/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 取冷却键, 冷却就绪, 进入冷却, 取范围敌人, 造成装备伤害, 播放单位特效, 第二章后段Boss战利品装备名, 装备伤害类型 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on电鳗共生指环伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.电鳗共生指环)) return;
  const key = 取冷却键(attacker, "电鳗共生指环");
  if (!冷却就绪(key)) return;
  进入冷却(key, 8);
  const enemies = 取范围敌人(attacker, target, 420);
  let count = 0;
  for (let i = 0; i < enemies.length && count < 3; i++) {
    播放单位特效("Abilities\\Weapons\\Bolt\\BoltImpact.mdl", enemies[i], "origin", 0.6);
    造成装备伤害(attacker, enemies[i], 260, 装备伤害类型.闪电);
    count++;
  }
}

registerAppliedFinalDamageListener(on电鳗共生指环伤害);

export {};
