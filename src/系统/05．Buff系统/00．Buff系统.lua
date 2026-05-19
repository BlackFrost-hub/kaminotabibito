local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsNaN = ____lualib.__TS__NumberIsNaN
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySort = ____lualib.__TS__ArraySort
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
local makeBuffKey, parseStrictPositiveInt, parseBuffKey, getBuffFromFlat, removeBuffFromFlat, hasAnyBuffOnHid, collectActiveBuffPairs, __pcallIsUnitPausedBody, __pcallNotifyExpiredBody, __pcallSyncDotBody, isBuffPoolUnitPaused, notifyDotBuffExpiredFromPool, syncDotFromPoolTick, tickBuffPool, processBuffsForUnit, cleanupExpiredNativeBuffs, cleanupBuffOnRemove, removeBuffRuntimeByKey, onBuffPoolCenterTimerTick, ensureSyncTimer, maybeStopSyncTimer, unitBjExt, UnitRemoveAbility, DEFAULT_NATIVE_BUFF_IDS_BY_BUFF_ID, buffByUnitAndId, unitRefByHid, __pcallIsPausedUnit, __pcallIsPausedResult, __pcallExpiredBuffId, __pcallExpiredHid, _registeredToCenterTimer, _tickCounter
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
function hasAnyBuffOnHid(hid)
    for k in pairs(buffByUnitAndId) do
        local p = parseBuffKey(k)
        if p and p.hid == hid then
            return true
        end
    end
    return false
end
function collectActiveBuffPairs()
    local out = {}
    for k in pairs(buffByUnitAndId) do
        do
            local p = parseBuffKey(k)
            if not p then
                goto __continue20
            end
            local row = buffByUnitAndId[k]
            if row ~= nil then
                out[#out + 1] = {hid = p.hid, buffID = p.buffID, row = row}
            end
        end
        ::__continue20::
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
            local ____pairs_index_10 = ____pairs[i + 1]
            local hid = ____pairs_index_10.hid
            local buffID = ____pairs_index_10.buffID
            local row = ____pairs_index_10.row
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
            local ____buffs_index_11 = buffs[i + 1]
            local buffID = ____buffs_index_11.buffID
            local row = ____buffs_index_11.row
            row.remaining = row.remaining - ____exports.BUFF_POOL_TICK
            if row.remaining <= 0 then
                expired[#expired + 1] = {buffID = buffID, row = row}
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #expired do
            local ____expired_index_12 = expired[i + 1]
            local buffID = ____expired_index_12.buffID
            local row = ____expired_index_12.row
            removeBuffRuntimeByKey(hid, buffID, row, unitRef)
            i = i + 1
        end
    end
    if not hasAnyBuffOnHid(hid) then
        __TS__Delete(unitRefByHid, hid)
    end
end
function cleanupExpiredNativeBuffs(unitRef, row)
    if unitRef == nil or unitRef == 0 then
        return
    end
    local ids = row.nativeBuffAbilityIds or DEFAULT_NATIVE_BUFF_IDS_BY_BUFF_ID[row.buffID]
    if ids == nil or #ids == 0 then
        return
    end
    do
        local i = 0
        while i < #ids do
            local rawId = ids[i + 1]
            if rawId ~= nil and rawId ~= 0 then
                UnitRemoveAbility(unitRef, rawId)
            end
            i = i + 1
        end
    end
end
function cleanupBuffOnRemove(unitRef, hid, buffID, row)
    local onRemove = row.onRemove
    if onRemove == nil then
        return
    end
    local unitOrHid = (unitRef == nil or unitRef == 0) and hid or unitRef
    onRemove(unitOrHid, buffID, row)
end
function removeBuffRuntimeByKey(hid, buffID, row, unitRef)
    if row.source == "dot" then
        notifyDotBuffExpiredFromPool(buffID, hid)
    end
    cleanupBuffOnRemove(unitRef, hid, buffID, row)
    cleanupExpiredNativeBuffs(unitRef, row)
    removeBuffFromFlat(hid, buffID)
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
    local ____G_14 = _G
    local onTick10ms = ____G_14.onTick10ms
    onTick10ms(onBuffPoolCenterTimerTick)
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
UnitRemoveAbility = jass.UnitRemoveAbility
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_1.YDWETimerDestroyEffectSafe
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
DEFAULT_NATIVE_BUFF_IDS_BY_BUFF_ID = {
    C001 = {1112560453},
    C002 = {1114010234},
    C003 = {1112437609},
    C004 = {1114664057},
    C005 = {1114205814},
    C006 = {1112437609},
    C007 = {1114860655},
    C011 = {1114205798},
    C012 = {1113746543},
    C013 = {1113813609},
    C014 = {1114005861},
    C015 = {1113813619},
    C016 = {1112896364, 1112896368, 1114993524},
    C017 = {1111844210},
    C018 = {1113815395, 1113815346},
    C024 = {1112436833}
}
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
        effect2 = 0,
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
local function playManualBuffEffect(target, buffID, row, durationSec)
    if target == nil or target == 0 then
        return
    end
    local meta = buffTableMod.buffs[buffID]
    local modelPath = row.effectModelOverride and row.effectModelOverride ~= "" and row.effectModelOverride or (meta and meta.effect or "")
    if modelPath == "" then
        return
    end
    local effect = nil
    if (meta and meta.effectMode) == "point" then
        effect = AddSpecialEffect(
            modelPath,
            GetUnitX(target),
            GetUnitY(target)
        )
    else
        effect = AddSpecialEffectTarget(modelPath, target, meta and meta.effectAttachPoint or "overhead")
    end
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(durationSec, effect)
    end
end
function ____exports.registerManualBuff(target, buffID, durationSec, effectValue, extras)
    if target == nil or target == 0 or not buffID or durationSec <= 0 then
        return
    end
    local hid = toHid(target)
    if hid == 0 then
        return
    end
    local row = {
        buffID = buffID,
        remaining = durationSec,
        effect = effectValue,
        effect2 = extras and extras.effectValue2 or 0,
        source = "manual"
    }
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
        if extras.effectValue2 ~= nil then
            row.effect2 = extras.effectValue2
        end
        if extras.nativeBuffAbilityIds ~= nil and #extras.nativeBuffAbilityIds > 0 then
            row.nativeBuffAbilityIds = extras.nativeBuffAbilityIds
        end
        if extras.onRemove ~= nil then
            row.onRemove = extras.onRemove
        end
    end
    setBuffToFlat(hid, buffID, row)
    if type(target) ~= "number" then
        unitRefByHid[hid] = target
    end
    playManualBuffEffect(target, buffID, row, durationSec)
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
--- 删除单位身上的指定 buffID，并同步清理 DOT 与原生魔法效果。
____exports["移除单位指定Buff"] = function(unit, buffID)
    local hid = toHid(unit)
    if hid == 0 or buffID == "" then
        return false
    end
    local row = getBuffFromFlat(hid, buffID)
    if row == nil then
        return false
    end
    local ____temp_13
    if type(unit) ~= "number" then
        ____temp_13 = unit
    else
        ____temp_13 = unitRefByHid[hid]
    end
    local unitRef = ____temp_13
    removeBuffRuntimeByKey(hid, buffID, row, unitRef)
    if not hasAnyBuffOnHid(hid) then
        __TS__Delete(unitRefByHid, hid)
    end
    maybeStopSyncTimer()
    return true
end
_registeredToCenterTimer = false
_tickCounter = 0
function ____exports.initBuffSystem()
end
return ____exports
