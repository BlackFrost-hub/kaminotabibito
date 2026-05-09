/** @noSelfInFile */
/**
 * 护盾回调模板
 *
 * 提供常用的护盾回调工厂函数
 */

import { 护盾开始回调, 护盾破碎回调, 护盾到期回调, 护盾结束回调, 护盾类型 } from "./01．护盾类型";

const jass = require("jass.common") as any;

const { CreateFloatTextOnUnit } = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
};

// ==========================================================================================
// JASS 函数别名
// ==========================================================================================

const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPoint: string) => any;
const DestroyEffect = jass.DestroyEffect as (e: any) => void;

// ==========================================================================================
// 护盾类型名称映射
// ==========================================================================================

// 护盾类型名称映射
export const 护盾类型名称: Record<number, string> = {
  [护盾类型.通用]: "通用",
  [护盾类型.物理]: "物理",
  [护盾类型.魔法]: "魔法",
};

/** 获取护盾类型中文名 */
function 获取护盾类型名(类型: 护盾类型): string {
  return 护盾类型名称[类型] ?? "未知";
}

// ==========================================================================================
// 特效回调模板
// ==========================================================================================

/**
 * 创建护盾开始特效回调
 */
export function 创建护盾开始特效回调(模型路径: string, 附着点: string = "origin"): 护盾开始回调 {
  return (_单位, _护盾ID) => {
    const eff = AddSpecialEffectTarget(模型路径, _单位, 附着点);
    if (eff != null) {
      DestroyEffect(eff);
    }
  };
}

/**
 * 创建护盾破碎特效回调
 */
export function 创建护盾破碎特效回调(模型路径: string, 附着点: string = "origin"): 护盾破碎回调 {
  return (_单位, _护盾ID, _吸收伤害) => {
    const eff = AddSpecialEffectTarget(模型路径, _单位, 附着点);
    if (eff != null) {
      DestroyEffect(eff);
    }
  };
}

/**
 * 创建护盾到期特效回调
 */
export function 创建护盾到期特效回调(模型路径: string, 附着点: string = "origin"): 护盾到期回调 {
  return (_单位, _护盾ID) => {
    const eff = AddSpecialEffectTarget(模型路径, _单位, 附着点);
    if (eff != null) {
      DestroyEffect(eff);
    }
  };
}

// ==========================================================================================
// 漂浮文字回调模板
// ==========================================================================================

/** 护盾类型对应颜色 */
const 护盾类型颜色: Record<number, { r: number; g: number; b: number }> = {
  [护盾类型.物理]: { r: 180, g: 100, b: 30 },
  [护盾类型.魔法]: { r: 30, g: 30, b: 180 },
  [护盾类型.通用]: { r: 200, g: 200, b: 200 },
};

/** 显示护盾到期漂浮文字 */
export function 显示护盾到期漂浮文字(单位: any, 护盾类型值: 护盾类型): void {
  const 颜色 = 护盾类型颜色[护盾类型值] ?? { r: 200, g: 200, b: 200 };
  const 类型名 = 护盾类型名称[护盾类型值] ?? "护盾";
  CreateFloatTextOnUnit(单位, "『" + 类型名 + "护盾到期』", {
    size: 10, red: 颜色.r, green: 颜色.g, blue: 颜色.b, duration: 1.2, speedY: 0.06,
  });
}

/** 显示护盾破碎漂浮文字 */
export function 显示护盾破碎漂浮文字(单位: any, 护盾类型值: 护盾类型): void {
  const 颜色 = 护盾类型颜色[护盾类型值] ?? { r: 200, g: 200, b: 200 };
  const 类型名 = 护盾类型名称[护盾类型值] ?? "护盾";
  CreateFloatTextOnUnit(单位, "『" + 类型名 + "护盾破碎』", {
    size: 10, red: 颜色.r, green: 颜色.g, blue: 颜色.b, duration: 1.2, speedY: 0.06,
  });
}

export {};
