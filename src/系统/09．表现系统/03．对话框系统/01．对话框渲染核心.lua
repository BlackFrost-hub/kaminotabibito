--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local dzShow, dzSetText, dzSetTexture, dzSetAlpha, dzSetPriority, dzSetAbsPoint, dzSetSize, dzClearPoints, dzSetEnable, dzSetFont, dzCreate, dzGetLocalPlayer, dzGetPlayerId, dzPlayer, dzTimerStart, dzTimerPause, dzLoadToc, dzLoadTocOnce, resolveQuestCallbackByTriggerPlayer, questAcceptCallback, questRejectCallback, createDialogFrames, bindQuestSyncHandlers, showDialogFrames, playEntry, skipTyping, startTyping, onTypingTick, advanceDialog, japi, jass, DIALOG_OPEN_SOUND, MAX_PLAYERS, TOC_PATH, TAG_BASE_MAIN, TAG_BASE_PORTRAIT, DEFAULT_FONT, DEFAULT_TITLE_FONT_SIZE, DEFAULT_BODY_FONT_SIZE, DEFAULT_BG_TEX, DEFAULT_TITLE_TEX, g_states, g_questCallbacksByPlayer, g_tocLoaded
local ____index = require("系统.09．表现系统.01．UI工具.index")
local createFrame = ____index.createFrame
local FrameType = ____index.FrameType
local ____04_FF0E_786C_4EF6_51FD_6570 = require("系统.00．核心系统.04．硬件函数")
local frameSetScriptByCode = ____04_FF0E_786C_4EF6_51FD_6570.frameSetScriptByCode
local ____02_FF0E_97F3_6548_51FD_6570 = require("系统.00．核心系统.02．音效函数")
local Sound3DII_Mp3PlayReuse = ____02_FF0E_97F3_6548_51FD_6570.Sound3DII_Mp3PlayReuse
local ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60 = require("系统.09．表现系统.04．NPC对话状态池")
local getActivePlayerId = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.getActivePlayerId
local resetActivePlayerIdIfMatch = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.resetActivePlayerIdIfMatch
local setActivePlayerId = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.setActivePlayerId
local ____02_FF0E_6253_5B57_673A_6548_679C = require("系统.09．表现系统.03．对话框系统.02．打字机效果")
local STEP_LEN = ____02_FF0E_6253_5B57_673A_6548_679C.STEP_LEN
local TICK = ____02_FF0E_6253_5B57_673A_6548_679C.TICK
local nextTypingProgress = ____02_FF0E_6253_5B57_673A_6548_679C.nextTypingProgress
local stringLengthCompat = ____02_FF0E_6253_5B57_673A_6548_679C.stringLengthCompat
local substringCompat = ____02_FF0E_6253_5B57_673A_6548_679C.substringCompat
local ____03_FF0E_5BF9_8BDD_6846_7ACB_7ED8_7CFB_7EDF = require("系统.09．表现系统.03．对话框系统.03．对话框立绘系统")
local applyPortraitFrames = ____03_FF0E_5BF9_8BDD_6846_7ACB_7ED8_7CFB_7EDF.applyPortraitFrames
local ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846 = require("系统.09．表现系统.03．对话框系统.04．任务对话框")
local resolveQuestButtonTexts = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.resolveQuestButtonTexts
local setQuestButtonTexts = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.setQuestButtonTexts
local showQuestButtons = ____04_FF0E_4EFB_52A1_5BF9_8BDD_6846.showQuestButtons
local ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91 = require("系统.09．表现系统.03．对话框系统.05．对话框业务逻辑")
local createNormalDialogEntry = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.createNormalDialogEntry
local createQuestDialogEntry = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.createQuestDialogEntry
local onDialogFinished = ____05_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.onDialogFinished
function dzShow(self, f, b)
    if f and f ~= 0 and type(japi.DzFrameShow) == "function" then
        japi.DzFrameShow(f, b)
    end
end
function dzSetText(self, f, s)
    if f and f ~= 0 and type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(f, s)
    end
