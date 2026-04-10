// 装备掉落.ts - 优先按装备掉落表；无则走旧 DROP_RULES（hfoo 等）
// 自动生成 - 单位数据表
/**
 * 装备掉落表格式说明：
 * - picks：最多掉落多少件（不是必定掉满）。
 * - itemIds 带百分数（如 I03Y:7%;I04R:7%）：每项独立按概率判定，不重复；最多 picks 件。仅当 picks > 物品种类数时，差额按权重再抽（可重复）。
 * - itemIds 纯权重（如 I02C:1.5;I01G:1）：按权重在池中随机抽 picks 件。
 * - itemIds 无权重（如 I00C;I00E;I00D;I00G）：从池中选 min(picks, 池大小) 件不重复；picks > 池大小时多出的可重复随机。
 * - always：必掉且仅掉一次。
 * - unitType 为 elite/Boss 且 T>1 时，picks = round(basePicks×(1+0.334×(T-1)))。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const equipExcrete = require("系统.02．物品系统.09．装备排泄");
const { stringToFourCC, isSpecialUnit } = require("系统.00．核心系统.01．封装函数");
const idData = require("系统.02．物品系统.02．装备掉落表").default ??
    require("系统.02．物品系统.02．装备掉落表").idData ??
    {};
const itemsData = require("系统.02．物品系统.01．装备数据").default ?? {};
const PREFIX = "|cffffff00『系统提示』：|r";
// 安全初始化随机种子（只执行一次，所有玩家一致）
(() => {
    const key = "__equip_drop_rand_init";
    if (globalThis[key])
        return;
    globalThis[key] = true;
    // 使用固定种子初始化，所有玩家一样
    // 魔兽引擎会自动管理后续随机数序列的同步
    math.randomseed(123456789);
    // 预先消耗一些随机数，确保随机性
    for (let i = 0; i < 10; i++)
        math.random();
})();
function typeIdToUnitId(typeId) {
    for (const id in idData) {
        if (stringToFourCC(id) === typeId)
            return id;
    }
    return undefined;
}
/** 解析 itemIds → [{id, weight, always?}]。always 标记必掉且仅掉一次、不参与重复抽取 */
function parseItemPool(itemIdsStr) {
    const raw = String(itemIdsStr).trim();
    if (!raw)
        return [];
    const parts = raw.split(";").map((p) => p.trim()).filter((p) => p.length >= 4);
    const hasColon = parts.some((p) => p.indexOf(":") >= 0);
    const pool = [];
    if (hasColon) {
        for (const p of parts) {
            const colon = p.indexOf(":");
            if (colon < 0)
                continue;
            const id = p.substring(0, colon).trim();
            let w = 0;
            let always = false;
            const rest = p.substring(colon + 1).trim().toLowerCase();
            if (rest === "always") {
                w = 1;
                always = true;
            }
            else if (rest.indexOf("%") >= 0) {
                w = parseFloat(rest) / 100;
            }
            else {
                w = parseFloat(rest);
            }
            if (id.length >= 4)
                pool.push({ id: id.substring(0, 4), weight: w, always });
        }
    }
    else {
        for (const p of parts) {
            const id = p.substring(0, 4);
            if (id.length === 4)
                pool.push({ id, weight: 1 });
        }
    }
    return pool;
}
/** Jass 全局 T = 玩家人数。unitType 为 elite/Boss 时，picks = round(basePicks × (1 + 0.334×(T-1)))，如 T=5、picks=2 得 5 */
function getEffectivePicks(basePicks, unitType) {
    const ut = String(unitType || "").toLowerCase();
    if (ut !== "elite" && ut !== "boss")
        return basePicks;
    const T = g.udg_T != null ? Number(g.udg_T) : 0;
    if (T <= 1)
        return basePicks;
    const mult = 1 + 0.334 * (T - 1);
    return Math.floor(basePicks * mult + 0.5);
}
/** 加权随机取一个（权重不必归一化） */
function weightedPickOne(pool) {
    if (pool.length === 0)
        return undefined;
    let sum = 0;
    for (const p of pool)
        sum += p.weight;
    if (sum <= 0)
        return pool[math.random(1, pool.length)]?.id;
    const r = math.random(1, 10000) / 10000 * sum;
    let acc = 0;
    for (const p of pool) {
        acc += p.weight;
        if (r <= acc)
            return p.id;
    }
    return pool[pool.length - 1].id;
}
/**
 * 权重/百分比池：最多 picks 件；首轮每项独立按概率 roll，不重复。
 * 仅当 picks > 池子物品种类数时，差额按权重再抽（可重复掉落）。
 */
