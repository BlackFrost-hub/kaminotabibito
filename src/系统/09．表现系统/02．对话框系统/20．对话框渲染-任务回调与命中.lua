local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local frameSetScriptByCode = ____index.frameSetScriptByCode
local registerKeyEventByCode = ____index.registerKeyEventByCode
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY_STATE
local ____02_FF0E_6253_5B57_673A_6548_679C = require("系统.09．表现系统.02．对话框系统.02．打字机效果")
local stringLengthCompat = ____02_FF0E_6253_5B57_673A_6548_679C.stringLengthCompat
local ____03_FF0E_5BF9_8BDD_6846_7ACB_7ED8_7CFB_7EDF = require("系统.09．表现系统.02．对话框系统.03．对话框立绘系统")
local applyPortraitFrames = ____03_FF0E_5BF9_8BDD_6846_7ACB_7ED8_7CFB_7EDF.applyPortraitFrames
local ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846 = require("系统.09．表现系统.02．对话框系统.04．任务对话框")
local resolveQuestButtonTexts = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.resolveQuestButtonTexts
local setQuestButtonTexts = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.setQuestButtonTexts
local showQuestButtons = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.showQuestButtons
local ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91 = require("系统.09．表现系统.02．对话框系统.05．对话框业务逻辑")
local onDialogFinished = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.onDialogFinished
local resetDialogActiveFlagsKeepOnFinish = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.resetDialogActiveFlagsKeepOnFinish
local ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001 = require("系统.09．表现系统.02．对话框系统.16．对话框同步状态")
local resetActivePlayerIdIfMatch = ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001.resetActivePlayerIdIfMatch
local setActivePlayerId = ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001.setActivePlayerId
local ____18_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27 = require("系统.09．表现系统.02．对话框系统.18．对话框渲染-创建帧")
local setDialogPanelHitBinder = ____18_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27.setDialogPanelHitBinder
local ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001 = require("系统.09．表现系统.02．对话框系统.17．对话框渲染-Dz与状态")
local DEFAULT_BODY_FONT_SIZE = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_BODY_FONT_SIZE
local DEFAULT_FONT = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_FONT
local DEFAULT_TITLE_FONT_SIZE = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_TITLE_FONT_SIZE
local dzGetLocalPlayer = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzGetLocalPlayer
local dzGetPlayerId = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzGetPlayerId
local dzPlayer = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzPlayer
local dzSetFont = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetFont
local dzSetText = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetText
local dzSetTexture = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetTexture
local dzShow = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzShow
local dzTimerPause = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzTimerPause
local findFirstQuestEntryIndex = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.findFirstQuestEntryIndex
local g_questCallbacksByPlayer = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.g_questCallbacksByPlayer
local g_states = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.g_states
local japi = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.japi
local KEY_SKIP_DIALOG = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.KEY_SKIP_DIALOG
local MAX_PLAYERS = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.MAX_PLAYERS
local ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406 = require("系统.09．表现系统.02．对话框系统.19．对话框渲染-播放与状态管理")
local advanceDialog = ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.advanceDialog
local showDialogFrames = ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.showDialogFrames
local skipTyping = ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.skipTyping
local playEntry = ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.playEntry
local jass = require("jass.common")
local function resolveQuestCallbackByPlayerId(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return nil
    end
    local state = g_states[playerId + 1]
    if not state then
        return nil
    end
    local questIdx = findFirstQuestEntryIndex(nil, state)
    if questIdx < 0 then
        return nil
    end
    local entry = state.queue[questIdx + 1]
    local cb = entry.questCallbacks
    return {state = state, questIdx = questIdx, onAccept = cb.onAccept, onReject = cb.onReject}
end
local function runQuestAcceptForPlayer(self, playerId)
    local ctx = resolveQuestCallbackByPlayerId(nil, playerId)
    if not ctx then
        return
    end
    local state = ctx.state
    local questIdx = ctx.questIdx
    local onAccept = ctx.onAccept
    local hadRemainingEntries = #state.queue > questIdx + 1
    dzTimerPause(nil, state.tickTimer)
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    __TS__ArraySplice(state.queue, 0, questIdx + 1)
    state.strNow = 0
    state.strLen = 0
    resetDialogActiveFlagsKeepOnFinish(nil, state)
    onAccept(nil)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer == targetPlayer then
        showQuestButtons(
            nil,
            state,
            false,
            dzGetLocalPlayer,
            dzPlayer,
            dzShow
        )
    end
    if #state.queue == 0 then
        onDialogFinished(nil, state)
        if localPlayer == targetPlayer then
            showDialogFrames(nil, state, false)
        end
    elseif state.isActive then
        return
    elseif hadRemainingEntries or #state.queue > 0 then
        playEntry(nil, state)
    end
end
local function runQuestRejectForPlayer(self, playerId)
    local ctx = resolveQuestCallbackByPlayerId(nil, playerId)
    if not ctx then
        return
    end
    local state = ctx.state
    local questIdx = ctx.questIdx
    local onReject = ctx.onReject
    local hadRemainingEntries = #state.queue > questIdx + 1
    dzTimerPause(nil, state.tickTimer)
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    __TS__ArraySplice(state.queue, 0, questIdx + 1)
    state.strNow = 0
    state.strLen = 0
    resetDialogActiveFlagsKeepOnFinish(nil, state)
    onReject(nil)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer == targetPlayer then
        showQuestButtons(
            nil,
            state,
            false,
            dzGetLocalPlayer,
            dzPlayer,
            dzShow
        )
    end
    if #state.queue == 0 then
        onDialogFinished(nil, state)
        if localPlayer == targetPlayer then
            showDialogFrames(nil, state, false)
        end
    elseif state.isActive then
        return
    elseif hadRemainingEntries or #state.queue > 0 then
        playEntry(nil, state)
    end
end
local function questAcceptCallbackP0(self)
    runQuestAcceptForPlayer(nil, 0)
end
local function questAcceptCallbackP1(self)
    runQuestAcceptForPlayer(nil, 1)
end
local function questAcceptCallbackP2(self)
    runQuestAcceptForPlayer(nil, 2)
end
local function questAcceptCallbackP3(self)
    runQuestAcceptForPlayer(nil, 3)
end
local function questRejectCallbackP0(self)
    runQuestRejectForPlayer(nil, 0)
end
local function questRejectCallbackP1(self)
    runQuestRejectForPlayer(nil, 1)
end
local function questRejectCallbackP2(self)
    runQuestRejectForPlayer(nil, 2)
end
local function questRejectCallbackP3(self)
    runQuestRejectForPlayer(nil, 3)
end
_G.QuestAcceptCallbackP0 = questAcceptCallbackP0
_G.QuestAcceptCallbackP1 = questAcceptCallbackP1
_G.QuestAcceptCallbackP2 = questAcceptCallbackP2
_G.QuestAcceptCallbackP3 = questAcceptCallbackP3
_G.QuestRejectCallbackP0 = questRejectCallbackP0
_G.QuestRejectCallbackP1 = questRejectCallbackP1
_G.QuestRejectCallbackP2 = questRejectCallbackP2
_G.QuestRejectCallbackP3 = questRejectCallbackP3
local function handleDialogPanelClick(self, state)
    if state.strNow < state.strLen then
        skipTyping(nil, state)
        return
    end
    if state.clickCooldown then
        return
    end
    if state.waitingClick and #state.queue > 0 and not state.queue[1].isQuest then
        state.waitingClick = false
        advanceDialog(nil, state)
    end
end
local function runDialogPanelHitForPlayer(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    local state = g_states[playerId + 1]
    if not state then
        return
    end
    handleDialogPanelClick(nil, state)
end
local function dialogPanelHitCallbackP0(self)
    runDialogPanelHitForPlayer(nil, 0)
end
local function dialogPanelHitCallbackP1(self)
    runDialogPanelHitForPlayer(nil, 1)
end
local function dialogPanelHitCallbackP2(self)
    runDialogPanelHitForPlayer(nil, 2)
end
local function dialogPanelHitCallbackP3(self)
    runDialogPanelHitForPlayer(nil, 3)
end
_G.DialogPanelHitCallbackP0 = dialogPanelHitCallbackP0
_G.DialogPanelHitCallbackP1 = dialogPanelHitCallbackP1
_G.DialogPanelHitCallbackP2 = dialogPanelHitCallbackP2
_G.DialogPanelHitCallbackP3 = dialogPanelHitCallbackP3
local function showContinueHintLocal(self, state, visible)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    dzShow(nil, state.frames[12], visible)
end
function ____exports.bindDialogPanelHitFrame(self, _hitFrame)
    return
end
local SKIP_KEY_COOLDOWN_SECONDS = 0.12
local g_skipKeyCooldown = {}
local g_skipKeyCooldownTimers = {}
local function finishSkipKeyCooldownForPlayer(self, pid)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    g_skipKeyCooldown[pid + 1] = false
    local t = g_skipKeyCooldownTimers[pid + 1]
    g_skipKeyCooldownTimers[pid + 1] = nil
    if not t then
        return
    end
    jass.PauseTimer(t)
    jass.DestroyTimer(t)
end
local function skipKeyCooldownCallbackP0(self)
    finishSkipKeyCooldownForPlayer(nil, 0)
end
local function skipKeyCooldownCallbackP1(self)
    finishSkipKeyCooldownForPlayer(nil, 1)
end
local function skipKeyCooldownCallbackP2(self)
    finishSkipKeyCooldownForPlayer(nil, 2)
end
local function skipKeyCooldownCallbackP3(self)
    finishSkipKeyCooldownForPlayer(nil, 3)
end
local function startSkipKeyCooldown(self, pid)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    g_skipKeyCooldown[pid + 1] = true
    local t = jass.CreateTimer()
    g_skipKeyCooldownTimers[pid + 1] = t
    repeat
        local ____switch51 = pid
        local ____cond51 = ____switch51 == 0
        if ____cond51 then
            jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP0)
            return
        end
        ____cond51 = ____cond51 or ____switch51 == 1
        if ____cond51 then
            jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP1)
            return
        end
        ____cond51 = ____cond51 or ____switch51 == 2
        if ____cond51 then
            jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP2)
            return
        end
        ____cond51 = ____cond51 or ____switch51 == 3
        if ____cond51 then
            jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, skipKeyCooldownCallbackP3)
            return
        end
        do
            jass.PauseTimer(t)
            jass.DestroyTimer(t)
            g_skipKeyCooldownTimers[pid + 1] = nil
            g_skipKeyCooldown[pid + 1] = false
            return
        end
    until true
