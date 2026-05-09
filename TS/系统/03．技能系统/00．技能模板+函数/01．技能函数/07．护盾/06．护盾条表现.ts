/** @noSelfInFile */
/**
 * 护盾条表现
 *
 * 说明：
 * 1. 复用进度条单位 e011 显示护盾条
 * 2. 第一版只显示总护盾值
 * 3. 护盾条颜色：通用=黄色，受物理伤害=棕色，受魔法伤害=深蓝色
 * 4. 护盾耗尽或单位死亡时删除
 */

import { 护盾类型 } from "./01．护盾类型";
import { 获取单位总护盾值, 获取单位护盾实例列表, 取句柄ID } from "./02．护盾实例";

const jass = require("jass.common") as any;

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};

// ==========================================================================================
// JASS 函数别名
// ==========================================================================================

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
const R2I = jass.R2I as (r: number) => number;

// ==========================================================================================
// 常量
// ==========================================================================================

const SHIELD_BAR_UNIT_ID = 1935764066; // 'sbar'
const SHIELD_BAR_OWNER_PLAYER_ID = 4;
const DEFAULT_HEIGHT_OFFSET = 290.0; // 比进度条略高
const UNIT_ALIVE_LIFE = 0.405;

// 颜色定义
const COLOR_DEFAULT = { r: 255, g: 255, b: 0, a: 255 };    // 黄色（默认）
const COLOR_PHYSICAL = { r: 180, g: 100, b: 30, a: 255 };  // 棕色（物理伤害）
const COLOR_MAGICAL = { r: 30, g: 30, b: 180, a: 255 };    // 深蓝色（魔法伤害）
const COLOR_GENERAL = { r: 200, g: 200, b: 200, a: 255 };  // 灰白色（其他/通用伤害）

// ==========================================================================================
// 护盾条数据
// ==========================================================================================

interface 护盾条数据 {
  护盾条单位: any;
  跟随单位: any;
  跟随单位ID: number;
  高度偏移: number;
  当前颜色: { r: number; g: number; b: number; a: number };
  颜色恢复倒计时: number;
  初始总护盾: number;
}

const 护盾条映射 = new Map<number, 护盾条数据>(); // 单位ID -> 护盾条数据
let 已注册计时器 = false;

// ==========================================================================================
// 工具函数
// ==========================================================================================

