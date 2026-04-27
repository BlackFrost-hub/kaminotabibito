local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
--- 单位死亡事件系统 - 核心功能
-- 
-- 统一注册任意单位死亡事件，提供回调注册接口供其他系统调用。
-- 避免每个系统各自创建死亡触发器造成浪费。
-- 
-- 使用方式：
--   import { onUnitDeath, registerDeathListener } from "系统.01．单位系统.03．单位死亡事件.01．核心功能";
-- 
--   // 注册监听
--   registerDeathListener((dyingUnit, killingUnit) => {
--     // 处理死亡逻辑
--   });
-- 
--   // 主动触发（一般不需要，由系统内部自动调用）
--   onUnitDeath();
local jass = require("jass.common")
local playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
local listeners = {}
local DEATH_EVENT_PLAYER_IDS = {
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
local function onUnitDeath()
    local dyingUnit = jass.GetTriggerUnit()
    if dyingUnit == nil then
        return
    end
    local killingUnit = jass.GetKillingUnit()
    do
        local i = 0
        while i < #listeners do
            local cb = listeners[i + 1]
            if type(cb) == "function" then
                cb(nil, dyingUnit, killingUnit)
            end
            i = i + 1
        end
    end
end
function ____exports.registerDeathListener(self, callback)
    if type(callback) ~= "function" then
        return
    end
    listeners[#listeners + 1] = callback
end
function ____exports.unregisterDeathListener(self, callback)
    local idx = __TS__ArrayIndexOf(listeners, callback)
    if idx >= 0 then
        __TS__ArraySplice(listeners, idx, 1)
    end
end
function ____exports.init()
    if _initialized then
        return
    end
    _initialized = true
    local trig = jass.CreateTrigger()
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, DEATH_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_DEATH)
    jass.TriggerAddAction(trig, onUnitDeath)
end
return ____exports
