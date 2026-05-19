/** @noSelfInFile */

const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, cb: (this: void, context: any) => number, priority?: number) => number;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 是否在前方 } = require("lib.扩展函数.Star扩展函数.Star扩展库.11．方位判断函数") as {
  是否在前方: (this: void, unit: any, target: any) => boolean;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
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
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const UNIT_TYPE_MELEE_ATTACKER = jass.UNIT_TYPE_MELEE_ATTACKER as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

const 格挡大盾物品ID = stringToFourCCSafe(resolveItemIdByName("格挡大盾"));
const 格挡大盾近战范围 = 200;
const 格挡大盾近战范围平方 = 格挡大盾近战范围 * 格挡大盾近战范围;
const 格挡大盾普通前方减伤 = 0.15;
const 格挡大盾近战前方减伤 = 0.30;
const 格挡大盾盾击护甲系数 = 1.40;
const 单位护甲状态 = ConvertUnitState(0x20);

let 已初始化格挡大盾 = false;

function 单位持有格挡大盾(this: void, unit: any): boolean {
  if (unit == null || unit === 0 || 格挡大盾物品ID === 0) return false;
  for (let i = 0; i < 6; i++) {
    const item = UnitItemInSlot(unit, i);
    if (item != null && item !== 0 && GetItemTypeId(item) === 格挡大盾物品ID) return true;
  }
  return false;
}

function 取单位距离平方(this: void, unitA: any, unitB: any): number {
  const dx = GetUnitX(unitA) - GetUnitX(unitB);
  const dy = GetUnitY(unitA) - GetUnitY(unitB);
  return dx * dx + dy * dy;
}

function 是否近战普攻(this: void, source: any, target: any, snapshot: any): boolean {
  if (source == null || source === 0 || target == null || target === 0) return false;
  if (snapshot == null || snapshot.isNormalAttack !== true) return false;
  if (IsUnitType(source, UNIT_TYPE_MELEE_ATTACKER) !== true) return false;
  return 取单位距离平方(source, target) <= 格挡大盾近战范围平方;
}

function 取单位护甲(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetUnitStateJapi(unit, 单位护甲状态);
}

function on格挡大盾伤害修正(this: void, context: any): number {
  if (!(context.currentDamage >= 1)) return context.currentDamage;
  if (context.isTrueDamage === true) return context.currentDamage;

  const target = context.target;
  const attacker = context.attacker;
  if (target == null || target === 0 || attacker == null || attacker === 0) return context.currentDamage;
  if (!单位持有格挡大盾(target)) return context.currentDamage;
  if (!是否在前方(target, attacker)) return context.currentDamage;

  const 减伤比例 = 是否近战普攻(attacker, target, context) ? 格挡大盾近战前方减伤 : 格挡大盾普通前方减伤;
  return context.currentDamage * (1 - 减伤比例);
}

function on格挡大盾盾击(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (target == null || target === 0 || attacker == null || attacker === 0) return;
  if (!(applied >= 1)) return;
  if (snapshot != null && snapshot.isTrueDamage === true) return;
  if (!单位持有格挡大盾(attacker)) return;
  if (!是否近战普攻(attacker, target, snapshot)) return;

  const 伤害值 = 取单位护甲(attacker) * 格挡大盾盾击护甲系数;
  if (!(伤害值 > 0)) return;
  UnitDamageTarget(attacker, target, 伤害值, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_METAL_HEAVY_BASH);
}

export function 初始化格挡大盾(this: void): void {
  if (已初始化格挡大盾 || 格挡大盾物品ID === 0) return;
  已初始化格挡大盾 = true;
  registerDamageModifier(on格挡大盾伤害修正, 35);
  registerAppliedFinalDamageListener(on格挡大盾盾击);
}

初始化格挡大盾();

export {};
