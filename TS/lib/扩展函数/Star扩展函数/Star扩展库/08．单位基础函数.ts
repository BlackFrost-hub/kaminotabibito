/**
 * Star扩展库 - 单位基础函数
 *
 * 来源于 StarUnit.j，提供单位基础操作功能。
 *
 * 公开接口：
 *   SU_IsUnitInvincible(u)        - 判断单位是否无敌
 *   SU_SetUnitFlyHeight(u, h, r)  - 设置单位飞行高度（自动添加飞行能力）
 *   SU_GetHeroAllState(u, b)      - 获取英雄全属性
 *   SU_GetUnitLostHPPercent(u)    - 获取单位已损失生命值百分比
 *   SU_GetUnitLostHP(u)           - 获取单位已损失生命值
 *   UnitAddHp(u, value, b)        - 为单位添加生命值（支持百分比）
 *   SU_IsUnitDie(u)               - 判断单位是否死亡（高精度）
 *   SU_ShowOrHideUnit(u, isShow)  - 设置单位可见性
 */

const jass = require("jass.common") as any;

/**
 * 判断单位是否无敌
 * 检查 'Avul'(无敌技能)、'Bvul'(无敌Buff)、'BHds'(神圣护甲)
 * @param u 目标单位
 * @returns 是否无敌
 */
export function SU_IsUnitInvincible(u: any): boolean {
  if (u == null || u === 0) return false;

  const avul = typeof jass.GetUnitAbilityLevel === "function"
    ? jass.GetUnitAbilityLevel(u, 0x4176756c) // 'Avul'
    : 0;
  const bvul = typeof jass.GetUnitAbilityLevel === "function"
    ? jass.GetUnitAbilityLevel(u, 0x4276756c) // 'Bvul'
    : 0;
  const bhds = typeof jass.GetUnitAbilityLevel === "function"
    ? jass.GetUnitAbilityLevel(u, 0x42486473) // 'BHds'
    : 0;

  return avul !== 0 || bvul !== 0 || bhds !== 0;
}

/**
 * 设置单位飞行高度（自动添加飞行能力）
 * 通过临时添加 'Amrf'(乌鸦形态) 技能让单位可以飞行
 * @param whichUnit 目标单位
 * @param newHeight 新的飞行高度
 * @param rate 变换速率
 */
export function SU_SetUnitFlyHeight(whichUnit: any, newHeight: number, rate: number): void {
  if (whichUnit == null || whichUnit === 0) return;

  const AMRF = 0x416d7266; // 'Amrf'

  if (typeof jass.UnitAddAbility === "function") {
    jass.UnitAddAbility(whichUnit, AMRF);
  }
  if (typeof jass.UnitRemoveAbility === "function") {
    jass.UnitRemoveAbility(whichUnit, AMRF);
  }
  if (typeof jass.SetUnitFlyHeight === "function") {
    jass.SetUnitFlyHeight(whichUnit, newHeight, rate);
  }
}

/**
 * 获取英雄全属性（力量+敏捷+智力）
 * @param u 目标英雄
 * @param b 是否计算绿字（加成）
 * @returns 全属性数值
 */
export function SU_GetHeroAllState(u: any, b: boolean): number {
  if (u == null || u === 0) return 0;

  const str = typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, b) : 0;
  const agi = typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, b) : 0;
  const int = typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, b) : 0;

  return str + agi + int;
}

/**
 * 获取单位已损失生命值百分比
 * @param u 目标单位
 * @returns 已损失生命值百分比（0-1）
 */
export function SU_GetUnitLostHPPercent(u: any): number {
  if (u == null || u === 0) return 0;

  const maxLife = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    : 0;
  const life = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    : 0;

  if (maxLife <= 0) return 0;
  return (maxLife - life) / maxLife;
}

/**
 * 获取单位已损失生命值
 * @param u 目标单位
 * @returns 已损失生命值
 */
export function SU_GetUnitLostHP(u: any): number {
  if (u == null || u === 0) return 0;

  const maxLife = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    : 0;
  const life = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    : 0;

  return maxLife - life;
}

/**
 * 为单位添加生命值（支持百分比）
 * @param u 目标单位
 * @param value 增加值（若b为true则为百分比）
 * @param b 是否为百分比模式
 */
export function UnitAddHp(u: any, value: number, b: boolean): void {
  if (u == null || u === 0) return;

  const life = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    : 0;
  const maxLife = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    : 0;

  const percent = maxLife > 0 ? life / maxLife : 1;
  const addValue = b ? maxLife * value : value;

  if (typeof jass.SetUnitState === "function") {
    jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, maxLife + addValue);
    jass.SetUnitState(u, jass.UNIT_STATE_LIFE, (maxLife + addValue) * percent);
  }
}

/**
 * 判断单位是否死亡（高精度）
 * @param u 目标单位
 * @returns 是否存活（true=存活，false=死亡）
 */
export function SU_IsUnitDie(u: any): boolean {
  if (u == null || u === 0) return true;

  const life = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    : 0;

  return life > 0.405;
}

/**
 * 设置单位可见性
 * 通过透明度和飞行高度实现显示/隐藏
 * @param u 目标单位
 * @param isShow true=显示，false=隐藏
 */
export function SU_ShowOrHideUnit(u: any, isShow: boolean): void {
  if (u == null || u === 0) return;

  if (typeof jass.SetUnitVertexColor === "function") {
    if (isShow) {
      jass.SetUnitVertexColor(u, 255, 255, 255, 255);
    } else {
      jass.SetUnitVertexColor(u, 255, 255, 255, 0);
    }
  }

  if (isShow) {
    SU_SetUnitFlyHeight(u, 999999, 0);
  } else {
    SU_SetUnitFlyHeight(u, 0, 0);
  }
}

export {};
