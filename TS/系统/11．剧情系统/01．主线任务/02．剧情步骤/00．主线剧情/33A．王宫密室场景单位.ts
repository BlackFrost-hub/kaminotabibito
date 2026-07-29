/** @noSelfInFile */

import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};

const ForGroup = jass.ForGroup as (this: void, whichGroup: any, callback: (this: void) => void) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facingAngle: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;

const 中立被动玩家ID = 15;

export interface 王宫密室场景站位 {
  X: number;
  Y: number;
  朝向: number;
}

// 地图编辑器截图中的第三个高度值由地形自动决定；剧情单位仅保存可复用的平面坐标与面向。
export const 王宫密室场景站位表 = {
  伪装卫兵王宫异变: { X: 16116.2, Y: -24363.8, 朝向: 180 },
  里科特王宫异变: { X: 15635.6, Y: -24270.9, 朝向: 360 },
  皇家禁卫王宫异变: { X: 15906.5, Y: -24655.4, 朝向: 270 },
  克林姆德王对峙: { X: 14507.6, Y: -28132.3, 朝向: 90 },
  赫克提尔对峙: { X: 14911.8, Y: -28141.4, 朝向: 90 },
  玩家队伍密室对白: { X: 14691.2, Y: -28537.0, 朝向: 90 },
  耶提尔密室内: { X: 14312.1, Y: -28371.4, 朝向: 45 },
  里凡特密室内: { X: 15114.9, Y: -28421.5, 朝向: 135 },
  克林姆德王受伤: { X: 14510.1, Y: -28134.6, 朝向: 90 },
  赫克提尔受伤: { X: 14936.0, Y: -28143.7, 朝向: 90 },
  里科特密室: { X: 14711.8, Y: -27896.9, 朝向: 270 },
  艾伦密室门外: { X: 15709.1, Y: -24275.2, 朝向: 270 },
  里凡特密室门外: { X: 16102.0, Y: -24243.5, 朝向: 270 },
  耶提尔返回王宫: { X: 15947.6, Y: -24545.3, 朝向: 90 },
} as const satisfies Record<string, 王宫密室场景站位>;

export const 王宫密室演出特效表 = {
  里科特进入传承密室: { 模型路径: "Common\\Effect\\Form\\Portal\\RicketSecretRoomShift.mdx", 持续秒: 3 },
  里科特战后撤离: { 模型路径: "Common\\Effect\\Form\\Portal\\RicketVoidEscape.mdx", 持续秒: 3 },
  玩家队伍抵达传承密室: { 模型路径: "Common\\Effect\\Form\\Portal\\PalaceSecretRoomArrival.mdx", 持续秒: 4 },
  里凡特开启传承密室门: { 模型路径: "Common\\Effect\\Form\\Portal\\RoyalBloodlineGate.mdx", 持续秒: 8 },
} as const;

export type 王宫密室演出特效键 = keyof typeof 王宫密室演出特效表;

let 当前玩家队伍转场站位: 王宫密室场景站位 | undefined;

function 定位单位(this: void, unit: any, 站位: 王宫密室场景站位): void {
  if (unit == null || unit === 0) return;
  SetUnitPosition(unit, 站位.X, 站位.Y);
  SetUnitFacing(unit, 站位.朝向);
  IssueImmediateOrder(unit, "stop");
}

function on移动枚举玩家英雄至密室(this: void): void {
  const 站位 = 当前玩家队伍转场站位;
  if (站位 == null) return;
  定位单位(GetEnumUnit(), 站位);
}

export function 定位并登记王宫密室剧情单位(
  this: void,
  读取引用: string,
  登记引用: string,
  站位: 王宫密室场景站位,
): any {
  const unit = 读取语义单位引用(读取引用);
  if (unit == null || unit === 0) return null;
  定位单位(unit, 站位);
  注册剧情运行时单位(登记引用, unit);
  return unit;
}

export function 读取或创建并定位王宫密室剧情单位(
  this: void,
  语义引用: string,
  单位名: string,
  站位: 王宫密室场景站位,
): any {
  let unit = 读取语义单位引用(语义引用);
  if (unit == null || unit === 0) {
    const 单位类型ID = stringToFourCCSafe(按名字反查总单位ID(单位名));
    if (!(单位类型ID > 0)) return null;
    unit = 创建单位并登记排泄安全(Player(中立被动玩家ID), 单位类型ID, 站位.X, 站位.Y, 站位.朝向);
  }
  if (unit == null || unit === 0) return null;
  定位单位(unit, 站位);
  注册剧情运行时单位(语义引用, unit);
  return unit;
}

export function 播放王宫密室演出特效(
  this: void,
  特效键: 王宫密室演出特效键,
  站位: 王宫密室场景站位,
): void {
  const 特效 = 王宫密室演出特效表[特效键];
  createTimedEffect(特效.模型路径, 站位.X, 站位.Y, 0, 特效.持续秒);
}

export function 移动玩家英雄组到王宫密室(this: void): void {
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0) return;
  当前玩家队伍转场站位 = 王宫密室场景站位表.玩家队伍密室对白;
  ForGroup(玩家英雄组, on移动枚举玩家英雄至密室);
  当前玩家队伍转场站位 = undefined;
}
