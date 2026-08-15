/** @noSelfInFile */
// 黑崎一护运行时状态表：卍解、A键武装、瞬步连携窗口、Q弹道位置（D连携用）。
// 源 YDUserData(string,"黑崎一护",...) 全局表迁移为单位级状态记录，句柄ID 索引。

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;

export interface 黑崎一护状态 {
  英雄句柄ID: number;
  施法者: any;
  // R：卍解
  卍解: boolean;
  卍解倒计时回调ID: number;
  移速已突破: boolean;
  // A键：黑流牙突
  A键已武装: boolean;
  // D：瞬步连携窗口
  瞬步连携: boolean;
  连携窗口回调ID: number;
  // Q：月牙弹道位置（D 瞬步可飞向未结束的月牙）
  月牙飞行中: boolean;
  月牙X: number;
  月牙Y: number;
}

const 状态表: Record<number, 黑崎一护状态> = {};

export function 获取或创建黑崎一护状态(this: void, 单位: any): 黑崎一护状态 {
  const id = GetHandleId(单位);
  let record = 状态表[id];
  if (record == null) {
    record = {
      英雄句柄ID: id,
      施法者: 单位,
      卍解: false,
      卍解倒计时回调ID: 0,
      移速已突破: false,
      A键已武装: false,
      瞬步连携: false,
      连携窗口回调ID: 0,
      月牙飞行中: false,
      月牙X: 0,
      月牙Y: 0,
    };
    状态表[id] = record;
  }
  return record;
}

export function 获取黑崎一护状态(this: void, 单位: any): 黑崎一护状态 | undefined {
  if (单位 == null || 单位 === 0) return undefined;
  return 状态表[GetHandleId(单位)];
}

export function 黑崎一护是否卍解(this: void, 单位: any): boolean {
  const record = 获取黑崎一护状态(单位);
  return record != null && record.卍解 === true;
}

export function 设置黑崎一护卍解(this: void, 单位: any, 开启: boolean): void {
  const record = 获取或创建黑崎一护状态(单位);
  record.卍解 = 开启;
}

// --- A键武装 ---

export function 武装黑崎一护A键(this: void, 单位: any): void {
  获取或创建黑崎一护状态(单位).A键已武装 = true;
}

export function 解除黑崎一护A键武装(this: void, 单位: any): void {
  const record = 获取黑崎一护状态(单位);
  if (record != null) record.A键已武装 = false;
}

export function 黑崎一护A键是否武装(this: void, 单位: any): boolean {
  const record = 获取黑崎一护状态(单位);
  return record != null && record.A键已武装 === true;
}

// --- 瞬步连携窗口 ---

export function 开启瞬步连携(this: void, 单位: any): void {
  获取或创建黑崎一护状态(单位).瞬步连携 = true;
}

export function 关闭瞬步连携(this: void, 单位: any): void {
  const record = 获取黑崎一护状态(单位);
  if (record != null) record.瞬步连携 = false;
}

export function 是否瞬步连携中(this: void, 单位: any): boolean {
  const record = 获取黑崎一护状态(单位);
  return record != null && record.瞬步连携 === true;
}

// --- Q 月牙弹道位置 ---

export function 记录月牙位置(this: void, 单位: any, x: number, y: number): void {
  const record = 获取或创建黑崎一护状态(单位);
  record.月牙飞行中 = true;
  record.月牙X = x;
  record.月牙Y = y;
}

export function 清除月牙位置(this: void, 单位: any): void {
  const record = 获取黑崎一护状态(单位);
  if (record == null) return;
  record.月牙飞行中 = false;
}

export function 月牙是否飞行中(this: void, 单位: any): boolean {
  const record = 获取黑崎一护状态(单位);
  return record != null && record.月牙飞行中 === true;
}

export function 清理黑崎一护状态(this: void, 单位: any): void {
  const id = GetHandleId(单位);
  delete 状态表[id];
}

export {};
