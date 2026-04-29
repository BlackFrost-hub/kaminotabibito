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
  // 提取 deps 到局部变量，避免 TSTL 生成冒号调用
  const jass = deps.jass;
  const g = deps.g;
  const itemsData = deps.itemsData;
  const fourCCToString = deps.fourCCToString;

  // ========== 虚拟分区：目标合法性判断 ==========
  function getStructureUnitTypeHandle(): any {
    const direct = jass.UNIT_TYPE_STRUCTURE ?? g.UNIT_TYPE_STRUCTURE;
    if (direct != null) return direct;
    if (typeof jass.ConvertUnitType === "function") return jass.ConvertUnitType(64);
    return null;
  }

  function isDebuffDotTargetOk(source: any, target: any): boolean {
    if (source == null || target == null || target === 0) return false;
    const utStruct = getStructureUnitTypeHandle();
    if (utStruct != null) {
      if (jass.IsUnitType(target, utStruct) === true) return false;
    }
    const srcP = jass.GetOwningPlayer(source);
    if (srcP == null) return false;
    return jass.IsUnitEnemy(target, srcP) === true;
  }

  function heroUnitTypeForIsUnitType(): any {
    const direct = jass.UNIT_TYPE_HERO ?? g.UNIT_TYPE_HERO;
    if (direct != null) return direct;
    return jass.ConvertUnitType(2);
  }

  function isSourceHeroPlayer1to4(unit: any): boolean {
    if (!unit) return false;
    const owner = jass.GetOwningPlayer(unit);
    let playerIdx = -1;
    for (let i = 0; i <= 15; i++) {
      if (jass.Player(i) === owner) {
        playerIdx = i;
        break;
      }
    }
    if (playerIdx < 0 || playerIdx > 3) return false;
    const utHero = heroUnitTypeForIsUnitType();
    if (utHero != null && jass.IsUnitType(unit, utHero) === true) return true;
    if (jass.GetHeroLevel(unit) > 0) return true;
    return false;
  }

  // ========== 虚拟分区：装备读取 ==========
  function unitItemInSlot(unit: any, slot: number): any {
    return jass.UnitItemInSlot(unit, slot);
  }

  function getItemTypeId(item: any): number {
    return jass.GetItemTypeId(item);
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
      const idStr = fourCCToString(getItemTypeId(item));
      const entry = itemsData[idStr];
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
    const m = jass.BlzGetUnitMaxHP(targetUnit);
    if (typeof m === "number" && isFinite(m) && m > 0) return m;
    let maxLifeState: any = null;
    if (jass.UNIT_STATE_MAX_LIFE != null) maxLifeState = jass.UNIT_STATE_MAX_LIFE;
    else if (g.UNIT_STATE_MAX_LIFE != null) maxLifeState = g.UNIT_STATE_MAX_LIFE;
    else maxLifeState = jass.ConvertUnitState(1);
    if (maxLifeState == null) return 0;
    const v = jass.GetUnitState(targetUnit, maxLifeState);
    return typeof v === "number" && isFinite(v) && v > 0 ? v : 0;
  }

  function getTargetRegenHP(targetUnit: any): number {
    if (!targetUnit) return 0;
    const typeId = jass.GetUnitTypeId(targetUnit);
    const idStr = fourCCToString(typeId);
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

