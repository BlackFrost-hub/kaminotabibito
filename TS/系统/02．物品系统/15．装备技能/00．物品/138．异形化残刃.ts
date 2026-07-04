/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 取单位ID, 扣除当前生命比例, 播放单位特效, 第二章后段Boss战利品装备名 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

const 异形化能量表: Record<number, number | undefined> = {};

function on异形化残刃伤害修正(this: void, context: any): number {
  let result = context.currentDamage;
  const attacker = context.attacker;
  if (!(result > 0) || !是技能伤害(context)) return result;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.异形化残刃)) return result;
  const id = 取单位ID(attacker);
  if (id === 0) return result;
  const next = (异形化能量表[id] ?? 0) + 1;
  if (next < 5) {
    异形化能量表[id] = next;
    return result;
  }
  异形化能量表[id] = 0;
  扣除当前生命比例(attacker, 0.05);
  播放单位特效("Common\\Effect\\Element\\Dark\\ShadowHitBurst.mdx", context.target, "origin", 0.8);
  return result * 1.3;
}

registerDamageModifier(on异形化残刃伤害修正, 29);

export {};
