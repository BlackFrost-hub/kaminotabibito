/** @noSelfInFile */

import { 单位持有米亚战利品, 米亚战利品装备名, 米亚装备冷却中, 设置米亚装备冷却, 取米亚装备冷却键, 施加米亚项圈护盾 } from "./137．米亚战利品公共";
import { 单位有效存活, 取当前生命, 取最大生命, 播放单位特效 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const 灵猫庇护冷却秒数 = 30;
const 灵猫庇护触发生命比例 = 0.35;
const 灵猫庇护护盾值 = 1200;
const 灵猫庇护持续秒数 = 5;
const 灵猫庇护特效 = "Abilities\\Spells\\NightElf\\Rejuvenation\\RejuvenationTarget.mdl";

function on米亚的项圈最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (!单位有效存活(target)) return;
  if (!单位持有米亚战利品(target, 米亚战利品装备名.米亚的项圈)) return;
  const maxLife = 取最大生命(target);
  if (!(maxLife > 0)) return;
  if (取当前生命(target) > maxLife * 灵猫庇护触发生命比例) return;
  const key = 取米亚装备冷却键(target, "米亚的项圈:灵猫庇护");
  if (米亚装备冷却中(key)) return;
  设置米亚装备冷却(key, 灵猫庇护冷却秒数);
  施加米亚项圈护盾(target, 灵猫庇护护盾值, 灵猫庇护持续秒数);
  播放单位特效(target, 灵猫庇护特效, "origin", 1);
}

registerAppliedFinalDamageListener(on米亚的项圈最终伤害);

export {};

