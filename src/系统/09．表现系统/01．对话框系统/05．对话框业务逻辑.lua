--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_97F3_6548_51FD_6570 = require("系统.00．核心系统.02．音效函数")
local Sound3DII_Mp3PlayReuse = ____02_FF0E_97F3_6548_51FD_6570.Sound3DII_Mp3PlayReuse
local ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3 = require("系统.09．表现系统.01．对话框系统.01．对话框渲染核心")
local DIALOG_OPEN_SOUND = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.DIALOG_OPEN_SOUND
local dzPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzPlayer
local dzGetLocalPlayer = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzGetLocalPlayer
local dzLoadTocOnce = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzLoadTocOnce
local createDialogFrames = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.createDialogFrames
local showDialogFrames = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.showDialogFrames
local onDialogEnd = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.onDialogEnd
local dzSetText = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzSetText
local dzSetFont = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzSetFont
local dzShow = ____01_FF0E_5BF9_8BDD_6846_6E32_67D3_6838_5FC3.dzShow
local ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60 = require("系统.09．表现系统.04．NPC对话状态池")
local setActivePlayerId = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.setActivePlayerId
local getNpcUnit = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.getNpcUnit
local createBubbleEffect = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.createBubbleEffect
local ____02_FF0E_6253_5B57_673A_6548_679C = require("系统.09．表现系统.01．对话框系统.02．打字机效果")
local startTyping = ____02_FF0E_6253_5B57_673A_6548_679C.startTyping
local skipTyping = ____02_FF0E_6253_5B57_673A_6548_679C.skipTyping
local isTyping = ____02_FF0E_6253_5B57_673A_6548_679C.isTyping
local setTypingCallbacks = ____02_FF0E_6253_5B57_673A_6548_679C.setTypingCallbacks
local setTextLength = ____02_FF0E_6253_5B57_673A_6548_679C.setTextLength
local ____03_FF0E_5BF9_8BDD_6846_7ACB_7ED8_7CFB_7EDF = require("系统.09．表现系统.01．对话框系统.03．对话框立绘系统")
local updatePortraits = ____03_FF0E_5BF9_8BDD_6846_7ACB_7ED8_7CFB_7EDF.updatePortraits
local ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846 = require("系统.09．表现系统.01．对话框系统.04．任务对话框")
local showQuestButtons = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.showQuestButtons
local hideQuestButtons = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.hideQuestButtons
local registerQuestCallbacks = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.registerQuestCallbacks
--- 背景点击回调 - 处理打字机跳过和对话推进
function ____exports.onBackgroundClick(self, state)
    if state.clickCooldown then
        return
    end
    if isTyping(nil, state) then
        skipTyping(nil, state)
    elseif state.waitingClick and #state.queue > 0 then
        local entry = state.queue[1]
        if not entry.isQuest then
            state.waitingClick = false
            ____exports.advanceDialog(nil, state)
        end
    end
end
--- 播放队列中当前对话条目
function ____exports.playEntry(self, state)
    if #state.queue == 0 then
        return
    end
    setActivePlayerId(nil, state.playerId)
    local isFirstOpen = not state.isActive
    state.isActive = true
    state.waitingClick = false
    state.clickCooldown = true
    if isFirstOpen then
        local npcUnit = getNpcUnit(nil, state.playerId)
        if npcUnit then
            createBubbleEffect(nil, state.playerId, npcUnit)
        end
    end
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    local isLocal = localPlayer == targetPlayer
    if not state.initialized then
        dzLoadTocOnce(nil)
        state.frames = createDialogFrames(nil, ____exports.onBackgroundClick)
        state.initialized = true
    end
    if isLocal then
        showDialogFrames(nil, state, true)
    end
    if isFirstOpen then
        Sound3DII_Mp3PlayReuse(nil, DIALOG_OPEN_SOUND, targetPlayer)
    end
    local entry = state.queue[1]
    if isLocal then
        dzSetFont(nil, state.frames[3], "UI\\uizt.ttf", entry.titleFontSize)
        dzSetFont(nil, state.frames[4], "UI\\uizt.ttf", entry.bodyFontSize)
        dzSetText(nil, state.frames[3], entry.title)
        dzSetText(nil, state.frames[4], "")
        updatePortraits(
            nil,
            state,
            entry.leftTex,
            entry.midTex,
            entry.rightTex
        )
    end
    setTextLength(nil, state, #entry.text)
    if isLocal then
        dzShow(nil, state.frames[12], false)
    end
    hideQuestButtons(nil, state)
    if entry.isQuest and entry.questCallbacks then
        registerQuestCallbacks(nil, state, entry.questCallbacks)
    end
    startTyping(nil, state)
end
--- 推进到下一条对话
function ____exports.advanceDialog(self, state)
    hideQuestButtons(nil, state)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer == targetPlayer then
        dzShow(nil, state.frames[12], false)
    end
    table.remove(state.queue, 1)
    if #state.queue == 0 then
        onDialogEnd(nil, state.playerId)
    else
        ____exports.playEntry(nil, state)
    end
end
--- 添加对话到队列
function ____exports.enqueue(self, state, title, text, waitTime, leftTex, midTex, rightTex, titleFontSize, bodyFontSize)
    local entry = {
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
    local wasEmpty = #state.queue == 0
    local ____state_queue_0 = state.queue
    ____state_queue_0[#____state_queue_0 + 1] = entry
    if wasEmpty then
        ____exports.playEntry(nil, state)
    end
end
function ____exports.initTypingCallbacks(self)
    setTypingCallbacks(
        nil,
        {
            onComplete = function()
            end,
            onShowContinueHint = function(____, state, show)
                local localPlayer = dzGetLocalPlayer(nil)
                local targetPlayer = dzPlayer(nil, state.playerId)
                if localPlayer == targetPlayer then
                    dzShow(nil, state.frames[12], show)
                end
            end,
            onShowQuestButtons = function(____, state, show)
                showQuestButtons(nil, state, show)
            end
        }
    )
end
return ____exports
