/** @noSelfInFile */
/**
 * 嘲讽 + 反伤系统
 *
 * 类似Dota斧王的嘲讽：施加嘲讽时立刻发 attack 命令，后续通过指令事件拦截维持。
 * 通过中心计时器管理持续时间，到期自动解除。
 * 可选反伤：被嘲讽单位普攻嘲讽来源时，按配置倍率反弹伤害。
 */

const jass = require("jass.common") as any;
const { String2OrderIdBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  String2OrderIdBJ: (this: void, orderIdString: string) => number;
};

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number) => void) => void;
};
const {
  calcReducedControlDuration,
  isExcludedFromControlResist,
} = require("系统.05．Buff系统.01．控制抗性.index") as {
  calcReducedControlDuration: (this: void, target: any, originalDuration: number) => number;
  isExcludedFromControlResist: (this: void, unit: any) => boolean;
};
const buffPool = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (
    this: void,
    target: any,
    buffID: string,
    durationSec: number,
    effectValue: number,
    extras?: { sourceName?: string }
  ) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};
const {
  registerTargetOrderListener,
  registerPointOrderListener,
  registerImmediateOrderListener,
} = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void) => void;
  registerPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
  registerImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
};

const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const 伤害函数 = require("lib.扩展函数.封装函数.06．伤害函数.index") as {
  isNormalAttack: (this: void) => boolean;
};
const isNormalAttack = 伤害函数.isNormalAttack as (this: void) => boolean;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const IssueTargetOrder = jass.IssueTargetOrder as (u: any, orderStr: string, target: any) => boolean;
const GetUnitCurrentOrder = jass.GetUnitCurrentOrder as (u: any) => number;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (
  whichUnit: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any
) => boolean;

const 模块名 = "嘲讽系统";
const 嘲讽BuffID = "C020";
const registerManualBuff = buffPool.registerManualBuff;
const 移除单位指定Buff = buffPool.移除单位指定Buff;

export interface 嘲讽参数 {
  持续时间: number;
  反伤倍率?: number;
}

interface 嘲讽记录 {
  来源单位ID: number;
  反伤倍率: number;
  延迟回调ID: number;
  来源单位引用: any;
  目标单位引用: any;
}

const 嘲讽映射表: Record<number, 嘲讽记录 | undefined> = {};
let 已初始化 = false;
let 正在发布覆盖命令 = false;
const 待执行反伤队列: Array<{ 攻击者: any; 伤害: number }> = [];
let 反伤结算已排队 = false;
let 自动续攻回调ID = 0;
let 攻击命令ID = 0;

function 取单位ID(u: any): number {
  if (u == null || u === 0) return 0;
  return GetHandleId(u) || 0;
}

function 内部清除嘲讽(目标ID: number): void {
  const 记录 = 嘲讽映射表[目标ID];
  if (记录 == null) return;
  if (记录.延迟回调ID !== 0) {
    removeDelayedCallback(记录.延迟回调ID);
  }
  if (记录.目标单位引用 != null && 记录.目标单位引用 !== 0) {
    移除单位指定Buff(记录.目标单位引用, 嘲讽BuffID);
  }
  delete 嘲讽映射表[目标ID];
  debugLogForce(模块名, "嘲讽到期 目标ID=", 目标ID);
}

function 自动续攻Tick(this: void): void {
  if (正在发布覆盖命令) return;
  if (攻击命令ID === 0) 攻击命令ID = String2OrderIdBJ("attack");
  for (const key in 嘲讽映射表) {
    const 记录 = 嘲讽映射表[key];
    if (记录 == null) continue;
    const 目标单位 = 记录.目标单位引用;
    const 来源单位 = 记录.来源单位引用;
    if (目标单位 == null || 目标单位 === 0) continue;
    if (来源单位 == null || 来源单位 === 0) continue;
    if (IsUnitType(目标单位, jass.UNIT_TYPE_DEAD)) continue;
    if (IsUnitType(来源单位, jass.UNIT_TYPE_DEAD)) continue;
    const 当前命令 = GetUnitCurrentOrder(目标单位) || 0;
    if (当前命令 === 攻击命令ID) continue;
    正在发布覆盖命令 = true;
    IssueTargetOrder(目标单位, "attack", 来源单位);
    正在发布覆盖命令 = false;
  }
}

// --- 指令拦截：只覆盖非attack，或attack到错误目标 ---

