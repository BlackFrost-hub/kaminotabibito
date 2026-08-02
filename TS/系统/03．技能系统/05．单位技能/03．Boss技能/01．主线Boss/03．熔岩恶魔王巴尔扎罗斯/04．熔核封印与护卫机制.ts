/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 获取巴尔扎罗斯上下文 } from "./03．运行时上下文";
import { 播放巴尔扎罗斯台词, 播放格鲁姆台词, 播放塞拉台词 } from "./14．台词播放";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯护卫配置, 巴尔扎罗斯技能数值配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建条件伤害修正 } from "../../../../00．技能模板+函数/04．机制组件/08．机制触发/11．条件伤害修正";

const { 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number, animSpeed?: number, 动画索引?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { 创建自定义护卫单位, 处理Boss结束全部护卫 } = require("系统.01．单位系统.10．护卫系统.index") as {
  创建自定义护卫单位: (this: void, 参数: any, 创建器: (this: void) => any) => any;
  处理Boss结束全部护卫: (this: void, boss: any) => void;
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
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
let 熔核封印伤害修正已注册 = false;

function 创建格鲁姆(this: void, context: 巴尔扎罗斯运行时上下文): any {
  const cfg = 巴尔扎罗斯护卫配置.格鲁姆;
  return 创建自定义护卫单位({
    主Boss单位: context.Boss单位,
    护卫类型: "巴尔扎罗斯:格鲁姆",
    护卫血条优先级: 200,
    标记为召唤单位: true,
    Boss结束处理: "移除",
    on死亡: on巴尔扎罗斯护卫死亡,
  }, function 创建格鲁姆召唤物(this: void): any {
    return 创建召唤物({
      主人单位: context.Boss单位,
      单位类型: 巴尔扎罗斯单位技能配置.护卫.格鲁姆.单位ID,
      单位名称: 巴尔扎罗斯单位技能配置.护卫.格鲁姆.名称,
      X: cfg.X,
      Y: cfg.Y,
      朝向: cfg.面向,
      生命值: cfg.生命值,
      生命值受小怪倍率: false,
      护甲: cfg.防御力,
      攻击间隔: cfg.攻击间隔,
    });
  });
}

function 创建塞拉(this: void, context: 巴尔扎罗斯运行时上下文): any {
  const cfg = 巴尔扎罗斯护卫配置.塞拉;
  return 创建自定义护卫单位({
    主Boss单位: context.Boss单位,
    护卫类型: "巴尔扎罗斯:塞拉",
    护卫血条优先级: 200,
    标记为召唤单位: true,
    Boss结束处理: "移除",
    on死亡: on巴尔扎罗斯护卫死亡,
  }, function 创建塞拉召唤物(this: void): any {
    return 创建召唤物({
      主人单位: context.Boss单位,
      单位类型: 巴尔扎罗斯单位技能配置.护卫.塞拉.单位ID,
      单位名称: 巴尔扎罗斯单位技能配置.护卫.塞拉.名称,
      X: cfg.X,
      Y: cfg.Y,
      朝向: cfg.面向,
      生命值: cfg.生命值,
      生命值受小怪倍率: false,
      护甲: cfg.防御力,
      攻击间隔: cfg.攻击间隔,
    });
  });
}

function 添加熔核封印(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.熔核封印;
  registerManualBuff(boss, 巴尔扎罗斯单位技能配置.BuffID.熔核封印, 999999, 0.8, {
    sourceName: "巴尔扎罗斯",
  });
  X_FixUnitStandingSafe(boss);
  创建单位坐标跟随特效(boss, config.特效路径, config.特效键, config.特效缩放, config.特效高度, undefined, config.动画索引);
  context.清理.登记清理("巴尔扎罗斯-熔核封印特效", function 巴尔扎罗斯熔核封印特效清理(this: void): void {
    销毁单位坐标跟随特效(boss, config.特效键);
  });
  context.熔核封印已解除 = false;
}

function 解除熔核封印(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.熔核封印已解除) return;
  context.熔核封印已解除 = true;
  销毁单位坐标跟随特效(boss, 巴尔扎罗斯技能数值配置.熔核封印.特效键);
  移除单位指定Buff(boss, 巴尔扎罗斯单位技能配置.BuffID.熔核封印);
  X_RestoreUnitStandingSafe(boss);
  播放Boss坐标音效(巴尔扎罗斯音效配置.转阶段2.封印破碎, GetUnitX(boss), GetUnitY(boss), 巴尔扎罗斯音效配置.默认裁断距离);
}

function 双护卫都已死亡(this: void, context: 巴尔扎罗斯运行时上下文): boolean {
  return !单位有效(context.格鲁姆) && !单位有效(context.塞拉);
}

function on巴尔扎罗斯护卫死亡(this: void, dyingUnit: any, _killingUnit: any, record: any): void {
  const boss = record?.主Boss单位;
  if (boss == null || boss === 0) return;
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

function 满足熔核封印伤害条件(this: void, context: any): boolean {
  if (context == null || !单位有效(context.target)) return false;
  return getBuffRuntime(context.target, 巴尔扎罗斯单位技能配置.BuffID.熔核封印) != null;
}

function 确保全局监听(this: void): void {
  if (!熔核封印伤害修正已注册) {
    熔核封印伤害修正已注册 = true;
    创建条件伤害修正({
      名称: "巴尔扎罗斯熔核封印承伤修正",
      优先级: 40,
      条件: 满足熔核封印伤害条件,
      修正: on熔核封印伤害修正,
    });
  }
}

export function 初始化巴尔扎罗斯熔核封印与护卫机制(this: void, context: 巴尔扎罗斯运行时上下文, 跳过护卫创建: boolean = false): void {
  if (context.护卫机制已初始化) return;
  context.护卫机制已初始化 = true;
  确保全局监听();
  添加熔核封印(context);
  if (跳过护卫创建) return;

  context.格鲁姆 = 创建格鲁姆(context);
  context.塞拉 = 创建塞拉(context);
  const boss = context.Boss单位;
  context.清理.登记清理("巴尔扎罗斯-护卫登记清理", function 清理巴尔扎罗斯护卫登记(this: void): void {
    处理Boss结束全部护卫(boss);
  });

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
