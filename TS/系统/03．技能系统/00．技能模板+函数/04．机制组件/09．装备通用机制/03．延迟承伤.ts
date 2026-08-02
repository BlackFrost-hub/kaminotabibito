/** @noSelfInFile */

import type { 自适应共享周期驱动 } from "../10．复杂战斗通用机制/17．周期机制调度器";

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, cb: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 创建自适应共享周期驱动 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器") as {
  创建自适应共享周期驱动: (this: void, 参数: any) => 自适应共享周期驱动;
};
const { 减少生命值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, lowestLife?: number) => number;
};

export interface 延迟承伤参数 {
  名称?: string;
  单位?: any;
  减免比例: number;
  持续秒: number;
  跳数?: number;
  跳间隔毫秒?: number;
  优先级?: number;
  显示扣血?: boolean;
  扣血特效?: string;
  过滤伤害?: (this: void, context: any) => boolean;
}

export interface 延迟承伤控制器 {
  readonly 名称: string;
  停止(): void;
}

interface 延迟扣血记录 {
  目标: any;
  每跳伤害: number;
  剩余跳数: number;
  下次毫秒: number;
  间隔毫秒: number;
  显示扣血: boolean;
  扣血特效?: string;
}

const 延迟承伤表: Record<number, 延迟承伤实现> = {};
let 延迟承伤计数 = 0;
let 延迟承伤修正器ID = 0;
let 延迟扣血驱动: 自适应共享周期驱动 | undefined;
const 延迟扣血队列: 延迟扣血记录[] = [];

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, 单位: any): number {
  if (!单位有效(单位)) return 0;
  return GetHandleId(单位) || 0;
}

function 确保延迟承伤修正器(this: void, priority: number): void {
  if (延迟承伤修正器ID !== 0) return;
  延迟承伤修正器ID = registerDamageModifier(on延迟承伤修正, priority);
}

function 确保延迟扣血Tick(this: void): void {
  if (延迟扣血驱动 == null) {
    延迟扣血驱动 = 创建自适应共享周期驱动({
      名称: "延迟承伤扣血驱动",
      最大检查间隔毫秒: 100,
      取建议检查间隔毫秒: 取延迟扣血建议检查间隔,
      onTick: on延迟扣血Tick,
    });
  }
  延迟扣血驱动.刷新();
}

function 尝试停止延迟承伤系统(this: void): void {
  let hasController = false;
  for (const key in 延迟承伤表) {
    if (延迟承伤表[key] != null) hasController = true;
  }
  if (!hasController && 延迟承伤修正器ID !== 0) {
    unregisterDamageModifier(延迟承伤修正器ID);
    延迟承伤修正器ID = 0;
  }
  if (延迟扣血驱动 != null) 延迟扣血驱动.刷新();
}

class 延迟承伤实现 implements 延迟承伤控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 延迟承伤参数;
  private 已停止 = false;

  constructor(名称: string, 参数: 延迟承伤参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.控制器ID = ++延迟承伤计数;
    延迟承伤表[this.控制器ID] = this;
    确保延迟承伤修正器(参数.优先级 ?? 40);
  }

  修正(context: any): number {
    if (this.已停止 || context.currentDamage <= 0) return context.currentDamage;
    if (!单位有效(context.target)) return context.currentDamage;
    if (this.参数.单位 != null && 取单位ID(this.参数.单位) !== 取单位ID(context.target)) return context.currentDamage;
    if (this.参数.过滤伤害 != null && !this.参数.过滤伤害(context)) return context.currentDamage;
    let ratio = this.参数.减免比例;
    if (ratio <= 0) return context.currentDamage;
    if (ratio > 1) ratio = 1;
    const delayed = context.currentDamage * ratio;
    this.登记延迟扣血(context.target, delayed);
    return context.currentDamage - delayed;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 延迟承伤表[this.控制器ID];
    尝试停止延迟承伤系统();
  }

  private 登记延迟扣血(target: any, amount: number): void {
    if (amount <= 0) return;
    const ticks = this.参数.跳数 != null && this.参数.跳数 > 0 ? this.参数.跳数 : 10;
    const interval = this.参数.跳间隔毫秒 != null && this.参数.跳间隔毫秒 > 0
      ? this.参数.跳间隔毫秒
      : (this.参数.持续秒 * 1000) / ticks;
    延迟扣血队列.push({
      目标: target,
      每跳伤害: amount / ticks,
      剩余跳数: ticks,
      下次毫秒: getServerTime() + interval,
      间隔毫秒: interval,
      显示扣血: this.参数.显示扣血 !== false,
      扣血特效: this.参数.扣血特效,
    });
    确保延迟扣血Tick();
  }
}

export function 创建延迟承伤(this: void, 参数: 延迟承伤参数): 延迟承伤控制器 {
  return new 延迟承伤实现(参数.名称 ?? "延迟承伤", 参数);
}

function on延迟承伤修正(this: void, context: any): number {
  let damage = context.currentDamage;
  for (const key in 延迟承伤表) {
    const 控制器 = 延迟承伤表[key];
    if (控制器 == null) continue;
    context.currentDamage = damage;
    damage = 控制器.修正(context);
  }
  return damage;
}

function 取延迟扣血建议检查间隔(this: void, _nowMs: number): number {
  let 最短间隔 = 0;
  for (let i = 0; i < 延迟扣血队列.length; i++) {
    const 间隔 = 延迟扣血队列[i].间隔毫秒;
    if (间隔 > 0 && (最短间隔 === 0 || 间隔 < 最短间隔)) 最短间隔 = 间隔;
  }
  return 最短间隔;
}

function on延迟扣血Tick(this: void, now: number): void {
  for (let i = 延迟扣血队列.length - 1; i >= 0; i--) {
    const 记录 = 延迟扣血队列[i];
    if (now < 记录.下次毫秒) continue;
    if (单位有效(记录.目标)) {
      减少生命值(记录.目标, 记录.每跳伤害, 记录.显示扣血, 记录.扣血特效 != null && 记录.扣血特效 !== "", 记录.扣血特效, 1);
    }
    记录.剩余跳数 -= 1;
    if (记录.剩余跳数 <= 0) {
      延迟扣血队列.splice(i, 1);
    } else {
      记录.下次毫秒 = now + 记录.间隔毫秒;
    }
  }
  尝试停止延迟承伤系统();
}
