local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local dispatchSpellListeners, onSpellChannel, onSpellEffect, jass, playerUnitEvent, channelListeners, effectListeners, SPELL_EVENT_PLAYER_IDS, _initialized
function dispatchSpellListeners(self, list, castingUnit, spellAbilityId)
    do
        local i = 0
        while i < #list do
            local callback = list[i + 1]
            if callback ~= nil then
                callback(nil, castingUnit, spellAbilityId)
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
    dispatchSpellListeners(nil, channelListeners, castingUnit, spellAbilityId)
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
    dispatchSpellListeners(nil, effectListeners, castingUnit, spellAbilityId)
end
function ____exports.init()
    if _initialized then
        return
    end
    _initialized = true
    local channelTrig = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(channelTrig, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    jass:TriggerAddAction(channelTrig, onSpellChannel)
    local effectTrig = jass:CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(effectTrig, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT)
    jass:TriggerAddAction(effectTrig, onSpellEffect)
end
jass = require("jass.common")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
channelListeners = {}
effectListeners = {}
SPELL_EVENT_PLAYER_IDS = {
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
_initialized = false
local function hasListener(self, list, callback)
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
function ____exports.registerSpellChannelListener(self, callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.init()
    if not hasListener(nil, channelListeners, callback) then
        channelListeners[#channelListeners + 1] = callback
    end
end
function ____exports.unregisterSpellChannelListener(self, callback)
    local idx = __TS__ArrayIndexOf(channelListeners, callback)
    if idx >= 0 then
        __TS__ArraySplice(channelListeners, idx, 1)
    end
end
function ____exports.registerSpellEffectListener(self, callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.init()
    if not hasListener(nil, effectListeners, callback) then
        effectListeners[#effectListeners + 1] = callback
    end
end
function ____exports.unregisterSpellEffectListener(self, callback)
    local idx = __TS__ArrayIndexOf(effectListeners, callback)
    if idx >= 0 then
        __TS__ArraySplice(effectListeners, idx, 1)
    end
end
return ____exports
