/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 造成伤害事件伤害, 伤害事件伤害类型 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;

const 月光锁链护腕控制Buff列表 = [
  "C001",
  "C002",
  "C003",
  "C004",
  "C005",
  "C006",
  "C007",
  "C008",
  "C009",
  "C023",
];
const 月光锁链护腕控制BuffID列表: number[] = [];
const 月光锁链护腕冷却表: Record<number, number | undefined> = {};
const 月光锁链护腕减伤到期表: Record<number, number | undefined> = {};
const 月光锁链护腕反伤队列: Array<{ source: any; target: any; amount: number }> = [];

function 初始化月光锁链护腕BuffID(this: void): void {
  if (月光锁链护腕控制BuffID列表.length > 0) return;
  for (let i = 0; i < 月光锁链护腕控制Buff列表.length; i++) {
    const id = stringToFourCCSafe(月光锁链护腕控制Buff列表[i]);
    if (id !== 0) 月光锁链护腕控制BuffID列表.push(id);
  }
}

function 单位处于控制中(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  初始化月光锁链护腕BuffID();
  for (let i = 0; i < 月光锁链护腕控制BuffID列表.length; i++) {
    if (GetUnitAbilityLevel(unit, 月光锁链护腕控制BuffID列表[i]) > 0) return true;
  }
  return false;
}

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 月光锁链护腕冷却通过(this: void, unitId: number): boolean {
  if (unitId === 0) return false;
  const now = getServerTime();
  const last = 月光锁链护腕冷却表[unitId];
  if (last != null && now - last < 12000) return false;
  月光锁链护腕冷却表[unitId] = now;
  月光锁链护腕减伤到期表[unitId] = now + 2000;
  return true;
}

function 月光锁链护腕减伤中(this: void, unitId: number): boolean {
  if (unitId === 0) return false;
  const end = 月光锁链护腕减伤到期表[unitId];
  return end != null && getServerTime() < end;
}

function 执行月光锁链护腕反伤(this: void): void {
  while (月光锁链护腕反伤队列.length > 0) {
    const item = 月光锁链护腕反伤队列.shift();
    if (item == null) continue;
    造成伤害事件伤害(item.source, item.target, item.amount, 伤害事件伤害类型.强化);
  }
}

export function 处理月光锁链护腕伤害修正(this: void, context: any): number {
  const target = context.target;
  const attacker = context.attacker;
  if (target == null || target === 0 || attacker == null || attacker === 0) return context.currentDamage;
  if (!单位持有伤害事件装备(target, 伤害事件装备ID.月光锁链护腕)) return context.currentDamage;

  const targetId = 取单位句柄ID(target);
  if (单位处于控制中(target) && 月光锁链护腕冷却通过(targetId)) {
    月光锁链护腕反伤队列.push({ source: target, target: attacker, amount: context.currentDamage * 0.3 });
    addDelayedCallback(1, 执行月光锁链护腕反伤);
  }

  if (!月光锁链护腕减伤中(targetId)) return context.currentDamage;
  return context.currentDamage * 0.7;
}

export {};
