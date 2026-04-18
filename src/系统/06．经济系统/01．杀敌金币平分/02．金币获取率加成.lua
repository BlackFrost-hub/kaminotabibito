local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____require_result_0 = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义")
local GOLD_RATE_THRESHOLD = ____require_result_0.GOLD_RATE_THRESHOLD
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_1.YDUserDataGet
local ____require_result_2 = require("系统.06．经济系统.01．杀敌金币平分.01．核心功能")
local registerGoldGainCallback = ____require_result_2.registerGoldGainCallback
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
--- 处理金币获取率加成
local function goldRateCallback(params)
    local ____params_3 = params
    local player = ____params_3.player
    local baseGold = ____params_3.baseGold
    local goldRate = getPlayerGoldRate(player)
    local finalGold = baseGold
    if goldRate >= GOLD_RATE_THRESHOLD then
        finalGold = math.floor(baseGold * (1 + goldRate))
    end
    return __TS__ObjectAssign({}, params, {finalGold = finalGold})
end
registerGoldGainCallback(nil, goldRateCallback)
return ____exports
