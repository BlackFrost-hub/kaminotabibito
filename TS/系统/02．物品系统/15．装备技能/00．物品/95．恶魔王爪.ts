/** @noSelfInFile */

import {
  单位有效存活,
  攻击者类型满足,
  取当前生命,
  取最大生命,
} from "../08．攻击效果/00．公共/01．攻击效果工具";
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";
import { 施加或刷新周期目标效果 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/06．周期目标效果模板";
import { 造成装备伤害 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/10．装备战斗执行";

const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (
    this: void,
    sourceUnit: any,
    u: any,
    as: number,
    ms: number,
    time: number,
    effectSourceName?: string,
    effectSourceType?: "装备" | "技能"
  ) => void;
};

const jass = require("jass.common") as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;

const 装备名 = "|cff993300恶魔王爪|r";
const 恶魔伤害提高 = 0.15;
const 撕裂持续毫秒 = 3000;
const 撕裂间隔毫秒 = 1000;
const 已损失生命真实伤害比例 = 0.02;
const 减速比例 = 0.15;
const 减速持续秒 = 3;

function 计算已损失生命真实伤害(this: void, target: any): number {
  const maxLife = 取最大生命(target);
  const currentLife = 取当前生命(target);
  if (!(maxLife > currentLife)) return 0;
  return (maxLife - currentLife) * 已损失生命真实伤害比例;
}

function 造成恶魔王爪真实伤害(this: void, source: any, target: any): void {
  if (!单位有效存活(source) || !单位有效存活(target)) return;
  const amount = 计算已损失生命真实伤害(target);
  if (!(amount > 0)) return;
  造成装备伤害(source, target, amount, DAMAGE_TYPE_MIND, false, undefined, { 伤害形态: "单体" });
}

function 施加或刷新撕裂(this: void, source: any, target: any): void {
  施加或刷新周期目标效果({
    key前缀: "恶魔王爪撕裂",
    来源单位: source,
    目标单位: target,
    持续毫秒: 撕裂持续毫秒,
    间隔毫秒: 撕裂间隔毫秒,
    on周期: function on恶魔王爪撕裂周期(this: void, 上下文): void {
      造成恶魔王爪真实伤害(上下文.来源单位, 上下文.目标单位);
    },
  });
}

注册最终伤害触发模板({
  名称: "恶魔王爪",
  装备名,
  持有者: "攻击者",
  伤害过滤: "任意",
  自定义过滤: function 恶魔王爪触发过滤(this: void, event): boolean {
    const snapshot = event.伤害快照;
    if (snapshot == null || snapshot.isPhysicalDamage !== true || snapshot.isTrueDamage === true) return false;
    return 攻击者类型满足(event.攻击者, "近战");
  },
  on触发: function on恶魔王爪最终伤害(this: void, event): void {
    SFB_setSlow(event.攻击者, event.目标, 0, 减速比例, 减速持续秒, "恶魔王爪", "装备");
    施加或刷新撕裂(event.攻击者, event.目标);
  },
});

export {};
