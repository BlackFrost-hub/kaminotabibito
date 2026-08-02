/** @noSelfInFile */

const jass = require("jass.common") as any;
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const {
  启用第二章精灵城背景音乐,
  启用第二章精灵城王宫背景音乐,
  启用第二章精灵城区域122背景音乐,
} = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐") as {
  启用第二章精灵城背景音乐: (this: void) => boolean;
  启用第二章精灵城王宫背景音乐: (this: void) => boolean;
  启用第二章精灵城区域122背景音乐: (this: void) => boolean;
};

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import {
  读取语义单位引用,
  停止触发单位,
} from "../../00．剧情系统核心工具/06．剧情通用执行工具";
export { 阿尔文接引剧情片段 } from "../02．第二章/20．阿尔文引导";

const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;

export function 执行阿尔文接引(this: void): void {
  停止触发单位();
  const 阿尔文 = 读取语义单位引用("主线NPC.阿尔文");
  if (阿尔文 == null || 阿尔文 === 0) return;
  EC_CreateEffect("Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl", GetUnitX(阿尔文), GetUnitY(阿尔文), 0, 270, 2, 1, 1.5);
}

export function 执行启用第二章精灵城背景音乐(this: void): void {
  启用第二章精灵城背景音乐();
  启用第二章精灵城王宫背景音乐();
  启用第二章精灵城区域122背景音乐();
}

export const 阿尔文引导剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_阿尔文接引": 执行阿尔文接引,
  "第二章_启用精灵城背景音乐": 执行启用第二章精灵城背景音乐,
};
