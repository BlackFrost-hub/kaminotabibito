/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 取当前生命, 取最大生命, 取冷却键, 冷却就绪, 进入冷却, 恢复生命魔法, 短暂无敌, 播放单位特效, 第二章后段Boss战利品装备名, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

function on灵心之碎片伤害修正(this: void, context: any): number {
  const target = context.target;
  let result = context.currentDamage;
  if (!(result > 0) || !单位持有第二章后段Boss战利品(target, 第二章后段Boss战利品装备名.灵心之碎片)) return result;
  const life = 取当前生命(target);
  if (life - result > 1) return result;
  const key = 取冷却键(target, "灵心之碎片");
  if (!冷却就绪(key)) return result;
  进入冷却(key, 120);
  短暂无敌(target, 1);
  恢复生命魔法(target, target, 取最大生命(target) * 0.1);
  播放单位特效(装备小特效.护盾闪光, target, "origin", 1);
  return life > 1 ? life - 1 : 0;
}

registerDamageModifier(on灵心之碎片伤害修正, 5);

export {};
