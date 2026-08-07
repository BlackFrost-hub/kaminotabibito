/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
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
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};
import {
  低血状态音效配置列表,
  受伤语音冷却秒,
  受伤语音字段,
  战况劣势语音冷却秒,
  战况劣势语音字段,
  战况劣势音效配置列表,
  状态不佳语音字段,
  状态音效伤害延迟毫秒,
  状态音效配置列表,
} from "./00．配置";

const GetLocalPlayer = jass.GetLocalPlayer as () => any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitStateJass = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const IsUnitInGroup = jass.IsUnitInGroup as (unit: any, whichGroup: any) => boolean;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const SetSoundVolume = jass.SetSoundVolume as (soundHandle: any, volume: number) => void;
const SetSoundPosition = jass.SetSoundPosition as (soundHandle: any, x: number, y: number, z: number) => void;
const StartSound = jass.StartSound as (soundHandle: any) => void;
const StopSound = jass.StopSound as (soundHandle: any, killWhenDone: boolean, fadeOut: boolean) => void;

interface 延迟状态音效记录 {
  目标: any;
  来源: any;
  伤害: number;
}

interface 冷却记录 {
  单位: any;
  字段: string;
  到期时间: number;
}

const 延迟状态音效队列: 延迟状态音效记录[] = [];
const 冷却队列: 冷却记录[] = [];
let 状态音效已初始化 = false;
let 延迟状态音效已调度 = false;

function 取最大生命(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  const value = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE);
  return value > 0 ? value : 0;
}

function 取当前生命(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  const value = GetUnitStateJass(unit, jass.UNIT_STATE_LIFE);
  return value > 0 ? value : 0;
}

function 取最大魔法(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  const value = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA);
  return value > 0 ? value : 0;
}

function 取当前生命百分比(this: void, unit: any): number {
  const maxLife = 取最大生命(unit);
  if (maxLife <= 0) return 0;
  return 取当前生命(unit) * 100 / maxLife;
}

function 取当前魔法百分比(this: void, unit: any): number {
  const maxMana = 取最大魔法(unit);
  if (maxMana <= 0) return 100;
  const mana = GetUnitStateJass(unit, jass.UNIT_STATE_MANA);
  return mana * 100 / maxMana;
}

function 是注册玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  return getRegisteredPlayerHero(owner) === unit;
}

function 单位是否血条Boss组成员(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const bossGroup = YDUserDataGetSafe("string", "血条Boss", "单位组", "group");
  if (bossGroup == null || bossGroup === 0) return false;
  return IsUnitInGroup(unit, bossGroup);
}

function 是英雄或血条Boss(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_HERO)) return true;
  return 单位是否血条Boss组成员(unit);
}

function 目标满足状态音效前置(this: void, target: any, applied: number): boolean {
  if (applied < 0.10) return false;
  if (target == null || target === 0) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_DEAD)) return false;
  return 是注册玩家英雄(target);
}

function 随机取音效(this: void, soundList: any[]): any {
  if (soundList.length <= 0) return null;
  if (soundList.length === 1) return soundList[0];
  const index = GetRandomInt(1, soundList.length) - 1;
  return soundList[index];
}

function 本地播放单位语音(this: void, unit: any, soundHandle: any): void {
  if (soundHandle == null || soundHandle === 0) return;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return;
  if (GetLocalPlayer() !== owner) return;
  StartSound(soundHandle);
}

function 播放单位3D音效(this: void, unit: any, soundHandle: any): void {
  SetSoundVolume(soundHandle, 100);
  SetSoundPosition(soundHandle, GetUnitX(unit), GetUnitY(unit), GetUnitFlyHeight(unit));
  StartSound(soundHandle);
}

function 播放状态音效(this: void, unit: any, soundHandle: any, 是否3D: boolean): void {
  if (soundHandle == null || soundHandle === 0) return;
  if (是否3D) {
    播放单位3D音效(unit, soundHandle);
    return;
  }
  本地播放单位语音(unit, soundHandle);
}

function 取受伤配置(this: void, unit: any): { 英雄名: string; 是否3D: boolean; 普通受伤音效列表: any[]; 重伤音效列表: any[] } | null {
  for (let i = 0; i < 状态音效配置列表.length; i++) {
    const config = 状态音效配置列表[i];
    if (单位是否匹配玩家英雄名称(unit, config.英雄名)) return config;
  }
  return null;
}

function 取战况劣势配置(this: void, unit: any): { 英雄名: string; 音效列表: any[]; 是否3D: boolean } | null {
  for (let i = 0; i < 战况劣势音效配置列表.length; i++) {
    const config = 战况劣势音效配置列表[i];
    if (单位是否匹配玩家英雄名称(unit, config.英雄名)) return config;
  }
  return null;
}

