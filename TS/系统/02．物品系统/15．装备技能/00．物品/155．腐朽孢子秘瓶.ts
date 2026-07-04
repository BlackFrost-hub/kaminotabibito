/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 概率通过, 取冷却键, 冷却就绪, 进入冷却, 取范围敌人, 造成装备伤害, 第二章后段Boss战利品装备名, 装备伤害类型 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on腐朽孢子秘瓶伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.腐朽孢子秘瓶)) return;
  if (!概率通过(attacker, 0.12)) return;
  const key = 取冷却键(attacker, "腐朽孢子秘瓶");
  if (!冷却就绪(key)) return;
  进入冷却(key, 4);
  const enemies = 取范围敌人(attacker, target, 300);
  for (let i = 0; i < enemies.length; i++) {
    造成装备伤害(attacker, enemies[i], 220, 装备伤害类型.暗影);
  }
}

registerAppliedFinalDamageListener(on腐朽孢子秘瓶伤害);

export {};
