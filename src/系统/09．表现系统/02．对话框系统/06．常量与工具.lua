--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
____exports.DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的"
____exports.DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者"
function ____exports.showLocalHint(self, playerId, msg, duration)
    if duration == nil then
        duration = 5
    end
    jass.DisplayTimedTextToPlayer(
        jass.Player(playerId),
        0,
        0,
        duration,
        msg
    )
end
return ____exports