end
local function fastForwardQueueToLastNormalLine(self, state)
    if #state.queue <= 1 then
        return
    end
    local last = state.queue[#state.queue]
    if not last or last.isQuest then
        return
    end
    state.queue = {last}
    showQuestButtons(
        nil,
        state,
        false,
        dzGetLocalPlayer,
        dzPlayer,
        dzShow
    )
    showContinueHintLocal(nil, state, false)
    dzTimerPause(nil, state.tickTimer)
    local entry = state.queue[1]
    state.strLen = stringLengthCompat(nil, entry.text)
    state.strNow = state.strLen
    state.waitingClick = true
    state.clickCooldown = false
    setActivePlayerId(nil, state.playerId)
    dzSetFont(nil, state.frames[3], DEFAULT_FONT, entry.titleFontSize or DEFAULT_TITLE_FONT_SIZE)
    dzSetFont(nil, state.frames[4], DEFAULT_FONT, entry.bodyFontSize or DEFAULT_BODY_FONT_SIZE)
    dzSetText(nil, state.frames[3], entry.title)
    dzSetText(nil, state.frames[4], entry.text)
    showDialogFrames(nil, state, true)
    applyPortraitFrames(
        nil,
        entry,
        state,
        dzGetLocalPlayer,
        dzPlayer,
        dzSetTexture,
        dzShow
    )
    showContinueHintLocal(nil, state, true)
end
local function skipDialogLocal(self)
    local triggerPlayer = japi.DzGetTriggerKeyPlayer()
    if not triggerPlayer then
        return
    end
    local triggerPid = dzGetPlayerId(nil, triggerPlayer)
    if triggerPid == nil or triggerPid < 0 or triggerPid >= MAX_PLAYERS then
        return
    end
    if g_skipKeyCooldown[triggerPid + 1] then
        return
    end
    local state = g_states[triggerPid + 1]
    if not state or #state.queue == 0 then
        return
    end
    local isLocal = dzGetLocalPlayer(nil) == triggerPlayer
    startSkipKeyCooldown(nil, triggerPid)
    dzTimerPause(nil, state.tickTimer)
    local questIdx = findFirstQuestEntryIndex(nil, state)
    if questIdx >= 0 then
        if state.strNow < state.strLen then
            state.strNow = state.strLen
            local head = state.queue[1]
            if head ~= nil then
                dzSetText(nil, state.frames[4], head.text)
            end
        end
        local questEntry = state.queue[questIdx + 1]
        dzSetFont(nil, state.frames[3], DEFAULT_FONT, questEntry.titleFontSize or DEFAULT_TITLE_FONT_SIZE)
        dzSetFont(nil, state.frames[4], DEFAULT_FONT, questEntry.bodyFontSize or DEFAULT_BODY_FONT_SIZE)
        dzSetText(nil, state.frames[3], questEntry.title)
        dzSetText(nil, state.frames[4], questEntry.text)
        showDialogFrames(nil, state, true)
        applyPortraitFrames(
            nil,
            questEntry,
            state,
            dzGetLocalPlayer,
            dzPlayer,
            dzSetTexture,
            dzShow
        )
        local buttonTexts = resolveQuestButtonTexts(nil, questEntry.acceptText, questEntry.rejectText)
        setQuestButtonTexts(nil, state, buttonTexts.accept, buttonTexts.reject)
        showQuestButtons(
            nil,
            state,
            true,
            dzGetLocalPlayer,
            dzPlayer,
            dzShow
        )
        return
    end
    if #state.queue > 1 then
        fastForwardQueueToLastNormalLine(nil, state)
        return
    end
    if state.strNow < state.strLen then
        skipTyping(nil, state)
        return
    end
    if #state.queue > 0 and not state.queue[1].isQuest then
        handleDialogPanelClick(nil, state)
    end
end
local g_skipKeyInitialized = false
function ____exports.initSkipKeyListener(self)
    if g_skipKeyInitialized then
        return
    end
    g_skipKeyInitialized = true
    registerKeyEventByCode(
        nil,
        KEY_SKIP_DIALOG,
        KEY_STATE.DOWN,
        true,
        skipDialogLocal
    )
end
function ____exports.bindQuestSyncHandlersImpl(self, state)
    if state.questSyncHandlersBound or not state.frames or #state.frames == 0 then
        return
    end
    local acceptCallback
    local rejectCallback
    local panelCallback
    repeat
        local ____switch70 = state.playerId
        local ____cond70 = ____switch70 == 0
        if ____cond70 then
            acceptCallback = questAcceptCallbackP0
            rejectCallback = questRejectCallbackP0
            panelCallback = dialogPanelHitCallbackP0
            break
        end
        ____cond70 = ____cond70 or ____switch70 == 1
        if ____cond70 then
            acceptCallback = questAcceptCallbackP1
            rejectCallback = questRejectCallbackP1
            panelCallback = dialogPanelHitCallbackP1
            break
        end
        ____cond70 = ____cond70 or ____switch70 == 2
        if ____cond70 then
            acceptCallback = questAcceptCallbackP2
            rejectCallback = questRejectCallbackP2
            panelCallback = dialogPanelHitCallbackP2
            break
        end
        ____cond70 = ____cond70 or ____switch70 == 3
        if ____cond70 then
            acceptCallback = questAcceptCallbackP3
            rejectCallback = questRejectCallbackP3
            panelCallback = dialogPanelHitCallbackP3
            break
        end
        do
            return
        end
    until true
    frameSetScriptByCode(
        nil,
        state.frames[7],
        1,
        acceptCallback,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[9],
        1,
        rejectCallback,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[5],
        1,
        panelCallback,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[4],
        1,
        panelCallback,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[3],
        1,
        panelCallback,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[12],
        1,
        panelCallback,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[13],
        1,
        panelCallback,
        true
    )
    state.questSyncHandlersBound = true
end
setDialogPanelHitBinder(nil, ____exports.bindDialogPanelHitFrame)
return ____exports
