/** @noSelfInFile */
/**
 * 03．仇恨驱动
 *
 * 核心驱动，每0.25秒执行一次：
 * 1. 遍历所有有仇恨表的敌人
 * 2. 死亡清理
 * 3. 选择应攻击目标（filter 排除死亡/超距）
 * 4. 目标变更时更新缓存并下发一次 attack 命令；同目标不重复抢命令
 *
 * 目标引用直接从仇恨表的 targetRef 获取，无需额外注册。
 */

const jass = require("jass.common") as any;

const {
  getAllTrackedEnemyIds,
  clearAllThreatById,
  hasThreatTable,
  getEnemyRef,
  getEnemyLastThreatUpdateTimeById,
  清理敌人过期仇恨条目ById,
  仇恨整表超时毫秒,
} = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  getAllTrackedEnemyIds: () => number[];
  clearAllThreatById: (this: void, 敌人ID: number) => void;
  hasThreatTable: (this: void, 敌人ID: number) => boolean;
  getEnemyRef: (this: void, 敌人ID: number) => any | null;
  getEnemyLastThreatUpdateTimeById: (this: void, 敌人ID: number) => number;
  清理敌人过期仇恨条目ById: (this: void, 敌人ID: number) => void;
  仇恨整表超时毫秒: number;
};

const {
  获取应攻击目标,
  获取强制攻击目标,
  获取当前目标ID,
  设置当前目标,
  清除所有当前目标,
} = require("系统.01．单位系统.06．仇恨系统.02．目标选择") as {
  获取应攻击目标: (this: void, 敌人: any, filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean) => { targetHid: number; targetRef: any; threat: number } | null;
  获取强制攻击目标: (this: void, 敌人: any, filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean) => { targetHid: number; targetRef: any; threat: number } | null;
  获取当前目标ID: (this: void, 敌人: any) => number;
  设置当前目标: (this: void, 敌人ID: number, 目标ID: number) => void;
  清除所有当前目标: () => void;
};

