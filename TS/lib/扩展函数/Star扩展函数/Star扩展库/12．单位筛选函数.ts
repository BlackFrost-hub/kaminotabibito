/**
 * Star扩展库 - 单位筛选函数
 *
 * 来源于 StarUnit.j，提供单位筛选条件函数。
 *
 * 公开接口：
 *   SUF_Base_1(u)       - 敌对单位且非无敌非建筑非死亡（用于FilterUnit）
 *   SUF_Base_2(u)       - 友方单位且非无敌非建筑非死亡（用于FilterUnit）
 *   SUF_Base_3(fu, u)   - 敌对单位判断（直接传参）
 */

const jass = require("jass.common") as any;

const AVUL = 0x4176756c; // 'Avul'

/**
 * 判断单位是否存活（内部使用）
 */
function isUnitAlive(u: any): boolean {
  if (u == null || u === 0) return false;
  const life = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    : 0;
  return life > 0.405;
}

/**
 * 筛选条件：敌对单位且非无敌非建筑非死亡
 * 用于 EnumUnitsInRect 等枚举函数的 FilterFunc
 * 注意：此函数需要在枚举回调中使用，GetFilterUnit() 获取枚举单位
 * @param u 参考单位（用于判断敌对关系）
 * @returns 筛选结果
 */
export function SUF_Base_1(u: any): boolean {
  if (u == null || u === 0) return false;

  const fu = typeof jass.GetFilterUnit === "function" ? jass.GetFilterUnit() : null;
  if (fu == null || fu === 0) return false;

  const isEnemy = typeof jass.IsUnitEnemy === "function"
    ? jass.IsUnitEnemy(fu, jass.GetOwningPlayer(u))
    : false;
  const notInvincible = typeof jass.GetUnitAbilityLevel === "function"
    ? jass.GetUnitAbilityLevel(fu, AVUL) === 0
    : true;
  const notStructure = typeof jass.IsUnitType === "function"
    ? !jass.IsUnitType(fu, jass.UNIT_TYPE_STRUCTURE)
    : true;
  const alive = isUnitAlive(fu);

  return isEnemy && notInvincible && notStructure && alive;
}

/**
 * 筛选条件：友方单位且非无敌非建筑非死亡
 * 用于 EnumUnitsInRect 等枚举函数的 FilterFunc
 * @param u 参考单位（用于判断敌对关系）
 * @returns 筛选结果
 */
export function SUF_Base_2(u: any): boolean {
  if (u == null || u === 0) return false;

  const fu = typeof jass.GetFilterUnit === "function" ? jass.GetFilterUnit() : null;
  if (fu == null || fu === 0) return false;

  const notEnemy = typeof jass.IsUnitEnemy === "function"
    ? !jass.IsUnitEnemy(fu, jass.GetOwningPlayer(u))
    : true;
  const notInvincible = typeof jass.GetUnitAbilityLevel === "function"
    ? jass.GetUnitAbilityLevel(fu, AVUL) === 0
    : true;
  const notStructure = typeof jass.IsUnitType === "function"
    ? !jass.IsUnitType(fu, jass.UNIT_TYPE_STRUCTURE)
    : true;
  const alive = isUnitAlive(fu);

  return notEnemy && notInvincible && notStructure && alive;
}

/**
 * 直接判断：敌对单位且非无敌非建筑非死亡
 * @param fu 要判断的单位
 * @param u 参考单位（用于判断敌对关系）
 * @returns 是否满足条件
 */
export function SUF_Base_3(fu: any, u: any): boolean {
  if (fu == null || fu === 0 || u == null || u === 0) return false;

  const isEnemy = typeof jass.IsUnitEnemy === "function"
    ? jass.IsUnitEnemy(fu, jass.GetOwningPlayer(u))
    : false;
  const notInvincible = typeof jass.GetUnitAbilityLevel === "function"
    ? jass.GetUnitAbilityLevel(fu, AVUL) === 0
    : true;
  const notStructure = typeof jass.IsUnitType === "function"
    ? !jass.IsUnitType(fu, jass.UNIT_TYPE_STRUCTURE)
    : true;
  const alive = isUnitAlive(fu);

  return isEnemy && notInvincible && notStructure && alive;
}

export {};
