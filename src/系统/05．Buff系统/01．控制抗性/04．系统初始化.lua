--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 控制抗性系统初始化
-- 
-- 通过统一技能事件系统监听控制技能
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.01．控制抗性.01．控制检测")
local isExcludedFromControlResist = ____require_result_0.isExcludedFromControlResist
local isControlAbility = ____require_result_0.isControlAbility
local isUnitControlled = ____require_result_0.isUnitControlled
local ____require_result_1 = require("系统.05．Buff系统.01．控制抗性.02．控制时间计算")
local calcReducedControlTime = ____require_result_1.calcReducedControlTime
local ____require_result_2 = require("系统.05．Buff系统.01．控制抗性.03．控制重施放")
local recastControlAbility = ____require_result_2.recastControlAbility
local ____require_result_3 = require("系统.03．技能系统.00．技能事件.01．核心功能")
local registerSpellChannelListener = ____require_result_3.registerSpellChannelListener
local ALLOWED_PLAYERS = {
    0,
    1,
    2,
    3,
    6,
    7,
    jass.PLAYER_NEUTRAL_AGGRESSIVE
}
local function isAllowedPlayer(self, player)
    local id = jass.GetPlayerId(player)
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
local function onSpellChannel(self, caster, abilityId)
    if not isAllowedPlayer(
        nil,
        jass.GetOwningPlayer(caster)
    ) then
        return
    end
    if isExcludedFromControlResist(nil, caster) then
        return
    end
    local target = jass.GetSpellTargetUnit()
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
    local timer = jass.CreateTimer()
    jass.TimerStart(
        timer,
        0,
        false,
        function()
            if isUnitControlled(nil, target) then
                recastControlAbility(
                    nil,
                    caster,
                    target,
                    abilityId,
                    duration
                )
            end
            jass.DestroyTimer(timer)
        end
    )
end
local _initialized = false
function ____exports.initControlResist(self)
    if _initialized then
        return
    end
    _initialized = true
    registerSpellChannelListener(nil, onSpellChannel)
end
return ____exports
