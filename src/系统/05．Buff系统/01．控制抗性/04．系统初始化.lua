local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 控制抗性系统初始化
-- 
-- 通过统一技能事件系统监听控制技能
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("系统.05．Buff系统.01．控制抗性.01．控制检测")
local isExcludedFromControlResist = ____require_result_1.isExcludedFromControlResist
local isControlAbility = ____require_result_1.isControlAbility
local isUnitControlled = ____require_result_1.isUnitControlled
local ____require_result_2 = require("系统.05．Buff系统.01．控制抗性.02．控制时间计算")
local calcReducedControlTime = ____require_result_2.calcReducedControlTime
local ____require_result_3 = require("系统.05．Buff系统.01．控制抗性.03．控制重施放")
local recastControlAbility = ____require_result_3.recastControlAbility
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellChannelListener = ____require_result_4.registerSpellChannelListener
local ALLOWED_PLAYERS = {
    0,
    1,
    2,
    3,
    6,
    7,
    jass.PLAYER_NEUTRAL_AGGRESSIVE
}
local controlResistCtxByTimerHid = {}
local function onControlResistTimerExpire()
    local t = jass:GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass:GetHandleId(t)
    local ctx = controlResistCtxByTimerHid[hid]
    __TS__Delete(controlResistCtxByTimerHid, hid)
    safeDestroyTimer(nil, t)
    if not ctx then
        return
    end
    if isUnitControlled(nil, ctx.target) then
        recastControlAbility(
            nil,
            ctx.caster,
            ctx.target,
            ctx.abilityId,
            ctx.duration
        )
    end
end
local function isAllowedPlayer(player)
    local id = jass:GetPlayerId(player)
    do
        local i = 0
        while i < #ALLOWED_PLAYERS do
            if ALLOWED_PLAYERS[i + 1] == id then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function onSpellChannel(caster, abilityId)
    if not isAllowedPlayer(jass:GetOwningPlayer(caster)) then
        return
    end
    if isExcludedFromControlResist(nil, caster) then
        return
    end
    local target = jass:GetSpellTargetUnit()
    if target == nil then
        return
    end
    if not isControlAbility(nil, abilityId) then
        return
    end
    if not isUnitControlled(nil, target) then
        return
    end
    local duration = calcReducedControlTime(nil, target, abilityId)
    local t = jass:CreateTimer()
    if t then
        controlResistCtxByTimerHid[jass:GetHandleId(t)] = {caster = caster, target = target, abilityId = abilityId, duration = duration}
        safeTimerStart(
            nil,
            t,
            0,
            false,
            onControlResistTimerExpire
        )
    end
end
local _initialized = false
function ____exports.initControlResist()
    if _initialized then
        return
    end
    _initialized = true
    registerSpellChannelListener(onSpellChannel)
end
return ____exports
