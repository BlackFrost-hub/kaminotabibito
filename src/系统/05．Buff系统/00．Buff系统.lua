local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local makeBuffKey, parseStrictPositiveInt, parseBuffKey, getBuffFromFlat, removeBuffFromFlat, collectActiveBuffPairs, __pcallIsUnitPausedBody, __pcallNotifyExpiredBody, __pcallSyncDotBody, isBuffPoolUnitPaused, notifyDotBuffExpiredFromPool, syncDotFromPoolTick, tickBuffPool, processBuffsForUnit, onBuffPoolCenterTimerTick, ensureSyncTimer, maybeStopSyncTimer, unitBjExt, buffByUnitAndId, unitRefByHid, __pcallIsPausedUnit, __pcallIsPausedResult, __pcallExpiredBuffId, __pcallExpiredHid, _registeredToCenterTimer, _tickCounter
function makeBuffKey(hid, buffID)
    return (tostring(hid) .. "|") .. buffID
end
function parseStrictPositiveInt(s)
    if s == "" then
        return nil
    end
    do
        local i = 0
        while i < #s do
            local ch = __TS__StringSubstring(s, i, i + 1)
            if ch < "0" or ch > "9" then
                return nil
            end
            i = i + 1
        end
    end
    local n = __TS__ParseInt(s, 10)
    if __TS__NumberIsNaN(__TS__Number(n)) or n <= 0 then
        return nil
    end
    return n
end
function parseBuffKey(key)
    local idx = (string.find(key, "|", nil, true) or 0) - 1
    if idx <= 0 then
        return nil
    end
    local hidStr = __TS__StringSubstring(key, 0, idx)
    local buffID = __TS__StringSubstring(key, idx + 1)
    local hid = parseStrictPositiveInt(hidStr)
    if hid == nil or buffID == "" then
        return nil
    end
    return {hid = hid, buffID = buffID}
end
function getBuffFromFlat(hid, buffID)
    return buffByUnitAndId[makeBuffKey(hid, buffID)] or nil
end
function removeBuffFromFlat(hid, buffID)
    __TS__Delete(
        buffByUnitAndId,
        makeBuffKey(hid, buffID)
    )