function on目标指令(this: void, unit: any, orderId: number, targetUnit: any, _targetItem: any, _targetDestructable: any): void {
  if (正在发布覆盖命令) return;
  if (攻击命令ID === 0) 攻击命令ID = String2OrderIdBJ("attack");
  const 单位ID = 取单位ID(unit);
  const 记录 = 嘲讽映射表[单位ID];
  if (记录 == null) return;
  const 来源 = 记录.来源单位引用;
  if (来源 == null || 来源 === 0) return;
  if (orderId === 攻击命令ID && 取单位ID(targetUnit) === 记录.来源单位ID) return;
  正在发布覆盖命令 = true;
  IssueTargetOrder(unit, "attack", 来源);
  正在发布覆盖命令 = false;
}

function on点指令(this: void, unit: any, orderId: number, _x: number, _y: number): void {
  if (正在发布覆盖命令) return;
  if (攻击命令ID === 0) 攻击命令ID = String2OrderIdBJ("attack");
  if (orderId === 攻击命令ID) return;
  const 单位ID = 取单位ID(unit);
  const 记录 = 嘲讽映射表[单位ID];
  if (记录 == null) return;
  const 来源 = 记录.来源单位引用;
  if (来源 == null || 来源 === 0) return;
  正在发布覆盖命令 = true;
  IssueTargetOrder(unit, "attack", 来源);
  正在发布覆盖命令 = false;
}

function on立即指令(this: void, unit: any, orderId: number): void {
  if (正在发布覆盖命令) return;
  if (攻击命令ID === 0) 攻击命令ID = String2OrderIdBJ("attack");
  if (orderId === 攻击命令ID) return;
  const 单位ID = 取单位ID(unit);
  const 记录 = 嘲讽映射表[单位ID];
  if (记录 == null) return;
  const 来源 = 记录.来源单位引用;
  if (来源 == null || 来源 === 0) return;
  正在发布覆盖命令 = true;
  IssueTargetOrder(unit, "attack", 来源);
  正在发布覆盖命令 = false;
}

// --- 反伤 ---

function flush反伤队列(this: void): void {
  反伤结算已排队 = false;
  while (待执行反伤队列.length > 0) {
    const 记录 = 待执行反伤队列.shift();
    if (记录 == null) continue;
    const 攻击者 = 记录.攻击者;
    const 伤害 = 记录.伤害;
    if (攻击者 == null || 攻击者 === 0) continue;
    if (伤害 <= 0) continue;
    UnitDamageTarget(攻击者, 攻击者, 伤害, false, false, jass.ATTACK_TYPE_CHAOS, jass.DAMAGE_TYPE_UNIVERSAL, null);
  }
}

function schedule反伤(this: void, attacker: any, damage: number): void {
  if (attacker == null || attacker === 0) return;
  if (damage <= 0) return;
  待执行反伤队列.push({ 攻击者: attacker, 伤害: damage });
  if (反伤结算已排队) return;
  反伤结算已排队 = true;
  addDelayedCallback(0, flush反伤队列);
}

function on反伤最终伤害(this: void, target: any, attacker: any, applied: number): void {
  if (applied <= 0) return;
  if (attacker == null || attacker === 0) return;
  if (isNormalAttack() !== true) return;
  const 攻击者ID = 取单位ID(attacker);
  const 记录 = 嘲讽映射表[攻击者ID];
  if (记录 == null) return;
  if (记录.反伤倍率 <= 0) return;
  if (target == null || target === 0) return;
  if (取单位ID(target) !== 记录.来源单位ID) return;

  const 反伤伤害 = applied * 记录.反伤倍率;
  debugLogForce(模块名, "反伤 被嘲讽者=", 攻击者ID, "伤害=", 反伤伤害);
  schedule反伤(attacker, 反伤伤害);
}

// --- 初始化 ---

function 确保初始化(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  registerTargetOrderListener(on目标指令);
  registerPointOrderListener(on点指令);
  registerImmediateOrderListener(on立即指令);
  registerAppliedFinalDamageListener(on反伤最终伤害);
  自动续攻回调ID = addPeriodicCallback(250, 自动续攻Tick);
}

// --- 对外API ---

