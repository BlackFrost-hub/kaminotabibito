/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 取单位ID, 取范围敌人, 造成装备伤害, 播放点特效, 取单位X, 取单位Y, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const 风蚀层数表: Record<number, number | undefined> = {};

function on克林姆德风纹法杖伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.克林姆德风纹法杖)) return;
  const id = 取单位ID(target);
  if (id === 0) return;
  const next = (风蚀层数表[id] ?? 0) + 1;
  if (next < 3) {
    风蚀层数表[id] = next;
    return;
  }
  风蚀层数表[id] = 0;
  播放点特效(装备小特效.小风爆, 取单位X(target), 取单位Y(target), 0.9);
  const enemies = 取范围敌人(attacker, target, 260);
  for (let i = 0; i < enemies.length; i++) {
    造成装备伤害(attacker, enemies[i], 420, 装备伤害类型.风);
  }
}

registerAppliedFinalDamageListener(on克林姆德风纹法杖伤害);

export {};
