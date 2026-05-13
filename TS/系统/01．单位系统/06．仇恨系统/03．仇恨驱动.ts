/** @noSelfInFile */
/**
 * 03．仇恨驱动
 *
 * 核心驱动，每0.25秒执行一次：
 * 1. 遍历所有有仇恨表的敌人
 * 2. 死亡清理
 * 3. 选择应攻击目标（filter 排除死亡/超距）
 * 4. 目标变更时更新缓存；同目标也每 tick 补发 attack 命令维持攻击
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
  获取当前目标ID,
  设置当前目标,
  清除所有当前目标,
} = require("系统.01．单位系统.06．仇恨系统.02．目标选择") as {
  获取应攻击目标: (this: void, 敌人: any, filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean) => { targetHid: number; targetRef: any; threat: number } | null;
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

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (u: any, orderStr: string, target: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;

const MAX_DISTANCE_SQ = 2500 * 2500;
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
  debugLogForce(模块名, "清理敌人仇恨状态 敌人ID=", 敌人ID);
  清除仇恨显示ById(敌人ID);
  clearAllThreatById(敌人ID);
}

/** 过滤回调：单位死亡或超距时排除 */
function 构建过滤函数(this: void, ex: number, ey: number): (entry: { targetHid: number; targetRef: any; threat: number }) => boolean {
  return (entry): boolean => {
    const ref = entry.targetRef;
    if (ref == null || ref === 0) return false;
    if (IsUnitType(ref, UNIT_TYPE_DEAD)) return false;
    const tx = GetUnitX(ref);
    const ty = GetUnitY(ref);
    const dx = tx - ex;
    const dy = ty - ey;
    return dx * dx + dy * dy <= MAX_DISTANCE_SQ;
  };
}

/** 驱动 Tick：通过敌人引用表拿到敌人单位，再驱动攻击 */
function onTick(): void {
  const 敌人ID列表 = getAllTrackedEnemyIds();

  for (let i = 0; i < 敌人ID列表.length; i++) {
    const 敌人ID = 敌人ID列表[i];
    const 敌人 = getEnemyRef(敌人ID);
    if (敌人 == null || 敌人 === 0) {
      debugLogForce(模块名, "驱动清理：敌人引用丢失 敌人ID=", 敌人ID);
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    if (IsUnitType(敌人, UNIT_TYPE_DEAD)) {
      debugLogForce(模块名, "驱动清理：敌人已死亡 敌人ID=", 敌人ID);
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    清理敌人过期仇恨条目ById(敌人ID);
    if (!hasThreatTable(敌人ID)) {
      debugLogForce(模块名, "驱动清理：过期条目清完后已无仇恨表 敌人ID=", 敌人ID);
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
    const filter = 构建过滤函数(ex, ey);
    const best = 获取应攻击目标(敌人, filter);

    if (best == null) {
      debugLogForce(模块名, "驱动清理：未找到有效目标 敌人ID=", 敌人ID);
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    const 当前目标ID = 获取当前目标ID(敌人);
    if (best.targetRef == null || best.targetRef === 0) {
      清理敌人仇恨状态(敌人ID);
      continue;
    }

    更新仇恨显示(敌人, best.targetRef, best.threat);

    if (当前目标ID !== best.targetHid) {
      // 目标变更：发命令 + 更新缓存
      debugLogForce(模块名, "切换目标 敌人ID=", 敌人ID, "新目标=", best.targetHid, "仇恨=", best.threat);
      IssueTargetOrder(敌人, "attack", best.targetRef);
      设置当前目标(敌人ID, best.targetHid);
    } else {
      // 目标没变，但每 tick 发一次命令维持攻击（引擎会过滤重复指令）
      IssueTargetOrder(敌人, "attack", best.targetRef);
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
    debugLogForce(模块名, "单体驱动清理：过期条目清完后已无仇恨表 敌人ID=", 敌人ID);
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
  const filter = 构建过滤函数(ex, ey);
  const best = 获取应攻击目标(敌人, filter);

  if (best == null) {
    debugLogForce(模块名, "单体驱动清理：未找到有效目标 敌人ID=", 敌人ID);
    清理敌人仇恨状态(敌人ID);
    return;
  }

  const 当前目标ID = 获取当前目标ID(敌人);
  if (best.targetRef == null || best.targetRef === 0) {
    清理敌人仇恨状态(敌人ID);
    return;
  }

  更新仇恨显示(敌人, best.targetRef, best.threat);

  if (当前目标ID !== best.targetHid) {
    debugLogForce(模块名, "切换目标 敌人ID=", 敌人ID, "新目标=", best.targetHid, "仇恨=", best.threat);
    IssueTargetOrder(敌人, "attack", best.targetRef);
    设置当前目标(敌人ID, best.targetHid);
  } else {
    // 目标没变也补发，和 onTick 保持一致
    IssueTargetOrder(敌人, "attack", best.targetRef);
  }
}

/** 初始化仇恨系统：注册 0.25 秒周期回调 */
export function 初始化仇恨系统(): void {
  if (周期回调ID !== 0) return;

  const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
    addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  };

  周期回调ID = addPeriodicCallback(250, onTick);
  debugLogForce(模块名, "初始化仇恨系统 周期ID=", 周期回调ID);
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
  debugLogForce(模块名, "停用仇恨系统");
}

export {};
