/** @noSelfInFile */
/**
 * Star扩展库 - 快速Buff幻象物品
 *
 * 单独拆分原因：
 * - 幻象物品是独立业务，不该堆在 04A 共享层
 * - 这里专管召唤桥接、上下文匹配、BuffUI 挂载
 */

const jass = require("jass.common") as any;
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const summonEvent = require("系统.00．核心系统.01．事件中心.09．单位召唤事件中心") as {
  registerSummonListener: (this: void, callback: (summonedUnit: any, summoningUnit: any) => void) => void;
};

import {
  SFB_Unit,
  getUnitSourceName,
} from "./04A．快速Buff共享";

const ITEM_ILLUSION_BUFF_ID = "C019";
const GetHandleId = jass["GetHandleId"] as (whichHandle: any) => number;
const GetUnitTypeId = jass["GetUnitTypeId"] as (whichUnit: any) => number;
const GetOwningPlayer = jass["GetOwningPlayer"] as (whichUnit: any) => any;
const IsUnitIllusion = jass["IsUnitIllusion"] as (whichUnit: any) => boolean;
const SetUnitOwner = jass["SetUnitOwner"] as (whichUnit: any, whichPlayer: any, changeColor: boolean) => void;

interface PendingItemIllusionContext {
  sourceUnit: any;
  targetUnit: any;
  duration: number;
  targetOwner: any;
  targetTypeId: number;
  targetHandleId: number;
}

let pendingItemIllusionContext: PendingItemIllusionContext | null = null;
let itemIllusionSummonBridgeInited = false;

function isMatchingPendingItemIllusionContext(summonedUnit: any, summoningUnit: any, ctx: PendingItemIllusionContext): boolean {
  if (summonedUnit == null || summonedUnit === 0) return false;
  if (!IsUnitIllusion(summonedUnit)) return false;
  if (GetUnitTypeId(summonedUnit) !== ctx.targetTypeId) return false;
  if (summoningUnit == null || summoningUnit === 0) return true;
  if (summoningUnit === ctx.targetUnit) return true;
  if (summoningUnit === SFB_Unit) return true;
  return GetHandleId(summoningUnit) === ctx.targetHandleId;
}

function applyItemIllusionSummonBuff(summonedUnit: any, ctx: PendingItemIllusionContext): void {
  if (ctx.duration <= 0) return;
  SetUnitOwner(summonedUnit, ctx.targetOwner, true);
  registerManualBuff(summonedUnit, ITEM_ILLUSION_BUFF_ID, ctx.duration, 0, {
    sourceName: getUnitSourceName(ctx.sourceUnit, ctx.targetUnit),
  });
}

function onItemIllusionSummoned(summonedUnit: any, summoningUnit: any): void {
  const ctx = pendingItemIllusionContext;
  if (ctx == null) return;
  if (!isMatchingPendingItemIllusionContext(summonedUnit, summoningUnit, ctx)) return;
  pendingItemIllusionContext = null;
  applyItemIllusionSummonBuff(summonedUnit, ctx);
}

export function initItemIllusionSummonBridge(this: void): void {
  if (itemIllusionSummonBridgeInited) return;
  itemIllusionSummonBridgeInited = true;
  summonEvent.registerSummonListener(onItemIllusionSummoned);
}

export function SFB_记录幻象物品上下文(this: void, sourceUnit: any, targetUnit: any, duration: number): void {
  if (targetUnit == null || targetUnit === 0 || duration <= 0) {
    pendingItemIllusionContext = null;
    return;
  }
  pendingItemIllusionContext = {
    sourceUnit,
    targetUnit,
    duration,
    targetOwner: GetOwningPlayer(targetUnit),
    targetTypeId: GetUnitTypeId(targetUnit),
    targetHandleId: GetHandleId(targetUnit),
  };
}

export function SFB_清空幻象物品上下文(this: void): void {
  pendingItemIllusionContext = null;
}
