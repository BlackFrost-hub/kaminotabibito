/** @noSelfInFile */

import type { 攻击效果配置项, 攻击效果上下文 } from "./00．公共/00．攻击效果类型";
import { 获取攻击效果配置列表 } from "./00．公共/02．攻击效果注册表";
import {
  单位持有攻击效果装备,
  单位有效存活,
  单位是精英目标,
  攻击者类型满足,
  是否攻击效果全局跳过,
  距离满足限制,
  命中概率通过,
  取攻击力,
  取力量,
  取当前生命,
  取最大生命,
  取最大魔法,
  攻击效果造成伤害,
  攻击效果治疗生命魔法,
  攻击效果减少生命魔法,
  获取敌方范围单位,
  播放目标特效,
  播放单位坐标特效,
  施加攻击效果减速,
  施加攻击效果眩晕,
  施加攻击效果击飞,
  临时修改攻速,
  临时修改护甲,
} from "./00．公共/01．攻击效果工具";

const { registerAppliedFinalDamageListener, 延后一帧执行伤害派生效果 } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
  延后一帧执行伤害派生效果: (this: void, cb: (this: void) => void) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

interface 延迟伤害记录 {
  source: any;
  target: any;
  amount: number;
  damageType: any;
}

interface 持续伤害记录 {
  source: any;
  target: any;
  amount: number;
  damageType: any;
  nextTime: number;
  remainTicks: number;
  intervalMs: number;
  slow: number;
  effect: string;
}

interface 临时属性记录 {
  unit: any;
  type: "攻速" | "护甲";
  value: number;
}

const 延迟伤害队列: 延迟伤害记录[] = [];
const 持续伤害列表: 持续伤害记录[] = [];
const 临时属性队列: 临时属性记录[] = [];
const 攻击效果冷却: Record<string, number> = {};

let 已初始化 = false;
let 持续伤害Tick已注册 = false;

function 绝对值(this: void, value: number): number {
  return value < 0 ? -value : value;
}

function 向下取整(this: void, value: number): number {
  const jass = require("jass.common") as any;
  const R2I = jass.R2I as (r: number) => number;
  return R2I(value);
}

function 取冷却键(this: void, 配置: 攻击效果配置项, unit: any): string {
  const jass = require("jass.common") as any;
  const GetHandleId = jass.GetHandleId as (h: any) => number;
  if (unit == null || unit === 0) return "";
  return 配置.装备名 + ":" + GetHandleId(unit);
}

function 冷却通过(this: void, 配置: 攻击效果配置项, unit: any): boolean {
  if (配置.冷却毫秒 == null || 配置.冷却毫秒 <= 0) return true;
  const key = 取冷却键(配置, unit);
  if (key === "") return false;
  const now = getServerTime();
  const last = 攻击效果冷却[key];
  if (last != null && now - last < 配置.冷却毫秒) return false;
  攻击效果冷却[key] = now;
  return true;
}

function 基础条件通过(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): boolean {
  if (!单位有效存活(ctx.source) || !单位有效存活(ctx.target)) return false;
  if (配置.仅普通攻击 === true && !(ctx.snapshot != null && ctx.snapshot.isNormalAttack === true)) return false;
  if (配置.仅物理 === true && !(ctx.snapshot != null && ctx.snapshot.isPhysicalDamage === true)) return false;
  if (!攻击者类型满足(ctx.source, 配置.攻击者类型)) return false;
  if (!距离满足限制(ctx.source, ctx.target, 配置.最小距离, 配置.最大距离)) return false;
  if (!命中概率通过(配置.概率)) return false;
  if (!冷却通过(配置, ctx.source)) return false;
  return true;
}

function 计算伤害(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): number {
  let amount = 配置.固定伤害 ?? 0;
  if (配置.攻击系数 != null) amount += 取攻击力(ctx.source) * 配置.攻击系数;
  if (配置.力量系数 != null) amount += 取力量(ctx.source) * 配置.力量系数;
  if (配置.生命系数 != null) amount += 取最大生命(ctx.target) * 配置.生命系数;
  if (配置.伤害倍率 != null) amount += ctx.applied * 配置.伤害倍率;
  return amount;
}

function 执行反击伤害(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  const amount = 计算伤害(配置, { source: ctx.target, target: ctx.source, applied: ctx.applied, snapshot: ctx.snapshot });
  攻击效果造成伤害(ctx.target, ctx.source, amount, 配置.伤害类型);
}

