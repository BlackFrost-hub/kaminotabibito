/** @noSelfInFile */

import type { Boss战运行上下文 } from "./01．Boss战运行上下文";
import type { Boss护卫血条归属类型, Boss血条弱点韧性运行状态 } from "../03．Boss血条弱点韧性/00．类型";
import { Boss战斗启动护卫配置表 } from "../00．战斗启动属性/05．Boss战斗启动护卫配置表";
import { Boss护卫血条UI常量 } from "../03．Boss血条弱点韧性/01．常量定义";
import {
  启动Boss护卫血条弱点韧性,
  结束Boss护卫血条弱点韧性,
} from "../03．Boss血条弱点韧性/07．Boss弱点事件桥接";
import { 获取全部Boss血条弱点韧性运行状态 } from "../03．Boss血条弱点韧性/05．Boss弱点运行状态";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};

const { 获取Boss护卫列表, 获取护卫记录 } = require("系统.01．单位系统.10．护卫系统.index") as {
  获取Boss护卫列表: (this: void, boss: any, 只返回存活?: boolean) => any[];
  获取护卫记录: (this: void, unit: any) => {
    护卫单位: any;
    主Boss单位: any;
    护卫血条优先级: number;
    登记顺序: number;
  } | undefined;
};

interface 护卫血条候选 {
  unit: any;
  handleId: number;
  优先级: number;
  登记顺序: number;
  Boss战上下文: Boss战运行上下文;
  归属类型: Boss护卫血条归属类型;
}

function 获取护卫血条归属类型(this: void, context: Boss战运行上下文): Boss护卫血条归属类型 {
  const bossTypeId = GetUnitTypeId(context.Boss单位) || 0;
  for (let i = 0; i < Boss战斗启动护卫配置表.length; i++) {
    const config = Boss战斗启动护卫配置表[i];
    if (stringToFourCCSafe(config.Boss单位ID) === bossTypeId) return config.护卫血条归属类型;
  }
  return "独立";
}

function 候选应排在前面(this: void, left: 护卫血条候选, right: 护卫血条候选): boolean {
  if (left.优先级 !== right.优先级) return left.优先级 > right.优先级;
  if (left.登记顺序 !== right.登记顺序) return left.登记顺序 < right.登记顺序;
  return left.handleId < right.handleId;
}

function 排序护卫血条候选(this: void, list: 护卫血条候选[]): void {
  for (let i = 1; i < list.length; i++) {
    const current = list[i];
    let insertIndex = i - 1;
    while (insertIndex >= 0 && 候选应排在前面(current, list[insertIndex])) {
      list[insertIndex + 1] = list[insertIndex];
      insertIndex--;
    }
    list[insertIndex + 1] = current;
  }
}

function 收集Boss护卫血条候选(
  this: void,
  context: Boss战运行上下文,
  归属类型: Boss护卫血条归属类型,
): 护卫血条候选[] {
  const result: 护卫血条候选[] = [];
  const guards = 获取Boss护卫列表(context.Boss单位, true);
  for (let i = 0; i < guards.length; i++) {
    const unit = guards[i];
    const record = 获取护卫记录(unit);
    const handleId = GetHandleId(unit) || 0;
    if (record == null || record.主Boss单位 !== context.Boss单位 || handleId === 0) continue;
    if (!(record.护卫血条优先级 > 0)) continue;
    result.push({
      unit,
      handleId,
      优先级: record.护卫血条优先级,
      登记顺序: record.登记顺序,
      Boss战上下文: context,
      归属类型,
    });
  }
  排序护卫血条候选(result);
  return result;
}

function 截取可显示候选(this: void, list: 护卫血条候选[]): 护卫血条候选[] {
  const result: 护卫血条候选[] = [];
  const count = list.length < Boss护卫血条UI常量.最大显示数量
    ? list.length
    : Boss护卫血条UI常量.最大显示数量;
  for (let i = 0; i < count; i++) result.push(list[i]);
  return result;
}

