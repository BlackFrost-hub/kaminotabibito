--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- TS 原生弹幕 - 共享常量与 JASS/JAPI 别名
local jass = require("jass.common")
local japi = require("jass.japi")
local unitRelated = require("lib.扩展函数.自定义扩展函数.00．单位相关")
local unitCleanup = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local effectLibrary = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4 = unitRelated["创建单位并登记排泄"]
____exports.DestroyEffect = jass.DestroyEffect
____exports.EC_CreateEffect = effectLibrary.EC_CreateEffect
____exports.GetHandleId = jass.GetHandleId
____exports.GetOwningPlayer = jass.GetOwningPlayer
____exports.GetRandomReal = jass.GetRandomReal
____exports.GetUnitFacing = jass.GetUnitFacing
____exports.GetUnitFlyHeight = jass.GetUnitFlyHeight
____exports.GetUnitState = jass.GetUnitState
____exports.GetUnitX = jass.GetUnitX
____exports.GetUnitY = jass.GetUnitY
____exports.IsTerrainPathable = jass.IsTerrainPathable
____exports.IsUnitPaused = jass.IsUnitPaused
____exports.KillUnit = jass.KillUnit
____exports.Player = jass.Player
____exports.SetUnitFacing = jass.SetUnitFacing
____exports.SetUnitFlyHeight = jass.SetUnitFlyHeight
____exports.SetUnitPathing = jass.SetUnitPathing
____exports.SetUnitPosition = jass.SetUnitPosition
____exports.SetUnitScale = jass.SetUnitScale
____exports.SetUnitX = jass.SetUnitX
____exports.SetUnitY = jass.SetUnitY
____exports.SquareRoot = jass.SquareRoot
____exports.UnitAddAbility = jass.UnitAddAbility
____exports.UnitRemoveAbility = jass.UnitRemoveAbility
____exports.UnitAddType = jass.UnitAddType
____exports.UnitRemoveType = jass.UnitRemoveType
____exports.Atan2 = jass.Atan2
____exports.CosBJ = require("lib.扩展函数.BJ函数.12．数学函数").CosBJ
____exports.SinBJ = require("lib.扩展函数.BJ函数.12．数学函数").SinBJ
____exports.EXSetUnitFacing = japi.EXSetUnitFacing
____exports.DzSetUnitModel = japi.DzSetUnitModel
____exports.DzSetEffectPos = japi.DzSetEffectPos
____exports.DzGetColor = japi.DzGetColor
____exports.DzSetEffectVertexColor = japi.DzSetEffectVertexColor
____exports.EXEffectMatReset = japi.EXEffectMatReset
____exports.EXEffectMatRotateY = japi.EXEffectMatRotateY
____exports.EXEffectMatRotateZ = japi.EXEffectMatRotateZ
____exports.EXSetEffectSize = japi.EXSetEffectSize
____exports.ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
____exports.DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
____exports.WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
____exports.UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
____exports.UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
____exports.UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
____exports.UNIT_TYPE_TAUREN = jass.UNIT_TYPE_TAUREN
____exports.PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY
local ____jass_bj_RADTODEG_0 = jass.bj_RADTODEG
if ____jass_bj_RADTODEG_0 == nil then
    ____jass_bj_RADTODEG_0 = 57.29577951308232
end
____exports.bj_RADTODEG = ____jass_bj_RADTODEG_0
____exports["蝗虫技能ID"] = 1097625443
____exports["默认弹幕单位类型"] = 1700880737
____exports["弹幕Tick间隔"] = 0.01
local _____7A7ASelf = nil
function ____exports.CreateUnit(owner, unitTypeId, x, y, facing)
    return _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4(
        _____7A7ASelf,
        owner,
        unitTypeId,
        x,
        y,
        facing
    )
end
function ____exports.RemoveUnit(unit)
    unitCleanup["立即移除单位并取消排泄登记"](unit)
end
____exports["取句柄ID"] = function(handle)
    return handle ~= nil and handle ~= 0 and (____exports.GetHandleId(handle) or 0) or 0
end
____exports["标准化角度"] = function(_____89D2_5EA6)
    local _____7ED3_679C = _____89D2_5EA6
    while _____7ED3_679C < 0 do
        _____7ED3_679C = _____7ED3_679C + 360
    end
    while _____7ED3_679C >= 360 do
        _____7ED3_679C = _____7ED3_679C - 360
    end
    return _____7ED3_679C
end
____exports["取坐标朝向角"] = function(fromX, fromY, toX, toY)
    return ____exports.Atan2(toY - fromY, toX - fromX) * ____exports.bj_RADTODEG
end
____exports["角度差"] = function(from, to)
    local diff = ____exports["标准化角度"](to - from)
    if diff > 180 then
        diff = diff - 360
    end
    return diff
end
____exports["限制范围"] = function(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end
____exports["计算距离"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return ____exports.SquareRoot(dx * dx + dy * dy)
end
return ____exports