function 执行额外伤害(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  const amount = 计算伤害(配置, ctx);
  const 资源偷取同时造成伤害 = 配置.固定伤害 != null || 配置.攻击系数 != null || 配置.力量系数 != null || 配置.生命系数 != null;
  if (配置.效果类型 !== "资源偷取" || 资源偷取同时造成伤害) {
    攻击效果造成伤害(ctx.source, ctx.target, amount, 配置.伤害类型);
  }
  if ((配置.治疗生命 ?? 0) > 0 || (配置.恢复魔法 ?? 0) > 0) {
    攻击效果治疗生命魔法(ctx.source, ctx.source, 配置.治疗生命 ?? 0, 配置.恢复魔法 ?? 0);
  }
  if ((配置.抽取生命比例 ?? 0) > 0 || (配置.抽取魔法比例 ?? 0) > 0) {
    const life = 取最大生命(ctx.target) * (配置.抽取生命比例 ?? 0);
    const mana = 取最大魔法(ctx.target) * (配置.抽取魔法比例 ?? 0);
    攻击效果减少生命魔法(ctx.target, life, mana);
    攻击效果治疗生命魔法(ctx.source, ctx.source, life, mana);
  }
  if (配置.效果类型 === "资源偷取" && (配置.伤害倍率 ?? 0) > 0) {
    const steal = ctx.applied * (配置.伤害倍率 ?? 0);
    攻击效果减少生命魔法(ctx.target, 0, steal);
    攻击效果治疗生命魔法(ctx.source, ctx.source, steal, 0);
  }
}

function 执行范围伤害(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  const radius = 配置.范围 ?? 0;
  if (!(radius > 0)) return;
  const list = 获取敌方范围单位(ctx.source, ctx.target, radius, true);
  const amount = 计算伤害(配置, ctx);
  for (let i = 0; i < list.length; i++) {
    攻击效果造成伤害(ctx.source, list[i], amount, 配置.伤害类型);
  }
}

function 注册持续伤害Tick(this: void): void {
  if (持续伤害Tick已注册) return;
  持续伤害Tick已注册 = true;
  addPeriodicCallback(100, on攻击效果持续伤害Tick);
}

function 执行持续伤害(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  const duration = 配置.持续时间 ?? 0;
  const interval = 配置.间隔 ?? 1;
  if (!(duration > 0) || !(interval > 0)) return;
  const ticks = 向下取整(duration / interval);
  if (!(ticks > 0)) return;
  持续伤害列表.push({
    source: ctx.source,
    target: ctx.target,
    amount: 计算伤害(配置, ctx),
    damageType: 配置.伤害类型,
    nextTime: getServerTime() + interval * 1000,
    remainTicks: ticks,
    intervalMs: interval * 1000,
    slow: 配置.减速 ?? 0,
    effect: 配置.特效 ?? "",
  });
  注册持续伤害Tick();
  if ((配置.减速 ?? 0) > 0) {
    施加攻击效果减速(ctx.source, ctx.target, 配置.减速 ?? 0, duration);
  }
}

function 执行低血斩杀(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  const maxLife = 取最大生命(ctx.target);
  if (!(maxLife > 0)) return;
  const line = 单位是精英目标(ctx.target) ? (配置.精英斩杀线 ?? 配置.普通斩杀线 ?? 0) : (配置.普通斩杀线 ?? 0);
  if (!(line > 0)) return;
  if (取当前生命(ctx.target) / maxLife > line) return;
  攻击效果造成伤害(ctx.source, ctx.target, maxLife, 配置.伤害类型);
}

function 执行范围击飞(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  const radius = 配置.范围 ?? 0;
  const list = 获取敌方范围单位(ctx.source, ctx.target, radius, true);
  const amount = 计算伤害(配置, ctx);
  for (let i = 0; i < list.length; i++) {
    const unit = list[i];
    攻击效果造成伤害(ctx.source, unit, amount, 配置.伤害类型);
    施加攻击效果击飞(ctx.source, unit, 配置.持续时间 ?? 1.5);
    施加攻击效果眩晕(ctx.source, unit, 配置.持续时间 ?? 1.5);
  }
}

function 执行临时攻速(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  const value = 配置.攻速加成 ?? 0;
  if (value === 0) return;
  临时修改攻速(ctx.source, value);
  临时属性队列.push({ unit: ctx.source, type: "攻速", value: -value });
  addDelayedCallback((配置.持续时间 ?? 2) * 1000, on攻击效果临时属性结束);
  执行范围伤害(配置, ctx);
}

function 执行护甲削减(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  const value = 绝对值(配置.固定伤害 ?? 0);
  if (!(value > 0)) return;
  临时修改护甲(ctx.target, -value);
  临时属性队列.push({ unit: ctx.target, type: "护甲", value });
  addDelayedCallback((配置.持续时间 ?? 5) * 1000, on攻击效果临时属性结束);
}

