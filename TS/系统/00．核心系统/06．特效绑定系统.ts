/** @noSelfInFile */
/**
 * 核心系统 - 特效绑定系统
 *
 * 功能：
 * 1. 创建绑定到单位的特效（如进度条）
 * 2. 使用 JAPI 函数设置特效颜色和坐标
 * 3. 通过中心计时器实时更新位置跟随单位
 *
 * 特点：
 * - 使用 EC_CreateEffect 创建特效
 * - 使用 DzGetColor / DzSetEffectVertexColor 设置颜色
 * - 使用 EXSetEffectXY 设置坐标
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
  /** 特效句柄 */
  effect: any;
  /** 绑定的单位 */
  unit: any;
  /** 高度偏移 */
  heightOffset: number;
  /** 缩放 */
  scale: number;
  /** 旋转角度 */
  facing: number;
  /** 动画速度 */
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

/** 绑定特效映射：特效句柄 -> 绑定数据 */
const boundEffects = new Map<any, BoundEffectData>();

/** 单位到特效的映射：单位句柄 -> 特效句柄（方便快速查找） */
const unitToEffectMap = new Map<number, any>();

/** 是否已注册到中心计时器 */
let _isRegistered = false;

// ==========================================================================================
// 工具函数
// ==========================================================================================

/**
 * 使用 DzGetColor 生成颜色值
 * @param r 红色 (0-255)
 * @param g 绿色 (0-255)
 * @param b 蓝色 (0-255)
 * @param a 透明度 (0-255)
 */
export function DzGetColor(r: number, g: number, b: number, a: number): number {
  if (typeof japi.DzGetColor === "function") {
    return japi.DzGetColor(r, g, b, a);
  }
  // 降级：手动计算 ARGB
  return (a << 24) | (r << 16) | (g << 8) | b;
}

/**
 * 设置特效顶点颜色
 * @param effect 特效句柄
 * @param color 颜色值（由 DzGetColor 生成）
 */
export function DzSetEffectVertexColor(effect: any, color: number): void {
  if (!effect) return;
  if (typeof japi.DzSetEffectVertexColor === "function") {
    japi.DzSetEffectVertexColor(effect, color);
  }
}

/**
 * 设置特效坐标
 * @param effect 特效句柄
 * @param x X坐标
 * @param y Y坐标
 */
export function EXSetEffectXY(effect: any, x: number, y: number): void {
  if (!effect) return;
  if (typeof japi.EXSetEffectXY === "function") {
    japi.EXSetEffectXY(effect, x, y);
  }
}

/**
 * 设置特效Z轴高度
 * @param effect 特效句柄
 * @param z Z轴高度
 */
export function EXSetEffectZ(effect: any, z: number): void {
  if (!effect) return;
  if (typeof japi.EXSetEffectZ === "function") {
    japi.EXSetEffectZ(effect, z);
  }
}

/**
 * 设置特效缩放
 * @param effect 特效句柄
 * @param scale 缩放值
 */
export function EXSetEffectSize(effect: any, scale: number): void {
  if (!effect) return;
  if (typeof japi.EXSetEffectSize === "function") {
    japi.EXSetEffectSize(effect, scale);
  }
}

/**
 * 设置特效动画速度
 * @param effect 特效句柄
 * @param speed 速度倍数
 */
export function EXSetEffectSpeed(effect: any, speed: number): void {
  if (!effect) return;
  if (typeof japi.EXSetEffectSpeed === "function") {
    japi.EXSetEffectSpeed(effect, speed);
  }
}

/**
 * 获取单位HandleId
 */
function getUnitId(unit: any): number {
  if (!unit || typeof jass.GetHandleId !== "function") return 0;
  return jass.GetHandleId(unit);
}

/**
 * 销毁特效
 */
function destroyEffect(effect: any): void {
  if (!effect) return;
  if (typeof jass.DestroyEffect === "function") {
    jass.DestroyEffect(effect);
  }
}

// ==========================================================================================
// 核心功能
// ==========================================================================================

/**
 * 更新所有绑定特效的位置
 */
function updateBoundEffects(): void {
  for (const [effect, data] of boundEffects) {
    if (!data.unit) {
      removeBoundEffect(effect);
      continue;
    }

    // 获取单位当前位置
    const unitX = jass.GetUnitX?.(data.unit);
    const unitY = jass.GetUnitY?.(data.unit);

    if (unitX === undefined || unitY === undefined) {
      removeBoundEffect(effect);
      continue;
    }

    // 计算Z轴高度（地形高度 + 单位飞行高度 + 偏移）
    const unitFlyHeight = jass.GetUnitFlyHeight?.(data.unit) ?? 0;
    const z = EC_GetPointZ(unitX, unitY) + unitFlyHeight + data.heightOffset;

    // 使用 EXSetEffectXY 更新坐标
    EXSetEffectXY(effect, unitX, unitY);
    EXSetEffectZ(effect, z);
  }

  // 如果没有特效了，取消注册
  if (boundEffects.size === 0 && _isRegistered) {
    offTick10ms(updateBoundEffects);
    _isRegistered = false;
  }
}

