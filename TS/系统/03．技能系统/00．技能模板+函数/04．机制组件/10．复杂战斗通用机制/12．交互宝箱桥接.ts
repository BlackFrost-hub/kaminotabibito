/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const CreateDestructable = jass.CreateDestructable as (objectid: number, x: number, y: number, face: number, scale: number, variation: number) => any;
const RemoveDestructable = jass.RemoveDestructable as (d: any) => void;
const GetHandleId = jass.GetHandleId as (h: any) => number;

const { 注册宝箱开启中回调 } = require("系统.06．经济系统.00．宝箱系统.05．开启中回调") as {
  注册宝箱开启中回调: (this: void, callback: (this: void, unit: any, target: any, progressBar: any, openTime: number, elapsed: number, chestConfig: any, ownerUnit?: any) => void) => void;
};
const { 注册宝箱开启完成回调 } = require("系统.06．经济系统.00．宝箱系统.06．开启完成回调") as {
  注册宝箱开启完成回调: (this: void, callback: (this: void, unit: any, target: any, progressBar: any, openTime: number, chestConfig: any, ownerUnit?: any) => void) => void;
};

export interface 交互宝箱参数 {
  清理?: 机制清理篮子;
  名称: string;
  可破坏物ID: string;
  X: number;
  Y: number;
  朝向?: number;
  缩放?: number;
  变量?: any;
  on开启中?: (this: void, 开启者: any, 宝箱: any, 已用时间: number, 配置: any, 变量: any) => void;
  on开启完成?: (this: void, 开启者: any, 宝箱: any, 配置: any, 变量: any) => void;
}

export interface 交互宝箱实例 {
  readonly 宝箱: any;
  销毁(): void;
}

interface 交互宝箱记录 {
  参数: 交互宝箱参数;
  实例: 交互宝箱实例;
}

const 交互宝箱表: Record<number, 交互宝箱记录 | undefined> = {};
let 已注册宝箱回调 = false;

function stringToFourCC(this: void, s: string): number {
  const a = s.length > 0 ? s.charCodeAt(0) : 0;
  const b = s.length > 1 ? s.charCodeAt(1) : 0;
  const c = s.length > 2 ? s.charCodeAt(2) : 0;
  const d = s.length > 3 ? s.charCodeAt(3) : 0;
  return a * 16777216 + b * 65536 + c * 256 + d;
}

function on交互宝箱开启中(this: void, unit: any, target: any, _progressBar: any, _openTime: number, elapsed: number, chestConfig: any, _ownerUnit?: any): void {
  const 记录 = 交互宝箱表[GetHandleId(target)];
  if (记录 == null || 记录.参数.on开启中 == null) return;
  记录.参数.on开启中(unit, target, elapsed, chestConfig, 记录.参数.变量);
}

function on交互宝箱开启完成(this: void, unit: any, target: any, _progressBar: any, _openTime: number, chestConfig: any, _ownerUnit?: any): void {
  const id = GetHandleId(target);
  const 记录 = 交互宝箱表[id];
  if (记录 == null) return;
  if (记录.参数.on开启完成 != null) 记录.参数.on开启完成(unit, target, chestConfig, 记录.参数.变量);
  delete 交互宝箱表[id];
}

function 确保交互宝箱回调(this: void): void {
  if (已注册宝箱回调) return;
  已注册宝箱回调 = true;
  注册宝箱开启中回调(on交互宝箱开启中);
  注册宝箱开启完成回调(on交互宝箱开启完成);
}

class 交互宝箱实例实现 implements 交互宝箱实例 {
  readonly 宝箱: any;
  private 已销毁 = false;

  constructor(宝箱: any) {
    this.宝箱 = 宝箱;
  }

  销毁(): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    delete 交互宝箱表[GetHandleId(this.宝箱)];
    if (this.宝箱 != null && this.宝箱 !== 0) RemoveDestructable(this.宝箱);
  }
}

export function 创建交互宝箱(this: void, 参数: 交互宝箱参数): 交互宝箱实例 | undefined {
  确保交互宝箱回调();
  const 宝箱 = CreateDestructable(stringToFourCC(参数.可破坏物ID), 参数.X, 参数.Y, 参数.朝向 ?? 0, 参数.缩放 ?? 1, 0);
  if (宝箱 == null || 宝箱 === 0) return undefined;
  const 实例 = new 交互宝箱实例实现(宝箱);
  交互宝箱表[GetHandleId(宝箱)] = { 参数, 实例 };
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 交互宝箱清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}
