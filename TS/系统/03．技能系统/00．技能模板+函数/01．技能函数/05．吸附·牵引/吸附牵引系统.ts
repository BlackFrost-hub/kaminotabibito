/** @noSelfInFile */
/**
 * 吸附·牵引系统
 *
 * 说明：
 * 1. 独立于冲锋·击退、跳跃·击飞的持续位移系统。
 * 2. 适合做吸附、拖拽、牵引、聚怪。
 * 3. 开始单位组牵引时会先快照 group，外部 group 可立刻销毁。
 * 4. 默认附带持续闪电效果，便于地图直接测试。
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_IsTerrainWalkable: (x: number, y: number) => boolean;
  X_GetAbleX: () => number;
  X_GetAbleY: () => number;
};
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};

const GetHandleId = jass["GetHandleId"] as (h: any) => number;
const GetUnitX = jass["GetUnitX"] as (u: any) => number;
const GetUnitY = jass["GetUnitY"] as (u: any) => number;
const GetUnitTypeId = jass["GetUnitTypeId"] as (u: any) => number;
const GetUnitState = jass["GetUnitState"] as (u: any, state: any) => number;
const IsUnitType = jass["IsUnitType"] as (u: any, unitType: any) => boolean;
const GetRectMinX = jass["GetRectMinX"] as (r: any) => number;
const GetRectMinY = jass["GetRectMinY"] as (r: any) => number;
const GetRectMaxX = jass["GetRectMaxX"] as (r: any) => number;
const GetRectMaxY = jass["GetRectMaxY"] as (r: any) => number;
const SetUnitX = jass["SetUnitX"] as (u: any, x: number) => void;
const SetUnitY = jass["SetUnitY"] as (u: any, y: number) => void;
const SetUnitFacing = jass["SetUnitFacing"] as (u: any, facing: number) => void;
const PauseUnit = jass["PauseUnit"] as (u: any, flag: boolean) => void;
const IsUnitPaused = jass["IsUnitPaused"] as (u: any) => boolean;
const SetUnitPathing = jass["SetUnitPathing"] as (u: any, flag: boolean) => void;
const SquareRoot = jass["SquareRoot"] as (v: number) => number;
const Atan2 = jass["Atan2"] as (y: number, x: number) => number;
const Cos = jass["Cos"] as (radians: number) => number;
const Sin = jass["Sin"] as (radians: number) => number;
const R2I = jass["R2I"] as (value: number) => number;
const bj_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;
const bj_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
const ForGroup = jass["ForGroup"] as (whichGroup: any, callback: () => void) => void;
const GetEnumUnit = jass["GetEnumUnit"] as () => any;

const AddLightning = jass["AddLightning"] as ((codeName: string, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => any) | undefined;
const MoveLightning = jass["MoveLightning"] as ((whichLightning: any, checkVisibility: boolean, x1: number, y1: number, x2: number, y2: number) => boolean) | undefined;
const MoveLightningEx = jass["MoveLightningEx"] as ((whichLightning: any, checkVisibility: boolean, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number) => boolean) | undefined;
const DestroyLightning = jass["DestroyLightning"] as ((whichLightning: any) => boolean) | undefined;

const TICK_INTERVAL = 0.02;
const CENTER_TIMER_TICKS = 2;
const MAX_SUB_STEP = 31.0;
const WALKABLE_TOLERANCE = 8.0;
const UNIT_ALIVE_LIFE = 0.405;
/**
 * 常用闪电效果代码速查：
 * - CLPB：闪电链主闪电
 * - CLSB：闪电链次闪电
 * - DRAB：生命汲取
 * - DRAL：生命汲取（生命）
 * - DRAM：魔力汲取
 * - FORK：叉状闪电
 * - HWPB：治疗波主闪电
 * - HWSB：治疗波次闪电
 * - CHIM：闪电攻击
 * - LEAS：魔法束缚
 * - SPLK：灵魂锁链
 * - ROP：牵引绳子
 * - MFPB：魔力之焰
 * - AFOD：死亡之指
 *
 * 其他技能如果需要改闪电表现，优先直接传 `闪电效果代码`。
 */
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

const DEFAULT_LIGHTNING_CODE = 闪电效果代码_闪电链主闪电;

export type 牵引结束原因 = "完成" | "中断" | "死亡" | "阻挡" | "中心失效" | "主单位死亡";
type 牵引结束回调 = (单位: any, 原因: 牵引结束原因, 牵引ID: number) => void;
type 牵引目标筛选器 = (单位: any) => boolean;
type 牵引到达回调 = (单位: any, 牵引ID: number) => void;
type 牵引开始回调 = (单位: any, 牵引ID: number) => void;

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

