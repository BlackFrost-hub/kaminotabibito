/** @noSelfInFile */

const jass = require("jass.common") as any;

import { 英雄闪避音效冷却, 取英雄闪避音效配置 } from "./00．配置";
const { 是玩家英雄组单位 } = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 获取单位玩家英雄配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位玩家英雄配置: (this: void, unit: any) => Record<string, any> | null;
};
const { 获取单位玩家英雄全部名称 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名") as {
  获取单位玩家英雄全部名称: (this: void, unit: any) => string[];
};
const { registerDodgeAppliedFinalDamageListener } = require("系统.04．伤害系统.05．闪避系统.01．闪避核心") as {
  registerDodgeAppliedFinalDamageListener: (this: void, callback: (this: void, source: any, target: any, damage: number) => void) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: number) => boolean;
const PlaySoundOnUnitBJ = jass.PlaySoundOnUnitBJ as (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;

let 已初始化英雄闪避语音 = false;

function 取英雄名(this: void, unit: any): string {
  const 全部名称 = 获取单位玩家英雄全部名称(unit);
  if (全部名称.length > 0) return 全部名称[0];
  const config = 获取单位玩家英雄配置(unit);
  if (config == null) return "";
  const 名称 = String(config.Name ?? "").trim();
  if (名称 !== "") return 名称;
  return String(config.Propernames ?? "").trim();
}

function 取闪避音效(this: void, unit: any): any {
  const 名称列表 = 获取单位玩家英雄全部名称(unit);
  if (名称列表.length <= 0) {
    const 英雄名 = 取英雄名(unit);
    const 配置 = 取英雄闪避音效配置(英雄名);
    if (配置 == null || 配置.音效列表.length === 0) return null;
    const 索引 = GetRandomInt(1, 配置.音效列表.length) - 1;
    return 配置.音效列表[索引] ?? null;
  }
  for (let i = 0; i < 名称列表.length; i++) {
    const 配置 = 取英雄闪避音效配置(名称列表[i]);
    if (配置 == null || 配置.音效列表.length === 0) continue;
    const 索引 = GetRandomInt(1, 配置.音效列表.length) - 1;
    return 配置.音效列表[索引] ?? null;
  }
  return null;
}

function 允许播放(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (!是玩家英雄组单位(unit)) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_DEAD)) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_SUMMONED)) return false;
  return true;
}

function 本地玩家播放(this: void, unit: any, soundHandle: any): void {
  if (soundHandle == null) return;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return;
  if (GetLocalPlayer() !== owner) return;
  PlaySoundOnUnitBJ(soundHandle, 100, unit);
}

function 英雄闪避语音冷却结束(this: void): void {
  const timer = jass.GetExpiredTimer();
  const target = YDUserDataGetSafe("timer", timer, "英雄闪避语音单位", "unit");
  if (target != null && target !== 0) {
    YDUserDataSetSafe("unit", target, "闪避语音", "boolean", false);
  }
  jass.DestroyTimer(timer);
}

function 处理闪避语音(this: void, _source: any, target: any): void {
  if (!允许播放(target)) return;
  if (YDUserDataGetSafe("unit", target, "闪避语音", "boolean")) return;
  const soundHandle = 取闪避音效(target);
  if (soundHandle == null) return;
  YDUserDataSetSafe("unit", target, "闪避语音", "boolean", true);
  本地玩家播放(target, soundHandle);
  const timer = jass.CreateTimer();
  YDUserDataSetSafe("timer", timer, "英雄闪避语音单位", "unit", target);
  jass.TimerStart(timer, 英雄闪避音效冷却, false, 英雄闪避语音冷却结束);
}

function 闪避成功回调(this: void, source: any, target: any, _damage: number): void {
  处理闪避语音(source, target);
}

export function init英雄闪避音效系统(this: void): void {
  if (已初始化英雄闪避语音) return;
  已初始化英雄闪避语音 = true;
  registerDodgeAppliedFinalDamageListener(闪避成功回调);
}

export {};
