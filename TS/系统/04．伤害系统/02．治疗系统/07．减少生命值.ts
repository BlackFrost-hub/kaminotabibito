/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetUnitStateJass = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitStateJass = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { HEAL_SYSTEM_ENABLED } = require("系统.04．伤害系统.02．治疗系统.00．常量定义") as {
  HEAL_SYSTEM_ENABLED: boolean;
};
const { fireShowDamageEvent } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  fireShowDamageEvent: (this: void, target: any, amount: number, red?: number, green?: number, blue?: number) => void;
};

export function 减少生命值(
  this: void,
  target: any,
  amount: number,
  showText: boolean = true,
  showEffect: boolean = false,
  effectPath?: string,
  最低保留生命: number = 1,
): number {
  if (!HEAL_SYSTEM_ENABLED) return 0;
  if (target == null || target === 0) return 0;
  if (amount <= 0) return 0;
  if (IsUnitType(target, UNIT_TYPE_DEAD) === true) return 0;

  const currentLife = GetUnitStateJass(target, UNIT_STATE_LIFE);
  const safeMinLife = 最低保留生命 > 0 ? 最低保留生命 : 0;
  if (currentLife <= safeMinLife) return 0;

  const maxReduce = currentLife - safeMinLife;
  const actualReduce = amount < maxReduce ? amount : maxReduce;
  if (actualReduce <= 0) return 0;

  SetUnitStateJass(target, UNIT_STATE_LIFE, currentLife - actualReduce);

  if (showEffect && effectPath != null && effectPath !== "") {
    const effect = AddSpecialEffectTarget(effectPath, target, "origin");
    if (effect != null && effect !== 0) DestroyEffect(effect);
  }

  if (showText) {
    fireShowDamageEvent(target, actualReduce, 255, 0, 0);
  }

  return actualReduce;
}

export {};

