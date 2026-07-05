/** @noSelfInFile */

import type { 配置型攻击效果配置, 配置型攻击效果上下文, 配置型攻击效果伤害类型 } from "./00．类型定义";
import { 计算配置型攻击效果伤害 } from "./02．伤害计算";
import {
  配置型攻击效果造成伤害,
  配置型单位有效存活,
  配置型播放目标特效,
  配置型施加减速,
} from "./01．基础工具";
const { 计算持续伤害最终值 } = require("系统.04．伤害系统.07．持续伤害系统") as {
  计算持续伤害最终值: (this: void, source: any, amount: number) => number;
};

const jass = require("jass.common") as any;
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const R2I = jass.R2I as (r: number) => number;

interface 配置型持续伤害记录 {
  source: any;
  target: any;
  amount: number;
  damageType?: 配置型攻击效果伤害类型;
  nextTime: number;
  remainTicks: number;
  intervalMs: number;
  effect: string;
}

const 配置型持续伤害列表: 配置型持续伤害记录[] = [];
let 配置型持续伤害Tick已注册 = false;

function 注册配置型持续伤害Tick(this: void): void {
  if (配置型持续伤害Tick已注册) return;
  配置型持续伤害Tick已注册 = true;
  addPeriodicCallback(100, on配置型持续伤害Tick);
}

function on配置型持续伤害Tick(this: void): void {
  const now = getServerTime();
  let write = 0;
  for (let i = 0; i < 配置型持续伤害列表.length; i++) {
    const record = 配置型持续伤害列表[i];
    if (record == null || !配置型单位有效存活(record.source) || !配置型单位有效存活(record.target) || record.remainTicks <= 0) continue;
    if (now >= record.nextTime) {
      if (record.effect !== "") 配置型播放目标特效(record.target, record.effect);
      const finalAmount = 计算持续伤害最终值(record.source, record.amount);
      if (finalAmount > 0) 配置型攻击效果造成伤害(record.source, record.target, finalAmount, record.damageType, { 伤害形态: "单体", 装备技能类型: "装备持续伤害" });
      record.remainTicks -= 1;
      record.nextTime = now + record.intervalMs;
    }
    if (record.remainTicks > 0) {
      配置型持续伤害列表[write] = record;
      write++;
    }
  }
  while (配置型持续伤害列表.length > write) 配置型持续伤害列表.pop();
}

export function 执行配置型持续伤害(this: void, 配置: 配置型攻击效果配置, ctx: 配置型攻击效果上下文): void {
  const duration = 配置.持续时间 ?? 0;
  const interval = 配置.间隔 ?? 1;
  if (!(duration > 0) || !(interval > 0)) return;
  const ticks = R2I(duration / interval);
  if (!(ticks > 0)) return;
  配置型持续伤害列表.push({
    source: ctx.source,
    target: ctx.target,
    amount: 计算配置型攻击效果伤害(配置, ctx),
    damageType: 配置.伤害类型,
    nextTime: getServerTime() + interval * 1000,
    remainTicks: ticks,
    intervalMs: interval * 1000,
    effect: 配置.特效 ?? "",
  });
  注册配置型持续伤害Tick();
  if ((配置.减速 ?? 0) > 0) {
    配置型施加减速(ctx.source, ctx.target, 配置.减速 ?? 0, duration);
  }
}

export {};
