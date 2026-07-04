/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是敌对单位, 概率通过, 取冷却键, 冷却就绪, 进入冷却, 净化负面, 临时受到治疗率, 播放单位特效, 第二章后段Boss战利品装备名, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerAppliedFinalHealListener } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerAppliedFinalHealListener: (this: void, cb: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => void) => void;
};

function on净土萌芽圣铃治疗(this: void, source: any, target: any, amount: number, isItemHeal: boolean): void {
  if (!(amount > 0) || source == null || source === 0 || target == null || target === 0) return;
  if (是敌对单位(source, target)) return;
  if (!单位持有第二章后段Boss战利品(source, 第二章后段Boss战利品装备名.净土萌芽圣铃)) return;
  if (!概率通过(source, 0.22)) return;
  const key = 取冷却键(source, "净土萌芽圣铃");
  if (!冷却就绪(key)) return;
  进入冷却(key, 6);
  if (净化负面(target)) {
    临时受到治疗率(target, 0.18, 5);
  } else {
    临时受到治疗率(target, 0.08, 4);
  }
  播放单位特效(装备小特效.护盾闪光, target, "origin", 0.8);
}

registerAppliedFinalHealListener(on净土萌芽圣铃治疗);

export {};
