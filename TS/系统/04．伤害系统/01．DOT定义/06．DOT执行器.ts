import type { DotState, DotTypeConfig } from "./01．DOT配置";
import { clearIgnoredTarget, getDotState, isIgnoredTarget, isValidDotStateRow, setIgnoredTarget } from "./04．DOT工具";
import { DOT_TYPE_TO_BUFF_ID, getBuffRuntimeByHid } from "../../05．Buff系统/00．Buff系统";
import { 计算持续伤害最终值 } from "../07．持续伤害系统";
import { 造成装备技能伤害 } from "../08．技能伤害系统";

const unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as { IsUnitPausedBJ?: (unit: any) => boolean };
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (duration: number, effect: any) => void;
};

/** DOT 秒跳目标被 `PauseUnit` 暂停时不结算伤害/特效/onTick（与 Buff 池不计时一致） */
// pcall 具名函数体模式：禁止 (pcall as any)(匿名)，避免 TSTL 生成 pcall(nil, func)
let __pcallPausedUnit: any = 0;
let __pcallPausedResult = false;
function __pcallIsUnitPausedBody(): void {
  const fn = unitBjExt.IsUnitPausedBJ;
  if (fn != null) __pcallPausedResult = fn(__pcallPausedUnit) === true;
}
function isDotTargetPaused(u: any): boolean {
  if (u == null || u === 0) return false;
  const fn = unitBjExt.IsUnitPausedBJ;
  if (fn == null) return false;
  __pcallPausedUnit = u;
  __pcallPausedResult = false;
  pcall(__pcallIsUnitPausedBody);
  return __pcallPausedResult;
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
  damageEventModule: { markNextPendingDamageAsDotTickBatch?: () => void };
  unitHid: (u: any) => number;
}): {
  ensureDotTimers: () => void;
  dealDamageForType: (typeId: string, source: any, target: any, amount: number) => void;
  notifyDotTickBatchDamageDisplayed: () => void;
  getDotTickBatchTargetHids: () => Record<number, boolean> | null;
} {
  // 提取 deps 到局部变量，避免 TSTL 生成冒号调用
  const jass = deps.jass;
  const LeakWatcher = deps.LeakWatcher;
  const dotTypes = deps.dotTypes;
  const dotTicks = deps.dotTicks;
  const unitHid = deps.unitHid;
  const damageEventModule = deps.damageEventModule;

  // ========== 虚拟分区：内部状态 ==========
  let dotTimer: any = undefined;
  let dotTickBatchTargetHids: Record<number, boolean> | null = null;
  let dotBatchSnapForClear: Record<number, boolean> | null = null;
  let dotBatchDeferredRemaining = 0;

  // ========== 虚拟分区：特效回收 ==========
  function addDotEffectOnUnit(unit: any, model: string, duration: number): void {
    if (!unit || !model || model === "") return;
    const eff = jass.AddSpecialEffectTarget(model, unit, "origin");
    if (eff == null) return;
    YDWETimerDestroyEffect(duration, eff);
  }

  // ========== 虚拟分区：造成 DOT 伤害 ==========
  function dealDamageForType(typeId: string, source: any, target: any, amount: number): void {
    if (isDotTargetPaused(target)) return;
    const cfg = dotTypes.find(c => c.id === typeId);
    if (cfg == null) return;
    const finalAmount = 计算持续伤害最终值(source, amount);
    if (!(finalAmount > 0)) return;
    const dh = unitHid(target);
    // 使用扁平化 API 设置忽略目标
    for (let di = 0; di < dotTypes.length; di++) {
      const tid = dotTypes[di].id;
      setIgnoredTarget(tid, dh);
    }
    if (typeof damageEventModule.markNextPendingDamageAsDotTickBatch === "function") {
      damageEventModule.markNextPendingDamageAsDotTickBatch();
    }
    造成装备技能伤害({
      来源: source,
      目标: target,
      伤害: finalAmount,
      伤害类型: cfg.damageType,
      attack: false,
      ranged: false,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      装备技能类型: "装备持续伤害",
      伤害形态: "单体",
    });
    for (let ci = 0; ci < dotTypes.length; ci++) {
      clearIgnoredTarget(dotTypes[ci].id, dh);
    }
  }

  // ========== 虚拟分区：每秒 tick 执行 ==========
  function dotTickRun(): void {
    for (let i = dotTicks.length - 1; i >= 0; i--) {
      const e = dotTicks[i];
      const eh = unitHid(e.target);
      const bid = (DOT_TYPE_TO_BUFF_ID as any)[e.typeId] as string | undefined;
      const rt = bid != null && bid !== "" ? getBuffRuntimeByHid(eh, bid) : null;
      if (rt == null || rt.remaining <= 0.001) dotTicks.splice(i, 1);
    }
    const toRun: DotTickEntry[] = [];
    for (let i = dotTicks.length - 1; i >= 0; i--) {
      const e = dotTicks[i];
      if (!isDotTargetPaused(e.target)) toRun.push(e);
    }
    const batch: Record<number, boolean> = {};
    for (let bi = 0; bi < toRun.length; bi++) {
      const bh = unitHid(toRun[bi].target);
      if (bh !== 0) batch[bh] = true;
    }
    const batchSnap = batch;
    dotTickBatchTargetHids = batchSnap;
    const nDeals = toRun.length;
    dotBatchSnapForClear = batchSnap;
    dotBatchDeferredRemaining = nDeals;
    for (let ri = 0; ri < toRun.length; ri++) {
      const e = toRun[ri];
      const eh = unitHid(e.target);
      dealDamageForType(e.typeId, e.source, e.target, e.amount);
      addDotEffectOnUnit(e.target, e.effectModel, e.effectDuration);
      const cfg = dotTypes.find(c => c.id === e.typeId);
      // 使用扁平化 API 获取状态
      const state = getDotState(e.typeId, eh);
      if (cfg != null && typeof (cfg as any).onTick === "function" && state != null) (cfg as any).onTick(e.target, state);
    }
    if (nDeals <= 0) {
      dotTickBatchTargetHids = null;
      dotBatchSnapForClear = null;
      dotBatchDeferredRemaining = 0;
    }
    if (dotTicks.length === 0 && dotTimer != null) {
      LeakWatcher.destroyTimer(dotTimer);
      dotTimer = undefined;
    }
  }

  // ========== 虚拟分区：计时器保障（使用中心计时器） ==========
  let _registeredToCenterTimer = false;

  function ensureDotTimers(): void {
    if (_registeredToCenterTimer) return;
    _registeredToCenterTimer = true;

    // 走核心系统挂到 globalThis 的桥，避免 TSTL 把 require 对象字段函数编成少参调用
    const { onSecond } = globalThis as unknown as {
      onSecond: (this: void, callback: () => void) => void;
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

