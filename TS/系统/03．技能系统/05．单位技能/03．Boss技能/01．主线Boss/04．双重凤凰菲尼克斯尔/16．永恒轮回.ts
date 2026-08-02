/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";

const { 创建单位动画守护 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.18．单位动画守护") as {
  创建单位动画守护: (this: void, 参数: any) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
import {
  周期,
  延迟,
  停止周期,
  单位存活,
  取当前生命,
  取最大生命,
  取单位X,
  取单位Y,
  创建菲尼克斯尔机制单位,
  显示致命读条,
  开始施法硬直,
  设置单位动画,
  取菲尼克斯尔敌对目标列表,
  取菲尼克斯尔技能强度倍率,
  创建菲尼克斯尔独立伤害上下文,
} from "./19．公共工具";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};

const jass = require("jass.common") as any;
const KillUnit = jass.KillUnit as (whichUnit: any) => void;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

function 播放永恒轮回点特效(this: void, model: string, x: number, y: number, lifeMs: number, scale: number): any {
  return 创建点特效({ 模型路径: model, X: x, Y: y, 缩放: scale, 持续秒: lifeMs / 1000 });
}

function 清理菲尼克斯尔凤凰蛋(this: void, context: 菲尼克斯尔运行时上下文): void {
  for (let i = 0; i < context.凤凰蛋列表.length; i++) {
    const item = context.凤凰蛋列表[i];
    const egg = item.单位;
    if (egg != null && egg !== 0) {
      if (!item.已摧毁) 播放永恒轮回点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回星屑残留, 取单位X(egg), 取单位Y(egg), 1200, 菲尼克斯尔数值与表现配置.机制.永恒轮回星屑残留特效缩放);
      RemoveUnit(egg);
    }
  }
  context.凤凰蛋列表 = [];
}

function on菲尼克斯尔凤凰蛋死亡(this: void, context: 菲尼克斯尔运行时上下文, unit: any): void {
  for (let i = 0; i < context.凤凰蛋列表.length; i++) {
    const item = context.凤凰蛋列表[i];
    if (item.单位 !== unit) continue;
    if (item.已摧毁) return;
    item.已摧毁 = true;
    播放永恒轮回点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回星屑残留, 取单位X(unit), 取单位Y(unit), 1200, 菲尼克斯尔数值与表现配置.机制.永恒轮回星屑残留特效缩放);
    播放Boss坐标音效(菲尼克斯尔音效配置.永恒轮回.凤凰蛋摧毁, 取单位X(unit), 取单位Y(unit), 菲尼克斯尔音效配置.默认裁断距离);
    return;
  }
}

function 创建凤凰蛋死亡回调(this: void, context: 菲尼克斯尔运行时上下文): (this: void, unit: any, killer: any) => void {
  return function 菲尼克斯尔凤凰蛋死亡(this: void, unit: any): void {
    on菲尼克斯尔凤凰蛋死亡(context, unit);
  };
}

