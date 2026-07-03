--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local Atan2 = jass.Atan2
local bj_RADTODEG = jass.bj_RADTODEG
____exports["标准化角度"] = function(_____89D2_5EA6)
    local result = _____89D2_5EA6 % 360
    if result < 0 then
        result = result + 360
    end
    return result
end
____exports["两点方向角"] = function(x1, y1, x2, y2)
    return ____exports["标准化角度"](Atan2(y2 - y1, x2 - x1) * bj_RADTODEG)
end
____exports["角度差绝对值"] = function(a, b)
    local diff = ____exports["标准化角度"](a) - ____exports["标准化角度"](b)
    if diff < -180 then
        diff = diff + 360
    end
    if diff > 180 then
        diff = diff - 360
    end
    return diff < 0 and -diff or diff
end
____exports["单位是否在来源正面扇区"] = function(_____6765_6E90, _____76EE_6807, _____6247_533A_89D2_5EA6)
    if _____6765_6E90 == nil or _____6765_6E90 == 0 or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    local toward = ____exports["两点方向角"](
        GetUnitX(_____6765_6E90),
        GetUnitY(_____6765_6E90),
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807)
    )
    return ____exports["角度差绝对值"](
        GetUnitFacing(_____6765_6E90),
        toward
    ) <= _____6247_533A_89D2_5EA6 / 2
end
____exports["单位是否在来源背后扇区"] = function(_____6765_6E90, _____76EE_6807, _____6247_533A_89D2_5EA6)
    if _____6765_6E90 == nil or _____6765_6E90 == 0 or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    local back = ____exports["标准化角度"](GetUnitFacing(_____6765_6E90) + 180)
    local toward = ____exports["两点方向角"](
        GetUnitX(_____6765_6E90),
        GetUnitY(_____6765_6E90),
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807)
    )
    return ____exports["角度差绝对值"](back, toward) <= _____6247_533A_89D2_5EA6 / 2
end
____exports["目标是否面向来源"] = function(_____6765_6E90, _____76EE_6807, _____6247_533A_89D2_5EA6)
    if _____6765_6E90 == nil or _____6765_6E90 == 0 or _____76EE_6807 == nil or _____76EE_6807 == 0 then
        return false
    end
    local towardSource = ____exports["两点方向角"](
        GetUnitX(_____76EE_6807),
        GetUnitY(_____76EE_6807),
        GetUnitX(_____6765_6E90),
        GetUnitY(_____6765_6E90)
    )
    return ____exports["角度差绝对值"](
        GetUnitFacing(_____76EE_6807),
        towardSource
    ) <= _____6247_533A_89D2_5EA6 / 2
end
return ____exports
