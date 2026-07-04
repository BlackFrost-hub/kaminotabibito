/** @noSelfInFile */

import { 临时受到治疗率, 开始通用护盾, 取范围友方, 取冷却键, 冷却就绪, 进入冷却, 取最大生命, 取当前生命, 单位持有第二章后段Boss战利品, 是技能伤害, 第二章后段Boss战利品装备名 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

function on攻城号令圣印伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.攻城号令圣印)) return;
  const key = 取冷却键(attacker, "攻城号令圣印");
  if (!冷却就绪(key)) return;
  进入冷却(key, 14);
  const allies = 取范围友方(attacker, 650);
  for (let i = 0; i < allies.length; i++) {
    const unit = allies[i];
    临时受到治疗率(unit, 0.12, 6);
    if (取当前生命(unit) < 取最大生命(unit) * 0.5) 开始通用护盾(attacker, unit, 650, 5, "攻城号令圣印");
  }
}

registerAppliedFinalDamageListener(on攻城号令圣印伤害);

export {};
