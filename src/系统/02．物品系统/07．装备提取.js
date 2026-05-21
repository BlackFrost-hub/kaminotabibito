/**
 * 装备提取 — STES「装备提取事件」子触发：YDLocal5(ScoreMin/Max) → YDLocal7Set(integer, "ItemType", …)
 *
 * 规则：读 YDLocal5 的 ScoreMin/ScoreMax，在闭区间内枚举带 score 的 4 字 id，`GetRandomInt` 抽一件；无候选则 ItemType=0。
 *
 * 须与地图 JASS 一致：StringHash("装备提取事件")、ItemType。
 *
 * 注册时用 **jass.globals 的 STES___HT** 上 LoadInteger 校验监听数；若为 0 或表尚未绑定则延迟重试，
 * 避免早先 STES_Register 写入「Lua 自用表」后仍置 REG_GUARD，导致 JASS 遍历计数恒为 0、聊天无任何反应。
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { STES_Register } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件");
const { YDLocal5Get, YDLocal7Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容");
const { ydlStes_syncTriggerStep, ydlStes_finishChildCleanup, ydlStes_coerceOptionalNumber, ydlStes_skeyIndex, ydlStes_registerAfterGetTable, registerStesListener, } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具");
const dataMod = require("系统.02．物品系统.01．装备数据");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { debugLog } = require("lib.扩展函数.自定义扩展函数.index");
const ITEM_TYPE_KEY = "ItemType";
const REG_GUARD = "__syzl_equipExtract_registered";
const TRIG_KEY = "__syzl_equipExtract_trig";
const ATTEMPT_KEY = "__syzl_equipRegAttempt";
const MAX_REG_ATTEMPTS = 30;
const RETRY_SEC = 0.1;
const EQUIP_EXTRACT_EVENT_NAME = "装备提取事件";
const itemsTable = dataMod.items ?? dataMod.default ?? {};
function log(msg) {
    debugLog("装备提取", msg);
}
function formatDbgVal(v) {
    if (v == null)
        return "nil";
    return typeof v + ":" + v;
}
/** 仅使用 JASS 传入的 ScoreMin/ScoreMax（转成数字后取闭区间）；任一端读不到有效数字则视为失败 */
function readScoreBounds() {
    const minS = ydlStes_coerceOptionalNumber(undefined, YDLocal5Get("real", "ScoreMin"));
    const maxS = ydlStes_coerceOptionalNumber(undefined, YDLocal5Get("real", "ScoreMax"));
    if (minS === undefined || maxS === undefined) {
        return { ok: false, lo: 0, hi: 0 };
    }
    const lo = minS <= maxS ? minS : maxS;
    const hi = minS <= maxS ? maxS : minS;
    return { ok: true, lo, hi };
}
/** 与 02．Star自定义事件 resolveStesHashtable 候选一致，在 JASS 实际用的表上读监听数 */
function jassStesHashtable() {
    const jg = jglobals;
    const cands = [jg.STES___HT, jg.STES_HT, jg.udg_STES___HT, jg.udg_STES_HT];
    for (let i = 0; i < cands.length; i++) {
        const t = cands[i];
        if (t != null && t !== 0)
            return t;
    }
    return null;
}
/** -1 表示尚未找到任何 STES 全局表句柄 */
function countOnJassStesTable(eventName) {
    const ht = jassStesHashtable();
    if (ht == null || ht === 0)
        return -1;
    const h = jass.StringHash(eventName);
    return jass.LoadInteger(ht, h, ydlStes_skeyIndex(undefined));
}
/**
 * 列出闭区间 [lo, hi] 内**所有**带有效 score 的 4 字 id（score 用 coerceNumber，避免 Lua 表里为 string 时漏掉）
 */
