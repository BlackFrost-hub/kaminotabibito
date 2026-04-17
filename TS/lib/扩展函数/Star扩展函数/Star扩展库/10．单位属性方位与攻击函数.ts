/**
 * Star扩展库 - 单位属性方位与攻击函数
 *
 * 提供单位模型、英雄主属性、方位判断与白字攻击力计算。
 */

const jass = require("jass.common") as any;
const { CosBJ, BJ_DEGTORAD } = require("lib.扩展函数.BJ函数.00．BJ全局兜底");

import { SUC_IsValidUnit } from "./08．单位判定与筛选函数";

let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}

export const PRIMARY_STR = 0;
export const PRIMARY_AGI = 1;
export const PRIMARY_INT = 2;

const UNIT_STATE_ATTACK1_BASE = 0x12;
const UNIT_STATE_ATTACK1_BONUS = 0x10;
const UNIT_STATE_ATTACK1_COUNT = 0x11;

function getUnitPrimaryTypeFromSlk(u: any): number {
  if (!SUC_IsValidUnit(u)) return -1;
  const unitId = typeof jass.GetUnitTypeId === "function" ? jass.GetUnitTypeId(u) : 0;
  if (unitId === 0) return -1;
  if (japi == null || typeof japi.EXExecuteScript !== "function") return -1;

  const script = "(function() local _t=(require'jass.slk').unit; local _u=_t and _t['" + unitId + "']; if _u then return _u.Primary or '' else return '' end end)()";
  const primary = japi.EXExecuteScript(script) || "";

  if (primary === "STR") return PRIMARY_STR;
  if (primary === "AGI") return PRIMARY_AGI;
  if (primary === "INT") return PRIMARY_INT;
  return -1;
}

function GAFC(x1: number, y1: number, x2: number, y2: number): number {
  return jass.Atan2(y2 - y1, x2 - x1) / BJ_DEGTORAD;
}

function getHeroPrimaryGreenValue(u: any): number {
  const primaryType = getUnitPrimaryTypeFromSlk(u);

  if (primaryType === PRIMARY_STR) {
    const total = typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, true) : 0;
    const green = typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, false) : 0;
    return total - green;
  }
  if (primaryType === PRIMARY_AGI) {
    const total = typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, true) : 0;
    const green = typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, false) : 0;
    return total - green;
  }
  if (primaryType === PRIMARY_INT) {
    const total = typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, true) : 0;
    const green = typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, false) : 0;
    return total - green;
  }

  return 0;
}

// 读取单位模型路径。
export function SU_GetUnitModel(u: any): string {
  if (!SUC_IsValidUnit(u)) return "";

  const unitId = typeof jass.GetUnitTypeId === "function" ? jass.GetUnitTypeId(u) : 0;
  let file = "";

  if (japi != null && typeof japi.EXExecuteScript === "function") {
    const script = "(function() local _t=(require'jass.slk').unit; local _u=_t and _t['" + unitId + "']; if _u then return _u.file or '' else return '' end end)()";
    file = japi.EXExecuteScript(script) || "";
  }

  if (file.length > 0) {
    const suffix = file.slice(-4).toLowerCase();
    if (suffix !== ".mdl" && suffix !== ".mdx") {
      file += ".mdl";
    }
  }

  return file;
}

// 读取英雄主属性类型。
export function SU_GetHeroParmary(u: any): number {
  return getUnitPrimaryTypeFromSlk(u);
}

// 增加或设置指定英雄属性。
export function SU_AddHeroState(u: any, id: number, typ: number, value: number): void {
  if (!SUC_IsValidUnit(u)) return;

  const isAdd = typ === 0;

  if (id === PRIMARY_STR) {
    const current = typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, false) : 0;
    if (typeof jass.SetHeroStr === "function") {
      jass.SetHeroStr(u, isAdd ? current + value : value, false);
    }
  } else if (id === PRIMARY_AGI) {
    const current = typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, false) : 0;
    if (typeof jass.SetHeroAgi === "function") {
      jass.SetHeroAgi(u, isAdd ? current + value : value, false);
    }
  } else if (id === PRIMARY_INT) {
    const current = typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, false) : 0;
    if (typeof jass.SetHeroInt === "function") {
      jass.SetHeroInt(u, isAdd ? current + value : value, false);
    }
  }
}

