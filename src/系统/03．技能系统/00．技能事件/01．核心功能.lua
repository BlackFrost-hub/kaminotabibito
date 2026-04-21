local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 技能事件系统 - 核心功能
-- 
-- 统一注册技能相关事件，提供回调注册接口供其他系统调用。
-- 避免每个系统各自创建技能触发器造成浪费。
-- 
-- 支持事件：
--   - SPELL_CHANNEL  准备使用技能
--   - SPELL_EFFECT   发动技能效果
-- 
-- 使用方式：
--   const { registerSpellChannelListener, registerSpellEffectListener } =
--     require("系统.03．技能系统.00．技能事件.01．核心功能") as { ... };
-- 
--   registerSpellChannelListener((castingUnit, spellAbilityId) => {
--     // 处理准备施法逻辑
--   });
-- 
--   registerSpellEffectListener((castingUnit, spellAbilityId) => {
--     // 处理发动技能效果逻辑
--   });
local jass = require("jass.common")
local playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local channelListeners = {}
local effectListeners = {}
local SPELL_EVENT_PLAYER_IDS = {
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
local _initialized = false
local function onSpellChannel()
    local castingUnit = jass.GetTriggerUnit()
    if castingUnit == nil then
        return
    end
    local spellAbilityId = jass.GetSpellAbilityId()
    if spellAbilityId == nil then
        return
    end
    do
        local i = 0
        while i < #channelListeners do
            local cb = channelListeners[i + 1]
            cb(nil, castingUnit, spellAbilityId)
            i = i + 1
        end
    end
end
local function onSpellEffect()
    local castingUnit = jass.GetTriggerUnit()
    if castingUnit == nil then
        return
    end
    local spellAbilityId = jass.GetSpellAbilityId()
    if spellAbilityId == nil then
        return
    end
    do
        local i = 0
        while i < #effectListeners do
            local cb = effectListeners[i + 1]
            cb(nil, castingUnit, spellAbilityId)
            i = i + 1
        end
    end
end
function ____exports.registerSpellChannelListener(self, callback)
    if type(callback) ~= "function" then
        return
    end
    channelListeners[#channelListeners + 1] = callback
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
    effectListeners[#effectListeners + 1] = callback
end
function ____exports.unregisterSpellEffectListener(self, callback)
    local idx = __TS__ArrayIndexOf(effectListeners, callback)
    if idx >= 0 then
        __TS__ArraySplice(effectListeners, idx, 1)
    end
end
function ____exports.init()
    if _initialized then
        return
    end
    _initialized = true
    local channelTrig = jass.CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(channelTrig, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    jass.TriggerAddAction(channelTrig, onSpellChannel)
    local effectTrig = jass.CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(effectTrig, SPELL_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT)
    jass.TriggerAddAction(effectTrig, onSpellEffect)
end
return ____exports
