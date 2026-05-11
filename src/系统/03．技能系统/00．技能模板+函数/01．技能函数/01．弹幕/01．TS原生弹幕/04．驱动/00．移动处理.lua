--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local CosBJ = ____01_FF0E_5171_4EAB.CosBJ
local GetUnitFacing = ____01_FF0E_5171_4EAB.GetUnitFacing
local GetUnitState = ____01_FF0E_5171_4EAB.GetUnitState
local GetUnitX = ____01_FF0E_5171_4EAB.GetUnitX
local GetUnitY = ____01_FF0E_5171_4EAB.GetUnitY
local IsTerrainPathable = ____01_FF0E_5171_4EAB.IsTerrainPathable
local IsUnitPaused = ____01_FF0E_5171_4EAB.IsUnitPaused
local PATHING_TYPE_WALKABILITY = ____01_FF0E_5171_4EAB.PATHING_TYPE_WALKABILITY
local SetUnitFlyHeight = ____01_FF0E_5171_4EAB.SetUnitFlyHeight
local SetUnitX = ____01_FF0E_5171_4EAB.SetUnitX
local SetUnitY = ____01_FF0E_5171_4EAB.SetUnitY
local SinBJ = ____01_FF0E_5171_4EAB.SinBJ
local UNIT_STATE_LIFE = ____01_FF0E_5171_4EAB.UNIT_STATE_LIFE
local _____6807_51C6_5316_89D2_5EA6 = ____01_FF0E_5171_4EAB["标准化角度"]
local _____89D2_5EA6_5DEE = ____01_FF0E_5171_4EAB["角度差"]
local _____8BA1_7B97_8DDD_79BB = ____01_FF0E_5171_4EAB["计算距离"]
local _____53D6_5750_6807_671D_5411_89D2 = ____01_FF0E_5171_4EAB["取坐标朝向角"]
local _____9650_5236_8303_56F4 = ____01_FF0E_5171_4EAB["限制范围"]
local GetRandomReal = ____01_FF0E_5171_4EAB.GetRandomReal
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____require_result_0["立即设置单位朝向"]
local UNIT_ALIVE_LIFE = 0.405
____exports["弹幕单位存活"] = function(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and GetUnitState(_____5355_4F4D, UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE
end
local function _____66F4_65B0_5F39_5E55_5355_4F4D_5750_6807(_____5B9E_4F8B, x, y, face)
    SetUnitX(_____5B9E_4F8B["弹幕单位"], x)
    SetUnitY(_____5B9E_4F8B["弹幕单位"], y)
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(
        _____5B9E_4F8B["弹幕单位"],
        _____6807_51C6_5316_89D2_5EA6(face)
    )
    _____5B9E_4F8B["当前X"] = x
    _____5B9E_4F8B["当前Y"] = y
    _____5B9E_4F8B["当前方向角"] = _____6807_51C6_5316_89D2_5EA6(face)
end
local function _____66F4_65B0_8FFD_8E2A_65B9_5411(_____5B9E_4F8B, delta)
    local _____76EE_6807 = _____5B9E_4F8B["参数"]["指定目标"]
    if _____76EE_6807 == nil or _____76EE_6807 == 0 or not ____exports["弹幕单位存活"](_____76EE_6807) then
        return
    end
    local _____76EE_6807_89D2 = _____53D6_5750_6807_671D_5411_89D2(
        _____5B9E_4F8B["当前X"],
        _____5B9E_4F8B["当前Y"],
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807)
    )
    local _____8F6C_5411_901F_5EA6 = _____5B9E_4F8B["参数"]["追踪转向速度"] or 0
    if _____8F6C_5411_901F_5EA6 <= 0 then
        _____5B9E_4F8B["当前方向角"] = _____6807_51C6_5316_89D2_5EA6(_____76EE_6807_89D2)
        return
    end
    local _____6700_5927_8F6C_5411 = _____8F6C_5411_901F_5EA6 * delta
    local diff = _____89D2_5EA6_5DEE(_____5B9E_4F8B["当前方向角"], _____76EE_6807_89D2)
    _____5B9E_4F8B["当前方向角"] = _____6807_51C6_5316_89D2_5EA6(_____5B9E_4F8B["当前方向角"] + _____9650_5236_8303_56F4(diff, -_____6700_5927_8F6C_5411, _____6700_5927_8F6C_5411))
end
local function _____5C1D_8BD5_5F39_5C04(_____5B9E_4F8B)
    if _____5B9E_4F8B["参数"]["弹射"] ~= true then
        return false
    end
    local _____4E0A_9650 = _____5B9E_4F8B["参数"]["弹射次数上限"] or 0
    if _____4E0A_9650 > 0 and _____5B9E_4F8B["弹射次数"] >= _____4E0A_9650 then
        return false
    end
    _____5B9E_4F8B["弹射次数"] = _____5B9E_4F8B["弹射次数"] + 1
    if _____5B9E_4F8B["参数"]["随机弹射"] == true then
        _____5B9E_4F8B["当前方向角"] = _____6807_51C6_5316_89D2_5EA6(_____5B9E_4F8B["当前方向角"] + GetRandomReal(120, 240))
    else
        _____5B9E_4F8B["当前方向角"] = _____6807_51C6_5316_89D2_5EA6(_____5B9E_4F8B["当前方向角"] + (_____5B9E_4F8B["参数"]["弹射角度"] or 180))
    end
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(_____5B9E_4F8B["弹幕单位"], _____5B9E_4F8B["当前方向角"])
    local _____8870_51CF = _____5B9E_4F8B["参数"]["弹射衰减"] or 0
    if _____8870_51CF > 0 then
        local _____7CFB_6570 = _____9650_5236_8303_56F4(1 - _____8870_51CF, 0, 1)
        _____5B9E_4F8B["当前速度"] = _____5B9E_4F8B["当前速度"] * _____7CFB_6570
        _____5B9E_4F8B["当前伤害值"] = _____5B9E_4F8B["当前伤害值"] * _____7CFB_6570
    end
    return true
end
____exports["推进弹幕移动"] = function(_____5B9E_4F8B, delta)
    if IsUnitPaused(_____5B9E_4F8B["弹幕单位"]) then
        return false
    end
    local _____5EF6_8FDF = _____5B9E_4F8B["参数"]["延迟发射"] or 0
    if _____5EF6_8FDF > 0 and _____5B9E_4F8B["已运行时间"] < _____5EF6_8FDF then
        return false
    end
    local _____91C7_6837_5668 = _____5B9E_4F8B["参数"]["轨迹采样器"]
    if _____91C7_6837_5668 ~= nil then
        local oldX = _____5B9E_4F8B["当前X"]
        local oldY = _____5B9E_4F8B["当前Y"]
        local _____7ED3_679C = _____91C7_6837_5668(_____5B9E_4F8B, delta)
        _____5B9E_4F8B["已飞行距离"] = _____5B9E_4F8B["已飞行距离"] + _____8BA1_7B97_8DDD_79BB(oldX, oldY, _____7ED3_679C.X, _____7ED3_679C.Y)
        _____66F4_65B0_5F39_5E55_5355_4F4D_5750_6807(_____5B9E_4F8B, _____7ED3_679C.X, _____7ED3_679C.Y, _____7ED3_679C["方向角"] or _____5B9E_4F8B["当前方向角"])
        if _____7ED3_679C.Z ~= nil then
            SetUnitFlyHeight(_____5B9E_4F8B["弹幕单位"], _____7ED3_679C.Z, 0)
        end
        return _____7ED3_679C["完成"] == true
    end
    if _____5B9E_4F8B["参数"]["轨迹类型"] == "追踪" then
        _____66F4_65B0_8FFD_8E2A_65B9_5411(_____5B9E_4F8B, delta)
    else
        _____5B9E_4F8B["当前方向角"] = _____6807_51C6_5316_89D2_5EA6(GetUnitFacing(_____5B9E_4F8B["弹幕单位"]))
    end
    local _____8DDD_79BB = _____5B9E_4F8B["当前速度"] * delta
    local nextX = _____5B9E_4F8B["当前X"] + CosBJ(_____5B9E_4F8B["当前方向角"]) * _____8DDD_79BB
    local nextY = _____5B9E_4F8B["当前Y"] + SinBJ(_____5B9E_4F8B["当前方向角"]) * _____8DDD_79BB
    if IsTerrainPathable(nextX, nextY, PATHING_TYPE_WALKABILITY) then
        return not _____5C1D_8BD5_5F39_5C04(_____5B9E_4F8B)
    end
    _____5B9E_4F8B["已飞行距离"] = _____5B9E_4F8B["已飞行距离"] + _____8DDD_79BB
    _____66F4_65B0_5F39_5E55_5355_4F4D_5750_6807(_____5B9E_4F8B, nextX, nextY, _____5B9E_4F8B["当前方向角"])
    return false
end
return ____exports
