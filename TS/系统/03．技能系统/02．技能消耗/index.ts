/** @noSelfInFile */
/**
 * 技能消耗系统 - 统一导出和初始化入口
 */

export * from "./00．消耗常量";
export * from "./01．魔法消耗返还";
export * from "./02．特殊单位消耗";
export * from "./03．QWERD魔法消耗显示";
export * from "./04．原生魔法消耗同步";

const jass = require("jass.common") as any;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, cb: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

const {
  计算最终魔法消耗: 计算最终魔法消耗Raw,
} = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  计算最终魔法消耗: (this: void, unit: any, abilityId: number, level: number) => number;
};
const {
  isEdwardUnit: isEdwardUnitRaw,
  handleEdwardPassiveCost: handleEdwardPassiveCostRaw,
} = require("系统.03．技能系统.02．技能消耗.02．特殊单位消耗") as {
  isEdwardUnit: (this: void, unit: any) => boolean;
  handleEdwardPassiveCost: (this: void, unit: any, manaCost: number) => void;
};
const {
  初始化原生魔法消耗同步,
} = require("系统.03．技能系统.02．技能消耗.04．原生魔法消耗同步") as {
  初始化原生魔法消耗同步: (this: void) => void;
};
const {
  初始化QWERD魔法消耗显示,
} = require("系统.03．技能系统.02．技能消耗.03．QWERD魔法消耗显示") as {
  初始化QWERD魔法消耗显示: (this: void) => void;
};

function 计算最终魔法消耗(this: void, unit: any, abilityId: number, level: number): number {
  return 计算最终魔法消耗Raw(unit, abilityId, level);
}

function isEdwardUnit(this: void, unit: any): boolean {
  return isEdwardUnitRaw(unit);
}

function handleEdwardPassiveCost(this: void, unit: any, manaCost: number): void {
  handleEdwardPassiveCostRaw(unit, manaCost);
}

function onSpellEffectForCost(this: void, castingUnit: any, spellAbilityId: number): void {
  if (isEdwardUnit(castingUnit)) {
    const level = GetUnitAbilityLevel(castingUnit, spellAbilityId);
    const manaCost = 计算最终魔法消耗(castingUnit, spellAbilityId, level);
    if (manaCost > 0) {
      handleEdwardPassiveCost(castingUnit, manaCost);
    }
  }
}

registerSpellEffectListener(onSpellEffectForCost);
初始化原生魔法消耗同步();
初始化QWERD魔法消耗显示();
