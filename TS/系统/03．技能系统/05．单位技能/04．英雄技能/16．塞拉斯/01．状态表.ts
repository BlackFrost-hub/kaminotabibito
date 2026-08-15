/** @noSelfInFile */
// 塞拉斯专用同步状态表：普通/大魔法开关、当前元素、攻击标记、E 增幅统一入口。
// 所有读写都在同步游戏逻辑中进行；本地表现（按钮/文字）由各技能文件内的本地分支处理。

import { 塞拉斯技能配置, 塞拉斯元素 } from "./00．配置";

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;

export interface 塞拉斯魔法状态 {
  英雄句柄ID: number;
  普通魔法已开启: boolean;
  大魔法化: boolean;
  当前元素: 塞拉斯元素;
  普通魔法技能等级: number;
  开启回调ID: number;
  关闭回调ID: number;
}

interface 塞拉斯攻击标记 {
  火: boolean;
  冰: boolean;
  雷: boolean;
}

const 魔法状态表: Record<number, 塞拉斯魔法状态 | undefined> = {};
const 攻击标记表: Record<number, 塞拉斯攻击标记 | undefined> = {};

export function 取塞拉斯句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 获取塞拉斯魔法状态(this: void, unit: any): 塞拉斯魔法状态 | undefined {
  const id = 取塞拉斯句柄ID(unit);
  if (id === 0) return undefined;
  return 魔法状态表[id];
}

export function 获取或创建塞拉斯魔法状态(this: void, unit: any): 塞拉斯魔法状态 | undefined {
  const id = 取塞拉斯句柄ID(unit);
  if (id === 0) return undefined;
  const current = 魔法状态表[id];
  if (current != null) return current;
  const created: 塞拉斯魔法状态 = {
    英雄句柄ID: id,
    普通魔法已开启: false,
    大魔法化: false,
    当前元素: "",
    普通魔法技能等级: 0,
    开启回调ID: 0,
    关闭回调ID: 0,
  };
  魔法状态表[id] = created;
  return created;
}

export function 清理塞拉斯魔法状态(this: void, unit: any): void {
  const id = 取塞拉斯句柄ID(unit);
  if (id === 0) return;
  delete 魔法状态表[id];
  delete 攻击标记表[id];
}

export function 消费塞拉斯大魔法化(this: void, unit: any): boolean {
  const state = 获取塞拉斯魔法状态(unit);
  if (state == null) return false;
  if (!state.大魔法化) return false;
  state.大魔法化 = false;
  return true;
}

export function 设置塞拉斯攻击标记(this: void, unit: any, 元素: 塞拉斯元素): void {
  if (元素 === "") return;
  const id = 取塞拉斯句柄ID(unit);
  if (id === 0) return;
  let marks = 攻击标记表[id];
  if (marks == null) {
    marks = { 火: false, 冰: false, 雷: false };
    攻击标记表[id] = marks;
  }
  if (元素 === "火") marks.火 = true;
  if (元素 === "冰") marks.冰 = true;
  if (元素 === "雷") marks.雷 = true;
}

/**
 * 一次性取走全部有效攻击标记并清空（源 JASS 被动消费行为）。
 * 返回的布尔按 火/冰/雷 表示；同时返回优先级最高的元素（火 > 雷 > 冰，与源 JASS 分支顺序一致）。
 */
export function 消费塞拉斯攻击标记(this: void, unit: any): { 火: boolean; 冰: boolean; 雷: boolean; 优先元素: 塞拉斯元素 } {
  const id = 取塞拉斯句柄ID(unit);
  const empty = { 火: false, 冰: false, 雷: false, 优先元素: "" as 塞拉斯元素 };
  if (id === 0) return empty;
  const marks = 攻击标记表[id];
  if (marks == null) return empty;
  const result = { 火: marks.火, 冰: marks.冰, 雷: marks.雷, 优先元素: "" as 塞拉斯元素 };
  if (marks.火) result.优先元素 = "火";
  else if (marks.雷) result.优先元素 = "雷";
  else if (marks.冰) result.优先元素 = "冰";
  marks.火 = false;
  marks.冰 = false;
  marks.雷 = false;
  return result;
}

export function 塞拉斯拥有任意攻击标记(this: void, unit: any): boolean {
  const id = 取塞拉斯句柄ID(unit);
  if (id === 0) return false;
  const marks = 攻击标记表[id];
  if (marks == null) return false;
  return marks.火 || marks.冰 || marks.雷;
}

/**
 * E 属性提升统一增幅入口（塞拉斯专用）。
 * 增幅 = (10 + 3 × A0JX等级)%；只用于塞拉斯火冰雷魔法技能伤害，
 * 不修正普攻与灼烧周期伤害。项目统一魔法伤害修正入口落地后迁移本函数。
 */
export function 塞拉斯魔法技能增幅倍率(this: void, unit: any): number {
  if (unit == null || unit === 0) return 1;
  const level = GetUnitAbilityLevel(unit, 塞拉斯技能配置.E.技能类型ID);
  if (level <= 0) return 1;
  const 增幅百分比 = 塞拉斯技能配置.E.每级魔法伤害基础增幅百分比 + 塞拉斯技能配置.E.每级魔法伤害成长百分比 * level;
  return 1 + 增幅百分比 / 100;
}
