/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 概率通过, 造成装备伤害, 恢复生命魔法, 播放点特效, 取单位X, 取单位Y, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on剑魂狼牙坠伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.剑魂狼牙坠)) return;
  if (!概率通过(attacker, 0.12)) return;
  播放点特效(装备小特效.小风爆, 取单位X(target), 取单位Y(target), 0.8);
  造成装备伤害(attacker, target, 360, 装备伤害类型.风);
  恢复生命魔法(attacker, attacker, 0, 60, true);
}

registerAppliedFinalDamageListener(on剑魂狼牙坠伤害);

export {};
