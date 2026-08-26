/** @noSelfInFile */
/**
 * 充能系统
 *
 * 说明：
 * 1. 使用中心计时器按 0.02 秒推进充能
 * 2. 默认显示“进度条特效”，它是单位头顶的施法进度条，不是附着骨骼特效
 * 3. 过程特效 / 完成特效统一使用坐标特效，不使用 `AddSpecialEffectTarget`
 * 4. 命中硬控制效果合集时，当前充能会按“中断”结束
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};
const {
  registerImmediateOrderListener,
  registerPointOrderListener,
  registerTargetOrderListener,
} = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
  registerPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
  registerTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void) => void;
};
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (duration: number, effect: any) => void;
};
const {
  添加单位暂停,
  移除单位暂停,
} = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};

import { 创建进度条特效, 销毁单位进度条特效, 默认进度条高度偏移 } from "./进度条特效";
import { 单位是否处于硬控制效果合集 } from "../../02．通用函数/01．控制与Buff";
import {
  创建世界坐标进度UI,
  更新世界坐标进度UI,
  销毁世界坐标进度UI,
} from "../../../../09．表现系统/15．世界坐标进度UI";
import type {
  世界坐标进度UI,
  世界坐标进度UI类型,
} from "../../../../09．表现系统/15．世界坐标进度UI";

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (u: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (u: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const Location = jass.Location as (x: number, y: number) => any;
const MoveLocation = jass.MoveLocation as (whichLocation: any, x: number, y: number) => void;
const GetLocationZ = jass.GetLocationZ as (whichLocation: any) => number;
const RemoveLocation = jass.RemoveLocation as (whichLocation: any) => void;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;

const TICK_INTERVAL = 0.02;
const CENTER_TIMER_TICKS = 2;
const UNIT_ALIVE_LIFE = 0.405;
const DEFAULT_EFFECT_INTERVAL = 0.1;
const DEFAULT_EFFECT_DURATION = 1.0;

export type 充能结束原因 = "完成" | "中断" | "死亡" | "主单位死亡";
type 充能开始回调 = (单位: any, 充能ID: number) => void;
type 充能完成回调 = (单位: any, 充能ID: number) => void;
type 充能结束回调 = (单位: any, 原因: 充能结束原因, 充能ID: number) => void;
type 充能周期回调 = (
  单位: any,
  充能ID: number,
  已进行时间: number,
  剩余时间: number,
  进度: number,
) => void;
export type 充能打断回调 = (单位: any, 原因: Exclude<充能结束原因, "完成">, 充能ID: number) => void;

export interface 充能参数 {
  持续时间: number;
  主单位?: any;
  主单位死亡时中断?: boolean;
  指令中断?: boolean;
  强制硬直?: boolean;

  显示进度条特效?: boolean;
  进度条特效高度偏移?: number;
  进度条特效动画序号?: number;
  进度条特效动画速度?: number;

  世界坐标进度UI?: boolean;
  世界坐标进度UI类型?: 世界坐标进度UI类型;
  世界坐标进度UI标题?: string;
  世界坐标进度UI数值后缀?: string;
  世界坐标进度UI高度偏移?: number;

  过程特效?: string;
  过程特效播放次数?: number;
  过程特效间隔?: number;
  过程特效生命周期?: number;

  完成特效?: string;
  完成特效生命周期?: number;

  开始回调?: 充能开始回调;
  周期回调?: 充能周期回调;
  周期回调间隔?: number;
  充能完成回调?: 充能完成回调;
  结束回调?: 充能结束回调;
}

interface 充能实例 {
  id: number;
  单位: any;
  单位ID: number;
  主单位?: any;
  主单位死亡时中断: boolean;
  指令中断: boolean;
  强制硬直: boolean;
  强制硬直来源?: string;
  总持续时间: number;
  剩余时间: number;

  显示进度条特效: boolean;
  世界坐标进度UI: 世界坐标进度UI | null;
  过程特效?: string;
  过程特效间隔: number;
  过程特效生命周期: number;
  完成特效?: string;
  完成特效生命周期: number;
  下次过程特效倒计时: number;
  周期回调?: 充能周期回调;
  周期回调间隔: number;
  下次周期回调倒计时: number;

  开始回调?: 充能开始回调;
  充能完成回调?: 充能完成回调;
  结束回调?: 充能结束回调;
}

const 活动充能列表: 充能实例[] = [];
const 充能映射: Record<number, 充能实例 | undefined> = {};
const 单位当前充能: Record<number, number | undefined> = {};
const 充能打断回调列表: 充能打断回调[] = [];
let 下一个充能ID = 1;
let 已注册到中心计时器 = false;
let 已注册指令中断监听 = false;
let tick计数 = 0;
let 地形采样点: any = null;

function 取句柄ID(h: any): number {
  return h != null && h !== 0 ? GetHandleId(h) : 0;
}

function 单位存活(u: any): boolean {
  if (u == null || u === 0) return false;
  if (GetUnitTypeId(u) === 0) return false;
  if (IsUnitType(u, jass.UNIT_TYPE_DEAD)) return false;
  return GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 获取地形高度(x: number, y: number): number {
  if (地形采样点 == null) {
    地形采样点 = Location(x, y);
  } else {
    MoveLocation(地形采样点, x, y);
  }
  return GetLocationZ(地形采样点) || 0;
}

function 归一化时间(value: number | undefined, defaultValue: number): number {
  if (value != null && value > 0) return value;
  return defaultValue;
}

function 计算过程特效间隔(持续时间: number, 参数: 充能参数): number {
  const 播放次数 = 参数.过程特效播放次数;
  if (播放次数 != null && 播放次数 > 0) {
    return 归一化时间(持续时间 / 播放次数, DEFAULT_EFFECT_INTERVAL);
  }
  return 归一化时间(参数.过程特效间隔, DEFAULT_EFFECT_INTERVAL);
}

function 计算进度条动画速度(持续时间: number, 参数: 充能参数): number {
  if (参数.进度条特效动画速度 != null && 参数.进度条特效动画速度 > 0) {
    return 参数.进度条特效动画速度;
  }
  if (持续时间 > 0) {
    return 1 / 持续时间;
  }
  return 1;
}

function 计算充能进度(实例: 充能实例): number {
  if (实例.总持续时间 <= 0) return 0;
  const 已进行时间 = 实例.总持续时间 - 实例.剩余时间;
  const 百分比 = 已进行时间 / 实例.总持续时间;
  if (百分比 <= 0) return 0;
  if (百分比 >= 1) return 1;
  return 百分比;
}

function 播放单位坐标特效(单位: any, 模型: string | undefined, 生命周期: number): void {
  if (!单位存活(单位) || 模型 == null || 模型 === "") return;

  const x = GetUnitX(单位);
  const y = GetUnitY(单位);
  const effect = AddSpecialEffect(模型, x, y);
  if (effect == null || effect === 0) return;

  if (typeof EXSetEffectZ === "function") {
    EXSetEffectZ(effect, 获取地形高度(x, y) + GetUnitFlyHeight(单位));
  }
  YDWETimerDestroyEffect(生命周期, effect);
}

function 从中心计时器注销(): void {
  if (!已注册到中心计时器) return;
  已注册到中心计时器 = false;
  offTick10ms(on充能系统Tick);
}

function 注册到中心计时器(): void {
  if (已注册到中心计时器) return;
  已注册到中心计时器 = true;
  tick计数 = 0;
  onTick10ms(on充能系统Tick);
}

function 尝试指令中断充能(this: void, 单位: any): void {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return;
  const 充能ID = 单位当前充能[单位ID];
  if (充能ID == null) return;
  const 实例 = 充能映射[充能ID];
  if (实例 == null || 实例.强制硬直 === true || 实例.指令中断 !== true) return;
  停止充能(充能ID);
}

function on充能单位立即指令(this: void, 单位: any, _orderId: number): void {
  尝试指令中断充能(单位);
}

function on充能单位点指令(this: void, 单位: any, _orderId: number, _x: number, _y: number): void {
  尝试指令中断充能(单位);
}

function on充能单位目标指令(this: void, 单位: any, _orderId: number, _targetUnit: any, _targetItem: any, _targetDestructable: any): void {
  尝试指令中断充能(单位);
}

function 确保注册指令中断监听(this: void): void {
  if (已注册指令中断监听) return;
  已注册指令中断监听 = true;
  registerImmediateOrderListener(on充能单位立即指令);
  registerPointOrderListener(on充能单位点指令);
  registerTargetOrderListener(on充能单位目标指令);
}

function 尝试关闭中心计时器(): void {
  if (活动充能列表.length > 0) return;
  从中心计时器注销();
}

function 触发充能打断回调(
  单位: any,
  原因: Exclude<充能结束原因, "完成">,
  充能ID: number
): void {
  for (const 回调 of 充能打断回调列表) {
    回调(单位, 原因, 充能ID);
  }
}

function 结束充能实例(实例: 充能实例, 原因: 充能结束原因): void {
  delete 充能映射[实例.id];
  if (单位当前充能[实例.单位ID] === 实例.id) {
    delete 单位当前充能[实例.单位ID];
  }

  const index = 活动充能列表.indexOf(实例);
  if (index >= 0) {
    活动充能列表.splice(index, 1);
  }

  if (实例.显示进度条特效) {
    销毁单位进度条特效(实例.单位);
  }
  销毁世界坐标进度UI(实例.世界坐标进度UI);
  if (实例.强制硬直 && 实例.强制硬直来源 != null) {
    移除单位暂停(实例.单位, 实例.强制硬直来源);
  }

  if (原因 === "完成" && 单位存活(实例.单位)) {
    播放单位坐标特效(实例.单位, 实例.完成特效, 实例.完成特效生命周期);
    if (typeof 实例.充能完成回调 === "function") {
      实例.充能完成回调(实例.单位, 实例.id);
    }
  }

  if (typeof 实例.结束回调 === "function") {
    实例.结束回调(实例.单位, 原因, 实例.id);
  }

  if (原因 !== "完成") {
    触发充能打断回调(实例.单位, 原因, 实例.id);
  }
}

export function 停止充能(充能ID: number): boolean {
  const 实例 = 充能映射[充能ID];
  if (实例 == null) return false;
  结束充能实例(实例, "中断");
  尝试关闭中心计时器();
  return true;
}

export function 停止单位充能(单位: any): boolean {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return false;
  const 充能ID = 单位当前充能[单位ID];
  if (充能ID == null) return false;
  return 停止充能(充能ID);
}

export function 单位是否正在充能(单位: any): boolean {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return false;
  return 单位当前充能[单位ID] != null;
}

export function 获取单位当前充能ID(单位: any): number {
  const 单位ID = 取句柄ID(单位);
  if (单位ID === 0) return 0;
  return 单位当前充能[单位ID] ?? 0;
}

export function 获取活跃充能数量(): number {
  return 活动充能列表.length;
}

export function 获取充能进度(充能ID: number): number {
  const 实例 = 充能映射[充能ID];
  if (实例 == null || 实例.总持续时间 <= 0) return 0;
  const 已进行时间 = 实例.总持续时间 - 实例.剩余时间;
  const 百分比 = 已进行时间 / 实例.总持续时间;
  if (百分比 <= 0) return 0;
  if (百分比 >= 1) return 1;
  return 百分比;
}

export function 注册充能打断回调(回调: 充能打断回调): void {
  if (回调 == null) return;
  if (充能打断回调列表.indexOf(回调) >= 0) return;
  充能打断回调列表.push(回调);
}

export function 取消注册充能打断回调(回调: 充能打断回调): void {
  const 索引 = 充能打断回调列表.indexOf(回调);
  if (索引 < 0) return;
  充能打断回调列表.splice(索引, 1);
}

export function 开始充能(单位: any, 参数: 充能参数): number {
  if (!单位存活(单位) || 参数.持续时间 <= 0) {
    return 0;
  }

  停止单位充能(单位);

  const 单位ID = 取句柄ID(单位);
  const 持续时间 = 参数.持续时间;
  const 充能ID = 下一个充能ID++;
  const 显示进度条特效 = 参数.显示进度条特效 !== false;
  const 过程特效 = 参数.过程特效;
  const 过程特效生命周期 = 归一化时间(参数.过程特效生命周期, DEFAULT_EFFECT_DURATION);
  const 完成特效 = 参数.完成特效;
  const 完成特效生命周期 = 归一化时间(参数.完成特效生命周期, DEFAULT_EFFECT_DURATION);
  const 周期回调间隔 = 归一化时间(参数.周期回调间隔, TICK_INTERVAL);
  const 强制硬直 = 参数.强制硬直 === true;
  const 强制硬直来源 = 强制硬直 ? `充能强制硬直#${充能ID}` : undefined;

  const 新实例: 充能实例 = {
    id: 充能ID,
    单位,
    单位ID,
    主单位: 参数.主单位,
    主单位死亡时中断: 参数.主单位死亡时中断 !== false,
    指令中断: !强制硬直 && 参数.指令中断 === true,
    强制硬直,
    强制硬直来源,
    总持续时间: 持续时间,
    剩余时间: 持续时间,
    显示进度条特效,
    世界坐标进度UI: null,
    过程特效,
    过程特效间隔: 计算过程特效间隔(持续时间, 参数),
    过程特效生命周期,
    完成特效,
    完成特效生命周期,
    下次过程特效倒计时: 0,
    周期回调: 参数.周期回调,
    周期回调间隔,
    下次周期回调倒计时: 0,
    开始回调: 参数.开始回调,
    充能完成回调: 参数.充能完成回调,
    结束回调: 参数.结束回调,
  };

  活动充能列表.push(新实例);
  充能映射[充能ID] = 新实例;
  单位当前充能[单位ID] = 充能ID;
  if (强制硬直 && 强制硬直来源 != null) 添加单位暂停(单位, 强制硬直来源);
  if (新实例.指令中断) 确保注册指令中断监听();

  if (显示进度条特效) {
    创建进度条特效(单位, {
      高度偏移: 参数.进度条特效高度偏移 ?? 默认进度条高度偏移,
      动画序号: 参数.进度条特效动画序号 ?? 0,
      动画速度: 计算进度条动画速度(持续时间, 参数),
    });
  }

  if (参数.世界坐标进度UI === true) {
    const 高度偏移 = 参数.世界坐标进度UI高度偏移 ?? 180;
    新实例.世界坐标进度UI = 创建世界坐标进度UI({
      X: GetUnitX(单位),
      Y: GetUnitY(单位),
      Z: 高度偏移,
      最大值: 持续时间,
      当前值: 持续时间,
      标题: 参数.世界坐标进度UI标题 ?? "蓄力",
      数值后缀: 参数.世界坐标进度UI数值后缀 ?? "秒",
      类型: 参数.世界坐标进度UI类型 ?? "通用",
      跟随单位: 单位,
      跟随Z偏移: 高度偏移,
      初始显示: true,
    });
  }

  if (typeof 新实例.开始回调 === "function") {
    新实例.开始回调(单位, 充能ID);
  }

  注册到中心计时器();
  return 充能ID;
}

function on充能系统Tick(): void {
  tick计数 += 1;
  if (tick计数 < CENTER_TIMER_TICKS) return;
  tick计数 = 0;

  let i = 0;
  while (i < 活动充能列表.length) {
    const 实例 = 活动充能列表[i];

    if (!单位存活(实例.单位)) {
      结束充能实例(实例, "死亡");
      continue;
    }

    if (单位是否处于硬控制效果合集(实例.单位)) {
      结束充能实例(实例, "中断");
      continue;
    }

    if (实例.主单位死亡时中断 && 实例.主单位 != null && !单位存活(实例.主单位)) {
      结束充能实例(实例, "主单位死亡");
      continue;
    }

    实例.剩余时间 -= TICK_INTERVAL;
    实例.下次过程特效倒计时 -= TICK_INTERVAL;
    实例.下次周期回调倒计时 -= TICK_INTERVAL;
    更新世界坐标进度UI(实例.世界坐标进度UI, 实例.剩余时间);

    if (实例.过程特效 != null && 实例.过程特效 !== "" && 实例.下次过程特效倒计时 <= 0) {
      播放单位坐标特效(实例.单位, 实例.过程特效, 实例.过程特效生命周期);
      实例.下次过程特效倒计时 = 实例.过程特效间隔;
    }

    if (typeof 实例.周期回调 === "function" && 实例.下次周期回调倒计时 <= 0) {
      const 已进行时间 = 实例.总持续时间 - 实例.剩余时间;
      实例.周期回调(实例.单位, 实例.id, 已进行时间, 实例.剩余时间, 计算充能进度(实例));
      实例.下次周期回调倒计时 = 实例.周期回调间隔;
    }

    if (实例.剩余时间 <= 0) {
      结束充能实例(实例, "完成");
      continue;
    }

    i += 1;
  }

  尝试关闭中心计时器();
}

const g = globalThis as any;
if (typeof g.开始充能 !== "function") {
  g.开始充能 = 开始充能;
}

export {};
