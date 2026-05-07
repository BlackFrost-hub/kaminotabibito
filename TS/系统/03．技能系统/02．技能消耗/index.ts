/**
 * 技能消耗系统 - 统一导出和初始化入口
 */

export * from "./00．消耗常量";
export * from "./01．魔法消耗返还";
export * from "./02．特殊单位消耗";

const jass = require("jass.common") as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, cb: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

const { handleManaRefund, calcTotalManaCost } = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  handleManaRefund: (unit: any, abilityId: number) => boolean;
  calcTotalManaCost: (unit: any, abilityId: number, level: number) => number;
};

const { isEdwardUnit, handleEdwardPassiveCost } = require("系统.03．技能系统.02．技能消耗.02．特殊单位消耗") as {
  isEdwardUnit: (unit: any) => boolean;
  handleEdwardPassiveCost: (unit: any, manaCost: number) => void;
};

function onSpellEffectForCost(this: void, castingUnit: any, spellAbilityId: number): void {
  handleManaRefund(castingUnit, spellAbilityId);

  if (isEdwardUnit(castingUnit)) {
    const level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
    const manaCost = calcTotalManaCost(castingUnit, spellAbilityId, level);
    if (manaCost > 0) {
      handleEdwardPassiveCost(castingUnit, manaCost);
    }
  }
}

registerSpellEffectListener(onSpellEffectForCost);
