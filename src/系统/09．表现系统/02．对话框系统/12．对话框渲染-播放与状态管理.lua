--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local showContinueHint, startTyping, onTypingTick, jass
local ____index = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_Mp3PlayReuse = ____index.Sound3DII_Mp3PlayReuse
local ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001 = require("系统.09．表现系统.02．对话框系统.10．对话框渲染-Dz与状态")
local resetActivePlayerIdIfMatch = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.resetActivePlayerIdIfMatch
local setActivePlayerId = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.setActivePlayerId
local ____01_FF0E_4EFB_52A1_5BF9_8BDD_6846 = require("系统.09．表现系统.02．对话框系统.01．任务对话框")
local resolveQuestButtonTexts = ____01_FF0E_4EFB_52A1_5BF9_8BDD_6846.resolveQuestButtonTexts
local setQuestButtonTexts = ____01_FF0E_4EFB_52A1_5BF9_8BDD_6846.setQuestButtonTexts
local showQuestButtons = ____01_FF0E_4EFB_52A1_5BF9_8BDD_6846.showQuestButtons
local ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91 = require("系统.09．表现系统.02．对话框系统.02．对话框业务逻辑")
local onDialogFinished = ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.onDialogFinished
local ____11_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27 = require("系统.09．表现系统.02．对话框系统.11．对话框渲染-创建帧")
local createDialogFrames = ____11_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27.createDialogFrames
local ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001 = require("系统.09．表现系统.02．对话框系统.10．对话框渲染-Dz与状态")
local DEFAULT_FONT = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_FONT
local DIALOG_OPEN_SOUND = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DIALOG_OPEN_SOUND
local dzGetLocalPlayer = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzGetLocalPlayer
local dzPlayer = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzPlayer
local dzSetAlpha = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetAlpha
local dzSetFont = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetFont
local dzSetText = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetText
local dzSetTexture = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetTexture
local dzShow = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzShow
local dzLoadTocOnce = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzLoadTocOnce
local g_questCallbacksByPlayer = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.g_questCallbacksByPlayer
local g_states = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.g_states
local MAX_PLAYERS = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.MAX_PLAYERS
local syncQuestCallbacksTableFromQueueHead = ____10_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.syncQuestCallbacksTableFromQueueHead
function ____exports.nextTypingProgress(self, current, step)
    if step == nil then
        step = ____exports.STEP_LEN
    end
    return current + step
end
function ____exports.substringCompat(self, text, start, ____end)
    return jass:SubString(text, start, ____end)
end
function showContinueHint(self, state, visible)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    dzShow(nil, state.frames[12], visible)
end
function startTyping(self, state)
    if state.playerId < 0 or state.playerId >= MAX_PLAYERS then
        return
    end
    state.typingActive = true
end
function ____exports.stopTyping(self, state)
    state.typingActive = false
end
function onTypingTick(self, state)
    if #state.queue == 0 then
        ____exports.stopTyping(nil, state)
        return
    end
    state.strNow = ____exports.nextTypingProgress(nil, state.strNow, ____exports.STEP_LEN)
    state.clickCooldown = false
    local entry = state.queue[state.currentIndex + 1]
    if not entry then
        ____exports.stopTyping(nil, state)
        return
    end
    if state.strNow >= state.strLen then
        dzSetText(nil, state.frames[4], entry.text)
        ____exports.stopTyping(nil, state)
        if entry.isQuest then
            syncQuestCallbacksTableFromQueueHead(nil, state)
            showQuestButtons(
                nil,
                state,
                true,
                dzGetLocalPlayer,
                dzPlayer,
                dzShow
            )
        else
            state.waitingClick = true
            setActivePlayerId(nil, state.playerId)
            showContinueHint(nil, state, true)
        end
    else
        dzSetText(
            nil,
            state.frames[4],
            ____exports.substringCompat(nil, entry.text, 0, state.strNow)
        )
    end
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
____exports.STEP_LEN = 2
____exports.TICK = 0.03
function ____exports.stringLengthCompat(self, text)
    return jass:StringLength(text)
end
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
local g_bindQuestSyncHandlers
function ____exports.setQuestSyncHandlersBinder(self, fn)
    g_bindQuestSyncHandlers = fn
end
local function bindQuestSyncHandlers(self, state)
    if g_bindQuestSyncHandlers then
        g_bindQuestSyncHandlers(nil, state)
    end
end
function ____exports.ensureState(self, playerId)
    if g_states[playerId + 1] then
        return g_states[playerId + 1]
    end
    local state = {
        playerId = playerId,
        queue = {},
        currentIndex = 0,
        typingActive = false,
        frames = {},
        strNow = 0,
        strLen = 0,
        canShow = true,
        initialized = false,
        questSyncHandlersBound = false,
        isActive = false,
        clickCooldown = false,
        waitingClick = false
    }
    g_states[playerId + 1] = state
    return state
