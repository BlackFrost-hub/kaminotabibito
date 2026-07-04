/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 概率通过, 取冷却键, 冷却就绪, 进入冷却, 造成装备伤害, 播放单位特效, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "./154．第二章后段Boss战利品公共";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, 来源单位: any, 目标单位: any, 类型: string, 参数: { 持续时间: number }) => number;
};

function 延迟根须伤害(this: void, source: any, target: any): void {
  造成装备伤害(source, target, 150, 装备伤害类型.自然);
}

function on腐败根须法杖伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.腐败根须法杖)) return;
  if (!概率通过(attacker, 0.15)) return;
  const key = 取冷却键(attacker, "腐败根须法杖");
  if (!冷却就绪(key)) return;
  进入冷却(key, 4);
  播放单位特效(装备小特效.根须, target, "origin", 2.5);
  施加扩展控制(attacker, target, "roots", { 持续时间: 1.5 });
  造成装备伤害(attacker, target, 180, 装备伤害类型.自然);
  addDelayedCallback(1000, function 腐败根须第二跳(this: void): void { 延迟根须伤害(attacker, target); });
  addDelayedCallback(2000, function 腐败根须第三跳(this: void): void { 延迟根须伤害(attacker, target); });
}

registerAppliedFinalDamageListener(on腐败根须法杖伤害);

export {};
