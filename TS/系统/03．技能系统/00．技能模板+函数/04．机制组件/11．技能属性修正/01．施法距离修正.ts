/** @noSelfInFile */

const jass = require("jass.common") as any;
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能施法距离: (this: void, 单位: any, 技能代码: number, 值: number) => boolean;
};
const platformAbilityGetter = require("平台扩展API取值") as {
  技能_获取技能施法距离: (this: void, 单位: any, 技能代码: number) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

export type 标准技能距离修正用途 =
  | "施法距离"
  | "施法距离派生距离"
  | "自身位移距离"
  | "路径长度"
  | "路径总长度"
  | "直线长度"
  | "矩形长度"
  | "胶囊长度"
  | "扇形半径"
  | "弹幕飞行距离"
  | "飞行最大距离"
  | "投射物最大距离"
  | "追踪最大距离"
  | "目标点最大距离"
  | "落点最大距离"
  | "效果半径"
  | "爆炸半径"
  | "击退距离"
  | "牵引距离"
  | "移动别人距离";

export type 技能距离修正用途 = 标准技能距离修正用途 | (string & {});

export interface 英雄技能施法距离配置 {
  基础施法距离?: number;
  最小距离?: number;
  最大距离?: number;
  同步物遍施法距离?: boolean;
}

export interface 技能距离修正选项 {
  吃施法距离加成?: boolean;
  最小距离?: number;
  最大距离?: number;
}

const 英雄技能全局施法距离修正表: Record<number, number | undefined> = {};
const 英雄技能单技能施法距离修正表: Record<string, number | undefined> = {};
const 英雄技能施法距离配置表: Record<string, 英雄技能施法距离配置 | undefined> = {};

function 转技能ID(this: void, 技能ID: number | string | undefined | null): number {
  if (技能ID == null) return 0;
  if (typeof 技能ID === "number") return 技能ID;
  return stringToFourCCSafe(技能ID);
}

function 是有效英雄(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_HERO) === true;
}

function 取单位ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

function 取技能键(this: void, 单位: any, 技能ID: number | string | undefined | null): string {
  const 单位ID = 取单位ID(单位);
  const 实际技能ID = 转技能ID(技能ID);
  if (单位ID <= 0 || 实际技能ID <= 0) return "";
  return String(单位ID) + "#" + String(实际技能ID);
}

function 限制距离(this: void, 值: number, 最小距离?: number, 最大距离?: number): number {
  let result = 值;
  const min = 最小距离 ?? 0;
  if (result < min) result = min;
  if (最大距离 != null && 最大距离 > min && result > 最大距离) result = 最大距离;
  return result;
}

export function 技能距离用途默认吃施法距离加成(this: void, 用途: 技能距离修正用途): boolean {
  return 用途 === "施法距离"
    || 用途 === "施法距离派生距离"
    || 用途 === "自身位移距离"
    || 用途 === "路径长度"
    || 用途 === "路径总长度"
    || 用途 === "直线长度"
    || 用途 === "矩形长度"
    || 用途 === "胶囊长度"
    || 用途 === "扇形半径"
    || 用途 === "弹幕飞行距离"
    || 用途 === "飞行最大距离"
    || 用途 === "投射物最大距离"
    || 用途 === "追踪最大距离"
    || 用途 === "目标点最大距离"
    || 用途 === "落点最大距离";
}

export function 取英雄技能施法距离修正(this: void, 单位: any, 技能ID?: number | string): number {
  if (!是有效英雄(单位)) return 0;
  const 单位ID = 取单位ID(单位);
  let result = 英雄技能全局施法距离修正表[单位ID] ?? 0;
  const key = 技能ID != null ? 取技能键(单位, 技能ID) : "";
  if (key !== "") result += 英雄技能单技能施法距离修正表[key] ?? 0;
  return result;
}

export function 取英雄技能修正距离(this: void, 单位: any, 技能ID: number | string, 基础距离: number, 用途: 技能距离修正用途, 选项?: 技能距离修正选项): number {
  if (!(基础距离 > 0)) return 0;
  const shouldApply = 选项?.吃施法距离加成 ?? 技能距离用途默认吃施法距离加成(用途);
  if (!shouldApply) return 限制距离(基础距离, 选项?.最小距离, 选项?.最大距离);

  const key = 取技能键(单位, 技能ID);
  const config = key !== "" ? 英雄技能施法距离配置表[key] : undefined;
  const min = 选项?.最小距离 ?? config?.最小距离;
  const max = 选项?.最大距离 ?? config?.最大距离;
  return 限制距离(基础距离 + 取英雄技能施法距离修正(单位, 技能ID), min, max);
}

