/**
 * Buff 池 / Buff 系统框架（`00` 前缀便于在 `05．Buff系统` 目录内统一排序管理）
 *
 * - **DOT（D001–D004）剩余时间由本模块以固定步长递减**；`dot伤害` 施加/刷新时 `syncDotBuff` 写入满额 remaining，不在此用 `getUnitPoison` 回写覆盖。
 * - 非 DOT 的 `manual` 条同样由本计时器递减。
 * - 每 tick 末调用 `dot伤害.syncDotRemainingFromBuffPool`，使逻辑层 `stateByType` 与池一致。
 * - **单位被 `PauseUnit` 暂停时**（`IsUnitPausedBJ`）：该单位在池内所有 Buff **不扣** `remaining`，与引擎时间冻结一致；恢复暂停后照常递减。
 */

const jass = require("jass.common") as Record<string, unknown>;
const unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as { IsUnitPausedBJ?: (unit: any) => boolean };
const leakCore = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher?: any };
const LeakWatcher = leakCore.LeakWatcher ?? leakCore;

/** Buff 条剩余秒数递减步长（与 UI 刷新粒度一致，0.1s） */
export const BUFF_POOL_TICK = 0.1;

/** dot伤害 里的 typeId → 01．Buff表 buffID */
export const DOT_TYPE_TO_BUFF_ID: Record<string, string> = {
  antiHeal: "D001",
  burn: "D002",
  poison: "D003",
  /** 与 `01．Buff表` D004 对应；`dot伤害` 注册同名 typeId 后 syncDotBuff 才会写入 */
  trollCurse: "D004",
};

export interface BuffRuntime {
  buffID: string;
  remaining: number;
  effect: number;
  source: "dot" | "manual";
  /** 来源单位名称 */
  sourceName?: string;
  _dotParsedDuration?: number;
  /** JASS 桥接：覆盖 01．Buff表 图标（非空则 Buff 条用此路径） */
  iconOverride?: string;
  /** 预留：与桥接传入的特效路径一致（可用于后续挂点逻辑） */
  effectModelOverride?: string;
}

interface UnitBuffEntry {
  lastRef: any;
  buffs: Record<string, BuffRuntime>;
}

/** GetHandleId → 数据（Lua 下勿直接用 unit 作键） */
const unitToBuffs: Record<number, UnitBuffEntry> = {};
let syncTimer: any = undefined;

/** 与 `PauseUnit` 一致：暂停中的单位 Buff 池不计时（由中心计时器驱动，见 `tickBuffPool`） */
function isBuffPoolUnitPaused(u: any): boolean {
  if (u == null || u === 0) return false;
  const fn = unitBjExt.IsUnitPausedBJ;
  if (fn == null) return false;
  let paused = false;
  (pcall as any)(() => {
    paused = fn(u) === true;
  });
  return paused;
}

