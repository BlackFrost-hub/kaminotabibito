--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local Atan2 = ____01_FF0E_5171_4EAB.Atan2
local CosBJ = ____01_FF0E_5171_4EAB.CosBJ
local DzSetEffectPos = ____01_FF0E_5171_4EAB.DzSetEffectPos
local EXEffectMatReset = ____01_FF0E_5171_4EAB.EXEffectMatReset
local EXEffectMatRotateY = ____01_FF0E_5171_4EAB.EXEffectMatRotateY
local EXEffectMatRotateZ = ____01_FF0E_5171_4EAB.EXEffectMatRotateZ
local EXSetEffectSize = ____01_FF0E_5171_4EAB.EXSetEffectSize
local GetUnitFlyHeight = ____01_FF0E_5171_4EAB.GetUnitFlyHeight
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
local bj_RADTODEG = ____01_FF0E_5171_4EAB.bj_RADTODEG
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
local function _____8BA1_7B97_8F68_8FF9_4FEF_4EF0_89D2(oldX, oldY, oldZ, x, y, z)
    local dz = z - oldZ
    local horizontalDistance = _____8BA1_7B97_8DDD_79BB(oldX, oldY, x, y)
    if horizontalDistance <= 0.001 and dz == 0 then
        return 0
    end
    return Atan2(dz, horizontalDistance) * bj_RADTODEG
end
local function _____89E3_6790_9644_52A0_7279_6548_7F29_653E(_____5B9E_4F8B, _____7279_6548_53C2_6570)
    return _____7279_6548_53C2_6570["缩放"] or (_____7279_6548_53C2_6570["跟随主弹幕参数"] == true and (_____5B9E_4F8B["参数"]["缩放"] or 1) or 1)
end
local function _____540C_6B65_5355_4E2A_5F39_5E55_9644_52A0_7279_6548(_____5B9E_4F8B, effect, _____7279_6548_53C2_6570, x, y, z, _____65B0_65B9_5411_89D2, _____65CB_8F6C_89D2_5EA6_5DEE, _____8F68_8FF9_4FEF_4EF0_89D2)
    if effect == nil or effect == 0 then
        return
    end
    if (_____7279_6548_53C2_6570 and _____7279_6548_53C2_6570["跟随轨迹俯仰"]) == true then
        EXEffectMatReset(effect)
        EXSetEffectSize(
            effect,
            _____89E3_6790_9644_52A0_7279_6548_7F29_653E(_____5B9E_4F8B, _____7279_6548_53C2_6570)
        )
        if _____8F68_8FF9_4FEF_4EF0_89D2 ~= 0 then
            EXEffectMatRotateY(effect, -_____8F68_8FF9_4FEF_4EF0_89D2)
        end
        if _____65B0_65B9_5411_89D2 ~= 0 then
            EXEffectMatRotateZ(effect, _____65B0_65B9_5411_89D2)
        end
        DzSetEffectPos(effect, x, y, z)
        return
    end
    DzSetEffectPos(effect, x, y, z)
    if _____65CB_8F6C_89D2_5EA6_5DEE ~= 0 then
        EXEffectMatRotateZ(effect, _____65CB_8F6C_89D2_5EA6_5DEE)
    end
end
local function _____540C_6B65_5F39_5E55_9644_52A0_7279_6548(_____5B9E_4F8B, oldX, oldY, oldZ, x, y, z, _____65E7_65B9_5411_89D2, _____65B0_65B9_5411_89D2)
    local _____65CB_8F6C_89D2_5EA6_5DEE = _____89D2_5EA6_5DEE(_____65E7_65B9_5411_89D2, _____65B0_65B9_5411_89D2)
    local _____8F68_8FF9_4FEF_4EF0_89D2 = _____8BA1_7B97_8F68_8FF9_4FEF_4EF0_89D2(
        oldX,
        oldY,
        oldZ,
        x,
        y,
        z
    )
    _____540C_6B65_5355_4E2A_5F39_5E55_9644_52A0_7279_6548(
        _____5B9E_4F8B,
        _____5B9E_4F8B["附加特效1"],
        _____5B9E_4F8B["参数"]["附加特效1"],
        x,
        y,
        z,
        _____65B0_65B9_5411_89D2,
        _____65CB_8F6C_89D2_5EA6_5DEE,
        _____8F68_8FF9_4FEF_4EF0_89D2
    )
    _____540C_6B65_5355_4E2A_5F39_5E55_9644_52A0_7279_6548(
        _____5B9E_4F8B,
        _____5B9E_4F8B["附加特效2"],
        _____5B9E_4F8B["参数"]["附加特效2"],
        x,
        y,
        z,
        _____65B0_65B9_5411_89D2,
        _____65CB_8F6C_89D2_5EA6_5DEE,
        _____8F68_8FF9_4FEF_4EF0_89D2
    )
