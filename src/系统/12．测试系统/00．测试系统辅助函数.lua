local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local jass = require("jass.common")
local _____83B7_53D6_73A9_5BB6ID = jass.GetPlayerId
local _____83B7_53D6_73A9_5BB6_540D_79F0 = jass.GetPlayerName
local _____6D4B_8BD5_73A9_5BB6ID = 0
local _____6D4B_8BD5_73A9_5BB6_540D_79F0 = "WorldEdit"
local _____6D4B_8BD5_5907_7528_73A9_5BB6_540D_79F0 = "九条艾莉莎"
local _____6D4B_8BD5_7A7AID_73A9_5BB6_540D_79F0 = ""
local _____6D4B_8BD5_7A7A_683CID_73A9_5BB6_540D_79F0 = " "
local _____5DF2_767B_8BB0_6D4B_8BD5_73A9_5BB6_540D_79F0_8868 = __TS__New(Set)
____exports["登记测试玩家"] = function(player)
    if player == nil or player == 0 then
        return
    end
    local playerName = _____83B7_53D6_73A9_5BB6_540D_79F0(player) or ""
    if playerName == "" then
        return
    end
    _____5DF2_767B_8BB0_6D4B_8BD5_73A9_5BB6_540D_79F0_8868:add(playerName)
end
____exports["是允许测试玩家"] = function(player)
    if player == nil or player == 0 then
        return false
    end
    local playerId = _____83B7_53D6_73A9_5BB6ID(player)
    local playerName = _____83B7_53D6_73A9_5BB6_540D_79F0(player) or ""
    if _____5DF2_767B_8BB0_6D4B_8BD5_73A9_5BB6_540D_79F0_8868:has(playerName) then
        return true
    end
    if playerId ~= _____6D4B_8BD5_73A9_5BB6ID then
        return false
    end
    return playerName == _____6D4B_8BD5_73A9_5BB6_540D_79F0 or playerName == _____6D4B_8BD5_73A9_5BB6_540D_79F0 .. ":" or playerName == _____6D4B_8BD5_5907_7528_73A9_5BB6_540D_79F0 or playerName == _____6D4B_8BD5_5907_7528_73A9_5BB6_540D_79F0 .. ":" or playerName == _____6D4B_8BD5_7A7AID_73A9_5BB6_540D_79F0 or playerName == _____6D4B_8BD5_7A7A_683CID_73A9_5BB6_540D_79F0
end
____exports["测试Boss跳过死亡结算字段"] = "测试Boss跳过死亡结算"
____exports["创建测试中心平移映射"] = function(_____6B63_5F0F_4E2D_5FC3X, _____6B63_5F0F_4E2D_5FC3Y, _____6D4B_8BD5_4E2D_5FC3X, _____6D4B_8BD5_4E2D_5FC3Y)
    return {["偏移X"] = _____6D4B_8BD5_4E2D_5FC3X - _____6B63_5F0F_4E2D_5FC3X, ["偏移Y"] = _____6D4B_8BD5_4E2D_5FC3Y - _____6B63_5F0F_4E2D_5FC3Y}
end
____exports["按测试映射平移坐标"] = function(_____70B9, _____6620_5C04)
    return {x = _____70B9.x + _____6620_5C04["偏移X"], y = _____70B9.y + _____6620_5C04["偏移Y"]}
end
____exports["按测试映射平移XY坐标"] = function(_____70B9, _____6620_5C04)
    return {X = _____70B9.X + _____6620_5C04["偏移X"], Y = _____70B9.Y + _____6620_5C04["偏移Y"]}
end
____exports["按测试映射平移矩形"] = function(_____77E9_5F62, _____6620_5C04)
    return {
        ID = _____77E9_5F62.ID,
        ["名称"] = _____77E9_5F62["名称"],
        ["左"] = _____77E9_5F62["左"] + _____6620_5C04["偏移X"],
        ["右"] = _____77E9_5F62["右"] + _____6620_5C04["偏移X"],
        ["下"] = _____77E9_5F62["下"] + _____6620_5C04["偏移Y"],
        ["上"] = _____77E9_5F62["上"] + _____6620_5C04["偏移Y"]
    }
end
____exports["根据测试中心平移坐标"] = function(_____70B9, _____6B63_5F0F_4E2D_5FC3, _____6D4B_8BD5_4E2D_5FC3)
    return ____exports["按测试映射平移坐标"](
        _____70B9,
        ____exports["创建测试中心平移映射"](_____6B63_5F0F_4E2D_5FC3.x, _____6B63_5F0F_4E2D_5FC3.y, _____6D4B_8BD5_4E2D_5FC3.x, _____6D4B_8BD5_4E2D_5FC3.y)
    )
end
____exports["根据测试中心平移XY坐标"] = function(_____70B9, _____6B63_5F0F_4E2D_5FC3, _____6D4B_8BD5_4E2D_5FC3)
    return ____exports["按测试映射平移XY坐标"](
        _____70B9,
        ____exports["创建测试中心平移映射"](_____6B63_5F0F_4E2D_5FC3.x, _____6B63_5F0F_4E2D_5FC3.y, _____6D4B_8BD5_4E2D_5FC3.x, _____6D4B_8BD5_4E2D_5FC3.y)
    )
end
____exports["根据测试中心平移矩形"] = function(_____77E9_5F62, _____6B63_5F0F_4E2D_5FC3, _____6D4B_8BD5_4E2D_5FC3)
    return ____exports["按测试映射平移矩形"](
        _____77E9_5F62,
        ____exports["创建测试中心平移映射"](_____6B63_5F0F_4E2D_5FC3.x, _____6B63_5F0F_4E2D_5FC3.y, _____6D4B_8BD5_4E2D_5FC3.x, _____6D4B_8BD5_4E2D_5FC3.y)
    )
end
____exports["复制平移测试坐标数组"] = function(_____70B9_4F4D, _____6620_5C04)
    local result = {}
    do
        local i = 0
        while i < #_____70B9_4F4D do
            result[#result + 1] = ____exports["按测试映射平移坐标"](_____70B9_4F4D[i + 1], _____6620_5C04)
            i = i + 1
        end
    end
    return result
end
____exports["复制平移测试矩形数组"] = function(_____77E9_5F62_5217_8868, _____6620_5C04)
    local result = {}
    do
        local i = 0
        while i < #_____77E9_5F62_5217_8868 do
            result[#result + 1] = ____exports["按测试映射平移矩形"](_____77E9_5F62_5217_8868[i + 1], _____6620_5C04)
            i = i + 1
        end
    end
    return result
end
____exports["标记测试Boss跳过死亡结算"] = function(boss)
    if boss == nil or boss == 0 then
        return
    end
    YDUserDataSetSafe(
        "unit",
        boss,
        ____exports["测试Boss跳过死亡结算字段"],
        "boolean",
        true
    )
end
return ____exports
