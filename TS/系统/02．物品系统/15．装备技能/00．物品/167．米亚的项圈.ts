/** @noSelfInFile */

import { 单位有效存活, 取当前生命, 取最大生命, 播放单位特效 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 开始护盾, 护盾类型, 查询单位标签护盾值, 充能单位标签护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: { 通用: number };
  查询单位标签护盾值: (this: void, unit: any, tag: string) => number;
  充能单位标签护盾: (this: void, unit: any, tag: string, amount: number, maxValue: number, params?: any) => number;
};
const { 单位持有装备, 取装备冷却键, 装备冷却中, 进入装备冷却 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．装备辅助") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
  取装备冷却键: (this: void, unit: any, tag: string, 前缀?: string) => string;
  装备冷却中: (this: void, key: string) => boolean;
  进入装备冷却: (this: void, key: string, 秒数: number) => void;
};

const 灵猫庇护冷却秒数 = 30;
const 灵猫庇护触发生命比例 = 0.35;
const 灵猫庇护护盾值 = 1200;
const 灵猫庇护持续秒数 = 5;
const 灵猫庇护特效 = "Abilities\\Spells\\NightElf\\Rejuvenation\\RejuvenationTarget.mdl";

function 施加灵猫庇护护盾(this: void, unit: any, 护盾值: number, 持续秒数: number): void {
  if (unit == null || unit === 0 || !(护盾值 > 0) || !(持续秒数 > 0)) return;
  const tag = "装备:米亚的项圈";
  const params = {
    类型: 护盾类型.通用,
    数值: 护盾值,
    持续时间: 持续秒数,
    来源单位: unit,
    标签: tag,
    显示护盾条: true,
    可驱散: false,
  };
  const current = 查询单位标签护盾值(unit, tag);
  if (current > 0) {
    充能单位标签护盾(unit, tag, 护盾值, 护盾值, params);
    return;
  }
  开始护盾(unit, params);
}

function on米亚的项圈最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (!单位有效存活(target)) return;
  if (!单位持有装备(target, "米亚的项圈")) return;
  const maxLife = 取最大生命(target);
  if (!(maxLife > 0)) return;
  if (取当前生命(target) > maxLife * 灵猫庇护触发生命比例) return;
  const key = 取装备冷却键(target, "米亚的项圈:灵猫庇护", "米亚战利品");
  if (装备冷却中(key)) return;
  进入装备冷却(key, 灵猫庇护冷却秒数);
  施加灵猫庇护护盾(target, 灵猫庇护护盾值, 灵猫庇护持续秒数);
  播放单位特效(target, 灵猫庇护特效, "origin", 1);
}

registerAppliedFinalDamageListener(on米亚的项圈最终伤害);

export {};
