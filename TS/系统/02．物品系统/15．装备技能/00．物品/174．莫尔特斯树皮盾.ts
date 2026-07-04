/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 取最大生命, 取冷却键, 冷却就绪, 进入冷却, 开始通用护盾, 临时玩家属性, 第二章后段Boss战利品装备名 } from "./154．第二章后段Boss战利品公共";

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

function on莫尔特斯树皮盾伤害修正(this: void, context: any): number {
  const target = context.target;
  let result = context.currentDamage;
  if (!(result > 0) || !单位持有第二章后段Boss战利品(target, 第二章后段Boss战利品装备名.莫尔特斯树皮盾)) return result;
  if (result < 取最大生命(target) * 0.13) return result;
  const key = 取冷却键(target, "莫尔特斯树皮盾");
  if (!冷却就绪(key)) return result;
  进入冷却(key, 18);
  开始通用护盾(target, target, 1100, 6, "莫尔特斯树皮盾");
  临时玩家属性(target, "木属性抗性", 0.12, 6);
  临时玩家属性(target, "暗属性抗性", 0.12, 6);
  return result * 0.82;
}

registerDamageModifier(on莫尔特斯树皮盾伤害修正, 27);

export {};
