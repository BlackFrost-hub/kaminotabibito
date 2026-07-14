/** @noSelfInFile */
import type { 技能伤害来源类型, 技能伤害形态, 装备技能伤害类型 } from "../../../../../04．伤害系统/08．技能伤害系统";
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
  添加单位暂停,
  移除单位暂停,
  单位是否存在其他暂停占用,
} = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, 单位: any, 来源: string) => boolean;
  移除单位暂停: (this: void, 单位: any, 来源: string) => boolean;
  单位是否存在其他暂停占用: (this: void, 单位: any, 自身来源: string) => boolean;
};
const { 零秒后播放单位动作, 零秒后重置单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  零秒后播放单位动作: (this: void, 单位: any, 动画名: string, 下一步?: () => void) => any;
  零秒后重置单位动画: (this: void, 单位: any, 下一步?: () => void) => any;
};

const ForGroup = jass["ForGroup"] as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass["GetEnumUnit"] as () => any;
const SetUnitAnimation = jass["SetUnitAnimation"] as ((u: any, animName: string) => void) | undefined;
const SetUnitTimeScale = jass["SetUnitTimeScale"] as ((u: any, scale: number) => void) | undefined;

export { jass, jglobals, X_GAFC, X_IsTerrainWalkable, X_IsUnitTerrainWalkable, X_GetAbleX, X_GetAbleY };
export { 添加单位暂停, 移除单位暂停, 单位是否存在其他暂停占用 };
export { 零秒后播放单位动作, 零秒后重置单位动画, SetUnitAnimation, SetUnitTimeScale };

export const BJ_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
export const TICK_INTERVAL = 0.02;
export const CENTER_TIMER_TICKS = 2;
export const MAX_SUB_STEP = 31.0;
export const WALKABLE_TOLERANCE = 8.0;
export const UNIT_ALIVE_LIFE = 0.405;
export const DEFAULT_MOVE_EFFECT_MODEL = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl";
export const DEFAULT_ATTACK_TYPE = jass.ATTACK_TYPE_NORMAL;
export const DEFAULT_DAMAGE_TYPE = jass.DAMAGE_TYPE_NORMAL;
export const DEFAULT_WEAPON_TYPE = jass.WEAPON_TYPE_WHOKNOWS;

export type 位移结束原因 = "完成" | "撞墙" | "命中" | "中断" | "死亡" | "主单位死亡";

export type 命中过滤函数 = (移动单位: any, 目标单位: any, 位移ID: number) => boolean;
export type 命中回调函数 = (移动单位: any, 目标单位: any, 位移ID: number) => void;
export type 撞墙回调函数 = (this: void, 移动单位: any, 位移ID: number) => void;
export type 结束回调函数 = (移动单位: any, 原因: 位移结束原因, 位移ID: number, 命中目标?: any) => void;
export type 开始回调函数 = (单位: any, ID: number) => void;

export interface 位移技能伤害标记 {
  来源类型?: 技能伤害来源类型;
  装备技能类型?: 装备技能伤害类型;
  伤害形态?: 技能伤害形态;
  物品ID?: number;
  物品实例?: any;
  技能ID?: number;
  技能实例ID?: number;
  标签?: string;
  参与技能伤害加成?: boolean;
}

export interface 通用位移参数 {
  距离: number;
  英雄技能距离修正?: 英雄技能距离修正上下文;
  主单位?: any;
  主单位死亡时中断?: boolean;
  持续时间?: number;
  每秒速度?: number;
  检查地形?: boolean;
  朝向跟随位移?: boolean;
  暂停单位?: boolean;
  禁用碰撞?: boolean;
  位移特效?: string;

  命中半径?: number;
  只命中敌人?: boolean;
  允许命中自己?: boolean;
  允许重复命中?: boolean;
  命中后结束?: boolean;

  命中伤害?: number;
  伤害来源?: any;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
  技能伤害标记?: 位移技能伤害标记;

  命中过滤?: 命中过滤函数;
  命中回调?: 命中回调函数;
  撞墙回调?: 撞墙回调函数;
  结束回调?: 结束回调函数;
  开始回调?: 开始回调函数;
}

export interface 冲锋参数 extends 通用位移参数 {
  角度?: number;
  目标X?: number;
  目标Y?: number;
}

