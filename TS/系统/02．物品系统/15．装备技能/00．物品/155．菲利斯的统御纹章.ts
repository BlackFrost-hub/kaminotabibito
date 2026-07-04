/** @noSelfInFile */

import { 临时玩家属性, 取冷却键, 冷却就绪, 进入冷却, 取范围友方, 单位持有第二章后段Boss战利品, 是技能伤害, 第二章后段Boss战利品装备名, 装备小特效, 播放单位特效 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on菲利斯的统御纹章伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.菲利斯的统御纹章)) return;
  const key = 取冷却键(attacker, "菲利斯的统御纹章");
  if (!冷却就绪(key)) return;
  进入冷却(key, 12);
  const allies = 取范围友方(attacker, 650);
  for (let i = 0; i < allies.length; i++) {
    临时玩家属性(allies[i], "魔法伤害", 0.08, 6);
    播放单位特效(装备小特效.护盾闪光, allies[i], "origin", 0.8);
  }
}

registerAppliedFinalDamageListener(on菲利斯的统御纹章伤害);

export {};