function collectAllIdsInScoreInterval(lo, hi) {
    const a = lo <= hi ? lo : hi;
    const b = lo <= hi ? hi : lo;
    const out = [];
    for (const id in itemsTable) {
        if (typeof id !== "string" || id.length !== 4)
            continue;
        const sc = ydlStes_coerceOptionalNumber(undefined, itemsTable[id]?.score);
        if (sc === undefined)
            continue;
        if (sc >= a && sc <= b)
            out.push(id);
    }
    return out;
}
function pickFromScorePool(ids) {
    if (ids.length === 0)
        return { raw: 0, id: "" };
    const idx = jass.GetRandomInt(1, ids.length);
    const id = ids[idx];
    if (typeof id !== "string" || id.length !== 4)
        return { raw: 0, id: "" };
    return { raw: stringToFourCC(id), id };
}
function runEquipExtract() {
    ydlStes_syncTriggerStep(undefined);
    const rawMin = YDLocal5Get("real", "ScoreMin");
    const rawMax = YDLocal5Get("real", "ScoreMax");
    const bounds = readScoreBounds();
    if (!bounds.ok) {
        YDLocal7Set("integer", ITEM_TYPE_KEY, 0);
        ydlStes_finishChildCleanup(undefined);
        log("[装备提取] 读参失败 ScoreMin=" +
            formatDbgVal(rawMin) +
            " ScoreMax=" +
            formatDbgVal(rawMax) +
            " → ItemType=0");
        return;
    }
    const { lo, hi } = bounds;
    const pool = collectAllIdsInScoreInterval(lo, hi);
    if (pool.length === 0) {
        YDLocal7Set("integer", ITEM_TYPE_KEY, 0);
        ydlStes_finishChildCleanup(undefined);
        log("[装备提取] 读参 ScoreMin=" +
            formatDbgVal(rawMin) +
            " ScoreMax=" +
            formatDbgVal(rawMax) +
            " → 区间[" +
            lo +
            "," +
            hi +
            "] 候选0件 → ItemType=0");
        return;
    }
    const { raw, id: pickedId } = pickFromScorePool(pool);
    YDLocal7Set("integer", ITEM_TYPE_KEY, raw);
    ydlStes_finishChildCleanup(undefined);
    log("[装备提取] 读参 ScoreMin=" +
        formatDbgVal(rawMin) +
        " ScoreMax=" +
        formatDbgVal(rawMax) +
        " → 区间[" +
        lo +
        "," +
        hi +
        "] 候选" +
        pool.length +
        "件 抽到id=" +
        pickedId +
        " ItemType(rawcode)=" +
        raw);
}
function onEquipExtractTriggerAction() {
    runEquipExtract();
}
function scheduleRetry(fn) {
    createDelayedCall(RETRY_SEC, fn);
}
/**
 * 反复 STES_GetTable + Register，直到 **JASS 全局表** 上该事件监听数 >= 1，或超出次数。
 * 字面量事件名供 fix-lua-for-pack 10b 去掉多余 nil。
 */
function tryRegisterEquipStes() {
    const g = globalThis;
    if (g[REG_GUARD])
        return;
    if (STES_Register == null) {
        g[REG_GUARD] = true;
        return;
    }
    if (g[TRIG_KEY] == null) {
        const trig = jass.CreateTrigger();
        jass.TriggerAddAction(trig, onEquipExtractTriggerAction);
        g[TRIG_KEY] = trig;
    }
    const trig = g[TRIG_KEY];
    ydlStes_registerAfterGetTable(undefined, trig, EQUIP_EXTRACT_EVENT_NAME);
    const jCount = countOnJassStesTable(EQUIP_EXTRACT_EVENT_NAME);
    const attempt = g[ATTEMPT_KEY] || 0;
    g[ATTEMPT_KEY] = attempt + 1;
    if (jCount >= 1) {
        g[REG_GUARD] = true;
        g.EquipExtract_CreateByLevel = runEquipExtract;
        return;
    }
    if (g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS) {
        log("[装备提取] STES 注册失败（已重试" +
            MAX_REG_ATTEMPTS +
            "次，JASS 表上监听数=" +
            jCount +
            "）。请确认地图 STES 与事件名「装备提取事件」一致。");
        g[REG_GUARD] = true;
        return;
    }
    scheduleRetry(() => {
        tryRegisterEquipStes();
    });
}
function boot() {
    tryRegisterEquipStes();
}
boot();
export function EquipExtract_CreateByLevel(_self) {
    runEquipExtract();
}
