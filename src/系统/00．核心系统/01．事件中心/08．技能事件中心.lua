local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local dispatchSpellListeners, onSpellChannel, onSpellEffect, jass, playerUnitEvent, channelListeners, effectListeners, initialized
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
    dispatchSpellListeners(effectListeners, castingUnit, spellAbilityId)
end
--- 初始化技能事件中心。
-- 统一注册 SPELL_CHANNEL / SPELL_EFFECT 两类原生事件，并集中派发给监听器。
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
end
jass = require("jass.common")
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
initialized = false
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
return ____exports
