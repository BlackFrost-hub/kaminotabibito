/** @noSelfInFile */

import type {
  封印守卫战第三章技能环境,
  封印守卫战敌人机制状态,
  封印守卫战敌人记录,
  封印守卫战敌人类型,
  封印守卫战锚点状态,
} from "./00．类型";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, unit: any) => boolean;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, player: any) => any;
};
const { GS_LoadUintProperty } = require("lib.扩展函数.Star扩展函数.02．GS单位属性") as {
  GS_LoadUintProperty: (this: void, unit: any, propertyType: number) => number;
};
const { 单位是否处于硬控制效果合集 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  单位是否处于硬控制效果合集: (this: void, unit: any) => boolean;
};
const {
  创建点特效,
  createTimedUnitEffect,
  createUnitEffect,
  destroyUnitEffect,
} = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
};

const Player = jass.Player as (this: void, playerId: number) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, unit: any, order: string, target: any) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (this: void, unit: any, order: string, x: number, y: number) => boolean;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const Atan2 = jass.Atan2 as (this: void, y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 弧度转角度 = 57.29577951308232;
const 允许玩家英雄数量 = 6;

export const 封印守卫战第三章敌人单位ID = {
  失控英灵: stringToFourCCSafe("n06B"),
  夺灵祭司: stringToFourCCSafe("n06A"),
  锚蚀兽: stringToFourCCSafe("n06C"),
  断誓猎手: stringToFourCCSafe("n06D"),
  黑暗残响: stringToFourCCSafe("n069"),
  裂誓重卫: stringToFourCCSafe("n06E"),
  失律号令者: stringToFourCCSafe("n06F"),
  潮蚀巡鳞者: stringToFourCCSafe("n056"),
  碎礁投石手: stringToFourCCSafe("h00Y"),
  灵潮祭司: stringToFourCCSafe("n054"),
  金鳞执刑官: stringToFourCCSafe("n052"),
  深渊鳞将: stringToFourCCSafe("n055"),
} as const;

const 状态: 封印守卫战敌人机制状态 = {
  运行中: false,
  敌人列表: [],
  敌人映射: {},
  锚点压制数量: [0, 0, 0],
};

export function 设置封印守卫战第三章技能环境(this: void, 环境?: 封印守卫战第三章技能环境): void {
  状态.环境 = 环境;
  状态.运行中 = 环境 != null;
}

export function 读取封印守卫战第三章技能状态(this: void): 封印守卫战敌人机制状态 {
  return 状态;
}

export function 封印守卫战单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit) === true;
}

export function 取封印守卫战单位句柄ID(this: void, unit: any): number {
  return unit != null && unit !== 0 ? (GetHandleId(unit) || 0) : 0;
}

export function 创建封印守卫战敌人记录(
  this: void,
  unit: any,
  类型: 封印守卫战敌人类型,
  当前毫秒: number,
): 封印守卫战敌人记录 | undefined {
  const 句柄ID = 取封印守卫战单位句柄ID(unit);
  if (句柄ID === 0 || !封印守卫战单位存活(unit)) return undefined;
  const 已有 = 状态.敌人映射[句柄ID];
  if (已有 != null) return 已有;
  const record: 封印守卫战敌人记录 = {
    单位: unit,
    句柄ID,
    类型,
    下次AI毫秒: 当前毫秒,
    下次技能毫秒: 当前毫秒,
    充能ID: 0,
    锚点编号: 0,
    正在压制锚点: false,
    普攻计数: 0,
    上次被动毫秒: 0,
    号令结束毫秒: 0,
    号令属性已施加: false,
    号令移动速度增量: 0,
  };
  状态.敌人列表.push(record);
  状态.敌人映射[句柄ID] = record;
  return record;
}

export function 读取封印守卫战敌人记录(this: void, unit: any): 封印守卫战敌人记录 | undefined {
  const id = 取封印守卫战单位句柄ID(unit);
  return id > 0 ? 状态.敌人映射[id] : undefined;
}

export function 读取封印守卫战敌人列表(this: void): 封印守卫战敌人记录[] {
  return 状态.敌人列表;
}

export function 移除封印守卫战敌人记录引用(this: void, record: 封印守卫战敌人记录): void {
  if (状态.敌人映射[record.句柄ID] === record) delete 状态.敌人映射[record.句柄ID];
  const index = 状态.敌人列表.indexOf(record);
  if (index >= 0) 状态.敌人列表.splice(index, 1);
}

export function 清空封印守卫战敌人记录(this: void): void {
  状态.敌人列表.length = 0;
  状态.敌人映射 = {};
  状态.锚点压制数量[0] = 0;
  状态.锚点压制数量[1] = 0;
  状态.锚点压制数量[2] = 0;
}

export function 读取封印守卫战核心(this: void): any {
  return 状态.环境?.读取能量核心() ?? null;
}

export function 读取封印守卫战锚点状态(this: void, 锚点编号: number): 封印守卫战锚点状态 | undefined {
  return 状态.环境?.读取锚点状态(锚点编号);
}

export function 读取封印守卫战玩家英雄列表(this: void): any[] {
  const fromContext = 状态.环境?.读取玩家英雄列表();
  if (fromContext != null) return fromContext;
  const result: any[] = [];
  for (let i = 0; i < 允许玩家英雄数量; i++) {
    const hero = getRegisteredPlayerHero(Player(i));
    if (封印守卫战单位存活(hero)) result.push(hero);
  }
  return result;
}

