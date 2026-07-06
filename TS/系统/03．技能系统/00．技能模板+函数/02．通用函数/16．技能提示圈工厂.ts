/** @noSelfInFile */
/**
 * 技能提示圈工厂
 *
 * 目标：
 * 1. 调用方可以显式指定圆形、矩形、扇形、安全圆等提示圈。
 * 2. 调用方也可以传 `类型: "自动"`，由常见字段推断提示圈类型。
 * 3. 这里只负责创建提示表现，不承担伤害、筛选、命中、吟唱条等技能逻辑。
 */

const jass = require("jass.common") as any;
import type { 技能距离修正用途, 英雄技能距离修正上下文 } from "../04．机制组件/11．技能属性修正";

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;

const {
  创建矩形提示圈,
  创建红色扇形提示圈,
  创建薄圆形提示圈,
  创建白色圆形提示圈,
  创建渐变圆形提示圈,
  创建双环提示圈,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  创建矩形提示圈: (this: void, x: number, y: number, width: number, long: number, fac: number, time: number, speed?: number) => void;
  创建红色扇形提示圈: (this: void, x: number, y: number, fac: number, size: number, time: number, speed?: number) => void;
  创建薄圆形提示圈: (this: void, x: number, y: number, r: number, time: number, speed?: number) => void;
  创建白色圆形提示圈: (this: void, x: number, y: number, r: number, time: number, speed?: number) => void;
  创建渐变圆形提示圈: (this: void, x: number, y: number, r: number, time: number, speed?: number) => any;
  创建双环提示圈: (this: void, x: number, y: number, r: number, time: number, speed?: number) => any;
};
const { 按英雄技能距离修正上下文修正距离 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index") as {
  按英雄技能距离修正上下文修正距离: (this: void, 基础距离: number, 上下文: any, 默认用途?: string) => number;
};

export type 技能提示圈类型 =
  | "自动"
  | "无"
  | "圆形"
  | "敌方圆形"
  | "渐变圆形"
  | "白色安全圆"
  | "双环"
  | "矩形"
  | "扇形"
  | "红色扇形";

export interface 技能提示圈配置 {
  类型?: 技能提示圈类型;
  X?: number;
  Y?: number;
  x?: number;
  y?: number;
  锚点单位?: any;
  来源单位?: any;
  半径?: number;
  提示半径?: number;
  伤害半径?: number;
  安全区半径?: number;
  外圈半径?: number;
  宽度?: number;
  长度?: number;
  英雄技能距离修正?: 英雄技能距离修正上下文;
  朝向?: number;
  方向角?: number;
  扇形角度?: number;
  扇形模型尺寸?: number;
  持续时间?: number;
  预警秒?: number;
  延迟时间?: number;
  动画速度?: number;
}

function 转数字(this: void, value: any, 默认值: number): number {
  if (value == null || value === false || value === "") return 默认值;
  const n = typeof value === "number" ? value : Number(value);
  return n === n ? n : 默认值;
}

function 取锚点单位(this: void, 配置: 技能提示圈配置): any {
  if (配置.锚点单位 != null && 配置.锚点单位 !== 0) return 配置.锚点单位;
  if (配置.来源单位 != null && 配置.来源单位 !== 0) return 配置.来源单位;
  return null;
}

function 取X(this: void, 配置: 技能提示圈配置): number {
  const unit = 取锚点单位(配置);
  if (配置.X != null) return 转数字(配置.X, 0);
  if (配置.x != null) return 转数字(配置.x, 0);
  return unit != null ? GetUnitX(unit) : 0;
}

function 取Y(this: void, 配置: 技能提示圈配置): number {
  const unit = 取锚点单位(配置);
  if (配置.Y != null) return 转数字(配置.Y, 0);
  if (配置.y != null) return 转数字(配置.y, 0);
  return unit != null ? GetUnitY(unit) : 0;
}

