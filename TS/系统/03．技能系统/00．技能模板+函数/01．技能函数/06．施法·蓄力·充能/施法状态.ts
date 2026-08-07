/** @noSelfInFile */
/**
 * 施法状态与打断回调
 *
 * 说明：
 * 1. 底层状态仍然复用 `充能系统.ts`
 * 2. 对外推荐统一使用“施法”语义
 * 3. “蓄力 / 充能”相关名称只作为兼容别名保留
 */

import {
  单位是否正在充能,
  注册充能打断回调,
  取消注册充能打断回调,
  type 充能打断回调,
} from "./充能系统";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const 技能事件中心 = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellChannelListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
  registerSpellFinishListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
  registerSpellEndcastListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const registerSpellChannelListener = 技能事件中心.registerSpellChannelListener;
const registerSpellFinishListener = 技能事件中心.registerSpellFinishListener;
const registerSpellEndcastListener = 技能事件中心.registerSpellEndcastListener;

const 单位死亡事件中心 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const registerDeathListener = 单位死亡事件中心.registerDeathListener;

const 原生施法状态: Record<number, true | undefined> = {};

function 取单位句柄ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位);
}

function 处理原生施法开始(this: void, 单位: any, _技能ID: number): void {
  const 单位ID = 取单位句柄ID(单位);
  if (单位ID !== 0) 原生施法状态[单位ID] = true;
}

function 处理原生施法结束(this: void, 单位: any, _技能ID: number): void {
  const 单位ID = 取单位句柄ID(单位);
  if (单位ID !== 0) delete 原生施法状态[单位ID];
}

function 清理死亡单位施法状态(this: void, 死亡单位: any, _击杀单位: any): void {
  const 单位ID = 取单位句柄ID(死亡单位);
  if (单位ID !== 0) delete 原生施法状态[单位ID];
}

registerSpellChannelListener(处理原生施法开始);
registerSpellFinishListener(处理原生施法结束);
registerSpellEndcastListener(处理原生施法结束);
registerDeathListener(清理死亡单位施法状态);

/**
 * 判断单位是否处于魔兽原生技能的施法阶段。
 * 状态由 SPELL_CHANNEL / SPELL_FINISH / SPELL_ENDCAST 事件维护，不使用轮询或单位组扫描。
 */
export function 单位是否正在原生施法(this: void, 单位: any): boolean {
  const 单位ID = 取单位句柄ID(单位);
  return 单位ID !== 0 && 原生施法状态[单位ID] === true;
}

/**
 * 兼容旧接口：判断项目自定义充能状态，不代表魔兽原生施法状态。
 */
export function 单位是否正在施法(this: void, 单位: any): boolean {
  return 单位是否正在充能(单位);
}

/**
 * 兼容别名。
 * 推荐优先使用 `单位是否正在施法`。
 */
export function 单位是否正在蓄力(this: void, 单位: any): boolean {
  return 单位是否正在施法(单位);
}

/**
 * 兼容别名。
 * 推荐优先使用 `单位是否正在施法`。
 */
export function 单位是否正在施法或蓄力或充能(this: void, 单位: any): boolean {
  return 单位是否正在施法(单位);
}

/**
 * 推荐统一使用这个接口注册“施法被打断”回调。
 * 底层实现与“充能被打断”相同。
 */
export const 注册施法被打断回调 = 注册充能打断回调;

/**
 * 推荐统一使用这个接口取消“施法被打断”回调。
 * 底层实现与“充能被打断”相同。
 */
export const 取消注册施法被打断回调 = 取消注册充能打断回调;

/**
 * 兼容别名。
 * 推荐优先使用 `注册施法被打断回调`。
 */
export const 注册蓄力被打断回调 = 注册充能打断回调;

/**
 * 兼容别名。
 * 推荐优先使用 `取消注册施法被打断回调`。
 */
export const 取消注册蓄力被打断回调 = 取消注册充能打断回调;

export type 施法打断回调 = 充能打断回调;
