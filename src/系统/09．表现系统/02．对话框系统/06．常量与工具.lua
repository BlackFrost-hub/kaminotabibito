--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____13_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统.13．任务奖励执行")
local giveRewardToPlayers = ____13_FF0E_4EFB_52A1_5956_52B1_6267_884C.giveRewardToPlayers
local jass = require("jass.common")
____exports.UNIT_ID_NGME = 110 * 16777216 + 103 * 65536 + 109 * 256 + 101
____exports.DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的"
____exports.DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者"
function ____exports.showLocalHint(self, playerId, msg, duration)
    if duration == nil then
        duration = 5
    end
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer == jass.Player(playerId) then
        jass.DisplayTimedTextToPlayer(
            localPlayer,
            0,
            0,
            duration,
            msg
        )
    end
end
function ____exports.giveQuestReward(self, reward, triggerPlayerId)
    giveRewardToPlayers(nil, reward, triggerPlayerId)
end
return ____exports
