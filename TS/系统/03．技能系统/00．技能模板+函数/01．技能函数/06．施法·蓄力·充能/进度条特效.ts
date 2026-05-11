/** @noSelfInFile */
/**
 * 进度条特效模块（施法进度条）
 *
 * 说明：
 * 1. 不使用 `特效绑定系统.ts`
 * 2. 不使用 `AddSpecialEffectTarget` / `AddSpecialEffectTargetUnitBJ`
 * 3. 当前实现改为直接创建物编单位 `e011`（父 id: `ewsp`）
 * 4. 进度条颜色、动画速度、动画序号都通过单位接口控制
 * 5. 销毁时直接 `RemoveUnit`，不是延迟特效回收
 */

const jass = require("jass.common") as any;

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 调试模块名 = "进度条特效";
const PROGRESSBAR_UNIT_ID = 1697657137; // 'e011'
const PROGRESSBAR_OWNER_PLAYER_ID = 4;
const DEFAULT_HEIGHT_OFFSET = 275.0;
const DEFAULT_SCALE = 1.0;
const DEFAULT_ANIM_INDEX = 0;
const DEFAULT_COLOR_RGBA = { r: 255, g: 255, b: 0, a: 255 };
const UNIT_ALIVE_LIFE = 0.405;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const Player = jass.Player as (playerId: number) => any;
const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, face: number) => any;
const RemoveUnit = jass.RemoveUnit as (u: any) => void;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (u: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (u: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const SetUnitX = jass.SetUnitX as (u: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (u: any, y: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (u: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (u: any, x: number, y: number, z: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (u: any, scale: number) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (u: any, r: number, g: number, b: number, a: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as ((u: any, index: number) => void) | undefined;

export interface 进度条特效选项 {
  高度偏移?: number;
  缩放?: number;
  动画序号?: number;
  动画速度?: number;
  颜色?: { r: number; g: number; b: number; a: number };
}

interface 进度条特效数据 {
  进度条单位: any;
  跟随单位: any;
  跟随单位ID: number;
  高度偏移: number;
}

const 进度条映射 = new Map<any, 进度条特效数据>();
const 单位进度条映射 = new Map<number, any>();
let 已注册计时器 = false;

function 取句柄ID(h: any): number {
  if (h == null || h === 0) return 0;
  return GetHandleId(h);
}

function 单位存活(u: any): boolean {
  if (u == null || u === 0) return false;
  if (GetUnitTypeId(u) === 0) return false;
  if (IsUnitType(u, jass.UNIT_TYPE_DEAD)) return false;
  return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 裁剪到字节(value: number): number {
  if (value <= 0) return 0;
  if (value >= 255) return 255;
  return jass.R2I(value);
}

function 设置进度条位置(进度条单位: any, 跟随单位: any, 高度偏移: number): void {
  if (!单位存活(进度条单位) || !单位存活(跟随单位)) return;
  SetUnitX(进度条单位, GetUnitX(跟随单位));
  SetUnitY(进度条单位, GetUnitY(跟随单位));
  SetUnitFlyHeight(进度条单位, GetUnitFlyHeight(跟随单位) + 高度偏移, 0);
}

function 立即移除进度条单位(进度条单位: any): void {
  if (进度条单位 == null || 进度条单位 === 0) return;
  if (GetUnitTypeId(进度条单位) === 0) return;
  RemoveUnit(进度条单位);
}

function 更新所有进度条位置(): void {
  for (const [进度条单位, 数据] of 进度条映射) {
    if (!单位存活(数据.跟随单位) || !单位存活(进度条单位)) {
      移除进度条特效(进度条单位);
      continue;
    }
    设置进度条位置(进度条单位, 数据.跟随单位, 数据.高度偏移);
  }

  if (进度条映射.size === 0 && 已注册计时器) {
    已注册计时器 = false;
    offTick10ms(更新所有进度条位置);
  }
}

function 确保注册计时器(): void {
  if (已注册计时器) return;
  已注册计时器 = true;
  onTick10ms(更新所有进度条位置);
}

function 移除进度条特效(进度条单位: any): void {
  if (进度条单位 == null || 进度条单位 === 0) return;

  const 数据 = 进度条映射.get(进度条单位);
  if (数据 != null) {
    单位进度条映射.delete(数据.跟随单位ID);
  }

  进度条映射.delete(进度条单位);
  立即移除进度条单位(进度条单位);
}

export function 创建进度条特效(单位: any, 选项?: 进度条特效选项): any {
  if (!单位存活(单位)) return null;

  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return null;

  const 已有进度条 = 单位进度条映射.get(单位ID);
  if (已有进度条 != null) {
    移除进度条特效(已有进度条);
  }

  const 高度偏移 = 选项?.高度偏移 ?? DEFAULT_HEIGHT_OFFSET;
  const 缩放 = 选项?.缩放 ?? DEFAULT_SCALE;
  const 动画序号 = 选项?.动画序号 ?? DEFAULT_ANIM_INDEX;
  const 动画速度 = 选项?.动画速度;
  const 颜色 = 选项?.颜色 ?? DEFAULT_COLOR_RGBA;
  const x = GetUnitX(单位);
  const y = GetUnitY(单位);
  const owner = Player(PROGRESSBAR_OWNER_PLAYER_ID);
  const 进度条单位 = CreateUnit(owner, PROGRESSBAR_UNIT_ID, x, y, 0);
  if (!单位存活(进度条单位)) return null;

  SetUnitScale(进度条单位, 缩放, 缩放, 缩放);
  if (typeof SetUnitAnimationByIndex === "function") {
    SetUnitAnimationByIndex(进度条单位, 动画序号);
  }
  if (动画速度 != null && 动画速度 > 0) {
    SetUnitTimeScale(进度条单位, 动画速度);
  }
  SetUnitVertexColor(
    进度条单位,
    裁剪到字节(颜色.r),
    裁剪到字节(颜色.g),
    裁剪到字节(颜色.b),
    裁剪到字节(颜色.a),
  );
  设置进度条位置(进度条单位, 单位, 高度偏移);

  const 数据: 进度条特效数据 = {
    进度条单位,
    跟随单位: 单位,
    跟随单位ID: 单位ID,
    高度偏移,
  };

  进度条映射.set(进度条单位, 数据);
  单位进度条映射.set(单位ID, 进度条单位);
  确保注册计时器();

  debugLogForce(调试模块名, "创建进度条单位成功", "unitId=", 单位ID, "animSpeed=", 动画速度 ?? "default");
  return 进度条单位;
}

export function 销毁进度条特效(进度条单位: any): void {
  移除进度条特效(进度条单位);
}

export function 销毁单位进度条特效(单位: any): void {
  if (单位 == null || 单位 === 0) return;
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return;

  const 进度条单位 = 单位进度条映射.get(单位ID);
  if (进度条单位 != null) {
    移除进度条特效(进度条单位);
  }

  if (进度条映射.size === 0 && 已注册计时器) {
    已注册计时器 = false;
    offTick10ms(更新所有进度条位置);
  }
}

export function 是否存在进度条特效(单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return 单位进度条映射.has(取句柄ID(单位));
}

export function 获取单位进度条特效(单位: any): any {
  if (单位 == null || 单位 === 0) return undefined;
  return 单位进度条映射.get(取句柄ID(单位));
}

export function 清除所有进度条特效(): void {
  for (const [进度条单位] of 进度条映射) {
    立即移除进度条单位(进度条单位);
  }
  进度条映射.clear();
  单位进度条映射.clear();

  if (已注册计时器) {
    已注册计时器 = false;
    offTick10ms(更新所有进度条位置);
  }
}

const g = globalThis as any;
if (typeof g.创建进度条特效 !== "function") {
  g.创建进度条特效 = 创建进度条特效;
}
if (typeof g.销毁单位进度条特效 !== "function") {
  g.销毁单位进度条特效 = 销毁单位进度条特效;
}

export {};
