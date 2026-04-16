import { splitItemBuffSegments } from "./02．DOT解析";

// ========== 虚拟分区：工厂 ==========
export function createDotBaseUtils(deps: {
  jass: any;
  g: any;
  itemsData: Record<string, { Buff?: string }>;
  fourCCToString: (four: number) => string;
}): {
  isDebuffDotTargetOk: (source: any, target: any) => boolean;
  isSourceHeroPlayer1to4: (unit: any) => boolean;
  getBestDotFromUnit: <T extends { duration: number; attackOnly: boolean }>(
    unit: any,
    parseBuff: (s: string) => T | null,
    getProduct: (parsed: T) => number
  ) => T | null;
  getUnitMaxHp: (targetUnit: any) => number;
  getTargetRegenHP: (targetUnit: any) => number;
} {
  // ========== 虚拟分区：目标合法性判断 ==========
  function getStructureUnitTypeHandle(): any {
    const direct = deps.jass.UNIT_TYPE_STRUCTURE ?? deps.g.UNIT_TYPE_STRUCTURE;
    if (direct != null) return direct;
    if (typeof deps.jass.ConvertUnitType === "function") return deps.jass.ConvertUnitType(64);
    return null;
  }

  function isDebuffDotTargetOk(source: any, target: any): boolean {
    if (source == null || target == null || target === 0) return false;
    const utStruct = getStructureUnitTypeHandle();
    if (typeof deps.jass.IsUnitType === "function" && utStruct != null) {
      if (deps.jass.IsUnitType(target, utStruct) === true) return false;
    }
    if (typeof deps.jass.GetOwningPlayer !== "function") return false;
    const srcP = deps.jass.GetOwningPlayer(source);
    if (srcP == null) return false;
    if (typeof deps.jass.IsUnitEnemy === "function") {
      return deps.jass.IsUnitEnemy(target, srcP) === true;
    }
    if (typeof deps.jass.IsPlayerEnemy === "function") {
      const tp = deps.jass.GetOwningPlayer(target);
      if (tp != null) return deps.jass.IsPlayerEnemy(srcP, tp) === true;
    }
    return false;
  }

  function heroUnitTypeForIsUnitType(): any {
    const direct = deps.jass.UNIT_TYPE_HERO ?? deps.g.UNIT_TYPE_HERO;
    if (direct != null) return direct;
    if (typeof deps.jass.ConvertUnitType !== "function") return undefined;
    return deps.jass.ConvertUnitType(2);
  }

  function isSourceHeroPlayer1to4(unit: any): boolean {
    if (!unit || typeof deps.jass.GetOwningPlayer !== "function") return false;
    const hasIsUnitType = typeof deps.jass.IsUnitType === "function";
    const hasHeroLevel = typeof deps.jass.GetHeroLevel === "function";
    if (!hasIsUnitType && !hasHeroLevel) return false;
    const owner = deps.jass.GetOwningPlayer(unit);
    let playerIdx = -1;
    for (let i = 0; i <= 15; i++) {
      if (deps.jass.Player(i) === owner) {
        playerIdx = i;
        break;
      }
    }
    if (playerIdx < 0 || playerIdx > 3) return false;
    const utHero = heroUnitTypeForIsUnitType();
    if (hasIsUnitType && utHero != null && deps.jass.IsUnitType(unit, utHero) === true) return true;
    if (hasHeroLevel && deps.jass.GetHeroLevel(unit) > 0) return true;
    return false;
  }

  // ========== 虚拟分区：装备读取 ==========
  function unitItemInSlot(unit: any, slot: number): any {
    if (typeof deps.jass.UnitItemInSlot !== "function") return null;
    return deps.jass.UnitItemInSlot(unit, slot);
  }

  function getItemTypeId(item: any): number {
    if (typeof deps.jass.GetItemTypeId !== "function") return 0;
    return deps.jass.GetItemTypeId(item);
  }

  function getBestDotFromUnit<T extends { duration: number; attackOnly: boolean }>(
    unit: any,
    parseBuff: (s: string) => T | null,
    getProduct: (parsed: T) => number
  ): T | null {
    let best: (T & { product: number }) | null = null;
    for (let slot = 0; slot <= 5; slot++) {
      const item = unitItemInSlot(unit, slot);
      if (!item) continue;
      const idStr = deps.fourCCToString(getItemTypeId(item));
      const entry = deps.itemsData[idStr];
      const segments = entry?.Buff != null ? splitItemBuffSegments(entry.Buff) : [];
      for (let si = 0; si < segments.length; si++) {
        const parsed = parseBuff(segments[si]);
        if (!parsed) continue;
        const product = getProduct(parsed);
        if (best == null || product > best.product) {
          best = { ...parsed, product };
        }
      }
    }
    if (best == null) return null;
    const { product, ...result } = best;
    return result as unknown as T;
  }

  // ========== 虚拟分区：数值读取 ==========
  function getUnitMaxHp(targetUnit: any): number {
    if (!targetUnit) return 0;
    if (typeof deps.jass.BlzGetUnitMaxHP === "function") {
      const m = deps.jass.BlzGetUnitMaxHP(targetUnit);
      if (typeof m === "number" && isFinite(m) && m > 0) return m;
    }
    if (typeof deps.jass.GetUnitState !== "function") return 0;
    let maxLifeState: any = null;
    if (deps.jass.UNIT_STATE_MAX_LIFE != null) maxLifeState = deps.jass.UNIT_STATE_MAX_LIFE;
    else if (deps.g.UNIT_STATE_MAX_LIFE != null) maxLifeState = deps.g.UNIT_STATE_MAX_LIFE;
    else if (typeof deps.jass.ConvertUnitState === "function") maxLifeState = deps.jass.ConvertUnitState(1);
    if (maxLifeState == null) return 0;
    const v = deps.jass.GetUnitState(targetUnit, maxLifeState);
    return typeof v === "number" && isFinite(v) && v > 0 ? v : 0;
  }

  function getTargetRegenHP(targetUnit: any): number {
    if (typeof deps.jass.GetUnitTypeId !== "function" || !targetUnit) return 0;
    const typeId = deps.jass.GetUnitTypeId(targetUnit);
    const idStr = deps.fourCCToString(typeId);
    const slk = (globalThis as any).slk as { unit?: Record<string, Record<string, string>> } | undefined;
    const slkUnit = slk != null && slk.unit ? slk.unit[idStr] : undefined;
    if (slkUnit == null) return 0;
    const regenStr = slkUnit.regenHP ?? slkUnit["regenHP"];
    if (regenStr == null || typeof regenStr !== "string") return 0;
    const n = parseFloat(regenStr);
    return typeof n === "number" && !isNaN(n) ? n : 0;
  }

  return {
    isDebuffDotTargetOk,
    isSourceHeroPlayer1to4,
    getBestDotFromUnit,
    getUnitMaxHp,
    getTargetRegenHP,
  };
}

