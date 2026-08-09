/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerHeroLevelListener } = require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心") as {
  registerHeroLevelListener: (this: void, callback: (this: void, heroUnit: any) => void) => void;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 获取单位玩家英雄配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位玩家英雄配置: (this: void, unit: any) => Record<string, any> | null;
};
const { 单位是否匹配玩家英雄名称 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名") as {
  单位是否匹配玩家英雄名称: (this: void, unit: any, name: string) => boolean;
};
import { 英雄升级音效配置列表, 英雄升级音效配置 } from "./00．配置";

const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: number) => boolean;
const StartSound = jass.StartSound as (this: void, soundHandle: any) => void;

let 英雄升级音效已初始化 = false;

function 取单位匹配名列表(this: void, unit: any): string[] {
  const config = 获取单位玩家英雄配置(unit);
  if (config == null) return [];
  const result: string[] = [];
  const name = String(config.Name ?? "").trim();
  const proper = String(config.Propernames ?? "").trim();
  if (name !== "") result.push(name);
  if (proper !== "") result.push(proper);
  return result;
}

function 匹配升级音效配置(this: void, unit: any): 英雄升级音效配置 | null {
  for (let i = 0; i < 英雄升级音效配置列表.length; i++) {
    const config = 英雄升级音效配置列表[i];
    if (单位是否匹配玩家英雄名称(unit, config.英雄名)) return config;
  }
  return null;
}

function 本地播放升级音效(this: void, unit: any, soundHandle: any): void {
  if (soundHandle == null) return;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return;
  if (GetLocalPlayer() !== owner) return;
  StartSound(soundHandle);
}

function on英雄升级语音(this: void, heroUnit: any): void {
  if (heroUnit == null || heroUnit === 0) return;
  const owner = GetOwningPlayer(heroUnit);
  if (owner == null || owner === 0) return;
  const registeredHero = YDUserDataGetSafe("player", owner, "英雄", "unit");
  if (registeredHero == null || registeredHero === 0) return;
  if (registeredHero !== heroUnit && GetHandleId(registeredHero) !== GetHandleId(heroUnit)) return;
  if (IsUnitType(heroUnit, jass.UNIT_TYPE_DEAD)) return;
  const config = 匹配升级音效配置(heroUnit);
  if (config == null) return;
  本地播放升级音效(heroUnit, config.播放音效);
}

export function init英雄升级音效系统(this: void): void {
  if (英雄升级音效已初始化) return;
  英雄升级音效已初始化 = true;
  registerHeroLevelListener(on英雄升级语音);
}

export {};