end
function dzSetTexture(self, f, path)
    if f and f ~= 0 and type(japi.DzFrameSetTexture) == "function" then
        japi.DzFrameSetTexture(f, path, 0)
    end
end
function dzSetAlpha(self, f, a)
    if f and f ~= 0 and type(japi.DzFrameSetAlpha) == "function" then
        japi.DzFrameSetAlpha(f, a)
    end
end
function dzSetPriority(self, f, p)
    if f and f ~= 0 and type(japi.DzFrameSetPriority) == "function" then
        pcall(function () return japi.DzFrameSetPriority(f, p) end
        )
    end
end
function dzSetAbsPoint(self, f, point, x, y)
    if f and f ~= 0 and type(japi.DzFrameSetAbsolutePoint) == "function" then
        japi.DzFrameSetAbsolutePoint(f, point, x, y)
    end
end
function dzSetSize(self, f, w, h)
    if f and f ~= 0 and type(japi.DzFrameSetSize) == "function" then
        japi.DzFrameSetSize(f, w, h)
    end
end
function dzClearPoints(self, f)
    if f and f ~= 0 and type(japi.DzFrameClearAllPoints) == "function" then
        japi.DzFrameClearAllPoints(f)
    end
end
function dzSetEnable(self, f, b)
    if f and f ~= 0 and type(japi.DzFrameSetEnable) == "function" then
        japi.DzFrameSetEnable(f, b)
    end
end
function dzSetFont(self, f, font, size)
    if f and f ~= 0 and type(japi.DzFrameSetFont) == "function" then
        japi.DzFrameSetFont(f, font, size, 0)
    end
end
function dzCreate(self, template, tag)
    local ____temp_0
    if type(japi.DzGetGameUI) == "function" then
        ____temp_0 = japi.DzGetGameUI()
    else
        ____temp_0 = 0
    end
    local gameUI = ____temp_0
    if not gameUI or gameUI == 0 then
        return 0
    end
    if type(japi.DzCreateFrame) ~= "function" then
        return 0
    end
    return japi.DzCreateFrame(template, gameUI, tag)
end
function dzGetLocalPlayer(self)
    local ____temp_1
    if type(jass.GetLocalPlayer) == "function" then
        ____temp_1 = jass.GetLocalPlayer()
    else
        ____temp_1 = nil
    end
    return ____temp_1
end
function dzGetPlayerId(self, p)
    return type(jass.GetPlayerId) == "function" and jass.GetPlayerId(p) or -1
end
function dzPlayer(self, index)
    local ____temp_2
    if type(jass.Player) == "function" then
        ____temp_2 = jass.Player(index)
    else
        ____temp_2 = nil
    end
    return ____temp_2
end
function dzTimerStart(self, t, timeout, periodic, cb)
    if t and type(jass.TimerStart) == "function" then
        jass.TimerStart(t, timeout, periodic, cb)
    end
end
function dzTimerPause(self, t)
    if t and type(jass.PauseTimer) == "function" then
        jass.PauseTimer(t)
    end
end
function dzLoadToc(self)
    if type(japi.DzLoadToc) == "function" then
        japi.DzLoadToc(TOC_PATH)
    end
end
function dzLoadTocOnce(self)
    if g_tocLoaded then
        return
    end
    g_tocLoaded = true
    dzLoadToc(nil)
end
function resolveQuestCallbackByTriggerPlayer(self)
    local pid = getActivePlayerId(nil)
    if pid < 0 or pid >= MAX_PLAYERS then
        if type(japi.DzGetTriggerUIEventPlayer) ~= "function" then
            return nil
        end
        local triggerPlayer = japi.DzGetTriggerUIEventPlayer()
        pid = dzGetPlayerId(nil, triggerPlayer)
    end
    if pid < 0 or pid >= MAX_PLAYERS then
        return nil
    end
    local state = g_states[pid + 1]
    if not state then
        return nil
    end
    local cb = g_questCallbacksByPlayer[pid + 1]
    if not cb then
        return nil
    end
    return {state = state, onAccept = cb.onAccept, onReject = cb.onReject}