function 排序当前护卫血条状态(this: void, list: Boss血条弱点韧性运行状态[]): void {
  for (let i = 1; i < list.length; i++) {
    const current = list[i];
    let insertIndex = i - 1;
    while (insertIndex >= 0 && list[insertIndex].护卫槽位索引 > current.护卫槽位索引) {
      list[insertIndex + 1] = list[insertIndex];
      insertIndex--;
    }
    list[insertIndex + 1] = current;
  }
}

function 获取当前护卫血条状态(
  this: void,
  归属类型: Boss护卫血条归属类型,
  主Boss句柄ID: number,
): Boss血条弱点韧性运行状态[] {
  const result: Boss血条弱点韧性运行状态[] = [];
  const states = 获取全部Boss血条弱点韧性运行状态();
  for (let i = 0; i < states.length; i++) {
    const state = states[i];
    if (state.显示类型 !== "护卫" || state.是否已结束 || !state.是否血条已注册) continue;
    if (state.护卫血条归属类型 !== 归属类型) continue;
    if (归属类型 === "独立" && state.所属主Boss句柄ID !== 主Boss句柄ID) continue;
    result.push(state);
  }
  排序当前护卫血条状态(result);
  return result;
}

function 当前显示顺序相同(
  this: void,
  current: Boss血条弱点韧性运行状态[],
  selected: 护卫血条候选[],
): boolean {
  if (current.length !== selected.length) return false;
  for (let i = 0; i < selected.length; i++) {
    if (current[i].Boss句柄ID !== selected[i].handleId) return false;
  }
  return true;
}

function 重建护卫血条组(
  this: void,
  current: Boss血条弱点韧性运行状态[],
  selected: 护卫血条候选[],
): void {
  if (当前显示顺序相同(current, selected)) return;
  for (let i = 0; i < current.length; i++) 结束Boss护卫血条弱点韧性(current[i].Boss单位);
  for (let i = 0; i < selected.length; i++) {
    const candidate = selected[i];
    启动Boss护卫血条弱点韧性(candidate.Boss战上下文, candidate.unit, candidate.归属类型);
  }
}

function 同步独立Boss护卫血条(this: void, context: Boss战运行上下文): void {
  const selected = 截取可显示候选(收集Boss护卫血条候选(context, "独立"));
  const current = 获取当前护卫血条状态("独立", context.Boss句柄ID);
  重建护卫血条组(current, selected);
}

export function 同步全部Boss护卫血条优先级(this: void, contexts: Boss战运行上下文[]): void {
  const activeIndependentBossIds: Record<number, boolean | undefined> = {};
  const sharedCandidates: 护卫血条候选[] = [];

  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    if (context == null || context.是否已结束 || !context.是否已激活) continue;
    const ownership = 获取护卫血条归属类型(context);
    if (ownership === "共享") {
      const candidates = 收集Boss护卫血条候选(context, "共享");
      for (let j = 0; j < candidates.length; j++) sharedCandidates.push(candidates[j]);
    } else {
      activeIndependentBossIds[context.Boss句柄ID] = true;
      同步独立Boss护卫血条(context);
    }
  }

  const allStates = 获取全部Boss血条弱点韧性运行状态();
  for (let i = 0; i < allStates.length; i++) {
    const state = allStates[i];
    if (state.显示类型 !== "护卫" || state.是否已结束) continue;
    if (state.护卫血条归属类型 === "独立" && activeIndependentBossIds[state.所属主Boss句柄ID] !== true) {
      结束Boss护卫血条弱点韧性(state.Boss单位);
    }
  }

  排序护卫血条候选(sharedCandidates);
  const selectedShared = 截取可显示候选(sharedCandidates);
  const currentShared = 获取当前护卫血条状态("共享", 0);
  重建护卫血条组(currentShared, selectedShared);
}
