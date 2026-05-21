/** @noSelfInFile */
/**
 * Star扩展库 - 快速Buff幻象物品
 *
 * 单独拆分原因：
 * - 幻象物品是独立业务，不该堆在 04A 共享层
 * - 这里专管召唤桥接、上下文匹配、BuffUI 挂载
 */
const jass = require("jass.common");
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统");
const summonEvent = require("系统.00．核心系统.01．事件中心.09．单位召唤事件中心");
import { SFB_Unit, getUnitSourceName, } from "./04A．快速Buff共享";
const ITEM_ILLUSION_BUFF_ID = "C019";
const GetHandleId = jass["GetHandleId"];
const GetUnitTypeId = jass["GetUnitTypeId"];
const GetOwningPlayer = jass["GetOwningPlayer"];
const IsUnitIllusion = jass["IsUnitIllusion"];
const SetUnitOwner = jass["SetUnitOwner"];
let pendingItemIllusionContext = null;
let itemIllusionSummonBridgeInited = false;
function isMatchingPendingItemIllusionContext(summonedUnit, summoningUnit, ctx) {
    if (summonedUnit == null || summonedUnit === 0)
        return false;
    if (!IsUnitIllusion(summonedUnit))
        return false;
    if (GetUnitTypeId(summonedUnit) !== ctx.targetTypeId)
        return false;
    if (summoningUnit == null || summoningUnit === 0)
        return true;
    if (summoningUnit === ctx.targetUnit)
        return true;
    if (summoningUnit === SFB_Unit)
        return true;
    return GetHandleId(summoningUnit) === ctx.targetHandleId;
}
function applyItemIllusionSummonBuff(summonedUnit, ctx) {
    if (ctx.duration <= 0)
        return;
    SetUnitOwner(summonedUnit, ctx.targetOwner, true);
    registerManualBuff(summonedUnit, ITEM_ILLUSION_BUFF_ID, ctx.duration, 0, {
        sourceName: getUnitSourceName(ctx.sourceUnit, ctx.targetUnit),
    });
}
function onItemIllusionSummoned(summonedUnit, summoningUnit) {
    const ctx = pendingItemIllusionContext;
    if (ctx == null)
        return;
    if (!isMatchingPendingItemIllusionContext(summonedUnit, summoningUnit, ctx))
        return;
    pendingItemIllusionContext = null;
    applyItemIllusionSummonBuff(summonedUnit, ctx);
}
export function initItemIllusionSummonBridge() {
    if (itemIllusionSummonBridgeInited)
        return;
    itemIllusionSummonBridgeInited = true;
    summonEvent.registerSummonListener(onItemIllusionSummoned);
}
export function SFB_记录幻象物品上下文(sourceUnit, targetUnit, duration) {
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
export function SFB_清空幻象物品上下文() {
    pendingItemIllusionContext = null;
}