end
function ____exports.showDialogFrames(self, state, visible)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    if not state.canShow then
        do
            local i = 0
            while i < 9 do
                dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
        do
            local i = 101
            while i < 104 do
                dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
        return
    end
    do
        local i = 0
        while i < 5 do
            dzShow(nil, state.frames[i + 1], visible)
            i = i + 1
        end
    end
    if not visible then
        dzShow(nil, state.frames[6], false)
        dzShow(nil, state.frames[7], false)
        dzShow(nil, state.frames[8], false)
        dzShow(nil, state.frames[9], false)
        dzShow(nil, state.frames[10], false)
        dzShow(nil, state.frames[11], false)
        dzShow(nil, state.frames[12], false)
        dzShow(nil, state.frames[13], false)
    end
    if visible then
        dzSetAlpha(nil, state.frames[1], 155)
        dzShow(nil, state.frames[13], true)
    end
    do
        local i = 101
        while i < 104 do
            dzShow(nil, state.frames[i + 1], visible)
            i = i + 1
        end
    end
end
function ____exports.clearState(self, state)
    ____exports.stopTyping(nil, state)
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    state.queue = {}
    state.currentIndex = 0
    onDialogFinished(nil, state)
    ____exports.showDialogFrames(nil, state, false)
end
function ____exports.playEntry(self, state)
    if #state.queue == 0 then
        return
    end
    local isFirstOpen = not state.isActive
    state.isActive = true
    state.waitingClick = false
    state.clickCooldown = true
    if not state.initialized then
        dzLoadTocOnce(nil)
        state.frames = createDialogFrames(nil, state.playerId)
        state.initialized = true
        bindQuestSyncHandlers(nil, state)
    end
    ____exports.showDialogFrames(nil, state, true)
    if isFirstOpen then
        Sound3DII_Mp3PlayReuse(
            DIALOG_OPEN_SOUND,
            dzPlayer(nil, state.playerId)
        )
    end
    local entry = state.queue[state.currentIndex + 1]
    setActivePlayerId(nil, state.playerId)
    if entry.isQuest and entry.questCallbacks then
        syncQuestCallbacksTableFromQueueHead(nil, state)
        local buttonTexts = resolveQuestButtonTexts(nil, entry.acceptText, entry.rejectText)
        setQuestButtonTexts(nil, state, buttonTexts.accept, buttonTexts.reject)
    end
    dzSetFont(nil, state.frames[3], DEFAULT_FONT, entry.titleFontSize)
    dzSetFont(nil, state.frames[4], DEFAULT_FONT, entry.bodyFontSize)
    dzSetText(nil, state.frames[3], entry.title)
    dzSetText(nil, state.frames[4], "")
    ____exports.applyPortraitFrames(
        nil,
        entry,
        state,
        dzGetLocalPlayer,
        dzPlayer,
        dzSetTexture,
        dzShow
    )
    state.strNow = 0
    state.strLen = ____exports.stringLengthCompat(nil, entry.text)
    startTyping(nil, state)
end
function ____exports.skipTyping(self, state)
    if #state.queue == 0 then
        return
    end
    local entry = state.queue[state.currentIndex + 1]
    if state.strNow < state.strLen then
        ____exports.stopTyping(nil, state)
        state.strNow = state.strLen
        dzSetText(nil, state.frames[4], entry.text)
    end
    if entry.isQuest then
        syncQuestCallbacksTableFromQueueHead(nil, state)
        showQuestButtons(
            nil,
            state,
            true,
            dzGetLocalPlayer,
            dzPlayer,
            dzShow
        )
    else
        state.waitingClick = true
        setActivePlayerId(nil, state.playerId)
        showContinueHint(nil, state, true)
    end
    state.clickCooldown = false
end
local function onTypingDriver()
    do
        local playerId = 0
        while playerId < MAX_PLAYERS do
            do
                local state = g_states[playerId + 1]
                if not state or not state.typingActive then
                    goto __continue54
                end
                onTypingTick(nil, state)
            end
            ::__continue54::
            playerId = playerId + 1
        end
    end
end
addPeriodicCallback(____exports.TICK * 1000, onTypingDriver)
function ____exports.advanceDialog(self, state)
    showQuestButtons(
        nil,
        state,
        false,
        dzGetLocalPlayer,
        dzPlayer,
        dzShow
    )
    showContinueHint(nil, state, false)
    state.currentIndex = state.currentIndex + 1
    if state.currentIndex >= #state.queue then
        resetActivePlayerIdIfMatch(nil, state.playerId)
        onDialogFinished(nil, state)
        ____exports.showDialogFrames(nil, state, false)
    else
        ____exports.playEntry(nil, state)
    end
end
function ____exports.enqueue(self, state, entry)
    local wasEmpty = #state.queue == 0
    local ____state_queue_1 = state.queue
    ____state_queue_1[#____state_queue_1 + 1] = entry
    if wasEmpty then
        state.currentIndex = 0
        ____exports.playEntry(nil, state)
    end
end
return ____exports
