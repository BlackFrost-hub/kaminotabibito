--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____require_result_0["播放限时单位动画"]
local BJ_RADTODEG = 57.29577951308232
local BJ_DEGTORAD = 0.017453292519943295
function ____exports.stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
____exports["取单位ID"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["单位有效"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
____exports["播放莫尔特斯限时动作"] = function(unit, _____52A8_753B_7F16_53F7, _____52A8_753B_901F_5EA6, _____6301_7EED_79D2)
    return _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = unit,
        ["动画编号"] = _____52A8_753B_7F16_53F7,
        ["动画速度"] = _____52A8_753B_901F_5EA6,
        ["持续秒"] = _____6301_7EED_79D2,
        ["恢复动画编号"] = 0,
        ["恢复动画速度"] = 1
    })
end
____exports["距离平方XY"] = function(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end
____exports["距离XY"] = function(x1, y1, x2, y2)
    return SquareRoot(____exports["距离平方XY"](x1, y1, x2, y2))
end
____exports["取坐标角度"] = function(x1, y1, x2, y2)
    return Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG
end
____exports["取单位间角度"] = function(source, target)
    return ____exports["取坐标角度"](
        GetUnitX(source),
        GetUnitY(source),
        GetUnitX(target),
        GetUnitY(target)
    )
end
____exports["极坐标X"] = function(x, angle, distance)
    return x + Cos(angle * BJ_DEGTORAD) * distance
end
____exports["极坐标Y"] = function(y, angle, distance)
    return y + Sin(angle * BJ_DEGTORAD) * distance
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
return ____exports
