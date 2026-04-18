/** @noSelfInFile */
/**
 * 伤害显示系统 - 事件注册
 *
 * 功能：
 * 1. 通过伤害计算系统的回调获取最终伤害数值
 * 2. 分发伤害事件到核心功能和Boss战统计
 */

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (cb: (target: any, attacker: any, applied: number) => void) => void;
};

const { showDamageNumber } = require("系统.04．伤害系统.04．伤害显示.02．核心功能") as {
  showDamageNumber: (target: any, damage: number) => void;
};

const { updateBossDamageStats } = require("系统.04．伤害系统.04．伤害显示.03．Boss战统计") as {
  updateBossDamageStats: (source: any, target: any, damage: number) => void;
};

const { MIN_DAMAGE_THRESHOLD } = require("系统.04．伤害系统.04．伤害显示.00．常量定义") as {
  MIN_DAMAGE_THRESHOLD: number;
};

// ==========================================================================================
// 伤害事件回调
// ==========================================================================================

/**
 * 最终伤害已应用回调
 * 在伤害计算系统完成计算后调用，获取最终伤害数值
 */
function onAppliedFinalDamage(
  this: void,
  target: any,
  attacker: any,
  applied: number
): void {
  // 跳过小伤害
  if (applied < MIN_DAMAGE_THRESHOLD) return;

  // 显示伤害数字
  showDamageNumber(target, applied);

  // 更新Boss战统计
  updateBossDamageStats(attacker, target, applied);
}

// ==========================================================================================
// 初始化
// ==========================================================================================

let _initialized = false;

/**
 * 初始化伤害显示系统
 */
export function initDamageDisplay(this: void): void {
  if (_initialized) return;
  _initialized = true;

  registerAppliedFinalDamageListener(onAppliedFinalDamage);
}

// 自动初始化
initDamageDisplay();

export {};
