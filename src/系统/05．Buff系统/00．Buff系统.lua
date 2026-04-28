local ____lualib = require("lualib_bundle")
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__Delete = ____lualib.__TS__Delete
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local __pcallIsUnitPausedBody, __pcallNotifyExpiredBody, __pcallSyncDotBody, isBuffPoolUnitPaused, toHid, pruneEmptyHid, notifyDotBuffExpiredFromPool, syncDotFromPoolTick, tickBuffPool, ensureSyncTimer, maybeStopSyncTimer, jass, unitBjExt, unitToBuffs, __pcallIsPausedUnit, __pcallIsPausedResult, __pcallExpiredBuffId, __pcallExpiredHid, _registeredToCenterTimer, _tickCounter
function __pcallIsUnitPausedBody(self)
    local fn = unitBjExt.IsUnitPausedBJ
    if fn ~= nil then
        __pcallIsPausedResult = fn(nil, __pcallIsPausedUnit) == true
    end
end
function __pcallNotifyExpiredBody(self)
    local m = require("系统.04．伤害系统.02．dot伤害")
    if m ~= nil and m.clearDotByBuffPoolExpire then
        m.clearDotByBuffPoolExpire(__pcallExpiredBuffId, __pcallExpiredHid)
    end
end
function __pcallSyncDotBody(self)
    local m = require("系统.04．伤害系统.02．dot伤害")
    if m ~= nil and m.syncDotRemainingFromBuffPool then
        m.syncDotRemainingFromBuffPool()
    end
end
function isBuffPoolUnitPaused(self, u)
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
function toHid(self, u)
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
function pruneEmptyHid(self, hid)
    local e = unitToBuffs[hid]
    if e == nil then
        return
    end
    local n = 0
    for _k in pairs(e.buffs) do
        n = n + 1
        break
    end
    if n == 0 then
        __TS__Delete(unitToBuffs, hid)
    end
end
function notifyDotBuffExpiredFromPool(self, buffID, hid)
    __pcallExpiredBuffId = buffID
    __pcallExpiredHid = hid
    pcall(__pcallNotifyExpiredBody)
end
function syncDotFromPoolTick(self)
    pcall(__pcallSyncDotBody)
end
function ____exports.getBuffRuntimeByHid(self, hid, buffID)
    if hid == 0 then
        return nil
    end
    local e = unitToBuffs[hid]
    if e == nil then
        return nil
    end
    local r = e.buffs[buffID]
    return r ~= nil and r or nil
