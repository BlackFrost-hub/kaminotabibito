--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local _____9650_5236_6570_503C = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["限制数值"]
local _____8DDD_79BB_5E73_65B9XY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离平方XY"]
local _____8DDD_79BBXY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离XY"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____5355_4F4D_95F4_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位间角度"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["点到线段距离平方"]
---
-- @noSelfInFile
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getGameDifficulty = ____require_result_0.getGameDifficulty
____exports.stringToFourCC = stringToFourCC
____exports["单位有效"] = _____5355_4F4D_6709_6548
____exports["限制数值"] = _____9650_5236_6570_503C
____exports["距离平方XY"] = _____8DDD_79BB_5E73_65B9XY
____exports["距离XY"] = _____8DDD_79BBXY
____exports["极坐标X"] = _____6781_5750_6807X
____exports["极坐标Y"] = _____6781_5750_6807Y
____exports["点到线段距离平方"] = _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9
____exports["取单位间角度"] = _____5355_4F4D_95F4_89D2_5EA6
____exports["取坐标角度"] = _____4E24_70B9_89D2_5EA6
____exports["取难度"] = function()
    local n = getGameDifficulty()
    return n > 0 and n or 1
end
____exports["单位到线段距离平方"] = function(unit, ax, ay, bx, by)
    return _____70B9_5230_7EBF_6BB5_8DDD_79BB_5E73_65B9(
        GetUnitX(unit),
        GetUnitY(unit),
        ax,
        ay,
        bx,
        by
    )
end
return ____exports
