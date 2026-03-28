/**
 * Buff 池 / Buff 系统框架
 *
 * - 记录「单位 → 当前拥有的 Buff 表 buffID」及快照（剩余时间、每跳强度等）。
 * - 键统一为 GetHandleId(unit)，避免 Lua 里「伤害回调里的 target」与「选中枚举的 sole」不是同一 userdata 导致查不到表。
 * - DOT 类由 dot伤害 在施加/覆盖/到期时调用 syncDotBuff；到期自动从池中移除。
 * - 非 DOT 类可调用 registerManualBuff，由本模块计时并在到期时清除。
 */

const jass = require("jass.common") as Record<string, unknown>;
const leakCore = require("系统.00．核心系统.泄露审计") as { LeakWatcher?: any };
const LeakWatcher = leakCore.LeakWatcher ?? leakCore;

const TICK = 0.5;

/** dot伤害 里的 typeId → 01．Buff表 buffID */
export const DOT_TYPE_TO_BUFF_ID: Record<string, string> = {
  antiHeal: "D001",
  burn: "D002",
};

export interface BuffRuntime {
  buffID: string;
  remaining: number;
  effect: number;
  source: "dot" | "manual";
}

interface UnitBuffEntry {
  /** 最近一次同步时的单位引用，供从 dot 刷新 D001/D002（与 hid 对应） */
  lastRef: any;
  buffs: Record<string, BuffRuntime>;
}

/** GetHandleId → 数据（Lua 下勿直接用 unit 作键） */
const unitToBuffs: Record<number, UnitBuffEntry> = {};
let syncTimer: any = undefined;

function toHid(u: any): number {
  if (u == null || u === 0) return 0;
  if (typeof u === "number") return u;
  if (typeof u === "string") {
    const n = parseInt(u, 10);
    return isNaN(n) ? 0 : n;
  }
  if (typeof (jass as any).GetHandleId !== "function") return 0;
  return (jass as any).GetHandleId(u) as number;
}

function ensureEntry(u: any): UnitBuffEntry | null {
  const hid = toHid(u);
  if (hid === 0) return null;
  if (unitToBuffs[hid] == null) unitToBuffs[hid] = { lastRef: u, buffs: {} as Record<string, BuffRuntime> };
  else unitToBuffs[hid].lastRef = u;
  return unitToBuffs[hid];
}

function pruneEmptyHid(hid: number): void {
  const e = unitToBuffs[hid];
  if (e == null) return;
  let n = 0;
  for (const _k in e.buffs) {
    n++;
    break;
  }
  if (n === 0) delete unitToBuffs[hid];
}

/**
 * 由 dot伤害 调用：施加、覆盖或到期清除。
 * target 可为单位或 **GetHandleId**（tick 里到期时只传 id）。
 * state 为 null 表示该 DOT 类型在该单位上已结束。
 */
export function syncDotBuff(typeId: string, target: any, state: { effect: number; remaining: number } | null): void {
  const buffID = DOT_TYPE_TO_BUFF_ID[typeId];
  if (!buffID) return;
  const hid = toHid(target);
  if (hid === 0) return;
  if (state == null) {
    const e = unitToBuffs[hid];
    if (e == null) return;
    delete e.buffs[buffID];
    pruneEmptyHid(hid);
    maybeStopSyncTimer();
    return;
  }
  const entry = ensureEntry(target);
  if (entry == null) return;
  entry.buffs[buffID] = { buffID, remaining: state.remaining, effect: state.effect, source: "dot" };
  if (typeof target !== "number") entry.lastRef = target;
  ensureSyncTimer();
}

export function registerManualBuff(target: any, buffID: string, durationSec: number, effectValue: number): void {
  if (target == null || target === 0 || !buffID || durationSec <= 0) return;
  const entry = ensureEntry(target);
  if (entry == null) return;
  entry.buffs[buffID] = { buffID, remaining: durationSec, effect: effectValue, source: "manual" };
  ensureSyncTimer();
}

export function removeBuffById(target: any, buffID: string): void {
  const hid = toHid(target);
  if (hid === 0) return;
  const e = unitToBuffs[hid];
  if (e == null) return;
  delete e.buffs[buffID];
  pruneEmptyHid(hid);
  maybeStopSyncTimer();
}

export function clearAllBuffsOnUnit(target: any): void {
  const hid = toHid(target);
  if (hid === 0) return;
  delete unitToBuffs[hid];
  maybeStopSyncTimer();
}

export function isUnitInBuffPool(unit: any): boolean {
  const hid = toHid(unit);
  if (hid === 0) return false;
  const e = unitToBuffs[hid];
  if (e == null) return false;
  for (const _k in e.buffs) return true;
  return false;
}

export function getBuffIdsOnUnit(unit: any): string[] {
  const hid = toHid(unit);
  const out: string[] = [];
  const e = hid !== 0 ? unitToBuffs[hid] : null;
  if (e == null) return out;
  for (const k in e.buffs) out.push(k);
  return out;
}

export function getBuffRuntime(unit: any, buffID: string): BuffRuntime | null {
  const hid = toHid(unit);
  const e = hid !== 0 ? unitToBuffs[hid] : null;
  if (e == null) return null;
  const r = e.buffs[buffID];
  return r != null ? r : null;
}

function syncDotSnapshots(): void {
  const dotMod = require("系统.04．伤害系统.dot伤害") as {
    getUnitAntiHeal?: (u: any) => { effect: number; remaining: number } | null;
    getUnitBurn?: (u: any) => { effect: number; remaining: number } | null;
  };
  for (const hidKey in unitToBuffs) {
    const hid = toHid(hidKey);
    if (hid === 0) continue;
    const entry = unitToBuffs[hid];
    if (entry == null) continue;
    const unit = entry.lastRef;
    const tab = entry.buffs;
    if (tab["D001"] != null && tab["D001"].source === "dot") {
      const st = unit != null && dotMod.getUnitAntiHeal != null ? dotMod.getUnitAntiHeal(unit) : null;
      if (st == null) {
        delete tab["D001"];
      } else {
        tab["D001"].remaining = st.remaining;
        tab["D001"].effect = st.effect;
      }
    }
    if (tab["D002"] != null && tab["D002"].source === "dot") {
      const st = unit != null && dotMod.getUnitBurn != null ? dotMod.getUnitBurn(unit) : null;
      if (st == null) {
        delete tab["D002"];
      } else {
        tab["D002"].remaining = st.remaining;
        tab["D002"].effect = st.effect;
      }
    }
    pruneEmptyHid(hid);
  }
}

function tickManualAndSyncDot(): void {
  syncDotSnapshots();
  for (const hidKey in unitToBuffs) {
    const hid = toHid(hidKey);
    if (hid === 0) continue;
    const entry = unitToBuffs[hid];
    if (entry == null) continue;
    const tab = entry.buffs;
    for (const bid in tab) {
      const row = tab[bid];
      if (row == null || row.source !== "manual") continue;
      row.remaining = row.remaining - TICK;
      if (row.remaining <= 0) delete tab[bid];
    }
    pruneEmptyHid(hid);
  }
  maybeStopSyncTimer();
}

function ensureSyncTimer(): void {
  if (syncTimer != null) return;
  if (typeof (jass as any).CreateTimer !== "function" || typeof (jass as any).TimerStart !== "function") return;
  syncTimer = LeakWatcher.createTimer("buff_pool_sync");
  (jass as any).TimerStart(syncTimer, TICK, true, tickManualAndSyncDot);
}

function maybeStopSyncTimer(): void {
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

export function initBuffSystem(): void {}
