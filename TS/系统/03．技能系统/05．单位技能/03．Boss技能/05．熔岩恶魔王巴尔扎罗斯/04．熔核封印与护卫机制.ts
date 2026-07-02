/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 获取巴尔扎罗斯上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯护卫配置 } from "./02．数值与表现配置";

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

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 护卫归属Boss表: Record<number, any | undefined> = {};
let 护卫死亡监听已注册 = false;
let 熔核封印伤害修正已注册 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

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
    单位名称: 巴尔扎罗斯单位技能配置.护卫.塞拉.名称,
    X: cfg.X,
    Y: cfg.Y,
    朝向: cfg.面向,
    模型文件: 巴尔扎罗斯单位技能配置.护卫.塞拉.模型路径,
    生命值: cfg.生命值,
    生命值受小怪倍率: false,
    护甲: cfg.防御力,
    攻击间隔: cfg.攻击间隔,
    攻击范围: 650,
    普攻弹道模型: "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl",
    普攻弹道弧度: 0.15,
    普攻弹道速度: 900,
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
  if (dyingUnit === context.格鲁姆) context.格鲁姆 = undefined;
  if (dyingUnit === context.塞拉) context.塞拉 = undefined;
  if (双护卫都已死亡(context)) 解除熔核封印(context);
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
}

export function 注册巴尔扎罗斯熔核封印与护卫机制(this: void): void {
  确保全局监听();
}
