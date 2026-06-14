/** @noSelfInFile */

import { 单位持有米亚战利品, 米亚战利品装备名, 米亚装备冷却中, 设置米亚装备冷却, 取米亚装备冷却键 } from "./137．米亚战利品公共";
import { 单位有效存活, 造成伤害事件伤害, 伤害事件伤害类型, 播放单位特效 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const 腐化核心冷却秒数 = 2;
const 腐化核心附加伤害 = 180;
const 腐化核心特效 = "Abilities\\Spells\\Other\\AcidBomb\\BottleImpact.mdl";

function 是技能伤害快照(this: void, snapshot: any): boolean {
  return snapshot != null && (snapshot.isSkillAttack === true || snapshot.isSkillDamage === true);
}

function on腐化核心法杖最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (!是技能伤害快照(snapshot)) return;
  if (!单位有效存活(attacker) || !单位有效存活(target)) return;
  if (!单位持有米亚战利品(attacker, 米亚战利品装备名.腐化核心法杖)) return;
  const key = 取米亚装备冷却键(attacker, "腐化核心法杖:腐化核心");
  if (米亚装备冷却中(key)) return;
  设置米亚装备冷却(key, 腐化核心冷却秒数);
  播放单位特效(target, 腐化核心特效, "origin", 1);
  造成伤害事件伤害(attacker, target, 腐化核心附加伤害, 伤害事件伤害类型.毒素);
}

registerAppliedFinalDamageListener(on腐化核心法杖最终伤害);

export {};

