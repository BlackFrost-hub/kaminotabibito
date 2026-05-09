/** @noSelfInFile */
/**
 * 护盾回调模板
 *
 * 提供常用的护盾回调工厂函数
 */

import { 护盾开始回调, 护盾破碎回调, 护盾到期回调, 护盾结束回调 } from "./01．护盾类型";

const jass = require("jass.common") as any;

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

// ==========================================================================================
// JASS 函数别名
// ==========================================================================================

const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPoint: string) => any;
const DestroyEffect = jass.DestroyEffect as (e: any) => void;

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
// 调试回调模板
// ==========================================================================================

/**
 * 创建护盾开始调试回调
 */
export function 创建护盾开始调试回调(模块名: string = "护盾"): 护盾开始回调 {
  return (单位, 护盾ID) => {
    debugLogForce(模块名, "护盾开始", "单位=", 单位, "护盾ID=", 护盾ID);
  };
}

/**
 * 创建护盾破碎调试回调
 */
export function 创建护盾破碎调试回调(模块名: string = "护盾"): 护盾破碎回调 {
  return (单位, 护盾ID, 吸收伤害) => {
    debugLogForce(模块名, "护盾破碎", "单位=", 单位, "护盾ID=", 护盾ID, "吸收=", 吸收伤害);
  };
}

/**
 * 创建护盾到期调试回调
 */
export function 创建护盾到期调试回调(模块名: string = "护盾"): 护盾到期回调 {
  return (单位, 护盾ID) => {
    debugLogForce(模块名, "护盾到期", "单位=", 单位, "护盾ID=", 护盾ID);
  };
}

/**
 * 创建护盾结束调试回调
 */
export function 创建护盾结束调试回调(模块名: string = "护盾"): 护盾结束回调 {
  return (单位, 护盾ID, 原因) => {
    debugLogForce(模块名, "护盾结束", "单位=", 单位, "护盾ID=", 护盾ID, "原因=", 原因);
  };
}

// ==========================================================================================
// 组合回调模板
// ==========================================================================================

/**
 * 创建护盾完整调试回调（开始+破碎+到期+结束）
 */
export function 创建护盾完整调试回调(模块名: string = "护盾"): {
  开始回调: 护盾开始回调;
  破碎回调: 护盾破碎回调;
  到期回调: 护盾到期回调;
  结束回调: 护盾结束回调;
} {
  return {
    开始回调: 创建护盾开始调试回调(模块名),
    破碎回调: 创建护盾破碎调试回调(模块名),
    到期回调: 创建护盾到期调试回调(模块名),
    结束回调: 创建护盾结束调试回调(模块名),
  };
}

export {};