interface 牵引实例 {
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

const 活动牵引列表: 牵引实例[] = [];
const 牵引映射: Record<number, 牵引实例 | undefined> = {};
const 单位当前牵引: Record<number, number | undefined> = {};
let 单位组快照缓存: any[] = [];
let 下一个牵引ID = 0;
let 已注册到中心计时器 = false;
let tick计数 = 0;

function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
}

function 单位存活(u: any): boolean {
  if (u == null || u === 0) return false;
  if (GetUnitTypeId(u) === 0) return false;
  if (IsUnitType(u, jass.UNIT_TYPE_DEAD) === true) return false;
  return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 在可玩区域内(x: number, y: number): boolean {
  return x >= GetRectMinX(jglobals.bj_mapInitialPlayableArea)
    && y >= GetRectMinY(jglobals.bj_mapInitialPlayableArea)
    && x <= GetRectMaxX(jglobals.bj_mapInitialPlayableArea)
    && y <= GetRectMaxY(jglobals.bj_mapInitialPlayableArea);
}

function 计算坐标距离(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

function 计算朝向角度(x1: number, y1: number, x2: number, y2: number): number {
  return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG;
}

function 收集单位组成员(): void {
  const 单位 = GetEnumUnit();
  if (单位 != null && 单位 !== 0) {
    单位组快照缓存.push(单位);
  }
}

function 快照单位组(单位组: any): any[] {
  if (单位组 == null || 单位组 === 0) return [];
  单位组快照缓存 = [];
  ForGroup(单位组, 收集单位组成员);
  const 结果 = 单位组快照缓存;
  单位组快照缓存 = [];
  return 结果;
}

function 计算每Tick位移(参数: 牵引参数): number {
  if (参数.每Tick位移 != null && 参数.每Tick位移 > 0) return 参数.每Tick位移;
  if (参数.每秒速度 != null && 参数.每秒速度 > 0) return 参数.每秒速度 * TICK_INTERVAL;
  return 10;
}

function 计算持续Tick数(参数: 牵引参数): number {
  if (参数.持续时间 != null && 参数.持续时间 > 0) {
    const ticks = R2I(参数.持续时间 / TICK_INTERVAL + 0.0001);
    return ticks > 0 ? ticks : 1;
  }
  return 50;
}

function 尝试触发到达回调(实例: 牵引实例, 距离中心: number): boolean {
  if (实例.已触发到达回调 || 实例.到达距离 <= 0) return false;
  if (距离中心 > 实例.到达距离) return false;

  实例.已触发到达回调 = true;
  if (typeof 实例.到达回调 === "function") {
    实例.到达回调(实例.单位, 实例.id);
  }
  return 实例.到达后结束 === true;
}

function 注册到中心计时器(): void {
  if (已注册到中心计时器) return;
  已注册到中心计时器 = true;
  onTick10ms(on吸附牵引系统Tick);
}

function 从中心计时器注销(): void {
  if (!已注册到中心计时器) return;
  已注册到中心计时器 = false;
  offTick10ms(on吸附牵引系统Tick);
}

function 尝试收尾中心计时器(): void {
  if (活动牵引列表.length !== 0) return;
  tick计数 = 0;
  从中心计时器注销();
}

function 销毁闪电(实例: 牵引实例): void {
  const 闪电 = 实例.闪电句柄;
  if (闪电 != null && 闪电 !== 0 && typeof DestroyLightning === "function") {
    DestroyLightning(闪电);
  }
  实例.闪电句柄 = undefined;
}

function 更新闪电(实例: 牵引实例): void {
  if (!实例.启用闪电效果 || typeof AddLightning !== "function") return;

  const 单位X = GetUnitX(实例.单位);
  const 单位Y = GetUnitY(实例.单位);
  const 中心X = 实例.中心X;
  const 中心Y = 实例.中心Y;

  if (实例.闪电句柄 == null || 实例.闪电句柄 === 0) {
    实例.闪电句柄 = AddLightning(实例.闪电效果代码, false, 单位X, 单位Y, 中心X, 中心Y);
    return;
  }

  if (typeof MoveLightningEx === "function") {
    MoveLightningEx(实例.闪电句柄, false, 单位X, 单位Y, 实例.闪电高度, 中心X, 中心Y, 实例.闪电高度);
  } else if (typeof MoveLightning === "function") {
    MoveLightning(实例.闪电句柄, false, 单位X, 单位Y, 中心X, 中心Y);
  }
}

function 内部移除牵引(实例: 牵引实例): void {
  delete 牵引映射[实例.id];
  if (单位当前牵引[实例.单位ID] === 实例.id) {
    delete 单位当前牵引[实例.单位ID];
  }

  销毁闪电(实例);

  const idx = 实例.listIndex;
  const lastIdx = 活动牵引列表.length - 1;
  if (idx !== lastIdx) {
    const last = 活动牵引列表[lastIdx];
    活动牵引列表[idx] = last;
    last.listIndex = idx;
  }
  活动牵引列表.pop();
  尝试收尾中心计时器();
}

function 结束牵引实例(实例: 牵引实例, 原因: 牵引结束原因): void {
  if (牵引映射[实例.id] !== 实例) return;

  if (实例.禁用碰撞) {
    SetUnitPathing(实例.单位, true);
  }
  if (实例.暂停单位) {
    PauseUnit(实例.单位, false);
  }

  const 单位 = 实例.单位;
  const 牵引ID = 实例.id;
  const 结束回调 = 实例.结束回调;

  内部移除牵引(实例);

  if (typeof 结束回调 === "function") {
    结束回调(单位, 原因, 牵引ID);
  }
}

function 结束牵引ID(牵引ID: number, 原因: 牵引结束原因): boolean {
  const 实例 = 牵引映射[牵引ID];
  if (!实例) return false;
  结束牵引实例(实例, 原因);
  return true;
}

function 解析中心坐标(参数: 牵引参数): { x: number; y: number } | null {
  if (参数.中心单位 != null && 参数.中心单位 !== 0) {
    return { x: GetUnitX(参数.中心单位), y: GetUnitY(参数.中心单位) };
  }
  if (参数.中心X != null && 参数.中心Y != null) {
    return { x: 参数.中心X, y: 参数.中心Y };
  }
  return null;
}

function 尝试移动一步(实例: 牵引实例, 位移距离: number): { 停止: boolean; 原因?: 牵引结束原因 } {
  const 当前X = GetUnitX(实例.单位);
  const 当前Y = GetUnitY(实例.单位);
  const 距离中心 = 计算坐标距离(当前X, 当前Y, 实例.中心X, 实例.中心Y);
  if (尝试触发到达回调(实例, 距离中心)) {
    return { 停止: true, 原因: "完成" };
  }
  if (距离中心 <= 实例.最小距离) {
    return { 停止: true, 原因: "完成" };
  }

  const 实际位移 = 位移距离 >= 距离中心 - 实例.最小距离 ? 距离中心 - 实例.最小距离 : 位移距离;
  if (实际位移 <= 0) {
    return { 停止: true, 原因: "完成" };
  }

  const 角度 = 计算朝向角度(当前X, 当前Y, 实例.中心X, 实例.中心Y);
  const 弧度 = 角度 * bj_DEGTORAD;
  const 新X = 当前X + 实际位移 * Cos(弧度);
  const 新Y = 当前Y + 实际位移 * Sin(弧度);

  if (!在可玩区域内(新X, 新Y)) {
    return { 停止: true, 原因: "阻挡" };
  }

  if (实例.检查地形 && !X_IsTerrainWalkable(新X, 新Y)) {
    const ableDist = 计算坐标距离(新X, 新Y, X_GetAbleX(), X_GetAbleY());
    if (ableDist > WALKABLE_TOLERANCE) {
      return { 停止: true, 原因: "阻挡" };
    }
  }

  SetUnitX(实例.单位, 新X);
  SetUnitY(实例.单位, 新Y);
  if (实例.朝向跟随牵引) {
    SetUnitFacing(实例.单位, 角度);
  }
  const 新距离中心 = 计算坐标距离(新X, 新Y, 实例.中心X, 实例.中心Y);
  if (尝试触发到达回调(实例, 新距离中心)) {
    return { 停止: true, 原因: "完成" };
  }
  return { 停止: false };
}

function 推进牵引实例(实例: 牵引实例): void {
  if (!单位存活(实例.单位)) {
    结束牵引实例(实例, "死亡");
    return;
  }
  if (实例.主单位死亡时中断 && 实例.主单位 != null && 实例.主单位 !== 0 && !单位存活(实例.主单位)) {
    结束牵引实例(实例, "主单位死亡");
    return;
  }
  if (实例.中心单位 != null && 实例.中心单位 !== 0) {
    if (!单位存活(实例.中心单位)) {
      结束牵引实例(实例, "中心失效");
      return;
    }
    实例.中心X = GetUnitX(实例.中心单位);
    实例.中心Y = GetUnitY(实例.中心单位);
  }
  if (实例.外部暂停时中断 && !实例.暂停单位 && IsUnitPaused(实例.单位) === true) {
    结束牵引实例(实例, "中断");
    return;
  }

  实例.已运行Tick数 += 1;
  if (实例.已运行Tick数 > 实例.持续Tick数) {
    结束牵引实例(实例, "完成");
    return;
  }

  let 剩余位移 = 实例.每Tick位移;
  while (剩余位移 > 0) {
    const 子步长 = 剩余位移 > MAX_SUB_STEP ? MAX_SUB_STEP : 剩余位移;
    const 结果 = 尝试移动一步(实例, 子步长);
    if (结果.停止) {
      结束牵引实例(实例, 结果.原因 ?? "完成");
      return;
    }
    剩余位移 -= 子步长;
  }

  更新闪电(实例);
}

function on吸附牵引系统Tick(): void {
  tick计数 += 1;
  if (tick计数 < CENTER_TIMER_TICKS) return;
  tick计数 = 0;

  let i = 0;
  while (i < 活动牵引列表.length) {
    const 实例 = 活动牵引列表[i];
    推进牵引实例(实例);
    if (活动牵引列表[i] === 实例) {
      i += 1;
    }
  }
}

function 创建牵引实例(单位: any, 参数: 牵引参数): 牵引实例 | null {
  if (!单位存活(单位)) return null;
  if (typeof 参数.目标筛选 === "function" && 参数.目标筛选(单位) !== true) return null;

  const 主单位 = 参数.主单位 ?? 参数.中心单位;
  const 中心坐标 = 解析中心坐标(参数);
  if (!中心坐标) return null;

  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return null;

  const 旧牵引ID = 单位当前牵引[单位ID];
  if (旧牵引ID != null) {
    结束牵引ID(旧牵引ID, "中断");
  }

  const 实例: 牵引实例 = {
    id: ++下一个牵引ID,
    listIndex: 活动牵引列表.length,
    单位,
    单位ID,
    主单位,
    主单位死亡时中断: 参数.主单位死亡时中断 !== false,
    中心单位: 参数.中心单位,
    中心X: 中心坐标.x,
    中心Y: 中心坐标.y,
    每Tick位移: 计算每Tick位移(参数),
    持续Tick数: 计算持续Tick数(参数),
    已运行Tick数: 0,
    最小距离: 参数.最小距离 != null ? 参数.最小距离 : 96,
    到达距离: 参数.到达距离 != null ? 参数.到达距离 : 0,
    到达后结束: 参数.到达后结束,
    到达回调: 参数.到达回调,
    已触发到达回调: false,
    检查地形: 参数.检查地形 !== false,
    禁用碰撞: 参数.禁用碰撞 === true,
    暂停单位: 参数.暂停单位 === true,
    朝向跟随牵引: 参数.朝向跟随牵引 !== false,
    外部暂停时中断: 参数.外部暂停时中断 === true,
    闪电效果代码: 参数.闪电效果代码 && 参数.闪电效果代码 !== "" ? 参数.闪电效果代码 : DEFAULT_LIGHTNING_CODE,
    闪电高度: 参数.闪电高度 != null ? 参数.闪电高度 : 60,
    启用闪电效果: 参数.启用闪电效果 !== false,
    结束回调: 参数.结束回调,
    开始回调: 参数.开始回调,
  };

  if (实例.禁用碰撞) {
    SetUnitPathing(单位, false);
  }
  if (实例.暂停单位) {
    PauseUnit(单位, true);
  }

  活动牵引列表.push(实例);
  牵引映射[实例.id] = 实例;
  单位当前牵引[单位ID] = 实例.id;
  更新闪电(实例);
  注册到中心计时器();

  if (typeof 参数.开始回调 === "function") {
    参数.开始回调(单位, 实例.id);
  }

  return 实例;
}

export function 开始牵引(单位: any, 参数: 牵引参数): number {
  const 实例 = 创建牵引实例(单位, 参数);
  return 实例 ? 实例.id : 0;
}

export function 开始单位组牵引(单位组: any, 参数: 牵引参数): number[] {
  const 结果: number[] = [];
  for (const 单位 of 快照单位组(单位组)) {
    const 牵引ID = 开始牵引(单位, 参数);
    if (牵引ID > 0) {
      结果.push(牵引ID);
    }
  }
  return 结果;
}

export function 停止牵引(牵引ID: number): boolean {
  return 结束牵引ID(牵引ID, "中断");
}

export function 停止单位牵引(单位: any): boolean {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return false;
  const 牵引ID = 单位当前牵引[单位ID];
  if (牵引ID == null) return false;
  return 停止牵引(牵引ID);
}

export function 单位是否正在被牵引(单位: any): boolean {
  const 单位ID = 取句柄ID(单位);
  return 单位ID !== 0 && 单位当前牵引[单位ID] != null;
}

export function 获取单位当前牵引ID(单位: any): number {
  const 单位ID = 取句柄ID(单位);
  return 单位ID !== 0 ? (单位当前牵引[单位ID] ?? 0) : 0;
}

export function 获取活跃牵引数量(): number {
  return 活动牵引列表.length;
}

export {};