function toHid(u: any): number {
  if (u == null || u === 0) return 0;
  if (typeof u === "number") return u;
  if (typeof u === "string") {
    const n = parseInt(u, 10);
    return isNaN(n) ? 0 : n;
  }
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

function notifyDotBuffExpiredFromPool(buffID: string, hid: number): void {
  (pcall as any)(() => {
    const m = require("系统.04．伤害系统.02．dot伤害") as { clearDotByBuffPoolExpire: (bid: string, h: number) => void };
    if (m != null) m.clearDotByBuffPoolExpire(buffID, hid);
  });
}

function syncDotFromPoolTick(): void {
  (pcall as any)(() => {
    const m = require("系统.04．伤害系统.02．dot伤害") as { syncDotRemainingFromBuffPool: () => void };
    if (m != null) m.syncDotRemainingFromBuffPool();
  });
}

/**
 * 由 dot伤害 调用：施加、覆盖或到期清除。
 * target 可为单位或 **GetHandleId**。
 * state 为 null 表示该 DOT 类型在该单位上已结束。
 */
export function syncDotBuff(
  typeId: string,
  target: any,
  state: { effect: number; remaining: number; sourceName?: string; _dotParsedDuration?: number } | null
): void {
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
  entry.buffs[buffID] = {
    buffID,
    remaining: state.remaining,
    effect: state.effect,
    source: "dot",
    sourceName: state.sourceName,
    _dotParsedDuration: state._dotParsedDuration,
  };
  if (typeof target !== "number") entry.lastRef = target;
  ensureSyncTimer();
}

/** 手动 Buff 的可选展示字段（JASS 桥接、技能脚本） */
export interface RegisterManualBuffExtras {
  sourceName?: string;
  iconOverride?: string;
  effectModelOverride?: string;
}

export function registerManualBuff(
  target: any,
  buffID: string,
  durationSec: number,
  effectValue: number,
  extras?: RegisterManualBuffExtras
): void {
  if (target == null || target === 0 || !buffID || durationSec <= 0) return;
  const entry = ensureEntry(target);
  if (entry == null) return;
  const row: BuffRuntime = { buffID, remaining: durationSec, effect: effectValue, source: "manual" };
  if (extras != null) {
    if (extras.sourceName !== undefined && extras.sourceName !== "") row.sourceName = extras.sourceName;
    if (extras.iconOverride !== undefined && extras.iconOverride !== "") row.iconOverride = extras.iconOverride;
    if (extras.effectModelOverride !== undefined && extras.effectModelOverride !== "")
      row.effectModelOverride = extras.effectModelOverride;
  }
  entry.buffs[buffID] = row;
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
  return getBuffRuntimeByHid(hid, buffID);
}

export function getBuffRuntimeByHid(hid: number, buffID: string): BuffRuntime | null {
  if (hid === 0) return null;
  const e = unitToBuffs[hid];
  if (e == null) return null;
  const r = e.buffs[buffID];
  return r != null ? r : null;
}

/** 图标底部剩余秒数：与池内 `remaining` 一致（无假层） */
export function getDotIconDisplayRemaining(_unit: any, _buffID: string, realRemaining: number): number {
  return typeof realRemaining === "number" && isFinite(realRemaining) ? realRemaining : 0;
}

function tickBuffPool(): void {
  for (const hidKey in unitToBuffs) {
    const hid = toHid(hidKey);
    if (hid === 0) continue;
    const entry = unitToBuffs[hid];
    if (entry == null) continue;
    if (isBuffPoolUnitPaused(entry.lastRef)) continue;
    const tab = entry.buffs;
    const expired: string[] = [];
    for (const bid in tab) {
      const row = tab[bid];
      if (row == null) continue;
      row.remaining = row.remaining - BUFF_POOL_TICK;
      if (row.remaining <= 0) {
        if (row.source === "dot") notifyDotBuffExpiredFromPool(bid, hid);
        expired.push(bid);
      }
    }
    for (let ei = 0; ei < expired.length; ei++) delete tab[expired[ei]];
    pruneEmptyHid(hid);
  }
  syncDotFromPoolTick();
  maybeStopSyncTimer();
}

/** 是否已注册到中心计时器 */
let _registeredToCenterTimer = false;
/** tick计数器（每10个10毫秒=0.1秒执行一次） */
let _tickCounter = 0;

function ensureSyncTimer(): void {
  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

  // 使用中心计时器的每10毫秒回调
const { onTick10ms } = globalThis as unknown as {
    onTick10ms: (callback: () => void) => void;
  };

  onTick10ms(() => {
    _tickCounter = _tickCounter + 1;
    if (_tickCounter >= 10) {  // 10 * 10ms = 100ms = 0.1秒
      _tickCounter = 0;
      tickBuffPool();
    }
  });
}

function maybeStopSyncTimer(): void {
  // 使用中心计时器后无法停止，但可以通过检查是否有buff来决定是否执行逻辑
  // 这个函数保留用于兼容性
}

export function initBuffSystem(): void {}
