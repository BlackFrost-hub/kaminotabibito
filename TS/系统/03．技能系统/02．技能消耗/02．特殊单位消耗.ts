/**
 * 特殊单位消耗处理
 *
 * 配置哪些单位有特殊的消耗处理方式
 */

const jass = require("jass.common") as any;
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

//=============================================================================
// 一、特殊单位配置
//=============================================================================

/**
 * 特殊单位消耗处理类型
 */
export type SpecialCostType = "health_instead_mana";

/**
 * 特殊单位配置
 */
export interface SpecialUnitCostConfig {
  /** 处理类型 */
  type: SpecialCostType;
  /** 描述 */
  description?: string;
}

/**
 * 特殊单位消耗处理配置表
 *
 * key: 单位类型ID
 * value: 处理配置
 */
export const SPECIAL_UNIT_COST_CONFIG: Record<number, SpecialUnitCostConfig> = {
  // 爱德华：被动技能扣血代替扣蓝
  // 注意：爱德华单位存储在YDUserData中，通过字符串key获取
};

//=============================================================================
// 二、爱德华特殊处理
//=============================================================================

/**
 * 获取爱德华单位
 */
export function getEdwardUnit(): any {
  return YDUserDataGet("string", "爱德华", "单位", "unit");
}

/**
 * 检查单位是否为爱德华
 */
export function isEdwardUnit(unit: any): boolean {
  const edward = getEdwardUnit();
  return edward != null && unit === edward;
}

/**
 * 爱德华被动处理：扣血代替扣蓝
 */
export function handleEdwardPassiveCost(unit: any, manaCost: number): void {
  if (!isEdwardUnit(unit)) return;

  const currentLife = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE);
  const lifeKeep = currentLife - 1;
  const deductAmount = manaCost < lifeKeep ? manaCost : lifeKeep; // 保留1点生命

  if (deductAmount > 0) {
    jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, currentLife - deductAmount);
  }
}

export {};
