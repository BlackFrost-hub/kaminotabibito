--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local _____8F6C_56DB_5B57_7801 = ____require_result_0.stringToFourCC
local _____5F27_5EA6_8F6C_89D2_5EA6 = 57.29577951308232
local _____89D2_5EA6_8F6C_5F27_5EA6 = 0.017453292519943295
function ____exports.stringToFourCC(id)
    return _____8F6C_56DB_5B57_7801(id)
end
____exports["取单位ID"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["单位有效"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if IsUnitType(unit, UNIT_TYPE_DEAD) == true then
        return false
    end
    return GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
____exports["两点距离"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
____exports["两点角度"] = function(x1, y1, x2, y2)
    local angle = Atan2(y2 - y1, x2 - x1) * _____5F27_5EA6_8F6C_89D2_5EA6
    if angle < 0 then
        angle = angle + 360
    end
    return angle
end
____exports["极坐标X"] = function(x, distance, angleDeg)
    return x + distance * Cos(angleDeg * _____89D2_5EA6_8F6C_5F27_5EA6)
end
____exports["极坐标Y"] = function(y, distance, angleDeg)
    return y + distance * Sin(angleDeg * _____89D2_5EA6_8F6C_5F27_5EA6)
end
____exports["角度差绝对值"] = function(a, b)
    local diff = a - b
    while diff > 180 do
        diff = diff - 360
    end
    while diff < -180 do
        diff = diff + 360
    end
    return diff >= 0 and diff or -diff
end
____exports["目标正面朝向来源"] = function(source, target, frontAngle)
    if not ____exports["单位有效"](source) or not ____exports["单位有效"](target) then
        return false
    end
    local targetFacing = GetUnitFacing(target)
    local targetToSource = ____exports["两点角度"](
        GetUnitX(target),
        GetUnitY(target),
        GetUnitX(source),
        GetUnitY(source)
    )
    return ____exports["角度差绝对值"](targetFacing, targetToSource) <= frontAngle * 0.5
end
return ____exports
