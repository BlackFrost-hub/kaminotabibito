import type { DotState, DotTypeConfig } from "./01．DOT配置";

// ========== 虚拟分区：类型 ==========
interface DotTickEntry {
  typeId: string;
  source: any;
  target: any;
  amount: number;
  effectModel: string;
  effectDuration: number;
}

// ========== 虚拟分区：策略工厂 ==========
export function createDotApplyStrategy(deps: {
  dotTypes: DotTypeConfig[];
  stateByType: Record<string, Record<any, DotState>>;
  dotTicks: DotTickEntry[];
  ignoredTargetByType: Record<string, Record<any, boolean>>;
  unitHid: (u: any) => number;
  isSourceHeroPlayer1to4: (unit: any) => boolean;
  isDebuffDotTargetOk: (source: any, target: any) => boolean;
  tabRowForHid: (tab: Record<any, any>, hid: number) => any;
  tabSetHid: (tab: Record<any, any>, hid: number, state: DotState) => void;
  tabDeleteHid: (tab: Record<any, any>, hid: number) => void;
  isValidDotStateRow: (v: any) => boolean;
  getDotSourceDisplayName: (u: any) => string;
  notifyBuffPool: (typeId: string, target: any, state: DotState | null) => void;
  ensureDotTimers: () => void;
  getDotTickBatchTargetHids: () => Record<number, boolean> | null;
}): {
  tryApplyHeroAttackGearDots: (source: any, target: any, damage: number) => void;
  onDamage: (target: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttackHit?: boolean) => void;
} {
  // ========== 虚拟分区：常量 ==========
  const DURATION_TIER_EPS = 0.05;
  function abs(value: number): number {
    return value < 0 ? -value : value;
  }

  // ========== 虚拟分区：工具函数 ==========
  function sameDurationTier(cur: DotState, bestDuration: number): boolean {
    return cur._dotParsedDuration != null && abs(bestDuration - cur._dotParsedDuration) < DURATION_TIER_EPS;
  }

  // ========== 虚拟分区：tick 记录 ==========
  function pushDotTickForTarget(
    typeId: string,
    source: any,
    target: any,
    tgtHid: number,
    amount: number,
    _duration: number,
    cfg: DotTypeConfig
  ): void {
    for (let i = deps.dotTicks.length - 1; i >= 0; i--) {
      const e = deps.dotTicks[i];
      if (e.typeId === typeId && deps.unitHid(e.target) === tgtHid) deps.dotTicks.splice(i, 1);
    }
    deps.dotTicks.push({
      typeId,
      source,
      target,
      amount,
      effectModel: cfg.effectModel,
      effectDuration: cfg.effectDuration,
    });
  }

  // ========== 虚拟分区：状态填充 ==========
  function fillDotStateRow(cur: DotState, target: any, source: any, amount: number, bestDuration: number): void {
    cur.effect = amount;
    cur.remaining = bestDuration;
    cur._dotParsedDuration = bestDuration;
    (cur as any)._dotUnitRef = target;
    cur.sourceName = deps.getDotSourceDisplayName(source);
  }

  // ========== 虚拟分区：普攻施加策略 ==========
  function applyEquipmentDotOnHeroAttack(
    typeId: string,
    cfg: DotTypeConfig,
    tab: Record<any, any>,
    tgtHid: number,
    target: any,
    source: any,
    amount: number,
    bestDuration: number,
    cur: DotState | null
  ): void {
    if (cur != null) {
      fillDotStateRow(cur, target, source, amount, bestDuration);
      pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
      deps.notifyBuffPool(typeId, target, cur);
    } else {
      const state: DotState = {
        effect: amount,
        remaining: bestDuration,
        _dotUnitRef: target,
        sourceName: deps.getDotSourceDisplayName(source),
        _dotParsedDuration: bestDuration,
      };
      deps.tabSetHid(tab, tgtHid, state);
      pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
      deps.notifyBuffPool(typeId, target, state);
      if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
    }
    deps.ensureDotTimers();
  }

  // ========== 虚拟分区：非普攻施加策略 ==========
  function applyEquipmentDotOnNonAttack(
    typeId: string,
    cfg: DotTypeConfig,
    tab: Record<any, any>,
    tgtHid: number,
    target: any,
    source: any,
    amount: number,
    bestDuration: number,
    cur: DotState | null
  ): void {
    if (cur == null) {
      const state: DotState = {
        effect: amount,
        remaining: bestDuration,
        _dotUnitRef: target,
        sourceName: deps.getDotSourceDisplayName(source),
        _dotParsedDuration: bestDuration,
      };
      deps.tabSetHid(tab, tgtHid, state);
      pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
      deps.notifyBuffPool(typeId, target, state);
      if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
      deps.ensureDotTimers();
      return;
    }
    if (sameDurationTier(cur, bestDuration)) {
      fillDotStateRow(cur, target, source, amount, bestDuration);
      pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
      deps.notifyBuffPool(typeId, target, cur);
      deps.ensureDotTimers();
      return;
    }
    const currentProduct = cur.effect * cur.remaining;
    const newProduct = amount * bestDuration;
    if (newProduct <= currentProduct) return;
    if (typeof cfg.onEnd === "function") (cfg as any).onEnd(target, cur);
    const state: DotState = {
      effect: amount,
      remaining: bestDuration,
      _dotUnitRef: target,
      sourceName: deps.getDotSourceDisplayName(source),
      _dotParsedDuration: bestDuration,
    };
    deps.tabSetHid(tab, tgtHid, state);
    pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
    deps.notifyBuffPool(typeId, target, state);
    if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
    deps.ensureDotTimers();
  }

  // ========== 虚拟分区：普攻装备入口 ==========
  function tryApplyHeroAttackGearDots(source: any, target: any, _damage: number): void {
    if (!target || !source) return;
    if (!deps.isSourceHeroPlayer1to4(source)) return;
    const tgtHid = deps.unitHid(target);
    for (let t = 0; t < deps.dotTypes.length; t++) {
      const cfg = deps.dotTypes[t];
      const typeId = cfg.id;
      if (cfg.debuffDotEnemyNoStructure === true && !deps.isDebuffDotTargetOk(source, target)) continue;
      const best = cfg.getBestFromUnit(source);
      if (best == null) continue;
      const amount = cfg.computeAmount(target, best);
      if (amount <= 0) continue;
      if ((deps.stateByType as any)[typeId] == null) (deps.stateByType as any)[typeId] = {};
      const tab = (deps.stateByType as any)[typeId];
      const curRaw = deps.tabRowForHid(tab, tgtHid);
      let cur: DotState | null = deps.isValidDotStateRow(curRaw) ? (curRaw as DotState) : null;
      if (curRaw != null && cur == null) deps.tabDeleteHid(tab, tgtHid);
      applyEquipmentDotOnHeroAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
    }
  }

  // ========== 虚拟分区：伤害回调入口 ==========
  function onDamage(
    target: any,
    damage: number,
    _damageType: number,
    fromDotTickBatch?: boolean,
    source?: any,
    isNormalAttackHit?: boolean
  ): void {
    if (!target) return;
    const isAttackHitForDot = isNormalAttackHit === true;
    if (damage <= 0 && !isAttackHitForDot) return;
    if (!source) return;
    if (!deps.isSourceHeroPlayer1to4(source)) return;

    const tgtHid = deps.unitHid(target);
    const dotTickBatchTargetHids = deps.getDotTickBatchTargetHids();
    const suppressDotApplyForBatch =
      fromDotTickBatch === true && dotTickBatchTargetHids != null && dotTickBatchTargetHids[tgtHid] === true && !isAttackHitForDot;

    for (let t = 0; t < deps.dotTypes.length; t++) {
      const cfg = deps.dotTypes[t];
      const typeId = cfg.id;
      if ((deps.ignoredTargetByType as any)[typeId] != null && (deps.ignoredTargetByType as any)[typeId][tgtHid] === true) {
        delete (deps.ignoredTargetByType as any)[typeId][tgtHid];
        continue;
      }
      if (suppressDotApplyForBatch) continue;
      if (isAttackHitForDot) continue;
      if (cfg.debuffDotEnemyNoStructure === true && !deps.isDebuffDotTargetOk(source, target)) continue;
      const best = cfg.getBestFromUnit(source);
      if (best == null) continue;
      if ((best as any).attackOnly === true || cfg.attackOnlyTrigger === true) {
        if (!isAttackHitForDot) continue;
      }
      const amount = cfg.computeAmount(target, best);
      if (amount <= 0) continue;

      if ((deps.stateByType as any)[typeId] == null) (deps.stateByType as any)[typeId] = {};
      const tab = (deps.stateByType as any)[typeId];
      const curRaw = deps.tabRowForHid(tab, tgtHid);
      let cur: DotState | null = deps.isValidDotStateRow(curRaw) ? (curRaw as DotState) : null;
      if (curRaw != null && cur == null) deps.tabDeleteHid(tab, tgtHid);

      if (isAttackHitForDot) {
        applyEquipmentDotOnHeroAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
      } else {
        applyEquipmentDotOnNonAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
      }
    }
  }

  // ========== 虚拟分区：对外导出 ==========
  return {
    tryApplyHeroAttackGearDots,
    onDamage,
  };
}