export function 触发菲尼克斯尔永恒轮回(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.永恒轮回已触发 || context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  const config = 菲尼克斯尔数值与表现配置.机制;
  context.永恒轮回已触发 = true;
  context.当前形态 = "永恒轮回";
  registerManualBuff(context.Boss, 菲尼克斯尔单位技能配置.BuffID.永恒轮回, config.永恒轮回引导秒, 1, {
    stack: 1,
    sourceName: "菲尼克斯尔-永恒轮回",
  });
  const 伤害上下文 = 创建菲尼克斯尔独立伤害上下文("菲尼克斯尔永恒轮回", config.永恒轮回引导秒 + 2);
  播放菲尼克斯尔台词(context.Boss, "永恒轮回");
  开始施法硬直(context.Boss, config.永恒轮回引导秒);
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.轮回死亡.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.轮回死亡.倍速);
  延迟(config.永恒轮回动画冻结秒 * 1000, function 菲尼克斯尔永恒轮回冻结动画(this: void): void {
    if (单位存活(context.Boss) && context.当前形态 === "永恒轮回") SetUnitTimeScale(context.Boss, 0);
  });
  显示致命读条(config.永恒轮回引导秒, 3, "永恒轮回倒计时", "摧毁凤凰之卵，否则菲尼克斯尔将恢复生命");
  播放Boss坐标音效(菲尼克斯尔音效配置.永恒轮回.开始, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.默认裁断距离);
  const points = 菲尼克斯尔场地配置.导管点位;
  for (let i = 0; i < points.length; i++) {
    const p = points[i];
    const egg = 创建菲尼克斯尔机制单位(
      context,
      菲尼克斯尔单位技能配置.机制单位ID.凤凰之卵,
      "凤凰之卵",
      菲尼克斯尔单位技能配置.模型.凤凰之卵,
      p.x,
      p.y,
      取最大生命(context.Boss) * config.凤凰蛋生命Boss最大生命比例,
      创建凤凰蛋死亡回调(context)
    );
    const eggAnimation = 菲尼克斯尔数值与表现配置.动画.第一形态.凤凰蛋;
    创建单位动画守护({
      单位: egg,
      动画编号: eggAnimation.编号,
      附加动画属性: eggAnimation.附加动画属性,
      间隔秒: eggAnimation.守护间隔秒,
      调试名: "菲尼克斯尔-凤凰蛋动画守护",
    });
    context.凤凰蛋列表.push({ 单位: egg, 已摧毁: false });
  }
  const 能量上升timerId = 周期(500, function 菲尼克斯尔永恒轮回能量上升(this: void): void {
    for (let i = 0; i < context.凤凰蛋列表.length; i++) {
      const egg = context.凤凰蛋列表[i].单位;
      if (!单位存活(egg)) continue;
      播放永恒轮回点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回能量上升, 取单位X(egg), 取单位Y(egg), 600, config.永恒轮回能量上升特效缩放);
    }
  });
  context.清理.登记周期回调("菲尼克斯尔-永恒轮回能量上升", 能量上升timerId);
  延迟(config.永恒轮回引导秒 * 1000, function 菲尼克斯尔永恒轮回结算(this: void): void {
    停止周期(能量上升timerId);
    SetUnitTimeScale(context.Boss, 1);
    移除单位指定Buff(context.Boss, 菲尼克斯尔单位技能配置.BuffID.永恒轮回);
    let aliveEggs = 0;
    for (let i = 0; i < context.凤凰蛋列表.length; i++) {
      if (单位存活(context.凤凰蛋列表[i].单位)) aliveEggs += 1;
    }
    if (aliveEggs > 0) {
      播放Boss坐标音效(菲尼克斯尔音效配置.永恒轮回.失败结算, 取单位X(context.Boss), 取单位Y(context.Boss), 菲尼克斯尔音效配置.默认裁断距离);
      const heal = 取最大生命(context.Boss) * config.每枚存活凤凰蛋回血Boss最大生命比例 * aliveEggs;
      doHeal({ HealSource: context.Boss, HealTarget: context.Boss, HealAmount: heal, ItemHeal: false, HealEffect: false });
      const heroes = 取菲尼克斯尔敌对目标列表(context.Boss);
      for (let i = 0; i < heroes.length; i++) {
        if (单位存活(context.Boss) && 单位存活(heroes[i])) {
          执行BossAOE技能伤害({
            技能实例ID: 伤害上下文?.技能实例ID,
            标签: 伤害上下文?.标签,
            来源: context.Boss,
            目标: heroes[i],
            伤害公式: {
              来源攻击力比例: config.轮回失败全场伤害Boss攻击力比例,
              目标最大生命比例: config.轮回失败全场伤害目标最大生命比例,
              总倍率: 取菲尼克斯尔技能强度倍率(context.Boss),
            },
            ranged: true,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
            weaponType: WEAPON_TYPE_WHOKNOWS,
          });
        }
        播放永恒轮回点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回失败伤害, 取单位X(heroes[i]), 取单位Y(heroes[i]), 1500, config.永恒轮回失败伤害特效缩放);
      }
      清理菲尼克斯尔凤凰蛋(context);
      context.当前形态 = "第二形态";
      context.永恒轮回已触发 = false;
    } else {
      清理菲尼克斯尔凤凰蛋(context);
      KillUnit(context.Boss);
    }
    播放永恒轮回点特效(菲尼克斯尔数值与表现配置.特效.永恒轮回收拢, 取单位X(context.Boss), 取单位Y(context.Boss), 2000, config.永恒轮回收拢特效缩放);
  });
}

export function 初始化菲尼克斯尔永恒轮回节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  const timerId = 周期(500, function 菲尼克斯尔永恒轮回检测(this: void): void {
    if (!单位存活(context.Boss)) {
      停止周期(timerId);
      return;
    }
    if (取当前生命(context.Boss) <= 取最大生命(context.Boss) * 菲尼克斯尔数值与表现配置.机制.永恒轮回触发生命比例) {
      触发菲尼克斯尔永恒轮回(context);
    }
  });
  context.清理.登记周期回调("菲尼克斯尔-永恒轮回检测", timerId);
}

export function 注册菲尼克斯尔永恒轮回(this: void): void {
  // 第二形态低生命机制，由转阶段时初始化。
}

