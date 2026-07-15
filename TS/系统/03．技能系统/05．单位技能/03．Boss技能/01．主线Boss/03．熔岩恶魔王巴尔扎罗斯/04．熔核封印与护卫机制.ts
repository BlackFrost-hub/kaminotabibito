/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 取单位ID } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 获取巴尔扎罗斯上下文 } from "./03．运行时上下文";
import { 播放巴尔扎罗斯台词, 播放格鲁姆台词, 播放塞拉台词 } from "./14．台词播放";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯护卫配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";

const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { X_FixUnitStandingSafe, X_RestoreUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
  X_RestoreUnitStandingSafe: (this: void, unit: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 护卫归属Boss表: Record<number, any | undefined> = {};
let 护卫死亡监听已注册 = false;
let 熔核封印伤害修正已注册 = false;

function 登记护卫归属(this: void, context: 巴尔扎罗斯运行时上下文, guard: any): void {
  const id = 取单位ID(guard);
  if (id === 0) return;
  护卫归属Boss表[id] = context.Boss单位;
  context.清理.登记清理("巴尔扎罗斯-护卫归属清理", function 清理护卫归属(this: void): void {
    delete 护卫归属Boss表[id];
  });
}

function 创建格鲁姆(this: void, context: 巴尔扎罗斯运行时上下文): any {
  const cfg = 巴尔扎罗斯护卫配置.格鲁姆;
  return 创建召唤物({
    主人单位: context.Boss单位,
    单位类型: 巴尔扎罗斯单位技能配置.护卫.格鲁姆.单位ID,
    单位名称: 巴尔扎罗斯单位技能配置.护卫.格鲁姆.名称,
    X: cfg.X,
    Y: cfg.Y,
    朝向: cfg.面向,
    模型文件: 巴尔扎罗斯单位技能配置.护卫.格鲁姆.模型路径,
    生命值: cfg.生命值,
    生命值受小怪倍率: false,
    护甲: cfg.防御力,
    攻击间隔: cfg.攻击间隔,
  });
}

function 创建塞拉(this: void, context: 巴尔扎罗斯运行时上下文): any {
  const cfg = 巴尔扎罗斯护卫配置.塞拉;
  return 创建召唤物({
    主人单位: context.Boss单位,
    单位类型: 巴尔扎罗斯单位技能配置.护卫.塞拉.单位ID,
    单位名称: 巴尔扎罗斯单位技能配置.护卫.塞拉.名称,
    X: cfg.X,
    Y: cfg.Y,
    朝向: cfg.面向,
    模型文件: 巴尔扎罗斯单位技能配置.护卫.塞拉.模型路径,
    生命值: cfg.生命值,
    生命值受小怪倍率: false,
    护甲: cfg.防御力,
    攻击间隔: cfg.攻击间隔,
  });
}

function 添加熔核封印(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  registerManualBuff(boss, 巴尔扎罗斯单位技能配置.BuffID.熔核封印, 999999, 0.8, {
    sourceName: "巴尔扎罗斯",
  });
  X_FixUnitStandingSafe(boss);
  context.熔核封印已解除 = false;
}

function 解除熔核封印(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.熔核封印已解除) return;
  context.熔核封印已解除 = true;
  移除单位指定Buff(boss, 巴尔扎罗斯单位技能配置.BuffID.熔核封印);
  X_RestoreUnitStandingSafe(boss);
  播放Boss坐标音效(巴尔扎罗斯音效配置.转阶段2.封印破碎, GetUnitX(boss), GetUnitY(boss), 巴尔扎罗斯音效配置.默认裁断距离);
}

function 双护卫都已死亡(this: void, context: 巴尔扎罗斯运行时上下文): boolean {
  return !单位有效(context.格鲁姆) && !单位有效(context.塞拉);
}

function on巴尔扎罗斯护卫死亡(this: void, dyingUnit: any): void {
  const guardId = 取单位ID(dyingUnit);
  if (guardId === 0) return;
  const boss = 护卫归属Boss表[guardId];
  if (boss == null || boss === 0) return;
  delete 护卫归属Boss表[guardId];
  const context = 获取巴尔扎罗斯上下文(boss);
  if (context == null) return;
  if (dyingUnit === context.格鲁姆) {
    播放格鲁姆台词(dyingUnit, "死亡", 0);
    context.格鲁姆 = undefined;
  }
  if (dyingUnit === context.塞拉) {
    播放塞拉台词(dyingUnit, "死亡", 0);
    context.塞拉 = undefined;
  }
  if (!双护卫都已死亡(context)) return;
  解除熔核封印(context);
  context.阶段 = 2;
  const bossUnit = context.Boss单位;
  context.阶段3台词最早Ms = getServerTime() + 14500;
  addDelayedCallback(6000, function 巴尔扎罗斯护卫尽灭台词(this: void): void {
    if (单位有效(bossUnit)) 播放巴尔扎罗斯台词(bossUnit, "转阶段2", 0);
  });
}

function on熔核封印伤害修正(this: void, context: any): number {
  const target = context.target;
  if (!单位有效(target)) return context.currentDamage;
  if (getBuffRuntime(target, 巴尔扎罗斯单位技能配置.BuffID.熔核封印) == null) return context.currentDamage;
  return context.currentDamage * 0.2;
}

function 确保全局监听(this: void): void {
  if (!护卫死亡监听已注册) {
    护卫死亡监听已注册 = true;
    registerDeathListener(on巴尔扎罗斯护卫死亡);
  }
  if (!熔核封印伤害修正已注册) {
    熔核封印伤害修正已注册 = true;
    registerDamageModifier(on熔核封印伤害修正, 40);
  }
}

export function 初始化巴尔扎罗斯熔核封印与护卫机制(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.护卫机制已初始化) return;
  context.护卫机制已初始化 = true;
  确保全局监听();
  添加熔核封印(context);

  context.格鲁姆 = 创建格鲁姆(context);
  context.塞拉 = 创建塞拉(context);
  context.清理.登记单位("巴尔扎罗斯-格鲁姆", context.格鲁姆);
  context.清理.登记单位("巴尔扎罗斯-塞拉", context.塞拉);
  登记护卫归属(context, context.格鲁姆);
  登记护卫归属(context, context.塞拉);

  const grum = context.格鲁姆;
  const sera = context.塞拉;
  addDelayedCallback(7000, function 格鲁姆登场回应(this: void): void {
    if (单位有效(grum)) 播放格鲁姆台词(grum, "响应召令", 0);
  });
  addDelayedCallback(10300, function 塞拉登场回应(this: void): void {
    if (单位有效(sera)) 播放塞拉台词(sera, "响应召令", 0);
  });
}

export function 注册巴尔扎罗斯熔核封印与护卫机制(this: void): void {
  确保全局监听();
}
