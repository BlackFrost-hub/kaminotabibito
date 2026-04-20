local ____lualib = require("lualib_bundle")
local __TS__TypeOf = ____lualib.__TS__TypeOf
local ____exports = {}
--- 装备提取 — STES「装备提取事件」子触发：YDLocal5(ScoreMin/Max) → YDLocal7Set(integer, "ItemType", …)
-- 
-- 规则：读 YDLocal5 的 ScoreMin/ScoreMax，在闭区间内枚举带 score 的 4 字 id，`math.random` 抽一件；无候选则 ItemType=0。
-- 
-- 须与地图 JASS 一致：StringHash("装备提取事件")、ItemType。
-- 
-- 注册时用 **jass.globals 的 STES___HT** 上 LoadInteger 校验监听数；若为 0 或表尚未绑定则延迟重试，
-- 避免早先 STES_Register 写入「Lua 自用表」后仍置 REG_GUARD，导致 JASS 遍历计数恒为 0、聊天无任何反应。
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Register = ____require_result_0.STES_Register
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Get = ____require_result_1.YDLocal5Get
local YDLocal7Set = ____require_result_1.YDLocal7Set
local ____require_result_2 = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具")
local ydlStes_syncTriggerStep = ____require_result_2.ydlStes_syncTriggerStep
local ydlStes_finishChildCleanup = ____require_result_2.ydlStes_finishChildCleanup
local ydlStes_coerceOptionalNumber = ____require_result_2.ydlStes_coerceOptionalNumber
local ydlStes_skeyIndex = ____require_result_2.ydlStes_skeyIndex
local ydlStes_registerAfterGetTable = ____require_result_2.ydlStes_registerAfterGetTable
local dataMod = require("系统.02．物品系统.01．装备数据")
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_3.stringToFourCC
local ITEM_TYPE_KEY = "ItemType"
local REG_GUARD = "__syzl_equipExtract_registered"
local TRIG_KEY = "__syzl_equipExtract_trig"
local ATTEMPT_KEY = "__syzl_equipRegAttempt"
local MAX_REG_ATTEMPTS = 30
local RETRY_SEC = 0.1
local itemsTable = dataMod.items or dataMod.default or ({})
local function log(msg)
    local p = _G.print
    if type(p) == "function" then
        p(nil, msg)
    end
end
local function formatDbgVal(v)
    if v == nil then
        return "nil"
    end
    return (__TS__TypeOf(v) .. ":") .. tostring(v)
end
--- 仅使用 JASS 传入的 ScoreMin/ScoreMax（转成数字后取闭区间）；任一端读不到有效数字则视为失败
local function readScoreBounds()
    local minS = ydlStes_coerceOptionalNumber(
        nil,
        nil,
        YDLocal5Get(nil, "real", "ScoreMin")
    )
    local maxS = ydlStes_coerceOptionalNumber(
        nil,
        nil,
        YDLocal5Get(nil, "real", "ScoreMax")
    )
    if minS == nil or maxS == nil then
        return {ok = false, lo = 0, hi = 0}
    end
    local lo = minS <= maxS and minS or maxS
    local hi = minS <= maxS and maxS or minS
    return {ok = true, lo = lo, hi = hi}
end
--- 与 02．Star自定义事件 resolveStesHashtable 候选一致，在 JASS 实际用的表上读监听数
local function jassStesHashtable()
    local jg = jglobals
    local cands = {jg.STES___HT, jg.STES_HT, jg.udg_STES___HT, jg.udg_STES_HT}
    do
        local i = 0
        while i < #cands do
            local t = cands[i + 1]
            if t ~= nil and t ~= 0 then
                return t
            end
            i = i + 1
        end
    end
    return nil
end
--- -1 表示尚未找到任何 STES 全局表句柄
local function countOnJassStesTable(eventName)
    local ht = jassStesHashtable()
    if ht == nil or ht == 0 then
        return -1
    end
    local h = jass.StringHash(eventName)
    return jass.LoadInteger(
        ht,
        h,
        ydlStes_skeyIndex(nil, nil)
    )