end
function collectActiveBuffPairs()
    local out = {}
    for k in pairs(buffByUnitAndId) do
        do
            local p = parseBuffKey(k)
            if not p then
                goto __continue16
            end
            local row = buffByUnitAndId[k]
            if row then
                out[#out + 1] = {hid = p.hid, buffID = p.buffID, row = row}
            end
        end
        ::__continue16::
    end
    __TS__ArraySort(
        out,
        function(____, a, b)
            if a.hid ~= b.hid then
                return a.hid - b.hid
            end
            if a.buffID < b.buffID then
                return -1
            end
            if a.buffID > b.buffID then
                return 1
            end
            return 0
        end
    )
    return out
end
function __pcallIsUnitPausedBody(self)
    if unitBjExt.IsUnitPausedBJ ~= nil then
        __pcallIsPausedResult = unitBjExt:IsUnitPausedBJ(__pcallIsPausedUnit) == true
    end
end
function __pcallNotifyExpiredBody(self)
    local m = require("系统.04．伤害系统.02．dot伤害")
    if m ~= nil and m.clearDotByBuffPoolExpire then
        local fn = m.clearDotByBuffPoolExpire
        fn(nil, __pcallExpiredBuffId, __pcallExpiredHid)
    end
end
function __pcallSyncDotBody(self)
    local m = require("系统.04．伤害系统.02．dot伤害")
    if m ~= nil and m.syncDotRemainingFromBuffPool then
        local fn = m.syncDotRemainingFromBuffPool
        fn(nil)
    end
end
function isBuffPoolUnitPaused(u)
    if u == nil or u == 0 then
        return false
    end
    if unitBjExt.IsUnitPausedBJ == nil then
        return false
    end
    __pcallIsPausedUnit = u
    __pcallIsPausedResult = false
    pcall(__pcallIsUnitPausedBody)
    return __pcallIsPausedResult
end
function notifyDotBuffExpiredFromPool(buffID, hid)
    __pcallExpiredBuffId = buffID
    __pcallExpiredHid = hid
    pcall(__pcallNotifyExpiredBody)
end
function syncDotFromPoolTick()
    pcall(__pcallSyncDotBody)
end
function ____exports.getBuffRuntimeByHid(hid, buffID)
    if hid == 0 then
        return nil
    end
    return getBuffFromFlat(hid, buffID)
end
function tickBuffPool()
    local ____pairs = collectActiveBuffPairs()
    local currentHid = -1
    local currentBuffs = {}
    do
        local i = 0
        while i < #____pairs do
            local ____pairs_index_1 = ____pairs[i + 1]
            local hid = ____pairs_index_1.hid
            local buffID = ____pairs_index_1.buffID
            local row = ____pairs_index_1.row
            if hid ~= currentHid then
                if currentHid > 0 and #currentBuffs > 0 then
                    processBuffsForUnit(currentHid, currentBuffs)
                end
                currentHid = hid
                currentBuffs = {}
            end
            currentBuffs[#currentBuffs + 1] = {buffID = buffID, row = row}
            i = i + 1
        end
    end
    if currentHid > 0 and #currentBuffs > 0 then
        processBuffsForUnit(currentHid, currentBuffs)
    end
    syncDotFromPoolTick()
    maybeStopSyncTimer()
end
function processBuffsForUnit(hid, buffs)
    if hid <= 0 or #buffs == 0 then
        return
    end
    local unitRef = unitRefByHid[hid]
    if unitRef ~= nil and isBuffPoolUnitPaused(unitRef) then
        return
    end
    local expired = {}
    do
        local i = 0
        while i < #buffs do
            local ____buffs_index_2 = buffs[i + 1]
            local buffID = ____buffs_index_2.buffID
            local row = ____buffs_index_2.row
            row.remaining = row.remaining - ____exports.BUFF_POOL_TICK
            if row.remaining <= 0 then
                if row.source == "dot" then
                    notifyDotBuffExpiredFromPool(buffID, hid)
                end
                expired[#expired + 1] = buffID
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #expired do
            removeBuffFromFlat(hid, expired[i + 1])
            i = i + 1
        end
    end
    local hasRemainingBuff = (function()
        for k in pairs(buffByUnitAndId) do
            local p = parseBuffKey(k)
            if p and p.hid == hid then
                return true
            end
        end
        return false
    end)()
    if not hasRemainingBuff then
        __TS__Delete(unitRefByHid, hid)
    end
end
function onBuffPoolCenterTimerTick()
    _tickCounter = _tickCounter + 1
    if _tickCounter >= 10 then
        _tickCounter = 0
        tickBuffPool()
    end
end
function ensureSyncTimer()
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____G_3 = _G
    local onTick10ms = ____G_3.onTick10ms
    onTick10ms(nil, onBuffPoolCenterTimerTick)
end
function maybeStopSyncTimer()
end
--- Buff 池 / Buff 系统框架（`00` 前缀便于在 `05．Buff系统` 目录内统一排序管理）
-- 
-- - **DOT（D001–D004）剩余时间由本模块以固定步长递减**；`dot伤害` 施加/刷新时 `syncDotBuff` 写入满额 remaining，不在此用 `getUnitPoison` 回写覆盖。
-- - 非 DOT 的 `manual` 条同样由本计时器递减。
-- - 每 tick 末调用 `dot伤害.syncDotRemainingFromBuffPool`，使逻辑层 `stateByType` 与池一致。
-- - **单位被 `PauseUnit` 暂停时**（`IsUnitPausedBJ`）：该单位在池内所有 Buff **不扣** `remaining`，与引擎时间冻结一致；恢复暂停后照常递减。
-- 
-- 扁平化改造：禁止 state[x][y] 二级链式，全部改用单层 flat[key]
-- key 格式："hid|buffId"（排序：先 hid 数值，再 buffID 字典序）
local jass = require("jass.common")
unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local leakCore = require("lib.扩展函数.封装函数.05．泄露审计.index")
local ____leakCore_LeakWatcher_0 = leakCore.LeakWatcher
if ____leakCore_LeakWatcher_0 == nil then
    ____leakCore_LeakWatcher_0 = leakCore
end
local LeakWatcher = ____leakCore_LeakWatcher_0
--- Buff 条剩余秒数递减步长（与 UI 刷新粒度一致，0.1s）
____exports.BUFF_POOL_TICK = 0.1
--- dot伤害 里的 typeId → 01．Buff表 buffID
____exports.DOT_TYPE_TO_BUFF_ID = {antiHeal = "D001", burn = "D002", poison = "D003", trollCurse = "D004"}
buffByUnitAndId = {}
local function setBuffToFlat(hid, buffID, row)
    buffByUnitAndId[makeBuffKey(hid, buffID)] = row
end
unitRefByHid = {}
local syncTimer = nil
__pcallIsPausedUnit = 0
__pcallIsPausedResult = false
__pcallExpiredBuffId = ""
__pcallExpiredHid = 0
local function toHid(u)
    if u == nil or u == 0 then
        return 0
    end
    if type(u) == "number" then
        return u
    end
    if type(u) == "string" then
        local n = __TS__ParseInt(u, 10)
        return __TS__NumberIsNaN(__TS__Number(n)) and 0 or n
    end
    return jass.GetHandleId(u)
end
--- 由 dot伤害 调用：施加、覆盖或到期清除。
-- target 可为单位或 **GetHandleId**。
-- state 为 null 表示该 DOT 类型在该单位上已结束。
function ____exports.syncDotBuff(typeId, target, state)
    local buffID = ____exports.DOT_TYPE_TO_BUFF_ID[typeId]
    if not buffID then
        return
    end
    local hid = toHid(target)
    if hid == 0 then
        return
    end
    if state == nil then
        removeBuffFromFlat(hid, buffID)
        __TS__Delete(unitRefByHid, hid)
        maybeStopSyncTimer()
        return
    end
    local row = {
        buffID = buffID,
        remaining = state.remaining,
        effect = state.effect,
        source = "dot",
        sourceName = state.sourceName,
        _dotParsedDuration = state._dotParsedDuration
    }
    setBuffToFlat(hid, buffID, row)
    if type(target) ~= "number" then
        unitRefByHid[hid] = target
    end
    ensureSyncTimer()
end
function ____exports.registerManualBuff(target, buffID, durationSec, effectValue, extras)
    if target == nil or target == 0 or not buffID or durationSec <= 0 then
        return
    end
    local hid = toHid(target)
    if hid == 0 then
        return
    end
    local row = {buffID = buffID, remaining = durationSec, effect = effectValue, source = "manual"}
    if extras ~= nil then
        if extras.sourceName ~= nil and extras.sourceName ~= "" then
            row.sourceName = extras.sourceName
        end
        if extras.iconOverride ~= nil and extras.iconOverride ~= "" then
            row.iconOverride = extras.iconOverride
        end
        if extras.effectModelOverride ~= nil and extras.effectModelOverride ~= "" then
            row.effectModelOverride = extras.effectModelOverride
        end
    end
    setBuffToFlat(hid, buffID, row)
    if type(target) ~= "number" then
        unitRefByHid[hid] = target
    end
    ensureSyncTimer()
end
function ____exports.isUnitInBuffPool(unit)
    local hid = toHid(unit)
    if hid == 0 then
        return false
    end
    for k in pairs(buffByUnitAndId) do
        local p = parseBuffKey(k)
        if p and p.hid == hid then
            return true
        end
    end
    return false
end
function ____exports.getBuffIdsOnUnit(unit)
    local hid = toHid(unit)
    local out = {}
    for k in pairs(buffByUnitAndId) do
        local p = parseBuffKey(k)
        if p and p.hid == hid then
            out[#out + 1] = p.buffID
        end
    end
    __TS__ArraySort(
        out,
        function(____, a, b)
            if a < b then
                return -1
            end
            if a > b then
                return 1
            end
            return 0
        end
    )
    return out
end
function ____exports.getBuffRuntime(unit, buffID)
    local hid = toHid(unit)
    return ____exports.getBuffRuntimeByHid(hid, buffID)
end
--- 图标底部剩余秒数：与池内 `remaining` 一致（无假层）
function ____exports.getDotIconDisplayRemaining(_unit, _buffID, realRemaining)
    return type(realRemaining) == "number" and __TS__NumberIsFinite(__TS__Number(realRemaining)) and realRemaining or 0
end
_registeredToCenterTimer = false
_tickCounter = 0
function ____exports.initBuffSystem()
end
return ____exports
