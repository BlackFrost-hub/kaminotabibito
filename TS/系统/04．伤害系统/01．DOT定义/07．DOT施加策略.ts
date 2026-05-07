/** @noSelfInFile */
import type { DotState, DotTypeConfig } from "./01．DOT配置";
import { clearIgnoredTarget, deleteDotState, getDotState, isIgnoredTarget, isValidDotStateRow, setDotState } from "./04．DOT工具";

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
  dotTicks: DotTickEntry[];
  unitHid: (this: void, u: any) => number;
  isSourceHeroPlayer1to4: (this: void, unit: any) => boolean;
  isDebuffDotTargetOk: (this: void, source: any, target: any) => boolean;
  getDotSourceDisplayName: (this: void, u: any) => string;
  notifyBuffPool: (this: void, typeId: string, target: any, state: DotState | null) => void;
  ensureDotTimers: (this: void) => void;
  getDotTickBatchTargetHids: (this: void) => Record<number, boolean> | null;
}): {
  tryApplyHeroAttackGearDots: (this: void, source: any, target: any, damage: number) => void;
  onDamage: (this: void, target: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttackHit?: boolean) => void;
} {
  // 提取 deps 到局部变量，避免 TSTL 生成冒号调用
  const dotTypes = deps.dotTypes;
  const dotTicks = deps.dotTicks;
  const unitHid = deps.unitHid;
  const isSourceHeroPlayer1to4 = deps.isSourceHeroPlayer1to4;
  const isDebuffDotTargetOk = deps.isDebuffDotTargetOk;
  const getDotSourceDisplayName = deps.getDotSourceDisplayName;
  const notifyBuffPool = deps.notifyBuffPool;
  const ensureDotTimers = deps.ensureDotTimers;
  const getDotTickBatchTargetHids = deps.getDotTickBatchTargetHids;

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
    for (let i = dotTicks.length - 1; i >= 0; i--) {
      const e = dotTicks[i];
      if (e.typeId === typeId && unitHid(e.target) === tgtHid) dotTicks.splice(i, 1);
    }
    dotTicks.push({
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
    cur.sourceName = getDotSourceDisplayName(source);
  }

  // ========== 虚拟分区：普攻施加策略 ==========
  function applyEquipmentDotOnHeroAttack(
    typeId: string,
    cfg: DotTypeConfig,
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
      notifyBuffPool(typeId, target, cur);
      // 写回扁平存储
      setDotState(typeId, tgtHid, cur);
    } else {
      const state: DotState = {
        effect: amount,
        remaining: bestDuration,
        _dotUnitRef: target,
        sourceName: getDotSourceDisplayName(source),
        _dotParsedDuration: bestDuration,
      };
      setDotState(typeId, tgtHid, state);
      pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
      notifyBuffPool(typeId, target, state);
      if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
    }
    ensureDotTimers();
  }

  // ========== 虚拟分区：非普攻施加策略 ==========
  function applyEquipmentDotOnNonAttack(
    typeId: string,
    cfg: DotTypeConfig,
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
        sourceName: getDotSourceDisplayName(source),
        _dotParsedDuration: bestDuration,
      };
      setDotState(typeId, tgtHid, state);
      pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
      notifyBuffPool(typeId, target, state);
      if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
      ensureDotTimers();
      return;
    }
    if (sameDurationTier(cur, bestDuration)) {
      fillDotStateRow(cur, target, source, amount, bestDuration);
      pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
      notifyBuffPool(typeId, target, cur);
      // 写回扁平存储
      setDotState(typeId, tgtHid, cur);
      ensureDotTimers();
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
      sourceName: getDotSourceDisplayName(source),
      _dotParsedDuration: bestDuration,
    };
    setDotState(typeId, tgtHid, state);
    pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
    notifyBuffPool(typeId, target, state);
    if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
    ensureDotTimers();
  }

  // ========== 虚拟分区：普攻装备入口 ==========
  function tryApplyHeroAttackGearDots(this: void, source: any, target: any, _damage: number): void {
    if (!target || !source) return;
    const isHeroSource = isSourceHeroPlayer1to4(source);
    if (!isHeroSource) return;
    const tgtHid = unitHid(target);
    for (let t = 0; t < dotTypes.length; t++) {
      const cfg = dotTypes[t];
      const typeId = cfg.id;
      const targetOk = !(cfg.debuffDotEnemyNoStructure === true) || isDebuffDotTargetOk(source, target);
      if (!targetOk) continue;
      const best = cfg.getBestFromUnit(source);
      if (best == null) continue;
      const amount = cfg.computeAmount(target, best);
      if (amount <= 0) continue;
      // 使用扁平化 API 获取当前状态
      const cur = getDotState(typeId, tgtHid);
      applyEquipmentDotOnHeroAttack(typeId, cfg, tgtHid, target, source, amount, best.duration, cur);
    }
  }

  // ========== 虚拟分区：伤害回调入口 ==========
  function onDamage(
    this: void,
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
    if (!isSourceHeroPlayer1to4(source)) return;

    const tgtHid = unitHid(target);
    const dotTickBatchTargetHids = getDotTickBatchTargetHids();
    const suppressDotApplyForBatch =
      fromDotTickBatch === true && dotTickBatchTargetHids != null && dotTickBatchTargetHids[tgtHid] === true && !isAttackHitForDot;

    for (let t = 0; t < dotTypes.length; t++) {
      const cfg = dotTypes[t];
      const typeId = cfg.id;
      // 使用扁平化 API 检查忽略目标
      if (isIgnoredTarget(typeId, tgtHid)) {
        clearIgnoredTarget(typeId, tgtHid);
        continue;
      }
      if (suppressDotApplyForBatch) continue;
      if (isAttackHitForDot) continue;
      if (cfg.debuffDotEnemyNoStructure === true && !isDebuffDotTargetOk(source, target)) continue;
      const best = cfg.getBestFromUnit(source);
      if (best == null) continue;
      if ((best as any).attackOnly === true || cfg.attackOnlyTrigger === true) {
        if (!isAttackHitForDot) continue;
      }
      const amount = cfg.computeAmount(target, best);
      if (amount <= 0) continue;

      // 使用扁平化 API 获取当前状态
      const cur = getDotState(typeId, tgtHid);

      if (isAttackHitForDot) {
        applyEquipmentDotOnHeroAttack(typeId, cfg, tgtHid, target, source, amount, best.duration, cur);
      } else {
        applyEquipmentDotOnNonAttack(typeId, cfg, tgtHid, target, source, amount, best.duration, cur);
      }
    }
  }

  // ========== 虚拟分区：对外导出 ==========
  return {
    tryApplyHeroAttackGearDots,
    onDamage,
  };
}