const {
  更新仇恨显示,
  清除仇恨显示ById,
  清除所有仇恨显示,
} = require("系统.01．单位系统.06．仇恨系统.04．仇恨显示") as {
  更新仇恨显示: (this: void, 敌人: any, 目标单位: any, 仇恨值: number) => void;
  清除仇恨显示ById: (this: void, 敌人ID: number) => void;
  清除所有仇恨显示: (this: void) => void;
};
const { 自动展开仇恨面板一次 } = require("系统.09．表现系统.05．仇恨面板.05．仇恨面板") as {
  自动展开仇恨面板一次: (this: void, playerId: number) => void;
};
const { 单位是否正在原生施法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态") as {
  单位是否正在原生施法: (this: void, 单位: any) => boolean;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (u: any, orderStr: string, target: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (u: any) => any;
const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;

const MAX_DISTANCE_SQ = 2500 * 2500;
const ISSUE_ORDER_DISTANCE_SQ = 1000 * 1000;
const 强制目标补发命令间隔Ms = 750;
const 强制目标上次补发命令Ms: Record<number, number | undefined> = {};
const 施法期间跳过攻击命令: Record<number, true | undefined> = {};
let 周期回调ID = 0;
const 模块名 = "仇恨系统";
let _nowMs: (() => number) | null = null;

function 取单位ID(u: any): number {
  if (u == null || u === 0) return 0;
  return GetHandleId(u) || 0;
}

function nowMs(): number {
  if (_nowMs == null) {
    _nowMs = require("系统.00．核心系统.05．中心计时器").getServerTime as () => number;
  }
  return _nowMs();
}

function 清理敌人仇恨状态(敌人ID: number): void {
  清除仇恨显示ById(敌人ID);
  delete 强制目标上次补发命令Ms[敌人ID];
  delete 施法期间跳过攻击命令[敌人ID];
  clearAllThreatById(敌人ID);
}

function 尝试自动展开目标玩家仇恨面板(this: void, target: any): void {
  if (target == null || target === 0) return;
  const owner = GetOwningPlayer(target);
  if (owner == null || owner === 0) return;
  const playerId = GetPlayerId(owner);
  自动展开仇恨面板一次(playerId);
}

/** 过滤回调：单位死亡或超距时排除 */
function 构建过滤函数(this: void, ex: number, ey: number, maxDistanceSq: number): (entry: { targetHid: number; targetRef: any; threat: number }) => boolean {
  return (entry): boolean => {
    const ref = entry.targetRef;
    if (ref == null || ref === 0) return false;
    if (IsUnitType(ref, UNIT_TYPE_DEAD)) return false;
    const tx = GetUnitX(ref);
    const ty = GetUnitY(ref);
    const dx = tx - ex;
    const dy = ty - ey;
    return dx * dx + dy * dy <= maxDistanceSq;
  };
}

function 需要下发攻击命令(
  this: void,
  敌人: any,
  敌人ID: number,
  当前目标ID: number,
  目标: { targetHid: number; targetRef: any; threat: number },
  filter: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean
): boolean {
  if (单位是否正在原生施法(敌人)) {
    施法期间跳过攻击命令[敌人ID] = true;
    return false;
  }

  if (施法期间跳过攻击命令[敌人ID] === true) {
    delete 施法期间跳过攻击命令[敌人ID];
    return true;
  }

  if (当前目标ID !== 目标.targetHid) return true;

  const 强制目标 = 获取强制攻击目标(敌人, filter);
  if (强制目标 == null || 强制目标.targetHid !== 目标.targetHid) return false;

  const 当前时间 = nowMs();
  const 上次补发时间 = 强制目标上次补发命令Ms[敌人ID] ?? 0;
  return 当前时间 - 上次补发时间 >= 强制目标补发命令间隔Ms;
}

function 下发攻击命令(this: void, 敌人: any, 敌人ID: number, 目标: { targetHid: number; targetRef: any; threat: number }): void {
  if (单位是否正在原生施法(敌人)) {
    施法期间跳过攻击命令[敌人ID] = true;
    return;
  }

  delete 施法期间跳过攻击命令[敌人ID];
  IssueTargetOrder(敌人, "attack", 目标.targetRef);
  设置当前目标(敌人ID, 目标.targetHid);
  强制目标上次补发命令Ms[敌人ID] = nowMs();
}

/** 驱动 Tick：通过敌人引用表拿到敌人单位，再驱动攻击 */
function onTick(): void {
  const 敌人ID列表 = getAllTrackedEnemyIds();

  for (let i = 0; i < 敌人ID列表.length; i++) {
    const 敌人ID = 敌人ID列表[i];
    const 敌人 = getEnemyRef(敌人ID);
    if (敌人 == null || 敌人 === 0) {
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    if (IsUnitType(敌人, UNIT_TYPE_DEAD)) {
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    清理敌人过期仇恨条目ById(敌人ID);
    if (!hasThreatTable(敌人ID)) {
      清除仇恨显示ById(敌人ID);
      continue;
    }

    const 最近受伤时间 = getEnemyLastThreatUpdateTimeById(敌人ID);
    if (最近受伤时间 > 0 && nowMs() - 最近受伤时间 >= 仇恨整表超时毫秒) {
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    const ex = GetUnitX(敌人);
    const ey = GetUnitY(敌人);
    const filter = 构建过滤函数(ex, ey, MAX_DISTANCE_SQ);
    const issueOrderFilter = 构建过滤函数(ex, ey, ISSUE_ORDER_DISTANCE_SQ);
    const best = 获取应攻击目标(敌人, filter);
    const issueOrderBest = 获取应攻击目标(敌人, issueOrderFilter);

    if (best == null) {
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    const 当前目标ID = 获取当前目标ID(敌人);
    if (best.targetRef == null || best.targetRef === 0) {
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    更新仇恨显示(敌人, best.targetRef, best.threat);
    尝试自动展开目标玩家仇恨面板(best.targetRef);

    if (issueOrderBest == null || issueOrderBest.targetRef == null || issueOrderBest.targetRef === 0) {
      continue;
    }

    if (需要下发攻击命令(敌人, 敌人ID, 当前目标ID, issueOrderBest, issueOrderFilter)) {
      // 仅对 1000 码内存在的仇恨目标下攻击命令，避免远目标无视野时反复抢命令
      下发攻击命令(敌人, 敌人ID, issueOrderBest);
    }
  }
}

/** 带敌人引用的外部驱动入口（由调用方在 tick 外调用，传入敌人单位引用） */
export function 驱动单个敌人(敌人: any): void {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return;
  if (!hasThreatTable(敌人ID)) return;
  if (IsUnitType(敌人, UNIT_TYPE_DEAD)) {
    清理敌人仇恨状态(敌人ID);
    return;
  }

  清理敌人过期仇恨条目ById(敌人ID);
  if (!hasThreatTable(敌人ID)) {
    清除仇恨显示ById(敌人ID);
    return;
  }

  const 最近受伤时间 = getEnemyLastThreatUpdateTimeById(敌人ID);
  if (最近受伤时间 > 0 && nowMs() - 最近受伤时间 >= 仇恨整表超时毫秒) {
    清理敌人仇恨状态(敌人ID);
    return;
  }

  const ex = GetUnitX(敌人);
  const ey = GetUnitY(敌人);
  const filter = 构建过滤函数(ex, ey, MAX_DISTANCE_SQ);
  const issueOrderFilter = 构建过滤函数(ex, ey, ISSUE_ORDER_DISTANCE_SQ);
  const best = 获取应攻击目标(敌人, filter);
  const issueOrderBest = 获取应攻击目标(敌人, issueOrderFilter);

  if (best == null) {
    清理敌人仇恨状态(敌人ID);
    return;
  }

  const 当前目标ID = 获取当前目标ID(敌人);
  if (best.targetRef == null || best.targetRef === 0) {
    清理敌人仇恨状态(敌人ID);
    return;
  }

  更新仇恨显示(敌人, best.targetRef, best.threat);
  尝试自动展开目标玩家仇恨面板(best.targetRef);

  if (issueOrderBest == null || issueOrderBest.targetRef == null || issueOrderBest.targetRef === 0) {
    return;
  }

  if (需要下发攻击命令(敌人, 敌人ID, 当前目标ID, issueOrderBest, issueOrderFilter)) {
    下发攻击命令(敌人, 敌人ID, issueOrderBest);
  }
}

/** 初始化仇恨系统：注册 0.25 秒周期回调 */
export function 初始化仇恨系统(): void {
  if (周期回调ID !== 0) return;

  const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
    addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  };

  周期回调ID = addPeriodicCallback(250, onTick);
}

/** 停用仇恨系统 */
export function 停用仇恨系统(): void {
  if (周期回调ID === 0) return;

  const { removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
    removePeriodicCallback: (this: void, id: number) => void;
  };

  removePeriodicCallback(周期回调ID);
  周期回调ID = 0;
  清除所有当前目标();
  清除所有仇恨显示();
}

export {};
