/** @noSelfInFile */
/**
 * 跳跃系统 - 共享模块
 *
 * 包含类型定义、常量、工具函数和状态容器。
 */
import type { 英雄技能距离修正上下文 } from "../../../04．机制组件/11．技能属性修正";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { X_GAFC, X_IsTerrainWalkable, X_IsUnitTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_GAFC: (x1: number, y1: number, x2: number, y2: number) => number;
  X_IsTerrainWalkable: (x: number, y: number) => boolean;
  X_IsUnitTerrainWalkable: (this: void, unit: any, x: number, y: number) => boolean;
  X_GetAbleX: () => number;
  X_GetAbleY: () => number;
};
const {
  申请单位暂停占用,
  释放单位暂停占用,
  单位是否存在其他暂停占用,
} = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  申请单位暂停占用: (this: void, 单位: any, 来源: string) => boolean;
  释放单位暂停占用: (this: void, 单位: any, 来源: string) => boolean;
  单位是否存在其他暂停占用: (this: void, 单位: any, 自身来源: string) => boolean;
};
const { 零秒后重置单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  零秒后重置单位动画: (this: void, 单位: any, 下一步?: () => void) => any;
};

const GetHandleId = jass["GetHandleId"] as (h: any) => number;
const GetUnitState = jass["GetUnitState"] as (u: any, state: any) => number;
const GetRectMinX = jass["GetRectMinX"] as (r: any) => number;
const GetRectMinY = jass["GetRectMinY"] as (r: any) => number;
const GetRectMaxX = jass["GetRectMaxX"] as (r: any) => number;
const GetRectMaxY = jass["GetRectMaxY"] as (r: any) => number;
const UnitAddAbility = jass["UnitAddAbility"] as (u: any, abilityId: number) => void;
const UnitRemoveAbility = jass["UnitRemoveAbility"] as (u: any, abilityId: number) => void;
const AddSpecialEffect = jass["AddSpecialEffect"] as (model: string, x: number, y: number) => any;
const DestroyEffect = jass["DestroyEffect"] as (effect: any) => void;
const GetRandomReal = jass["GetRandomReal"] as (low: number, high: number) => number;
const GetUnitX = jass["GetUnitX"] as (u: any) => number;
const GetUnitY = jass["GetUnitY"] as (u: any) => number;
const GetUnitFlyHeight = jass["GetUnitFlyHeight"] as (u: any) => number;
const SetUnitFlyHeight = jass["SetUnitFlyHeight"] as (u: any, h: number, rate: number) => void;
const SetUnitFacing = jass["SetUnitFacing"] as (u: any, facing: number) => void;
const SetUnitX = jass["SetUnitX"] as (u: any, x: number) => void;
const SetUnitY = jass["SetUnitY"] as (u: any, y: number) => void;
const Cos = jass["Cos"] as (radians: number) => number;
const Sin = jass["Sin"] as (radians: number) => number;
const IsUnitPaused = jass["IsUnitPaused"] as (u: any) => boolean;
const ForGroup = jass["ForGroup"] as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass["GetEnumUnit"] as () => any;

export { jass, jglobals, X_GAFC, X_IsTerrainWalkable, X_IsUnitTerrainWalkable, X_GetAbleX, X_GetAbleY };
export { 申请单位暂停占用, 释放单位暂停占用, 单位是否存在其他暂停占用 };
export { 零秒后重置单位动画 };
export {
  GetHandleId, GetUnitState, GetRectMinX, GetRectMinY, GetRectMaxX, GetRectMaxY,
  UnitAddAbility, UnitRemoveAbility, AddSpecialEffect, DestroyEffect, GetRandomReal,
  GetUnitX, GetUnitY, GetUnitFlyHeight, SetUnitFlyHeight,
  SetUnitFacing, SetUnitX, SetUnitY, Cos, Sin, IsUnitPaused,
  ForGroup, GetEnumUnit,
};

export const BJ_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
export const TICK_INTERVAL = 0.02;
export const CENTER_TIMER_TICKS = 2;
export const MAX_SUB_STEP = 31.0;
export const WALKABLE_TOLERANCE = 8.0;
export const UNIT_ALIVE_LIFE = 0.405;
export const DEFAULT_JUMP_EFFECT_MODEL = "";
export const CROW_FORM_ABILITY_ID = 1097691750;

