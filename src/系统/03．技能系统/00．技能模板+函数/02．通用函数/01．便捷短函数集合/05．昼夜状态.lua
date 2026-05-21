--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 昼夜状态便捷函数
-- 
-- 功能：获取当前游戏时间是白天还是黑天
-- 白天：6:00 - 18:00
-- 黑天：18:00 - 6:00
local jass = require("jass.common")
local GetFloatGameState = jass.GetFloatGameState
local GAME_STATE_TIME_OF_DAY = jass.GAME_STATE_TIME_OF_DAY
local function _____8BFB_53D6_5F53_524D_65F6_95F4()
    if GetFloatGameState == nil or GAME_STATE_TIME_OF_DAY == nil then
        return 12
    end
    return GetFloatGameState(GAME_STATE_TIME_OF_DAY)
end
--- 获取当前游戏时间（小时）
____exports["获取游戏时间"] = function()
    return _____8BFB_53D6_5F53_524D_65F6_95F4()
end
--- 判断是否为白天
-- 白天时间：6:00 - 18:00
____exports["是否白天"] = function()
    local time = _____8BFB_53D6_5F53_524D_65F6_95F4()
    return time >= 6 and time <= 18
end
--- 判断是否为黑天
-- 黑天时间：18:00 - 6:00
____exports["是否黑天"] = function()
    return not ____exports["是否白天"]()
end
--- 获取昼夜状态描述
____exports["获取昼夜状态"] = function()
    return ____exports["是否白天"]() and "白天" or "黑天"
end
return ____exports