export function 取英雄技能施法距离派生距离(this: void, 单位: any, 技能ID: number | string, 基础距离: number, 选项?: 技能距离修正选项): number {
  return 取英雄技能修正距离(单位, 技能ID, 基础距离, "施法距离派生距离", {
    ...(选项 ?? {}),
    吃施法距离加成: 选项?.吃施法距离加成 ?? true,
  });
}

export function 取英雄技能最终施法距离(this: void, 单位: any, 技能ID: number | string, 基础施法距离?: number): number {
  const key = 取技能键(单位, 技能ID);
  const config = key !== "" ? 英雄技能施法距离配置表[key] : undefined;
  const abilityId = 转技能ID(技能ID);
  const base = 基础施法距离 ?? config?.基础施法距离 ?? (abilityId > 0 ? platformAbilityGetter.技能_获取技能施法距离(单位, abilityId) : 0);
  return 取英雄技能修正距离(单位, abilityId, base, "施法距离", {
    最小距离: config?.最小距离,
    最大距离: config?.最大距离,
  });
}

export function 登记英雄技能施法距离配置(this: void, 单位: any, 技能ID: number | string, 配置: 英雄技能施法距离配置): boolean {
  if (!是有效英雄(单位)) return false;
  const abilityId = 转技能ID(技能ID);
  const key = 取技能键(单位, abilityId);
  if (key === "") return false;

  const base = 配置.基础施法距离 ?? platformAbilityGetter.技能_获取技能施法距离(单位, abilityId);
  英雄技能施法距离配置表[key] = {
    ...配置,
    基础施法距离: base > 0 ? base : 配置.基础施法距离,
  };

  if (配置.同步物遍施法距离 !== false) {
    刷新英雄技能物遍施法距离(单位, abilityId);
  }
  return true;
}

export function 取消登记英雄技能施法距离配置(this: void, 单位: any, 技能ID: number | string): void {
  const key = 取技能键(单位, 技能ID);
  if (key === "") return;
  delete 英雄技能施法距离配置表[key];
  delete 英雄技能单技能施法距离修正表[key];
}

export function 设置英雄技能施法距离修正(this: void, 单位: any, 修正值: number, 刷新: boolean = true): void {
  if (!是有效英雄(单位)) return;
  const 单位ID = 取单位ID(单位);
  英雄技能全局施法距离修正表[单位ID] = 修正值;
  if (刷新) 刷新英雄单位全部技能施法距离(单位);
}

export function 调整英雄技能施法距离修正(this: void, 单位: any, 变化值: number, 刷新: boolean = true): void {
  设置英雄技能施法距离修正(单位, 取英雄技能施法距离修正(单位) + 变化值, 刷新);
}

export function 设置指定英雄技能施法距离修正(this: void, 单位: any, 技能ID: number | string, 修正值: number, 刷新: boolean = true): void {
  if (!是有效英雄(单位)) return;
  const key = 取技能键(单位, 技能ID);
  if (key === "") return;
  英雄技能单技能施法距离修正表[key] = 修正值;
  if (刷新) 刷新英雄技能物遍施法距离(单位, 技能ID);
}

export function 刷新英雄技能物遍施法距离(this: void, 单位: any, 技能ID: number | string, 基础施法距离?: number): boolean {
  if (!是有效英雄(单位)) return false;
  const abilityId = 转技能ID(技能ID);
  if (abilityId <= 0) return false;

  const key = 取技能键(单位, abilityId);
  const config = key !== "" ? 英雄技能施法距离配置表[key] : undefined;
  const base = 基础施法距离 ?? config?.基础施法距离;
  if (!(base != null && base > 0)) return false;

  const range = 取英雄技能最终施法距离(单位, abilityId, base);
  return platformAbilityAction.技能_设置技能施法距离(单位, abilityId, range);
}

export function 刷新英雄单位全部技能施法距离(this: void, 单位: any): void {
  if (!是有效英雄(单位)) return;
  const prefix = String(取单位ID(单位)) + "#";
  for (const key in 英雄技能施法距离配置表) {
    if (key.indexOf(prefix) !== 0) continue;
    const config = 英雄技能施法距离配置表[key];
    if (config == null || config.同步物遍施法距离 === false) continue;
    const abilityId = parseInt(key.substring(prefix.length), 10);
    if (abilityId > 0) 刷新英雄技能物遍施法距离(单位, abilityId);
  }
}

export function 清除英雄技能施法距离修正(this: void, 单位: any, 刷新: boolean = true): void {
  const 单位ID = 取单位ID(单位);
  if (单位ID <= 0) return;
  delete 英雄技能全局施法距离修正表[单位ID];
  const prefix = String(单位ID) + "#";
  for (const key in 英雄技能单技能施法距离修正表) {
    if (key.indexOf(prefix) === 0) delete 英雄技能单技能施法距离修正表[key];
  }
  if (刷新) 刷新英雄单位全部技能施法距离(单位);
}

export {};
