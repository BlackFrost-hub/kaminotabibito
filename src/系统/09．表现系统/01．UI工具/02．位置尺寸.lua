--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi = require("jass.japi")
function ____exports.setFramePosition(self, frame, position)
    if frame == 0 or frame == nil then
        return false
    end
    japi.DzFrameSetAbsolutePoint(frame, position.point, position.x, position.y)
    return true
end
function ____exports.setFramePointRelative(self, frame, point, relativeFrame, relativePoint, x, y)
    if frame == 0 or frame == nil or relativeFrame == 0 or relativeFrame == nil then
        return false
    end
    japi.DzFrameSetPoint(
        frame,
        point,
        relativeFrame,
        relativePoint,
        x,
        y
    )
    return true
end
function ____exports.setFrameSize(self, frame, size)
    if frame == 0 or frame == nil then
        return false
    end
    japi.DzFrameSetSize(frame, size.width, size.height)
    return true
end
return ____exports