export function 施加嘲讽(来源单位或Self: any, 目标单位或来源单位: any, 参数或目标单位: 嘲讽参数 | any, 兼容参数?: 嘲讽参数): number {
  let 来源单位 = 来源单位或Self;
  let 目标单位 = 目标单位或来源单位;
  let 参数 = 参数或目标单位 as 嘲讽参数;
  if (兼容参数 != null) {
    来源单位 = 目标单位或来源单位;
    目标单位 = 参数或目标单位;
    参数 = 兼容参数;
  }
  if (来源单位 == null || 来源单位 === 0) return 0;
  if (目标单位 == null || 目标单位 === 0) return 0;
  if (参数.持续时间 == null || 参数.持续时间 <= 0) return 0;

  确保初始化();

  let 实际持续时间 = 参数.持续时间;
  if (!isExcludedFromControlResist(目标单位)) {
    实际持续时间 = calcReducedControlDuration(目标单位, 参数.持续时间);
  }
  if (实际持续时间 <= 0) return 0;

  const 目标ID = 取单位ID(目标单位);
  if (目标ID === 0) return 0;

  if (嘲讽映射表[目标ID] != null) {
    内部清除嘲讽(目标ID);
  }

  const 延迟回调ID = addDelayedCallback(实际持续时间 * 1000, () => {
    内部清除嘲讽(目标ID);
  });

  嘲讽映射表[目标ID] = {
    来源单位ID: 取单位ID(来源单位),
    反伤倍率: 参数.反伤倍率 ?? 0,
    延迟回调ID,
    来源单位引用: 来源单位,
    目标单位引用: 目标单位,
  };
  registerManualBuff(目标单位, 嘲讽BuffID, 实际持续时间, 0, {
    sourceName: GetUnitName(来源单位),
  });

  // 立刻发一次攻击命令，后续由指令事件拦截维持
  正在发布覆盖命令 = true;
  const 命令结果 = IssueTargetOrder(目标单位, "attack", 来源单位);
  debugLogForce(模块名, "施加嘲讽 首发attack结果=", 命令结果);
  正在发布覆盖命令 = false;

  debugLogForce(模块名, "施加嘲讽 来源=", 取单位ID(来源单位), "目标=", 目标ID, "持续=", 实际持续时间, "秒 反伤倍率=", 参数.反伤倍率 ?? 0);
  return 目标ID;
}

export function AOE施加嘲讽(来源单位或Self: any, 中心X或来源单位: number | any, 中心Y或中心X: number, 半径或中心Y: number, 参数或半径: 嘲讽参数 | number, 兼容参数?: 嘲讽参数): number[] {
  let 来源单位 = 来源单位或Self;
  let 中心X = 中心X或来源单位 as number;
  let 中心Y = 中心Y或中心X;
  let 半径 = 半径或中心Y;
  let 参数 = 参数或半径 as 嘲讽参数;
  if (兼容参数 != null) {
    来源单位 = 中心X或来源单位;
    中心X = 中心Y或中心X;
    中心Y = 半径或中心Y;
    半径 = 参数或半径 as number;
    参数 = 兼容参数;
  }
  if (来源单位 == null || 来源单位 === 0) return [];

  const 目标列表 = getEnemyUnitsInRange(来源单位, 中心X, 中心Y, 半径);

  const 结果: number[] = [];
  for (let i = 0; i < 目标列表.length; i++) {
    const 目标 = 目标列表[i];
    if (目标 == null || 目标 === 0) continue;
    const id = 施加嘲讽(来源单位, 目标, 参数);
    if (id !== 0) 结果.push(id);
  }

  debugLogForce(模块名, "AOE施加嘲讽 范围=", 半径, "命中=", 结果.length, "个单位");
  return 结果;
}

export function 移除嘲讽(目标单位或Self: any, 兼容目标单位?: any): boolean {
  const 目标单位 = 兼容目标单位 ?? 目标单位或Self;
  const 目标ID = 取单位ID(目标单位);
  if (目标ID === 0) return false;
  if (嘲讽映射表[目标ID] == null) return false;

  内部清除嘲讽(目标ID);
  return true;
}

export function 单位是否被嘲讽(目标单位或Self: any, 兼容目标单位?: any): boolean {
  const 目标单位 = 兼容目标单位 ?? 目标单位或Self;
  const 目标ID = 取单位ID(目标单位);
  if (目标ID === 0) return false;
  return 嘲讽映射表[目标ID] != null;
}

export function 获取嘲讽来源单位(目标单位或Self: any, 兼容目标单位?: any): any {
  const 目标单位 = 兼容目标单位 ?? 目标单位或Self;
  const 目标ID = 取单位ID(目标单位);
  if (目标ID === 0) return null;
  const 记录 = 嘲讽映射表[目标ID];
  if (记录 == null) return null;
  return 记录.来源单位引用;
}

export {};
