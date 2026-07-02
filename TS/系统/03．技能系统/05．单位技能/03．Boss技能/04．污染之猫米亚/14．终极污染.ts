/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 取米亚平台中心配置, 取米亚平台中心X, 取米亚平台中心Y } from "./01．场地配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚腐化感染配置 } from "./02．数值与表现配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示致命惩罚吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示致命惩罚吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { 创建点特效, 创建循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  创建循环点特效: (this: void, 参数: any) => any;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

interface 终极污染核心点 {
  x: number;
  y: number;
}

const 终极污染核心上下文表: Record<number, 米亚运行时上下文 | undefined> = {};
let 米亚终极污染已注册 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取核心出生点表(this: void): 终极污染核心点[] {
  const config = 米亚技能数值配置.终极污染;
  const inset = config.核心内缩距离;
  const platform = 取米亚平台中心配置();
  return [
    { x: platform.左 + inset, y: platform.下 + inset },
    { x: platform.右 - inset, y: platform.下 + inset },
    { x: platform.左 + inset, y: platform.上 - inset },
    { x: platform.右 - inset, y: platform.上 - inset },
  ];
}

function 播放终极污染引导表现(this: void, context: 米亚运行时上下文): void {
  const boss = context.Boss单位;
  const seconds = 米亚技能数值配置.终极污染.引导秒;
  创建循环点特效({
    模型路径: 米亚单位技能配置.特效.终极污染Boss引导,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    Z: 20,
    缩放: 1.6,
    总持续秒: seconds,
    重建间隔秒: 3,
    单次持续秒: 2.9,
    存活条件: function 米亚终极污染Boss引导存活(this: void): boolean {
      return context.终极污染引导中 && 单位有效(context.Boss单位);
    },
  });
  创建循环点特效({
    模型路径: 米亚单位技能配置.特效.终极污染中心柱,
    X: 取米亚平台中心X(),
    Y: 取米亚平台中心Y(),
    Z: 0,
    缩放: 1.2,
    总持续秒: seconds,
    重建间隔秒: 3,
    单次持续秒: 2.9,
    存活条件: function 米亚终极污染中心柱存活(this: void): boolean {
      return context.终极污染引导中 && 单位有效(context.Boss单位);
    },
  });
  创建循环点特效({
    模型路径: "war3mapImported\\[ake]gaopin.mdx",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    Z: 80,
    缩放: 1.1,
    总持续秒: seconds,
    重建间隔秒: 3,
    单次持续秒: 2.9,
    存活条件: function 米亚终极污染高频存活(this: void): boolean {
      return context.终极污染引导中 && 单位有效(context.Boss单位);
    },
  });
}

function 创建终极污染核心(this: void, context: 米亚运行时上下文, point: 终极污染核心点, hp: number): any {
  const config = 米亚技能数值配置.终极污染;
  const core = 创建召唤物({
    主人单位: context.Boss单位,
    所属玩家: GetOwningPlayer(context.Boss单位),
    单位类型: 米亚单位技能配置.腐化核心单位ID,
    单位名称: "终极污染核心",
    模型文件: 米亚单位技能配置.特效.终极污染核心模型,
    X: point.x,
    Y: point.y,
    持续时间: config.引导秒 + 2,
    飞行高度: config.核心浮空高度,
    生命值: hp,
    生命值受小怪倍率: false,
    攻击力: 0,
    攻击范围: 0,
    索敌范围: 0,
    缩放: config.核心缩放,
  });
  if (!单位有效(core)) return core;
  X_FixUnitStandingSafe(core);
  const id = 取单位ID(core);
  if (id !== 0) 终极污染核心上下文表[id] = context;
  context.终极污染核心列表.push(core);
  创建循环点特效({
    模型路径: 米亚单位技能配置.特效.终极污染核心附着,
    X: point.x,
    Y: point.y,
    Z: config.核心浮空高度,
    缩放: 1,
    总持续秒: config.引导秒,
    重建间隔秒: 1,
    单次持续秒: 0.9,
    存活条件: function 米亚终极污染核心附着存活(this: void): boolean {
      return context.终极污染引导中 && 单位有效(core);
    },
  });
  return core;
}

function 创建终极污染核心组(this: void, context: 米亚运行时上下文): void {
  const config = 米亚技能数值配置.终极污染;
  const maxLife = GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE);
  const hp = maxLife * config.核心生命Boss最大生命比例;
  const points = 取核心出生点表();
  const count = config.核心数量 < points.length ? config.核心数量 : points.length;
  context.终极污染核心列表 = [];
  for (let i = 0; i < count; i++) {
    创建终极污染核心(context, points[i], hp);
  }
  广播单位提示(context.Boss单位, "打碎所有腐化核心，打断终极污染！", 4200);
  播放米亚台词(context.Boss单位, "终极污染", 2);
}

