--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local showContinueHint, startTyping, onTypingTick
local ____index = require("lib.扩展函数.封装函数.02．音效系统.index")
local Sound3DII_Mp3PlayReuse = ____index.Sound3DII_Mp3PlayReuse
local ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001 = require("系统.09．表现系统.02．对话框系统.16．对话框同步状态")
local resetActivePlayerIdIfMatch = ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001.resetActivePlayerIdIfMatch
local setActivePlayerId = ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001.setActivePlayerId
local ____02_FF0E_6253_5B57_673A_6548_679C = require("系统.09．表现系统.02．对话框系统.02．打字机效果")
local STEP_LEN = ____02_FF0E_6253_5B57_673A_6548_679C.STEP_LEN
local TICK = ____02_FF0E_6253_5B57_673A_6548_679C.TICK
local nextTypingProgress = ____02_FF0E_6253_5B57_673A_6548_679C.nextTypingProgress
local stringLengthCompat = ____02_FF0E_6253_5B57_673A_6548_679C.stringLengthCompat
local substringCompat = ____02_FF0E_6253_5B57_673A_6548_679C.substringCompat
local ____03_FF0E_5BF9_8BDD_6846_7ACB_7ED8_7CFB_7EDF = require("系统.09．表现系统.02．对话框系统.03．对话框立绘系统")
local applyPortraitFrames = ____03_FF0E_5BF9_8BDD_6846_7ACB_7ED8_7CFB_7EDF.applyPortraitFrames
local ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846 = require("系统.09．表现系统.02．对话框系统.04．任务对话框")
local resolveQuestButtonTexts = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.resolveQuestButtonTexts
local setQuestButtonTexts = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.setQuestButtonTexts
local showQuestButtons = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.showQuestButtons
local ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91 = require("系统.09．表现系统.02．对话框系统.05．对话框业务逻辑")
local onDialogFinished = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.onDialogFinished
local ____18_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27 = require("系统.09．表现系统.02．对话框系统.18．对话框渲染-创建帧")
local createDialogFrames = ____18_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27.createDialogFrames
local ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001 = require("系统.09．表现系统.02．对话框系统.17．对话框渲染-Dz与状态")
local DEFAULT_FONT = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_FONT
local DIALOG_OPEN_SOUND = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DIALOG_OPEN_SOUND
local dzGetLocalPlayer = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzGetLocalPlayer
local dzPlayer = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzPlayer
local dzSetAlpha = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetAlpha
local dzSetFont = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetFont
local dzSetText = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetText
local dzSetTexture = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetTexture
local dzShow = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzShow
local dzTimerCreate = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzTimerCreate
local dzTimerPause = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzTimerPause
local dzTimerStart = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzTimerStart
local dzLoadTocOnce = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzLoadTocOnce
local g_questCallbacksByPlayer = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.g_questCallbacksByPlayer
local g_states = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.g_states
local syncQuestCallbacksTableFromQueueHead = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.syncQuestCallbacksTableFromQueueHead
function showContinueHint(self, state, visible)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    dzShow(nil, state.frames[12], visible)
end
function startTyping(self, state)
    dzTimerStart(
        nil,
        state.tickTimer,
        TICK,
        true,
        function() return onTypingTick(nil, state) end
    )
end
function onTypingTick(self, state)
    if #state.queue == 0 then
        dzTimerPause(nil, state.tickTimer)
        return
    end
    state.strNow = nextTypingProgress(nil, state.strNow, STEP_LEN)
    state.clickCooldown = false
    local entry = state.queue[1]
    if not entry then
        dzTimerPause(nil, state.tickTimer)
        return
    end
    if state.strNow >= state.strLen then
        dzSetText(nil, state.frames[4], entry.text)
        dzTimerPause(nil, state.tickTimer)
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
            substringCompat(nil, entry.text, 0, state.strNow)
        )
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
        tickTimer = dzTimerCreate(nil),
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
    dzTimerPause(nil, state.tickTimer)
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    state.queue = {}
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
            nil,
            DIALOG_OPEN_SOUND,
            dzPlayer(nil, state.playerId)
        )
    end
    local entry = state.queue[1]
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
    applyPortraitFrames(
        nil,
        entry,
        state,
        dzGetLocalPlayer,
        dzPlayer,
        dzSetTexture,
        dzShow
    )
    state.strNow = 0
    state.strLen = stringLengthCompat(nil, entry.text)
    startTyping(nil, state)
end
function ____exports.skipTyping(self, state)
    if #state.queue == 0 then
        return
    end
    local entry = state.queue[1]
    if state.strNow < state.strLen then
        dzTimerPause(nil, state.tickTimer)
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
    table.remove(state.queue, 1)
    if #state.queue == 0 then
        resetActivePlayerIdIfMatch(nil, state.playerId)
        onDialogFinished(nil, state)
        ____exports.showDialogFrames(nil, state, false)
    else
        ____exports.playEntry(nil, state)
    end
end
function ____exports.enqueue(self, state, entry)
    local wasEmpty = #state.queue == 0
    local ____state_queue_0 = state.queue
    ____state_queue_0[#____state_queue_0 + 1] = entry
    if wasEmpty then
        ____exports.playEntry(nil, state)
    end
end
return ____exports
