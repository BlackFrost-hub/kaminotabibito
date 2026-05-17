--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local EXSetUnitFacing = ____01_FF0E_5171_4EAB.EXSetUnitFacing
local GetUnitFacing = ____01_FF0E_5171_4EAB.GetUnitFacing
local GetUnitX = ____01_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____01_FF0E_5171_4EAB.GetUnitY
local SetUnitFacing = ____01_FF0E_5171_4EAB.SetUnitFacing
local _____6807_51C6_5316_89D2_5EA6 = ____01_FF0E_5171_4EAB["标准化角度"]
local ____02_FF0E_6CE8_518C_8868 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.02．注册表")
local _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B = ____02_FF0E_6CE8_518C_8868["获取原生弹幕实例"]
local _____5355_4F4D_5230_539F_751F_5F39_5E55ID = ____02_FF0E_6CE8_518C_8868["单位到原生弹幕ID"]
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local _____53D6_53E5_67C4ID = ____01_FF0E_5171_4EAB["取句柄ID"]
local function _____89E3_6790_6539_5411_901F_5EA6(_____5B9E_4F8B, _____65B0_901F_5EA6)
    if _____65B0_901F_5EA6 ~= nil and _____65B0_901F_5EA6 > 0 then
        return _____65B0_901F_5EA6
    end
    if _____5B9E_4F8B["当前速度"] > 0 then
        return _____5B9E_4F8B["当前速度"]
    end
    if _____5B9E_4F8B["参数"]["速度"] > 0 then
        return _____5B9E_4F8B["参数"]["速度"]
    end
    return 400
end
local function _____5E94_7528_539F_751F_5F39_5E55_6539_5411(_____5B9E_4F8B, _____53C2_6570)
    if _____5B9E_4F8B["已结束"] then
        return false
    end
    local _____671D_5411_89D2_5EA6 = _____6807_51C6_5316_89D2_5EA6(_____53C2_6570["朝向角度"])
    _____5B9E_4F8B["参数"]["轨迹采样器"] = nil
    _____5B9E_4F8B["参数"]["轨迹类型"] = "直线"
    _____5B9E_4F8B["参数"]["指定目标"] = nil
    _____5B9E_4F8B["参数"]["显式改向后锁定方向"] = true
    _____5B9E_4F8B["当前X"] = GetUnitX(_____5B9E_4F8B["弹幕单位"])
    _____5B9E_4F8B["当前Y"] = GetUnitY(_____5B9E_4F8B["弹幕单位"])
    _____5B9E_4F8B["当前方向角"] = _____671D_5411_89D2_5EA6
    _____5B9E_4F8B["当前速度"] = _____89E3_6790_6539_5411_901F_5EA6(_____5B9E_4F8B, _____53C2_6570["新速度"])
    SetUnitFacing(_____5B9E_4F8B["弹幕单位"], _____671D_5411_89D2_5EA6)
    if EXSetUnitFacing ~= nil then
        EXSetUnitFacing(_____5B9E_4F8B["弹幕单位"], _____671D_5411_89D2_5EA6 * 0.017453292519943295)
    end
    return true
end
____exports["设置原生弹幕指定角度飞行"] = function(_____5F39_5E55ID, _____671D_5411_89D2_5EA6, _____65B0_901F_5EA6)
    local _____5B9E_4F8B = _____83B7_53D6_539F_751F_5F39_5E55_5B9E_4F8B(_____5F39_5E55ID)
    if _____5B9E_4F8B == nil then
        return false
    end
    return _____5E94_7528_539F_751F_5F39_5E55_6539_5411(_____5B9E_4F8B, {["朝向角度"] = _____671D_5411_89D2_5EA6, ["新速度"] = _____65B0_901F_5EA6})
end
____exports["按单位设置原生弹幕指定角度飞行"] = function(_____5F39_5E55_5355_4F4D, _____671D_5411_89D2_5EA6, _____65B0_901F_5EA6)
    local _____5F39_5E55ID = _____5355_4F4D_5230_539F_751F_5F39_5E55ID[_____53D6_53E5_67C4ID(_____5F39_5E55_5355_4F4D)] or 0
    if _____5F39_5E55ID <= 0 then
        return false
    end
    return ____exports["设置原生弹幕指定角度飞行"](_____5F39_5E55ID, _____671D_5411_89D2_5EA6, _____65B0_901F_5EA6)
end
____exports["按反弹单位面向反弹原生弹幕"] = function(_____5F39_5E55ID, _____53CD_5F39_5355_4F4D, _____65B0_901F_5EA6, _____9644_52A0_89D2_5EA6)
    if _____9644_52A0_89D2_5EA6 == nil then
        _____9644_52A0_89D2_5EA6 = 0
    end
    if _____53CD_5F39_5355_4F4D == nil or _____53CD_5F39_5355_4F4D == 0 then
        return false
    end
    return ____exports["设置原生弹幕指定角度飞行"](
        _____5F39_5E55ID,
        GetUnitFacing(_____53CD_5F39_5355_4F4D) + _____9644_52A0_89D2_5EA6,
        _____65B0_901F_5EA6
    )
end
____exports["按单位反弹原生弹幕"] = function(_____5F39_5E55_5355_4F4D, _____53CD_5F39_5355_4F4D, _____65B0_901F_5EA6, _____9644_52A0_89D2_5EA6)
    if _____9644_52A0_89D2_5EA6 == nil then
        _____9644_52A0_89D2_5EA6 = 0
    end
    if _____53CD_5F39_5355_4F4D == nil or _____53CD_5F39_5355_4F4D == 0 then
        return false
    end
    return ____exports["按单位设置原生弹幕指定角度飞行"](
        _____5F39_5E55_5355_4F4D,
        GetUnitFacing(_____53CD_5F39_5355_4F4D) + _____9644_52A0_89D2_5EA6,
        _____65B0_901F_5EA6
    )
end
return ____exports
