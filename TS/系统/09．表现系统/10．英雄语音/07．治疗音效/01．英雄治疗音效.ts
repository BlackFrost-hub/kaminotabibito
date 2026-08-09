/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerAppliedFinalHealListener } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerAppliedFinalHealListener: (this: void, callback: (this: void, source: any, target: any, actualHeal: number, isItemHeal: boolean) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 单位是否匹配玩家英雄名称 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名") as {
  单位是否匹配玩家英雄名称: (this: void, unit: any, name: string) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};

import { 英雄治疗音效配置列表, 英雄治疗音效冷却, 治疗音效排除来源Rawcode列表 } from "./00．配置";

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const IsUnitAlly = jass.IsUnitAlly as (unit: any, whichPlayer: any) => boolean;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;

const 冷却字段 = "受到帮助语音";

let 英雄治疗音效已初始化 = false;
const 治疗音效冷却结束单位队列: any[] = [];

function 是注册玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  return getRegisteredPlayerHero(owner) === unit;
}

function 来源需要排除(this: void, source: any): boolean {
  if (source == null || source === 0) return false;
  const typeId = GetUnitTypeId(source);
  for (let i = 0; i < 治疗音效排除来源Rawcode列表.length; i++) {
    if (typeId === stringToFourCC(治疗音效排除来源Rawcode列表[i])) return true;
  }
  return false;
}

function 取治疗音效配置(this: void, unit: any): { 英雄名: string; 音效列表: any[] } | null {
  for (let i = 0; i < 英雄治疗音效配置列表.length; i++) {
    const config = 英雄治疗音效配置列表[i];
    if (单位是否匹配玩家英雄名称(unit, config.英雄名)) return config;
  }
  return null;
}

function 取播放音效(this: void, soundList: any[]): any {
  if (soundList.length <= 0) return null;
  if (soundList.length === 1) return soundList[0];
  const index = GetRandomInt(1, soundList.length) - 1;
  return soundList[index];
}

function 治疗音效冷却结束(this: void): void {
  const unit = 治疗音效冷却结束单位队列.shift();
  if (unit != null && unit !== 0) {
    YDUserDataSetSafe("unit", unit, 冷却字段, "boolean", false);
  }
}

function 进入治疗音效冷却(this: void, unit: any): void {
  YDUserDataSetSafe("unit", unit, 冷却字段, "boolean", true);
  治疗音效冷却结束单位队列.push(unit);
  addDelayedCallback(英雄治疗音效冷却 * 1000, 治疗音效冷却结束);
}

function 满足治疗音效关系(this: void, source: any, target: any): boolean {
  if (source == null || source === 0 || target == null || target === 0) return false;
  if (来源需要排除(source)) return false;
  if (!是注册玩家英雄(target)) return false;

  const sourcePlayer = GetOwningPlayer(source);
  const targetPlayer = GetOwningPlayer(target);
  if (sourcePlayer == null || sourcePlayer === 0 || targetPlayer == null || targetPlayer === 0) return false;
  if (sourcePlayer === targetPlayer) return false;
  return IsUnitAlly(target, sourcePlayer);
}

function 处理英雄治疗音效(this: void, source: any, target: any, actualHeal: number, _isItemHeal: boolean): void {
  if (actualHeal <= 0) return;
  if (!满足治疗音效关系(source, target)) return;
  if (YDUserDataGetSafe("unit", target, 冷却字段, "boolean") === true) return;

  const config = 取治疗音效配置(target);
  if (config == null) return;
  const soundHandle = 取播放音效(config.音效列表);
  if (soundHandle == null || soundHandle === 0) return;

  PlaySoundOnUnitBJ(soundHandle, 100, target);
  进入治疗音效冷却(target);
}

export function init英雄治疗音效(this: void): void {
  if (英雄治疗音效已初始化) return;
  英雄治疗音效已初始化 = true;
  registerAppliedFinalHealListener(处理英雄治疗音效);
}

export {};