end
function tickBuffPool(self)
    for hidKey in pairs(unitToBuffs) do
        do
            local hid = toHid(nil, hidKey)
            if hid == 0 then
                goto __continue60
            end
            local entry = unitToBuffs[hid]
            if entry == nil then
                goto __continue60
            end
            if isBuffPoolUnitPaused(nil, entry.lastRef) then
                goto __continue60
            end
            local tab = entry.buffs
            local expired = {}
            for bid in pairs(tab) do
                do
                    local row = tab[bid]
                    if row == nil then
                        goto __continue64
                    end
                    row.remaining = row.remaining - ____exports.BUFF_POOL_TICK
                    if row.remaining <= 0 then
                        if row.source == "dot" then
                            notifyDotBuffExpiredFromPool(nil, bid, hid)
                        end
                        expired[#expired + 1] = bid
                    end
                end
                ::__continue64::
            end
            do
                local ei = 0
                while ei < #expired do
                    __TS__Delete(tab, expired[ei + 1])
                    ei = ei + 1
                end
            end
            pruneEmptyHid(nil, hid)
        end
        ::__continue60::
    end
    syncDotFromPoolTick(nil)
    maybeStopSyncTimer(nil)
end
function ensureSyncTimer(self)
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____G_1 = _G
    local onTick10ms = ____G_1.onTick10ms
    onTick10ms(
        nil,
        function()
            _tickCounter = _tickCounter + 1
            if _tickCounter >= 10 then
                _tickCounter = 0
                tickBuffPool(nil)
            end
        end
    )
end
function maybeStopSyncTimer(self)
end
jass = require("jass.common")
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
unitToBuffs = {}
local syncTimer = nil
__pcallIsPausedUnit = 0
__pcallIsPausedResult = false
__pcallExpiredBuffId = ""
__pcallExpiredHid = 0
local function ensureEntry(self, u)
    local hid = toHid(nil, u)
    if hid == 0 then
        return nil
    end
    if unitToBuffs[hid] == nil then
        unitToBuffs[hid] = {lastRef = u, buffs = {}}
    else
        unitToBuffs[hid].lastRef = u
    end
    return unitToBuffs[hid]
end
--- 由 dot伤害 调用：施加、覆盖或到期清除。
-- target 可为单位或 **GetHandleId**。
-- state 为 null 表示该 DOT 类型在该单位上已结束。
function ____exports.syncDotBuff(self, typeId, target, state)
    local buffID = ____exports.DOT_TYPE_TO_BUFF_ID[typeId]
    if not buffID then
        return
    end
    local hid = toHid(nil, target)
    if hid == 0 then
        return
    end
    if state == nil then
        local e = unitToBuffs[hid]
        if e == nil then
            return
        end
        __TS__Delete(e.buffs, buffID)
        pruneEmptyHid(nil, hid)
        maybeStopSyncTimer(nil)
        return
    end
    local entry = ensureEntry(nil, target)
    if entry == nil then
        return
    end
    entry.buffs[buffID] = {
        buffID = buffID,
        remaining = state.remaining,
        effect = state.effect,
        source = "dot",
        sourceName = state.sourceName,
        _dotParsedDuration = state._dotParsedDuration
    }
    if type(target) ~= "number" then
        entry.lastRef = target
    end
    ensureSyncTimer(nil)
end
function ____exports.registerManualBuff(self, target, buffID, durationSec, effectValue, extras)
    if target == nil or target == 0 or not buffID or durationSec <= 0 then
        return
    end
    local entry = ensureEntry(nil, target)
    if entry == nil then
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
    entry.buffs[buffID] = row
    ensureSyncTimer(nil)
end
function ____exports.removeBuffById(self, target, buffID)
    local hid = toHid(nil, target)
    if hid == 0 then
        return
    end
    local e = unitToBuffs[hid]
    if e == nil then
        return
    end
    __TS__Delete(e.buffs, buffID)
    pruneEmptyHid(nil, hid)
    maybeStopSyncTimer(nil)
end
function ____exports.clearAllBuffsOnUnit(self, target)
    local hid = toHid(nil, target)
    if hid == 0 then
        return
    end
    __TS__Delete(unitToBuffs, hid)
    maybeStopSyncTimer(nil)
end
function ____exports.isUnitInBuffPool(self, unit)
    local hid = toHid(nil, unit)
    if hid == 0 then
        return false
    end
    local e = unitToBuffs[hid]
    if e == nil then
        return false
    end
    for _k in pairs(e.buffs) do
        return true
    end
    return false
end
function ____exports.getBuffIdsOnUnit(self, unit)
    local hid = toHid(nil, unit)
    local out = {}
    local e = hid ~= 0 and unitToBuffs[hid] or nil
    if e == nil then
        return out
    end
    for k in pairs(e.buffs) do
        out[#out + 1] = k
    end
    return out
end
function ____exports.getBuffRuntime(self, unit, buffID)
    local hid = toHid(nil, unit)
    return ____exports.getBuffRuntimeByHid(nil, hid, buffID)
end
--- 图标底部剩余秒数：与池内 `remaining` 一致（无假层）
function ____exports.getDotIconDisplayRemaining(self, _unit, _buffID, realRemaining)
    return type(realRemaining) == "number" and __TS__NumberIsFinite(__TS__Number(realRemaining)) and realRemaining or 0
end
_registeredToCenterTimer = false
_tickCounter = 0
function ____exports.initBuffSystem(self)
end
return ____exports
