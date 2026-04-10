// 装备提取.ts - 聊天/拾取树枝触发，按 udg_TempScoreMin/Max 随机选1个物品写入 udg_TempItemType
const jass = require("jass.common");
const g = require("jass.globals");
const mod = require("系统.02．物品系统.01．装备数据");
const { stringToFourCC } = require("系统.00．核心系统.01．封装函数");
const itemsData = mod.items ?? mod.default ?? {};
let _seedCnt = 0;
const DEBUG = false;
const ITEM_TRIGGER = "tret"; // 触发物品ID
function getItemsByScoreRange(minScore, maxScore) {
    const min = minScore ?? 0;
    const max = maxScore ?? 0;
    const result = [];
    for (const id of Object.keys(itemsData)) {
        if (typeof id !== "string" || id.length !== 4)
            continue;
        const entry = itemsData[id];
        if (!entry)
            continue;
        const score = entry.score;
        if (score != null && score >= min && score <= max)
            result.push(id);
    }
    return result;
}
function EquipExtract_CreateByLevel() {
    globalThis.print?.("[装备提取] EquipExtract_CreateByLevel 被调用");
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "[装备提取] 执行中");
    _seedCnt++;
    math.randomseed(_seedCnt);
    const inputMin = jass.YDLocal1Get?.("integer", "EquipExtract_MinScore");
    const inputMax = jass.YDLocal1Get?.("integer", "EquipExtract_MaxScore");
    let minS = typeof inputMin === "number" ? inputMin : Number(g.udg_TempScoreMin) || 0;
    let maxS = typeof inputMax === "number" ? inputMax : Number(g.udg_TempScoreMax) || 0;
    if (minS <= 0 && maxS <= 0) {
        minS = 200;
        maxS = 250;
    }
    const candidates = getItemsByScoreRange(minS, maxS);
    const player = jass.STES_GetTriggerPlayer?.() ?? jass.GetTriggerPlayer?.() ?? jass.Player(0);
    if (candidates.length === 0) {
        g.udg_TempItemType = 0;
        if (DEBUG)
            jass.DisplayTimedTextToPlayer(player, 0, 0, 8, "TempItemType=0 无候选 min=" + minS + " max=" + maxS);
        return;
    }
    const arr = candidates.slice();
    for (let i = arr.length - 1; i > 0; i--) {
        const j = Math.floor(math.random() * (i + 1));
        [arr[i], arr[j]] = [arr[j], arr[i]];
    }
    const itemId = arr[0];
    g.udg_TempItemType = typeof itemId === "string" && itemId.length === 4 ? stringToFourCC(itemId) : 0;
    globalThis.print?.("TempItemType=" + g.udg_TempItemType + " itemId=" + itemId);
    if (DEBUG)
        jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "TempItemType=" + g.udg_TempItemType + " itemId=" + itemId);
}
function onTrigger() {
    const evt = jass.GetTriggerEventId();
    const player = jass.GetTriggerPlayer?.() ?? jass.Player(0);
    if (evt === jass.EVENT_PLAYER_UNIT_PICKUP_ITEM) {
        const item = jass.GetManipulatedItem();
        const tid = jass.GetItemTypeId(item);
        if (tid !== stringToFourCC(ITEM_TRIGGER))
            return; // 非 tret 不触发
        if (DEBUG)
            jass.DisplayTimedTextToPlayer(player, 0, 0, 8, "物品ID正确");
    }
    EquipExtract_CreateByLevel();
}
function init() {
    globalThis.EquipExtract_CreateByLevel = EquipExtract_CreateByLevel;
    const trig = jass.CreateTrigger();
    for (let i = 0; i < 4; i++) {
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_PICKUP_ITEM, undefined);
    }
    jass.TriggerAddAction(trig, onTrigger);
    const evtTrig = jass.CreateTrigger();
    jass.TriggerAddAction(evtTrig, () => EquipExtract_CreateByLevel());
    const STES_Reg = jass.STES_Register ?? g.STES_Register ?? globalThis.STES_Register;
    if (typeof STES_Reg === "function") {
        STES_Reg(evtTrig, "提取物品事件");
        if (DEBUG)
            jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "[装备提取] 已通过 STES_Register 注册事件 提取物品事件");
    }
    else {
        g.udg_RegTrigger = evtTrig;
        g.udg_RegEventStr = "提取物品事件";
        jass.ExecuteFunc("Bridge_STES_Register");
    }
}
init();
export { EquipExtract_CreateByLevel };
