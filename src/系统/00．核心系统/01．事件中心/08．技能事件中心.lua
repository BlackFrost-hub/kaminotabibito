local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local dispatchSpellListeners, dispatchSkillLearnListeners, onSpellChannel, onSpellEffect, onSpellFinish, onSpellEndcast, onSkillLearn, jass, debugLogForce, GetUnitTypeId, GetHandleId, _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID, playerUnitEvent, channelListeners, effectListeners, finishListeners, endcastListeners, skillLearnListeners, initialized, skillLearnInitialized
function dispatchSpellListeners(list, castingUnit, spellAbilityId)
    do
        local i = 0
        while i < #list do
            local callback = list[i + 1]
            if callback ~= nil then
                callback(castingUnit, spellAbilityId)
            end
            i = i + 1
        end
    end
end
function dispatchSkillLearnListeners(list, learningUnit, learnedAbilityId)
    do
        local i = 0
        while i < #list do
            local callback = list[i + 1]
            if callback ~= nil then
                callback(learningUnit, learnedAbilityId)
            end
            i = i + 1
        end
    end
end
function onSpellChannel()
    local castingUnit = jass:GetTriggerUnit()
    if castingUnit == nil then
        return
    end
    local spellAbilityId = jass:GetSpellAbilityId()
    if spellAbilityId == nil then
        return
    end
    dispatchSpellListeners(channelListeners, castingUnit, spellAbilityId)
end
function onSpellEffect()
    local castingUnit = jass:GetTriggerUnit()
    if castingUnit == nil then
        return
    end
    local spellAbilityId = jass:GetSpellAbilityId()
    if spellAbilityId == nil then
        return
    end
    if GetUnitTypeId(castingUnit) == _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID then
        debugLogForce(
            "藤原妹红施法事件诊断",
            "收到SPELL_EFFECT",
            "施法者",
            GetHandleId(castingUnit),
            "技能ID",
            spellAbilityId,
            "监听数",
            #effectListeners
        )
    end
    dispatchSpellListeners(effectListeners, castingUnit, spellAbilityId)
end
function onSpellFinish()
    local castingUnit = jass:GetTriggerUnit()
    if castingUnit == nil then
        return
    end
    local spellAbilityId = jass:GetSpellAbilityId()
    if spellAbilityId == nil then
        return
    end
    dispatchSpellListeners(finishListeners, castingUnit, spellAbilityId)
end
function onSpellEndcast()
    local castingUnit = jass:GetTriggerUnit()
    if castingUnit == nil then
        return
    end
    local spellAbilityId = jass:GetSpellAbilityId()
    if spellAbilityId == nil then
        return
    end
    dispatchSpellListeners(endcastListeners, castingUnit, spellAbilityId)
end
function onSkillLearn()
    local learningUnit = jass:GetTriggerUnit()
    if learningUnit == nil then
        return
    end
    local learnedAbilityId = jass:GetLearnedSkill()
    if learnedAbilityId == nil then
        return
    end
    dispatchSkillLearnListeners(skillLearnListeners, learningUnit, learnedAbilityId)
end
--- 初始化技能事件中心。
-- 统一注册 SPELL_CHANNEL / SPELL_EFFECT / SPELL_FINISH / SPELL_ENDCAST 原生事件，并集中派发给监听器。
function ____exports.initSpellEventCenter()
    if initialized then
        return
    end
    initialized = true
    local channelTrigger = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(channelTrigger, ____exports.SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    jass:TriggerAddAction(channelTrigger, onSpellChannel)
    local effectTrigger = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(effectTrigger, ____exports.SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT)
    jass:TriggerAddAction(effectTrigger, onSpellEffect)
    local finishTrigger = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(finishTrigger, ____exports.SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_FINISH)
    jass:TriggerAddAction(finishTrigger, onSpellFinish)
    local endcastTrigger = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(endcastTrigger, ____exports.SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    jass:TriggerAddAction(endcastTrigger, onSpellEndcast)
end
--- 初始化学习技能事件。
function ____exports.initSkillLearnEvent()
    if skillLearnInitialized then
        return
    end
    skillLearnInitialized = true
    local learnTrigger = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(learnTrigger, ____exports.SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_HERO_SKILL)
    jass:TriggerAddAction(learnTrigger, onSkillLearn)
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
GetUnitTypeId = jass.GetUnitTypeId
GetHandleId = jass.GetHandleId
_____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID = stringToFourCCSafe("H00R")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
____exports.SPELL_EVENT_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15
}
channelListeners = {}
effectListeners = {}
finishListeners = {}
endcastListeners = {}
skillLearnListeners = {}
initialized = false
skillLearnInitialized = false
local function hasListener(list, callback)
    do
        local i = 0
        while i < #list do
            if list[i + 1] == callback then
                return true
            end
            i = i + 1
        end
    end
    return false
end
--- 注册技能准备阶段监听。
-- 第一次使用时会自动初始化事件中心；同一回调不会重复注册。
function ____exports.registerSpellChannelListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initSpellEventCenter()
    if not hasListener(channelListeners, callback) then
        channelListeners[#channelListeners + 1] = callback
    end
end
--- 取消技能准备阶段监听。
function ____exports.unregisterSpellChannelListener(callback)
    local index = __TS__ArrayIndexOf(channelListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(channelListeners, index, 1)
    end
end
--- 注册技能生效阶段监听。
-- 第一次使用时会自动初始化事件中心；同一回调不会重复注册。
function ____exports.registerSpellEffectListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initSpellEventCenter()
    if not hasListener(effectListeners, callback) then
        effectListeners[#effectListeners + 1] = callback
    end
end
--- 取消技能生效阶段监听。
function ____exports.unregisterSpellEffectListener(callback)
    local index = __TS__ArrayIndexOf(effectListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(effectListeners, index, 1)
    end
end
--- 注册技能成功完成监听。
function ____exports.registerSpellFinishListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initSpellEventCenter()
    if not hasListener(finishListeners, callback) then
        finishListeners[#finishListeners + 1] = callback
    end
end
--- 取消技能成功完成监听。
function ____exports.unregisterSpellFinishListener(callback)
    local index = __TS__ArrayIndexOf(finishListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(finishListeners, index, 1)
    end
end
--- 注册技能结束施法监听。
-- 第一次使用时会自动初始化事件中心；同一回调不会重复注册。
function ____exports.registerSpellEndcastListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initSpellEventCenter()
    if not hasListener(endcastListeners, callback) then
        endcastListeners[#endcastListeners + 1] = callback
    end
end
--- 取消技能结束施法监听。
function ____exports.unregisterSpellEndcastListener(callback)
    local index = __TS__ArrayIndexOf(endcastListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(endcastListeners, index, 1)
    end
end
--- 注册学习技能监听。
-- 第一次使用时会自动初始化事件；同一回调不会重复注册。
function ____exports.registerSkillLearnListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initSkillLearnEvent()
    if not hasListener(skillLearnListeners, callback) then
        skillLearnListeners[#skillLearnListeners + 1] = callback
    end
end
--- 取消学习技能监听。
function ____exports.unregisterSkillLearnListener(callback)
    local index = __TS__ArrayIndexOf(skillLearnListeners, callback)
    if index >= 0 then
        __TS__ArraySplice(skillLearnListeners, index, 1)
    end
end
return ____exports
