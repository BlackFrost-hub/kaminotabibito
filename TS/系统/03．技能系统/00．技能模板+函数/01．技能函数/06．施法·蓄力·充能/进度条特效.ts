/** @noSelfInFile */
/**
 * 进度条特效模块（施法进度条）
 *
 * 说明：
 * 1. 直接创建独立点特效，不绑定单位或附着点
 * 2. 进度条颜色、动画速度、动画序号都通过特效接口控制
 * 3. 由中心计时器每 0.03 秒刷新到单位坐标与飞行高度之上
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

const PROGRESSBAR_MODEL = "war3mapImported\\Progressbar.mdx";
export const 默认进度条高度偏移 = 233.0;
const FOLLOW_INTERVAL_MS = 30;
const DEFAULT_SCALE = 1.5;
const DEFAULT_ANIM_INDEX = 0;
const DEFAULT_COLOR_RGBA = { r: 255, g: 255, b: 0, a: 255 };
const UNIT_ALIVE_LIFE = 0.405;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (u: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (u: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const DzSetEffectScale = japi.DzSetEffectScale as (effect: any, scale: number) => void;
const DzSetEffectAnimation = japi.DzSetEffectAnimation as (effect: any, animationIndex: number, flag: number) => void;
const EXSetEffectSpeed = japi.EXSetEffectSpeed as (effect: any, speed: number) => void;
const EXSetEffectXY = japi.EXSetEffectXY as (effect: any, x: number, y: number) => void;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const DzSetEffectVertexColor = japi.DzSetEffectVertexColor as (effect: any, color: number) => void;
const DzGetColor = japi.DzGetColor as (alpha: number, red: number, green: number, blue: number) => number;

export interface 进度条特效选项 {
  高度偏移?: number;
  缩放?: number;
  动画序号?: number;
  动画速度?: number;
  颜色?: { r: number; g: number; b: number; a: number };
}

interface 进度条特效数据 {
  进度条特效: any;
  跟随单位: any;
  跟随单位ID: number;
  高度偏移: number;
}

const 进度条映射 = new Map<number, 进度条特效数据>();
const 单位进度条映射 = new Map<number, any>();
let 跟随回调ID = 0;

function 取句柄ID(h: any): number {
  if (h == null || h === 0) return 0;
  return GetHandleId(h);
}

function 获取有序进度条特效ID列表(): number[] {
  const ids: number[] = [];
  for (const id of 进度条映射.keys()) {
    ids.push(id);
  }
  ids.sort((a, b) => a - b);
  return ids;
}

function 单位存活(u: any): boolean {
  if (u == null || u === 0) return false;
  if (GetUnitTypeId(u) === 0) return false;
  if (IsUnitType(u, jass.UNIT_TYPE_DEAD)) return false;
  return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 刷新进度条位置(this: void, 数据: 进度条特效数据): void {
  EXSetEffectXY(数据.进度条特效, GetUnitX(数据.跟随单位), GetUnitY(数据.跟随单位));
  EXSetEffectZ(数据.进度条特效, GetUnitFlyHeight(数据.跟随单位) + 数据.高度偏移);
}

function 刷新所有进度条位置(this: void): void {
  const ids = 获取有序进度条特效ID列表();
  for (let i = 0; i < ids.length; i++) {
    const 数据 = 进度条映射.get(ids[i]);
    if (数据 == null) continue;
    if (!单位存活(数据.跟随单位)) {
      移除进度条特效(数据.进度条特效);
      continue;
    }
    刷新进度条位置(数据);
  }
}

function 确保进度条跟随驱动(this: void): void {
  if (跟随回调ID !== 0) return;
  跟随回调ID = addPeriodicCallback(FOLLOW_INTERVAL_MS, 刷新所有进度条位置);
}

function 尝试停止进度条跟随驱动(this: void): void {
  if (进度条映射.size > 0 || 跟随回调ID === 0) return;
  removePeriodicCallback(跟随回调ID);
  跟随回调ID = 0;
}

function 裁剪到字节(value: number): number {
  if (value <= 0) return 0;
  if (value >= 255) return 255;
  return jass.R2I(value);
}

function 移除进度条特效(进度条特效: any): void {
  if (进度条特效 == null || 进度条特效 === 0) return;

  const 进度条特效ID = 取句柄ID(进度条特效);
  const 数据 = 进度条映射.get(进度条特效ID);
  if (数据 != null) {
    单位进度条映射.delete(数据.跟随单位ID);
  }

  进度条映射.delete(进度条特效ID);
  DzSetEffectScale(进度条特效, 0);
  DestroyEffect(进度条特效);
  尝试停止进度条跟随驱动();
}

export function 创建进度条特效(单位: any, 选项?: 进度条特效选项): any {
  if (!单位存活(单位)) return null;

  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return null;

  const 已有进度条 = 单位进度条映射.get(单位ID);
  if (已有进度条 != null) {
    移除进度条特效(已有进度条);
  }

  const 缩放 = 选项?.缩放 ?? DEFAULT_SCALE;
  const 动画序号 = 选项?.动画序号 ?? DEFAULT_ANIM_INDEX;
  const 动画速度 = 选项?.动画速度;
  const 颜色 = 选项?.颜色 ?? DEFAULT_COLOR_RGBA;
  const 高度偏移 = 选项?.高度偏移 ?? 默认进度条高度偏移;
  const x = GetUnitX(单位);
  const y = GetUnitY(单位);
  const z = GetUnitFlyHeight(单位) + 高度偏移;
  const 进度条特效 = EC_CreateEffect(PROGRESSBAR_MODEL, x, y, z, 0, 缩放, 动画速度 ?? 1, -1);
  if (进度条特效 == null || 进度条特效 === 0) return null;
  DzSetEffectVertexColor(进度条特效, DzGetColor(
    裁剪到字节(颜色.a),
    裁剪到字节(颜色.r),
    裁剪到字节(颜色.g),
    裁剪到字节(颜色.b),
  ));
  // 进度条动画的原始周期为1秒：持续5秒使用0.2，持续3秒使用1/3。
  DzSetEffectAnimation(进度条特效, 动画序号, 0);
  EXSetEffectSpeed(进度条特效, 动画速度 ?? 1);

  const 数据: 进度条特效数据 = {
    进度条特效,
    跟随单位: 单位,
    跟随单位ID: 单位ID,
    高度偏移,
  };

  进度条映射.set(取句柄ID(进度条特效), 数据);
  单位进度条映射.set(单位ID, 进度条特效);
  刷新进度条位置(数据);
  确保进度条跟随驱动();

  return 进度条特效;
}

export function 销毁进度条特效(进度条单位: any): void {
  移除进度条特效(进度条单位);
}

export function 销毁单位进度条特效(单位: any): void {
  if (单位 == null || 单位 === 0) return;
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return;

  const 进度条单位 = 单位进度条映射.get(单位ID);
  if (进度条单位 != null) {
    移除进度条特效(进度条单位);
  }

}

export function 是否存在进度条特效(单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return 单位进度条映射.has(取句柄ID(单位));
}

export function 获取单位进度条特效(单位: any): any {
  if (单位 == null || 单位 === 0) return undefined;
  return 单位进度条映射.get(取句柄ID(单位));
}

export function 清除所有进度条特效(): void {
  const 进度条特效ID列表 = 获取有序进度条特效ID列表();
  for (let i = 0; i < 进度条特效ID列表.length; i++) {
    const 数据 = 进度条映射.get(进度条特效ID列表[i]);
    if (数据 != null) {
      DzSetEffectScale(数据.进度条特效, 0);
      DestroyEffect(数据.进度条特效);
    }
  }
  进度条映射.clear();
  单位进度条映射.clear();
  尝试停止进度条跟随驱动();
}

const g = globalThis as any;
if (typeof g.创建进度条特效 !== "function") {
  g.创建进度条特效 = 创建进度条特效;
}
if (typeof g.销毁单位进度条特效 !== "function") {
  g.销毁单位进度条特效 = 销毁单位进度条特效;
}

export {};
