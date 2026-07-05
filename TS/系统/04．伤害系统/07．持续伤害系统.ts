/** @noSelfInFile */

const jass = require("jass.common") as any;
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any
) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

export const 持续伤害属性名 = "持续伤害";

export function 读取持续伤害加成(this: void, source: any): number {
  if (source == null || source === 0) return 0;
  const owner = jass.GetOwningPlayer(source);
  if (owner == null) return 0;
  const value = Number(YDUserDataGetSafe("player", owner, 持续伤害属性名, "real")) || 0;
  return value > -0.95 ? value : -0.95;
}

export function 计算持续伤害最终值(this: void, source: any, amount: number): number {
  if (!(amount > 0)) return 0;
  const finalAmount = amount * (1 + 读取持续伤害加成(source));
  return finalAmount > 0 ? finalAmount : 0;
}

export function 造成持续伤害(
  this: void,
  source: any,
  target: any,
  amount: number,
  damageType: any,
  ranged: boolean = false,
  attackType: any = ATTACK_TYPE_NORMAL,
  weaponType: any = WEAPON_TYPE_WHOKNOWS
): boolean {
  const finalAmount = 计算持续伤害最终值(source, amount);
  if (!(finalAmount > 0)) return false;
  return UnitDamageTarget(source, target, finalAmount, false, ranged, attackType, damageType, weaponType);
}

export {};
