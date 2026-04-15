/**
 * Star扩展库 - 单位生命周期函数
 *
 * 来源于 StarUnit.j，提供单位生命周期类型判断功能。
 *
 * 公开接口：
 *   IsWaterElement(u)          - 判断是否为水元素
 *   GetUnitTimedLifeID(u)      - 获取单位生命周期类型ID
 *   I2TimedLifeID(i)           - 整数转生命周期枚举ID（GUI封装）
 */

const jass = require("jass.common") as any;

// 生命周期类型常量
export const TIMED_LIFE_NONE = 0;
export const TIMED_LIFE_RAISE_DEAD = 1;      // 操纵死尸 BUan
export const TIMED_LIFE_DISEASE_CLOUD = 2;   // 疾病云雾 Bapl
export const TIMED_LIFE_FORCE_OF_NATURE = 3; // 自然之力 BEfn
export const TIMED_LIFE_HEALING_WARD = 4;    // 治疗守卫 Bhwd
export const TIMED_LIFE_ANIMATE_DEAD = 5;    // 复活死尸 Brai
export const TIMED_LIFE_WATER_ELEMENTAL = 6; // 水元素 BHwe
export const TIMED_LIFE_TIMED = 7;           // 定时的生命 BTLF

/**
 * 判断单位是否为水元素
 * @param u 目标单位
 * @returns 是否为水元素
 */
export function IsWaterElement(u: any): boolean {
  if (u == null || u === 0) return false;

  const BHWE = 0x42487765; // 'BHwe'

  return typeof jass.GetUnitAbilityLevel === "function"
    && jass.GetUnitAbilityLevel(u, BHWE) !== 0;
}

/**
 * 获取单位生命周期类型ID
 * @param u 目标单位
 * @returns 生命周期类型ID（0-7）
 */
export function GetUnitTimedLifeID(u: any): number {
  if (u == null || u === 0) return TIMED_LIFE_NONE;

  if (typeof jass.GetUnitAbilityLevel !== "function") return TIMED_LIFE_NONE;

  // 操纵死尸
  if (jass.GetUnitAbilityLevel(u, 0x4255616e) !== 0) return TIMED_LIFE_RAISE_DEAD; // 'BUan'
  // 疾病云雾
  if (jass.GetUnitAbilityLevel(u, 0x4261706c) !== 0) return TIMED_LIFE_DISEASE_CLOUD; // 'Bapl'
  // 自然之力
  if (jass.GetUnitAbilityLevel(u, 0x4245666e) !== 0) return TIMED_LIFE_FORCE_OF_NATURE; // 'BEfn'
  // 治疗守卫
  if (jass.GetUnitAbilityLevel(u, 0x42687764) !== 0) return TIMED_LIFE_HEALING_WARD; // 'Bhwd'
  // 复活死尸
  if (jass.GetUnitAbilityLevel(u, 0x42726169) !== 0) return TIMED_LIFE_ANIMATE_DEAD; // 'Brai'
  // 水元素
  if (jass.GetUnitAbilityLevel(u, 0x42487765) !== 0) return TIMED_LIFE_WATER_ELEMENTAL; // 'BHwe'
  // 定时的生命
  if (jass.GetUnitAbilityLevel(u, 0x42544c46) !== 0) return TIMED_LIFE_TIMED; // 'BTLF'

  return TIMED_LIFE_NONE;
}

/**
 * 整数转生命周期枚举ID（GUI封装）
 * @param i 整数值
 * @returns 生命周期枚举ID
 */
export function I2TimedLifeID(i: number): number {
  return i;
}

export {};
