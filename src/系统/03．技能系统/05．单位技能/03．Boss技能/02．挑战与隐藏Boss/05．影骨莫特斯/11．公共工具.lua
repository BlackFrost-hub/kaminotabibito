--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local _____8DDD_79BBXY = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["距离XY"]
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____516C_5171_6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____516C_5171_6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____89D2_5EA6_5DEE_7EDD_5BF9_503C = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["角度差绝对值"]
local _____76EE_6807_6B63_9762_671D_5411_6765_6E90 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["目标正面朝向来源"]
____exports.stringToFourCC = stringToFourCC
____exports["取单位ID"] = _____53D6_5355_4F4DID
____exports["单位有效"] = _____5355_4F4D_6709_6548
____exports["两点角度"] = _____4E24_70B9_89D2_5EA6
____exports["角度差绝对值"] = _____89D2_5EA6_5DEE_7EDD_5BF9_503C
____exports["目标正面朝向来源"] = _____76EE_6807_6B63_9762_671D_5411_6765_6E90
____exports["两点距离"] = _____8DDD_79BBXY
____exports["极坐标X"] = function(x, distance, angleDeg)
    return _____516C_5171_6781_5750_6807X(x, angleDeg, distance)
end
____exports["极坐标Y"] = function(y, distance, angleDeg)
    return _____516C_5171_6781_5750_6807Y(y, angleDeg, distance)
end
return ____exports