end
--- 列出闭区间 [lo, hi] 内**所有**带有效 score 的 4 字 id（score 用 coerceNumber，避免 Lua 表里为 string 时漏掉）
local function collectAllIdsInScoreInterval(lo, hi)
    local a = lo <= hi and lo or hi
    local b = lo <= hi and hi or lo
    local out = {}
    for id in pairs(itemsTable) do
        do
            if type(id) ~= "string" or #id ~= 4 then
                goto __continue15
            end
            local ____ydlStes_coerceOptionalNumber_6 = ydlStes_coerceOptionalNumber
            local ____opt_4 = itemsTable[id]
            if ____opt_4 ~= nil then
                ____opt_4 = ____opt_4.score
            end
            local sc = ____ydlStes_coerceOptionalNumber_6(nil, nil, ____opt_4)
            if sc == nil then
                goto __continue15
            end
            if sc >= a and sc <= b then
                out[#out + 1] = id
            end
        end
        ::__continue15::
    end
    return out
end
local function pickFromScorePool(ids)
    if #ids == 0 then
        return {raw = 0, id = ""}
    end
    local idx = math.random(1, #ids)
    local id = ids[idx]
    if type(id) ~= "string" or #id ~= 4 then
        return {raw = 0, id = ""}
    end
    return {
        raw = stringToFourCC(nil, id),
        id = id
    }
end
local function runEquipExtract()
    ydlStes_syncTriggerStep(nil, nil)
    local rawMin = YDLocal5Get(nil, "real", "ScoreMin")
    local rawMax = YDLocal5Get(nil, "real", "ScoreMax")
    local bounds = readScoreBounds()
    if not bounds.ok then
        YDLocal7Set(nil, "integer", ITEM_TYPE_KEY, 0)
        ydlStes_finishChildCleanup(nil, nil)
        log(((("[装备提取] 读参失败 ScoreMin=" .. formatDbgVal(rawMin)) .. " ScoreMax=") .. formatDbgVal(rawMax)) .. " → ItemType=0")
        return
    end
    local lo = bounds.lo
    local hi = bounds.hi
    local pool = collectAllIdsInScoreInterval(lo, hi)
    if #pool == 0 then
        YDLocal7Set(nil, "integer", ITEM_TYPE_KEY, 0)
        ydlStes_finishChildCleanup(nil, nil)
        log(((((((("[装备提取] 读参 ScoreMin=" .. formatDbgVal(rawMin)) .. " ScoreMax=") .. formatDbgVal(rawMax)) .. " → 区间[") .. tostring(lo)) .. ",") .. tostring(hi)) .. "] 候选0件 → ItemType=0")
        return
    end
    local ____pickFromScorePool_result_7 = pickFromScorePool(pool)
    local raw = ____pickFromScorePool_result_7.raw
    local pickedId = ____pickFromScorePool_result_7.id
    YDLocal7Set(nil, "integer", ITEM_TYPE_KEY, raw)
    ydlStes_finishChildCleanup(nil, nil)
    log((((((((((((("[装备提取] 读参 ScoreMin=" .. formatDbgVal(rawMin)) .. " ScoreMax=") .. formatDbgVal(rawMax)) .. " → 区间[") .. tostring(lo)) .. ",") .. tostring(hi)) .. "] 候选") .. tostring(#pool)) .. "件 抽到id=") .. pickedId) .. " ItemType(rawcode)=") .. tostring(raw))
end
local function scheduleRetry(fn)
    local tm = jass.CreateTimer()
    jass.TimerStart(
        tm,
        RETRY_SEC,
        false,
        function()
            jass.DestroyTimer(tm)
            fn(nil)
        end
    )
end
--- 反复 STES_GetTable + Register，直到 **JASS 全局表** 上该事件监听数 >= 1，或超出次数。
-- 字面量事件名供 fix-lua-for-pack 10b 去掉多余 nil。
local function tryRegisterEquipStes()
    local g = _G
    if g[REG_GUARD] then
        return
    end
    if STES_Register == nil then
        g[REG_GUARD] = true
        return
    end
    if STES_Register == nil then
        g[REG_GUARD] = true
        return
    end
    if g[TRIG_KEY] == nil then
        local trig = jass.CreateTrigger()
        jass.TriggerAddAction(
            trig,
            function()
                runEquipExtract()
            end
        )
        g[TRIG_KEY] = trig
    end
    local trig = g[TRIG_KEY]
    ydlStes_registerAfterGetTable(nil, nil, trig, "装备提取事件")
    local jCount = countOnJassStesTable("装备提取事件")
    local attempt = g[ATTEMPT_KEY] or 0
    g[ATTEMPT_KEY] = attempt + 1
    if jCount >= 1 then
        g[REG_GUARD] = true
        g.EquipExtract_CreateByLevel = runEquipExtract
        return
    end
    if g[ATTEMPT_KEY] >= MAX_REG_ATTEMPTS then
        log(((("[装备提取] STES 注册失败（已重试" .. tostring(MAX_REG_ATTEMPTS)) .. "次，JASS 表上监听数=") .. tostring(jCount)) .. "）。请确认地图 STES 与事件名「装备提取事件」一致。")
        g[REG_GUARD] = true
        return
    end
    scheduleRetry(function()
        tryRegisterEquipStes()
    end)
end
local function boot()
    tryRegisterEquipStes()
end
boot()
function ____exports.EquipExtract_CreateByLevel(self, _self)
    runEquipExtract()
end
return ____exports
