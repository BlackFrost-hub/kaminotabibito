local ____lualib = require("lualib_bundle")
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local toHid, pruneEmptyHid, syncDotSnapshots, tickManualAndSyncDot, ensureSyncTimer, maybeStopSyncTimer, jass, LeakWatcher, TICK, unitToBuffs, syncTimer
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
    if type(jass.GetHandleId) ~= "function" then
        return 0
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
function syncDotSnapshots(self)
    local dotMod = require("系统.04．伤害系统.dot伤害")
    for hidKey in pairs(unitToBuffs) do
        do
            local __continue43
            repeat
                local hid = toHid(nil, hidKey)
                if hid == 0 then
                    __continue43 = true
                    break
                end
                local entry = unitToBuffs[hid]
                if entry == nil then
                    __continue43 = true
                    break
                end
                local unit = entry.lastRef
                local tab = entry.buffs
                if tab.D001 ~= nil and tab.D001.source == "dot" then
                    local ____temp_1
                    if unit ~= nil and dotMod.getUnitAntiHeal ~= nil then
                        ____temp_1 = dotMod:getUnitAntiHeal(unit)
                    else
                        ____temp_1 = nil
                    end
                    local st = ____temp_1
                    if st == nil then
                        __TS__Delete(tab, "D001")
                    else
                        tab.D001.remaining = st.remaining
                        tab.D001.effect = st.effect
                    end
                end
                if tab.D002 ~= nil and tab.D002.source == "dot" then
                    local ____temp_2
                    if unit ~= nil and dotMod.getUnitBurn ~= nil then
                        ____temp_2 = dotMod:getUnitBurn(unit)
                    else
                        ____temp_2 = nil
                    end
                    local st = ____temp_2
                    if st == nil then
                        __TS__Delete(tab, "D002")
                    else
                        tab.D002.remaining = st.remaining
                        tab.D002.effect = st.effect
                    end
                end
                pruneEmptyHid(nil, hid)
                __continue43 = true
            until true
            if not __continue43 then
                break
            end
        end
    end
end
function tickManualAndSyncDot(self)
    syncDotSnapshots(nil)
    for hidKey in pairs(unitToBuffs) do
        do
            local __continue54
            repeat
                local hid = toHid(nil, hidKey)
                if hid == 0 then
                    __continue54 = true
                    break
                end
                local entry = unitToBuffs[hid]
                if entry == nil then
                    __continue54 = true
                    break
                end
                local tab = entry.buffs
                for bid in pairs(tab) do
                    do
                        local __continue57
                        repeat
                            local row = tab[bid]
                            if row == nil or row.source ~= "manual" then
                                __continue57 = true
                                break
                            end
                            row.remaining = row.remaining - TICK
                            if row.remaining <= 0 then
                                __TS__Delete(tab, bid)
                            end
                            __continue57 = true
                        until true
                        if not __continue57 then
                            break
                        end
                    end
                end
                pruneEmptyHid(nil, hid)
                __continue54 = true
            until true
            if not __continue54 then
                break
            end
        end
    end
    maybeStopSyncTimer(nil)
end
function ensureSyncTimer(self)
    if syncTimer ~= nil then
        return
    end
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
        return
    end
    syncTimer = LeakWatcher:createTimer("buff_pool_sync")
    jass.TimerStart(syncTimer, TICK, true, tickManualAndSyncDot)
end
function maybeStopSyncTimer(self)
    local hasAny = false
    for _u in pairs(unitToBuffs) do
        hasAny = true
        break
    end
    if not hasAny and syncTimer ~= nil then
        LeakWatcher:destroyTimer(syncTimer)
        syncTimer = nil
    end
end
jass = require("jass.common")
local leakCore = require("系统.00．核心系统.泄露审计")
local ____leakCore_LeakWatcher_0 = leakCore.LeakWatcher
if ____leakCore_LeakWatcher_0 == nil then
    ____leakCore_LeakWatcher_0 = leakCore
end
LeakWatcher = ____leakCore_LeakWatcher_0
TICK = 0.5
--- dot伤害 里的 typeId → 01．Buff表 buffID
____exports.DOT_TYPE_TO_BUFF_ID = {antiHeal = "D001", burn = "D002"}
unitToBuffs = {}
syncTimer = nil
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
-- target 可为单位或 **GetHandleId**（tick 里到期时只传 id）。
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
    entry.buffs[buffID] = {buffID = buffID, remaining = state.remaining, effect = state.effect, source = "dot"}
    if type(target) ~= "number" then
        entry.lastRef = target
    end
    ensureSyncTimer(nil)
end
function ____exports.registerManualBuff(self, target, buffID, durationSec, effectValue)
    if target == nil or target == 0 or not buffID or durationSec <= 0 then
        return
    end
    local entry = ensureEntry(nil, target)
    if entry == nil then
        return
    end
    entry.buffs[buffID] = {buffID = buffID, remaining = durationSec, effect = effectValue, source = "manual"}
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
    local e = hid ~= 0 and unitToBuffs[hid] or nil
    if e == nil then
        return nil
    end
    local r = e.buffs[buffID]
    return r ~= nil and r or nil
end
function ____exports.initBuffSystem(self)
end
return ____exports
