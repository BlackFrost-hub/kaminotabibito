/**
 * YDWE护甲获取函数
 *
 * 功能：获取单位护甲值（兼容1.27版本）
 *
 * 方式：
 * 1. 优先使用 GetUnitState + ConvertUnitState(0x20)
 * 2. 兜底使用伤害测试法
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;

//=============================================================================
// 常量定义
//=============================================================================

/** 护甲状态常量 */
const UNIT_STATE_ARMOR = 0x20;

/** 护甲减伤系数（游戏常数，默认0.06） */
const ARMOR_REDUCTION_MULTIPLIER1 = 0.06;
const ARMOR_REDUCTION_MULTIPLIER2 = 1 - ARMOR_REDUCTION_MULTIPLIER1;

/** 自然对数常量 */
const NATLOG_094 = Math.log(ARMOR_REDUCTION_MULTIPLIER2);

/** 无敌护甲值 */
const ARMOR_INVULNERABLE = 917451.519;

/** 测试伤害值 */
const DAMAGE_TEST = 160;

/** 测试生命阈值 */
const DAMAGE_LIFE = 300;

/** 护甲测试技能ID（需要一个不会影响单位的技能） */
const ARMOR_TEST_ABILITY = 0x416C6F63; // 'Aloc' 蝗虫技能

//=============================================================================
// 护甲获取函数
//=============================================================================

/**
 * 获取单位护甲值（简单方式）
 * 使用 GetUnitState + ConvertUnitState(0x20)
 *
 * @param u 目标单位
 * @returns 护甲值
 */
export function YDWEGetUnitArmor(u: any): number {
  if (u == null) return 0;

  // 方式1：使用 GetUnitState + ConvertUnitState
  if (typeof jass.ConvertUnitState === "function") {
    const armorState = jass.ConvertUnitState(UNIT_STATE_ARMOR);
    return jass.GetUnitState(u, armorState);
  }

  // 方式2：兜底 - 使用伤害测试法
  return YDWEGetUnitArmorByDamageTest(u);
}

/**
 * 获取单位护甲值（伤害测试法）
 * 通过造成测试伤害反算护甲值
 *
 * @param u 目标单位
 * @returns 护甲值
 */
export function YDWEGetUnitArmorByDamageTest(u: any): number {
  if (u == null) return 0;

  const life = jass.GetWidgetLife(u);
  if (life < 0.405) return 0;

  let test = life;
  let redc = 0;
  let enab = false;

  // 获取触发中的触发器
  const trig = jass.GetTriggeringTrigger ? jass.GetTriggeringTrigger() : null;

  // 确保单位生命足够测试
  const maxLife = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE);
  if (maxLife <= DAMAGE_LIFE) {
    jass.UnitAddAbility(u, ARMOR_TEST_ABILITY);
  }

  if (life <= DAMAGE_LIFE) {
    jass.SetWidgetLife(u, DAMAGE_LIFE);
    test = DAMAGE_LIFE;
  }

  // 禁用触发避免递归
  if (trig != null && jass.IsTriggerEnabled(trig)) {
    jass.DisableTrigger(trig);
    enab = true;
  }

  // 禁用伤害事件触发器（如果存在）
  const dmgTrigger = (g as any).yd_DamageEventTrigger;
  if (dmgTrigger != null) {
    jass.DisableTrigger(dmgTrigger);
  }

  // 造成测试伤害
  jass.UnitDamageTarget(u, u, DAMAGE_TEST, true, false, jass.ATTACK_TYPE_CHAOS, jass.DAMAGE_TYPE_NORMAL, null);

  // 恢复伤害事件触发器
  if (dmgTrigger != null) {
    jass.EnableTrigger(dmgTrigger);
  }

  // 计算减伤比例
  const newLife = jass.GetWidgetLife(u);
  redc = (DAMAGE_TEST - test + newLife) / DAMAGE_TEST;

  // 恢复触发器状态
  if (enab) {
    jass.EnableTrigger(trig);
  }

  // 移除测试技能
  jass.UnitRemoveAbility(u, ARMOR_TEST_ABILITY);

  // 恢复生命
  jass.SetWidgetLife(u, life);

  // 计算护甲值
  if (redc >= 1) {
    return ARMOR_INVULNERABLE;
  } else if (redc < 0) {
    return -Math.log(redc + 1) / NATLOG_094;
  } else {
    return redc / (ARMOR_REDUCTION_MULTIPLIER1 * (1 - redc));
  }
}

export {};
