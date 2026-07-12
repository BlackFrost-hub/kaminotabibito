/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import type { 动态装饰物安全区组 } from "../../../../00．技能模板+函数/04．机制组件/02．战斗区域/06．动态装饰物安全区组";
import { 卡瑟拉单位技能配置 } from "./00．配置";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";

const jass = require("jass.common") as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉") as {
  卡瑟拉BuffID: { 触手残片: string };
};

export type 卡瑟拉阶段 = 1 | 2 | 3;

export interface 卡瑟拉地面触手残片 {
  X: number;
  Y: number;
  特效?: any;
  已吸收?: boolean;
}

export interface 卡瑟拉绝缘珊瑚点 {
  X: number;
  Y: number;
  半径: number;
  装饰单位?: any;
}

export interface 卡瑟拉运行时上下文 {
  Boss单位: any;
  阶段: 卡瑟拉阶段;
  已初始化: boolean;
  清理: 机制清理篮子;
  触手残片数量: number;
  玩家触手残片表: Record<number, number | undefined>;
  玩家触手残片单位表: Record<number, any>;
  场上触手残片列表: 卡瑟拉地面触手残片[];
  绝缘珊瑚列表: 卡瑟拉绝缘珊瑚点[];
  绝缘珊瑚安全区组?: 动态装饰物安全区组;
  触手解放已触发: boolean;
  Boss潜入中: boolean;
  上次触手再生档位: number;
  下次深渊召唤时间: number;
  下次共生电击时间: number;
  下次残片吸收时间: number;
  下次残片牵引时间: number;
  触手精华层数: number;
}

function 创建卡瑟拉上下文(this: void, boss: any, 清理: 机制清理篮子): 卡瑟拉运行时上下文 {
  return {
    Boss单位: boss,
    阶段: 取卡瑟拉当前阶段(boss),
    已初始化: false,
    清理,
    触手残片数量: 0,
    玩家触手残片表: {},
    玩家触手残片单位表: {},
    场上触手残片列表: [],
    绝缘珊瑚列表: [],
    触手解放已触发: false,
    Boss潜入中: false,
    上次触手再生档位: 10,
    下次深渊召唤时间: 0,
    下次共生电击时间: 0,
    下次残片吸收时间: 0,
    下次残片牵引时间: 0,
    触手精华层数: 0,
  };
}

const 卡瑟拉上下文工厂 = 创建单位运行时上下文工厂<卡瑟拉运行时上下文>({
  名称: "卡瑟拉",
  主动技能提示: 卡瑟拉单位技能配置.主动技能提示,
  创建上下文: 创建卡瑟拉上下文,
});

function 取单位ID(this: void, unit: any): number {
  return 卡瑟拉上下文工厂.取单位ID(unit);
}

export function 获取卡瑟拉上下文(this: void, boss: any): 卡瑟拉运行时上下文 | undefined {
  return 卡瑟拉上下文工厂.获取(boss);
}

export function 获取或创建卡瑟拉上下文(this: void, boss: any): 卡瑟拉运行时上下文 | undefined {
  return 卡瑟拉上下文工厂.获取或创建(boss);
}

export function 获取全部卡瑟拉上下文(this: void): 卡瑟拉运行时上下文[] {
  return 卡瑟拉上下文工厂.获取全部();
}

export function 清理卡瑟拉上下文(this: void, boss: any): void {
  卡瑟拉上下文工厂.清理上下文(boss);
}

export function 取卡瑟拉当前阶段(this: void, boss: any): 卡瑟拉阶段 {
  if (boss == null || boss === 0) return 1;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 1;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  if (ratio <= 卡瑟拉数值与表现配置.阶段阈值.P3生命比例) return 3;
  if (ratio <= 卡瑟拉数值与表现配置.阶段阈值.P2生命比例) return 2;
  return 1;
}

export function 刷新卡瑟拉阶段(this: void, context: 卡瑟拉运行时上下文): 卡瑟拉阶段 {
  context.阶段 = 取卡瑟拉当前阶段(context.Boss单位);
  return context.阶段;
}

export function 增加玩家触手残片(this: void, context: 卡瑟拉运行时上下文, unit: any, amount: number = 1): number {
  const id = 取单位ID(unit);
  if (id === 0) return 0;
  const max = 卡瑟拉数值与表现配置.触手残片.玩家持有上限;
  let next = (context.玩家触手残片表[id] ?? 0) + amount;
  if (next > max) next = max;
  if (next < 0) next = 0;
  context.玩家触手残片表[id] = next;
  context.玩家触手残片单位表[id] = unit;
  刷新玩家触手残片Buff(context, unit, next);
  return next;
}

export function 设置玩家触手残片(this: void, context: 卡瑟拉运行时上下文, unit: any, amount: number): number {
  const id = 取单位ID(unit);
  if (id === 0) return 0;
  const max = 卡瑟拉数值与表现配置.触手残片.玩家持有上限;
  let next = amount;
  if (next > max) next = max;
  if (next < 0) next = 0;
  context.玩家触手残片表[id] = next;
  context.玩家触手残片单位表[id] = unit;
  刷新玩家触手残片Buff(context, unit, next);
  return next;
}

export function 刷新玩家触手残片Buff(this: void, _context: 卡瑟拉运行时上下文, unit: any, stack?: number): void {
  const current = stack != null ? stack : 0;
  if (current <= 0) {
    移除单位指定Buff(unit, 卡瑟拉BuffID.触手残片);
    return;
  }
  registerManualBuff(unit, 卡瑟拉BuffID.触手残片, 120, current, {
    stack: current,
    sourceName: "卡瑟拉-触手残片",
  });
}

export function 取玩家触手残片(this: void, context: 卡瑟拉运行时上下文, unit: any): number {
  const id = 取单位ID(unit);
  return id === 0 ? 0 : (context.玩家触手残片表[id] ?? 0);
}

export function 消耗玩家触手残片(this: void, context: 卡瑟拉运行时上下文, unit: any, amount: number): boolean {
  const id = 取单位ID(unit);
  if (id === 0) return false;
  const current = context.玩家触手残片表[id] ?? 0;
  if (current < amount) return false;
  context.玩家触手残片表[id] = current - amount;
  context.玩家触手残片单位表[id] = unit;
  刷新玩家触手残片Buff(context, unit, current - amount);
  return true;
}

export function 注册卡瑟拉运行时(this: void): void {
}
