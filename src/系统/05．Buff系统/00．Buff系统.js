/**
 * Buff 池 / Buff 系统框架（`00` 前缀便于在 `05．Buff系统` 目录内统一排序管理）
 *
 * - **DOT（D001–D004）剩余时间由本模块以固定步长递减**；`dot伤害` 施加/刷新时 `syncDotBuff` 写入满额 remaining，不在此用 `getUnitPoison` 回写覆盖。
 * - 非 DOT 的 `manual` 条同样由本计时器递减。
 * - 每 tick 末调用 `dot伤害.syncDotRemainingFromBuffPool`，使逻辑层 `stateByType` 与池一致。
 */
const jass = require("jass.common");
const leakCore = require("系统.00．核心系统.05．泄露审计");
const LeakWatcher = leakCore.LeakWatcher ?? leakCore;
/** Buff 条剩余秒数递减步长（与 UI 刷新粒度一致，0.1s） */
export const BUFF_POOL_TICK = 0.1;
/** dot伤害 里的 typeId → 01．Buff表 buffID */
export const DOT_TYPE_TO_BUFF_ID = {
    antiHeal: "D001",
    burn: "D002",
    poison: "D003",
    /** 与 `01．Buff表` D004 对应；`dot伤害` 注册同名 typeId 后 syncDotBuff 才会写入 */
    trollCurse: "D004",
};
/** GetHandleId → 数据（Lua 下勿直接用 unit 作键） */
const unitToBuffs = {};
let syncTimer = undefined;
function toHid(u) {
    if (u == null || u === 0)
        return 0;
    if (typeof u === "number")
        return u;
    if (typeof u === "string") {
        const n = parseInt(u, 10);
        return isNaN(n) ? 0 : n;
    }
    if (typeof jass.GetHandleId !== "function")
        return 0;
    return jass.GetHandleId(u);
}
function ensureEntry(u) {
    const hid = toHid(u);
    if (hid === 0)
        return null;
    if (unitToBuffs[hid] == null)
        unitToBuffs[hid] = { lastRef: u, buffs: {} };
    else
        unitToBuffs[hid].lastRef = u;
    return unitToBuffs[hid];
}
function pruneEmptyHid(hid) {
    const e = unitToBuffs[hid];
    if (e == null)
        return;
    let n = 0;
    for (const _k in e.buffs) {
        n++;
        break;
    }
    if (n === 0)
        delete unitToBuffs[hid];
}
function notifyDotBuffExpiredFromPool(buffID, hid) {
    pcall(() => {
        const m = require("系统.04．伤害系统.02．dot伤害");
        if (m != null && typeof m.clearDotByBuffPoolExpire === "function")
            m.clearDotByBuffPoolExpire(buffID, hid);
    });
}
function syncDotFromPoolTick() {
    pcall(() => {
        const m = require("系统.04．伤害系统.02．dot伤害");
        if (m != null && typeof m.syncDotRemainingFromBuffPool === "function")
            m.syncDotRemainingFromBuffPool();
    });
}
/**
 * 由 dot伤害 调用：施加、覆盖或到期清除。
 * target 可为单位或 **GetHandleId**。
 * state 为 null 表示该 DOT 类型在该单位上已结束。
 */
