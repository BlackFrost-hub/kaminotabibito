/** @noSelfInFile */

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 执行命中判定 } = require("系统.04．伤害系统.04．命中系统.01．命中核心") as {
  执行命中判定: (this: void, attacker: any, target: any, currentDamage: number) => {
    结束链路: boolean;
    伤害: number;
    命中概率: number;
  };
};
const { 执行闪避判定 } = require("系统.04．伤害系统.05．闪避系统.01．闪避核心") as {
  执行闪避判定: (this: void, context: any) => {
    结束链路: boolean;
    伤害: number;
    闪避概率: number;
  };
};
const { 执行暴击判定 } = require("系统.04．伤害系统.06．暴击系统.01．暴击核心") as {
  执行暴击判定: (this: void, context: any) => {
    伤害: number;
    暴击概率: number;
    暴击倍率: number;
    是否暴击: boolean;
  };
};

const 命中闪避暴击修正器优先级 = 100;
let 已注册命中闪避暴击修正器 = false;

/**
 * 命中/闪避/暴击共用同一个伤害修正器，顺序固定：
 * 1. 命中失败：本次伤害直接归零，并且不再进入闪避/暴击。
 * 2. 闪避成功：按闪避系统结果结算，并且不再进入暴击。
 * 3. 暴击成功：只改写当前伤害数值，业务效果走暴击系统的最终伤害桥接。
 */
function 命中闪避暴击伤害修正(this: void, context: any): number {
  if (context == null) return 0;
  if (context.currentDamage < 1.10) return context.currentDamage;

  const 命中结果 = 执行命中判定(context.attacker, context.target, context.currentDamage);
  if (命中结果.结束链路) return 命中结果.伤害;

  const 闪避结果 = 执行闪避判定({
    attacker: context.attacker,
    target: context.target,
    currentDamage: 命中结果.伤害,
    isPhysicalDamage: context.isPhysicalDamage === true,
    isNormalAttack: context.isNormalAttack === true,
  });
  if (闪避结果.结束链路) return 闪避结果.伤害;

  const 暴击结果 = 执行暴击判定({
    attacker: context.attacker,
    target: context.target,
    currentDamage: 闪避结果.伤害,
    isPhysicalDamage: context.isPhysicalDamage === true,
    isEnhancedDamage: context.isEnhancedDamage === true,
    isNormalAttack: context.isNormalAttack === true,
    isRangedAttack: context.isRangedAttack === true,
    isSkillAttack: context.isSkillAttack === true,
  });
  return 暴击结果.伤害;
}

export function init命中闪避暴击系统(this: void): void {
  if (已注册命中闪避暴击修正器) return;
  已注册命中闪避暴击修正器 = true;
  registerDamageModifier(命中闪避暴击伤害修正, 命中闪避暴击修正器优先级);
}

init命中闪避暴击系统();

export * from "./00．命中配置";
export * from "./01．命中核心";
export {};
