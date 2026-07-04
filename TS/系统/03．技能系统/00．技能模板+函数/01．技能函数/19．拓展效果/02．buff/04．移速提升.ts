/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (
    this: void,
    target: any,
    buffID: string,
    durationSec: number,
    effectValue: number,
    extras?: {
      sourceName?: string;
      iconOverride?: string;
      effectModelOverride?: string;
      onRemove?: (this: void, unit: any, buffID: string, row: { effect: number }) => void;
    }
  ) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { applyEquipStatsTS } = require("lib.扩展函数.Star扩展函数.01．装备属性应用") as {
  applyEquipStatsTS: (this: void, unit: any, stats: { name: string; value: number }[]) => Record<string, number>;
};
const { SOS_SetUnitSpeed, SOS_GetUnitSpeed, SOS_UnSetUnitSpeed } = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统") as {
  SOS_SetUnitSpeed: (this: void, unit: any, speed: number) => void;
  SOS_GetUnitSpeed: (this: void, unit: any) => number;
  SOS_UnSetUnitSpeed: (this: void, unit: any) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitName = jass.GetUnitName as (unit: any) => string;
const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (unit: any) => number;
const GetUnitMoveSpeed = jass.GetUnitMoveSpeed as (unit: any) => number;

const 默认移速提升BuffID = "C033";
const 引擎移速上限 = 522;

export interface 移速提升Buff参数 {
  BuffID?: string;
  持续时间: number;
  固定移速?: number;
  基础移速百分比?: number;
  当前移速百分比?: number;
  图标路径?: string;
  特效路径?: string;
}

interface 移速提升记录 {
  单位: any;
  BuffID: string;
  应用移速: number;
  原突破移速: number;
  应用突破移速: number;
}

const 移速提升记录表: Record<string, 移速提升记录 | undefined> = {};

function 取单位句柄ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  if (typeof 单位 === "number") return 单位;
  return GetHandleId(单位) || 0;
}

function 取单位键(this: void, 单位: any, BuffID: string): string {
  const hid = 取单位句柄ID(单位);
  if (hid === 0 || BuffID === "") return "";
  return hid + "|" + BuffID;
}

function 取有效BuffID(this: void, BuffID: string | undefined): string {
  return BuffID != null && BuffID !== "" ? BuffID : 默认移速提升BuffID;
}

function 取正数(this: void, value: number | undefined): number {
  return value != null && value > 0 ? value : 0;
}

function 应用移速属性(this: void, 单位: any, 移速: number): void {
  if (单位 == null || 单位 === 0 || 移速 === 0) return;
  applyEquipStatsTS(单位, [{ name: "叠加移动速度", value: 移速 }]);
}

function 计算移速提升值(this: void, 目标单位: any, 参数: 移速提升Buff参数): number {
  const 固定移速 = 取正数(参数.固定移速);
  const 基础百分比 = 取正数(参数.基础移速百分比);
  const 当前百分比 = 取正数(参数.当前移速百分比);
  const 基础移速 = GetUnitDefaultMoveSpeed(目标单位) || 0;
  const 当前移速 = GetUnitMoveSpeed(目标单位) || 0;
  return 固定移速 + 基础移速 * 基础百分比 + 当前移速 * 当前百分比;
}

function on移速提升移除(this: void, 单位: any, BuffID: string, _row: { effect: number }): void {
  const key = 取单位键(单位, BuffID);
  if (key === "") return;

  const 记录 = 移速提升记录表[key];
  delete 移速提升记录表[key];
  if (记录 == null) return;

  const 实际单位 = typeof 单位 === "number" ? 记录.单位 : 单位;
  const 当前突破移速 = SOS_GetUnitSpeed(实际单位) || 0;
  应用移速属性(实际单位, -记录.应用移速);

  const 移除后突破移速 = 当前突破移速 > 引擎移速上限 ? 当前突破移速 - 记录.应用移速 : 记录.原突破移速;
  if (移除后突破移速 > 引擎移速上限) {
    SOS_SetUnitSpeed(实际单位, 移除后突破移速);
  } else {
    SOS_UnSetUnitSpeed(实际单位);
  }
}

export function 施加移速提升Buff(this: void, 来源单位: any, 目标单位: any, 参数: 移速提升Buff参数): boolean {
  if (目标单位 == null || 目标单位 === 0) return false;
  if (!(参数.持续时间 > 0)) return false;

  const BuffID = 取有效BuffID(参数.BuffID);
  移除单位指定Buff(目标单位, BuffID);

  const 提升移速 = 计算移速提升值(目标单位, 参数);
  if (!(提升移速 > 0)) return false;

  const 原突破移速 = SOS_GetUnitSpeed(目标单位) || 0;
  const 当前实际移速 = 原突破移速 > 引擎移速上限 ? 原突破移速 : (GetUnitMoveSpeed(目标单位) || 0);
  const 提升后移速 = 当前实际移速 + 提升移速;
  const key = 取单位键(目标单位, BuffID);
  if (key === "") return false;

  应用移速属性(目标单位, 提升移速);
  if (提升后移速 > 引擎移速上限) {
    SOS_SetUnitSpeed(目标单位, 提升后移速);
  } else {
    SOS_UnSetUnitSpeed(目标单位);
  }

  移速提升记录表[key] = {
    单位: 目标单位,
    BuffID,
    应用移速: 提升移速,
    原突破移速,
    应用突破移速: 提升后移速,
  };

  registerManualBuff(目标单位, BuffID, 参数.持续时间, 提升移速, {
    sourceName: 来源单位 != null && 来源单位 !== 0 ? GetUnitName(来源单位) : undefined,
    iconOverride: 参数.图标路径,
    effectModelOverride: 参数.特效路径,
    onRemove: on移速提升移除,
  });

  return true;
}

export function 清除单位移速提升Buff(this: void, 单位: any): boolean {
  return 移除单位指定Buff(单位, 默认移速提升BuffID);
}

export {};
