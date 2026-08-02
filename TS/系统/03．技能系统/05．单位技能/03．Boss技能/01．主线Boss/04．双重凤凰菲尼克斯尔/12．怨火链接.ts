/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  周期,
  延迟,
  停止周期,
  单位存活,
  取菲尼克斯尔敌对目标列表,
  取单位X,
  取单位Y,
  两点距离,
  线段到点距离,
  创建预警圆,
  取菲尼克斯尔技能强度倍率,
  创建菲尼克斯尔独立伤害上下文,
  添加元素层数,
  显示常规读条,
  创建菲尼克斯尔机制单位,
  单位有效,
  取最大生命,
  设置单位动画,
} from "./19．公共工具";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";

const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
};

const jass = require("jass.common") as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const { 闪电效果代码 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码") as {
  闪电效果代码: any;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};

export function 释放菲尼克斯尔怨火链接(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  const targets = 取菲尼克斯尔敌对目标列表(context.Boss);
  if (targets.length < 1) return;
  const a = targets[0];
  let b = targets.length >= 2 ? targets[1] : context.怨火锚点;
  if (!单位有效(b)) {
    const center = 菲尼克斯尔场地配置.中心点;
    b = 创建菲尼克斯尔机制单位(
      context,
      菲尼克斯尔单位技能配置.机制单位ID.怨火核心,
      "怨火锚点",
      菲尼克斯尔单位技能配置.模型.怨火核心,
      center.x,
      center.y,
      取最大生命(context.Boss) * 0.05
    );
    context.怨火锚点 = b;
  }
  if (!单位存活(a) || !单位存活(b) || a === b) return;
  const config = 菲尼克斯尔数值与表现配置.怨火链接;
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔怨火链接", config.预警秒 + config.持续秒 + 2);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.倍速);
  播放菲尼克斯尔台词(context.Boss, "怨火链接");
  显示常规读条(config.预警秒, config.吟唱条颜色ID, config.吟唱条标题文本, config.吟唱条提示文本);
  创建预警圆(取单位X(a), 取单位Y(a), 160, config.预警秒);
  创建预警圆(取单位X(b), 取单位Y(b), 160, config.预警秒);
  延迟(config.预警秒 * 1000, function 菲尼克斯尔怨火链接创建(this: void): void {
    if (!单位存活(a) || !单位存活(b)) return;
    const lightning = 创建单位绑定闪电({
      效果代码: 闪电效果代码.红色光束 ?? 闪电效果代码.生命吸取 ?? "DRAL",
      起点单位: a,
      终点单位: b,
      持续时间: config.持续秒,
      起点高度偏移: 80,
      终点高度偏移: 80,
      任一死亡时销毁: true,
    });
    registerManualBuff(a, 菲尼克斯尔单位技能配置.BuffID.怨火链接, config.持续秒, 1, {
      stack: 1,
      sourceName: "菲尼克斯尔-怨火链接",
    });
    registerManualBuff(b, 菲尼克斯尔单位技能配置.BuffID.怨火链接, config.持续秒, 1, {
      stack: 1,
      sourceName: "菲尼克斯尔-怨火链接",
    });
    context.清理.登记闪电("菲尼克斯尔怨火链接", lightning);
    播放Boss坐标音效(菲尼克斯尔音效配置.怨火链接.链接生成, (取单位X(a) + 取单位X(b)) * 0.5, (取单位Y(a) + 取单位Y(b)) * 0.5, 菲尼克斯尔音效配置.默认裁断距离);
    const tick = 周期(config.Tick秒 * 1000, function 菲尼克斯尔怨火链接Tick(this: void): void {
      if (!单位存活(a) || !单位存活(b)) return;
      if (两点距离(取单位X(a), 取单位Y(a), 取单位X(b), 取单位Y(b)) > config.断链距离) {
        if (单位存活(context.Boss) && 单位存活(a)) {
          执行BossAOE技能伤害({
            技能ID: 伤害上下文?.技能ID,
            技能实例ID: 伤害上下文?.技能实例ID,
            标签: 伤害上下文?.标签,
            来源: context.Boss,
            目标: a,
            伤害公式: {
              来源攻击力比例: config.断链伤害Boss攻击力比例,
              目标已损生命比例: config.断链伤害目标已损失生命比例,
              总倍率: 取菲尼克斯尔技能强度倍率(context.Boss),
            },
            ranged: true,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
            weaponType: WEAPON_TYPE_WHOKNOWS,
          });
        }
        if (单位存活(context.Boss) && 单位存活(b)) {
          执行BossAOE技能伤害({
            技能ID: 伤害上下文?.技能ID,
            技能实例ID: 伤害上下文?.技能实例ID,
            标签: 伤害上下文?.标签,
            来源: context.Boss,
            目标: b,
            伤害公式: {
              来源攻击力比例: config.断链伤害Boss攻击力比例,
              目标已损生命比例: config.断链伤害目标已损失生命比例,
              总倍率: 取菲尼克斯尔技能强度倍率(context.Boss),
            },
            ranged: true,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
            weaponType: WEAPON_TYPE_WHOKNOWS,
          });
        }
        添加元素层数(a, "暗", config.怨火层数);
        添加元素层数(b, "暗", config.怨火层数);
        移除单位指定Buff(a, 菲尼克斯尔单位技能配置.BuffID.怨火链接);
        移除单位指定Buff(b, 菲尼克斯尔单位技能配置.BuffID.怨火链接);
        停止周期(tick);
        return;
      }
      const all = 取菲尼克斯尔敌对目标列表(context.Boss);
      for (let i = 0; i < all.length; i++) {
        const u = all[i];
        if (u === a || u === b) continue;
        if (线段到点距离(取单位X(a), 取单位Y(a), 取单位X(b), 取单位Y(b), 取单位X(u), 取单位Y(u)) <= config.线宽) {
          if (单位存活(context.Boss) && 单位存活(u)) {
            执行BossAOE技能伤害({
              技能ID: 伤害上下文?.技能ID,
              技能实例ID: 伤害上下文?.技能实例ID,
              标签: 伤害上下文?.标签,
              来源: context.Boss,
              目标: u,
              伤害公式: {
                来源攻击力比例: config.穿线伤害Boss攻击力比例,
                目标最大生命比例: config.穿线伤害目标最大生命比例,
                总倍率: 取菲尼克斯尔技能强度倍率(context.Boss),
              },
              ranged: true,
              attackType: ATTACK_TYPE_NORMAL,
              伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
              weaponType: WEAPON_TYPE_WHOKNOWS,
            });
          }
          添加元素层数(u, "暗", config.怨火层数);
        }
      }
    });
    context.清理.登记周期回调("菲尼克斯尔怨火链接Tick", tick);
    延迟(config.持续秒 * 1000, function 菲尼克斯尔怨火链接结束(this: void): void {
      停止周期(tick);
      移除单位指定Buff(a, 菲尼克斯尔单位技能配置.BuffID.怨火链接);
      移除单位指定Buff(b, 菲尼克斯尔单位技能配置.BuffID.怨火链接);
    });
  });
}

export function 初始化菲尼克斯尔怨火链接节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  const timerId = 周期(19000, function 菲尼克斯尔怨火链接周期(this: void): void {
    释放菲尼克斯尔怨火链接(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-怨火链接", timerId);
}

export function 注册菲尼克斯尔怨火链接(this: void): void {
  // 第二形态周期机制，由转阶段时初始化。
}

