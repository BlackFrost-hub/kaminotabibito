/**
 * 特效封装函数
 * 创建和管理特效
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { withTimer } from "./02．计时器";

/**
 * 创建特效并在指定时间后自动销毁（自动处理 1.27 兼容）
 * @param modelPath 特效模型路径
 * @param x x坐标
 * @param y y坐标
 * @param z z坐标（可选，默认0）
 * @param duration 持续时间秒数（默认2秒）
 * @returns 特效句柄
 */
export function createTimedEffect(
  modelPath: string,
  x: number,
  y: number,
  z: number = 0,
  duration: number = 2
): any {
  let eff: any;
  if (typeof (jass as any).AddSpecialEffectZ === "function") {
    eff = (jass as any).AddSpecialEffectZ(modelPath, x, y, z);
  } else if (typeof (jass as any).AddSpecialEffect === "function") {
    eff = (jass as any).AddSpecialEffect(modelPath, x, y);
  }
  if (!eff) return null;

  withTimer(duration, () => {
    if (typeof (jass as any).DestroyEffect === "function") {
      (jass as any).DestroyEffect(eff);
    }
  });
  return eff;
}

/** 存储单位绑定的特效（key: 单位句柄ID, value: 特效句柄） */
const unitEffectMap: Map<number, any> = new Map();

/**
 * 在单位上创建绑定特效
 * @param unit 目标单位
 * @param attachPoint 绑定点（如 "overhead", "origin", "chest" 等）
 * @param modelPath 特效模型路径
 * @param duration 持续时间（秒），不传则永久存在直到手动销毁
 * @returns 是否创建成功
 */
export function createUnitEffect(unit: any, attachPoint: string, modelPath: string, duration?: number): boolean {
  if (!unit) return false;
  const handleId = japi.DzGetUnitObjectId ? japi.DzGetUnitObjectId(unit) : 0;
  if (!handleId) return false;

  // 如果已有特效，先销毁
  const existingEffect = unitEffectMap.get(handleId);
  if (existingEffect && typeof jass.DestroyEffect === "function") {
    jass.DestroyEffect(existingEffect);
  }

  // 创建新特效
  const effect = jass.AddSpecialEffectTarget(modelPath, unit, attachPoint);
  if (!effect) return false;

  unitEffectMap.set(handleId, effect);

  // 如果指定了持续时间，定时销毁
  if (duration != null && duration > 0) {
    withTimer(duration, () => {
      const currentEffect = unitEffectMap.get(handleId);
      if (currentEffect === effect && typeof jass.DestroyEffect === "function") {
        jass.DestroyEffect(effect);
        unitEffectMap.delete(handleId);
      }
    });
  }

  return true;
}

/**
 * 销毁单位上的绑定特效
 * @param unit 目标单位
 */
export function destroyUnitEffect(unit: any): void {
  if (!unit) return;
  const handleId = japi.DzGetUnitObjectId ? japi.DzGetUnitObjectId(unit) : 0;
  if (!handleId) return;

  const effect = unitEffectMap.get(handleId);
  if (effect && typeof jass.DestroyEffect === "function") {
    jass.DestroyEffect(effect);
  }
  unitEffectMap.delete(handleId);
}
