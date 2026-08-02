/** @noSelfInFile */

import { type 卡瑟拉运行时上下文, 消耗玩家触手残片 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置, 卡瑟拉音效配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, 极坐标X, 极坐标Y, 距离平方XY } from "./14．公共工具";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { 创建动态装饰物安全区组 } from "../../../../00．技能模板+函数/04．机制组件/02．战斗区域/06．动态装饰物安全区组";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 启动基础施法时间线 } from "../../../../00．技能模板+函数/02．通用函数/13．施法时间线";

const { 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};
const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlType: number, duration: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉") as {
  卡瑟拉BuffID: { 麻痹电流: string; 绝缘庇护: string };
};

interface 共生电击预警特效实例 {
  context: 卡瑟拉运行时上下文;
  剩余播放次数: number;
  周期ID: number;
}

function 播放共生电击点特效(this: void, 模型路径: string, x: number, y: number, 缩放: number, 持续秒: number): any {
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  return 创建点特效({
    模型路径,
    X: x,
    Y: y,
    Z: cfg.特效高度,
    缩放,
    持续秒,
  });
}

function 播放共生电击蓄力特效(this: void, boss: any): void {
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  播放共生电击点特效(cfg.蓄力特效路径, GetUnitX(boss), GetUnitY(boss), cfg.蓄力特效缩放, cfg.蓄力特效持续秒);
}

