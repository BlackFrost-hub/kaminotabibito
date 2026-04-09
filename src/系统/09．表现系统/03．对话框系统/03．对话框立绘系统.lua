--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.LEFT_PORTRAIT_INDEX = 101
____exports.MID_PORTRAIT_INDEX = 102
____exports.RIGHT_PORTRAIT_INDEX = 103
function ____exports.applyPortraitFrames(self, entry, frames, dzSetTexture, dzShow)
    if entry.leftTex ~= "" then
        dzSetTexture(nil, frames[____exports.LEFT_PORTRAIT_INDEX + 1], entry.leftTex)
        dzShow(nil, frames[____exports.LEFT_PORTRAIT_INDEX + 1], true)
    else
        dzShow(nil, frames[____exports.LEFT_PORTRAIT_INDEX + 1], false)
    end
    if entry.midTex ~= "" then
        dzSetTexture(nil, frames[____exports.MID_PORTRAIT_INDEX + 1], entry.midTex)
        dzShow(nil, frames[____exports.MID_PORTRAIT_INDEX + 1], true)
    else
        dzShow(nil, frames[____exports.MID_PORTRAIT_INDEX + 1], false)
    end
    if entry.rightTex ~= "" then
        dzSetTexture(nil, frames[____exports.RIGHT_PORTRAIT_INDEX + 1], entry.rightTex)
        dzShow(nil, frames[____exports.RIGHT_PORTRAIT_INDEX + 1], true)
    else
        dzShow(nil, frames[____exports.RIGHT_PORTRAIT_INDEX + 1], false)
    end
end
return ____exports
