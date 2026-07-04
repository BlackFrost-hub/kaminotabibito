/** @noSelfInFile */

import { 单位持有第二章后段Boss战利品, 是技能伤害, 取冷却键, 冷却就绪, 进入冷却, 造成装备伤害, 播放点特效, 取单位X, 取单位Y, 第二章后段Boss战利品装备名, 装备伤害类型, 装备小特效 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, 来源单位: any, 目标单位: any, 类型: string, 参数: { 持续时间: number }) => number;
};

function on湮灭之风戒指伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !是技能伤害(snapshot)) return;
  if (!单位持有第二章后段Boss战利品(attacker, 第二章后段Boss战利品装备名.湮灭之风戒指)) return;
  const key = 取冷却键(attacker, "湮灭之风戒指");
  if (!冷却就绪(key)) return;
  进入冷却(key, 12);
  播放点特效(装备小特效.小风爆, 取单位X(target), 取单位Y(target), 0.8);
  造成装备伤害(attacker, target, 300, 装备伤害类型.风);
  施加扩展控制(attacker, target, "silence", { 持续时间: 1.2 });
}

registerAppliedFinalDamageListener(on湮灭之风戒指伤害);

export {};
