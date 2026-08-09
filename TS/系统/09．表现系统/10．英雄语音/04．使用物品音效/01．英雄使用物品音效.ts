/** @noSelfInFile */

const jass = require("jass.common") as any;
const { onItemUse } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemUse: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
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
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};

const GetLocalPlayer = jass.GetLocalPlayer as () => any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitCurrentOrder = jass.GetUnitCurrentOrder as (unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const StartSound = jass.StartSound as (this: void, soundHandle: any) => void;

const {
  英雄使用物品音效配置列表,
  英雄使用物品音效冷却,
  英雄使用物品命令最小,
  英雄使用物品命令最大,
} = require("./00．配置") as {
  英雄使用物品音效配置列表: readonly { 英雄名: string; 是否3D: boolean; 音效列表: any[] }[];
  英雄使用物品音效冷却: number;
  英雄使用物品命令最小: number;
  英雄使用物品命令最大: number;
};

const 冷却单位字段 = "使用物品语音";

let 英雄使用物品音效已初始化 = false;
const 物品使用音效冷却结束单位队列: any[] = [];

function isUseItemOrder(orderId: number): boolean {
  return orderId >= 英雄使用物品命令最小 && orderId <= 英雄使用物品命令最大;
}

function 取英雄使用物品音效配置(unit: any): { 英雄名: string; 是否3D: boolean; 音效列表: any[] } | null {
  for (let i = 0; i < 英雄使用物品音效配置列表.length; i++) {
    const config = 英雄使用物品音效配置列表[i];
    if (单位是否匹配玩家英雄名称(unit, config.英雄名)) return config;
  }
  return null;
}

function 取播放音效(soundList: any[]): any {
  if (soundList.length <= 0) return null;
  if (soundList.length === 1) return soundList[0];
  const index = GetRandomInt(1, soundList.length) - 1;
  return soundList[index];
}

function 物品使用音效冷却结束(): void {
  const unit = 物品使用音效冷却结束单位队列.shift();
  if (unit != null && unit !== 0) {
    YDUserDataSetSafe("unit", unit, 冷却单位字段, "boolean", false);
  }
}

function 播放物品使用音效(unit: any, config: { 英雄名: string; 是否3D: boolean; 音效列表: any[] }): void {
  const soundHandle = 取播放音效(config.音效列表);
  if (soundHandle == null || soundHandle === 0) return;

  if (config.是否3D) {
    PlaySoundOnUnitBJ(soundHandle, 100, unit);
    return;
  }

  if (GetOwningPlayer(unit) === GetLocalPlayer()) {
    StartSound(soundHandle);
  }
}

function 处理物品使用音效(unit: any, item: any): void {
  if (unit == null || unit === 0 || item == null || item === 0) return;
  if (getRegisteredPlayerHero(GetOwningPlayer(unit)) !== unit) return;
  if (isUseItemOrder(GetUnitCurrentOrder(unit)) !== true) return;
  if (YDUserDataGetSafe("unit", unit, 冷却单位字段, "boolean") === true) return;

  const config = 取英雄使用物品音效配置(unit);
  if (config == null) return;

  播放物品使用音效(unit, config);
  YDUserDataSetSafe("unit", unit, 冷却单位字段, "boolean", true);

  物品使用音效冷却结束单位队列.push(unit);
  addDelayedCallback(英雄使用物品音效冷却 * 1000, 物品使用音效冷却结束);
}

export function init英雄使用物品音效(this: void): void {
  if (英雄使用物品音效已初始化) return;
  英雄使用物品音效已初始化 = true;
  onItemUse(处理物品使用音效);
}

export {};
