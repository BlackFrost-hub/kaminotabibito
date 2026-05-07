/**
 * 魔法消耗返还模块
 *
 * 功能：暗夜精灵族技能施放后返还部分魔法
 */

const jass = require("jass.common") as any;
const { YDUserDataGet, YDWEGetUnitAbilityDataInteger, YDWEGetUnitAbilityDataReal, getObjectProperty, ObjectType } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDWEGetUnitAbilityDataInteger: (u: any, abilcode: number, level: number, data_type: number) => number;
  YDWEGetUnitAbilityDataReal: (u: any, abilcode: number, level: number, data_type: number) => number;
  getObjectProperty: (objectType: number, objectId: number | string, property: string) => string;
  ObjectType: { ABILITY: number };
};
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: (this: void) => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};
const { PERCENT_COST_THRESHOLD } = require("系统.03．技能系统.02．技能消耗.00．消耗常量") as {
  PERCENT_COST_THRESHOLD: number;
};

const pendingManaRefundByTimerHid: Record<number, { unit: any; refund: number } | undefined> = {};

function onManaRefundTimerExpire(this: void): void {
  const timer = jass.GetExpiredTimer();
  if (!timer) return;

  const timerHid = jass.GetHandleId(timer) as number;
  const pending = pendingManaRefundByTimerHid[timerHid];
  delete pendingManaRefundByTimerHid[timerHid];
  safeDestroyTimer(timer);

  if (!pending || !pending.unit) return;

  const currentMana = jass.GetUnitState(pending.unit, jass.UNIT_STATE_MANA);
  const maxMana = jass.GetUnitState(pending.unit, jass.UNIT_STATE_MAX_MANA);
  const manaGap = maxMana - currentMana;
  const actualRefund = pending.refund < manaGap ? pending.refund : manaGap;
  if (actualRefund <= 0) return;

  jass.SetUnitState(pending.unit, jass.UNIT_STATE_MANA, currentMana + actualRefund);
}

/**
 * 检查技能是否可参与返蓝逻辑
 * 默认仅处理 nightelf 技能
 */
export function isRefundableAbility(abilityId: number): boolean {
  const race = getObjectProperty(ObjectType.ABILITY, abilityId, "race");
  return race === "nightelf";
}

//=============================================================================
// 一、技能消耗计算
//=============================================================================

/**
 * 获取技能固定消耗
 */
export function getAbilityManaCost(unit: any, abilityId: number, level: number): number {
  return YDWEGetUnitAbilityDataInteger(unit, abilityId, level, 104);
}

/**
 * 获取技能百分比消耗
 */
export function getAbilityPercentCost(unit: any, abilityId: number, level: number): number {
  return YDWEGetUnitAbilityDataReal(unit, abilityId, level, 102);
}

/**
 * 计算技能总消耗
 */
export function calcTotalManaCost(
  unit: any,
  abilityId: number,
  level: number
): number {
  const fixedCost = getAbilityManaCost(unit, abilityId, level);
  const percentCost = getAbilityPercentCost(unit, abilityId, level);

  // 百分比消耗超过90%视为非通魔面板技能，不处理
  if (percentCost >= PERCENT_COST_THRESHOLD) {
    return -1;
  }

  const maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA);
  return fixedCost + maxMana * percentCost;
}

//=============================================================================
// 二、魔法返还
//=============================================================================

/**
 * 获取魔法消耗属性
 */
export function getManaCostReduction(unit: any): number {
  const player = jass.GetOwningPlayer(unit);
  if (player == null) return 0;
  return YDUserDataGet("player", player, "魔法消耗", "real");
}

export function hasEffectiveManaCostReduction(unit: any): boolean {
  const reduction = getManaCostReduction(unit);
  const refundRatio = reduction < 0 ? -reduction : reduction;
  return refundRatio >= 0.01;
}

/**
 * 执行魔法返还
 */
export function applyManaRefund(unit: any, manaCost: number): void {
  const reduction = getManaCostReduction(unit);
  const refundRatio = reduction < 0 ? -reduction : reduction;
  if (refundRatio < 0.01) return;

  const refund = manaCost * refundRatio;
  const timer = jass.CreateTimer();
  if (!timer) return;

  const timerHid = jass.GetHandleId(timer) as number;
  pendingManaRefundByTimerHid[timerHid] = { unit, refund };
  safeTimerStart(timer, 0.0, false, onManaRefundTimerExpire);
}

//=============================================================================
// 三、统一处理入口
//=============================================================================

/**
 * 处理技能消耗返还
 *
 * @param unit 施法单位
 * @param abilityId 技能ID
 * @returns 是否执行了返还
 */
export function handleManaRefund(unit: any, abilityId: number): boolean {
  if (!isRefundableAbility(abilityId)) return false;
  if (!hasEffectiveManaCostReduction(unit)) return false;

  const level = jass.GetUnitAbilityLevel(unit, abilityId);
  const manaCost = calcTotalManaCost(unit, abilityId, level);

  // 非通魔面板技能
  if (manaCost < 0) return false;

  // 执行返还
  applyManaRefund(unit, manaCost);
  return true;
}

export {};
