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
function ____exports.onDialogFinished(self, state)
    state.isActive = false
    state.waitingClick = false
    state.clickCooldown = false
    local cb = state.onFinish
    state.onFinish = nil
    if cb then
        cb(nil)
    end
end
return ____exports
