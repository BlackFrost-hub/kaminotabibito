--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_CooPlayReuse = ____require_result_0.Sound3DII_CooPlayReuse
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local jass = require("jass.common")
local GetRandomInt = jass.GetRandomInt
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
____exports["Boss拟声默认冷却Ms"] = 8000
____exports["Boss坐标音效编排最大段数"] = 4
local ____Boss_62DF_58F0_6C60_4E0B_6B21_53EF_64AD_653E_65F6_95F4 = {}
local ____Boss_62DF_58F0_6C60_4E0A_6B21_4E0B_6807 = {}
____exports["播放Boss坐标音效"] = function(path, x, y, cutoff)
    if path == "" then
        return
    end
    Sound3DII_CooPlayReuse(
        path,
        x,
        y,
        0,
        cutoff
    )
end
____exports["延迟播放Boss坐标音效"] = function(path, x, y, delayMs, cutoff)
    if path == "" then
        return
    end
    addDelayedCallback(
        delayMs,
        function()
            ____exports["播放Boss坐标音效"](path, x, y, cutoff)
        end
    )
end
local function _____53D6_975E_8D1F_6BEB_79D2(value)
    if value == nil or value <= 0 then
        return 0
    end
    return value
end
local function _____5B89_6392Boss_5750_6807_97F3_6548_6BB5(_____6BB5, _____5EF6_8FDFMs, _____9ED8_8BA4_88C1_65AD_8DDD_79BB)
    local cutoff = _____6BB5["裁断距离"] == nil and _____9ED8_8BA4_88C1_65AD_8DDD_79BB or _____6BB5["裁断距离"]
    if _____5EF6_8FDFMs <= 0 then
        ____exports["播放Boss坐标音效"](_____6BB5["音效路径"], _____6BB5.X, _____6BB5.Y, cutoff)
        return
    end
    ____exports["延迟播放Boss坐标音效"](
        _____6BB5["音效路径"],
        _____6BB5.X,
        _____6BB5.Y,
        _____5EF6_8FDFMs,
        cutoff
    )
end
____exports["播放Boss坐标音效编排"] = function(_____53C2_6570)
    local list = _____53C2_6570["音效列表"]
    local count = math.min(____exports["Boss坐标音效编排最大段数"], #list)
    local _____987A_5E8F = _____53C2_6570["模式"] == "顺序延迟"
    local _____7D2F_8BA1Ms = 0
    do
        local i = 0
        while i < count do
            do
                local _____6BB5 = list[i + 1]
                if _____6BB5 == nil or _____6BB5["音效路径"] == "" then
                    goto __continue13
                end
                local _____6BB5_5EF6_8FDFMs = _____53D6_975E_8D1F_6BEB_79D2(_____6BB5["延迟Ms"])
                local _____5B9E_9645_5EF6_8FDFMs = _____987A_5E8F and _____7D2F_8BA1Ms + _____6BB5_5EF6_8FDFMs or _____6BB5_5EF6_8FDFMs
                _____5B89_6392Boss_5750_6807_97F3_6548_6BB5(_____6BB5, _____5B9E_9645_5EF6_8FDFMs, _____53C2_6570["默认裁断距离"])
                if _____987A_5E8F then
                    _____7D2F_8BA1Ms = _____5B9E_9645_5EF6_8FDFMs + _____53D6_975E_8D1F_6BEB_79D2(_____6BB5["持续Ms"])
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
end
local function _____901A_8FC7Boss_62DF_58F0_89E6_53D1_6982_7387(_____53C2_6570)
    local chance = _____53C2_6570["触发概率百分比"] == nil and 100 or _____53C2_6570["触发概率百分比"]
    if chance <= 0 then
        return false
    end
    if chance >= 100 then
        return true
    end
    return GetRandomInt(1, 100) <= chance
end
local function _____9009_62E9Boss_62DF_58F0_8DEF_5F84(_____6807_8BC6, _____97F3_6548_8DEF_5F84_5217_8868)
    local count = #_____97F3_6548_8DEF_5F84_5217_8868
    if count <= 0 then
        return ""
    end
    if count == 1 then
        return _____97F3_6548_8DEF_5F84_5217_8868[1]
    end
    local index = GetRandomInt(0, count - 1)
    local lastIndex = ____Boss_62DF_58F0_6C60_4E0A_6B21_4E0B_6807[_____6807_8BC6]
    if lastIndex ~= nil and index == lastIndex then
        index = (index + 1) % count
    end
    ____Boss_62DF_58F0_6C60_4E0A_6B21_4E0B_6807[_____6807_8BC6] = index
    return _____97F3_6548_8DEF_5F84_5217_8868[index + 1]
end
____exports["尝试播放Boss拟声池"] = function(_____53C2_6570)
    local _____6807_8BC6 = _____53C2_6570["标识"]
    if _____6807_8BC6 == "" or #_____53C2_6570["音效路径列表"] <= 0 then
        return false
    end
    local now = getServerTime()
    local cooldown = _____53C2_6570["冷却Ms"] == nil and ____exports["Boss拟声默认冷却Ms"] or _____53C2_6570["冷却Ms"]
    local nextReady = ____Boss_62DF_58F0_6C60_4E0B_6B21_53EF_64AD_653E_65F6_95F4[_____6807_8BC6]
    if cooldown > 0 and nextReady ~= nil and now < nextReady then
        return false
    end
    if not _____901A_8FC7Boss_62DF_58F0_89E6_53D1_6982_7387(_____53C2_6570) then
        return false
    end
    local path = _____9009_62E9Boss_62DF_58F0_8DEF_5F84(_____6807_8BC6, _____53C2_6570["音效路径列表"])
    if path == "" then
        return false
    end
    ____exports["播放Boss坐标音效"](path, _____53C2_6570.X, _____53C2_6570.Y, _____53C2_6570["裁断距离"])
    if cooldown > 0 then
        ____Boss_62DF_58F0_6C60_4E0B_6B21_53EF_64AD_653E_65F6_95F4[_____6807_8BC6] = now + cooldown
    end
    return true
end
____exports["延迟尝试播放Boss拟声池"] = function(_____53C2_6570)
    addDelayedCallback(
        _____53C2_6570["延迟Ms"],
        function()
            ____exports["尝试播放Boss拟声池"](_____53C2_6570)
        end
    )
end
return ____exports
