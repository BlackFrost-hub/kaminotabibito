/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 取最大生命, 取冷却键, 冷却就绪, 进入冷却, 开始通用护盾, 第二章后段Boss战利品装备名 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

function on神风护体披风伤害修正(this: void, context: any): number {
  const target = context.target;
  let result = context.currentDamage;
  if (!(result > 0) || !单位持有第二章后段Boss战利品(target, 第二章后段Boss战利品装备名.神风护体披风)) return result;
  if (result < 取最大生命(target) * 0.14) return result;
  const key = 取冷却键(target, "神风护体披风");
  if (!冷却就绪(key)) return result;
  进入冷却(key, 16);
  开始通用护盾(target, target, 900, 5, "神风护体披风");
  return result * 0.72;
}

registerDamageModifier(on神风护体披风伤害修正, 26);

export {};