function 播放共生电击全屏结算特效(this: void, boss: any): void {
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  const effect = 播放共生电击点特效(cfg.全屏命中特效路径, GetUnitX(boss), GetUnitY(boss), cfg.全屏命中特效缩放, -1);
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

function 播放共生电击麻痹特效(this: void, hero: any): void {
  if (!单位有效(hero)) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  播放共生电击点特效(cfg.麻痹命中特效路径, GetUnitX(hero), GetUnitY(hero), cfg.麻痹命中特效缩放, cfg.麻痹命中特效持续秒);
}

function 播放共生电击预警特效一跳(this: void, data: 共生电击预警特效实例): void {
  const boss = data.context.Boss单位;
  if (!单位有效(boss) || data.context.Boss潜入中 || data.剩余播放次数 <= 0) {
    removePeriodicCallback(data.周期ID);
    return;
  }
  播放共生电击蓄力特效(boss);
  data.剩余播放次数 = data.剩余播放次数 - 1;
  if (data.剩余播放次数 <= 0) removePeriodicCallback(data.周期ID);
}

function 确保绝缘珊瑚(this: void, context: 卡瑟拉运行时上下文): void {
  if (context.绝缘珊瑚安全区组 != null && context.绝缘珊瑚列表.length > 0) return;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  const 点位列表: { ID: string; X: number; Y: number; 半径: number; 朝向: number }[] = [];
  for (let i = 0; i < cfg.珊瑚数量; i++) {
    const angle = i * 120 + 40;
    const x = 极坐标X(bx, angle, cfg.珊瑚距离);
    const y = 极坐标Y(by, angle, cfg.珊瑚距离);
    点位列表.push({ ID: "绝缘珊瑚" + (i + 1), X: x, Y: y, 半径: cfg.安全半径, 朝向: angle });
  }
  const 安全区组 = 创建动态装饰物安全区组({
    清理: context.清理,
    名称: "卡瑟拉-绝缘珊瑚",
    装饰物ID: cfg.珊瑚装饰物ID,
    点位列表,
    随机样式最小ID: cfg.珊瑚样式最小ID,
    随机样式最大ID: cfg.珊瑚样式最大ID,
    缩放: cfg.珊瑚缩放,
    来源单位: boss,
  });
  context.绝缘珊瑚安全区组 = 安全区组;
  const 安全区列表 = 安全区组.取列表();
  context.绝缘珊瑚列表 = [];
  for (let i = 0; i < 安全区列表.length; i++) {
    const 区 = 安全区列表[i];
    context.绝缘珊瑚列表.push({ X: 区.X, Y: 区.Y, 半径: 区.半径, 装饰单位: 区.装饰物 });
  }
}

function 玩家在绝缘珊瑚内(this: void, context: 卡瑟拉运行时上下文, hero: any): boolean {
  if (context.绝缘珊瑚安全区组 != null) return context.绝缘珊瑚安全区组.单位是否安全(hero);
  const hx = GetUnitX(hero);
  const hy = GetUnitY(hero);
  for (let i = 0; i < context.绝缘珊瑚列表.length; i++) {
    const coral = context.绝缘珊瑚列表[i];
    if (距离平方XY(hx, hy, coral.X, coral.Y) <= coral.半径 * coral.半径) return true;
  }
  return false;
}

function 预警绝缘珊瑚(this: void, context: 卡瑟拉运行时上下文): void {
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  if (context.绝缘珊瑚安全区组 != null) context.绝缘珊瑚安全区组.显示提示(cfg.预警秒);
}

function 安排绝缘珊瑚延迟删除(this: void, context: 卡瑟拉运行时上下文): void {
  const 安全区组 = context.绝缘珊瑚安全区组;
  if (安全区组 == null) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  const id = addDelayedCallback(cfg.珊瑚删除延迟秒 * 1000, function 卡瑟拉绝缘珊瑚延迟删除(this: void): void {
    if (context.绝缘珊瑚安全区组 !== 安全区组) return;
    安全区组.销毁();
    context.绝缘珊瑚安全区组 = undefined;
    context.绝缘珊瑚列表 = [];
  });
  context.清理.登记延迟回调("卡瑟拉-绝缘珊瑚延迟删除", id);
}

function 结算卡瑟拉共生电击(this: void, context: 卡瑟拉运行时上下文, 技能实例ID?: number): void {
  安排绝缘珊瑚延迟删除(context);
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  播放Boss坐标音效(卡瑟拉音效配置.共生电击.爆发, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
  播放共生电击全屏结算特效(boss);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (玩家在绝缘珊瑚内(context, hero)) {
      registerManualBuff(hero, 卡瑟拉BuffID.绝缘庇护, cfg.麻痹秒, 1, { sourceName: "卡瑟拉-绝缘庇护" });
      continue;
    }
    if (消耗玩家触手残片(context, hero, cfg.抵消残片数)) continue;
    执行BossAOE技能伤害({
      来源: boss,
      目标: hero,
      伤害公式: { 固定值: cfg.雷伤害 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_LIGHTNING,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      技能实例ID,
      标签: "卡瑟拉共生电击",
    });
    播放共生电击麻痹特效(hero);
    施加快速控制Buff(boss, hero, 0, cfg.麻痹秒);
    registerManualBuff(hero, 卡瑟拉BuffID.麻痹电流, cfg.麻痹秒, 1, { sourceName: "卡瑟拉-麻痹电流" });
  }
}

export function 释放卡瑟拉共生电击(this: void, context: 卡瑟拉运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return false;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  确保绝缘珊瑚(context);
  播放共生电击蓄力特效(boss);
  const 预警特效: 共生电击预警特效实例 = {
    context,
    剩余播放次数: cfg.预警秒 / cfg.预警特效间隔秒 - 1,
    周期ID: 0,
  };
  预警特效.周期ID = addPeriodicCallback(cfg.预警特效间隔秒 * 1000, function 卡瑟拉共生电击预警特效周期(this: void): void {
    播放共生电击预警特效一跳(预警特效);
  });
  context.清理.登记周期回调("卡瑟拉-共生电击预警特效", 预警特效.周期ID);
  预警绝缘珊瑚(context);
  const 技能实例ID = 创建独立技能伤害实例({
    来源类型: "Boss技能",
    标签: "卡瑟拉共生电击",
    持续时间秒: cfg.预警秒 + 2,
  });
  启动基础施法时间线({
    名称: "卡瑟拉-共生电击",
    施法者: boss,
    硬直秒: cfg.预警秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.预警秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 卡瑟拉共生电击台词(this: void): void {
      播放卡瑟拉台词(boss, "共生电击");
      播放Boss坐标音效(卡瑟拉音效配置.共生电击.预警, GetUnitX(boss), GetUnitY(boss), 卡瑟拉音效配置.默认裁断距离);
      尝试播放Boss拟声池({
        标识: 卡瑟拉音效配置.怪物拟声.标识,
        音效路径列表: 卡瑟拉音效配置.怪物拟声.音效路径列表,
        X: GetUnitX(boss),
        Y: GetUnitY(boss),
        裁断距离: 卡瑟拉音效配置.默认裁断距离,
        冷却Ms: 卡瑟拉音效配置.怪物拟声.冷却Ms,
        触发概率百分比: 卡瑟拉音效配置.怪物拟声.关键机制触发概率百分比,
      });
    },
    清理: context.清理,
    on生效: function 卡瑟拉共生电击时间线生效(this: void): void {
      结算卡瑟拉共生电击(context, 技能实例ID);
    },
  });
  return true;
}
