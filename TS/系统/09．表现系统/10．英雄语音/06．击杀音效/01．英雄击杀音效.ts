/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 单位是否匹配玩家英雄名称 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名") as {
  单位是否匹配玩家英雄名称: (this: void, unit: any, name: string) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};

import { 英雄击杀音效配置列表, 英雄击杀音效冷却 } from "./00．配置";

const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const CreateTimer = jass.CreateTimer as () => any;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const PlaySoundOnUnitBJ = jass.PlaySoundOnUnitBJ as (soundHandle: any, volumePercent: number, whichUnit: any) => void;

const 冷却字段 = "战斗胜利语音";
const 冷却计时器字段 = "击杀音效单位";

let 英雄击杀音效已初始化 = false;

function 死亡单位满足击杀音效前置(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_SUMMONED)) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE)) return false;
  return true;
}

function 取击杀音效配置(this: void, unit: any): { 英雄名: string; 音效列表: any[] } | null {
  for (let i = 0; i < 英雄击杀音效配置列表.length; i++) {
    const config = 英雄击杀音效配置列表[i];
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

function 击杀音效冷却结束(this: void): void {
  const timer = GetExpiredTimer();
  if (timer == null || timer === 0) return;
  const unit = YDUserDataGetSafe("timer", timer, 冷却计时器字段, "unit");
  if (unit != null && unit !== 0) {
    YDUserDataSetSafe("unit", unit, 冷却字段, "boolean", false);
  }
  safeDestroyTimer(timer);
}

function 进入击杀音效冷却(this: void, unit: any): void {
  YDUserDataSetSafe("unit", unit, 冷却字段, "boolean", true);
  const timer = CreateTimer();
  YDUserDataSetSafe("timer", timer, 冷却计时器字段, "unit", unit);
  safeTimerStart(timer, 英雄击杀音效冷却, false, 击杀音效冷却结束);
}

function 处理英雄击杀音效(this: void, dyingUnit: any, killingUnit: any): void {
  if (!死亡单位满足击杀音效前置(dyingUnit)) return;
  if (killingUnit == null || killingUnit === 0) return;
  if (!IsUnitType(killingUnit, jass.UNIT_TYPE_HERO)) return;
  if (YDUserDataGetSafe("unit", killingUnit, 冷却字段, "boolean") === true) return;

  const config = 取击杀音效配置(killingUnit);
  if (config == null) return;
  const soundHandle = 取播放音效(config.音效列表);
  if (soundHandle == null || soundHandle === 0) return;

  PlaySoundOnUnitBJ(soundHandle, 100, killingUnit);
  进入击杀音效冷却(killingUnit);
}

export function init英雄击杀音效(this: void): void {
  if (英雄击杀音效已初始化) return;
  英雄击杀音效已初始化 = true;
  registerDeathListener(处理英雄击杀音效);
}

export {};
