/** @noSelfInFile */

import { 单位有效存活, 取当前生命, 取最大生命, 播放单位特效 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { 开始护盾, 护盾类型, 查询单位标签护盾值, 充能单位标签护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: { 通用: number };
  查询单位标签护盾值: (this: void, unit: any, tag: string) => number;
  充能单位标签护盾: (this: void, unit: any, tag: string, amount: number, maxValue: number, params?: any) => number;
};
const { 注册最终伤害触发模板 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.03．最终伤害触发模板") as {
  注册最终伤害触发模板: (this: void, 配置: any) => any;
};

const 灵猫庇护冷却秒数 = 30;
const 灵猫庇护触发生命比例 = 0.35;
const 灵猫庇护基础护盾值 = 500;
const 灵猫庇护最大生命护盾系数 = 0.2;
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

function 米亚的项圈低血过滤(this: void, event: any): boolean {
  const target = event.目标;
  if (!单位有效存活(target)) return false;
  const maxLife = 取最大生命(target);
  return maxLife > 0 && 取当前生命(target) <= maxLife * 灵猫庇护触发生命比例;
}

function on米亚的项圈最终伤害(this: void, event: any): void {
  const target = event.目标;
  const maxLife = 取最大生命(target);
  施加灵猫庇护护盾(target, 灵猫庇护基础护盾值 + maxLife * 灵猫庇护最大生命护盾系数, 灵猫庇护持续秒数);
  播放单位特效(target, 灵猫庇护特效, "origin", 1);
}

注册最终伤害触发模板({
  名称: "米亚的项圈",
  装备名: "米亚的项圈",
  持有者: "受击者",
  要求双方存活: false,
  冷却秒数: 灵猫庇护冷却秒数,
  冷却标签: "米亚的项圈:灵猫庇护",
  冷却前缀: "米亚战利品",
  自定义过滤: 米亚的项圈低血过滤,
  on触发: on米亚的项圈最终伤害,
});

export {};
