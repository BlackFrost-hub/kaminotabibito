/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 闪避概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  闪避概率通过: (this: void, 原始概率: number, 受击者: any) => boolean;
};
const { 读取正向命中率偏移 } = require("系统.04．伤害系统.04．命中系统.01．命中核心") as {
  读取正向命中率偏移: (this: void, unit: any) => number;
};
const { 闪避系统配置 } = require("系统.04．伤害系统.05．闪避系统.00．闪避配置") as {
  闪避系统配置: {
    生效最低伤害: number;
    最大生命伤害比例门槛: number;
    玩家闪避率上限: number;
    敌人闪避后承伤比例: number;
    闪避文本: string;
    漂浮文字: any;
  };
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

function 调用玩家英雄判定(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  const hero = YDUserDataGetSafe("player", owner, "英雄", "unit");
  if (hero == null || hero === 0) return false;
  return hero === unit || GetHandleId(hero) === GetHandleId(unit);
}

export interface 闪避判定上下文 {
  attacker: any;
  target: any;
  currentDamage: number;
  isPhysicalDamage: boolean;
  isNormalAttack: boolean;
}

export interface 闪避判定结果 {
  结束链路: boolean;
  伤害: number;
  闪避概率: number;
}

export interface 闪避成功记录 {
  attacker: any;
  target: any;
  闪避前伤害: number;
  闪避后伤害: number;
  闪避概率: number;
  isPhysicalDamage: boolean;
  isNormalAttack: boolean;
}

export type 闪避最终伤害监听 = (this: void, record: 闪避成功记录, applied: number, snapshot: any) => void;

const 闪避成功记录列表: 闪避成功记录[] = [];
const 闪避最终伤害监听列表: 闪避最终伤害监听[] = [];
let 已注册闪避最终伤害桥接 = false;

function 读取单位实数(this: void, unit: any, 属性名: string): number {
  if (unit == null || unit === 0) return 0;
  return Number(YDUserDataGetSafe("unit", unit, 属性名, "real")) || 0;
}

export function registerDodgeAppliedFinalDamageListener(this: void, callback: 闪避最终伤害监听): void {
  if (callback == null) return;
  确保闪避最终伤害桥接();
  for (let i = 0; i < 闪避最终伤害监听列表.length; i++) {
    if (闪避最终伤害监听列表[i] === callback) return;
  }
  闪避最终伤害监听列表.push(callback);
}

/**
 * 闪避本身发生在伤害修正器内，但装备业务效果必须等最终伤害写回后再触发。
 * 所以这里先记录一次成功闪避，再通过 registerAppliedFinalDamageListener 桥接给业务监听。
 */
function 通知闪避最终伤害监听(this: void, record: 闪避成功记录, applied: number, snapshot: any): void {
  for (let i = 0; i < 闪避最终伤害监听列表.length; i++) {
    const callback = 闪避最终伤害监听列表[i];
    if (callback == null) continue;
    callback(record, applied, snapshot);
  }
}

function 闪避最终伤害桥接(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (let i = 0; i < 闪避成功记录列表.length; i++) {
    const record = 闪避成功记录列表[i];
    if (record == null) continue;
    if (record.target !== target || record.attacker !== attacker) continue;
    闪避成功记录列表.splice(i, 1);
    通知闪避最终伤害监听(record, applied, snapshot);
    return;
  }
}

function 确保闪避最终伤害桥接(this: void): void {
  if (已注册闪避最终伤害桥接) return;
  已注册闪避最终伤害桥接 = true;
  registerAppliedFinalDamageListener(闪避最终伤害桥接);
}

function 记录闪避成功(this: void, record: 闪避成功记录): void {
  确保闪避最终伤害桥接();
  闪避成功记录列表.push(record);
}

function 读取玩家实数(this: void, player: any, 属性名: string): number {
  if (player == null || player === 0) return 0;
  return Number(YDUserDataGetSafe("player", player, 属性名, "real")) || 0;
}

function 读取单位布尔(this: void, unit: any, 属性名: string): boolean {
  if (unit == null || unit === 0) return false;
  const value = YDUserDataGetSafe("unit", unit, 属性名, "boolean");
  return value === true || value === 1;
}

function 读取单位字符串开关(this: void, unit: any, 属性名: string): boolean {
  if (unit == null || unit === 0) return false;
  const value = YDUserDataGetSafe("unit", unit, 属性名, "string");
  if (value == null) return false;
  if (value === true || value === 1) return true;
  const text = String(value).toLowerCase();
  return text === "true" || text === "1";
}

function 读取目标基础闪避率(this: void, target: any): number {
  const 单位闪避 = 读取单位实数(target, "闪避率");
  if (单位闪避 > 0.01) return 单位闪避;

  // 玩家闪避属性有全局上限；单位自身闪避不走这个玩家上限。
  let 玩家闪避 = 读取玩家实数(GetOwningPlayer(target), "闪避率");
  if (玩家闪避 <= 0.01) return 0;
  if (玩家闪避 > 闪避系统配置.玩家闪避率上限) 玩家闪避 = 闪避系统配置.玩家闪避率上限;
  return 玩家闪避;
}

export function 执行闪避判定(this: void, context: 闪避判定上下文): 闪避判定结果 {
  const attacker = context.attacker;
  const target = context.target;
  const currentDamage = context.currentDamage;
  if (attacker == null || attacker === 0 || target == null || target === 0) {
    return { 结束链路: false, 伤害: currentDamage, 闪避概率: 0 };
  }
  if (currentDamage < 闪避系统配置.生效最低伤害) {
    return { 结束链路: false, 伤害: currentDamage, 闪避概率: 0 };
  }

  const 最大生命 = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  if (最大生命 > 0 && currentDamage >= 最大生命 * 闪避系统配置.最大生命伤害比例门槛) {
    return { 结束链路: false, 伤害: currentDamage, 闪避概率: 0 };
  }

  if (context.isNormalAttack && context.isPhysicalDamage && 读取单位布尔(target, "普攻必中")) {
    return { 结束链路: false, 伤害: currentDamage, 闪避概率: 0 };
  }
  if (读取单位字符串开关(attacker, "无视闪避")) {
    return { 结束链路: false, 伤害: currentDamage, 闪避概率: 0 };
  }

  const 基础闪避率 = 读取目标基础闪避率(target);
  if (基础闪避率 <= 0.01) {
    return { 结束链路: false, 伤害: currentDamage, 闪避概率: 0 };
  }

  // 正向命中抵消目标闪避：30% 闪避 vs 20% 命中 => 最终 10% 闪避。
  let 有效闪避率 = 基础闪避率 - 读取正向命中率偏移(attacker);
  if (有效闪避率 <= 0) {
    return { 结束链路: false, 伤害: currentDamage, 闪避概率: 0 };
  }
  if (有效闪避率 > 1) 有效闪避率 = 1;

  if (!闪避概率通过(有效闪避率, target)) {
    return { 结束链路: false, 伤害: currentDamage, 闪避概率: 有效闪避率 };
  }

  // 玩家单位闪避成功为 0 伤害；非玩家单位保留配置中的闪避后承伤比例。
  let 闪避后伤害 = currentDamage * 闪避系统配置.敌人闪避后承伤比例;
  if (调用玩家英雄判定(target)) {
    闪避后伤害 = 0;
  }
  记录闪避成功({
    attacker,
    target,
    闪避前伤害: currentDamage,
    闪避后伤害,
    闪避概率: 有效闪避率,
    isPhysicalDamage: context.isPhysicalDamage === true,
    isNormalAttack: context.isNormalAttack === true,
  });
  return { 结束链路: true, 伤害: 闪避后伤害, 闪避概率: 有效闪避率 };
}

export {};