// 读取主属性的当前值。
export function SU_GetHeroParmaryValue(u: any): number {
  if (!SUC_IsValidUnit(u)) return -1;

  const typ = SU_GetHeroParmary(u);
  if (typ === PRIMARY_STR) return typeof jass.GetHeroStr === "function" ? jass.GetHeroStr(u, true) : 0;
  if (typ === PRIMARY_AGI) return typeof jass.GetHeroAgi === "function" ? jass.GetHeroAgi(u, true) : 0;
  if (typ === PRIMARY_INT) return typeof jass.GetHeroInt === "function" ? jass.GetHeroInt(u, true) : 0;

  return -1;
}

// 一次性添加三项英雄属性。
export function SU_AddHeroAllState(u: any, a: number, b: number, c: number): void {
  SU_AddHeroState(u, PRIMARY_STR, 0, a);
  SU_AddHeroState(u, PRIMARY_INT, 0, b);
  SU_AddHeroState(u, PRIMARY_AGI, 0, c);
}

// 按主属性执行增设减。
export function SU_SetHeroParmaryValue(u: any, typ: number, value: number): void {
  if (!SUC_IsValidUnit(u)) return;

  const primaryType = SU_GetHeroParmary(u);
  if (primaryType < 0) return;

  if (typ === 0) {
    SU_AddHeroState(u, primaryType, 0, value);
  } else if (typ === 1) {
    SU_AddHeroState(u, primaryType, 1, value);
  } else if (typ === 2) {
    SU_AddHeroState(u, primaryType, 1, -value);
  }
}

// 判断是否匹配指定主属性。
export function SU_HeroISParmary(u: any, i: number): boolean {
  return SU_GetHeroParmary(u) === i;
}

// 判断点是否落在单位背面。
export function SU_DotBehindUnit(fac: number, x: number, y: number, a: number, b: number): boolean {
  const angle = GAFC(x, y, a, b) - fac;
  return CosBJ(angle) <= -0.707106;
}

// 获取目标相对单位的方位区间。
export function SU_GetUnitOfUnit(u: any, tu: any): number {
  if (!SUC_IsValidUnit(u) || !SUC_IsValidUnit(tu)) return 3;

  const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(u) : 0;
  const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(u) : 0;
  const a = typeof jass.GetUnitX === "function" ? jass.GetUnitX(tu) : 0;
  const b = typeof jass.GetUnitY === "function" ? jass.GetUnitY(tu) : 0;
  const facing = typeof jass.GetUnitFacing === "function" ? jass.GetUnitFacing(u) : 0;

  const angle = GAFC(x, y, a, b) - facing;
  const c = CosBJ(angle);

  if (c >= 0.866025) return 1;
  if (c >= 0.707106) return 4;
  if (c <= -0.866025) return 2;
  if (c <= -0.707106) return 5;
  return 3;
}

// 宽松判断目标是否在前方。
export function SU_IsUnitInfrontUnit2(u: any, tu: any): boolean {
  if (!SUC_IsValidUnit(u) || !SUC_IsValidUnit(tu)) return false;

  const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(u) : 0;
  const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(u) : 0;
  const a = typeof jass.GetUnitX === "function" ? jass.GetUnitX(tu) : 0;
  const b = typeof jass.GetUnitY === "function" ? jass.GetUnitY(tu) : 0;
  const facing = typeof jass.GetUnitFacing === "function" ? jass.GetUnitFacing(u) : 0;

  const angle = GAFC(x, y, a, b) - facing;
  return CosBJ(angle) > 0;
}

// 严格判断目标是否在正前方。
export function SU_IsUnitInfrontUnit(u: any, tu: any): boolean {
  return SU_GetUnitOfUnit(u, tu) === 1;
}

// 严格判断目标是否在正后方。
export function SU_IsUnitBehindUnit(u: any, tu: any): boolean {
  return SU_GetUnitOfUnit(u, tu) === 2;
}

// 计算单位白字攻击力。
export function SU_GetUnitWhiteAtk(u: any, a: number): number {
  if (!SUC_IsValidUnit(u)) return 0;

  const primaryGreen = getHeroPrimaryGreenValue(u);
  const baseDmg = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE))
    : 0;
  const bonusDmg = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ATTACK1_BONUS))
    : 0;
  const diceCount = typeof jass.GetUnitState === "function"
    ? jass.GetUnitState(u, jass.ConvertUnitState(UNIT_STATE_ATTACK1_COUNT))
    : 0;

  return baseDmg + bonusDmg * (diceCount + 1) / 2 - a * primaryGreen;
}

export {};
