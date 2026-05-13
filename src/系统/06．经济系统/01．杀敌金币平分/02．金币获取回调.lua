--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 杀敌金币平分系统 - 金币获取回调
-- 
-- 功能：
-- 1. 处理金币获取率加成
-- 2. 触发STES数值显示事件
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.06．经济系统.01．杀敌金币平分.00．常量定义")
local GOLD_RATE_THRESHOLD = ____require_result_0.GOLD_RATE_THRESHOLD
local EVENT_VALUE_DISPLAY = ____require_result_0.EVENT_VALUE_DISPLAY
local YDLOCAL_VAR_UNIT = ____require_result_0.YDLOCAL_VAR_UNIT
local YDLOCAL_VAR_REAL = ____require_result_0.YDLOCAL_VAR_REAL
local YDLOCAL_VAR_BLUE = ____require_result_0.YDLOCAL_VAR_BLUE
local YDLOCAL_VAR_SIZE = ____require_result_0.YDLOCAL_VAR_SIZE
local YDLOCAL_VAR_STRING = ____require_result_0.YDLOCAL_VAR_STRING
local DEFAULT_BLUE = ____require_result_0.DEFAULT_BLUE
local DEFAULT_TEXT_SIZE = ____require_result_0.DEFAULT_TEXT_SIZE
local GOLD_STRING_INDEX = ____require_result_0.GOLD_STRING_INDEX
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataGet = ____require_result_1.YDUserDataGet
local ____require_result_2 = require("lib.扩展函数.YDWE函数.04．YDWE_trigger")
local YDLocalExecuteTrigger = ____require_result_2.YDLocalExecuteTrigger
local saveParentIndex = ____require_result_2.saveParentIndex
local YDTriggerExecuteTrigger = ____require_result_2.YDTriggerExecuteTrigger
local ____require_result_3 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Set = ____require_result_3.YDLocal5Set
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_GetTable = ____require_result_4.STES_GetTable
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AdjustPlayerStateBJ = ____require_result_5.AdjustPlayerStateBJ
local ____require_result_6 = require("系统.06．经济系统.01．杀敌金币平分.01．核心功能")
local registerGoldGainCallback = ____require_result_6.registerGoldGainCallback
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
    local ht = STES_GetTable(nil, nil)
    if not ht then
        return
    end
    local hash = jass:StringHash(EVENT_VALUE_DISPLAY)
    local skeyIndex = jass:StringHash("index")
    local count = jass:LoadInteger(ht, hash, skeyIndex)
    do
        local i = 0
        while i < count do
            local trg = jass:LoadTriggerHandle(ht, hash, i)
            if trg then
                YDLocalExecuteTrigger(nil, trg)
                saveParentIndex(nil, trg)
                YDLocal5Set(nil, "unit", YDLOCAL_VAR_UNIT, unit)
                YDLocal5Set(nil, "real", YDLOCAL_VAR_REAL, gold)
                YDLocal5Set(nil, "real", YDLOCAL_VAR_BLUE, DEFAULT_BLUE)
                YDLocal5Set(nil, "real", YDLOCAL_VAR_SIZE, DEFAULT_TEXT_SIZE)
                local ____opt_result_11
                if jglobals ~= nil then
                    ____opt_result_11 = jglobals.udg_String
                end
                local ____opt_result_12
                if ____opt_result_11 ~= nil then
                    ____opt_result_12 = ____opt_result_11[GOLD_STRING_INDEX]
                end
                local string48 = ____opt_result_12
                if string48 ~= nil then
                    YDLocal5Set(nil, "string", YDLOCAL_VAR_STRING, string48)
                end
                YDTriggerExecuteTrigger(nil, trg, false)
            end
            i = i + 1
        end
    end
end
--- 处理金币获取率加成并给予金币
local function goldGainCallback(params)
    local ____params_13 = params
    local unit = ____params_13.unit
    local player = ____params_13.player
    local baseGold = ____params_13.baseGold
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
____exports.EVENT_VALUE_DISPLAY = EVENT_VALUE_DISPLAY
____exports.YDLOCAL_VAR_UNIT = YDLOCAL_VAR_UNIT
____exports.YDLOCAL_VAR_REAL = YDLOCAL_VAR_REAL
____exports.YDLOCAL_VAR_BLUE = YDLOCAL_VAR_BLUE
____exports.YDLOCAL_VAR_SIZE = YDLOCAL_VAR_SIZE
____exports.YDLOCAL_VAR_STRING = YDLOCAL_VAR_STRING
return ____exports