function 执行攻击效果配置(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  if (配置.触发侧 === "攻击者" && !单位持有攻击效果装备(ctx.source, 配置.装备名)) return;
  if (配置.触发侧 === "受击者" && !单位持有攻击效果装备(ctx.target, 配置.装备名)) return;
  if (!基础条件通过(配置, ctx)) return;
  const effectCtx = 配置.触发侧 === "受击者" && 配置.效果类型 !== "反击伤害"
    ? { source: ctx.target, target: ctx.source, applied: ctx.applied, snapshot: ctx.snapshot }
    : ctx;
  if (配置.特效 != null && 配置.特效 !== "") 播放目标特效(effectCtx.target, 配置.特效);
  if (配置.点特效 != null && 配置.点特效 !== "") 播放单位坐标特效(effectCtx.target, 配置.点特效, 配置.点特效缩放);

  if (配置.效果类型 === "反击伤害") 执行反击伤害(配置, ctx);
  else if (配置.效果类型 === "额外伤害") 执行额外伤害(配置, effectCtx);
  else if (配置.效果类型 === "范围伤害") 执行范围伤害(配置, effectCtx);
  else if (配置.效果类型 === "持续伤害") 执行持续伤害(配置, effectCtx);
  else if (配置.效果类型 === "低血斩杀") 执行低血斩杀(配置, effectCtx);
  else if (配置.效果类型 === "范围击飞") 执行范围击飞(配置, effectCtx);
  else if (配置.效果类型 === "临时攻速") 执行临时攻速(配置, effectCtx);
  else if (配置.效果类型 === "护甲削减") 执行护甲削减(配置, effectCtx);
  else if (配置.效果类型 === "资源偷取") 执行额外伤害(配置, effectCtx);
}

function on攻击效果最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied >= 1)) return;
  if (snapshot != null && snapshot.isTrueDamage === true) return;
  if (snapshot != null && snapshot.isNormalAttack !== true && snapshot.isSkillAttack !== true) return;
  if (是否攻击效果全局跳过(attacker, snapshot)) return;
  const ctx: 攻击效果上下文 = { source: attacker, target, applied, snapshot };
  const list = 获取攻击效果配置列表();
  for (let i = 0; i < list.length; i++) {
    const cfg = list[i];
    if (cfg == null || cfg.触发侧 === "伤害修正") continue;
    执行攻击效果配置(cfg, ctx);
  }
}

function on攻击效果伤害修正(this: void, context: any): number {
  let result = context.currentDamage;
  if (!(result >= 1)) return result;
  if (context.isTrueDamage === true) return result;
  if (是否攻击效果全局跳过(context.attacker)) return result;
  const list = 获取攻击效果配置列表();
  for (let i = 0; i < list.length; i++) {
    const cfg = list[i];
    if (cfg == null || cfg.触发侧 !== "伤害修正") continue;
    if (cfg.效果类型 !== "转换火焰伤害") continue;
    if (context.isNormalAttack !== true || context.isPhysicalDamage !== true) continue;
    if (!攻击者类型满足(context.attacker, cfg.攻击者类型)) continue;
    if (!单位持有攻击效果装备(context.attacker, cfg.装备名)) continue;
    const amount = result * (cfg.伤害倍率 ?? 0.8);
    if (amount > 0) {
      延迟伤害队列.push({ source: context.attacker, target: context.target, amount, damageType: cfg.伤害类型 });
      延后一帧执行伤害派生效果(on攻击效果延迟伤害);
    }
    result = 0;
  }
  return result;
}

function on攻击效果延迟伤害(this: void): void {
  while (延迟伤害队列.length > 0) {
    const record = 延迟伤害队列.shift();
    if (record == null) continue;
    攻击效果造成伤害(record.source, record.target, record.amount, record.damageType);
  }
}

function on攻击效果持续伤害Tick(this: void): void {
  const now = getServerTime();
  let write = 0;
  for (let i = 0; i < 持续伤害列表.length; i++) {
    const record = 持续伤害列表[i];
    if (record == null || !单位有效存活(record.source) || !单位有效存活(record.target) || record.remainTicks <= 0) continue;
    if (now >= record.nextTime) {
      if (record.effect !== "") 播放目标特效(record.target, record.effect);
      攻击效果造成伤害(record.source, record.target, record.amount, record.damageType);
      record.remainTicks -= 1;
      record.nextTime = now + record.intervalMs;
    }
    if (record.remainTicks > 0) {
      持续伤害列表[write] = record;
      write++;
    }
  }
  while (持续伤害列表.length > write) 持续伤害列表.pop();
}

function on攻击效果临时属性结束(this: void): void {
  const record = 临时属性队列.shift();
  if (record == null) return;
  if (record.type === "攻速") 临时修改攻速(record.unit, record.value);
  else 临时修改护甲(record.unit, record.value);
}

export function init攻击效果事件(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  registerAppliedFinalDamageListener(on攻击效果最终伤害);
  registerDamageModifier(on攻击效果伤害修正, 30);
}

init攻击效果事件();

export {};
