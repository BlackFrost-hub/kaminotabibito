local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local dispatchHeroLevelEvent, jass, playerUnitEvent, heroLevelListeners, heroLevelTrigger, _initialized
function dispatchHeroLevelEvent()
    local heroUnit = jass.GetTriggerUnit()
    if heroUnit == nil then
        return
    end
    do
        local i = 0
        while i < #heroLevelListeners do
            local callback = heroLevelListeners[i + 1]
            if callback ~= nil then
                callback(heroUnit)
            end
            i = i + 1
        end
    end
end
--- 初始化英雄升级事件中心。
-- 对项目约定的玩家集合统一注册升级事件，并把原生事件集中派发给监听列表。
function ____exports.initHeroLevelEventCenter()
    if _initialized then
        return
    end
    _initialized = true
    heroLevelTrigger = jass.CreateTrigger()
    local ____jass_EVENT_PLAYER_HERO_LEVEL_0 = jass.EVENT_PLAYER_HERO_LEVEL
    if ____jass_EVENT_PLAYER_HERO_LEVEL_0 == nil then
        ____jass_EVENT_PLAYER_HERO_LEVEL_0 = 46
    end
    local levelEventId = ____jass_EVENT_PLAYER_HERO_LEVEL_0
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(heroLevelTrigger, ____exports.HERO_LEVEL_EVENT_PLAYER_IDS, levelEventId)
    jass.TriggerAddAction(heroLevelTrigger, dispatchHeroLevelEvent)
end
jass = require("jass.common")
playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
____exports.HERO_LEVEL_EVENT_PLAYER_IDS = {
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
heroLevelListeners = {}
heroLevelTrigger = nil
_initialized = false
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
--- 注册英雄升级监听。
-- 第一次调用时会自动初始化事件中心，后续同一回调不会重复加入。
function ____exports.registerHeroLevelListener(callback)
    if type(callback) ~= "function" then
        return
    end
    ____exports.initHeroLevelEventCenter()
    if not hasListener(heroLevelListeners, callback) then
        heroLevelListeners[#heroLevelListeners + 1] = callback
    end
end
--- 取消英雄升级监听。
function ____exports.unregisterHeroLevelListener(callback)
    local idx = __TS__ArrayIndexOf(heroLevelListeners, callback)
    if idx >= 0 then
        __TS__ArraySplice(heroLevelListeners, idx, 1)
    end
end
return ____exports
