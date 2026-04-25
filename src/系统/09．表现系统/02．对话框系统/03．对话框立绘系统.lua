--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.LEFT_PORTRAIT_INDEX = 101
____exports.MID_PORTRAIT_INDEX = 102
____exports.RIGHT_PORTRAIT_INDEX = 103
function ____exports.applyPortraitFrames(self, entry, state, getLocalPlayer, getPlayerById, dzSetTexture, dzShow)
    local frames = state.frames
    local isLocalSlot = getLocalPlayer(nil) == getPlayerById(nil, state.playerId)
    if entry.leftTex ~= "" then
        dzSetTexture(nil, frames[____exports.LEFT_PORTRAIT_INDEX + 1], entry.leftTex)
        if isLocalSlot then
            dzShow(nil, frames[____exports.LEFT_PORTRAIT_INDEX + 1], true)
        end
    else
        if isLocalSlot then
            dzShow(nil, frames[____exports.LEFT_PORTRAIT_INDEX + 1], false)
        end
    end
    if entry.midTex ~= "" then
        dzSetTexture(nil, frames[____exports.MID_PORTRAIT_INDEX + 1], entry.midTex)
        if isLocalSlot then
            dzShow(nil, frames[____exports.MID_PORTRAIT_INDEX + 1], true)
        end
    else
        if isLocalSlot then
            dzShow(nil, frames[____exports.MID_PORTRAIT_INDEX + 1], false)
        end
    end
    if entry.rightTex ~= "" then
        dzSetTexture(nil, frames[____exports.RIGHT_PORTRAIT_INDEX + 1], entry.rightTex)
        if isLocalSlot then
            dzShow(nil, frames[____exports.RIGHT_PORTRAIT_INDEX + 1], true)
        end
    else
        if isLocalSlot then
            dzShow(nil, frames[____exports.RIGHT_PORTRAIT_INDEX + 1], false)
        end
    end
end
return ____exports
