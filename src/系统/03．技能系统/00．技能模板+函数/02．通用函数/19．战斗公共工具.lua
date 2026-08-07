local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local GetUnitFacing = jass.GetUnitFacing
local ConvertUnitState = jass.ConvertUnitState
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local Cos = jass.Cos
local Sin = jass.Sin
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_ATTACK = ConvertUnitState(21)
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
____exports["单位句柄存在"] = function(unit)
    return unit ~= nil and unit ~= 0
end
____exports["单位未标记死亡"] = function(unit)
    return ____exports["单位句柄存在"](unit) and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
____exports["单位已标记死亡"] = function(unit)
    return ____exports["单位句柄存在"](unit) and IsUnitType(unit, UNIT_TYPE_DEAD) == true
end
____exports["单位存活"] = function(unit)
    return ____exports["单位未标记死亡"](unit) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
--- 兼容旧调用；需要区分句柄、死亡标记时请使用语义明确的函数。
____exports["单位有效"] = function(unit)
    return ____exports["单位存活"](unit)
end
____exports["读取单位攻击力"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return __TS__Number(GetUnitStateJapi(unit, UNIT_STATE_ATTACK)) or 0
end
____exports["读取单位最大生命"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return __TS__Number(GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)) or 0
end
____exports["距离平方XY"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end
____exports["单位间距离平方"] = function(a, b)
    return ____exports["距离平方XY"](
        GetUnitX(a),
        GetUnitY(a),
        GetUnitX(b),
        GetUnitY(b)
    )
end
____exports["单位到点距离平方"] = function(unit, x, y)
    return ____exports["距离平方XY"](
        GetUnitX(unit),
        GetUnitY(unit),
        x,
        y
    )
end
____exports["距离XY"] = function(x1, y1, x2, y2)
    return SquareRoot(____exports["距离平方XY"](x1, y1, x2, y2))
end
____exports["两点角度"] = function(x1, y1, x2, y2)
    local angle = Atan2(y2 - y1, x2 - x1) * _____5F27_5EA6_8F6C_89D2_5EA6
    if angle < 0 then
        angle = angle + 360
    end
    return angle
end
____exports["单位间角度"] = function(source, target)
    return ____exports["两点角度"](
        GetUnitX(source),
        GetUnitY(source),
        GetUnitX(target),
        GetUnitY(target)
    )
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
____exports["极坐标X"] = function(x, angleDeg, distance)
    return x + Cos(angleDeg * _____89D2_5EA6_8F6C_5F27_5EA6) * distance
end
____exports["极坐标Y"] = function(y, angleDeg, distance)
    return y + Sin(angleDeg * _____89D2_5EA6_8F6C_5F27_5EA6) * distance
end
____exports["限制数值"] = function(value, min, max)
    if value < min then
        return min
    end
    if value > max then
        return max
    end
    return value
end
____exports["点到线段距离平方"] = function(px, py, ax, ay, bx, by)
    local dx = bx - ax
    local dy = by - ay
    local len2 = dx * dx + dy * dy
    if len2 <= 0.001 then
        return ____exports["距离平方XY"](px, py, ax, ay)
    end
    local t = ((px - ax) * dx + (py - ay) * dy) / len2
    if t < 0 then
        t = 0
    end
    if t > 1 then
        t = 1
    end
    local cx = ax + dx * t
    local cy = ay + dy * t
    return ____exports["距离平方XY"](px, py, cx, cy)
end
--- 判断目标是否位于指定方向障碍物的下游遮挡带内。
____exports["点是否处于方向障碍物后方"] = function(_____5F39_5E55X, _____5F39_5E55Y, _____65B9_5411_89D2, _____969C_788D_7269X, _____969C_788D_7269Y, _____76EE_6807X, _____76EE_6807Y, _____969C_788D_7269_534A_5F84)
    if _____969C_788D_7269_534A_5F84 < 0 then
        return false
    end
    local directionX = Cos(_____65B9_5411_89D2 * _____89D2_5EA6_8F6C_5F27_5EA6)
    local directionY = Sin(_____65B9_5411_89D2 * _____89D2_5EA6_8F6C_5F27_5EA6)
    local obstacleDX = _____969C_788D_7269X - _____5F39_5E55X
    local obstacleDY = _____969C_788D_7269Y - _____5F39_5E55Y
    local targetDX = _____76EE_6807X - _____5F39_5E55X
    local targetDY = _____76EE_6807Y - _____5F39_5E55Y
    local obstacleProjection = obstacleDX * directionX + obstacleDY * directionY
    local targetProjection = targetDX * directionX + targetDY * directionY
    if obstacleProjection <= 0 or targetProjection <= obstacleProjection then
        return false
    end
    local targetRelativeX = _____76EE_6807X - _____969C_788D_7269X
    local targetRelativeY = _____76EE_6807Y - _____969C_788D_7269Y
    local lateralDistance = targetRelativeX * directionY - targetRelativeY * directionX
    local absoluteLateralDistance = lateralDistance < 0 and -lateralDistance or lateralDistance
    return absoluteLateralDistance <= _____969C_788D_7269_534A_5F84
end
____exports["播放点特效"] = function(model, x, y)
    if model == nil or model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
____exports["播放单位特效"] = function(model, unit, attachPointName)
    if attachPointName == nil then
        attachPointName = "origin"
    end
    if model == nil or model == "" or not ____exports["单位有效"](unit) then
        return
    end
    local effect = AddSpecialEffectTarget(model, unit, attachPointName)
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
return ____exports
