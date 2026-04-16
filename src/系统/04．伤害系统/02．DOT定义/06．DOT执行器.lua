local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
function ____exports.createDotExecutor(self, deps)
    local EFFECT_RECYCLE_INTERVAL = 0.2
    local effectRecycleList = {}
    local effectRecycleTimer = nil
    local dotTimer = nil
    local dotTickBatchTargetHids = nil
    local dotBatchSnapForClear = nil
    local dotBatchDeferredRemaining = 0
    local function addDotEffectOnUnit(self, unit, model, duration)
        if not unit or not model or model == "" or type(deps.jass.AddSpecialEffectTarget) ~= "function" then
            return
        end
        local eff = deps.jass.AddSpecialEffectTarget(model, unit, "origin")
        if eff == nil then
            return
        end
        if type(deps.jass.YDWETimerDestroyEffect) == "function" then
            deps.jass.YDWETimerDestroyEffect(duration, eff)
            return
        end
        local ticks = math.ceil(duration / EFFECT_RECYCLE_INTERVAL)
        effectRecycleList[#effectRecycleList + 1] = {eff = eff, ticksLeft = ticks}
        if effectRecycleTimer == nil and type(deps.jass.TimerStart) == "function" then
            effectRecycleTimer = deps.LeakWatcher:createTimer("dot_effectRecycle")
            deps.jass.TimerStart(
                effectRecycleTimer,
                EFFECT_RECYCLE_INTERVAL,
                true,
                function()
                    do
                        local i = #effectRecycleList - 1
                        while i >= 0 do
                            local x = effectRecycleList[i + 1]
                            x.ticksLeft = x.ticksLeft - 1
                            if x.ticksLeft <= 0 then
                                if x.eff ~= nil and type(deps.jass.DestroyEffect) == "function" then
                                    deps.jass.DestroyEffect(x.eff)
                                end
                                __TS__ArraySplice(effectRecycleList, i, 1)
                            end
                            i = i - 1
                        end
                    end
                    if #effectRecycleList == 0 and effectRecycleTimer ~= nil then
                        deps.LeakWatcher:destroyTimer(effectRecycleTimer)
                        effectRecycleTimer = nil
                    end
                end
            )
        end
    end
    local function dealDamageForType(self, typeId, source, target, amount)
        if type(deps.jass.UnitDamageTarget) ~= "function" then
            return
        end
        local cfg = __TS__ArrayFind(
            deps.dotTypes,
            function(____, c) return c.id == typeId end
        )
        if cfg == nil then
            return
        end
        local dh = deps:unitHid(target)
        do
            local di = 0
            while di < #deps.dotTypes do
                local tid = deps.dotTypes[di + 1].id
                if deps.ignoredTargetByType[tid] == nil then
                    deps.ignoredTargetByType[tid] = {}
                end
                deps.ignoredTargetByType[tid][dh] = true
                di = di + 1
            end
        end
        if type(deps.damageEventModule.markNextPendingDamageAsDotTickBatch) == "function" then
            deps.damageEventModule:markNextPendingDamageAsDotTickBatch()
        end
        deps.jass.UnitDamageTarget(
            source,
            target,
            amount,
            false,
            false,
            deps.jass.ATTACK_TYPE_NORMAL,
            cfg.damageType,
            deps.jass.WEAPON_TYPE_WHOKNOWS
        )
    end
    local function dotTickRun(self)
        local buffM = require("系统.05．Buff系统.00．Buff系统")
        do
            local i = #deps.dotTicks - 1
            while i >= 0 do
                local e = deps.dotTicks[i + 1]
                local eh = deps:unitHid(e.target)
                local ____temp_0
                if buffM.DOT_TYPE_TO_BUFF_ID ~= nil then
                    ____temp_0 = buffM.DOT_TYPE_TO_BUFF_ID[e.typeId]
                else
                    ____temp_0 = nil
                end
                local bid = ____temp_0
                local ____temp_1
                if bid ~= nil and bid ~= "" and type(buffM.getBuffRuntimeByHid) == "function" then
                    ____temp_1 = buffM:getBuffRuntimeByHid(eh, bid)
                else
                    ____temp_1 = nil
                end
                local rt = ____temp_1
                if rt == nil or rt.remaining <= 0.001 then
                    __TS__ArraySplice(deps.dotTicks, i, 1)
                end
                i = i - 1
            end
        end
        local batch = {}
        do
            local bi = #deps.dotTicks - 1
            while bi >= 0 do
                local bh = deps:unitHid(deps.dotTicks[bi + 1].target)
                if bh ~= 0 then
                    batch[bh] = true
                end
                bi = bi - 1
            end
        end
        local batchSnap = batch
        dotTickBatchTargetHids = batchSnap
        local nDeals = #deps.dotTicks
        dotBatchSnapForClear = batchSnap
        dotBatchDeferredRemaining = nDeals
        do
            local i = #deps.dotTicks - 1
            while i >= 0 do
                local e = deps.dotTicks[i + 1]
                local eh = deps:unitHid(e.target)
                dealDamageForType(
                    nil,
                    e.typeId,
                    e.source,
                    e.target,
                    e.amount
                )
                addDotEffectOnUnit(nil, e.target, e.effectModel, e.effectDuration)
                local cfg = __TS__ArrayFind(
                    deps.dotTypes,
                    function(____, c) return c.id == e.typeId end
                )
                local stTab = deps.stateByType[e.typeId]
                local ____temp_3
                if stTab ~= nil then
                    local ____temp_2 = deps:tabRowForHid(stTab, eh)
                    if ____temp_2 == nil then
                        ____temp_2 = stTab[e.target]
                    end
                    ____temp_3 = ____temp_2
                else
                    ____temp_3 = nil
                end
                local stateRaw = ____temp_3
                local state = deps:isValidDotStateRow(stateRaw) and stateRaw or nil
                if cfg ~= nil and type(cfg.onTick) == "function" and state ~= nil then
                    cfg:onTick(e.target, state)
                end
                i = i - 1
            end
        end
        if nDeals <= 0 then
            dotTickBatchTargetHids = nil
            dotBatchSnapForClear = nil
            dotBatchDeferredRemaining = 0
        end
        if #deps.dotTicks == 0 and dotTimer ~= nil then
            deps.LeakWatcher:destroyTimer(dotTimer)
            dotTimer = nil
        end
    end
    local _registeredToCenterTimer = false
    local function ensureDotTimers(self)
        if _registeredToCenterTimer then
            return
        end
        _registeredToCenterTimer = true
        local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
        local onSecond = ____require_result_4.onSecond
        onSecond(nil, dotTickRun)
    end
    local function notifyDotTickBatchDamageDisplayed(self)
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
    local function getDotTickBatchTargetHids(self)
        return dotTickBatchTargetHids
    end
    return {ensureDotTimers = ensureDotTimers, dealDamageForType = dealDamageForType, notifyDotTickBatchDamageDisplayed = notifyDotTickBatchDamageDisplayed, getDotTickBatchTargetHids = getDotTickBatchTargetHids}
end
return ____exports
