/** @noSelfInFile */
/**
 * 02．目标选择
 *
 * 从仇恨表中选出应攻击目标（返回含 targetRef）。
 * 普通攻击可严格选择最高仇恨；Boss 主动施法保留高出当前目标至少 20% 才切换的粘性规则。
 *
 * 初始化时注册清除回调到 00．仇恨存储，实现 removeTarget/clearAllThreat 自动联动清理。
 */

const jass = require("jass.common") as any;

const {
  getHighestThreat,
  getThreatByHid,
  getEnemyThreats,
  注册当前目标清除回调,
} = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  getHighestThreat: (this: void, 敌人: any, filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean) => { targetHid: number; targetRef: any; threat: number } | null;
  getThreatByHid: (this: void, 敌人: any, 目标ID: number) => number;
  getEnemyThreats: (this: void, 敌人: any) => { targetHid: number; targetRef: any; threat: number }[];
  注册当前目标清除回调: (this: void, fn: (敌人ID: number, 目标ID: number) => void) => void;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;

const 当前目标表: Record<number, { targetHid: number } | undefined> = {};
const 强制目标表: Record<number, { targetHid: number; targetRef: any; enemyRef: any; expireMs: number } | undefined> = {};
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

function 数字升序排序(this: void, a: number, b: number): number {
  return a - b;
}

function 获取有序当前目标敌人ID列表(): number[] {
  const result: number[] = [];
  for (const key in 当前目标表) {
    const id = parseInt(key, 10);
    if (!isNaN(id)) {
      result.push(id);
    }
  }
  result.sort(数字升序排序);
  return result;
}

function 清除当前目标(敌人ID: number, 目标ID: number): void {
  if (敌人ID === 0) return;
  if (目标ID === 0) {
    // 全清：clearAllThreat / clearAllThreatById 触发
    delete 当前目标表[敌人ID];
    delete 强制目标表[敌人ID];
    return;
  }
  // 精确清除：removeTarget 触发，仅当被移除目标是当前目标
  const 记录 = 当前目标表[敌人ID];
  if (记录 != null && 记录.targetHid === 目标ID) {
    delete 当前目标表[敌人ID];
  }
  const 强制记录 = 强制目标表[敌人ID];
  if (强制记录 != null && 强制记录.targetHid === 目标ID) {
    delete 强制目标表[敌人ID];
  }
}

// 初始化联动：注册到 00．仇恨存储（仅当被移除目标是当前目标才清理）
注册当前目标清除回调(清除当前目标);

/** 获取当前缓存的攻击目标ID */
export function 获取当前目标ID(敌人: any): number {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return 0;
  const 记录 = 当前目标表[敌人ID];
  return 记录 == null ? 0 : 记录.targetHid;
}

export function 设置强制攻击目标(this: void, 敌人: any, 目标: any, 持续毫秒: number): void {
  const 敌人ID = 取单位ID(敌人);
  const 目标ID = 取单位ID(目标);
  if (敌人ID === 0 || 目标ID === 0 || 持续毫秒 <= 0) return;
  强制目标表[敌人ID] = {
    targetHid: 目标ID,
    targetRef: 目标,
    enemyRef: 敌人,
    expireMs: nowMs() + 持续毫秒,
  };
}

export function 获取强制攻击目标(
  this: void,
  敌人: any,
  filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean
): { targetHid: number; targetRef: any; threat: number } | null {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return null;
  const 记录 = 强制目标表[敌人ID];
  if (记录 == null) return null;
  if (nowMs() >= 记录.expireMs) {
    delete 强制目标表[敌人ID];
    return null;
  }
  const entry = { targetHid: 记录.targetHid, targetRef: 记录.targetRef, threat: 999999 };
  if (filter != null && !filter(entry)) return null;
  return entry;
}

export function 获取所有强制目标敌人ID(this: void): number[] {
  const result: number[] = [];
  const now = nowMs();
  for (const key in 强制目标表) {
    const id = parseInt(key, 10);
    if (isNaN(id)) continue;
    const 记录 = 强制目标表[id];
    if (记录 == null || now >= 记录.expireMs) {
      delete 强制目标表[id];
      continue;
    }
    result.push(id);
  }
  result.sort(数字升序排序);
  return result;
}

export function 获取强制目标敌人引用(this: void, 敌人ID: number): any | null {
  if (敌人ID === 0) return null;
  const 记录 = 强制目标表[敌人ID];
  if (记录 == null) return null;
  if (nowMs() >= 记录.expireMs) {
    delete 强制目标表[敌人ID];
    return null;
  }
  return 记录.enemyRef;
}

/**
 * 严格选择过滤范围内的最高仇恨攻击目标；明确的强制点名优先。
 */
export function 获取最高仇恨攻击目标(
  this: void,
  敌人: any,
  filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean
): { targetHid: number; targetRef: any; threat: number } | null {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return null;

  const 强制目标 = 获取强制攻击目标(敌人, filter);
  if (强制目标 != null) return 强制目标;
  return getHighestThreat(敌人, filter);
}

/**
 * Boss 主动施法目标：最高仇恨有效且比当前目标高至少 20% 时才切换。
 * @param filter 由驱动层传入，过滤死亡/超距目标（filter 接收 ThreatEntry，含 targetRef）
 */
export function 获取应攻击目标(
  this: void,
  敌人: any,
  filter?: (entry: { targetHid: number; targetRef: any; threat: number }) => boolean
): { targetHid: number; targetRef: any; threat: number } | null {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return null;

  const best = 获取最高仇恨攻击目标(敌人, filter);
  if (best == null) return null;

  const 当前记录 = 当前目标表[敌人ID];
  if (当前记录 != null && 当前记录.targetHid !== 0 && 当前记录.targetHid !== best.targetHid) {
    const 当前仇恨 = getThreatByHid(敌人, 当前记录.targetHid);
    if (当前仇恨 > 0 && best.threat < 当前仇恨 * 1.2) {
      const 列表 = getEnemyThreats(敌人);
      for (let i = 0; i < 列表.length; i++) {
        const entry = 列表[i];
        if (entry.targetHid === 当前记录.targetHid && (filter == null || filter(entry))) return entry;
      }
    }
  }

  return best;
}

/** 设置当前攻击目标缓存 */
export function 设置当前目标(敌人ID: number, 目标ID: number): void {
  if (敌人ID === 0) return;
  当前目标表[敌人ID] = { targetHid: 目标ID };
}

/** 清除所有当前目标缓存 */
export function 清除所有当前目标(): void {
  const 敌人ID列表 = 获取有序当前目标敌人ID列表();
  for (let i = 0; i < 敌人ID列表.length; i++) {
    delete 当前目标表[敌人ID列表[i]];
  }
  const 强制敌人ID列表 = 获取所有强制目标敌人ID();
  for (let i = 0; i < 强制敌人ID列表.length; i++) {
    delete 强制目标表[强制敌人ID列表[i]];
  }
}

export {};
