/** @noSelfInFile */
/**
 * 动态技能文本系统 - 入口与导出
 *
 * 功能：动态修改技能提示扩展文本
 * - 将描述中的公式替换为实际伤害数值
 * - 例如"智力×3"替换为实际智力×3的数值
 * - 支持：攻击力、最大生命值、当前生命值、智力、敏捷、力量的倍率公式
 */

const 平台扩展取值 = require("平台扩展API.取值") as {
  当前选择的单位异步: (this: void) => any;
};
const 当前选择的单位异步 = 平台扩展取值["当前选择的单位异步"] as (this: void) => any;

const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};

import { 检查英雄技能 } from "./03．核心逻辑";

const MODULE_NAME = "动态技能文本";
const REFRESH_MS = 500;

const registeredHeroes = new Set<any>();
let initialized = false;

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

function onTick(this: void): void {
  const unit = 当前选择的单位异步();
  if (!isValidHandle(unit)) return;
  if (!registeredHeroes.has(unit)) return;

  检查英雄技能(unit);
}

export function registerDynamicSkillTextHero(this: void, whichHero: any): void {
  if (!isValidHandle(whichHero)) return;
  if (registeredHeroes.has(whichHero)) return;

  registeredHeroes.add(whichHero);
  debugLog(MODULE_NAME, "注册英雄用于动态文本");

  检查英雄技能(whichHero);
}

export function initDynamicSkillTextSystem(this: void): void {
  if (initialized) return;
  initialized = true;
  addPeriodicCallback(REFRESH_MS, onTick);
  debugLog(MODULE_NAME, "初始化动态技能文本系统");
}

export {};
