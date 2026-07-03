--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local Atan2, BJ_RADTODEG
____exports["取坐标角度"] = function(x1, y1, x2, y2)
    return Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG
end
---
-- @noSelfInFile
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getGameDifficulty = ____require_result_0.getGameDifficulty
BJ_RADTODEG = 57.29577951308232
function ____exports.stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
____exports["单位有效"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
____exports["取难度"] = function()
    local n = getGameDifficulty()
    return n > 0 and n or 1
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
____exports["距离平方XY"] = function(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end
____exports["距离XY"] = function(x1, y1, x2, y2)
    return SquareRoot(____exports["距离平方XY"](x1, y1, x2, y2))
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
    return x + math.cos(angle * math.pi / 180) * distance
end
____exports["极坐标Y"] = function(y, angle, distance)
    return y + math.sin(angle * math.pi / 180) * distance
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
____exports["单位到线段距离平方"] = function(unit, ax, ay, bx, by)
    return ____exports["点到线段距离平方"](
        GetUnitX(unit),
        GetUnitY(unit),
        ax,
        ay,
        bx,
        by
    )
end
return ____exports
