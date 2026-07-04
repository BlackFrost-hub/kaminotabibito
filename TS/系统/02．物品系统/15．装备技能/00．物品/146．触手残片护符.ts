/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 取最大生命, 取冷却键, 冷却就绪, 进入冷却, 恢复生命魔法, 临时玩家属性, 播放单位特效, 第二章后段Boss战利品装备名, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

function on触手残片护符伤害修正(this: void, context: any): number {
  const target = context.target;
  const result = context.currentDamage;
  if (!(result > 0) || !单位持有第二章后段Boss战利品(target, 第二章后段Boss战利品装备名.触手残片护符)) return result;
  if (result < 取最大生命(target) * 0.15) return result;
  const key = 取冷却键(target, "触手残片护符");
  if (!冷却就绪(key)) return result;
  进入冷却(key, 20);
  恢复生命魔法(target, target, 取最大生命(target) * 0.12);
  临时玩家属性(target, "水属性抗性", 0.15, 5);
  播放单位特效(装备小特效.护盾闪光, target, "origin", 0.8);
  return result;
}

registerDamageModifier(on触手残片护符伤害修正, 27);

export {};
