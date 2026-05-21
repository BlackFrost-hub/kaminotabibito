import { splitItemBuffSegments } from "./02．DOT解析";
// ========== 虚拟分区：工厂 ==========
export function createDotBaseUtils(deps) {
    // 提取 deps 到局部变量，避免 TSTL 生成冒号调用
    const jass = deps.jass;
    const g = deps.g;
    const itemsData = deps.itemsData;
    const fourCCToString = deps.fourCCToString;
    const GetItemTypeId = jass.GetItemTypeId;
    const GetUnitTypeId = jass.GetUnitTypeId;
    // ========== 虚拟分区：目标合法性判断 ==========
    function getStructureUnitTypeHandle() {
        const direct = jass.UNIT_TYPE_STRUCTURE ?? g.UNIT_TYPE_STRUCTURE;
        if (direct != null)
            return direct;
        if (typeof jass.ConvertUnitType === "function")
            return jass.ConvertUnitType(64);
        return null;
    }
    function isDebuffDotTargetOk(source, target) {
        if (source == null || target == null || target === 0)
            return false;
        const utStruct = getStructureUnitTypeHandle();
        if (utStruct != null) {
            if (jass.IsUnitType(target, utStruct) === true)
                return false;
        }
        const srcP = jass.GetOwningPlayer(source);
        if (srcP == null)
            return false;
        return jass.IsUnitEnemy(target, srcP) === true;
    }
    function heroUnitTypeForIsUnitType() {
        const direct = jass.UNIT_TYPE_HERO ?? g.UNIT_TYPE_HERO;
        if (direct != null)
            return direct;
        return jass.ConvertUnitType(2);
    }
    function isSourceHeroPlayer1to4(unit) {
        if (!unit)
            return false;
        const owner = jass.GetOwningPlayer(unit);
        let playerIdx = -1;
        for (let i = 0; i <= 15; i++) {
            if (jass.Player(i) === owner) {
                playerIdx = i;
                break;
            }
        }
        if (playerIdx < 0 || playerIdx > 3)
            return false;
        const utHero = heroUnitTypeForIsUnitType();
        if (utHero != null && jass.IsUnitType(unit, utHero) === true)
            return true;
        if (jass.GetHeroLevel(unit) > 0)
            return true;
        return false;
    }
    // ========== 虚拟分区：装备读取 ==========
    function unitItemInSlot(unit, slot) {
        return jass.UnitItemInSlot(unit, slot);
    }
    function getItemTypeId(item) {
        return GetItemTypeId(item);
    }
    function getBestDotFromUnit(unit, parseBuff, getProduct) {
        let best = null;
        for (let slot = 0; slot <= 5; slot++) {
            const item = unitItemInSlot(unit, slot);
            if (!item)
                continue;
            const idStr = fourCCToString(getItemTypeId(item));
            const entry = itemsData[idStr];
            const segments = entry?.Buff != null ? splitItemBuffSegments(entry.Buff) : [];
            for (let si = 0; si < segments.length; si++) {
                const parsed = parseBuff(segments[si]);
                if (!parsed)
                    continue;
                const product = getProduct(parsed);
                if (best == null || product > best.product) {
                    best = { ...parsed, product };
                }
            }
        }
        if (best == null)
            return null;
        const { product, ...result } = best;
        return result;
    }
    // ========== 虚拟分区：数值读取 ==========
    function getUnitMaxHp(targetUnit) {
        if (!targetUnit)
            return 0;
        const m = jass.BlzGetUnitMaxHP(targetUnit);
        if (typeof m === "number" && isFinite(m) && m > 0)
            return m;
        let maxLifeState = null;
        if (jass.UNIT_STATE_MAX_LIFE != null)
            maxLifeState = jass.UNIT_STATE_MAX_LIFE;
        else if (g.UNIT_STATE_MAX_LIFE != null)
            maxLifeState = g.UNIT_STATE_MAX_LIFE;
        else
            maxLifeState = jass.ConvertUnitState(1);
        if (maxLifeState == null)
            return 0;
        const v = jass.GetUnitState(targetUnit, maxLifeState);
        return typeof v === "number" && isFinite(v) && v > 0 ? v : 0;
    }
    function getTargetRegenHP(targetUnit) {
        if (!targetUnit)
            return 0;
        const typeId = GetUnitTypeId(targetUnit);
        const idStr = fourCCToString(typeId);
        const slk = globalThis.slk;
        const slkUnit = slk != null && slk.unit ? slk.unit[idStr] : undefined;
        if (slkUnit == null)
            return 0;
        const regenStr = slkUnit.regenHP ?? slkUnit["regenHP"];
        if (regenStr == null || typeof regenStr !== "string")
            return 0;
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