export function syncDotBuff(typeId, target, state) {
    const buffID = DOT_TYPE_TO_BUFF_ID[typeId];
    if (!buffID)
        return;
    const hid = toHid(target);
    if (hid === 0)
        return;
    if (state == null) {
        const e = unitToBuffs[hid];
        if (e == null)
            return;
        delete e.buffs[buffID];
        pruneEmptyHid(hid);
        maybeStopSyncTimer();
        return;
    }
    const entry = ensureEntry(target);
    if (entry == null)
        return;
    entry.buffs[buffID] = {
        buffID,
        remaining: state.remaining,
        effect: state.effect,
        source: "dot",
        sourceName: state.sourceName,
        _dotParsedDuration: state._dotParsedDuration,
    };
    if (typeof target !== "number")
        entry.lastRef = target;
    ensureSyncTimer();
}
export function registerManualBuff(target, buffID, durationSec, effectValue, extras) {
    if (target == null || target === 0 || !buffID || durationSec <= 0)
        return;
    const entry = ensureEntry(target);
    if (entry == null)
        return;
    const row = { buffID, remaining: durationSec, effect: effectValue, source: "manual" };
    if (extras != null) {
        if (extras.sourceName !== undefined && extras.sourceName !== "")
            row.sourceName = extras.sourceName;
        if (extras.iconOverride !== undefined && extras.iconOverride !== "")
            row.iconOverride = extras.iconOverride;
        if (extras.effectModelOverride !== undefined && extras.effectModelOverride !== "")
            row.effectModelOverride = extras.effectModelOverride;
    }
    entry.buffs[buffID] = row;
    ensureSyncTimer();
}
export function removeBuffById(target, buffID) {
    const hid = toHid(target);
    if (hid === 0)
        return;
    const e = unitToBuffs[hid];
    if (e == null)
        return;
    delete e.buffs[buffID];
    pruneEmptyHid(hid);
    maybeStopSyncTimer();
}
export function clearAllBuffsOnUnit(target) {
    const hid = toHid(target);
    if (hid === 0)
        return;
    delete unitToBuffs[hid];
    maybeStopSyncTimer();
}
export function isUnitInBuffPool(unit) {
    const hid = toHid(unit);
    if (hid === 0)
        return false;
    const e = unitToBuffs[hid];
    if (e == null)
        return false;
    for (const _k in e.buffs)
        return true;
    return false;
}
export function getBuffIdsOnUnit(unit) {
    const hid = toHid(unit);
    const out = [];
    const e = hid !== 0 ? unitToBuffs[hid] : null;
    if (e == null)
        return out;
    for (const k in e.buffs)
        out.push(k);
    return out;
}
export function getBuffRuntime(unit, buffID) {
    const hid = toHid(unit);
    return getBuffRuntimeByHid(hid, buffID);
}
export function getBuffRuntimeByHid(hid, buffID) {
    if (hid === 0)
        return null;
    const e = unitToBuffs[hid];
    if (e == null)
        return null;
    const r = e.buffs[buffID];
    return r != null ? r : null;
}
/** 图标底部剩余秒数：与池内 `remaining` 一致（无假层） */
export function getDotIconDisplayRemaining(_unit, _buffID, realRemaining) {
    return typeof realRemaining === "number" && isFinite(realRemaining) ? realRemaining : 0;
}
function tickBuffPool() {
    for (const hidKey in unitToBuffs) {
        const hid = toHid(hidKey);
        if (hid === 0)
            continue;
        const entry = unitToBuffs[hid];
        if (entry == null)
            continue;
        const tab = entry.buffs;
        const expired = [];
        for (const bid in tab) {
            const row = tab[bid];
            if (row == null)
                continue;
            row.remaining = row.remaining - BUFF_POOL_TICK;
            if (row.remaining <= 0) {
                if (row.source === "dot")
                    notifyDotBuffExpiredFromPool(bid, hid);
                expired.push(bid);
            }
        }
        for (let ei = 0; ei < expired.length; ei++)
            delete tab[expired[ei]];
        pruneEmptyHid(hid);
    }
    syncDotFromPoolTick();
    maybeStopSyncTimer();
}
function ensureSyncTimer() {
    if (syncTimer != null)
        return;
    if (typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function")
        return;
    syncTimer = LeakWatcher.createTimer("buff_pool_tick");
    jass.TimerStart(syncTimer, BUFF_POOL_TICK, true, tickBuffPool);
}
function maybeStopSyncTimer() {
    let hasAny = false;
    for (const _u in unitToBuffs) {
        hasAny = true;
        break;
    }
    if (!hasAny && syncTimer != null) {
        LeakWatcher.destroyTimer(syncTimer);
        syncTimer = undefined;
    }
}
export function initBuffSystem() { }
