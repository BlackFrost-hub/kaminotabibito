/** @noSelfInFile */

import { 设置单位技能壳普通提示 } from "../../../00．技能模板+函数/02．通用函数/15．单位技能壳提示";
import { 创建机制清理篮子, type 机制清理篮子 } from "../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 莫尔特斯数值与表现配置 } from "./02．数值与表现配置";
import { 单位有效, 取单位ID } from "./16．公共工具";

const jass = require("jass.common") as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 莫尔特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.09．莫尔特斯") as {
  莫尔特斯BuffID: {
    腐败值: string;
    根须缠绕: string;
    荆棘寄生: string;
    腐败护盾: string;
    净化庇护: string;
    腐败虫尸净化: string;
  };
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

export type 莫尔特斯阶段 = 1 | 2 | 3;

export interface 莫尔特斯运行时上下文 {
  Boss单位: any;
  阶段: 莫尔特斯阶段;
  已初始化: boolean;
  清理: 机制清理篮子;
  根须宫格?: any;
  玩家腐败值表: Record<number, number | undefined>;
  玩家腐败值单位表: Record<number, any>;
  根系觉醒已触发: boolean;
  腐朽领域已触发: boolean;
  腐败之源组?: any;
  下次沼泽腐败时间: number;
  下次沼泽根须时间: number;
  下次虫群时间: number;
  下次腐败传输档位: number;
  腐败护盾值: number;
}

const 莫尔特斯上下文表: Record<number, 莫尔特斯运行时上下文 | undefined> = {};

export function 获取莫尔特斯上下文(this: void, boss: any): 莫尔特斯运行时上下文 | undefined {
  const id = 取单位ID(boss);
  return id === 0 ? undefined : 莫尔特斯上下文表[id];
}

export function 获取或创建莫尔特斯上下文(this: void, boss: any): 莫尔特斯运行时上下文 | undefined {
  const id = 取单位ID(boss);
  if (id === 0) return undefined;
  let context = 莫尔特斯上下文表[id];
  if (context != null) return context;
  context = {
    Boss单位: boss,
    阶段: 取莫尔特斯当前阶段(boss),
    已初始化: false,
    清理: 创建机制清理篮子("莫尔特斯"),
    玩家腐败值表: {},
    玩家腐败值单位表: {},
    根系觉醒已触发: false,
    腐朽领域已触发: false,
    下次沼泽腐败时间: 0,
    下次沼泽根须时间: 0,
    下次虫群时间: 0,
    下次腐败传输档位: 95,
    腐败护盾值: 0,
  };
  设置单位技能壳普通提示(boss, 莫尔特斯单位技能配置.主动技能提示);
  莫尔特斯上下文表[id] = context;
  return context;
}

export function 获取全部莫尔特斯上下文(this: void): 莫尔特斯运行时上下文[] {
  const result: 莫尔特斯运行时上下文[] = [];
  for (const key in 莫尔特斯上下文表) {
    const context = 莫尔特斯上下文表[key];
    if (context != null) result.push(context);
  }
  return result;
}

export function 清理莫尔特斯上下文(this: void, boss: any): void {
  const id = 取单位ID(boss);
  if (id === 0) return;
  const context = 莫尔特斯上下文表[id];
  if (context != null) context.清理.清理全部();
  delete 莫尔特斯上下文表[id];
}

export function 取莫尔特斯当前阶段(this: void, boss: any): 莫尔特斯阶段 {
  if (!单位有效(boss)) return 1;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 1;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  if (ratio <= 0.4) return 3;
  if (ratio <= 0.7) return 2;
  return 1;
}

export function 刷新莫尔特斯阶段(this: void, context: 莫尔特斯运行时上下文): 莫尔特斯阶段 {
  context.阶段 = 取莫尔特斯当前阶段(context.Boss单位);
  return context.阶段;
}

export function 刷新玩家腐败值Buff(this: void, _context: 莫尔特斯运行时上下文, unit: any, stack?: number): void {
  const current = stack ?? 0;
  if (current <= 0) {
    移除单位指定Buff(unit, 莫尔特斯BuffID.腐败值);
    return;
  }
  registerManualBuff(unit, 莫尔特斯BuffID.腐败值, 莫尔特斯数值与表现配置.腐败值.Buff显示秒, current, {
    stack: current,
    sourceName: "莫尔特斯-腐败值",
  });
}

export function 取玩家腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any): number {
  const id = 取单位ID(unit);
  return id === 0 ? 0 : (context.玩家腐败值表[id] ?? 0);
}

export function 设置玩家腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, value: number): number {
  const id = 取单位ID(unit);
  if (id === 0) return 0;
  const cfg = 莫尔特斯数值与表现配置.腐败值;
  let next = value;
  if (next < 0) next = 0;
  if (next > cfg.上限) next = cfg.上限;
  context.玩家腐败值表[id] = next;
  context.玩家腐败值单位表[id] = unit;
  刷新玩家腐败值Buff(context, unit, next);
  const owner = GetOwningPlayer(unit);
  if (owner != null && owner !== 0) YDUserDataSetSafe("player", owner, "腐败值", "real", next);
  return next;
}

export function 增加玩家腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, amount: number): number {
  const oldValue = 取玩家腐败值(context, unit);
  const next = 设置玩家腐败值(context, unit, oldValue + amount);
  return next;
}

export function 清除玩家腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, amount: number): number {
  return 设置玩家腐败值(context, unit, 取玩家腐败值(context, unit) - amount);
}

export function 取腐败值最高玩家(this: void, context: 莫尔特斯运行时上下文): any {
  let best: any = null;
  let bestValue = -1;
  for (const key in context.玩家腐败值表) {
    const value = context.玩家腐败值表[key] ?? 0;
    const unit = context.玩家腐败值单位表[key];
    if (!单位有效(unit)) continue;
    if (value > bestValue) {
      bestValue = value;
      best = unit;
    }
  }
  return best;
}

export function 刷新Boss腐败护盾Buff(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.腐败护盾值 <= 0) {
    if (单位有效(boss)) 移除单位指定Buff(boss, 莫尔特斯BuffID.腐败护盾);
    return;
  }
  registerManualBuff(boss, 莫尔特斯BuffID.腐败护盾, 莫尔特斯数值与表现配置.腐败传输.护盾持续秒, context.腐败护盾值, {
    stack: context.腐败护盾值,
    sourceName: "莫尔特斯-腐败护盾",
  });
}

export function 注册莫尔特斯运行时(this: void): void {
}
