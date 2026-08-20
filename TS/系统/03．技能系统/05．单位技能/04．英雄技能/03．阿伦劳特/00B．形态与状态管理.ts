/** @noSelfInFile */

/**
 * 阿伦劳特 - 形态与状态管理
 *
 * 职责：
 * - 光（H00F）/暗（H00G）形态判定
 * - 原生 Buff 挂载/移除（由 S005/S007/S006/S008 产生 B015/B018/B019/B017），
 *   供 Q/E/R 以统一方式判定强化状态（E 文件直接读 B015/B018）
 * - 通用工具：目标过滤、角度/距离、单位存活
 */

import { 阿伦劳特单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;
const 弧度转角度 = 57.29577951308232;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 秒转毫秒 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算") as {
  秒转毫秒: (this: void, seconds: number) => number;
};

interface 原生Buff到期参数 {
  单位: any;
  技能ID: number;
  单位ID: number;
  BuffID: number;
}

function 原生Buff到期移除(this: void, variable?: any): void {
  const 参数 = variable as 原生Buff到期参数 | undefined;
  if (参数 == null) return;
  UnitRemoveAbility(参数.单位, 参数.技能ID);
  const map = 原生Buff定时表[参数.单位ID];
  if (map != null) map[参数.BuffID] = undefined;
}

const 光形态单位ID = stringToFourCCSafe(阿伦劳特单位技能配置.光形态单位ID);
const 暗形态单位ID = stringToFourCCSafe(阿伦劳特单位技能配置.暗形态单位ID);
const B015 = stringToFourCCSafe(阿伦劳特单位技能配置.裁决审判强化BuffID);
const B018 = stringToFourCCSafe(阿伦劳特单位技能配置.天堂呼唤强化BuffID);
const B019 = stringToFourCCSafe(阿伦劳特单位技能配置.裁决制裁BuffID);
const B017 = stringToFourCCSafe(阿伦劳特单位技能配置.切换加攻BuffID);
const S005 = stringToFourCCSafe(阿伦劳特单位技能配置.裁决审判强化技能ID);
const S007 = stringToFourCCSafe(阿伦劳特单位技能配置.天堂呼唤强化技能ID);
const S006 = stringToFourCCSafe(阿伦劳特单位技能配置.裁决制裁技能ID);
const S008 = stringToFourCCSafe(阿伦劳特单位技能配置.切换加攻技能ID);

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;

/** 是否为阿伦劳特（光/暗任一形态） */
export function 是阿伦劳特英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const id = GetUnitTypeId(unit);
  return id === 光形态单位ID || id === 暗形态单位ID;
}

/** 光形态 */
export function 是光形态(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === 光形态单位ID;
}

/** 暗形态 */
export function 是暗形态(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === 暗形态单位ID;
}

/** 单位是否拥有指定原生 Buff（GetUnitAbilityLevel > 0） */
export function 阿伦劳特拥有原生Buff(this: void, unit: any, buffId: number): boolean {
  if (unit == null || unit === 0 || buffId === 0) return false;
  const abilityId = 取原生Buff技能ID(buffId);
  return abilityId !== 0 && GetUnitAbilityLevel(unit, abilityId) > 0;
}

/** 判定：拥有裁决审判（B015） */
export function 拥有裁决审判(this: void, unit: any): boolean {
  return 阿伦劳特拥有原生Buff(unit, B015);
}

/** 判定：拥有天堂呼唤（B018） */
export function 拥有天堂呼唤(this: void, unit: any): boolean {
  return 阿伦劳特拥有原生Buff(unit, B018);
}

interface 原生Buff记录 {
  定时器ID: number;
}

const 原生Buff定时表: Record<number, Record<number, 原生Buff记录 | undefined> | undefined> = {};

/** 给单位添加原生 Buff，持续 duration 秒后自动移除；重复添加刷新时长 */
export function 添加原生Buff持续(this: void, unit: any, buffId: number, duration: number): void {
  if (unit == null || unit === 0 || duration <= 0) return;
  const abilityId = 取原生Buff技能ID(buffId);
  if (abilityId === 0) return;
  UnitAddAbility(unit, abilityId);
  if (GetUnitAbilityLevel(unit, abilityId) <= 0) return;
  const unitId = GetHandleId(unit);
  let unitMap = 原生Buff定时表[unitId];
  if (unitMap == null) {
    unitMap = {};
    原生Buff定时表[unitId] = unitMap;
  }
  const old = unitMap[buffId];
  if (old != null && old.定时器ID !== 0) removeDelayedCallback(old.定时器ID);
  const timerId = addDelayedCallback(
    秒转毫秒(duration),
    原生Buff到期移除,
    { 单位: unit, 技能ID: abilityId, 单位ID: unitId, BuffID: buffId } as 原生Buff到期参数,
  );
  unitMap[buffId] = { 定时器ID: timerId };
}

/** 立即移除指定原生 Buff（含定时器清理） */
export function 移除原生Buff(this: void, unit: any, buffId: number): void {
  if (unit == null || unit === 0) return;
  const abilityId = 取原生Buff技能ID(buffId);
  if (abilityId === 0) return;
  UnitRemoveAbility(unit, abilityId);
  const unitId = GetHandleId(unit);
  const map = 原生Buff定时表[unitId];
  if (map == null) return;
  const record = map[buffId];
  if (record != null && record.定时器ID !== 0) removeDelayedCallback(record.定时器ID);
  map[buffId] = undefined;
}

function 取原生Buff技能ID(this: void, buffId: number): number {
  if (buffId === B015) return S005;
  if (buffId === B018) return S007;
  if (buffId === B019) return S006;
  if (buffId === B017) return S008;
  return 0;
}

/** 目标过滤：排除古树/机械/建筑 + 存活 */
export function 是有效目标(this: void, target: any): boolean {
  if (target == null || target === 0) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_DEAD as any)) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_ANCIENT as any)) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_MECHANICAL as any)) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_STRUCTURE as any)) return false;
  return true;
}

/** 两点角度（度） */
export function 两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Atan2(y2 - y1, x2 - x1) * 弧度转角度;
}

/** 两点距离 */
export function 两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

export {};
