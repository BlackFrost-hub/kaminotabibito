/** @noSelfInFile */

import { 单位有效存活, 造成伤害事件伤害, 伤害事件伤害类型 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 单位持有装备, 取装备冷却键, 装备冷却中, 进入装备冷却 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
  取装备冷却键: (this: void, unit: any, tag: string, 前缀?: string) => string;
  装备冷却中: (this: void, key: string) => boolean;
  进入装备冷却: (this: void, key: string, 秒数: number) => void;
};

const 怨火核心碎片冷却秒数 = 2;
const 怨火核心碎片附加伤害 = 260;

function 是技能伤害快照(this: void, snapshot: any): boolean {
  return snapshot != null && (snapshot.isSkillAttack === true || snapshot.isSkillDamage === true);
}

function on怨火核心碎片最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (!是技能伤害快照(snapshot)) return;
  if (!单位有效存活(attacker) || !单位有效存活(target)) return;
  if (!单位持有装备(attacker, "怨火核心碎片")) return;
  const key = 取装备冷却键(attacker, "怨火核心碎片:怨火灼痕", "第三章主线Boss战利品");
  if (装备冷却中(key)) return;
  进入装备冷却(key, 怨火核心碎片冷却秒数);
  造成伤害事件伤害(attacker, target, 怨火核心碎片附加伤害, 伤害事件伤害类型.暗影突袭);
}

registerAppliedFinalDamageListener(on怨火核心碎片最终伤害);

export {};