export function 读取正在修复封印锚点的英雄列表(this: void): any[] {
  return 状态.环境?.读取正在修复锚点的英雄列表() ?? [];
}

export function 是封印守卫战玩家英雄(this: void, unit: any): boolean {
  if (!封印守卫战单位存活(unit)) return false;
  const list = 读取封印守卫战玩家英雄列表();
  for (let i = 0; i < list.length; i++) {
    if (list[i] === unit) return true;
  }
  return false;
}

export function 取单位X(this: void, unit: any): number {
  return GetUnitX(unit);
}

export function 取单位Y(this: void, unit: any): number {
  return GetUnitY(unit);
}

export function 取单位面向(this: void, unit: any): number {
  return GetUnitFacing(unit);
}

export function 取两点距离平方(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return dx * dx + dy * dy;
}

export function 取单位距离平方(this: void, first: any, second: any): number {
  if (!封印守卫战单位存活(first) || !封印守卫战单位存活(second)) return 999999999;
  return 取两点距离平方(GetUnitX(first), GetUnitY(first), GetUnitX(second), GetUnitY(second));
}

export function 取两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return SquareRoot(取两点距离平方(x1, y1, x2, y2));
}

export function 取两点方向角(this: void, x1: number, y1: number, x2: number, y2: number): number {
  let angle = Atan2(y2 - y1, x2 - x1) * 弧度转角度;
  if (angle < 0) angle += 360;
  return angle;
}

export function 取最近玩家英雄(this: void, unit: any, 最大范围?: number): any {
  const list = 读取封印守卫战玩家英雄列表();
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  const limit = 最大范围 != null && 最大范围 > 0 ? 最大范围 * 最大范围 : 999999999;
  let nearest: any = null;
  let best = limit;
  for (let i = 0; i < list.length; i++) {
    const hero = list[i];
    if (!封印守卫战单位存活(hero)) continue;
    const distance = 取两点距离平方(x, y, GetUnitX(hero), GetUnitY(hero));
    if (distance > best) continue;
    best = distance;
    nearest = hero;
  }
  return nearest;
}

export function 取最近单位(this: void, source: any, candidates: any[], 最大范围?: number): any {
  const x = GetUnitX(source);
  const y = GetUnitY(source);
  const limit = 最大范围 != null && 最大范围 > 0 ? 最大范围 * 最大范围 : 999999999;
  let nearest: any = null;
  let best = limit;
  for (let i = 0; i < candidates.length; i++) {
    const target = candidates[i];
    if (!封印守卫战单位存活(target)) continue;
    const distance = 取两点距离平方(x, y, GetUnitX(target), GetUnitY(target));
    if (distance > best) continue;
    best = distance;
    nearest = target;
  }
  return nearest;
}

export function 读取单位攻击力(this: void, unit: any): number {
  return GS_LoadUintProperty(unit, 2);
}

export function 读取单位最大生命(this: void, unit: any): number {
  return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) || 0;
}

export function 读取单位生命(this: void, unit: any): number {
  return GetUnitState(unit, jass.UNIT_STATE_LIFE) || 0;
}

export function 单位处于硬控制(this: void, unit: any): boolean {
  return 封印守卫战单位存活(unit) && 单位是否处于硬控制效果合集(unit) === true;
}

export function 命令攻击目标(this: void, unit: any, target: any): boolean {
  return 封印守卫战单位存活(unit) && 封印守卫战单位存活(target) && IssueTargetOrder(unit, "attack", target);
}

export function 命令移动到点(this: void, unit: any, x: number, y: number): boolean {
  return 封印守卫战单位存活(unit) && IssuePointOrder(unit, "move", x, y);
}

export function 命令停止(this: void, unit: any): boolean {
  return 封印守卫战单位存活(unit) && IssueImmediateOrder(unit, "stop");
}

export function 播放封印守卫战单位临时特效(this: void, unit: any, model: string, duration: number): any {
  return createTimedUnitEffect(unit, "origin", model, duration);
}

export function 创建封印守卫战单位常驻特效(this: void, unit: any, model: string, key: string): any {
  return createUnitEffect(unit, "origin", model, undefined, key);
}

export function 销毁封印守卫战单位常驻特效(this: void, unit: any, key: string): void {
  destroyUnitEffect(unit, key);
}

export function 创建封印守卫战点特效(this: void, params: any): any {
  return 创建点特效(params);
}

export function 销毁封印守卫战特效(this: void, effect: any): void {
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

export function 设置记录锚点压制(this: void, record: 封印守卫战敌人记录, enabled: boolean): void {
  if (record.锚点编号 < 1 || record.锚点编号 > 状态.锚点压制数量.length) return;
  if (record.正在压制锚点 === enabled) return;
  const index = record.锚点编号 - 1;
  const before = 状态.锚点压制数量[index] ?? 0;
  const after = enabled ? before + 1 : (before > 0 ? before - 1 : 0);
  状态.锚点压制数量[index] = after;
  record.正在压制锚点 = enabled;
  if ((before === 0) !== (after === 0)) 状态.环境?.设置锚点压制(record.锚点编号, after > 0);
}

export function 清理记录锚点压制(this: void, record: 封印守卫战敌人记录): void {
  设置记录锚点压制(record, false);
  销毁封印守卫战特效(record.压制特效);
  record.压制特效 = undefined;
  record.锚点编号 = 0;
}