function 取朝向(this: void, 配置: 技能提示圈配置): number {
  const unit = 取锚点单位(配置);
  if (配置.朝向 != null) return 转数字(配置.朝向, 0);
  if (配置.方向角 != null) return 转数字(配置.方向角, 0);
  return unit != null ? GetUnitFacing(unit) : 0;
}

function 取持续时间(this: void, 配置: 技能提示圈配置): number {
  if (配置.持续时间 != null) return 转数字(配置.持续时间, 1);
  if (配置.预警秒 != null) return 转数字(配置.预警秒, 1);
  if (配置.延迟时间 != null) return 转数字(配置.延迟时间, 1);
  return 1;
}

function 修正提示距离(this: void, 配置: 技能提示圈配置, 基础距离: number, 默认用途: 技能距离修正用途): number {
  return 按英雄技能距离修正上下文修正距离(基础距离, 配置.英雄技能距离修正, 默认用途);
}

function 取半径(this: void, 配置: 技能提示圈配置, 默认用途: 技能距离修正用途 = "效果半径"): number {
  let 半径 = 0;
  if (配置.半径 != null) 半径 = 转数字(配置.半径, 0);
  else if (配置.提示半径 != null) 半径 = 转数字(配置.提示半径, 0);
  else if (配置.伤害半径 != null) 半径 = 转数字(配置.伤害半径, 0);
  else if (配置.安全区半径 != null) 半径 = 转数字(配置.安全区半径, 0);
  else if (配置.外圈半径 != null) 半径 = 转数字(配置.外圈半径, 0);
  return 修正提示距离(配置, 半径, 默认用途);
}

function 取扇形尺寸(this: void, 配置: 技能提示圈配置): number {
  if (配置.扇形模型尺寸 != null) return 转数字(配置.扇形模型尺寸, 0.01);
  const 半径 = 取半径(配置, "扇形半径");
  if (半径 <= 0) return 0.01;
  return 半径 / 512;
}

export function 推断技能提示圈类型(this: void, 配置: 技能提示圈配置): 技能提示圈类型 {
  const 类型 = 配置.类型 ?? "自动";
  if (类型 !== "自动") return 类型;
  if (配置.安全区半径 != null) return "白色安全圆";
  if (配置.宽度 != null && 配置.长度 != null) return "矩形";
  if (配置.扇形角度 != null || 配置.扇形模型尺寸 != null) return "红色扇形";
  if (配置.外圈半径 != null) return "双环";
  return "渐变圆形";
}

export function 创建技能提示圈(this: void, 配置: 技能提示圈配置): any {
  const 类型 = 推断技能提示圈类型(配置);
  if (类型 === "无") return null;

  const x = 取X(配置);
  const y = 取Y(配置);
  const 持续时间 = 取持续时间(配置);
  const 动画速度 = 配置.动画速度;

  if (类型 === "矩形") {
    const 宽度 = 转数字(配置.宽度, 0);
    const 长度 = 修正提示距离(配置, 转数字(配置.长度, 0), "矩形长度");
    if (宽度 <= 0 || 长度 <= 0) return null;
    创建矩形提示圈(x, y, 宽度, 长度, 取朝向(配置), 持续时间, 动画速度);
    return null;
  }

  if (类型 === "扇形" || 类型 === "红色扇形") {
    创建红色扇形提示圈(x, y, 取朝向(配置), 取扇形尺寸(配置), 持续时间, 动画速度);
    return null;
  }

  const 半径 = 取半径(配置);
  if (半径 <= 0) return null;

  if (类型 === "圆形" || 类型 === "敌方圆形") {
    创建薄圆形提示圈(x, y, 半径, 持续时间, 动画速度);
    return null;
  }
  if (类型 === "白色安全圆") {
    创建白色圆形提示圈(x, y, 半径, 持续时间, 动画速度);
    return null;
  }
  if (类型 === "双环") {
    return 创建双环提示圈(x, y, 半径, 持续时间, 动画速度);
  }

  return 创建渐变圆形提示圈(x, y, 半径, 持续时间, 动画速度);
}

export {};
