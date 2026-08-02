/** @noSelfInFile */

import { getServerTime } from "../../../../00．核心系统/05．中心计时器";

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

export interface Boss战运行上下文 {
  Boss单位: any;
  Boss句柄ID: number;
  地点矩形: any;
  地点句柄ID: number;
  地点矩形是否动态: boolean;
  战斗音乐: any;
  胜利音乐: any;
  运行代次: number;
  启动时间: number;
  是否已激活: boolean;
  等待激活截止时间: number;
  转场提示时间: number;
  下次兜底搜敌时间: number;
  最近兜底目标ID: number;
  胜利音乐移除时间: number;
  是否已结束: boolean;
}

const 按Boss句柄索引的运行上下文表: Record<number, Boss战运行上下文 | undefined> = {};
const 按矩形句柄索引的运行上下文表: Record<number, Boss战运行上下文 | undefined> = {};
const 矩形玩家可见度缓存表: Record<number, Record<number, any | undefined> | undefined> = {};

let 全局运行代次 = 0;

function 获取句柄ID(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

function 获取有序句柄ID列表(this: void, table: Record<number, any | undefined>): number[] {
  const result: number[] = [];
  const keys = Object.keys(table);
  for (let i = 0; i < keys.length; i++) {
    const handleId = Number(keys[i]) || 0;
    if (handleId > 0 && table[handleId] != null) {
      result.push(handleId);
    }
  }
  for (let i = 1; i < result.length; i++) {
    const current = result[i];
    let insertIndex = i - 1;
    while (insertIndex >= 0 && result[insertIndex] > current) {
      result[insertIndex + 1] = result[insertIndex];
      insertIndex--;
    }
    result[insertIndex + 1] = current;
  }
  return result;
}

export function 创建Boss战运行上下文(this: void, bossUnit: any, 地点矩形: any, 战斗音乐: any, 胜利音乐: any, 地点矩形是否动态 = false): Boss战运行上下文 | undefined {
  const bossHandleId = 获取句柄ID(bossUnit);
  if (bossHandleId === 0) return undefined;

  全局运行代次 += 1;
  return {
    Boss单位: bossUnit,
    Boss句柄ID: bossHandleId,
    地点矩形,
    地点句柄ID: 获取句柄ID(地点矩形),
    地点矩形是否动态,
    战斗音乐,
    胜利音乐,
    运行代次: 全局运行代次,
    启动时间: getServerTime(),
    是否已激活: false,
    等待激活截止时间: 0,
    转场提示时间: 0,
    下次兜底搜敌时间: 0,
    最近兜底目标ID: 0,
    胜利音乐移除时间: 0,
    是否已结束: false,
  };
}

export function 记录Boss战运行上下文(this: void, context: Boss战运行上下文): void {
  按Boss句柄索引的运行上下文表[context.Boss句柄ID] = context;
  if (context.地点句柄ID > 0) {
    按矩形句柄索引的运行上下文表[context.地点句柄ID] = context;
  }
}

export function 读取Boss战运行上下文(this: void, bossUnit: any): Boss战运行上下文 | undefined {
  return 按Boss句柄索引的运行上下文表[获取句柄ID(bossUnit)];
}

export function 获取全部Boss战运行上下文(this: void): Boss战运行上下文[] {
  const result: Boss战运行上下文[] = [];
  const handleIds = 获取有序句柄ID列表(按Boss句柄索引的运行上下文表);
  for (let i = 0; i < handleIds.length; i++) {
    const context = 按Boss句柄索引的运行上下文表[handleIds[i]];
    if (context != null) {
      result.push(context);
    }
  }
  return result;
}

export function 清理Boss战运行上下文(this: void, bossUnit: any): void {
  const bossHandleId = 获取句柄ID(bossUnit);
  if (bossHandleId === 0) return;
  const context = 按Boss句柄索引的运行上下文表[bossHandleId];
  按Boss句柄索引的运行上下文表[bossHandleId] = undefined;
  if (context != null) {
    清理矩形当前Boss战上下文(context.地点句柄ID, context.运行代次);
  }
}

export function 读取矩形当前Boss战上下文(this: void, rectHandleId: number): Boss战运行上下文 | undefined {
  if (rectHandleId === 0) return undefined;
  return 按矩形句柄索引的运行上下文表[rectHandleId];
}

export function 设置矩形当前Boss战上下文(this: void, rectHandleId: number, context: Boss战运行上下文 | undefined): void {
  if (rectHandleId === 0) return;
  按矩形句柄索引的运行上下文表[rectHandleId] = context;
}

export function 获取全部矩形当前Boss战上下文(this: void): Boss战运行上下文[] {
  const result: Boss战运行上下文[] = [];
  const handleIds = 获取有序句柄ID列表(按矩形句柄索引的运行上下文表);
  for (let i = 0; i < handleIds.length; i++) {
    const context = 按矩形句柄索引的运行上下文表[handleIds[i]];
    if (context != null) {
      result.push(context);
    }
  }
  return result;
}

export function 清理矩形当前Boss战上下文(this: void, rectHandleId: number, expectedGeneration?: number): void {
  if (rectHandleId === 0) return;
  const context = 按矩形句柄索引的运行上下文表[rectHandleId];
  if (context == null) return;
  if (expectedGeneration != null && context.运行代次 !== expectedGeneration) return;
  按矩形句柄索引的运行上下文表[rectHandleId] = undefined;
}

export function 读取矩形玩家可见度修整器(this: void, rectHandleId: number, playerId: number): any {
  if (rectHandleId === 0 || playerId < 0) return undefined;
  const playerMap = 矩形玩家可见度缓存表[rectHandleId];
  if (playerMap == null) return undefined;
  return playerMap[playerId];
}

export function 记录矩形玩家可见度修整器(this: void, rectHandleId: number, playerId: number, fogModifier: any): void {
  if (rectHandleId === 0 || playerId < 0 || fogModifier == null || fogModifier === 0) return;
  let playerMap = 矩形玩家可见度缓存表[rectHandleId];
  if (playerMap == null) {
    playerMap = {};
    矩形玩家可见度缓存表[rectHandleId] = playerMap;
  }
  playerMap[playerId] = fogModifier;
}

export function 当前是否存在Boss战运行上下文(this: void): boolean {
  const handleIds = 获取有序句柄ID列表(按Boss句柄索引的运行上下文表);
  return handleIds.length > 0;
}
