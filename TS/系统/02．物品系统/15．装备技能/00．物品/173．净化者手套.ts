/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 概率通过, 取冷却键, 冷却就绪, 进入冷却, 净化负面, 临时治疗率, 播放单位特效, 第二章后段Boss战利品装备名, 装备小特效 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on净化者手套伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.净化者手套)) return;
  if (!概率通过(attacker, 0.18)) return;
  const key = 取冷却键(attacker, "净化者手套");
  if (!冷却就绪(key)) return;
  进入冷却(key, 8);
  if (!净化负面(attacker)) return;
  临时治疗率(attacker, 0.18, 6);
  播放单位特效(装备小特效.护盾闪光, attacker, "origin", 0.8);
}

registerAppliedFinalDamageListener(on净化者手套伤害);

export {};
