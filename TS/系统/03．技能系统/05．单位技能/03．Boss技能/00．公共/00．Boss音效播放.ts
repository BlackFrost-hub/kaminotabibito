/** @noSelfInFile */

const { Sound3DII_CooPlay } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlay: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const jass = require("jass.common") as any;

const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

export interface Boss拟声池播放参数 {
  标识: string;
  音效路径列表: readonly string[];
  X: number;
  Y: number;
  裁断距离: number;
  冷却Ms?: number;
  触发概率百分比?: number;
}

export interface Boss拟声池延迟播放参数 extends Boss拟声池播放参数 {
  延迟Ms: number;
}

export type Boss坐标音效编排模式 = "同步延迟" | "顺序延迟";

export interface Boss坐标音效编排段 {
  音效路径: string;
  X: number;
  Y: number;
  延迟Ms?: number;
  持续Ms?: number;
  裁断距离?: number;
}

export interface Boss坐标音效编排参数 {
  音效列表: Boss坐标音效编排段[];
  默认裁断距离: number;
  模式?: Boss坐标音效编排模式;
}

export const Boss拟声默认冷却Ms = 8000;
export const Boss坐标音效编排最大段数 = 4;

const Boss拟声池下次可播放时间: Record<string, number | undefined> = {};
const Boss拟声池上次下标: Record<string, number | undefined> = {};

export function 播放Boss坐标音效(this: void, path: string, x: number, y: number, cutoff: number): void {
  if (path === "") return;
  Sound3DII_CooPlay(path, x, y, 0, cutoff);
}

export function 延迟播放Boss坐标音效(this: void, path: string, x: number, y: number, delayMs: number, cutoff: number): void {
  if (path === "") return;
  addDelayedCallback(delayMs, function Boss延迟坐标音效(this: void): void {
    播放Boss坐标音效(path, x, y, cutoff);
  });
}

function 取非负毫秒(this: void, value: number | undefined): number {
  if (value == null || value <= 0) return 0;
  return value;
}

function 安排Boss坐标音效段(this: void, 段: Boss坐标音效编排段, 延迟Ms: number, 默认裁断距离: number): void {
  const cutoff = 段.裁断距离 == null ? 默认裁断距离 : 段.裁断距离;
  if (延迟Ms <= 0) {
    播放Boss坐标音效(段.音效路径, 段.X, 段.Y, cutoff);
    return;
  }
  延迟播放Boss坐标音效(段.音效路径, 段.X, 段.Y, 延迟Ms, cutoff);
}

export function 播放Boss坐标音效编排(this: void, 参数: Boss坐标音效编排参数): void {
  const list = 参数.音效列表;
  const count = Math.min(Boss坐标音效编排最大段数, list.length);
  const 顺序 = 参数.模式 === "顺序延迟";
  let 累计Ms = 0;
  for (let i = 0; i < count; i++) {
    const 段 = list[i];
    if (段 == null || 段.音效路径 === "") continue;
    const 段延迟Ms = 取非负毫秒(段.延迟Ms);
    const 实际延迟Ms = 顺序 ? 累计Ms + 段延迟Ms : 段延迟Ms;
    安排Boss坐标音效段(段, 实际延迟Ms, 参数.默认裁断距离);
    if (顺序) 累计Ms = 实际延迟Ms + 取非负毫秒(段.持续Ms);
  }
}

function 通过Boss拟声触发概率(this: void, 参数: Boss拟声池播放参数): boolean {
  const chance = 参数.触发概率百分比 == null ? 100 : 参数.触发概率百分比;
  if (chance <= 0) return false;
  if (chance >= 100) return true;
  return GetRandomInt(1, 100) <= chance;
}

function 选择Boss拟声路径(this: void, 标识: string, 音效路径列表: readonly string[]): string {
  const count = 音效路径列表.length;
  if (count <= 0) return "";
  if (count === 1) return 音效路径列表[0];
  let index = GetRandomInt(0, count - 1);
  const lastIndex = Boss拟声池上次下标[标识];
  if (lastIndex != null && index === lastIndex) index = (index + 1) % count;
  Boss拟声池上次下标[标识] = index;
  return 音效路径列表[index];
}

export function 尝试播放Boss拟声池(this: void, 参数: Boss拟声池播放参数): boolean {
  const 标识 = 参数.标识;
  if (标识 === "" || 参数.音效路径列表.length <= 0) return false;
  const now = getServerTime();
  const cooldown = 参数.冷却Ms == null ? Boss拟声默认冷却Ms : 参数.冷却Ms;
  const nextReady = Boss拟声池下次可播放时间[标识];
  if (cooldown > 0 && nextReady != null && now < nextReady) return false;
  if (!通过Boss拟声触发概率(参数)) return false;
  const path = 选择Boss拟声路径(标识, 参数.音效路径列表);
  if (path === "") return false;
  播放Boss坐标音效(path, 参数.X, 参数.Y, 参数.裁断距离);
  if (cooldown > 0) Boss拟声池下次可播放时间[标识] = now + cooldown;
  return true;
}

export function 延迟尝试播放Boss拟声池(this: void, 参数: Boss拟声池延迟播放参数): void {
  addDelayedCallback(参数.延迟Ms, function Boss延迟拟声音效(this: void): void {
    尝试播放Boss拟声池(参数);
  });
}
