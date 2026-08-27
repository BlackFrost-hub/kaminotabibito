--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
function ____exports.createNormalDialogEntry(self, title, text, waitTime, leftTex, midTex, rightTex, titleFontSize, bodyFontSize)
    return {
        title = title,
        text = text,
        waitTime = waitTime,
        leftTex = leftTex,
        midTex = midTex,
        rightTex = rightTex,
        titleFontSize = titleFontSize,
        bodyFontSize = bodyFontSize,
        isQuest = false
    }
end
function ____exports.createQuestDialogEntry(self, title, text, titleFontSize, bodyFontSize, callbacks, acceptText, rejectText)
    return {
        title = title,
        text = text,
        waitTime = 0,
        leftTex = "",
        midTex = "",
        rightTex = "",
        titleFontSize = titleFontSize,
        bodyFontSize = bodyFontSize,
        isQuest = true,
        questCallbacks = callbacks,
        acceptText = acceptText,
        rejectText = rejectText
    }
end
--- 仅清「进行中」标志，**不**触发 onFinish（用于任务接受/拒绝后立刻链式 openNpcDialog，避免先 onFinish 销毁 qipao）。
function ____exports.resetDialogActiveFlagsKeepOnFinish(self, state)
    state.isActive = false
    state.typingActive = false
    state.waitingClick = false
    state.clickCooldown = false
end
function ____exports.onDialogFinished(self, state)
    state.isActive = false
    state.typingActive = false
    state.waitingClick = false
    state.clickCooldown = false
    local cb = state.onFinish
    state.onFinish = nil
    if cb then
        cb(nil)
    end
end
local jass = require("jass.common")
____exports.DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的"
____exports.DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者"
function ____exports.showLocalHint(self, playerId, msg, duration)
    if duration == nil then
        duration = 5
    end
    jass:DisplayTimedTextToPlayer(
        jass:Player(playerId),
        0,
        0,
        duration,
        msg
    )
end
return ____exports
