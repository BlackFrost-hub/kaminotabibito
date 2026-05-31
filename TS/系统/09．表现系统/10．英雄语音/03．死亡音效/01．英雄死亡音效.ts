/** @noSelfInFile */

const jass = require("jass.common") as any;
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 是玩家英雄组单位 } = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 获取单位玩家英雄全部名称 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名") as {
  获取单位玩家英雄全部名称: (this: void, unit: any) => string[];
};
import { 英雄死亡音效冷却, 取英雄死亡音效配置 } from "./00．配置";

const PlaySoundBJ = jass.PlaySoundBJ as (this: void, soundHandle: any) => void;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;

let 英雄死亡音效已初始化 = false;
const 死亡音效冷却结束单位队列: any[] = [];

function 允许播放(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (!是玩家英雄组单位(unit)) return false;
  return true;
}

function 取死亡音效(this: void, unit: any): any {
  const 名称列表 = 获取单位玩家英雄全部名称(unit);
  for (let i = 0; i < 名称列表.length; i++) {
    const 配置 = 取英雄死亡音效配置(名称列表[i]);
    if (配置 == null || 配置.音效列表.length === 0) continue;
    const 索引 = GetRandomInt(1, 配置.音效列表.length) - 1;
    return 配置.音效列表[索引] ?? null;
  }
  return null;
}

function 死亡音效冷却结束(this: void): void {
  const target = 死亡音效冷却结束单位队列.shift();
  if (target != null && target !== 0) {
    YDUserDataSetSafe("unit", target, "死亡音效", "boolean", false);
  }
}

function 处理死亡语音(this: void, target: any): void {
  if (!允许播放(target)) return;
  if (YDUserDataGetSafe("unit", target, "死亡音效", "boolean")) return;
  const soundHandle = 取死亡音效(target);
  if (soundHandle == null) return;
  YDUserDataSetSafe("unit", target, "死亡音效", "boolean", true);
  PlaySoundBJ(soundHandle);
  死亡音效冷却结束单位队列.push(target);
  addDelayedCallback(英雄死亡音效冷却 * 1000, 死亡音效冷却结束);
}

function 死亡回调(this: void, dyingUnit: any, _killer: any): void {
  处理死亡语音(dyingUnit);
}

export function init英雄死亡音效系统(this: void): void {
  if (英雄死亡音效已初始化) return;
  英雄死亡音效已初始化 = true;
  registerDeathListener(死亡回调);
}

export {};
