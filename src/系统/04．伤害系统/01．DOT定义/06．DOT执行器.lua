local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____04_FF0EDOT_5DE5_5177 = require("系统.04．伤害系统.01．DOT定义.04．DOT工具")
local getDotState = ____04_FF0EDOT_5DE5_5177.getDotState
local setIgnoredTarget = ____04_FF0EDOT_5DE5_5177.setIgnoredTarget
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local DOT_TYPE_TO_BUFF_ID = ____00_FF0EBuff_7CFB_7EDF.DOT_TYPE_TO_BUFF_ID
local getBuffRuntimeByHid = ____00_FF0EBuff_7CFB_7EDF.getBuffRuntimeByHid
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local onSecond = ____require_result_0.onSecond
local unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local ____require_result_1 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWETimerDestroyEffect = ____require_result_1.YDWETimerDestroyEffect
local luaPcall = pcall
--- DOT 秒跳目标被 `PauseUnit` 暂停时不结算伤害/特效/onTick（与 Buff 池不计时一致）
local __pcallPausedUnit = 0
local __pcallPausedResult = false
local function __pcallIsUnitPausedBody()
    local fn = unitBjExt.IsUnitPausedBJ
    if fn ~= nil then
        __pcallPausedResult = fn(__pcallPausedUnit) == true
    end
end
local function isDotTargetPaused(u)
    if u == nil or u == 0 then
        return false
    end
    local fn = unitBjExt.IsUnitPausedBJ
    if fn == nil then
        return false
    end
    __pcallPausedUnit = u
    __pcallPausedResult = false
    luaPcall(__pcallIsUnitPausedBody)
    return __pcallPausedResult
end
function ____exports.createDotExecutor(deps)
    local jass = deps.jass
    local LeakWatcher = deps.LeakWatcher
    local dotTypes = deps.dotTypes
    local dotTicks = deps.dotTicks
    local unitHid = deps.unitHid
    local damageEventModule = deps.damageEventModule
    local dotTimer = nil
    local dotTickBatchTargetHids = nil
    local dotBatchSnapForClear = nil
    local dotBatchDeferredRemaining = 0
    local function addDotEffectOnUnit(unit, model, duration)
        if not unit or not model or model == "" then
            return
        end
        local eff = jass:AddSpecialEffectTarget(model, unit, "origin")
        if eff == nil then
            return
        end
        YDWETimerDestroyEffect(nil, duration, eff)
    end
    local function dealDamageForType(typeId, source, target, amount)
        if isDotTargetPaused(target) then
            return
        end
        local cfg = __TS__ArrayFind(
            dotTypes,
            function(____, c) return c.id == typeId end
        )
        if cfg == nil then
            return
        end
        local dh = unitHid(target)
        do
            local di = 0
            while di < #dotTypes do
                local tid = dotTypes[di + 1].id
                setIgnoredTarget(tid, dh)
                di = di + 1
            end
        end
        if type(damageEventModule.markNextPendingDamageAsDotTickBatch) == "function" then
            damageEventModule.markNextPendingDamageAsDotTickBatch()
        end
        jass:UnitDamageTarget(
            source,
            target,
            amount,
            false,
            false,
            jass.ATTACK_TYPE_NORMAL,
            cfg.damageType,
            jass.WEAPON_TYPE_WHOKNOWS
        )
    end
    local function dotTickRun()
        do
            local i = #dotTicks - 1
            while i >= 0 do
                local e = dotTicks[i + 1]
                local eh = unitHid(e.target)
                local bid = DOT_TYPE_TO_BUFF_ID[e.typeId]
                local ____temp_2
                if bid ~= nil and bid ~= "" then
                    ____temp_2 = getBuffRuntimeByHid(eh, bid)
                else
                    ____temp_2 = nil
                end
                local rt = ____temp_2
                if rt == nil or rt.remaining <= 0.001 then
                    __TS__ArraySplice(dotTicks, i, 1)
                end
                i = i - 1
            end
        end
        local toRun = {}
        do
            local i = #dotTicks - 1
            while i >= 0 do
                local e = dotTicks[i + 1]
                if not isDotTargetPaused(e.target) then
                    toRun[#toRun + 1] = e
                end
                i = i - 1
            end
        end
        local batch = {}
        do
            local bi = 0
            while bi < #toRun do
                local bh = unitHid(toRun[bi + 1].target)
                if bh ~= 0 then
                    batch[bh] = true
                end
                bi = bi + 1
            end
        end
        local batchSnap = batch
        dotTickBatchTargetHids = batchSnap
        local nDeals = #toRun
        dotBatchSnapForClear = batchSnap
        dotBatchDeferredRemaining = nDeals
        do
            local ri = 0
            while ri < #toRun do
                local e = toRun[ri + 1]
                local eh = unitHid(e.target)
                dealDamageForType(e.typeId, e.source, e.target, e.amount)
                addDotEffectOnUnit(e.target, e.effectModel, e.effectDuration)
                local cfg = __TS__ArrayFind(
                    dotTypes,
                    function(____, c) return c.id == e.typeId end
                )
                local state = getDotState(e.typeId, eh)
                if cfg ~= nil and type(cfg.onTick) == "function" and state ~= nil then
                    cfg:onTick(e.target, state)
                end
                ri = ri + 1
            end
        end
        if nDeals <= 0 then
            dotTickBatchTargetHids = nil
            dotBatchSnapForClear = nil
            dotBatchDeferredRemaining = 0
        end
        if #dotTicks == 0 and dotTimer ~= nil then
            LeakWatcher:destroyTimer(dotTimer)
            dotTimer = nil
        end
    end
    local _registeredToCenterTimer = false
    local function ensureDotTimers()
        if _registeredToCenterTimer then
            return
        end
        _registeredToCenterTimer = true
        onSecond(dotTickRun)
    end
    local function notifyDotTickBatchDamageDisplayed()
        if dotBatchDeferredRemaining <= 0 then
            return
        end
        dotBatchDeferredRemaining = dotBatchDeferredRemaining - 1
        if dotBatchDeferredRemaining <= 0 then
            if dotTickBatchTargetHids ~= nil and dotTickBatchTargetHids == dotBatchSnapForClear then
                dotTickBatchTargetHids = nil
            end
            dotBatchSnapForClear = nil
            dotBatchDeferredRemaining = 0
        end
    end
    local function getDotTickBatchTargetHids()
        return dotTickBatchTargetHids
    end
    return {ensureDotTimers = ensureDotTimers, dealDamageForType = dealDamageForType, notifyDotTickBatchDamageDisplayed = notifyDotTickBatchDamageDisplayed, getDotTickBatchTargetHids = getDotTickBatchTargetHids}
end
return ____exports