function pickFromWeightedPool(pool, picks) {
    if (pool.length === 0)
        return [];
    if (picks === 1) {
        const one = weightedPickOne(pool);
        return one ? [one] : [];
    }
    const out = [];
    for (const p of pool) {
        if (p.weight >= 1 || p.always) {
            globalThis.print?.("[装备掉落] 必掉物品:", p.id, p.weight);
            out.push(p.id);
        }
        else {
            const r = math.random(1, 10000) / 10000;
            globalThis.print?.("[装备掉落] 概率判定:", p.id, "weight:", p.weight, "r:", r, "命中:", r < p.weight);
            if (r < p.weight)
                out.push(p.id);
        }
    }
    if (out.length > picks) {
        for (let i = out.length - 1; i >= 1; i--) {
            const j = math.random(1, i + 1);
            const t = out[i];
            out[i] = out[j - 1];
            out[j - 1] = t;
        }
        while (out.length > picks)
            out.pop();
    }
    const needMore = picks - out.length;
    if (needMore <= 0)
        return out;
    if (picks <= pool.length)
        return out;
    for (let i = 0; i < needMore; i++) {
        const one = weightedPickOne(pool);
        if (one != null)
            out.push(one);
    }
    return out;
}
/** 无权重池（I00C;I00E;I00D;I00G）：从池中选 min(picks, 池大小) 件不重复；若 picks > 池大小，多出的按池内随机再抽（可重复） */
function pickFromEqualPool(ids, picks) {
    if (ids.length === 0 || picks <= 0)
        return [];
    const out = [];
    const list = ids.slice();
    const firstPicks = picks <= list.length ? picks : list.length;
    for (let i = 0; i < firstPicks; i++) {
        const idx = math.random(1, list.length);
        const id = list[idx - 1];
        out.push(id);
        list.splice(idx - 1, 1);
    }
    const needMore = picks - out.length;
    for (let i = 0; i < needMore; i++) {
        const idx = math.random(1, ids.length);
        out.push(ids[idx - 1]);
    }
    return out;
}
function createItemAtUnit(unit, itemId) {
    const four = stringToFourCC(itemId);
    let loc = undefined;
    if (typeof jass.GetUnitLoc === "function")
        loc = jass.GetUnitLoc(unit);
    if (loc && typeof jass.CreateItemLoc === "function") {
        equipExcrete.setLastCreatedItem(jass.CreateItemLoc(four, loc));
    }
    else if (jass.GetUnitX != null) {
        const x = jass.GetUnitX(unit);
        const y = jass.GetUnitY(unit);
        equipExcrete.setLastCreatedItem(jass.CreateItem(four, x, y));
    }
    if (loc && typeof jass.RemoveLocation === "function")
        jass.RemoveLocation(loc);
}
function onUnitDeath() {
    const unit = jass.GetTriggerUnit();
    if (!unit)
        return;
    if (typeof jass.GetUnitTypeId !== "function")
        return;
    const typeId = jass.GetUnitTypeId(unit);
    const unitId = typeIdToUnitId(typeId);
    const entry = unitId ? idData[unitId] : undefined;
    globalThis.print?.("[装备掉落] 单位死亡 typeId:", typeId, "unitId:", unitId, "entry:", entry?.name);
    if (entry && entry.itemIds != null) {
        globalThis.print?.("[装备掉落] 找到掉落表 itemIds:", entry.itemIds);
        const dropProc = entry.dropProc != null ? Number(entry.dropProc) : 1;
        const r = math.random(1, 10000);
        if (r > dropProc * 10000)
            return;
        const rawItemIds = String(entry.itemIds);
        const pool = parseItemPool(rawItemIds);
        if (pool.length === 0)
            return;
        let picksNum = Math.max(1, Math.floor(Number(entry.picks) || 1));
        picksNum = getEffectivePicks(picksNum, entry.unitType);
        const ids = pool.map((p) => p.id);
        // 只有 “I00C;I00E;I00D” 这种无冒号的格式才走等概率抽 picks 个
        const isEqualPool = rawItemIds.indexOf(":") < 0;
        const toDrop = isEqualPool
            ? pickFromEqualPool(ids, picksNum)
            : pickFromWeightedPool(pool, picksNum);
        for (const id of toDrop)
            createItemAtUnit(unit, id);
        return;
    }
    // 旧逻辑：hfoo 等 DROP_RULES
    const DROP_RULES = [
        { unitId: "hfoo", minScore: 150, maxScore: 250, proc: 1 },
    ];
    for (const rule of DROP_RULES) {
        if (typeId !== stringToFourCC(rule.unitId))
            continue;
        const r = math.random(1, 10000);
        if (r > rule.proc * 10000)
            continue;
        const list = getItemsByScoreRange(rule.minScore, rule.maxScore);
        if (list.length === 0)
            continue;
        const idx = math.random(1, list.length);
        const itemId = list[idx];
        if (itemId != null && itemId !== "")
            createItemAtUnit(unit, itemId);
        break;
    }
}
function getItemsByScoreRange(minScore, maxScore) {
    const result = [];
    for (const id in itemsData) {
        if (typeof id !== "string" || id.length !== 4)
            continue;
        const entry = itemsData[id];
        const score = entry?.score;
        if (typeof score !== "number")
            continue;
        if (score >= minScore && score <= maxScore)
            result.push(id);
    }
    return result;
}
function condition() {
    const u = jass.GetTriggerUnit();
    if (!u)
        return false;
    if (isSpecialUnit(u))
        return false;
    return true;
}
function init() {
    const trig = jass.CreateTrigger();
    const eventId = jass.EVENT_PLAYER_UNIT_DEATH ?? 52;
    for (let i = 0; i < 16; i++) {
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), eventId, undefined);
    }
    const neutral = jass.Player?.(jass.PLAYER_NEUTRAL_AGGRESSIVE ?? 13);
    if (neutral != null)
        jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, undefined);
    const neutralPassive = jass.Player?.(jass.PLAYER_NEUTRAL_PASSIVE ?? 15);
    if (neutralPassive != null)
        jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, undefined);
    const cond = jass.Condition;
    if (typeof cond === "function")
        jass.TriggerAddCondition(trig, cond(condition));
    jass.TriggerAddAction(trig, onUnitDeath);
}
init();
export {};
