local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____04_FF0EDOT_5DE5_5177 = require("系统.04．伤害系统.01．DOT定义.04．DOT工具")
local clearIgnoredTarget = ____04_FF0EDOT_5DE5_5177.clearIgnoredTarget
local getDotState = ____04_FF0EDOT_5DE5_5177.getDotState
local setIgnoredTarget = ____04_FF0EDOT_5DE5_5177.setIgnoredTarget
local ____00_FF0EBuff_7CFB_7EDF = require("系统.05．Buff系统.00．Buff系统")
local DOT_TYPE_TO_BUFF_ID = ____00_FF0EBuff_7CFB_7EDF.DOT_TYPE_TO_BUFF_ID
local getBuffRuntimeByHid = ____00_FF0EBuff_7CFB_7EDF.getBuffRuntimeByHid
local ____07_FF0E_6301_7EED_4F24_5BB3_7CFB_7EDF = require("系统.04．伤害系统.07．持续伤害系统")
local _____8BA1_7B97_6301_7EED_4F24_5BB3_6700_7EC8_503C = ____07_FF0E_6301_7EED_4F24_5BB3_7CFB_7EDF["计算持续伤害最终值"]
local ____08_FF0E_6280_80FD_4F24_5BB3_7CFB_7EDF = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_88C5_5907_6280_80FD_4F24_5BB3 = ____08_FF0E_6280_80FD_4F24_5BB3_7CFB_7EDF["造成装备技能伤害"]
local unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local YDWETimerDestroyEffect = ____require_result_0.YDWETimerDestroyEffect
--- DOT 秒跳目标被 `PauseUnit` 暂停时不结算伤害/特效/onTick（与 Buff 池不计时一致）
local __pcallPausedUnit = 0
local __pcallPausedResult = false
local function __pcallIsUnitPausedBody(self)
    local fn = unitBjExt.IsUnitPausedBJ
    if fn ~= nil then
        __pcallPausedResult = fn(nil, __pcallPausedUnit) == true
    end
end
local function isDotTargetPaused(self, u)
    if u == nil or u == 0 then
        return false
    end
    local fn = unitBjExt.IsUnitPausedBJ
    if fn == nil then
        return false
    end
    __pcallPausedUnit = u
    __pcallPausedResult = false
    pcall(__pcallIsUnitPausedBody)
    return __pcallPausedResult
end
function ____exports.createDotExecutor(self, deps)
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
    local function addDotEffectOnUnit(self, unit, model, duration)
        if not unit or not model or model == "" then
            return
        end
        local eff = jass:AddSpecialEffectTarget(model, unit, "origin")
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
            dotTypes,
            function(____, c) return c.id == typeId end
        )
        if cfg == nil then
            return
        end
        local finalAmount = _____8BA1_7B97_6301_7EED_4F24_5BB3_6700_7EC8_503C(source, amount)
        if not (finalAmount > 0) then
            return
        end
        local dh = unitHid(nil, target)
        do
            local di = 0
            while di < #dotTypes do
                local tid = dotTypes[di + 1].id
                setIgnoredTarget(nil, tid, dh)
                di = di + 1
            end
        end
        if type(damageEventModule.markNextPendingDamageAsDotTickBatch) == "function" then
            damageEventModule:markNextPendingDamageAsDotTickBatch()
        end
        _____9020_6210_88C5_5907_6280_80FD_4F24_5BB3({
            ["来源"] = source,
            ["目标"] = target,
            ["伤害"] = finalAmount,
            ["伤害类型"] = cfg.damageType,
            attack = false,
            ranged = false,
            attackType = jass.ATTACK_TYPE_NORMAL,
            weaponType = jass.WEAPON_TYPE_WHOKNOWS,
            ["装备技能类型"] = "装备持续伤害",
            ["伤害形态"] = "单体"
        })
        do
            local ci = 0
            while ci < #dotTypes do
                clearIgnoredTarget(nil, dotTypes[ci + 1].id, dh)
                ci = ci + 1
            end
        end
    end
    local function dotTickRun(self)
        do
            local i = #dotTicks - 1
            while i >= 0 do
                local e = dotTicks[i + 1]
                local eh = unitHid(nil, e.target)
                local bid = DOT_TYPE_TO_BUFF_ID[e.typeId]
                local ____temp_1
                if bid ~= nil and bid ~= "" then
                    ____temp_1 = getBuffRuntimeByHid(eh, bid)
                else
                    ____temp_1 = nil
                end
                local rt = ____temp_1
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
                local bh = unitHid(nil, toRun[bi + 1].target)
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
                local eh = unitHid(nil, e.target)
                dealDamageForType(
                    nil,
                    e.typeId,
                    e.source,
                    e.target,
                    e.amount
                )
                addDotEffectOnUnit(nil, e.target, e.effectModel, e.effectDuration)
                local cfg = __TS__ArrayFind(
                    dotTypes,
                    function(____, c) return c.id == e.typeId end
                )
                local state = getDotState(nil, e.typeId, eh)
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
    local function ensureDotTimers(self)
        if _registeredToCenterTimer then
            return
        end
        _registeredToCenterTimer = true
        local ____G_2 = _G
        local onSecond = ____G_2.onSecond
        onSecond(dotTickRun)
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
