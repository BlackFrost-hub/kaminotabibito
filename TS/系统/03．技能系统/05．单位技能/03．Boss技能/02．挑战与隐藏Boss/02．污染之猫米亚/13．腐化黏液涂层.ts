/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 单位间距离平方 as 距离平方 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置 } from "./02．数值与表现配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerDamageCallback } = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (this: void, cb: (this: void, target: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void, intervalSeconds?: number) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const 腐化黏液上下文表: Record<number, 米亚运行时上下文 | undefined> = {};
let 米亚腐化黏液涂层已注册 = false;

function 取腐化黏液上下文(this: void, boss: any): 米亚运行时上下文 | undefined {
  const id = GetHandleId(boss) || 0;
  if (id === 0) return undefined;
  return 腐化黏液上下文表[id];
}

function 登记腐化黏液上下文(this: void, context: 米亚运行时上下文): void {
  const id = GetHandleId(context.Boss单位) || 0;
  if (id === 0) return;
  if (context.阶段 !== 3 || !单位有效(context.Boss单位)) {
    if (腐化黏液上下文表[id] === context) delete 腐化黏液上下文表[id];
    return;
  }
  if (腐化黏液上下文表[id] === context) return;
  腐化黏液上下文表[id] = context;
  context.清理.登记清理("腐化黏液上下文索引", function 清理腐化黏液上下文索引(this: void): void {
    if (腐化黏液上下文表[id] === context) delete 腐化黏液上下文表[id];
  });
}

function 刷新腐化黏液Buff(this: void, context: 米亚运行时上下文): void {
  registerManualBuff(context.Boss单位, 米亚单位技能配置.BuffID.腐化黏液涂层, 1.2, 米亚技能数值配置.腐化黏液涂层.Boss受伤提高, {
    sourceName: "腐化黏液涂层",
    effectModelOverride: 米亚单位技能配置.特效.腐化高层,
  });
}

function 处理腐化黏液近战反噬(this: void, target: any, _damage: number, _damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean): void {
  if (fromDotTickBatch === true || isNormalAttack !== true) return;
  if (!单位有效(target) || !单位有效(source)) return;
  const context = 取腐化黏液上下文(target);
  if (context == null || context.阶段 !== 3) return;

  const config = 米亚技能数值配置.腐化黏液涂层;
  if (距离平方(target, source) > 250 * 250) return;

  const sourceId = GetHandleId(source) || 0;
  if (sourceId === 0) return;
  const nowMs = getServerTime();
  const 冷却表 = context.腐化黏液近战冷却表;
  if (冷却表[sourceId] != null && nowMs - (冷却表[sourceId] ?? 0) < config.近战叠层冷却Ms) return;
  冷却表[sourceId] = nowMs;
  添加米亚腐化感染(context, source, 1, "腐化黏液涂层近战反噬");
  播放米亚台词(context.Boss单位, "腐化黏液涂层", 1);
}

function 处理腐化黏液Boss受伤提高(this: void, damageContext: any): number {
  const context = 取腐化黏液上下文(damageContext.target);
  if (context == null || context.阶段 !== 3) return damageContext.currentDamage;
  const bonus = 米亚技能数值配置.腐化黏液涂层.Boss受伤提高;
  const nowMs = getServerTime();
  if (nowMs - context.腐化黏液上次受伤提示Ms >= 12000) {
    context.腐化黏液上次受伤提示Ms = nowMs;
    播放米亚台词(context.Boss单位, "腐化黏液涂层", 3);
  }
  return damageContext.currentDamage * (1 + bonus);
}

export function 释放米亚全场腐化黏液(this: void, context: 米亚运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.阶段 !== 3) return false;
  播放米亚台词(boss, "腐化黏液涂层", 2);
  创建点特效({
    模型路径: "war3mapImported\\archimonde_portal_state.mdx",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    Z: 80,
    缩放: 1.2,
    持续秒: 1,
  });

  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    添加米亚腐化感染(context, hero, 1, "腐化黏液涂层全场甩黏液");
  }
  return true;
}

export function 注册米亚腐化黏液涂层(this: void): void {
  if (米亚腐化黏液涂层已注册) return;
  米亚腐化黏液涂层已注册 = true;
  registerDamageCallback(处理腐化黏液近战反噬, 0.03);
  registerDamageModifier(处理腐化黏液Boss受伤提高, 35);
}

export function 刷新米亚腐化黏液涂层被动状态(this: void, context: 米亚运行时上下文): void {
  登记腐化黏液上下文(context);
  if (context.阶段 !== 3) return;
  刷新腐化黏液Buff(context);
}
