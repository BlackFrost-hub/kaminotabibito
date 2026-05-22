--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
--- 获取整个地图区域
-- 对应JASS: GetEntireMapRect
-- 实现: return GetWorldBounds()
function ____exports.GetEntireMapRect()
    return jass.GetWorldBounds()
end
function ____exports.RectContainsCoords(r, x, y)
    if not r then
        return false
    end
    return jass.GetRectMinX(r) <= x and x <= jass.GetRectMaxX(r) and jass.GetRectMinY(r) <= y and y <= jass.GetRectMaxY(r)
end
function ____exports.RectContainsLoc(r, loc)
    if not r or not loc then
        return false
    end
    return ____exports.RectContainsCoords(
        r,
        jass.GetLocationX(loc),
        jass.GetLocationY(loc)
    )
end
function ____exports.RectContainsUnit(r, whichUnit)
    if not r or not whichUnit then
        return false
    end
    return ____exports.RectContainsCoords(
        r,
        jass.GetUnitX(whichUnit),
        jass.GetUnitY(whichUnit)
    )
end
function ____exports.SetStackedSoundBJ(add, soundHandle, r)
    if not soundHandle or not r then
        return
    end
    local width = jass.GetRectMaxX(r) - jass.GetRectMinX(r)
    local height = jass.GetRectMaxY(r) - jass.GetRectMinY(r)
    jass.SetSoundPosition(
        soundHandle,
        jass.GetRectCenterX(r),
        jass.GetRectCenterY(r),
        0
    )
    if add then
        jass.RegisterStackedSound(soundHandle, true, width, height)
    else
        jass.UnregisterStackedSound(soundHandle, true, width, height)
    end
end
return ____exports