function 单位存活(u: any): boolean {
  if (u == null || u === 0) return false;
  if (GetUnitTypeId(u) === 0) return false;
  if (IsUnitType(u, jass.UNIT_TYPE_DEAD)) return false;
  return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 裁剪到字节(value: number): number {
  if (value <= 0) return 0;
  if (value >= 255) return 255;
  return R2I(value);
}

// ==========================================================================================
// 护盾条管理
// ==========================================================================================

function 设置护盾条位置(数据: 护盾条数据): void {
  if (!单位存活(数据.护盾条单位) || !单位存活(数据.跟随单位)) return;
  SetUnitX(数据.护盾条单位, GetUnitX(数据.跟随单位));
  SetUnitY(数据.护盾条单位, GetUnitY(数据.跟随单位));
  SetUnitFlyHeight(数据.护盾条单位, GetUnitFlyHeight(数据.跟随单位) + 数据.高度偏移, 0);
}

function 设置护盾条颜色(数据: 护盾条数据, 颜色: { r: number; g: number; b: number; a: number }): void {
  if (!单位存活(数据.护盾条单位)) return;
  SetUnitVertexColor(
    数据.护盾条单位,
    裁剪到字节(颜色.r),
    裁剪到字节(颜色.g),
    裁剪到字节(颜色.b),
    裁剪到字节(颜色.a)
  );
  数据.当前颜色 = 颜色;
}

function 设置护盾条比例(数据: 护盾条数据, 比例: number): void {
  if (!单位存活(数据.护盾条单位)) return;
  // 通过动画帧控制显示比例
  // e011 进度条模型有 100 帧对应 0%-100%
  let 帧索引 = jass.R2I(比例 * 99);
  if (帧索引 < 0) 帧索引 = 0;
  if (帧索引 > 99) 帧索引 = 99;
  if (typeof SetUnitAnimationByIndex === "function") {
    SetUnitAnimationByIndex(数据.护盾条单位, 帧索引);
  }
}

function 立即移除护盾条单位(护盾条单位: any): void {
  if (护盾条单位 == null || 护盾条单位 === 0) return;
  if (GetUnitTypeId(护盾条单位) === 0) return;
  RemoveUnit(护盾条单位);
}

function 移除护盾条(单位ID: number): void {
  const 数据 = 护盾条映射.get(单位ID);
  if (数据 == null) return;

  立即移除护盾条单位(数据.护盾条单位);
  护盾条映射.delete(单位ID);
}

function 更新所有护盾条位置(): void {
  for (const [单位ID, 数据] of 护盾条映射) {
    // 检查单位是否存活
    if (!单位存活(数据.跟随单位) || !单位存活(数据.护盾条单位)) {
      移除护盾条(单位ID);
      continue;
    }

    // 检查护盾是否还存在
    const 当前总护盾 = 获取单位总护盾值(单位ID);
    if (当前总护盾 <= 0) {
      移除护盾条(单位ID);
      continue;
    }

    // 更新位置
    设置护盾条位置(数据);

    // 更新比例
    const 比例 = 数据.初始总护盾 > 0 ? 当前总护盾 / 数据.初始总护盾 : 1;
    设置护盾条比例(数据, 比例);

    // 颜色恢复倒计时
    if (数据.颜色恢复倒计时 > 0) {
      数据.颜色恢复倒计时 -= 0.02;
      if (数据.颜色恢复倒计时 <= 0) {
        设置护盾条颜色(数据, COLOR_DEFAULT);
      }
    }
  }

  if (护盾条映射.size === 0 && 已注册计时器) {
    已注册计时器 = false;
    offTick10ms(更新所有护盾条位置);
  }
}

function 确保注册计时器(): void {
  if (已注册计时器) return;
  已注册计时器 = true;
  onTick10ms(更新所有护盾条位置);
}

// ==========================================================================================
// 对外 API
// ==========================================================================================

/**
 * 创建或更新护盾条
 */
export function 创建护盾条(单位: any): void {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return;

  // 已有护盾条则更新
  const 已有 = 护盾条映射.get(单位ID);
  if (已有 != null) {
    已有.初始总护盾 = 获取单位总护盾值(单位ID);
    return;
  }

  // 创建新的护盾条单位
  const x = GetUnitX(单位);
  const y = GetUnitY(单位);
  const owner = Player(SHIELD_BAR_OWNER_PLAYER_ID);
  const 护盾条单位 = CreateUnit(owner, SHIELD_BAR_UNIT_ID, x, y, 0);
  if (!单位存活(护盾条单位)) return;

  SetUnitScale(护盾条单位, 1, 1, 1);
  if (typeof SetUnitAnimationByIndex === "function") {
    SetUnitAnimationByIndex(护盾条单位, 0);
  }
  SetUnitVertexColor(
    护盾条单位,
    裁剪到字节(COLOR_DEFAULT.r),
    裁剪到字节(COLOR_DEFAULT.g),
    裁剪到字节(COLOR_DEFAULT.b),
    裁剪到字节(COLOR_DEFAULT.a)
  );

  const 初始总护盾 = 获取单位总护盾值(单位ID);

  const 数据: 护盾条数据 = {
    护盾条单位,
    跟随单位: 单位,
    跟随单位ID: 单位ID,
    高度偏移: DEFAULT_HEIGHT_OFFSET,
    当前颜色: COLOR_DEFAULT,
    颜色恢复倒计时: 0,
    初始总护盾,
  };

  护盾条映射.set(单位ID, 数据);
  设置护盾条位置(数据);
  确保注册计时器();
}

/**
 * 删除护盾条
 */
export function 删除护盾条(单位: any): void {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return;
  移除护盾条(单位ID);
}

/**
 * 护盾条闪色（受击反馈）
 * @param 伤害类型 0=其他/通用, 1=物理, 2=魔法
 */
export function 护盾条闪色(单位: any, 伤害类型: number): void {
  const 单位ID = 取句柄ID(单位);
  const 数据 = 护盾条映射.get(单位ID);
  if (数据 == null) return;

  let 颜色;
  if (伤害类型 === 1) {
    颜色 = COLOR_PHYSICAL;
  } else if (伤害类型 === 2) {
    颜色 = COLOR_MAGICAL;
  } else {
    颜色 = COLOR_GENERAL;
  }

  设置护盾条颜色(数据, 颜色);
  数据.颜色恢复倒计时 = 0.3; // 0.3秒后恢复默认颜色
}

/**
 * 检查单位是否有护盾条
 */
export function 是否有护盾条(单位: any): boolean {
  const 单位ID = 取句柄ID(单位);
  return 护盾条映射.has(单位ID);
}

/**
 * 清除所有护盾条
 */
export function 清除所有护盾条(): void {
  for (const [单位ID] of 护盾条映射) {
    移除护盾条(单位ID);
  }
  护盾条映射.clear();

  if (已注册计时器) {
    已注册计时器 = false;
    offTick10ms(更新所有护盾条位置);
  }
}

export {};