/**
 * 确保已注册到中心计时器
 */
function ensureRegistered(): void {
  if (_isRegistered) return;
  _isRegistered = true;
  onTick10ms(updateBoundEffects);
}

/**
 * 创建绑定到单位的特效
 * @param unit 目标单位
 * @param modelPath 模型路径
 * @param options 可选配置
 * @returns 特效句柄，创建失败返回 null
 */
export function createBoundEffect(
  unit: any,
  modelPath: string,
  options?: {
    /** 高度偏移（默认 233.0） */
    heightOffset?: number;
    /** 缩放（默认 3.0） */
    scale?: number;
    /** 初始面向角度（默认 0） */
    facing?: number;
    /** 动画速度（默认 1.0） */
    animSpeed?: number;
    /** 颜色（默认黄色） */
    color?: { r: number; g: number; b: number; a: number };
  }
): any {
  if (!unit) return null;

  // 先移除该单位已有的绑定特效
  const unitId = getUnitId(unit);
  const existingEffect = unitToEffectMap.get(unitId);
  if (existingEffect) {
    removeBoundEffect(existingEffect);
  }

  // 获取单位当前位置
  const unitX = jass.GetUnitX?.(unit) ?? 0;
  const unitY = jass.GetUnitY?.(unit) ?? 0;
  const unitFlyHeight = jass.GetUnitFlyHeight?.(unit) ?? 0;

  // 应用默认选项
  const heightOffset = options?.heightOffset ?? DEFAULT_HEIGHT_OFFSET;
  const scale = options?.scale ?? DEFAULT_SCALE;
  const facing = options?.facing ?? 0;
  const animSpeed = options?.animSpeed ?? DEFAULT_ANIM_SPEED;
  const color = options?.color ?? COLOR_YELLOW;

  // 计算初始Z轴
  const z = EC_GetPointZ(unitX, unitY) + unitFlyHeight + heightOffset;

  // 创建特效（time = -1 表示不自动销毁）
  const effect = EC_CreateEffect(modelPath, unitX, unitY, z, facing, scale, animSpeed, -1);

  if (!effect) return null;

  // 设置颜色
  const colorValue = DzGetColor(color.r, color.g, color.b, color.a);
  DzSetEffectVertexColor(effect, colorValue);

  // 存储绑定数据
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

  // 注册到中心计时器
  ensureRegistered();

  return effect;
}

/**
 * 创建黄色进度条特效（默认配置）
 * @param unit 目标单位
 * @param animSpeed 动画速度（默认 1.0，开启时间越短速度越快）
 * @returns 特效句柄
 */
export function createProgressBarEffect(unit: any, animSpeed: number = 1.0): any {
  return createBoundEffect(unit, PROGRESSBAR_MODEL, {
    heightOffset: DEFAULT_HEIGHT_OFFSET,
    scale: DEFAULT_SCALE,
    animSpeed,
    color: COLOR_YELLOW,
  });
}

/**
 * 移除绑定特效
 * @param effect 特效句柄
 */
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

/**
 * 移除单位绑定的特效
 * @param unit 目标单位
 */
export function removeUnitBoundEffect(unit: any): void {
  if (!unit) return;
  const unitId = getUnitId(unit);
  const effect = unitToEffectMap.get(unitId);
  if (effect) {
    removeBoundEffect(effect);
  }
}

/**
 * 检查单位是否有绑定特效
 * @param unit 目标单位
 */
export function hasBoundEffect(unit: any): boolean {
  if (!unit) return false;
  const unitId = getUnitId(unit);
  return unitToEffectMap.has(unitId);
}

/**
 * 获取单位绑定的特效
 * @param unit 目标单位
 * @returns 特效句柄或 undefined
 */
export function getUnitBoundEffect(unit: any): any {
  if (!unit) return undefined;
  const unitId = getUnitId(unit);
  return unitToEffectMap.get(unitId);
}

/**
 * 设置特效动画速度（用于控制进度条速度）
 * @param effect 特效句柄
 * @param speed 速度倍数（开启时间越短，速度越大）
 */
export function setEffectAnimSpeed(effect: any, speed: number): void {
  if (!effect) return;
  EXSetEffectSpeed(effect, speed);

  const data = boundEffects.get(effect);
  if (data) {
    data.animSpeed = speed;
  }
}

/**
 * 清理所有绑定特效
 */
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