end
local function _____66F4_65B0_5F39_5E55_5355_4F4D_5750_6807(_____5B9E_4F8B, x, y, face, _____65E7_65B9_5411_89D2, z)
    local _____65B0_65B9_5411_89D2 = _____6807_51C6_5316_89D2_5EA6(face)
    local oldX = _____5B9E_4F8B["当前X"]
    local oldY = _____5B9E_4F8B["当前Y"]
    local oldZ = GetUnitFlyHeight(_____5B9E_4F8B["弹幕单位"])
    local newZ = z or oldZ
    SetUnitX(_____5B9E_4F8B["弹幕单位"], x)
    SetUnitY(_____5B9E_4F8B["弹幕单位"], y)
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(_____5B9E_4F8B["弹幕单位"], _____65B0_65B9_5411_89D2)
    if z ~= nil then
        SetUnitFlyHeight(_____5B9E_4F8B["弹幕单位"], z, 0)
    end
    _____5B9E_4F8B["当前X"] = x
    _____5B9E_4F8B["当前Y"] = y
    _____5B9E_4F8B["当前方向角"] = _____65B0_65B9_5411_89D2
    _____540C_6B65_5F39_5E55_9644_52A0_7279_6548(
        _____5B9E_4F8B,
        oldX,
        oldY,
        oldZ,
        x,
        y,
        newZ,
        _____65E7_65B9_5411_89D2,
        _____65B0_65B9_5411_89D2
    )
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
local function _____5C1D_8BD5_5F39_5C04(_____5B9E_4F8B, _____540C_6B65_524D_65B9_5411_89D2)
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
    local z = GetUnitFlyHeight(_____5B9E_4F8B["弹幕单位"])
    _____540C_6B65_5F39_5E55_9644_52A0_7279_6548(
        _____5B9E_4F8B,
        _____5B9E_4F8B["当前X"],
        _____5B9E_4F8B["当前Y"],
        z,
        _____5B9E_4F8B["当前X"],
        _____5B9E_4F8B["当前Y"],
        z,
        _____540C_6B65_524D_65B9_5411_89D2,
        _____5B9E_4F8B["当前方向角"]
    )
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
    local _____79FB_52A8_524D_65B9_5411_89D2 = _____5B9E_4F8B["当前方向角"]
    local _____91C7_6837_5668 = _____5B9E_4F8B["参数"]["轨迹采样器"]
    if _____91C7_6837_5668 ~= nil then
        local oldX = _____5B9E_4F8B["当前X"]
        local oldY = _____5B9E_4F8B["当前Y"]
        local _____7ED3_679C = _____91C7_6837_5668(_____5B9E_4F8B, delta)
        _____5B9E_4F8B["已飞行距离"] = _____5B9E_4F8B["已飞行距离"] + _____8BA1_7B97_8DDD_79BB(oldX, oldY, _____7ED3_679C.X, _____7ED3_679C.Y)
        _____66F4_65B0_5F39_5E55_5355_4F4D_5750_6807(
            _____5B9E_4F8B,
            _____7ED3_679C.X,
            _____7ED3_679C.Y,
            _____7ED3_679C["方向角"] or _____5B9E_4F8B["当前方向角"],
            _____79FB_52A8_524D_65B9_5411_89D2,
            _____7ED3_679C.Z
        )
        return _____7ED3_679C["完成"] == true
    end
    if _____5B9E_4F8B["参数"]["轨迹类型"] == "追踪" then
        _____66F4_65B0_8FFD_8E2A_65B9_5411(_____5B9E_4F8B, delta)
    else
        if _____5B9E_4F8B["参数"]["显式改向后锁定方向"] ~= true then
            _____5B9E_4F8B["当前方向角"] = _____6807_51C6_5316_89D2_5EA6(GetUnitFacing(_____5B9E_4F8B["弹幕单位"]))
        end
    end
    local _____8DDD_79BB = _____5B9E_4F8B["当前速度"] * delta
    local nextX = _____5B9E_4F8B["当前X"] + CosBJ(_____5B9E_4F8B["当前方向角"]) * _____8DDD_79BB
    local nextY = _____5B9E_4F8B["当前Y"] + SinBJ(_____5B9E_4F8B["当前方向角"]) * _____8DDD_79BB
    if IsTerrainPathable(nextX, nextY, PATHING_TYPE_WALKABILITY) then
        return not _____5C1D_8BD5_5F39_5C04(_____5B9E_4F8B, _____79FB_52A8_524D_65B9_5411_89D2)
    end
    _____5B9E_4F8B["已飞行距离"] = _____5B9E_4F8B["已飞行距离"] + _____8DDD_79BB
    _____66F4_65B0_5F39_5E55_5355_4F4D_5750_6807(
        _____5B9E_4F8B,
        nextX,
        nextY,
        _____5B9E_4F8B["当前方向角"],
        _____79FB_52A8_524D_65B9_5411_89D2
    )
    return false
end
return ____exports
