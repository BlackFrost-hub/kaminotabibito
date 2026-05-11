/** @noSelfInFile */
/**
 * 牵引系统 - 共享类型、常量与工具函数
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

export const GetHandleId = jass["GetHandleId"] as (h: any) => number;
export const GetUnitX = jass["GetUnitX"] as (u: any) => number;
export const GetUnitY = jass["GetUnitY"] as (u: any) => number;
export const GetUnitTypeId = jass["GetUnitTypeId"] as (u: any) => number;
export const GetUnitState = jass["GetUnitState"] as (u: any, state: any) => number;
export const IsUnitType = jass["IsUnitType"] as (u: any, unitType: any) => boolean;
export const GetRectMinX = jass["GetRectMinX"] as (r: any) => number;
export const GetRectMinY = jass["GetRectMinY"] as (r: any) => number;
export const GetRectMaxX = jass["GetRectMaxX"] as (r: any) => number;
export const GetRectMaxY = jass["GetRectMaxY"] as (r: any) => number;
export const SetUnitX = jass["SetUnitX"] as (u: any, x: number) => void;
export const SetUnitY = jass["SetUnitY"] as (u: any, y: number) => void;
export const SetUnitFacing = jass["SetUnitFacing"] as (u: any, facing: number) => void;
export const PauseUnit = jass["PauseUnit"] as (u: any, flag: boolean) => void;
export const IsUnitPaused = jass["IsUnitPaused"] as (u: any) => boolean;
export const SetUnitPathing = jass["SetUnitPathing"] as (u: any, flag: boolean) => void;
export const SquareRoot = jass["SquareRoot"] as (v: number) => number;
export const Atan2 = jass["Atan2"] as (y: number, x: number) => number;
export const Cos = jass["Cos"] as (radians: number) => number;
export const Sin = jass["Sin"] as (radians: number) => number;
export const R2I = jass["R2I"] as (value: number) => number;
export const bj_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;
export const bj_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
export const ForGroup = jass["ForGroup"] as (whichGroup: any, callback: () => void) => void;
export const GetEnumUnit = jass["GetEnumUnit"] as () => any;

export const AddLightning = jass["AddLightning"] as ((codeName: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => any) | undefined;
export const MoveLightning = jass["MoveLightning"] as ((whichLightning: any, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => boolean) | undefined;
export const MoveLightningEx = jass["MoveLightningEx"] as ((whichLightning: any, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number) => boolean) | undefined;
export const DestroyLightning = jass["DestroyLightning"] as ((whichLightning: any) => boolean) | undefined;

export const { X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_IsTerrainWalkable: (x: number, y: number) => boolean;
  X_GetAbleX: () => number;
  X_GetAbleY: () => number;
};

export const TICK_INTERVAL = 0.02;
export const CENTER_TIMER_TICKS = 2;
export const MAX_SUB_STEP = 31.0;
export const WALKABLE_TOLERANCE = 8.0;
export const UNIT_ALIVE_LIFE = 0.405;

export const 闪电效果代码_闪电链主闪电 = "CLPB";
export const 闪电效果代码_闪电链次闪电 = "CLSB";
export const 闪电效果代码_生命汲取 = "DRAB";
export const 闪电效果代码_生命汲取生命 = "DRAL";
export const 闪电效果代码_魔力汲取 = "DRAM";
export const 闪电效果代码_叉状闪电 = "FORK";
export const 闪电效果代码_治疗波主闪电 = "HWPB";
export const 闪电效果代码_治疗波次闪电 = "HWSB";
export const 闪电效果代码_闪电攻击 = "CHIM";
export const 闪电效果代码_魔法束缚 = "LEAS";
export const 闪电效果代码_灵魂锁链 = "SPLK";
export const 闪电效果代码_牵引绳子 = "ROP";
export const 闪电效果代码_魔力之焰 = "MFPB";
export const 闪电效果代码_死亡之指 = "AFOD";

export const DEFAULT_LIGHTNING_CODE = 闪电效果代码_闪电链主闪电;

export type 牵引结束原因 = "完成" | "中断" | "死亡" | "阻挡" | "中心失效" | "主单位死亡" | "超距断开";
export type 牵引结束回调 = (单位: any, 原因: 牵引结束原因, 牵引ID: number) => void;
export type 牵引目标筛选器 = (单位: any) => boolean;
export type 牵引到达回调 = (单位: any, 牵引ID: number) => void;
export type 牵引开始回调 = (单位: any, 牵引ID: number) => void;

export interface 牵引参数 {
  中心单位?: any;
  中心X?: number;
  中心Y?: number;
  主单位?: any;
  主单位死亡时中断?: boolean;
  目标筛选?: 牵引目标筛选器;
  持续时间?: number;
  每秒速度?: number;
  每Tick位移?: number;
  最小距离?: number;
  到达距离?: number;
  最大牵引距离?: number;
  到达后结束?: boolean;
  到达回调?: 牵引到达回调;
  检查地形?: boolean;
  禁用碰撞?: boolean;
  暂停单位?: boolean;
  朝向跟随牵引?: boolean;
  外部暂停时中断?: boolean;
  闪电效果代码?: string;
  闪电高度?: number;
  启用闪电效果?: boolean;
  结束回调?: 牵引结束回调;
  开始回调?: 牵引开始回调;
}

export interface 牵引实例 {
  id: number;
  listIndex: number;
  单位: any;
  单位ID: number;
  主单位?: any;
  主单位死亡时中断: boolean;
  中心单位?: any;
  中心X: number;
  中心Y: number;
  每Tick位移: number;
  持续Tick数: number;
  已运行Tick数: number;
  最小距离: number;
  到达距离: number;
  最大牵引距离: number;
  到达后结束?: boolean;
  到达回调?: 牵引到达回调;
  已触发到达回调: boolean;
  检查地形: boolean;
  禁用碰撞: boolean;
  暂停单位: boolean;
  朝向跟随牵引: boolean;
  外部暂停时中断: boolean;
  闪电效果代码: string;
  闪电高度: number;
  启用闪电效果: boolean;
  闪电句柄?: any;
  结束回调?: 牵引结束回调;
  开始回调?: 牵引开始回调;
}

export let 单位组快照缓存: any[] = [];

export const 活动牵引列表: 牵引实例[] = [];
export const 牵引映射: Record<number, 牵引实例 | undefined> = {};
export const 单位当前牵引: Record<number, number | undefined> = {};
export let 下一个牵引ID = 0;

export function 推进下一个牵引ID(this: void): number {
  下一个牵引ID += 1;
  return 下一个牵引ID;
}

export function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
}

export function 单位存活(u: any): boolean {
  if (u == null || u === 0) return false;
  if (GetUnitTypeId(u) === 0) return false;
  if (IsUnitType(u, jass.UNIT_TYPE_DEAD) === true) return false;
  return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
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
  return SquareRoot(dx * dx + dy * dy);
}

export function 计算朝向角度(x1: number, y1: number, x2: number, y2: number): number {
  return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG;
}

export function 收集单位组成员(): void {
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

export function 计算每Tick位移(参数: 牵引参数): number {
  if (参数.每Tick位移 != null && 参数.每Tick位移 > 0) return 参数.每Tick位移;
  if (参数.每秒速度 != null && 参数.每秒速度 > 0) return 参数.每秒速度 * TICK_INTERVAL;
  return 10;
}

export function 计算持续Tick数(参数: 牵引参数): number {
  if (参数.持续时间 != null && 参数.持续时间 > 0) {
    const ticks = R2I(参数.持续时间 / TICK_INTERVAL + 0.0001);
    return ticks > 0 ? ticks : 1;
  }
  return 50;
}

export function 解析中心坐标(参数: 牵引参数): { x: number; y: number } | null {
  if (参数.中心单位 != null && 参数.中心单位 !== 0) {
    return { x: GetUnitX(参数.中心单位), y: GetUnitY(参数.中心单位) };
  }
  if (参数.中心X != null && 参数.中心Y != null) {
    return { x: 参数.中心X, y: 参数.中心Y };
  }
  return null;
}