function 记录终极污染叠层(this: void, context: 米亚运行时上下文, target: any, count: number): void {
  const id = 取单位ID(target);
  if (id === 0) return;
  context.终极污染本次叠层表[id] = (context.终极污染本次叠层表[id] ?? 0) + count;
}

function 清退终极污染本次叠层(this: void, context: 米亚运行时上下文): void {
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    const id = 取单位ID(hero);
    const count = context.终极污染本次叠层表[id] ?? 0;
    if (count > 0) context.腐化层数控制器.减少(hero, count, "终极污染打断清退");
  }
  context.终极污染本次叠层表 = {};
}

function 清理终极污染核心(this: void, context: 米亚运行时上下文): void {
  const cores = context.终极污染核心列表;
  for (let i = 0; i < cores.length; i++) {
    const core = cores[i];
    const id = 取单位ID(core);
    if (id !== 0) 终极污染核心上下文表[id] = undefined;
    if (单位有效(core)) RemoveUnit(core);
  }
  context.终极污染核心列表 = [];
}

export function 清理米亚终极污染(this: void, context: 米亚运行时上下文): void {
  context.终极污染引导中 = false;
  context.终极污染开始Ms = 0;
  context.终极污染结束Ms = 0;
  清理终极污染核心(context);
  context.终极污染本次叠层表 = {};
  关闭吟唱条("致命惩罚");
}

function 终极污染是否全部核心死亡(this: void, context: 米亚运行时上下文): boolean {
  const cores = context.终极污染核心列表;
  if (cores.length <= 0) return false;
  for (let i = 0; i < cores.length; i++) {
    if (单位有效(cores[i])) return false;
  }
  return true;
}

function 打断终极污染(this: void, context: 米亚运行时上下文): void {
  if (!context.终极污染引导中) return;
  context.终极污染引导中 = false;
  关闭吟唱条("致命惩罚");
  清退终极污染本次叠层(context);
  清理终极污染核心(context);
  if (单位有效(context.Boss单位)) {
    SetUnitTimeScale(context.Boss单位, 1);
    开始硬直(context.Boss单位, 米亚技能数值配置.终极污染.打断Boss虚弱秒);
    播放米亚台词(context.Boss单位, "终极污染", 8);
  }
}

function 终极污染核心死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const id = 取单位ID(dyingUnit);
  if (id === 0) return;
  const context = 终极污染核心上下文表[id];
  if (context == null) return;
  终极污染核心上下文表[id] = undefined;
  if (!context.终极污染引导中) return;
  播放米亚台词(context.Boss单位, "终极污染", 6);
  if (终极污染是否全部核心死亡(context)) {
    打断终极污染(context);
    return;
  }
  let alive = 0;
  for (let i = 0; i < context.终极污染核心列表.length; i++) {
    if (单位有效(context.终极污染核心列表[i])) alive += 1;
  }
  if (alive === 1) 播放米亚台词(context.Boss单位, "终极污染", 7);
}

function 终极污染每秒叠层(this: void, context: 米亚运行时上下文): void {
  if (!context.终极污染引导中 || !单位有效(context.Boss单位)) return;
  const config = 米亚技能数值配置.终极污染;
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    添加米亚腐化感染(context, hero, config.每秒全场腐化层数, "终极污染引导");
    记录终极污染叠层(context, hero, config.每秒全场腐化层数);
  }
}