end
function questAcceptCallback(self)
    local ctx = resolveQuestCallbackByTriggerPlayer(nil)
    if not ctx then
        return
    end
    local state = ctx.state
    local onAccept = ctx.onAccept
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    table.remove(state.queue, 1)
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
    onAccept(nil)
end
function questRejectCallback(self)
    local ctx = resolveQuestCallbackByTriggerPlayer(nil)
    if not ctx then
        return
    end
    local state = ctx.state
    local onReject = ctx.onReject
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    table.remove(state.queue, 1)
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
    onReject(nil)
end
function createDialogFrames(self)
    local frames = {}
    do
        local i = 0
        while i <= 11 do
            frames[i + 1] = 0
            i = i + 1
        end
    end
    frames[102] = 0
    frames[103] = 0
    frames[104] = 0
    local portraits = {{idx = 101, tag = TAG_BASE_PORTRAIT, x = 0.24, y = 0.1421 + 0.2}, {idx = 102, tag = TAG_BASE_PORTRAIT + 1, x = 0.24 + 0.377 / 3, y = 0.1421 + 0.2}, {idx = 103, tag = TAG_BASE_PORTRAIT + 2, x = 0.24 + 0.377 / 1.5, y = 0.1421 + 0.2}}
    for ____, p in ipairs(portraits) do
        local f = dzCreate(nil, "GameUI", p.tag)
        frames[p.idx + 1] = f
        dzShow(nil, f, false)
        dzClearPoints(nil, f)
        dzSetAbsPoint(
            nil,
            f,
            3,
            p.x,
            p.y
        )
        dzSetSize(nil, f, 0.367 / 3, 0.231)
        dzSetAlpha(nil, f, 255)
        dzSetTexture(nil, f, "")
    end
    local ____temp_4
    if type(japi.DzGetGameUI) == "function" then
        ____temp_4 = japi.DzGetGameUI()
    else
        ____temp_4 = 0
    end
    local gameUI = ____temp_4
    local bg = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = "DialogBG",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[1] = bg
    dzClearPoints(nil, bg)
    dzSetAbsPoint(
        nil,
        bg,
        3,
        0.23,
        0.2421
    )
    dzSetSize(nil, bg, 0.377, 0.131)
    dzSetAlpha(nil, bg, 255)
    dzSetTexture(nil, bg, DEFAULT_BG_TEX)
    local bgBtn = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = "DialogBGBtn",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[5] = bgBtn
    if bgBtn ~= 0 then
        if type(japi.DzFrameSetParent) == "function" then
            pcall(function () return japi.DzFrameSetParent(bgBtn, bg) end
            )
        end
        if type(japi.DzFrameClearAllPoints) == "function" then
            pcall(function () return japi.DzFrameClearAllPoints(bgBtn) end
            )
        end
        if type(japi.DzFrameSetAllPoints) == "function" then
            pcall(function () return japi.DzFrameSetAllPoints(bgBtn, bg) end
            )
        end
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(bgBtn, "")
        end
        if type(japi.DzFrameSetAlpha) == "function" then
            pcall(function () return japi.DzFrameSetAlpha(bgBtn, 0) end
            )
        end
    end
    frameSetScriptByCode(
        nil,
        bgBtn,
        1,
        function()
            do
                local i = 0
                while i < MAX_PLAYERS do
                    local s = g_states[i + 1]
                    if s and s.frames[1] == bg then
                        if s.clickCooldown then
                            return
                        end
                        if s.strNow < s.strLen then
                            skipTyping(nil, s)
                        elseif s.waitingClick and #s.queue > 0 and not s.queue[1].isQuest then
                            s.waitingClick = false
                            advanceDialog(nil, s)
                        end
                        return
                    end
                    i = i + 1
                end
            end
        end,
        false
    )
    local titleBg = dzCreate(nil, "GameUI", TAG_BASE_MAIN + 2)
    frames[2] = titleBg
    dzShow(nil, titleBg, false)
    dzClearPoints(nil, titleBg)
    dzSetAbsPoint(
        nil,
        titleBg,
        3,
        0.24,
        0.3083
    )
    dzSetSize(nil, titleBg, 0.107, 0.0328)
    dzSetAlpha(nil, titleBg, 255)
    dzSetTexture(nil, titleBg, DEFAULT_TITLE_TEX)
    local nameText = dzCreate(nil, "GameText", TAG_BASE_MAIN + 3)
    frames[3] = nameText
    dzShow(nil, nameText, false)
    dzClearPoints(nil, nameText)
    if nameText ~= 0 and type(japi.DzFrameSetAllPoints) == "function" then
        pcall(function () return japi.DzFrameSetAllPoints(nameText, titleBg) end
        )
    end
    dzSetText(nil, nameText, "")
    dzSetFont(nil, nameText, DEFAULT_FONT, DEFAULT_TITLE_FONT_SIZE)
    dzSetEnable(nil, nameText, false)
    if nameText ~= 0 and type(japi.DzFrameSetTextAlignment) == "function" then
        pcall(function ()
                japi.DzFrameSetTextAlignment(nameText, -1)
                japi.DzFrameSetTextAlignment(nameText, 18)
            end
        )
    end
    local bodyText = dzCreate(nil, "GameTextpxL", TAG_BASE_MAIN + 4)
    frames[4] = bodyText
    dzShow(nil, bodyText, false)
    dzClearPoints(nil, bodyText)
    dzSetAbsPoint(
        nil,
        bodyText,
        0,
        0.24,
        0.28
    )
    dzSetSize(nil, bodyText, 0.35, 0.22)
    dzSetText(nil, bodyText, "")
    dzSetFont(nil, bodyText, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE)
    dzSetEnable(nil, bodyText, false)
    local acceptBg = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = "DialogAcceptBg",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[6] = acceptBg
    if acceptBg ~= 0 and type(japi.DzFrameSetAbsolutePoint) == "function" then
        japi.DzFrameSetAbsolutePoint(acceptBg, 4, 0.311, 0.18)
    end
    if acceptBg ~= 0 and type(japi.DzFrameSetSize) == "function" then
        japi.DzFrameSetSize(acceptBg, 0.08, 0.022)
    end
    if acceptBg ~= 0 and type(japi.DzFrameSetTexture) == "function" then
        japi.DzFrameSetTexture(acceptBg, "UI\\renwu\\jieshourenwuanniu.tga", 0)
    end
    local acceptLabel = createFrame(nil, {
        type = FrameType.TEXT,
        name = "DialogAcceptLabel",
        parent = acceptBg,
        template = "template",
        visible = false
    }) or 0
    frames[10] = acceptLabel
    if acceptLabel ~= 0 and type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(acceptLabel, acceptBg)
    end
    if acceptLabel ~= 0 and type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(acceptLabel, "接受任务")
    end
    if acceptLabel ~= 0 and type(japi.DzFrameSetTextColor) == "function" then
        japi.DzFrameSetTextColor(
            acceptLabel,
            255,
            255,
            255,
            255
        )
    end
    if acceptLabel ~= 0 and type(japi.DzFrameSetFont) == "function" then
        japi.DzFrameSetFont(acceptLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0)
    end
    if acceptLabel ~= 0 and type(japi.DzFrameSetTextAlignment) == "function" then
        japi.DzFrameSetTextAlignment(acceptLabel, 18)
    end
    local acceptBtn = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = "DialogAcceptBtn",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[7] = acceptBtn
    if acceptBtn ~= 0 and type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(acceptBtn, acceptBg)
    end
    if acceptBtn ~= 0 and type(japi.DzFrameSetAlpha) == "function" then
        japi.DzFrameSetAlpha(acceptBtn, 0)
    end
    if acceptBtn ~= 0 and type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(acceptBtn, "")
    end
    local rejectBg = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = "DialogRejectBg",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[8] = rejectBg
    if rejectBg ~= 0 and type(japi.DzFrameSetAbsolutePoint) == "function" then
        japi.DzFrameSetAbsolutePoint(rejectBg, 4, 0.406, 0.18)
    end
    if rejectBg ~= 0 and type(japi.DzFrameSetSize) == "function" then
        japi.DzFrameSetSize(rejectBg, 0.08, 0.022)
    end
    if rejectBg ~= 0 and type(japi.DzFrameSetTexture) == "function" then
        japi.DzFrameSetTexture(rejectBg, "UI\\renwu\\jieshourenwuanniu.tga", 0)
    end
    local rejectLabel = createFrame(nil, {
        type = FrameType.TEXT,
        name = "DialogRejectLabel",
        parent = rejectBg,
        template = "template",
        visible = false
    }) or 0
    frames[11] = rejectLabel
    if rejectLabel ~= 0 and type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(rejectLabel, rejectBg)
    end
    if rejectLabel ~= 0 and type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(rejectLabel, "拒绝任务")
    end
    if rejectLabel ~= 0 and type(japi.DzFrameSetTextColor) == "function" then
        japi.DzFrameSetTextColor(
            rejectLabel,
            255,
            255,
            255,
            255
        )
    end
    if rejectLabel ~= 0 and type(japi.DzFrameSetFont) == "function" then
        japi.DzFrameSetFont(rejectLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0)
    end
    if rejectLabel ~= 0 and type(japi.DzFrameSetTextAlignment) == "function" then
        japi.DzFrameSetTextAlignment(rejectLabel, 18)
    end
    local rejectBtn = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = "DialogRejectBtn",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[9] = rejectBtn
    if rejectBtn ~= 0 and type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(rejectBtn, rejectBg)
    end
    if rejectBtn ~= 0 and type(japi.DzFrameSetAlpha) == "function" then
        japi.DzFrameSetAlpha(rejectBtn, 0)
    end
    if rejectBtn ~= 0 and type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(rejectBtn, "")
    end
    local hintLabel = createFrame(nil, {
        type = FrameType.TEXT,
        name = "DialogHintLabel",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[12] = hintLabel
    if hintLabel ~= 0 then
        if type(japi.DzFrameSetPoint) == "function" then
            pcall(function () return japi.DzFrameSetPoint(
                    hintLabel,
                    8,
                    bg,
                    8,
                    -0.008,
                    0.008
                ) end
            )
        end
        if type(japi.DzFrameSetSize) == "function" then
            japi.DzFrameSetSize(hintLabel, 0.12, 0.018)
        end
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(hintLabel, "|cff333333[点击以继续] ↓|r")
        end
        if type(japi.DzFrameSetFont) == "function" then
            japi.DzFrameSetFont(hintLabel, DEFAULT_FONT, 0.016, 0)
        end
        if type(japi.DzFrameSetTextAlignment) == "function" then
            japi.DzFrameSetTextAlignment(hintLabel, -1)
            japi.DzFrameSetTextAlignment(hintLabel, 5)
        end
    end
    local p = 180
    dzSetPriority(nil, frames[1], p)
    dzSetPriority(nil, frames[2], p)
    dzSetPriority(nil, frames[3], p)
    dzSetPriority(nil, frames[4], p)
    dzSetPriority(nil, frames[5], p)
    dzSetPriority(nil, frames[6], p)
    dzSetPriority(nil, frames[7], p)
    dzSetPriority(nil, frames[8], p)
    dzSetPriority(nil, frames[9], p)
    dzSetPriority(nil, frames[10], p)
    dzSetPriority(nil, frames[11], p)
    dzSetPriority(nil, frames[12], p)
    dzSetPriority(nil, frames[102], p)
    dzSetPriority(nil, frames[103], p)
    dzSetPriority(nil, frames[104], p)
    return frames
end
function bindQuestSyncHandlers(self, state)
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
function showDialogFrames(self, state, visible)
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
    end
    if visible then
        dzSetAlpha(nil, state.frames[1], 155)
    end
    do
        local i = 101
        while i < 104 do
            dzShow(nil, state.frames[i + 1], visible)
            i = i + 1
        end
    end
end
function playEntry(self, state)
    if #state.queue == 0 then
        return
    end
    local isFirstOpen = not state.isActive
    state.isActive = true
    state.waitingClick = false
    state.clickCooldown = true
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    local isLocal = localPlayer == targetPlayer
    if not state.initialized then
        dzLoadTocOnce(nil)
        state.frames = createDialogFrames(nil)
        state.initialized = true
        bindQuestSyncHandlers(nil, state)
    end
    showDialogFrames(nil, state, true)
    if isFirstOpen then
        Sound3DII_Mp3PlayReuse(nil, DIALOG_OPEN_SOUND, targetPlayer)
    end
    local entry = state.queue[1]
    if entry.isQuest and entry.questCallbacks then
        setActivePlayerId(nil, state.playerId)
        g_questCallbacksByPlayer[state.playerId + 1] = {onAccept = entry.questCallbacks.onAccept, onReject = entry.questCallbacks.onReject}
        local buttonTexts = resolveQuestButtonTexts(nil, entry.acceptText, entry.rejectText)
        setQuestButtonTexts(
            nil,
            state,
            buttonTexts.accept,
            buttonTexts.reject,
            dzGetLocalPlayer,
            dzPlayer
        )
    end
    if not isLocal then
        state.strLen = stringLengthCompat(nil, entry.text)
        state.strNow = 0
        dzTimerStart(
            nil,
            state.tickTimer,
            TICK,
            true,
            function()
                if #state.queue == 0 then
                    dzTimerPause(nil, state.tickTimer)
                    return
                end
                state.strNow = nextTypingProgress(nil, state.strNow, STEP_LEN)
                state.clickCooldown = false
                if state.strNow >= state.strLen then
                    dzTimerPause(nil, state.tickTimer)
                    if not state.queue[1].isQuest then
                        advanceDialog(nil, state)
                    end
                end
            end
        )
        return
    end
    dzSetFont(nil, state.frames[3], DEFAULT_FONT, entry.titleFontSize)
    dzSetFont(nil, state.frames[4], DEFAULT_FONT, entry.bodyFontSize)
    dzSetText(nil, state.frames[3], entry.title)
    dzSetText(nil, state.frames[4], "")
    applyPortraitFrames(
        nil,
        entry,
        state.frames,
        dzSetTexture,
        dzShow
    )
    state.strNow = 0
    state.strLen = stringLengthCompat(nil, entry.text)
    startTyping(nil, state)
end
function skipTyping(self, state)
    if #state.queue == 0 or state.strNow >= state.strLen then
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
    if entry.isQuest then
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
        dzShow(nil, state.frames[12], true)
    end
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
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    local isLocal = localPlayer == targetPlayer
    if state.strNow >= state.strLen then
        if isLocal then
            dzSetText(nil, state.frames[4], entry.text)
        end
        dzTimerPause(nil, state.tickTimer)
        if entry.isQuest then
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
            dzShow(nil, state.frames[12], true)
        end
    elseif isLocal then
        dzSetText(
            nil,
            state.frames[4],
            substringCompat(nil, entry.text, 0, state.strNow)
        )
    end
end
function advanceDialog(self, state)
    showQuestButtons(
        nil,
        state,
        false,
        dzGetLocalPlayer,
        dzPlayer,
        dzShow
    )
    dzShow(nil, state.frames[12], false)
    table.remove(state.queue, 1)
    if #state.queue == 0 then
        onDialogFinished(nil, state)
        showDialogFrames(nil, state, false)
    else
        playEntry(nil, state)
    end
end
japi = require("jass.japi")
jass = require("jass.common")
DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav"
MAX_PLAYERS = 28
TOC_PATH = "ui\\StarGameUI.toc"
TAG_BASE_MAIN = 1024
TAG_BASE_PORTRAIT = 1125
DEFAULT_FONT = "UI\\uizt.ttf"
DEFAULT_TITLE_FONT_SIZE = 0.018
DEFAULT_BODY_FONT_SIZE = 0.012
DEFAULT_BG_TEX = "UI\\wenbenkuang.blp"
DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp"
g_states = {}
g_questCallbacksByPlayer = {}
local function dzTimerCreate(self)
    local ____temp_3
    if type(jass.CreateTimer) == "function" then
        ____temp_3 = jass.CreateTimer()
    else
        ____temp_3 = nil
    end
    return ____temp_3
end
g_tocLoaded = false
_G.QuestAcceptCallback = questAcceptCallback
_G.QuestRejectCallback = questRejectCallback
local function ensureState(self, playerId)
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
local function clearState(self, state)
    dzTimerPause(nil, state.tickTimer)
    resetActivePlayerIdIfMatch(nil, state.playerId)
    g_questCallbacksByPlayer[state.playerId + 1] = nil
    state.queue = {}
    onDialogFinished(nil, state)
    showDialogFrames(nil, state, false)
end
local function enqueue(self, state, entry)
    local wasEmpty = #state.queue == 0
    local ____state_queue_5 = state.queue
    ____state_queue_5[#____state_queue_5 + 1] = entry
    if wasEmpty then
        playEntry(nil, state)
    end
end
function ____exports.initDialogSystem(self)
    dzLoadTocOnce(nil)
    do
        local i = 0
        while i < MAX_PLAYERS do
            local state = ensureState(nil, i)
            if not state.initialized then
                state.frames = createDialogFrames(nil)
                state.initialized = true
            end
            bindQuestSyncHandlers(nil, state)
            i = i + 1
        end
    end
end
function ____exports.displayText(self, p, title, text, duration, titleFontSize, bodyFontSize)
    if duration <= 0 then
        duration = 1
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    enqueue(
        nil,
        state,
        createNormalDialogEntry(
            nil,
            title,
            text,
            duration,
            "",
            "",
            "",
            titleFontSize or DEFAULT_TITLE_FONT_SIZE,
            bodyFontSize or DEFAULT_BODY_FONT_SIZE
        )
    )
end
function ____exports.displayTextEx(self, p, title, text, duration, leftPortrait, midPortrait, rightPortrait, titleFontSize, bodyFontSize)
    if duration <= 0 then
        duration = 1
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    enqueue(
        nil,
        state,
        createNormalDialogEntry(
            nil,
            title,
            text,
            duration,
            leftPortrait,
            midPortrait,
            rightPortrait,
            titleFontSize or DEFAULT_TITLE_FONT_SIZE,
            bodyFontSize or DEFAULT_BODY_FONT_SIZE
        )
    )
end
function ____exports.clearDialog(self, p)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = g_states[pid + 1]
    if not state then
        return
    end
    clearState(nil, state)
end
function ____exports.setDialogShowable(self, p, visible)
    local localPlayer = dzGetLocalPlayer(nil)
    if localPlayer ~= p then
        return
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    state.canShow = visible
    if not visible and state.initialized then
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
    end
end
function ____exports.setDialogBGTexture(self, p, path)
    local localPlayer = dzGetLocalPlayer(nil)
    if localPlayer ~= p then
        return
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = g_states[pid + 1]
    if not state or not state.initialized then
        return
    end
    dzSetTexture(nil, state.frames[1], path)
end
function ____exports.setDialogTitleTexture(self, p, path)
    local localPlayer = dzGetLocalPlayer(nil)
    if localPlayer ~= p then
        return
    end
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = g_states[pid + 1]
    if not state or not state.initialized then
        return
    end
    dzSetTexture(nil, state.frames[2], path)
end
function ____exports.isDialogActive(self, p)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return false
    end
    local state = g_states[pid + 1]
    return not not state and state.isActive
end
function ____exports.setDialogFinishCallback(self, p, callback)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    ensureState(nil, pid).onFinish = callback
end
function ____exports.displayQuest(self, p, title, text, onAccept, onReject, acceptText, rejectText)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    enqueue(
        nil,
        state,
        createQuestDialogEntry(
            nil,
            title,
            text,
            DEFAULT_TITLE_FONT_SIZE,
            DEFAULT_BODY_FONT_SIZE,
            {onAccept = onAccept, onReject = onReject},
            acceptText,
            rejectText
        )
    )
end
return ____exports
