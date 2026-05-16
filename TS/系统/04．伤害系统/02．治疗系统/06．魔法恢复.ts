/** @noSelfInFile */
/**
 * 魔法恢复系统
 *
 * 功能：执行魔法恢复、显示数值
 *
 * 后续接手者注意：
 * 1. 直接调用 doManaRegen 执行魔法恢复
 * 2. 内部会直接显示数值漂浮文字
 */

const jass = require("jass.common") as any;

const { STES_FireWithParams } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_FireWithParams: (this: void, name: string, params: Array<{ type: string; name: string; value: any }>) => void;
};

const { 显示单位数值漂浮文字 } = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字") as {
  显示单位数值漂浮文字: (this: void, unit: any, value: number, options?: any) => any;
};

//=============================================================================
// 一、常量配置
//=============================================================================

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
  const manaGap = maxMana - currentMana;
  const safeGap = manaGap > 0 ? manaGap : 0;
  const actualRegen = amount < safeGap ? amount : safeGap;
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
  显示单位数值漂浮文字(target, amount, {
    红: MANA_REGEN_COLOR.red,
    绿: MANA_REGEN_COLOR.green,
    蓝: MANA_REGEN_COLOR.blue,
  });
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
  STES_FireWithParams("恢复魔法事件", [
    { type: "real", name: "HealAmount", value: amount },
    { type: "unit", name: "HealTarget", value: target },
    { type: "unit", name: "HealSource", value: source },
  ]);
}

export {};
/** @noSelfInFile */
