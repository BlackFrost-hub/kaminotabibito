--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi = require("jass.japi")
function ____exports.resolveQuestButtonTexts(self, acceptText, rejectText)
    return {accept = acceptText and acceptText ~= "" and acceptText or "接受任务", reject = rejectText and rejectText ~= "" and rejectText or "拒绝任务"}
end
function ____exports.showQuestButtons(self, state, visible, getLocalPlayer, getPlayerById, dzShow)
    local localPlayer = getLocalPlayer(nil)
    local targetPlayer = getPlayerById(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    dzShow(nil, state.frames[6], visible)
    dzShow(nil, state.frames[7], visible)
    dzShow(nil, state.frames[10], visible)
    dzShow(nil, state.frames[8], visible)
    dzShow(nil, state.frames[9], visible)
    dzShow(nil, state.frames[11], visible)
end
function ____exports.setQuestButtonTexts(self, state, acceptText, rejectText)
    if state.frames[10] and state.frames[10] ~= 0 then
        japi.DzFrameSetText(state.frames[10], acceptText)
    end
    if state.frames[11] and state.frames[11] ~= 0 then
        japi.DzFrameSetText(state.frames[11], rejectText)
    end
end
return ____exports
