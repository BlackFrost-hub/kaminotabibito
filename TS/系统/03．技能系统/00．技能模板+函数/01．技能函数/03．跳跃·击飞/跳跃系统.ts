/** @noSelfInFile */
/**
 * 跳跃系统
 *
 * 参考来源：
 * `JASS/jass复制粘贴/跳跃系统.j`
 *
 * 说明：
 * 1. 这是独立于冲锋/击退的空中位移系统，只参考旧 JASS 的核心思路，不直接照抄地图专用规则。
 * 2. 系统使用中心计时器统一驱动，不为每个跳跃实例额外创建周期 timer。
 * 3. 同一单位同一时刻只保留一个本系统跳跃；新跳跃会覆盖旧跳跃。
 * 4. 默认会检查可玩区域与地形阻挡，所有跳跃都不能穿地形。若地图需要额外限制落点，请传 `落点过滤`。
 *
 * 常用示例：
 * - 跳向目标点：`开始跳跃(单位, { 目标X, 目标Y, 距离, 持续时间, 跳跃高度 })`
 * - 按角度跳跃：`开始定向跳跃(单位, { 角度, 距离, 持续时间, 跳跃高度 })`
 * - 落点过滤：`落点过滤(x, y, 单位, 跳跃ID) => boolean`
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { X_GAFC, X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_GAFC: (x1: number, y1: number, x2: number, y2: number) => number;
  X_IsTerrainWalkable: (x: number, y: number) => boolean;
  X_GetAbleX: () => number;
  X_GetAbleY: () => number;
};

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
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

const BJ_DEGTORAD = jglobals.bj_DEGTORAD ?? 0.017453292519943295;
const TICK_INTERVAL = 0.02;
const CENTER_TIMER_TICKS = 2;
const MAX_SUB_STEP = 31.0;
const WALKABLE_TOLERANCE = 8.0;
const UNIT_ALIVE_LIFE = 0.405;
const DEFAULT_JUMP_EFFECT_MODEL = "";
const CROW_FORM_ABILITY_ID = 1097691750;

export type 跳跃结束原因 = "完成" | "中断" | "死亡" | "阻挡" | "主单位死亡";

type 跳跃结束回调 = (单位: any, 原因: 跳跃结束原因, 跳跃ID: number) => void;
type 跳跃落点过滤 = (x: number, y: number, 单位: any, 跳跃ID: number) => boolean;

export interface 通用跳跃参数 {
  距离: number;
  主单位?: any;
  主单位死亡时中断?: boolean;
  持续时间: number;
  跳跃高度: number;
  朝向跟随跳跃?: boolean;
  跳跃特效?: string;
  落点过滤?: 跳跃落点过滤;
  结束回调?: 跳跃结束回调;
}

export interface 跳跃参数 extends 通用跳跃参数 {
  目标X?: number;
  目标Y?: number;
  角度?: number;
}

interface 跳跃实例 {
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
  朝向跟随跳跃: boolean;
  跳跃特效: string;
  落点过滤?: 跳跃落点过滤;
  结束回调?: 跳跃结束回调;
}

const 活动跳跃列表: 跳跃实例[] = [];
const 跳跃映射: Record<number, 跳跃实例 | undefined> = {};
const 单位当前跳跃: Record<number, number | undefined> = {};
let 单位组快照缓存: any[] = [];

let 下一个跳跃ID = 0;
let 已注册到中心计时器 = false;
let tick计数 = 0;

function 取句柄ID(h: any): number {
  return (h != null && h !== 0 ? GetHandleId(h) : 0) || 0;
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

function 单位存活(u: any): boolean {
  return u != null && u !== 0 && GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
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
  return jass.SquareRoot(dx * dx + dy * dy) as number;
}

function 计算每tick位移(距离: number, 持续时间: number): number {
  if (持续时间 <= 0) return 距离;
  return 距离 / (持续时间 / TICK_INTERVAL);
}

function 确保单位可设置飞行高度(单位: any): void {
  UnitAddAbility(单位, CROW_FORM_ABILITY_ID);
  UnitRemoveAbility(单位, CROW_FORM_ABILITY_ID);
}

function 限制进度(v: number): number {
  if (v <= 0) return 0;
  if (v >= 1) return 1;
  return v;
}

function 计算抛物线高度(进度: number, 最大高度: number): number {
  const t = 限制进度(进度);
  return 4.0 * 最大高度 * t * (1.0 - t);
}

function 播放跳跃特效(实例: 跳跃实例): void {
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

function 注册到中心计时器(): void {
  if (已注册到中心计时器) return;
  已注册到中心计时器 = true;
  onTick10ms(on跳跃系统Tick);
}

function 从中心计时器注销(): void {
  if (!已注册到中心计时器) return;
  已注册到中心计时器 = false;
  offTick10ms(on跳跃系统Tick);
}

function 尝试收尾中心计时器(): void {
  if (活动跳跃列表.length !== 0) return;
  tick计数 = 0;
  从中心计时器注销();
}

function 内部移除跳跃(实例: 跳跃实例): void {
  const 跳跃ID = 实例.id;
  const 单位ID = 实例.单位ID;

  delete 跳跃映射[跳跃ID];
  if (单位当前跳跃[单位ID] === 跳跃ID) {
    delete 单位当前跳跃[单位ID];
  }

  const idx = 实例.listIndex;
  const lastIdx = 活动跳跃列表.length - 1;
  if (idx !== lastIdx) {
    const last = 活动跳跃列表[lastIdx];
    活动跳跃列表[idx] = last;
    last.listIndex = idx;
  }
  活动跳跃列表.pop();
  尝试收尾中心计时器();
}

function 结束跳跃实例(实例: 跳跃实例, 原因: 跳跃结束原因): void {
  if (跳跃映射[实例.id] !== 实例) return;

  const 单位 = 实例.单位;
  const 跳跃ID = 实例.id;
  const 结束回调 = 实例.结束回调;

  if (单位 != null && 单位 !== 0 && 实例.上次附加高度 !== 0) {
    const 当前高度 = GetUnitFlyHeight(单位);
    SetUnitFlyHeight(单位, 当前高度 - 实例.上次附加高度, 0);
    实例.上次附加高度 = 0;
  }

  内部移除跳跃(实例);

  if (typeof 结束回调 === "function") {
    结束回调(单位, 原因, 跳跃ID);
  }
}

function 结束跳跃ID(跳跃ID: number, 原因: 跳跃结束原因): boolean {
  const 实例 = 跳跃映射[跳跃ID];
  if (!实例) return false;
  结束跳跃实例(实例, 原因);
  return true;
}

function 尝试移动一步(
  实例: 跳跃实例,
  位移距离: number
): { 停止: boolean; 原因?: 跳跃结束原因 } {
  const 单位 = 实例.单位;
  const 当前X = GetUnitX(单位);
  const 当前Y = GetUnitY(单位);
  const 弧度 = 实例.角度 * BJ_DEGTORAD;
  const 新X = 当前X + 位移距离 * Cos(弧度);
  const 新Y = 当前Y + 位移距离 * Sin(弧度);

  if (!在可玩区域内(新X, 新Y)) {
    return { 停止: true, 原因: "阻挡" };
  }

  if (!X_IsTerrainWalkable(新X, 新Y)) {
    const 可通行X = X_GetAbleX();
    const 可通行Y = X_GetAbleY();
    const ableDist = 计算坐标距离(新X, 新Y, 可通行X, 可通行Y);
    if (ableDist > WALKABLE_TOLERANCE) {
      return { 停止: true, 原因: "阻挡" };
    }
  }

  const 落点过滤 = 实例.落点过滤;
  if (typeof 落点过滤 === "function" && !落点过滤(新X, 新Y, 单位, 实例.id)) {
    return { 停止: true, 原因: "阻挡" };
  }

  if (实例.朝向跟随跳跃) {
    SetUnitFacing(单位, 实例.角度);
  }

  SetUnitX(单位, 新X);
  SetUnitY(单位, 新Y);
  实例.已移动 += 位移距离;

  const 进度 = 实例.总距离 > 0 ? (实例.已移动 / 实例.总距离) : 1;
  const 新附加高度 = 计算抛物线高度(进度, 实例.跳跃高度);
  const 当前高度 = GetUnitFlyHeight(单位);
  SetUnitFlyHeight(单位, 当前高度 - 实例.上次附加高度 + 新附加高度, 0);
  实例.上次附加高度 = 新附加高度;

  if (实例.已移动 >= 实例.总距离) {
    return { 停止: true, 原因: "完成" };
  }

  return { 停止: false };
}

function 推进一步(实例: 跳跃实例): { 停止: boolean; 原因?: 跳跃结束原因 } {
  const 起始已移动 = 实例.已移动;
  const 剩余距离 = 实例.总距离 - 实例.已移动;
  if (剩余距离 <= 0) {
    return { 停止: true, 原因: "完成" };
  }

  let 本tick位移 = 实例.每tick位移;
  if (本tick位移 > 剩余距离) {
    本tick位移 = 剩余距离;
  }
  if (本tick位移 <= 0) {
    return { 停止: true, 原因: "完成" };
  }

  let 剩余步长 = 本tick位移;
  while (剩余步长 > 0) {
    const 子步长 = 剩余步长 > MAX_SUB_STEP ? MAX_SUB_STEP : 剩余步长;
    const 结果 = 尝试移动一步(实例, 子步长);
    if (结果.停止) {
      if (实例.已移动 > 起始已移动) {
        播放跳跃特效(实例);
      }
      return 结果;
    }
    if (跳跃映射[实例.id] !== 实例) {
      return { 停止: true, 原因: "中断" };
    }
    剩余步长 -= 子步长;
  }

  if (实例.已移动 > 起始已移动) {
    播放跳跃特效(实例);
  }
  return { 停止: false };
}

function on跳跃系统Tick(): void {
  tick计数 += 1;
  if (tick计数 < CENTER_TIMER_TICKS) return;
  tick计数 = 0;

  let i = 0;
  while (i < 活动跳跃列表.length) {
    const 实例 = 活动跳跃列表[i];
    if (跳跃映射[实例.id] !== 实例) {
      i += 1;
      continue;
    }

    if (!单位存活(实例.单位)) {
      结束跳跃实例(实例, "死亡");
      continue;
    }

    if (实例.主单位死亡时中断 && 实例.主单位 != null && 实例.主单位 !== 0 && !单位存活(实例.主单位)) {
      结束跳跃实例(实例, "主单位死亡");
      continue;
    }

    if (IsUnitPaused(实例.单位) === true) {
      i += 1;
      continue;
    }

    const 结果 = 推进一步(实例);
    if (结果.停止) {
      结束跳跃实例(实例, 结果.原因 ?? "完成");
      continue;
    }

    i += 1;
  }
}

function 解析跳跃角度(单位: any, 参数: 跳跃参数): number | null {
  if (参数.角度 != null) return 参数.角度;
  if (参数.目标X != null && 参数.目标Y != null) {
    return X_GAFC(
      GetUnitX(单位),
      GetUnitY(单位),
      参数.目标X,
      参数.目标Y
    );
  }
  return null;
}

function 创建跳跃实例(单位: any, 角度: number, 参数: 通用跳跃参数): number {
  if (!单位存活(单位)) return 0;
  if (参数.距离 == null || 参数.距离 <= 0) return 0;
  if (参数.持续时间 == null || 参数.持续时间 <= 0) return 0;

  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return 0;

  停止单位跳跃(单位, "中断");
  确保单位可设置飞行高度(单位);

  const 每tick位移 = 计算每tick位移(参数.距离, 参数.持续时间);
  if (每tick位移 <= 0) return 0;

  const 跳跃ID = ++下一个跳跃ID;
  const 实例: 跳跃实例 = {
    id: 跳跃ID,
    listIndex: 活动跳跃列表.length,
    单位,
    单位ID,
    主单位: 参数.主单位,
    主单位死亡时中断: 参数.主单位死亡时中断 !== false,
    角度,
    总距离: 参数.距离,
    已移动: 0,
    每tick位移,
    跳跃高度: 参数.跳跃高度 ?? 0,
    上次附加高度: 0,
    朝向跟随跳跃: 参数.朝向跟随跳跃 === true,
    跳跃特效: 参数.跳跃特效 ?? DEFAULT_JUMP_EFFECT_MODEL,
    落点过滤: 参数.落点过滤,
    结束回调: 参数.结束回调,
  };

  跳跃映射[跳跃ID] = 实例;
  单位当前跳跃[单位ID] = 跳跃ID;
  活动跳跃列表.push(实例);
  注册到中心计时器();
  return 跳跃ID;
}

export function 开始跳跃(单位: any, 参数: 跳跃参数): number {
  const 角度 = 解析跳跃角度(单位, 参数);
  if (角度 == null) return 0;
  return 创建跳跃实例(单位, 角度, 参数);
}

export function 开始定向跳跃(单位: any, 参数: 跳跃参数): number {
  return 开始跳跃(单位, 参数);
}

export function 开始单位组跳跃(单位组: any, 参数: 跳跃参数): number[] {
  const 单位列表 = 快照单位组(单位组);
  const 结果: number[] = [];
  for (const 单位 of 单位列表) {
    const 跳跃ID = 开始跳跃(单位, 参数);
    if (跳跃ID > 0) {
      结果.push(跳跃ID);
    }
  }
  return 结果;
}

export function 开始单位组定向跳跃(单位组: any, 参数: 跳跃参数): number[] {
  const 单位列表 = 快照单位组(单位组);
  const 结果: number[] = [];
  for (const 单位 of 单位列表) {
    const 跳跃ID = 开始定向跳跃(单位, 参数);
    if (跳跃ID > 0) {
      结果.push(跳跃ID);
    }
  }
  return 结果;
}

export function 停止跳跃(跳跃ID: number, 原因: 跳跃结束原因 = "中断"): boolean {
  return 结束跳跃ID(跳跃ID, 原因);
}

export function 停止单位跳跃(单位: any, 原因: 跳跃结束原因 = "中断"): boolean {
  const 跳跃ID = 单位当前跳跃[取句柄ID(单位)];
  if (!跳跃ID) return false;
  return 结束跳跃ID(跳跃ID, 原因);
}

export function 单位是否正在跳跃(单位: any): boolean {
  const 跳跃ID = 单位当前跳跃[取句柄ID(单位)];
  return 跳跃ID != null && 跳跃映射[跳跃ID] != null;
}

export function 获取单位当前跳跃ID(单位: any): number {
  return 单位当前跳跃[取句柄ID(单位)] ?? 0;
}

export function 获取活跃跳跃数量(): number {
  return 活动跳跃列表.length;
}

export {};
