/** @noSelfInFile */
/**
 * 核心系统 - 特效绑定系统
 *
 * 职责（与 lib…04．EC扩展库 分工）：
 * - `EC_CreateEffect` 已负责：AddSpecialEffect、Size、Z（地形高程 + 传入 z）、旋转、速度、定时销毁。
 * - 本文件只负责：**单位绑定**、Map 生命周期、中心计时器每帧 **XY/Z 跟随**、以及 **顶点染色**（Dz）。
 *
 * 创建时传入 EC 的 z 参数须为「飞行高度 + 相对偏移」，**不要**再叠加 EC_GetPointZ，
 * 否则与 EC 内部的 `EC_GetPointZ(x,y)+z` 重复计算地形高度。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { EC_CreateEffect, EC_GetPointZ } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (path: string, x: number, y: number, z: number, fac: number, size: number, s: number, time: number) => any;
  EC_GetPointZ: (x: number, y: number) => number;
};

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (callback: () => void) => void;
  offTick10ms: (callback: () => void) => void;
};

// ==========================================================================================
// 类型定义
// ==========================================================================================

/** 绑定特效数据 */
interface BoundEffectData {
  effect: any;
  unit: any;
  heightOffset: number;
  scale: number;
  facing: number;
  animSpeed: number;
}

// ==========================================================================================
// 常量
// ==========================================================================================

/** 进度条模型路径 */
export const PROGRESSBAR_MODEL = "resource\\models\\Common\\Progressbar.mdx";

/** 默认黄色颜色 (R=255, G=255, B=0, A=255) */
export const COLOR_YELLOW = { r: 255, g: 255, b: 0, a: 255 };

/** 默认高度偏移 */
export const DEFAULT_HEIGHT_OFFSET = 233.0;

/** 默认缩放 */
export const DEFAULT_SCALE = 3.0;

/** 默认动画速度 (1.0 = 正常速度，越大越快) */
export const DEFAULT_ANIM_SPEED = 1.0;

// ==========================================================================================
// 数据存储
// ==========================================================================================

const boundEffects = new Map<any, BoundEffectData>();
const unitToEffectMap = new Map<number, any>();
let _isRegistered = false;

// ==========================================================================================
// 内部工具
// ==========================================================================================

function getUnitId(unit: any): number {
  if (!unit) return 0;
  return jass.GetHandleId(unit);
}

function destroyEffect(effect: any): void {
  if (!effect) return;
  jass.DestroyEffect(effect);
}

/**
 * 更新所有绑定特效的位置（世界 Z = 地形 + 飞行高度 + 记录的高度偏移）
 */
function updateBoundEffects(): void {
  for (const [effect, data] of boundEffects) {
    if (!data.unit) {
      removeBoundEffect(effect);
      continue;
    }

    const unitX = jass.GetUnitX(data.unit);
    const unitY = jass.GetUnitY(data.unit);

    const unitFlyHeight = jass.GetUnitFlyHeight(data.unit);
    const z = EC_GetPointZ(unitX, unitY) + unitFlyHeight + data.heightOffset;

    japi.EXSetEffectXY(effect, unitX, unitY);
    japi.EXSetEffectZ(effect, z);
  }

  if (boundEffects.size === 0 && _isRegistered) {
    offTick10ms(updateBoundEffects);
    _isRegistered = false;
  }
}

function ensureRegistered(): void {
  if (_isRegistered) return;
  _isRegistered = true;
  onTick10ms(updateBoundEffects);
}

// ==========================================================================================
// 对外 API
// ==========================================================================================

/**
 * 创建绑定到单位的特效
 * @param zForEC 传入 EC_CreateEffect 的 z：仅「飞行高度 + 相对地形/单位的竖直偏移」，不含地形采样
 */
export function createBoundEffect(
  unit: any,
  modelPath: string,
  options?: {
    heightOffset?: number;
    scale?: number;
    facing?: number;
    animSpeed?: number;
    color?: { r: number; g: number; b: number; a: number };
  }
): any {
  if (!unit) return null;

  const unitId = getUnitId(unit);
  const existingEffect = unitToEffectMap.get(unitId);
  if (existingEffect) {
    removeBoundEffect(existingEffect);
  }

  const unitX = jass.GetUnitX(unit);
  const unitY = jass.GetUnitY(unit);
  const unitFlyHeight = jass.GetUnitFlyHeight(unit);

  const heightOffset = options?.heightOffset ?? DEFAULT_HEIGHT_OFFSET;
  const scale = options?.scale ?? DEFAULT_SCALE;
  const facing = options?.facing ?? 0;
  const animSpeed = options?.animSpeed ?? DEFAULT_ANIM_SPEED;
  const color = options?.color ?? COLOR_YELLOW;

  /** EC 内部会再加 EC_GetPointZ(x,y)，此处只传飞行高度与自定义竖直偏移 */
  const zForEc = unitFlyHeight + heightOffset;

  const effect = EC_CreateEffect(modelPath, unitX, unitY, zForEc, facing, scale, animSpeed, -1);

  if (!effect) return null;

  const colorValue = japi.DzGetColor(color.r, color.g, color.b, color.a);
  japi.DzSetEffectVertexColor(effect, colorValue);

  const data: BoundEffectData = {
    effect,
    unit,
    heightOffset,
    scale,
    facing,
    animSpeed,
  };

  boundEffects.set(effect, data);
  unitToEffectMap.set(unitId, effect);

  ensureRegistered();

  return effect;
}

/**
 * 创建黄色进度条特效（默认配置）
 */
export function createProgressBarEffect(unit: any, animSpeed: number = 1.0): any {
  return createBoundEffect(unit, PROGRESSBAR_MODEL, {
    heightOffset: DEFAULT_HEIGHT_OFFSET,
    scale: DEFAULT_SCALE,
    animSpeed,
    color: COLOR_YELLOW,
  });
}

export function removeBoundEffect(effect: any): void {
  if (!effect) return;

  const data = boundEffects.get(effect);
  if (data) {
    const unitId = getUnitId(data.unit);
    unitToEffectMap.delete(unitId);
  }

  boundEffects.delete(effect);
  destroyEffect(effect);
}

export function removeUnitBoundEffect(unit: any): void {
  if (!unit) return;
  const unitId = getUnitId(unit);
  const effect = unitToEffectMap.get(unitId);
  if (effect) {
    removeBoundEffect(effect);
  }
}

export function hasBoundEffect(unit: any): boolean {
  if (!unit) return false;
  const unitId = getUnitId(unit);
  return unitToEffectMap.has(unitId);
}

export function getUnitBoundEffect(unit: any): any {
  if (!unit) return undefined;
  const unitId = getUnitId(unit);
  return unitToEffectMap.get(unitId);
}

export function setEffectAnimSpeed(effect: any, speed: number): void {
  if (!effect) return;
  japi.EXSetEffectSpeed(effect, speed);

  const data = boundEffects.get(effect);
  if (data) {
    data.animSpeed = speed;
  }
}

export function clearAllBoundEffects(): void {
  for (const [effect] of boundEffects) {
    destroyEffect(effect);
  }
  boundEffects.clear();
  unitToEffectMap.clear();

  if (_isRegistered) {
    offTick10ms(updateBoundEffects);
    _isRegistered = false;
  }
}

export {};
