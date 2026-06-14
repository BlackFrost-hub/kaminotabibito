/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { registerCritRateModifier, registerCritAppliedFinalDamageListener } = require("系统.04．伤害系统.06．暴击系统.01．暴击核心") as {
  registerCritRateModifier: (this: void, callback: (this: void, context: any) => number) => void;
  registerCritAppliedFinalDamageListener: (this: void, callback: (this: void, record: any, applied: number, snapshot: any) => void) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { YDWEGetUnitArmor } = require("lib.扩展函数.YDWE函数.06．护甲获取") as {
  YDWEGetUnitArmor: (this: void, unit: any) => number;
};
const { calcArmorReduction } = require("lib.扩展函数.封装函数.06．伤害函数.04．护甲计算") as {
  calcArmorReduction: (this: void, armor: number) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (value: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, value: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any,
) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 攻击力状态 = ConvertUnitState(0x15);
const 四位ID缓存: Record<string, number | undefined> = {};

export type 单位暴击率修正处理器 = (this: void, context: any) => number | undefined;
export type 单位暴击后处理器 = (this: void, record: any, applied: number, snapshot: any) => void;

export function 转四位ID(this: void, rawIdText: string): number {
  const cached = 四位ID缓存[rawIdText];
  if (cached != null) return cached;
  const value = stringToFourCCSafe(rawIdText);
  四位ID缓存[rawIdText] = value;
  return value;
}

export function 单位是指定类型(this: void, unit: any, typeId: number): boolean {
  if (unit == null || unit === 0 || typeId === 0) return false;
  return GetUnitTypeId(unit) === typeId;
}

export function 单位拥有原生Buff(this: void, unit: any, buffId: number): boolean {
  if (unit == null || unit === 0 || buffId === 0) return false;
  return GetUnitAbilityLevel(unit, buffId) > 0;
}

export function 读取单位累计实数(this: void, unit: any, key: string): number {
  if (unit == null || unit === 0 || key === "") return 0;
  return Number(YDUserDataGetSafe("unit", unit, key, "real")) || 0;
}

export function 写入单位累计实数(this: void, unit: any, key: string, value: number): void {
  if (unit == null || unit === 0 || key === "") return;
  YDUserDataSetSafe("unit", unit, key, "real", value);
}

export function 读取单位攻击力(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return Number(GetUnitStateJapi(unit, 攻击力状态)) || 0;
}

export function 读取单位护甲(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return Number(YDWEGetUnitArmor(unit)) || 0;
}

export function 计算无视护甲补正伤害(this: void, 已结算伤害: number, 护甲值: number): number {
  if (!(已结算伤害 > 0) || !(护甲值 > 0)) return 0;
  const 减伤比例 = calcArmorReduction(护甲值);
  if (!(减伤比例 > 0) || 减伤比例 >= 0.9999) return 0;
  const 无视护甲伤害 = 已结算伤害 / (1 - 减伤比例);
  const 补正值 = 无视护甲伤害 - 已结算伤害;
  return 补正值 > 0 ? 补正值 : 0;
}

export function 对单位造成强化伤害(this: void, source: any, target: any, amount: number): void {
  if (source == null || source === 0 || target == null || target === 0 || !(amount > 0)) return;
  UnitDamageTarget(source, target, amount, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS);
}

export function 对单位造成暗影伤害(this: void, source: any, target: any, amount: number): void {
  if (source == null || source === 0 || target == null || target === 0 || !(amount > 0)) return;
  UnitDamageTarget(source, target, amount, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS);
}

export function 获取范围敌军(this: void, source: any, x: number, y: number, radius: number): any[] {
  if (source == null || source === 0 || !(radius > 0)) return [];
  return getEnemyUnitsInRange(source, x, y, radius);
}

export function 在坐标播放特效(this: void, model: string, x: number, y: number, z: number, size: number, lifeSec: number): void {
  if (model === "") return;
  EC_CreateEffect(model, x, y, z, 270, size, 1, lifeSec);
}

export function 取单位X(this: void, unit: any): number {
  return unit != null && unit !== 0 ? GetUnitX(unit) : 0;
}

export function 取单位Y(this: void, unit: any): number {
  return unit != null && unit !== 0 ? GetUnitY(unit) : 0;
}

export function 播放动作(this: void, unit: any, animationIndex: number, timeScale: number): void {
  if (unit == null || unit === 0) return;
  SetUnitTimeScale(unit, timeScale);
  SetUnitAnimationByIndex(unit, animationIndex);
}

export function 恢复时间流速(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  SetUnitTimeScale(unit, 1);
}

export function 注册指定单位暴击率修正(this: void, unitTypeId: number, handler: 单位暴击率修正处理器): void {
  function 暴击率修正包装(this: void, context: any): number {
    const source = context?.暴击归属单位 ?? context?.attacker;
    if (!单位是指定类型(source, unitTypeId)) return context.暴击率;
    const nextRate = handler(context);
    return typeof nextRate === "number" ? nextRate : context.暴击率;
  }

  registerCritRateModifier(暴击率修正包装);
}

export function 注册指定单位暴击后监听(this: void, unitTypeId: number, handler: 单位暴击后处理器): void {
  function 暴击后监听包装(this: void, record: any, applied: number, snapshot: any): void {
    const source = record?.暴击归属单位 ?? record?.attacker;
    if (!单位是指定类型(source, unitTypeId)) return;
    handler(record, applied, snapshot);
  }

  registerCritAppliedFinalDamageListener(暴击后监听包装);
}

export function init暴击被动公共工具(this: void): void {
}
