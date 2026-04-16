/**
 * 魔法恢复系统
 *
 * 功能：执行魔法恢复、显示数值
 *
 * 后续接手者注意：
 * 1. 直接调用 doManaRegen 执行魔法恢复
 * 2. 内部会触发 STES "数值显示" 事件
 */

const jass = require("jass.common") as any;

const { STES_Fire } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Fire: (self: any, name: string) => void;
};

const { YDLocal5Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (ty: string, name: string, value: any) => void;
};

//=============================================================================
// 一、常量配置
//=============================================================================

/** 数值显示事件名 */
const SHOW_DAMAGE_EVENT = "数值显示";

/** 魔法恢复颜色 RGB */
const MANA_REGEN_COLOR = {
  red: 53,
  green: 80,
  blue: 92,
} as const;

/** 系统开关 */
const MANA_REGEN_SYSTEM_ENABLED = true;

//=============================================================================
// 二、核心功能
//=============================================================================

/**
 * 执行魔法恢复
 *
 * @param target 目标单位
 * @param amount 恢复量
 * @param showEffect 是否显示数值
 * @returns 实际恢复量
 */
export function doManaRegen(
  target: any,
  amount: number,
  showEffect: boolean = true
): number {
  if (!MANA_REGEN_SYSTEM_ENABLED) return 0;
  if (target == null || amount <= 0) return 0;
  if (jass.IsUnitType(target, jass.UNIT_TYPE_DEAD)) return 0;

  // 获取当前和最大魔法值
  const currentMana = jass.GetUnitState(target, jass.UNIT_STATE_MANA);
  const maxMana = jass.GetUnitState(target, jass.UNIT_STATE_MAX_MANA);

  // 计算实际恢复量（不超过上限）
  const actualRegen = Math.min(amount, Math.max(0, maxMana - currentMana));
  if (actualRegen <= 0) return 0;

  // 设置魔法值
  jass.SetUnitState(target, jass.UNIT_STATE_MANA, currentMana + actualRegen);

  // 显示数值
  if (showEffect) {
    fireManaShowEvent(target, actualRegen);
  }

  return actualRegen;
}

/**
 * 触发魔法数值显示事件
 */
function fireManaShowEvent(target: any, amount: number): void {
  YDLocal5Set("real", "Real", amount);
  YDLocal5Set("unit", "Unit", target);
  YDLocal5Set("real", "red", MANA_REGEN_COLOR.red);
  YDLocal5Set("real", "green", MANA_REGEN_COLOR.green);
  YDLocal5Set("real", "blue", MANA_REGEN_COLOR.blue);
  STES_Fire(null, SHOW_DAMAGE_EVENT);
}

//=============================================================================
// 三、便捷函数
//=============================================================================

/**
 * 触发 STES "恢复魔法事件"
 * 供Lua/JASS端调用，JASS端监听器会执行实际恢复
 *
 * @param target 目标单位
 * @param amount 恢复量
 * @param source 来源单位（可为null）
 */
export function fireManaRegenEvent(target: any, amount: number, source: any = null): void {
  YDLocal5Set("real", "HealAmount", amount);
  YDLocal5Set("unit", "HealTarget", target);
  YDLocal5Set("unit", "HealSource", source);
  STES_Fire(null, "恢复魔法事件");
}

export {};
