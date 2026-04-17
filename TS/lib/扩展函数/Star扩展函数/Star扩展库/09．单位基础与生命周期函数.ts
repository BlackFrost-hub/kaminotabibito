/**
 * Star扩展库 - 单位基础与生命周期函数
 *
 * 提供单位基础操作、存活状态、生命读写，以及生命周期类型判断。
 */

const jass = require("jass.common") as any;

import { SUC_IsUnitAlive, SUC_IsUnitInvincible, SUC_IsValidUnit } from "./08．单位判定与筛选函数";

export const TIMED_LIFE_NONE = 0;
export const TIMED_LIFE_RAISE_DEAD = 1;
export const TIMED_LIFE_DISEASE_CLOUD = 2;
export const TIMED_LIFE_FORCE_OF_NATURE = 3;
export const TIMED_LIFE_HEALING_WARD = 4;
export const TIMED_LIFE_ANIMATE_DEAD = 5;
export const TIMED_LIFE_WATER_ELEMENTAL = 6;
export const TIMED_LIFE_TIMED = 7;

// 保留旧接口名的无敌判断。
export function SU_IsUnitInvincible(u: any): boolean {
  return SUC_IsUnitInvincible(u);
}

// 通过乌鸦形态调整飞行高度。
export function SU_SetUnitFlyHeight(whichUnit: any, newHeight: number, rate: number): void {
  if (!SUC_IsValidUnit(whichUnit)) return;

  const AMRF = 0x416d7266;
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

// 读取英雄三围总和。
export function SU_GetHeroAllState(u: any, b: boolean): number {
  if (!SUC_IsValidUnit(u)) return 0;

  const str = typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, b) : 0;
  const agi = typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, b) : 0;
  const int = typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, b) : 0;

  return str + agi + int;
}

// 读取单位损失生命百分比。
export function SU_GetUnitLostHPPercent(u: any): number {
  if (!SUC_IsValidUnit(u)) return 0;

  const maxLife = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    : 0;
  const life = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    : 0;

  if (maxLife <= 0) return 0;
  return (maxLife - life) / maxLife;
}

// 读取单位损失生命值。
export function SU_GetUnitLostHP(u: any): number {
  if (!SUC_IsValidUnit(u)) return 0;

  const maxLife = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    : 0;
  const life = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    : 0;

  return maxLife - life;
}

// 按数值或百分比增减生命上限。
export function UnitAddHp(u: any, value: number, b: boolean): void {
  if (!SUC_IsValidUnit(u)) return;

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

// 保留旧语义的存活判断。
export function SU_IsUnitDie(u: any): boolean {
  return SUC_IsUnitAlive(u);
}

// 用透明度和高度控制显隐。
export function SU_ShowOrHideUnit(u: any, isShow: boolean): void {
  if (!SUC_IsValidUnit(u)) return;

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

// 判断单位是否为水元素。
export function IsWaterElement(u: any): boolean {
  if (!SUC_IsValidUnit(u)) return false;

  const BHWE = 0x42487765;
  return typeof jass.GetUnitAbilityLevel === "function"
    && jass.GetUnitAbilityLevel(u, BHWE) !== 0;
}

// 识别单位的生命周期类型。
export function GetUnitTimedLifeID(u: any): number {
  if (!SUC_IsValidUnit(u)) return TIMED_LIFE_NONE;
  if (typeof jass.GetUnitAbilityLevel !== "function") return TIMED_LIFE_NONE;

  if (jass.GetUnitAbilityLevel(u, 0x4255616e) !== 0) return TIMED_LIFE_RAISE_DEAD;
  if (jass.GetUnitAbilityLevel(u, 0x4261706c) !== 0) return TIMED_LIFE_DISEASE_CLOUD;
  if (jass.GetUnitAbilityLevel(u, 0x4245666e) !== 0) return TIMED_LIFE_FORCE_OF_NATURE;
  if (jass.GetUnitAbilityLevel(u, 0x42687764) !== 0) return TIMED_LIFE_HEALING_WARD;
  if (jass.GetUnitAbilityLevel(u, 0x42726169) !== 0) return TIMED_LIFE_ANIMATE_DEAD;
  if (jass.GetUnitAbilityLevel(u, 0x42487765) !== 0) return TIMED_LIFE_WATER_ELEMENTAL;
  if (jass.GetUnitAbilityLevel(u, 0x42544c46) !== 0) return TIMED_LIFE_TIMED;

  return TIMED_LIFE_NONE;
}

// GUI 用的整数透传封装。
export function I2TimedLifeID(i: number): number {
  return i;
}

export {};
