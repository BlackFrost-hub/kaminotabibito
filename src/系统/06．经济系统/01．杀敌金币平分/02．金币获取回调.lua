--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 杀敌金币平分系统 - 金币获取回调
-- 
-- 功能：
-- 1. 处理金币获取率加成
-- 2. 直接显示金币数值漂浮文字
local jass = require("jass.common")
local ____require_result_0 = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义")
local GOLD_RATE_THRESHOLD = ____require_result_0.GOLD_RATE_THRESHOLD
local DEFAULT_BLUE = ____require_result_0.DEFAULT_BLUE
local DEFAULT_TEXT_SIZE = ____require_result_0.DEFAULT_TEXT_SIZE
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_1.YDUserDataGet
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AdjustPlayerStateBJ = ____require_result_2.AdjustPlayerStateBJ
local ____require_result_3 = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字")
local _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57 = ____require_result_3["显示单位数值漂浮文字"]
local ____require_result_4 = require("系统.06．经济系统.01．杀敌金币平分.01．核心功能")
local registerGoldGainCallback = ____require_result_4.registerGoldGainCallback
--- 获取玩家金币获取率
local function getPlayerGoldRate(player)
    local rate = YDUserDataGet(
        nil,
        "player",
        player,
        "金币获取率",
        "real"
    )
    return type(rate) == "number" and rate or 0
end
local function fireStesEvent(unit, gold)
    _____663E_793A_5355_4F4D_6570_503C_6F02_6D6E_6587_5B57(unit, gold, {
        ["后缀"] = "金币",
        ["大小"] = DEFAULT_TEXT_SIZE,
        ["红"] = 255,
        ["绿"] = 215,
        ["蓝"] = DEFAULT_BLUE,
        ["持续时间"] = 1.25
    })
end
--- 处理金币获取率加成并给予金币
local function goldGainCallback(params)
    local ____params_5 = params
    local unit = ____params_5.unit
    local player = ____params_5.player
    local baseGold = ____params_5.baseGold
    local goldRate = getPlayerGoldRate(player)
    local finalGold = baseGold
    if goldRate >= GOLD_RATE_THRESHOLD then
        finalGold = jass:R2I(baseGold * (1 + goldRate))
    end
    AdjustPlayerStateBJ(nil, finalGold, player, jass.PLAYER_STATE_RESOURCE_GOLD)
    fireStesEvent(unit, finalGold)
    return finalGold
end
registerGoldGainCallback(nil, goldGainCallback)
return ____exports