function 是否冷却中(this: void, unit: any, 字段: string): boolean {
  return YDUserDataGetSafe("unit", unit, 字段, "boolean") === true;
}

function 处理状态音效冷却到期(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 冷却队列.length; i++) {
    const record = 冷却队列[i];
    if (record.单位 == null || record.单位 === 0) continue;
    if (record.到期时间 <= now) {
      YDUserDataSetSafe("unit", record.单位, record.字段, "boolean", false);
      continue;
    }
    冷却队列[writeIndex] = record;
    writeIndex++;
  }
  for (let i = 冷却队列.length - 1; i >= writeIndex; i--) {
    冷却队列.pop();
  }
}

function 进入状态音效冷却(this: void, unit: any, 字段: string, 冷却秒: number): void {
  YDUserDataSetSafe("unit", unit, 字段, "boolean", true);
  冷却队列.push({
    单位: unit,
    字段,
    到期时间: getServerTime() + 冷却秒 * 1000,
  });
  addDelayedCallback(冷却秒 * 1000, 处理状态音效冷却到期);
}

function 尝试播放战况劣势语音(this: void, record: 延迟状态音效记录, maxLife: number): void {
  const target = record.目标;
  const source = record.来源;
  if (source == null || source === 0) return;
  if (!是英雄或血条Boss(source)) return;
  if (是否冷却中(target, 战况劣势语音字段)) return;
  if (record.伤害 < maxLife * 0.01) return;
  if (取当前生命百分比(target) > 30) return;
  if (取当前生命百分比(source) < 75) return;
  if (取当前魔法百分比(source) < 30) return;

  const config = 取战况劣势配置(target);
  if (config == null) return;
  const soundHandle = 随机取音效(config.音效列表);
  if (soundHandle == null || soundHandle === 0) return;
  播放状态音效(target, soundHandle, config.是否3D);
  进入状态音效冷却(target, 战况劣势语音字段, 战况劣势语音冷却秒);
}

function 尝试播放受伤语音(this: void, record: 延迟状态音效记录, maxLife: number): void {
  const target = record.目标;
  if (是否冷却中(target, 受伤语音字段)) return;
  if (record.伤害 < maxLife * 0.07) return;

  const config = 取受伤配置(target);
  if (config == null) return;

  const heavy = record.伤害 >= maxLife * 0.12 && 取当前生命百分比(target) <= 40;
  const soundList = heavy ? config.重伤音效列表 : config.普通受伤音效列表;
  const soundHandle = 随机取音效(soundList);
  if (soundHandle == null || soundHandle === 0) return;

  播放状态音效(target, soundHandle, config.是否3D);
  进入状态音效冷却(target, 受伤语音字段, 受伤语音冷却秒);
}

function 尝试播放低血状态语音(this: void, target: any): void {
  if (是否冷却中(target, 状态不佳语音字段)) return;
  const lifePercent = 取当前生命百分比(target);

  for (let i = 0; i < 低血状态音效配置列表.length; i++) {
    const config = 低血状态音效配置列表[i];
    if (lifePercent < config.最小生命百分比 || lifePercent > config.最大生命百分比) continue;
    if (!单位是否匹配玩家英雄名称(target, config.英雄名)) continue;
    const soundHandle = 随机取音效(config.音效列表);
    if (soundHandle == null || soundHandle === 0) return;
    if (config.停止音效 != null && config.停止音效 !== 0) {
      StopSound(config.停止音效, false, false);
    }
    播放状态音效(target, soundHandle, config.是否3D);
    进入状态音效冷却(target, 状态不佳语音字段, config.冷却秒);
    return;
  }
}

function 处理延迟状态音效队列(this: void): void {
  延迟状态音效已调度 = false;
  while (延迟状态音效队列.length > 0) {
    const record = 延迟状态音效队列.shift();
    if (record == null) continue;
    const target = record.目标;
    if (!目标满足状态音效前置(target, record.伤害)) continue;
    const maxLife = 取最大生命(target);
    if (maxLife <= 0) continue;

    尝试播放战况劣势语音(record, maxLife);
    尝试播放受伤语音(record, maxLife);
    尝试播放低血状态语音(target);
  }
}

function 状态音效最终伤害回调(this: void, target: any, attacker: any, applied: number, _snapshot: any): void {
  if (!目标满足状态音效前置(target, applied)) return;
  延迟状态音效队列.push({
    目标: target,
    来源: attacker,
    伤害: applied,
  });
  if (延迟状态音效已调度) return;
  延迟状态音效已调度 = true;
  addDelayedCallback(状态音效伤害延迟毫秒, 处理延迟状态音效队列);
}

export function init英雄状态音效(this: void): void {
  if (状态音效已初始化) return;
  状态音效已初始化 = true;
  registerAppliedFinalDamageListener(状态音效最终伤害回调);
}

export {};
