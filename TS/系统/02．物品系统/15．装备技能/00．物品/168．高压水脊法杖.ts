/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 是元素伤害, 取冷却键, 冷却就绪, 进入冷却, 造成装备伤害, 播放单位特效, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on高压水脊法杖伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!是元素伤害(snapshot, 装备伤害类型.水)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.高压水脊法杖)) return;
  const key = 取冷却键(attacker, "高压水脊法杖");
  if (!冷却就绪(key)) return;
  进入冷却(key, 10);
  播放单位特效(装备小特效.湿痕, target, "origin", 1);
  造成装备伤害(attacker, target, 450, 装备伤害类型.水);
}

registerAppliedFinalDamageListener(on高压水脊法杖伤害);

export {};
