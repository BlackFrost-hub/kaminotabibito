import type { DotState, DotTypeConfig } from "./01．DOT配置";

const unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as { IsUnitPausedBJ?: (unit: any) => boolean };
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (duration: number, effect: any) => void;
};

/** DOT 秒跳目标被 `PauseUnit` 暂停时不结算伤害/特效/onTick（与 Buff 池不计时一致） */
function isDotTargetPaused(u: any): boolean {
  if (u == null || u === 0) return false;
  const fn = unitBjExt.IsUnitPausedBJ;
  if (fn == null) return false;
  let paused = false;
  (pcall as any)(() => {
    paused = fn(u) === true;
  });
  return paused;
}

// ========== 虚拟分区：类型 ==========
interface DotTickEntry {
  typeId: string;
  source: any;
  target: any;
  amount: number;
  effectModel: string;
  effectDuration: number;
}

// ========== 虚拟分区：执行器工厂 ==========
export function createDotExecutor(deps: {
  jass: any;
  LeakWatcher: any;
  dotTypes: DotTypeConfig[];
  dotTicks: DotTickEntry[];
  stateByType: Record<string, Record<any, DotState>>;
  ignoredTargetByType: Record<string, Record<any, boolean>>;
  damageEventModule: { markNextPendingDamageAsDotTickBatch?: () => void };
  unitHid: (u: any) => number;
  tabRowForHid: (tab: Record<any, any>, hid: number) => any;
  isValidDotStateRow: (v: any) => boolean;
}): {
  ensureDotTimers: () => void;
  dealDamageForType: (typeId: string, source: any, target: any, amount: number) => void;
  notifyDotTickBatchDamageDisplayed: () => void;
  getDotTickBatchTargetHids: () => Record<number, boolean> | null;
} {
  // ========== 虚拟分区：内部状态 ==========
  let dotTimer: any = undefined;
  let dotTickBatchTargetHids: Record<number, boolean> | null = null;
  let dotBatchSnapForClear: Record<number, boolean> | null = null;
  let dotBatchDeferredRemaining = 0;

  // ========== 虚拟分区：特效回收 ==========
  function addDotEffectOnUnit(unit: any, model: string, duration: number): void {
    if (!unit || !model || model === "") return;
    const eff = deps.jass.AddSpecialEffectTarget(model, unit, "origin");
    if (eff == null) return;
    YDWETimerDestroyEffect(duration, eff);
  }

  // ========== 虚拟分区：造成 DOT 伤害 ==========
  function dealDamageForType(typeId: string, source: any, target: any, amount: number): void {
    if (isDotTargetPaused(target)) return;
    const cfg = deps.dotTypes.find(c => c.id === typeId);
    if (cfg == null) return;
    const dh = deps.unitHid(target);
    for (let di = 0; di < deps.dotTypes.length; di++) {
      const tid = deps.dotTypes[di].id;
      if ((deps.ignoredTargetByType as any)[tid] == null) (deps.ignoredTargetByType as any)[tid] = {};
      (deps.ignoredTargetByType as any)[tid][dh] = true;
    }
    if (typeof deps.damageEventModule.markNextPendingDamageAsDotTickBatch === "function") {
      deps.damageEventModule.markNextPendingDamageAsDotTickBatch();
    }
    deps.jass.UnitDamageTarget(
      source,
      target,
      amount,
      false,
      false,
      deps.jass.ATTACK_TYPE_NORMAL,
      cfg.damageType,
      deps.jass.WEAPON_TYPE_WHOKNOWS
    );
  }

  // ========== 虚拟分区：每秒 tick 执行 ==========
  function dotTickRun(): void {
    const buffM = require("系统.05．Buff系统.00．Buff系统") as {
      getBuffRuntimeByHid?: (hid: number, buffID: string) => { remaining: number } | null;
      DOT_TYPE_TO_BUFF_ID?: Record<string, string>;
    };
    for (let i = deps.dotTicks.length - 1; i >= 0; i--) {
      const e = deps.dotTicks[i];
      const eh = deps.unitHid(e.target);
      const bid =
        buffM.DOT_TYPE_TO_BUFF_ID != null ? ((buffM.DOT_TYPE_TO_BUFF_ID as any)[e.typeId] as string | undefined) : undefined;
      const rt =
        bid != null && bid !== "" && typeof buffM.getBuffRuntimeByHid === "function" ? buffM.getBuffRuntimeByHid(eh, bid) : null;
      if (rt == null || rt.remaining <= 0.001) deps.dotTicks.splice(i, 1);
    }
    const toRun: DotTickEntry[] = [];
    for (let i = deps.dotTicks.length - 1; i >= 0; i--) {
      const e = deps.dotTicks[i];
      if (!isDotTargetPaused(e.target)) toRun.push(e);
    }
    const batch: Record<number, boolean> = {};
    for (let bi = 0; bi < toRun.length; bi++) {
      const bh = deps.unitHid(toRun[bi].target);
      if (bh !== 0) batch[bh] = true;
    }
    const batchSnap = batch;
    dotTickBatchTargetHids = batchSnap;
    const nDeals = toRun.length;
    dotBatchSnapForClear = batchSnap;
    dotBatchDeferredRemaining = nDeals;
    for (let ri = 0; ri < toRun.length; ri++) {
      const e = toRun[ri];
      const eh = deps.unitHid(e.target);
      dealDamageForType(e.typeId, e.source, e.target, e.amount);
      addDotEffectOnUnit(e.target, e.effectModel, e.effectDuration);
      const cfg = deps.dotTypes.find(c => c.id === e.typeId);
      const stTab = (deps.stateByType as any)[e.typeId];
      const stateRaw = stTab != null ? deps.tabRowForHid(stTab, eh) ?? (stTab as any)[e.target] : null;
      const state = deps.isValidDotStateRow(stateRaw) ? (stateRaw as DotState) : null;
      if (cfg != null && typeof (cfg as any).onTick === "function" && state != null) (cfg as any).onTick(e.target, state);
    }
    if (nDeals <= 0) {
      dotTickBatchTargetHids = null;
      dotBatchSnapForClear = null;
      dotBatchDeferredRemaining = 0;
    }
    if (deps.dotTicks.length === 0 && dotTimer != null) {
      deps.LeakWatcher.destroyTimer(dotTimer);
      dotTimer = undefined;
    }
  }

  // ========== 虚拟分区：计时器保障（使用中心计时器） ==========
  let _registeredToCenterTimer = false;

  function ensureDotTimers(): void {
    if (_registeredToCenterTimer) return;
    _registeredToCenterTimer = true;

    // 使用中心计时器的每秒回调
    const { onSecond } = require("系统.00．核心系统.05．中心计时器") as {
      onSecond: (callback: () => void) => void;
    };
    onSecond(dotTickRun);
  }

  // ========== 虚拟分区：批次清理通知 ==========
  function notifyDotTickBatchDamageDisplayed(): void {
    if (dotBatchDeferredRemaining <= 0) return;
    dotBatchDeferredRemaining -= 1;
    if (dotBatchDeferredRemaining <= 0) {
      if (dotTickBatchTargetHids != null && dotTickBatchTargetHids === dotBatchSnapForClear) dotTickBatchTargetHids = null;
      dotBatchSnapForClear = null;
      dotBatchDeferredRemaining = 0;
    }
  }

  // ========== 虚拟分区：对外读 batch ==========
  function getDotTickBatchTargetHids(): Record<number, boolean> | null {
    return dotTickBatchTargetHids;
  }

  return {
    ensureDotTimers,
    dealDamageForType,
    notifyDotTickBatchDamageDisplayed,
    getDotTickBatchTargetHids,
  };
}

