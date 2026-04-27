local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWETimerDestroyEffect = ____require_result_0.YDWETimerDestroyEffect
--- DOT 秒跳目标被 `PauseUnit` 暂停时不结算伤害/特效/onTick（与 Buff 池不计时一致）
local function isDotTargetPaused(self, u)
    if u == nil or u == 0 then
        return false
    end
    local fn = unitBjExt.IsUnitPausedBJ
    if fn == nil then
        return false
    end
    local paused = false
    pcall(
        nil,
        function()
            paused = fn(nil, u) == true
        end
    )
    return paused
end
function ____exports.createDotExecutor(self, deps)
    local dotTimer = nil
    local dotTickBatchTargetHids = nil
    local dotBatchSnapForClear = nil
    local dotBatchDeferredRemaining = 0
    local function addDotEffectOnUnit(self, unit, model, duration)
        if not unit or not model or model == "" then
            return
        end
        local eff = deps.jass:AddSpecialEffectTarget(model, unit, "origin")
        if eff == nil then
            return
        end
        YDWETimerDestroyEffect(nil, duration, eff)
    end
    local function dealDamageForType(self, typeId, source, target, amount)
        if isDotTargetPaused(nil, target) then
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
        deps.jass:UnitDamageTarget(
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
                local ____temp_1
                if buffM.DOT_TYPE_TO_BUFF_ID ~= nil then
                    ____temp_1 = buffM.DOT_TYPE_TO_BUFF_ID[e.typeId]
                else
                    ____temp_1 = nil
                end
                local bid = ____temp_1
                local ____temp_2
                if bid ~= nil and bid ~= "" and type(buffM.getBuffRuntimeByHid) == "function" then
                    ____temp_2 = buffM:getBuffRuntimeByHid(eh, bid)
                else
                    ____temp_2 = nil
                end
                local rt = ____temp_2
                if rt == nil or rt.remaining <= 0.001 then
                    __TS__ArraySplice(deps.dotTicks, i, 1)
                end
                i = i - 1
            end
        end
        local toRun = {}
        do
            local i = #deps.dotTicks - 1
            while i >= 0 do
                local e = deps.dotTicks[i + 1]
                if not isDotTargetPaused(nil, e.target) then
                    toRun[#toRun + 1] = e
                end
                i = i - 1
            end
        end
        local batch = {}
        do
            local bi = 0
            while bi < #toRun do
                local bh = deps:unitHid(toRun[bi + 1].target)
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
                local ____temp_4
                if stTab ~= nil then
                    local ____temp_3 = deps:tabRowForHid(stTab, eh)
                    if ____temp_3 == nil then
                        ____temp_3 = stTab[e.target]
                    end
                    ____temp_4 = ____temp_3
                else
                    ____temp_4 = nil
                end
                local stateRaw = ____temp_4
                local state = deps:isValidDotStateRow(stateRaw) and stateRaw or nil
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
        local ____G_5 = _G
        local onSecond = ____G_5.onSecond
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