function 完成终极污染(this: void, context: 米亚运行时上下文): void {
  if (!context.终极污染引导中 || !单位有效(context.Boss单位)) return;
  context.终极污染引导中 = false;
  关闭吟唱条("致命惩罚");
  清理终极污染核心(context);
  SetUnitTimeScale(context.Boss单位, 1);
  播放米亚台词(context.Boss单位, "终极污染", 9);
  创建点特效({ 模型路径: 米亚单位技能配置.特效.终极污染完成冲击, X: 取米亚平台中心X(), Y: 取米亚平台中心Y(), Z: 0, 缩放: 4, 持续秒: 2 });
  创建点特效({ 模型路径: 米亚单位技能配置.特效.终极污染完成毒爆, X: 取米亚平台中心X(), Y: 取米亚平台中心Y(), Z: 60, 缩放: 1.5, 持续秒: 2 });

  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    context.腐化层数控制器.设置(hero, 米亚腐化感染配置.最大层数, "终极污染完成");
    if (GetUnitState(hero, UNIT_STATE_LIFE) > 0) KillUnit(hero);
  }
  context.终极污染本次叠层表 = {};
}

function 安排终极污染时点(this: void, context: 米亚运行时上下文): void {
  const config = 米亚技能数值配置.终极污染;
  SetUnitTimeScale(context.Boss单位, 1);
  SetUnitAnimationByIndex(context.Boss单位, 5);

  addDelayedCallback(3330, function 米亚终极污染第二次动作(this: void): void {
    if (!context.终极污染引导中 || !单位有效(context.Boss单位)) return;
    SetUnitTimeScale(context.Boss单位, 1);
    SetUnitAnimationByIndex(context.Boss单位, 5);
  });
  addDelayedCallback(6660, function 米亚终极污染第三次动作(this: void): void {
    if (!context.终极污染引导中 || !单位有效(context.Boss单位)) return;
    SetUnitTimeScale(context.Boss单位, 1);
    SetUnitAnimationByIndex(context.Boss单位, 5);
  });

  for (let i = 1; i <= config.引导秒; i++) {
    addDelayedCallback(i * 1000, function 米亚终极污染每秒(this: void): void {
      终极污染每秒叠层(context);
    });
  }

  addDelayedCallback(2000, function 米亚终极污染二秒台词(this: void): void {
    if (context.终极污染引导中) 播放米亚台词(context.Boss单位, "终极污染", 3);
  });
  addDelayedCallback(4000, function 米亚终极污染四秒台词(this: void): void {
    if (context.终极污染引导中) 播放米亚台词(context.Boss单位, "终极污染", 4);
  });
  addDelayedCallback(6000, function 米亚终极污染六秒台词(this: void): void {
    if (context.终极污染引导中) 播放米亚台词(context.Boss单位, "终极污染", 5);
  });
  addDelayedCallback(config.引导秒 * 1000, function 米亚终极污染完成(this: void): void {
    完成终极污染(context);
  });
}

function 启动终极污染(this: void, context: 米亚运行时上下文): void {
  if (context.终极污染引导中 || !单位有效(context.Boss单位)) return;
  const config = 米亚技能数值配置.终极污染;
  context.终极污染引导中 = true;
  context.终极污染开始Ms = 0;
  context.终极污染结束Ms = config.引导秒 * 1000;
  context.终极污染本次叠层表 = {};

  开始硬直(context.Boss单位, config.引导秒);
  显示致命惩罚吟唱条({
    总时长: config.引导秒,
    颜色ID: 4,
    标题文本: "终极污染",
    提示文本: "击碎全部腐化核心，否则全场腐化满层并死亡",
  });
  播放米亚台词(context.Boss单位, "终极污染", 0);
  播放终极污染引导表现(context);
  创建终极污染核心组(context);
  安排终极污染时点(context);
}

export function 注册米亚终极污染(this: void): void {
  if (米亚终极污染已注册) return;
  米亚终极污染已注册 = true;
  registerDeathListener(终极污染核心死亡);
}

export function 尝试触发米亚终极污染(this: void, context: 米亚运行时上下文): void {
  if (context.阶段 !== 3 || context.终极污染引导中) return;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;

  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (maxLife <= 0) return;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  const trigger = 米亚技能数值配置.终极污染.触发生命比例;
  if (!context.已触发终极污染30 && ratio <= trigger[0]) {
    context.已触发终极污染30 = true;
    启动终极污染(context);
    return;
  }
  if (!context.已触发终极污染15 && ratio <= trigger[1]) {
    context.已触发终极污染15 = true;
    启动终极污染(context);
  }
}
