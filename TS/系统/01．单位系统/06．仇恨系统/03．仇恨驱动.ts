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
  getEnemyThreats,
  getEnemyLastThreatUpdateTimeById,
  清理敌人过期仇恨条目ById,
  仇恨整表超时毫秒,
} = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  getAllTrackedEnemyIds: (this: void) => number[];
  clearAllThreatById: (this: void, 敌人ID: number) => void;
  hasThreatTable: (this: void, 敌人ID: number) => boolean;
  getEnemyRef: (this: void, 敌人ID: number) => any | null;
  getEnemyThreats: (this: void, 敌人: any) => { targetHid: number; targetRef: any; threat: number }[];
  getEnemyLastThreatUpdateTimeById: (this: void, 敌人ID: number) => number;
  清理敌人过期仇恨条目ById: (this: void, 敌人ID: number) => void;
  仇恨整表超时毫秒: number;
};

const {
  获取最高仇恨攻击目标,
  获取强制攻击目标,
  获取当前目标ID,
  设置当前目标,
  清除所有当前目标,
} = require("系统.01．单位系统.06．仇恨系统.02．目标选择") as {
  获取最高仇恨攻击目标: (this: void, 敌人: any, filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean) => { targetHid: number; targetRef: any; threat: number } | null;
  获取强制攻击目标: (this: void, 敌人: any, filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean) => { targetHid: number; targetRef: any; threat: number } | null;
  获取当前目标ID: (this: void, 敌人: any) => number;
  设置当前目标: (this: void, 敌人ID: number, 目标ID: number) => void;
  清除所有当前目标: (this: void) => void;
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
const { registerPlayerUnitEventForPlayerIds } = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
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
const GetAttacker = jass.GetAttacker as () => any;
const GetTriggerUnit = jass.GetTriggerUnit as () => any;
const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerAddAction = jass.TriggerAddAction as (trig: any, action: () => void) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const EVENT_PLAYER_UNIT_ATTACKED = jass.EVENT_PLAYER_UNIT_ATTACKED;

const MAX_DISTANCE_SQ = 2500 * 2500;
const ISSUE_ORDER_DISTANCE_SQ = 1000 * 1000;
const 普通攻击目标保底毫秒 = 1500;
const 强制目标补发命令间隔Ms = 750;
const 强制目标上次补发命令Ms: Record<number, number | undefined> = {};
const 普通攻击目标承诺截止Ms: Record<number, number | undefined> = {};
const 施法期间跳过攻击命令: Record<number, true | undefined> = {};
const 仇恨攻击事件玩家ID = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;
let 周期回调ID = 0;
let 攻击纠偏事件已注册 = false;
const 模块名 = "仇恨系统";
let _nowMs: (() => number) | null = null;
let _是否护卫单位: ((this: void, unit: any) => boolean) | null = null;

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
  delete 普通攻击目标承诺截止Ms[敌人ID];
  delete 施法期间跳过攻击命令[敌人ID];
  clearAllThreatById(敌人ID);
}

function 是否由护卫系统托管(this: void, unit: any): boolean {
  if (_是否护卫单位 == null) {
    _是否护卫单位 = require("系统.01．单位系统.10．护卫系统.00．护卫核心").是否护卫单位 as (this: void, unit: any) => boolean;
  }
  return _是否护卫单位(unit);
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

function 获取保底攻击目标(
  this: void,
  敌人: any,
  filter: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean
): { targetHid: number; targetRef: any; threat: number } | null {
  const 强制目标 = 获取强制攻击目标(敌人, filter);
  if (强制目标 != null) return 强制目标;

  const 敌人ID = 取单位ID(敌人);
  const 当前目标ID = 获取当前目标ID(敌人);
  const 承诺截止时间 = 普通攻击目标承诺截止Ms[敌人ID] ?? 0;
  if (当前目标ID !== 0 && nowMs() < 承诺截止时间) {
    const 列表 = getEnemyThreats(敌人);
    for (let i = 0; i < 列表.length; i++) {
      const entry = 列表[i];
      if (entry.targetHid === 当前目标ID && filter(entry)) return entry;
    }
  }

  delete 普通攻击目标承诺截止Ms[敌人ID];
  return 获取最高仇恨攻击目标(敌人, filter);
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

function 下发攻击命令(this: void, 敌人: any, 敌人ID: number, 目标: { targetHid: number; targetRef: any; threat: number }): boolean {
  if (单位是否正在原生施法(敌人)) {
    施法期间跳过攻击命令[敌人ID] = true;
    return false;
  }

  delete 施法期间跳过攻击命令[敌人ID];
  if (!IssueTargetOrder(敌人, "attack", 目标.targetRef)) return false;
  设置当前目标(敌人ID, 目标.targetHid);
  普通攻击目标承诺截止Ms[敌人ID] = nowMs() + 普通攻击目标保底毫秒;
  强制目标上次补发命令Ms[敌人ID] = nowMs();
  return true;
}

function on单位开始攻击(this: void): void {
  const 敌人 = GetAttacker();
  if (敌人 == null || 敌人 === 0 || 是否由护卫系统托管(敌人)) return;

  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0 || !hasThreatTable(敌人ID) || IsUnitType(敌人, UNIT_TYPE_DEAD)) return;

  const 实际攻击目标 = GetTriggerUnit();
  const ex = GetUnitX(敌人);
  const ey = GetUnitY(敌人);
  const issueOrderFilter = 构建过滤函数(ex, ey, ISSUE_ORDER_DISTANCE_SQ);
  const 最高仇恨目标 = 获取保底攻击目标(敌人, issueOrderFilter);
  if (最高仇恨目标 == null || 最高仇恨目标.targetRef == null || 最高仇恨目标.targetRef === 0) return;
  if (取单位ID(实际攻击目标) === 最高仇恨目标.targetHid) {
    设置当前目标(敌人ID, 最高仇恨目标.targetHid);
    return;
  }

  下发攻击命令(敌人, 敌人ID, 最高仇恨目标);
}

function 注册攻击纠偏事件(this: void): void {
  if (攻击纠偏事件已注册) return;
  攻击纠偏事件已注册 = true;
  const trig = CreateTrigger();
  registerPlayerUnitEventForPlayerIds(trig, 仇恨攻击事件玩家ID, EVENT_PLAYER_UNIT_ATTACKED);
  TriggerAddAction(trig, on单位开始攻击);
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
    const best = 获取最高仇恨攻击目标(敌人, filter);
    const issueOrderBest = 获取保底攻击目标(敌人, issueOrderFilter);

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

    if (是否由护卫系统托管(敌人)) continue;

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
  const best = 获取最高仇恨攻击目标(敌人, filter);
  const issueOrderBest = 获取保底攻击目标(敌人, issueOrderFilter);

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

  if (是否由护卫系统托管(敌人)) return;

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

  注册攻击纠偏事件();

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
