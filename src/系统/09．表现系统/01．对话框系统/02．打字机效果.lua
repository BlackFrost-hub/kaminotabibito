--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local onTypingTick, onTypingComplete, g_callbacks
local ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3 = require("系统.09．表现系统.01．对话框系统.01．对话框渲染核心")
local dzTimerStart = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzTimerStart
local dzTimerPause = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzTimerPause
local dzSetText = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzSetText
local dzGetLocalPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzGetLocalPlayer
local dzPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzPlayer
local dzSubString = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzSubString
function onTypingTick(self, state)
    if #state.queue == 0 then
        dzTimerPause(nil, state.tickTimer)
        return
    end
    state.strNow = state.strNow + ____exports.STEP_LEN
    state.clickCooldown = false
    local entry = state.queue[1]
    if not entry then
        dzTimerPause(nil, state.tickTimer)
        return
    end
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    local isLocal = localPlayer == targetPlayer
    if state.strNow >= state.strLen then
        if isLocal then
            dzSetText(nil, state.frames[4], entry.text)
        end
        dzTimerPause(nil, state.tickTimer)
        onTypingComplete(nil, state)
    else
        if isLocal then
            local partial = dzSubString(nil, entry.text, 0, state.strNow)
            dzSetText(nil, state.frames[4], partial)
        end
    end
end
function onTypingComplete(self, state)
    local entry = state.queue[1]
    if not entry then
        return
    end
    if entry.isQuest then
        if g_callbacks then
            g_callbacks:onShowQuestButtons(state, true)
        end
    else
        state.waitingClick = true
        if g_callbacks then
            g_callbacks:onShowContinueHint(state, true)
        end
    end
    if g_callbacks then
        g_callbacks:onComplete(state)
    end
end
--- 打字机每帧步进（字符数）
____exports.STEP_LEN = 2
--- 打字机帧间隔（秒）
____exports.TICK = 0.03
g_callbacks = nil
function ____exports.setTypingCallbacks(self, callbacks)
    g_callbacks = callbacks
end
--- 开始打字机效果
function ____exports.startTyping(self, state)
    dzTimerStart(
        nil,
        state.tickTimer,
        ____exports.TICK,
        true,
        function()
            onTypingTick(nil, state)
        end
    )
end
--- 跳过打字机，直接显示完整文本
function ____exports.skipTyping(self, state)
    if #state.queue == 0 then
        return
    end
    if state.strNow >= state.strLen then
        return
    end
    dzTimerPause(nil, state.tickTimer)
    state.strNow = state.strLen
    local entry = state.queue[1]
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer == targetPlayer then
        dzSetText(nil, state.frames[4], entry.text)
    end
    onTypingComplete(nil, state)
end
--- 检查是否正在打字中
function ____exports.isTyping(self, state)
    return state.strNow < state.strLen
end
--- 获取当前打字进度（0-1）
function ____exports.getTypingProgress(self, state)
    if state.strLen == 0 then
        return 1
    end
    return state.strNow / state.strLen
end
--- 重置打字状态
function ____exports.resetTyping(self, state)
    dzTimerPause(nil, state.tickTimer)
    state.strNow = 0
    state.strLen = 0
    state.waitingClick = false
end
--- 设置新的文本长度
function ____exports.setTextLength(self, state, length)
    state.strLen = length
    state.strNow = 0
end
return ____exports
