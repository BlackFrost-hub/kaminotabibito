/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 取冷却键, 冷却就绪, 进入冷却, 开始通用护盾, 第二章后段Boss战利品装备名 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on墨潮行者长袍伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.墨潮行者长袍)) return;
  const key = 取冷却键(attacker, "墨潮行者长袍");
  if (!冷却就绪(key)) return;
  进入冷却(key, 12);
  开始通用护盾(attacker, attacker, 900, 5, "墨潮行者长袍");
}

registerAppliedFinalDamageListener(on墨潮行者长袍伤害);

export {};
