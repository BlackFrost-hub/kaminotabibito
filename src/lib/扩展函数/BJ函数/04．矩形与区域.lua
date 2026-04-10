--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
function ____exports.RectContainsCoords(self, r, x, y)
    if not r then
        return false
    end
    if type(jass.GetRectMinX) ~= "function" or type(jass.GetRectMaxX) ~= "function" or type(jass.GetRectMinY) ~= "function" or type(jass.GetRectMaxY) ~= "function" then
        return false
    end
    return jass.GetRectMinX(r) <= x and x <= jass.GetRectMaxX(r) and jass.GetRectMinY(r) <= y and y <= jass.GetRectMaxY(r)
end
function ____exports.RectContainsLoc(self, r, loc)
    if not r or not loc then
        return false
    end
    if type(jass.GetLocationX) ~= "function" or type(jass.GetLocationY) ~= "function" then
        return false
    end
    return ____exports.RectContainsCoords(
        nil,
        r,
        jass.GetLocationX(loc),
        jass.GetLocationY(loc)
    )
end
function ____exports.RectContainsUnit(self, r, whichUnit)
    if not r or not whichUnit then
        return false
    end
    if type(jass.GetUnitX) ~= "function" or type(jass.GetUnitY) ~= "function" then
        return false
    end
    return ____exports.RectContainsCoords(
        nil,
        r,
        jass.GetUnitX(whichUnit),
        jass.GetUnitY(whichUnit)
    )
end
function ____exports.SetStackedSoundBJ(self, add, soundHandle, r)
    if not soundHandle or not r then
        return
    end
    if type(jass.GetRectMaxX) ~= "function" or type(jass.GetRectMinX) ~= "function" or type(jass.GetRectMaxY) ~= "function" or type(jass.GetRectMinY) ~= "function" or type(jass.GetRectCenterX) ~= "function" or type(jass.GetRectCenterY) ~= "function" or type(jass.SetSoundPosition) ~= "function" then
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
        if type(jass.RegisterStackedSound) == "function" then
            jass.RegisterStackedSound(soundHandle, true, width, height)
        end
    elseif type(jass.UnregisterStackedSound) == "function" then
        jass.UnregisterStackedSound(soundHandle, true, width, height)
    end
end
return ____exports
