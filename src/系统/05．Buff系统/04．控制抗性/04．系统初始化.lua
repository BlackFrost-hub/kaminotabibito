--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 控制抗性系统初始化
-- 
-- 注册技能施放事件，监听控制技能
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.index")
local TriggerRegisterPlayerUnitEventSimple = ____require_result_0.TriggerRegisterPlayerUnitEventSimple
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetSpellAbilityId = ____require_result_1.GetSpellAbilityId
local ____require_result_2 = require("系统.05．Buff系统.04．控制抗性.01．控制检测")
local isExcludedFromControlResist = ____require_result_2.isExcludedFromControlResist
local isControlAbility = ____require_result_2.isControlAbility
local isUnitControlled = ____require_result_2.isUnitControlled
local ____require_result_3 = require("系统.05．Buff系统.04．控制抗性.02．控制时间计算")
local calcReducedControlTime = ____require_result_3.calcReducedControlTime
local ____require_result_4 = require("系统.05．Buff系统.04．控制抗性.03．控制重施放")
local recastControlAbility = ____require_result_4.recastControlAbility
--- 触发器
local controlTrigger = nil
--- 控制抗性事件处理函数
local function onSpellChannel(self)
    local caster = jass.GetTriggerUnit()
    local target = jass.GetSpellTargetUnit()
    local abilityId = GetSpellAbilityId(nil)
    if isExcludedFromControlResist(nil, caster) then
        return
    end
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
--- 初始化控制抗性系统
function ____exports.initControlResist(self)
    if controlTrigger ~= nil then
        return
    end
    controlTrigger = jass.CreateTrigger()
    do
        local i = 0
        while i <= 3 do
            TriggerRegisterPlayerUnitEventSimple(
                nil,
                controlTrigger,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL
            )
            i = i + 1
        end
    end
    TriggerRegisterPlayerUnitEventSimple(
        nil,
        controlTrigger,
        jass.Player(6),
        jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL
    )
    TriggerRegisterPlayerUnitEventSimple(
        nil,
        controlTrigger,
        jass.Player(7),
        jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL
    )
    TriggerRegisterPlayerUnitEventSimple(
        nil,
        controlTrigger,
        jass.Player(jass.PLAYER_NEUTRAL_AGGRESSIVE),
        jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL
    )
    jass.TriggerAddAction(controlTrigger, onSpellChannel)
end
return ____exports
