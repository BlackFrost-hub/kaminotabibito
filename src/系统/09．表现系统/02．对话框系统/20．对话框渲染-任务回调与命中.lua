local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local frameSetScriptByCode = ____index.frameSetScriptByCode
local registerKeyEventByCode = ____index.registerKeyEventByCode
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY_STATE
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
local getActivePlayerId = ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001.getActivePlayerId
local resetActivePlayerIdIfMatch = ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001.resetActivePlayerIdIfMatch
local setActivePlayerId = ____16_FF0E_5BF9_8BDD_6846_540C_6B65_72B6_6001.setActivePlayerId
local ____18_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27 = require("系统.09．表现系统.02．对话框系统.18．对话框渲染-创建帧")
local setDialogPanelHitBinder = ____18_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_521B_5EFA_5E27.setDialogPanelHitBinder
local ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001 = require("系统.09．表现系统.02．对话框系统.17．对话框渲染-Dz与状态")
local DEFAULT_FONT = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_FONT
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
local ____02_FF0E_6253_5B57_673A_6548_679C = require("系统.09．表现系统.02．对话框系统.02．打字机效果")
local stringLengthCompat = ____02_FF0E_6253_5B57_673A_6548_679C.stringLengthCompat
local ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406 = require("系统.09．表现系统.02．对话框系统.19．对话框渲染-播放与状态管理")
local advanceDialog = ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.advanceDialog
local showDialogFrames = ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.showDialogFrames
local skipTyping = ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.skipTyping
local playEntry = ____19_FF0E_5BF9_8BDD_6846_6E32_67D3_2D_64AD_653E_4E0E_72B6_6001_7BA1_7406.playEntry
local jass = require("jass.common")
local function resolveQuestCallbackByTriggerPlayer(self)
    --- sync=true 全房执行：扫描整个队列（不只看队首）找第一个任务行。
    -- ~ 键改为 sync=false 纯本地 UI 快进，队列不被修改，任务行可能不在队首。
    local questPids = {}
    do
        local i = 0
        while i < MAX_PLAYERS do
            do
                local st = g_states[i + 1]
                if not st or #st.queue == 0 then
                    goto __continue4
                end
                if findFirstQuestEntryIndex(nil, st) >= 0 then
                    questPids[#questPids + 1] = i
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    if #questPids == 0 then
        return nil
    end
    local pid = -1
    if #questPids == 1 then
        pid = questPids[1]
    else
        local aid = getActivePlayerId(nil)
        if aid >= 0 and __TS__ArrayIndexOf(questPids, aid) >= 0 then
            pid = aid
        else
            local triggerPlayer = japi.DzGetTriggerUIEventPlayer()
            local tpid = dzGetPlayerId(nil, triggerPlayer)
            if tpid >= 0 and __TS__ArrayIndexOf(questPids, tpid) >= 0 then
                pid = tpid
            end
        end
        if pid < 0 then
            local minPid = questPids[1]
            do
                local k = 1
                while k < #questPids do
                    if questPids[k + 1] < minPid then
                        minPid = questPids[k + 1]
                    end
                    k = k + 1
                end
            end
            pid = minPid
        end
    end
    if pid < 0 or pid >= MAX_PLAYERS then
        return nil
    end
    local state = g_states[pid + 1]
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
local function questAcceptCallback(self)
    local ctx = resolveQuestCallbackByTriggerPlayer(nil)
    if not ctx then
        return
    end
    local state = ctx.state
    local questIdx = ctx.questIdx
    local onAccept = ctx.onAccept
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    __TS__ArraySplice(state.queue, 0, questIdx + 1)
    resetDialogActiveFlagsKeepOnFinish(nil, state)
    onAccept(nil)
    if #state.queue == 0 then
        onDialogFinished(nil, state)
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
            showDialogFrames(nil, state, false)
        end
    else
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
        playEntry(nil, state)
    end
end
local function questRejectCallback(self)
    local ctx = resolveQuestCallbackByTriggerPlayer(nil)
    if not ctx then
        return
    end
    local state = ctx.state
    local questIdx = ctx.questIdx
    local onReject = ctx.onReject
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    __TS__ArraySplice(state.queue, 0, questIdx + 1)
    resetDialogActiveFlagsKeepOnFinish(nil, state)
    onReject(nil)
    if #state.queue == 0 then
        onDialogFinished(nil, state)
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
            showDialogFrames(nil, state, false)
        end
    else
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
        playEntry(nil, state)
    end
end
_G.QuestAcceptCallback = questAcceptCallback
_G.QuestRejectCallback = questRejectCallback
--- 正文/标题等 TEXT 叠在背景上会抢走点击，需与背景按钮共用同一套逻辑
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
--- sync=true：全房同一次 `advanceDialog`；匿名闭包 + sync=false 会导致仅点击端推进队列，后续点「接受任务」时各端队列不一致 → 接受回调解析失败/掉线。
-- 非点击端 `DzGetTriggerUIEventFrame` 可能为 0：用与「等点击」一致的 `setActivePlayerId` 回退（勿扫全表，易与各端 waiting 状态漂移冲突 → 误 advance）。
local function dialogPanelHitCallback(self)
    local hitFrame = 0
    hitFrame = japi.DzGetTriggerUIEventFrame()
    if hitFrame and hitFrame ~= 0 then
        do
            local i = 0
            while i < MAX_PLAYERS do
                do
                    local s = g_states[i + 1]
                    if not s then
                        goto __continue39
                    end
                    if s.frames[5] ~= hitFrame and s.frames[4] ~= hitFrame and s.frames[3] ~= hitFrame and s.frames[12] ~= hitFrame and s.frames[13] ~= hitFrame then
                        goto __continue39
                    end
                    handleDialogPanelClick(nil, s)
                    return
                end
                ::__continue39::
                i = i + 1
            end
        end
    end
    local aid = getActivePlayerId(nil)
    if aid >= 0 and aid < MAX_PLAYERS then
        local s = g_states[aid + 1]
        if not s or #s.queue == 0 then
            return
        end
        if s.strNow < s.strLen then
            handleDialogPanelClick(nil, s)
            return
        end
        if s.waitingClick and not s.queue[1].isQuest then
            handleDialogPanelClick(nil, s)
        end
    end
end
_G.DialogPanelHitCallback = dialogPanelHitCallback
function ____exports.bindDialogPanelHitFrame(self, hitFrame)
    if not hitFrame or hitFrame == 0 then
        return
    end
    frameSetScriptByCode(
        nil,
        hitFrame,
        1,
        dialogPanelHitCallback,
        true
    )
end
--- 每玩家独立 ~ 键冷却：防止疯狂连按导致提交/日后谈对白链上引擎调用堆叠 → 即便已修 desync，
-- 也能避免"对话框都还没渲染完就又被 ~ 推进下一步"的 UI 紊乱。
-- 数组长度 MAX_PLAYERS，sync=true 回调里对称读写，所有客户端状态一致。
local SKIP_KEY_COOLDOWN_SECONDS = 0.08
local g_skipKeyCooldown = {}
local function startSkipKeyCooldown(self, pid)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    g_skipKeyCooldown[pid + 1] = true
    local t = jass.CreateTimer()
    jass.TimerStart(
        t,
        SKIP_KEY_COOLDOWN_SECONDS,
        false,
        function()
            g_skipKeyCooldown[pid + 1] = false
            jass.PauseTimer(t)
            jass.DestroyTimer(t)
        end
    )
end
--- 多句纯对白：一次 ~ 将队列裁剪为**只保留最后一句**（全房对称 Lua），并显示全文 +「点击继续」。
-- 不使用 DzClickFrame 连点，避免单帧 sync 堆叠；**关闭本段对话**仍需再按 ~ 或点背景（单次 DzClickFrame）。
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
    dzShow(nil, state.frames[12], false)
    dzTimerPause(nil, state.tickTimer)
    local entry = state.queue[1]
    state.strLen = stringLengthCompat(nil, entry.text)
    state.strNow = state.strLen
    state.waitingClick = true
    state.clickCooldown = false
    setActivePlayerId(nil, state.playerId)
    dzSetFont(nil, state.frames[3], DEFAULT_FONT, entry.titleFontSize)
    dzSetFont(nil, state.frames[4], DEFAULT_FONT, entry.bodyFontSize)
    dzSetText(nil, state.frames[3], entry.title)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer == targetPlayer then
        dzSetText(nil, state.frames[4], entry.text)
    end
    showDialogFrames(nil, state, true)
    applyPortraitFrames(
        nil,
        entry,
        state.frames,
        dzSetTexture,
        dzShow
    )
    if localPlayer == targetPlayer then
        dzShow(nil, state.frames[12], true)
    end
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
        dzSetFont(nil, state.frames[3], DEFAULT_FONT, questEntry.titleFontSize)
        dzSetFont(nil, state.frames[4], DEFAULT_FONT, questEntry.bodyFontSize)
        dzSetText(nil, state.frames[3], questEntry.title)
        dzSetText(nil, state.frames[4], questEntry.text)
        showDialogFrames(nil, state, true)
        applyPortraitFrames(
            nil,
            questEntry,
            state.frames,
            dzSetTexture,
            dzShow
        )
        local buttonTexts = resolveQuestButtonTexts(nil, questEntry.acceptText, questEntry.rejectText)
        setQuestButtonTexts(
            nil,
            state,
            buttonTexts.accept,
            buttonTexts.reject,
            dzGetLocalPlayer,
            dzPlayer
        )
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
    --- DzClickFrame：sync=true 帧脚本，全房对称 → `advanceDialog`。
    -- **每次 ~ 至多一次**（等同鼠标点一下背景），避免单 tick 内连点 N 次。
    local lp = dzGetLocalPlayer(nil)
    if lp == triggerPlayer then
        local hitFrame = state.frames[5]
        if hitFrame and hitFrame ~= 0 and #state.queue > 0 and not state.queue[1].isQuest then
            japi.DzClickFrame(hitFrame)
        end
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
        false,
        function()
            skipDialogLocal(nil)
        end
    )
end
function ____exports.bindQuestSyncHandlersImpl(self, state)
    if state.questSyncHandlersBound or not state.frames or #state.frames == 0 then
        return
    end
    frameSetScriptByCode(
        nil,
        state.frames[7],
        1,
        questAcceptCallback,
        true
    )
    frameSetScriptByCode(
        nil,
        state.frames[9],
        1,
        questRejectCallback,
        true
    )
    state.questSyncHandlersBound = true
end
setDialogPanelHitBinder(nil, ____exports.bindDialogPanelHitFrame)
return ____exports