export interface 击退参数 extends 通用位移参数 {
  角度?: number;
  来源单位?: any;
  来源X?: number;
  来源Y?: number;
}

export interface 位移实例 {
  id: number;
  listIndex: number;
  单位: any;
  单位ID: number;
  主单位?: any;
  主单位死亡时中断: boolean;
  角度: number;
  每Tick位移: number;
  总距离: number;
  已移动: number;
  检查地形: boolean;
  朝向跟随位移: boolean;
  暂停单位: boolean;
  禁用碰撞: boolean;
  位移特效: string;
  命中半径: number;
  只命中敌人: boolean;
  允许命中自己: boolean;
  允许重复命中: boolean;
  命中后结束: boolean;
  命中伤害: number;
  伤害来源: any;
  攻击类型: any;
  伤害类型: any;
  武器类型: any;
  技能伤害标记?: 位移技能伤害标记;
  命中过滤?: 命中过滤函数;
  命中回调?: 命中回调函数;
  撞墙回调?: 撞墙回调函数;
  结束回调?: 结束回调函数;
  开始回调?: 开始回调函数;
  暂停来源: string;
}

export const 活动位移列表: 位移实例[] = [];
export const 位移映射: Record<number, 位移实例 | undefined> = {};
export const 单位当前位移: Record<number, number | undefined> = {};
export const 命中记录: Record<string, true | undefined> = {};

let 枚举组: any = null;
let 单位组快照缓存: any[] = [];
let 下一个位移ID = 0;

export function 分配新位移ID(this: void): number {
  下一个位移ID += 1;
  return 下一个位移ID;
}

export function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? (jass.GetHandleId(h) as number) : 0) || 0;
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
  return u != null && u !== 0 && (jass.GetUnitState(u, jass.UNIT_STATE_LIFE) as number) > UNIT_ALIVE_LIFE;
}

export function 在可玩区域内(x: number, y: number): boolean {
  return x >= (jass.GetRectMinX(jglobals.bj_mapInitialPlayableArea) as number)
    && y >= (jass.GetRectMinY(jglobals.bj_mapInitialPlayableArea) as number)
    && x <= (jass.GetRectMaxX(jglobals.bj_mapInitialPlayableArea) as number)
    && y <= (jass.GetRectMaxY(jglobals.bj_mapInitialPlayableArea) as number);
}

export function 计算坐标距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return jass.SquareRoot(dx * dx + dy * dy) as number;
}

export function 清理命中记录(位移ID: number): void {
  const 前缀 = `${位移ID}:`;
  for (const key in 命中记录) {
    if (key.indexOf(前缀) === 0) {
      delete 命中记录[key];
    }
  }
}

export function 生成命中键(位移ID: number, 目标单位: any): string {
  return `${位移ID}:${取句柄ID(目标单位)}`;
}

export function 计算每Tick位移(距离: number, 持续时间?: number, 每秒速度?: number): number {
  if (每秒速度 != null && 每秒速度 > 0) {
    return 每秒速度 * TICK_INTERVAL;
  }
  if (持续时间 != null && 持续时间 > 0) {
    return 距离 / (持续时间 / TICK_INTERVAL);
  }
  return 距离;
}

export function 单位已被暂停(单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return jass.IsUnitPaused(单位) === true;
}

export function 播放位移特效(实例: 位移实例): void {
  const 模型 = 实例.位移特效;
  if (模型 == null || 模型 === "") return;
  const 特效 = jass.AddSpecialEffect(模型, jass.GetUnitX(实例.单位) as number, jass.GetUnitY(实例.单位) as number);
  if (特效 != null && 特效 !== 0) {
    jass.DestroyEffect(特效);
  }
}

export function 获取枚举组(): any {
  if (枚举组 == null || 枚举组 === 0) {
    枚举组 = jass.CreateGroup();
  }
  return 枚举组;
}

export function 清空枚举组(): void {
  const g = 获取枚举组();
  while (true) {
    const u = jass.FirstOfGroup(g);
    if (u == null || u === 0) break;
    jass.GroupRemoveUnit(g, u);
  }
}

export function 销毁枚举组(): void {
  if (枚举组 != null && 枚举组 !== 0) {
    jass.DestroyGroup(枚举组);
    枚举组 = null;
  }
}