export type 跳跃结束原因 = "完成" | "中断" | "死亡" | "阻挡" | "主单位死亡";

export type 跳跃结束回调 = (单位: any, 原因: 跳跃结束原因, 跳跃ID: number) => void;
export type 跳跃落点过滤 = (x: number, y: number, 单位: any, 跳跃ID: number) => boolean;
export type 跳跃开始回调 = (单位: any, 跳跃ID: number) => void;

export interface 通用跳跃参数 {
  距离: number;
  英雄技能距离修正?: 英雄技能距离修正上下文;
  主单位?: any;
  主单位死亡时中断?: boolean;
  持续时间: number;
  跳跃高度: number;
  暂停单位?: boolean;
  朝向跟随跳跃?: boolean;
  跳跃特效?: string;
  落点过滤?: 跳跃落点过滤;
  结束回调?: 跳跃结束回调;
  开始回调?: 跳跃开始回调;
}

export interface 跳跃参数 extends 通用跳跃参数 {
  目标X?: number;
  目标Y?: number;
  角度?: number;
}

export interface 跳跃实例 {
  id: number;
  listIndex: number;
  单位: any;
  单位ID: number;
  主单位?: any;
  主单位死亡时中断: boolean;
  角度: number;
  总距离: number;
  已移动: number;
  每tick位移: number;
  跳跃高度: number;
  上次附加高度: number;
  暂停单位: boolean;
  暂停来源: string;
  朝向跟随跳跃: boolean;
  跳跃特效: string;
  落点过滤?: 跳跃落点过滤;
  结束回调?: 跳跃结束回调;
  开始回调?: 跳跃开始回调;
}

export const 活动跳跃列表: 跳跃实例[] = [];
export const 跳跃映射: Record<number, 跳跃实例 | undefined> = {};
export const 单位当前跳跃: Record<number, number | undefined> = {};

let 单位组快照缓存: any[] = [];
let 下一个跳跃ID = 0;

export function 分配新跳跃ID(this: void): number {
  下一个跳跃ID += 1;
  return 下一个跳跃ID;
}

export function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
}

function 收集单位组成员(): void {
  const 单位 = GetEnumUnit();
  if (单位 != null && 单位 !== 0) {
    单位组快照缓存.push(单位);
  }
}

export function 快照单位组(单位组: any): any[] {
  if (单位组 == null || 单位组 === 0) return [];
  单位组快照缓存 = [];
  ForGroup(单位组, 收集单位组成员);
  const 结果 = 单位组快照缓存;
  单位组快照缓存 = [];
  return 结果;
}

export function 单位存活(u: any): boolean {
  return u != null && u !== 0 && GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

export function 在可玩区域内(x: number, y: number): boolean {
  return x >= GetRectMinX(jglobals.bj_mapInitialPlayableArea)
    && y >= GetRectMinY(jglobals.bj_mapInitialPlayableArea)
    && x <= GetRectMaxX(jglobals.bj_mapInitialPlayableArea)
    && y <= GetRectMaxY(jglobals.bj_mapInitialPlayableArea);
}

export function 计算坐标距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return jass.SquareRoot(dx * dx + dy * dy) as number;
}

export function 计算每tick位移(距离: number, 持续时间: number): number {
  if (持续时间 <= 0) return 距离;
  return 距离 / (持续时间 / TICK_INTERVAL);
}

export function 确保单位可设置飞行高度(单位: any): void {
  UnitAddAbility(单位, CROW_FORM_ABILITY_ID);
  UnitRemoveAbility(单位, CROW_FORM_ABILITY_ID);
}

export function 限制进度(v: number): number {
  if (v <= 0) return 0;
  if (v >= 1) return 1;
  return v;
}

export function 计算抛物线高度(进度: number, 最大高度: number): number {
  const t = 限制进度(进度);
  return 4.0 * 最大高度 * t * (1.0 - t);
}

export function 播放跳跃特效(实例: 跳跃实例): void {
  const 模型 = 实例.跳跃特效;
  if (模型 == null || 模型 === "") return;
  const 特效 = AddSpecialEffect(
    模型,
    GetUnitX(实例.单位),
    GetUnitY(实例.单位)
  );
  if (特效 != null && 特效 !== 0) {
    DestroyEffect(特效);
  }
}

export function 单位已被暂停(单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return IsUnitPaused(单位) === true;
}
