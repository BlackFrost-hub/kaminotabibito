/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯固定安全区配置表 } from "./01．场地配置";
import { 巴尔扎罗斯技能数值配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";
import { 减少巴尔扎罗斯灼热层数 } from "./16．灼热层数工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建Boss战场地点位集 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.03．Boss战场地点位") as {
  创建Boss战场地点位集: (this: void, 区域组: any, 回退X: number, 回退Y: number) => any;
};
const { 创建血量节点触发器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.index") as {
  创建血量节点触发器: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { addDelayedCallback, addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { 创建点特效, 创建循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  创建循环点特效: (this: void, 参数: any) => any;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const { 造成AOE技能伤害, 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 末日熔爆点 {
  X: number;
  Y: number;
  左?: number;
  右?: number;
  下?: number;
  上?: number;
}

function 取场地中心(this: void, context: 巴尔扎罗斯运行时上下文): 末日熔爆点 {
  const boss = context.Boss单位;
  const fallbackX = GetUnitX(boss);
  const fallbackY = GetUnitY(boss);
  const points = 创建Boss战场地点位集(context.战斗区域组, fallbackX, fallbackY);
  const center = points.取中心();
  if (center.X === 0 && center.Y === 0) return { X: fallbackX, Y: fallbackY };
  return { X: center.X, Y: center.Y };
}

function 取安全点列表(this: void, context: 巴尔扎罗斯运行时上下文, center: 末日熔爆点): 末日熔爆点[] {
  const result: 末日熔爆点[] = [];
  const safeAreas = context.测试固定安全区配置表 ?? 巴尔扎罗斯固定安全区配置表;
  for (let i = 0; i < safeAreas.length; i++) {
    const area = safeAreas[i];
    result.push({
      X: (area.左 + area.右) / 2,
      Y: (area.下 + area.上) / 2,
      左: area.左,
      右: area.右,
      下: area.下,
      上: area.上,
    });
  }
  if (result.length > 0) return result;
  const saved = context.元素安全印记列表;
  for (let i = 0; i < saved.length; i++) {
    result.push({ X: saved[i].X, Y: saved[i].Y });
  }
  if (result.length > 0) return result;
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  result.push({ X: center.X - config.安全点回退距离, Y: center.Y });
  result.push({ X: center.X + config.安全点回退距离, Y: center.Y });
  return result;
}

function 创建安全点提示(this: void, point: 末日熔爆点, 持续秒: number): void {
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  if (point.左 != null && point.右 != null && point.下 != null && point.上 != null) {
    const 矩形路径起点X = (point.左 + point.右) / 2;
    const 矩形路径起点Y = point.下;
    创建技能提示圈({
      类型: "矩形",
      X: 矩形路径起点X,
      Y: 矩形路径起点Y,
      宽度: point.右 - point.左,
      长度: point.上 - point.下,
      朝向: 90,
      持续时间: 持续秒,
      动画速度: 1.0,
    });
    return;
  }
  创建技能提示圈({
    类型: "白色安全圆",
    X: point.X,
    Y: point.Y,
    半径: config.安全区半径,
    持续时间: 持续秒,
    动画速度: 1.0,
  });
}

function 创建安全点高亮(this: void, points: 末日熔爆点[]): void {
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  for (let i = 0; i < points.length; i++) {
    const point = points[i];
    创建安全点提示(point, config.引导秒);
    创建循环点特效({
      模型路径: config.安全点特效路径,
      X: point.X,
      Y: point.Y,
      Z: config.安全点特效高度,
      缩放: config.安全点特效缩放,
      红: 170,
      绿: 220,
      蓝: 255,
      透明度: 230,
      重建间隔秒: 3,
      单次持续秒: 2.8,
      总持续秒: config.安全点临时高亮持续秒,
    });
  }
}

function 创建末日熔爆引导表现(this: void, context: 巴尔扎罗斯运行时上下文, center: 末日熔爆点, safePoints: 末日熔爆点[]): void {
  const boss = context.Boss单位;
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  创建循环点特效({
    模型路径: config.Boss蓄力特效路径,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    Z: config.Boss蓄力特效高度,
    缩放: config.Boss蓄力特效缩放,
    重建间隔秒: config.Boss蓄力特效Tick秒,
    单次持续秒: config.Boss蓄力特效Tick秒,
    总持续秒: config.引导秒,
    存活条件: function 巴尔扎罗斯末日熔爆蓄力存活(this: void): boolean {
      return context.末日熔爆引导中 && 单位有效(boss);
    },
  });
  创建循环点特效({
    模型路径: config.场地中心法阵路径,
    X: center.X,
    Y: center.Y,
    Z: config.场地中心法阵高度,
    缩放: config.场地中心法阵缩放,
    重建间隔秒: 3,
    单次持续秒: 2.8,
    总持续秒: config.引导秒,
  });
  创建安全点高亮(safePoints);
  addDelayedCallback(config.中途提示秒 * 1000, function 巴尔扎罗斯末日熔爆中途提示(this: void): void {
    if (!context.末日熔爆引导中 || !单位有效(boss)) return;
    播放巴尔扎罗斯台词(boss, "末日熔爆中途");
    for (let i = 0; i < safePoints.length; i++) 创建安全点提示(safePoints[i], config.引导秒 - config.中途提示秒);
  });
}

function 点在安全区(this: void, unit: any, safePoints: 末日熔爆点[]): boolean {
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  const radius2 = config.安全区半径 * config.安全区半径;
  for (let i = 0; i < safePoints.length; i++) {
    const point = safePoints[i];
    if (point.左 != null && point.右 != null && point.下 != null && point.上 != null) {
      if (x >= point.左 && x <= point.右 && y >= point.下 && y <= point.上) return true;
      continue;
    }
    const dx = x - safePoints[i].X;
    const dy = y - safePoints[i].Y;
    if (dx * dx + dy * dy <= radius2) return true;
  }
  return false;
}

function 计算外圈伤害(this: void, boss: any, target: any): number {
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  return 计算组合技能伤害(boss, target, {
    来源攻击力比例: config.外圈伤害Boss攻击力比例,
    目标最大生命比例: config.外圈伤害目标最大生命比例,
    总倍率: config.外圈伤害总倍率,
  });
}

function 计算安全区余波伤害(this: void, target: any): number {
  return GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE) * 巴尔扎罗斯技能数值配置.末日熔爆.安全区余波目标最大生命比例;
}

function 播放爆发表现(this: void, center: 末日熔爆点): void {
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  创建点特效({
    模型路径: config.爆发特效路径,
    X: center.X,
    Y: center.Y,
    Z: config.爆发特效高度,
    缩放: config.爆发特效缩放,
    持续秒: config.爆发特效持续秒,
  });
  const angles = config.场地屏幕特效角度;
  for (let i = 0; i < angles.length; i++) {
    const angle = angles[i];
    创建点特效({
      模型路径: config.场地特效路径,
      X: center.X + CosBJ(angle) * config.场地屏幕特效距离,
      Y: center.Y + SinBJ(angle) * config.场地屏幕特效距离,
      Z: config.场地特效高度,
      缩放: config.场地特效缩放,
      持续秒: config.场地特效持续秒,
    });
  }
}

function 结算末日熔爆(this: void, context: 巴尔扎罗斯运行时上下文, center: 末日熔爆点, safePoints: 末日熔爆点[], 技能实例ID?: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  播放爆发表现(center);
  播放Boss坐标音效(巴尔扎罗斯音效配置.末日熔爆.爆发结算, center.X, center.Y, 巴尔扎罗斯音效配置.默认裁断距离);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (点在安全区(hero, safePoints)) {
      造成AOE技能伤害({
        来源: boss,
        目标: hero,
        伤害: 计算安全区余波伤害(hero),
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_FIRE,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "Boss技能",
        技能实例ID,
        标签: "巴尔扎罗斯末日熔爆",
      });
      减少巴尔扎罗斯灼热层数(hero, config.安全区清除灼热层数);
    } else {
      造成AOE技能伤害({
        来源: boss,
        目标: hero,
        伤害: 计算外圈伤害(boss, hero),
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_FIRE,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: "Boss技能",
        技能实例ID,
        标签: "巴尔扎罗斯末日熔爆",
      });
    }
  }
  播放巴尔扎罗斯台词(boss, "末日熔爆爆发");
}

export function 释放巴尔扎罗斯末日熔爆(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (context.末日熔爆引导中 || !单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  const center = 取场地中心(context);
  const safePoints = 取安全点列表(context, center);
  const 技能实例ID = 创建独立技能伤害实例({
    来源类型: "Boss技能",
    标签: "巴尔扎罗斯末日熔爆",
    持续时间秒: config.引导秒 + 2,
  });
  context.末日熔爆引导中 = true;
  创建末日熔爆引导表现(context, center, safePoints);
  播放Boss坐标音效(巴尔扎罗斯音效配置.末日熔爆.开始引导, center.X, center.Y, 巴尔扎罗斯音效配置.默认裁断距离);
  启动基础施法时间线({
    施法者: boss,
    目标X: center.X,
    目标Y: center.Y,
    硬直秒: config.引导秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    吟唱条: {
      通道: "致命惩罚",
      总时长: config.引导秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 巴尔扎罗斯末日熔爆台词(this: void): void {
      播放巴尔扎罗斯台词(boss, "末日熔爆");
    },
    on生效: function 巴尔扎罗斯末日熔爆生效(this: void): void {
      context.末日熔爆引导中 = false;
      结算末日熔爆(context, center, safePoints, 技能实例ID);
    },
  });
}

function 进入第三阶段(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.阶段 === 3) return;
  context.阶段 = 3;
  const boss = context.Boss单位;
  const delayMs = context.阶段3台词最早Ms - getServerTime();
  if (delayMs <= 0) {
    播放巴尔扎罗斯台词(boss, "转阶段3", 0);
  } else {
    addDelayedCallback(delayMs, function 巴尔扎罗斯延迟阶段3台词(this: void): void {
      if (单位有效(boss)) 播放巴尔扎罗斯台词(boss, "转阶段3", 0);
    });
  }
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  context.末日熔爆下一次允许Ms = getServerTime() + config.周期冷却秒 * 1000;
  registerManualBuff(context.Boss单位, 巴尔扎罗斯单位技能配置.BuffID.熔岩暴走, 3600, 1, {
    stack: 1,
    sourceName: "巴尔扎罗斯",
  });
}

function 尝试周期触发末日熔爆(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.阶段 !== 3 || context.末日熔爆引导中) return;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const now = getServerTime();
  if (context.末日熔爆下一次允许Ms <= 0 || now < context.末日熔爆下一次允许Ms) return;
  释放巴尔扎罗斯末日熔爆(context);
  context.末日熔爆下一次允许Ms = now + 巴尔扎罗斯技能数值配置.末日熔爆.周期冷却秒 * 1000;
}

function 尝试低血量额外触发(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.已触发低血量末日熔爆 || context.末日熔爆引导中) return;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE);
  if (maxLife <= 0) return;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  if (ratio > config.低血量额外触发生命比例) return;
  context.已触发低血量末日熔爆 = true;
  释放巴尔扎罗斯末日熔爆(context);
  context.末日熔爆下一次允许Ms = getServerTime() + config.低血量触发后冷却秒 * 1000;
}

export function 初始化巴尔扎罗斯末日熔爆节点(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.末日熔爆节点已初始化) return;
  context.末日熔爆节点已初始化 = true;
  const config = 巴尔扎罗斯技能数值配置.末日熔爆;
  创建血量节点触发器({
    清理: context.清理,
    名称: "巴尔扎罗斯-末日熔爆阶段节点",
    单位: context.Boss单位,
    节点列表: [
      { ID: "末日熔爆-P3", 百分比: config.第三阶段触发生命比例, on触发: function 巴尔扎罗斯进入P3(this: void): void { 进入第三阶段(context); } },
    ],
  });
  const tickId = addPeriodicCallback(config.运行检查间隔毫秒, function 巴尔扎罗斯末日熔爆周期(this: void): void {
    尝试低血量额外触发(context);
    尝试周期触发末日熔爆(context);
  });
  context.清理.登记周期回调("巴尔扎罗斯-末日熔爆周期", tickId);
}

export function 注册巴尔扎罗斯末日熔爆(this: void): void {
  // 代码侧阶段/周期触发；真正绑定在巴尔扎罗斯运行时上下文创建后完成。
}

export {};
