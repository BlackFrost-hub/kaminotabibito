/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文, 菲尼克斯尔元素类型 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  stringToFourCC,
  周期,
  延迟,
  单位存活,
  取菲尼克斯尔敌对目标列表,
  取最高元素,
  减少元素层数,
  显示场地读条,
  播放点特效,
  取单位X,
  取单位Y,
  取菲尼克斯尔技能强度倍率,
  创建菲尼克斯尔独立伤害上下文,
  设置单位动画,
  开始施法硬直,
  开始元素爆发硬直,
} from "./19．公共工具";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 创建条件伤害修正 } from "../../../../00．技能模板+函数/04．机制组件/08．机制触发/11．条件伤害修正";
import { 创建菲尼克斯尔燃烧区 } from "./06．炽羽散射";
const jass = require("jass.common") as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const { registerHealCallback } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerHealCallback: (this: void, callback: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => number) => void;
};
const { getBuffRuntime, registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

const 菲尼克斯尔单位类型ID = stringToFourCC(菲尼克斯尔单位技能配置.单位ID);
const 毒火枯竭BuffID = 菲尼克斯尔单位技能配置.BuffID.毒火枯竭;
const 暗火增幅BuffID = 菲尼克斯尔单位技能配置.BuffID.暗火增幅;
let 元素爆发附加效果已注册 = false;

function 毒火枯竭治疗修正(this: void, _source: any, target: any, amount: number, _isItemHeal: boolean): number {
  const runtime = getBuffRuntime(target, 毒火枯竭BuffID);
  if (runtime == null || !(runtime.effect > 0)) return amount;
  const modified = amount * (1 - runtime.effect);
  return modified;
}

function 暗火增幅技能伤害修正(this: void, context: any): number {
  if (context == null) return 0;
  if (context.attacker == null || context.target == null) return context.currentDamage;
  if (GetUnitTypeId(context.attacker) !== 菲尼克斯尔单位类型ID || context.isSkillDamage !== true) return context.currentDamage;
  const runtime = getBuffRuntime(context.target, 暗火增幅BuffID);
  if (runtime == null || !(runtime.effect > 0)) return context.currentDamage;
  const before = context.currentDamage;
  移除单位指定Buff(context.target, 暗火增幅BuffID);
  const modified = before * (1 + runtime.effect);
  return modified;
}

function 满足暗火增幅技能伤害条件(this: void, context: any): boolean {
  if (context == null || context.attacker == null || context.target == null) return false;
  if (GetUnitTypeId(context.attacker) !== 菲尼克斯尔单位类型ID || context.isSkillDamage !== true) return false;
  const runtime = getBuffRuntime(context.target, 暗火增幅BuffID);
  return runtime != null && Number(runtime.effect) > 0;
}

function 注册元素爆发附加效果(this: void): void {
  if (元素爆发附加效果已注册) return;
  元素爆发附加效果已注册 = true;
  registerHealCallback(毒火枯竭治疗修正);
  创建条件伤害修正({
    名称: "菲尼克斯尔暗火增幅技能伤害",
    优先级: 86,
    条件: 满足暗火增幅技能伤害条件,
    修正: 暗火增幅技能伤害修正,
  });
}

function 取元素特效(this: void, 元素: 菲尼克斯尔元素类型): string {
  if (元素 === "冰") return 菲尼克斯尔数值与表现配置.特效.元素爆发冰;
  if (元素 === "毒") return 菲尼克斯尔数值与表现配置.特效.元素爆发毒;
  if (元素 === "暗") return 菲尼克斯尔数值与表现配置.特效.元素爆发暗;
  return 菲尼克斯尔数值与表现配置.特效.元素爆发火;
}

function 取元素音效(this: void, 元素: 菲尼克斯尔元素类型): string {
  if (元素 === "冰") return 菲尼克斯尔音效配置.元素爆发.冰;
  if (元素 === "毒") return 菲尼克斯尔音效配置.元素爆发.毒;
  if (元素 === "暗") return 菲尼克斯尔音效配置.元素爆发.暗;
  return 菲尼克斯尔音效配置.元素爆发.火;
}

export function 结算菲尼克斯尔元素爆发(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  const config = 菲尼克斯尔数值与表现配置.元素爆发;
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔元素爆发", config.吟唱秒 + 2);
  开始施法硬直(context.Boss, config.吟唱秒);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.倍速);
  播放菲尼克斯尔台词(context.Boss, "元素爆发");
  显示场地读条(config.吟唱秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  延迟(config.吟唱秒 * 1000, function 菲尼克斯尔元素爆发结算(this: void): void {
    if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
    const heroes = 取菲尼克斯尔敌对目标列表(context.Boss);
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      const top = 取最高元素(hero);
      if (top.层数 <= 0) continue;
      const x = 取单位X(hero);
      const y = 取单位Y(hero);
      const 技能强度倍率 = 取菲尼克斯尔技能强度倍率(context.Boss);
      播放点特效(取元素特效(top.元素), x, y, 1800);
      播放Boss坐标音效(取元素音效(top.元素), x, y, 菲尼克斯尔音效配置.默认裁断距离);
      if (单位存活(context.Boss) && 单位存活(hero)) {
        if (top.元素 === "冰") {
          执行BossAOE技能伤害({
            技能实例ID: 伤害上下文?.技能实例ID,
            标签: 伤害上下文?.标签,
            来源: context.Boss,
            目标: hero,
            伤害公式: {
              来源攻击力比例: config.冰伤害Boss攻击力比例,
              目标最大生命比例: config.冰伤害目标最大生命比例,
              总倍率: 技能强度倍率,
            },
            ranged: true,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_COLD,
            weaponType: WEAPON_TYPE_WHOKNOWS,
          });
          开始元素爆发硬直(hero, config.冰硬直秒);
        } else if (top.元素 === "毒") {
          执行BossAOE技能伤害({
            技能实例ID: 伤害上下文?.技能实例ID,
            标签: 伤害上下文?.标签,
            来源: context.Boss,
            目标: hero,
            伤害公式: {
              目标已损生命比例: config.毒伤害目标已损失生命比例,
              总倍率: 技能强度倍率,
            },
            ranged: true,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_POISON,
            weaponType: WEAPON_TYPE_WHOKNOWS,
          });
          registerManualBuff(hero, 毒火枯竭BuffID, config.毒治疗降低持续秒, config.毒治疗降低比例, {
            stack: 1,
            sourceName: "菲尼克斯尔元素爆发",
          });
        } else if (top.元素 === "暗") {
          执行BossAOE技能伤害({
            技能实例ID: 伤害上下文?.技能实例ID,
            标签: 伤害上下文?.标签,
            来源: context.Boss,
            目标: hero,
            伤害公式: {
              来源攻击力比例: config.暗伤害Boss攻击力比例,
              目标最大生命比例: config.暗伤害目标最大生命比例,
              总倍率: 技能强度倍率,
            },
            ranged: true,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
            weaponType: WEAPON_TYPE_WHOKNOWS,
          });
          registerManualBuff(hero, 暗火增幅BuffID, config.暗下一次技能增伤持续秒, config.暗下一次技能增伤比例, {
            stack: 1,
            sourceName: "菲尼克斯尔元素爆发",
          });
        } else {
          执行BossAOE技能伤害({
            技能实例ID: 伤害上下文?.技能实例ID,
            标签: 伤害上下文?.标签,
            来源: context.Boss,
            目标: hero,
            伤害公式: {
              来源攻击力比例: config.火伤害Boss攻击力比例,
              目标最大生命比例: config.火伤害目标最大生命比例,
              总倍率: 技能强度倍率,
            },
            ranged: true,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_FIRE,
            weaponType: WEAPON_TYPE_WHOKNOWS,
          });
          创建菲尼克斯尔燃烧区(context, x, y, 伤害上下文);
        }
      }
      减少元素层数(hero, top.元素, config.结算后最高层降低);
    }
  });
}

export function 初始化菲尼克斯尔元素爆发节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.元素爆发已初始化) return;
  context.元素爆发已初始化 = true;
  const timerId = 周期(菲尼克斯尔数值与表现配置.元素爆发.周期秒 * 1000, function 菲尼克斯尔元素爆发周期(this: void): void {
    结算菲尼克斯尔元素爆发(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-元素爆发", timerId);
}

export function 注册菲尼克斯尔元素爆发(this: void): void {
  // 第二形态周期机制，由转阶段时初始化。
  注册元素爆发附加效果();
}

