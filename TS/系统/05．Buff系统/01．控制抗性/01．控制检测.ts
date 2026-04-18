/**
 * 控制技能检测模块
 *
 * 功能：判断技能是否为控制技能，单位是否被控制
 */

const jass = require("jass.common") as any;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};
const { getObjectProperty, ObjectType } = require("lib.扩展函数.YDWE函数.index") as {
  getObjectProperty: (objectType: number, objectId: number | string, property: string) => string;
  ObjectType: { ABILITY: number };
};
const { EXCLUDED_UNIT_TYPES } = require("系统.05．Buff系统.01．控制抗性.00．控制抗性常量") as {
  EXCLUDED_UNIT_TYPES: string[];
};

//=============================================================================
// 一、排除单位检测
//=============================================================================

/**
 * 检查单位是否被排除
 */
export function isExcludedFromControlResist(unit: any): boolean {
  const unitTypeId = jass.GetUnitTypeId(unit);
  // 将字符串ID转换为FourCC后比较
  return EXCLUDED_UNIT_TYPES.some(id => stringToFourCC(id) === unitTypeId);
}

//=============================================================================
// 二、控制技能判定
//=============================================================================

/**
 * 检查技能命令是否为排除类型
 */
function isExcludedOrder(abilityId: number): boolean {
  const order = getObjectProperty(ObjectType.ABILITY, abilityId, "Order");
  // 排除守卫类和蛛网类
  return order === "ward" || order === "web";
}

/**
 * 获取技能英雄持续时间
 */
export function getHeroDuration(abilityId: number): number {
  const str = getObjectProperty(ObjectType.ABILITY, abilityId, "HeroDur1");
  return parseFloat(str) || 0;
}

/**
 * 判断技能是否为控制技能
 *
 * 条件：
 * 1. 不是排除的命令类型
 * 2. 英雄持续时间 > 0.02秒
 */
export function isControlAbility(abilityId: number): boolean {
  if (isExcludedOrder(abilityId)) return false;

  const duration = getHeroDuration(abilityId);
  return duration > 0.02;
}

//=============================================================================
// 三、单位控制状态检测
//=============================================================================

/** 停止命令ID */
const STOP_ORDER_ID = 852231;

/** 麻痹命令ID */
const PARALYSIS_ORDER_ID = 852252;

/**
 * 检查单位是否处于被控制状态
 *
 * 条件：当前命令为stop或麻痹状态
 */
export function isUnitControlled(unit: any): boolean {
  const currentOrder = jass.GetUnitCurrentOrder(unit);

  // 检查是否为stop命令
  if (currentOrder === STOP_ORDER_ID) return true;

  // 检查是否为麻痹状态
  if (currentOrder === PARALYSIS_ORDER_ID) return true;

  // 检查是否发出了stop命令
  const issuedOrder = jass.GetIssuedOrderId();
  if (jass.OrderId2String(issuedOrder) === "stop") return true;

  return false;
}

export {};
