/** @noSelfInFile */

import { 单位有效存活, 取最大生命, 执行物品治疗 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 单位持有装备, 取装备冷却键, 装备冷却中, 进入装备冷却 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
  取装备冷却键: (this: void, unit: any, tag: string, 前缀?: string) => string;
  装备冷却中: (this: void, key: string) => boolean;
  进入装备冷却: (this: void, key: string, 秒数: number) => void;
};

const 净水回响冷却秒数 = 18;
const 净水回响恢复比例 = 0.05;
const 净水回响特效 = "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl";

function on纯净水源吊坠最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (!单位有效存活(target)) return;
  if (!单位持有装备(target, "纯净水源吊坠")) return;
  const key = 取装备冷却键(target, "纯净水源吊坠:净水回响", "米亚战利品");
  if (装备冷却中(key)) return;
  进入装备冷却(key, 净水回响冷却秒数);
  执行物品治疗(target, target, 取最大生命(target) * 净水回响恢复比例, 净水回响特效, 0, undefined, true);
}

registerAppliedFinalDamageListener(on纯净水源吊坠最终伤害);

export {};
