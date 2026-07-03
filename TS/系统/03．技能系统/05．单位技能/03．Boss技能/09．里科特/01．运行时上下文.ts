/** @noSelfInFile */

import { 设置单位技能壳普通提示 } from "../../../00．技能模板+函数/02．通用函数/15．单位技能壳提示";
import { 创建机制清理篮子, type 机制清理篮子 } from "../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 里科特单位技能配置 } from "./00．配置";
import { 里科特数值与表现配置 } from "./02．数值与表现配置";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

export type 里科特阶段 = 1 | 2 | 3;

export interface 里科特运行时上下文 {
  Boss单位: any;
  阶段: 里科特阶段;
  已初始化: boolean;
  清理: 机制清理篮子;
  神风护体层数: number;
  神风印记表: Record<number, number | undefined>;
  神风印记单位表: Record<number, any>;
  破魔反击中: boolean;
}

const 里科特上下文表: Record<number, 里科特运行时上下文 | undefined> = {};

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 获取里科特上下文(this: void, boss: any): 里科特运行时上下文 | undefined {
  const id = 取单位ID(boss);
  return id === 0 ? undefined : 里科特上下文表[id];
}

export function 获取或创建里科特上下文(this: void, boss: any): 里科特运行时上下文 | undefined {
  const id = 取单位ID(boss);
  if (id === 0) return undefined;
  let context = 里科特上下文表[id];
  if (context != null) return context;
  context = {
    Boss单位: boss,
    阶段: 取里科特当前阶段(boss),
    已初始化: false,
    清理: 创建机制清理篮子("里科特"),
    神风护体层数: 0,
    神风印记表: {},
    神风印记单位表: {},
    破魔反击中: false,
  };
  设置单位技能壳普通提示(boss, 里科特单位技能配置.主动技能提示);
  里科特上下文表[id] = context;
  return context;
}

export function 获取全部里科特上下文(this: void): 里科特运行时上下文[] {
  const result: 里科特运行时上下文[] = [];
  for (const key in 里科特上下文表) {
    const context = 里科特上下文表[key];
    if (context != null) result.push(context);
  }
  return result;
}

export function 清理里科特上下文(this: void, boss: any): void {
  const id = 取单位ID(boss);
  if (id === 0) return;
  const context = 里科特上下文表[id];
  if (context != null) context.清理.清理全部();
  delete 里科特上下文表[id];
}

export function 取里科特当前阶段(this: void, boss: any): 里科特阶段 {
  if (boss == null || boss === 0) return 1;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 1;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  if (ratio <= 里科特数值与表现配置.阶段阈值.P3生命比例) return 3;
  if (ratio <= 里科特数值与表现配置.阶段阈值.P2生命比例) return 2;
  return 1;
}

export function 刷新里科特阶段(this: void, context: 里科特运行时上下文): 里科特阶段 {
  context.阶段 = 取里科特当前阶段(context.Boss单位);
  return context.阶段;
}

export function 增加里科特神风印记(this: void, context: 里科特运行时上下文, unit: any, amount: number = 1): number {
  const id = 取单位ID(unit);
  if (id === 0) return 0;
  const next = (context.神风印记表[id] ?? 0) + amount;
  context.神风印记表[id] = next;
  context.神风印记单位表[id] = unit;
  return next;
}

export function 取里科特神风印记(this: void, context: 里科特运行时上下文, unit: any): number {
  const id = 取单位ID(unit);
  return id === 0 ? 0 : (context.神风印记表[id] ?? 0);
}

export function 清除里科特神风印记(this: void, context: 里科特运行时上下文, unit: any): void {
  const id = 取单位ID(unit);
  if (id !== 0) {
    delete context.神风印记表[id];
    delete context.神风印记单位表[id];
  }
}

export function 注册里科特运行时(this: void): void {
}
