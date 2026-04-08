--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local dzShow, dzSetText, dzSetTexture, dzSetAlpha, dzSetAbsPoint, dzSetSize, dzClearPoints, dzSetEnable, dzSetFont, dzCreate, dzSubString, dzStringLength, dzGetLocalPlayer, dzPlayer, dzTimerStart, dzTimerPause, dzLoadToc, dzLoadTocOnce, createDialogFrames, showDialogFrames, playEntry, skipTyping, startTyping, onTypingTick, advanceDialog, showQuestButtons, japi, jass, DIALOG_OPEN_SOUND, MAX_PLAYERS, STEP_LEN, TICK, TOC_PATH, TAG_BASE_MAIN, TAG_BASE_PORTRAIT, DEFAULT_FONT, DEFAULT_TITLE_FONT_SIZE, DEFAULT_BODY_FONT_SIZE, DEFAULT_BG_TEX, DEFAULT_TITLE_TEX, g_states, g_tocLoaded
local ____01_FF0EUI_5DE5_5177 = require("系统.09．表现系统.01．UI工具")
local createFrame = ____01_FF0EUI_5DE5_5177.createFrame
local FrameType = ____01_FF0EUI_5DE5_5177.FrameType
local ____04_FF0E_786C_4EF6_51FD_6570 = require("系统.00．核心系统.04．硬件函数")
local frameSetScriptByCode = ____04_FF0E_786C_4EF6_51FD_6570.frameSetScriptByCode
local ____02_FF0E_97F3_6548_51FD_6570 = require("系统.00．核心系统.02．音效函数")
local Sound3DII_Mp3PlayReuse = ____02_FF0E_97F3_6548_51FD_6570.Sound3DII_Mp3PlayReuse
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
function dzSubString(self, s, start, ____end)
    if type(jass.SubString) == "function" then
        return jass.SubString(s, start, ____end)
    end
    return s:sub(start + 1, ____end)
end
function dzStringLength(self, s)
    if type(jass.StringLength) == "function" then
        return jass.StringLength(s)
    end
    return #s
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
            local found = false
            do
                local i = 0
                while i < MAX_PLAYERS do
                    local s = g_states[i + 1]
                    if s and s.frames[1] == bg then
                        if s.clickCooldown then
                        elseif s.strNow < s.strLen then
                            skipTyping(nil, s)
                        elseif s.waitingClick and #s.queue > 0 and not s.queue[1].isQuest then
                            s.waitingClick = false
                            advanceDialog(nil, s)
                        end
                        found = true
                        break
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
    return frames
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
    if isLocal and not state.initialized then
        dzLoadTocOnce(nil)
        state.frames = createDialogFrames(nil)
        state.initialized = true
    end
    showDialogFrames(nil, state, true)
    if isFirstOpen then
        Sound3DII_Mp3PlayReuse(nil, DIALOG_OPEN_SOUND, targetPlayer)
    end
    if not isLocal then
        local entry = state.queue[1]
        state.strLen = dzStringLength(nil, entry.text)
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
                state.strNow = state.strNow + STEP_LEN
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
    local entry = state.queue[1]
    dzSetFont(nil, state.frames[3], DEFAULT_FONT, entry.titleFontSize)
    dzSetFont(nil, state.frames[4], DEFAULT_FONT, entry.bodyFontSize)
    dzSetText(nil, state.frames[3], entry.title)
    dzSetText(nil, state.frames[4], "")
    if entry.leftTex ~= "" then
        dzSetTexture(nil, state.frames[102], entry.leftTex)
        dzShow(nil, state.frames[102], true)
    else
        dzShow(nil, state.frames[102], false)
    end
    if entry.midTex ~= "" then
        dzSetTexture(nil, state.frames[103], entry.midTex)
        dzShow(nil, state.frames[103], true)
    else
        dzShow(nil, state.frames[103], false)
    end
    if entry.rightTex ~= "" then
        dzSetTexture(nil, state.frames[104], entry.rightTex)
        dzShow(nil, state.frames[104], true)
    else
        dzShow(nil, state.frames[104], false)
    end
    state.strNow = 0
    state.strLen = dzStringLength(nil, entry.text)
    if entry.isQuest and entry.questCallbacks then
        local cb = entry.questCallbacks
        frameSetScriptByCode(
            nil,
            state.frames[7],
            1,
            function()
                showQuestButtons(nil, state, false)
                showDialogFrames(nil, state, false)
                table.remove(state.queue, 1)
                state.isActive = false
                cb:onAccept()
            end,
            false
        )
        frameSetScriptByCode(
            nil,
            state.frames[9],
            1,
            function()
                showQuestButtons(nil, state, false)
                showDialogFrames(nil, state, false)
                table.remove(state.queue, 1)
                state.isActive = false
                cb:onReject()
            end,
            false
        )
    end
    startTyping(nil, state)
end
function skipTyping(self, state)
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
    if entry.isQuest then
        showQuestButtons(nil, state, true)
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
        function()
            onTypingTick(nil, state)
        end
    )
end
function onTypingTick(self, state)
    if #state.queue == 0 then
        dzTimerPause(nil, state.tickTimer)
        return
    end
    state.strNow = state.strNow + STEP_LEN
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
            showQuestButtons(nil, state, true)
        else
            state.waitingClick = true
            dzShow(nil, state.frames[12], true)
        end
    else
        if isLocal then
            local partial = dzSubString(nil, entry.text, 0, state.strNow)
            dzSetText(nil, state.frames[4], partial)
        end
    end
end
function advanceDialog(self, state)
    showQuestButtons(nil, state, false)
    dzShow(nil, state.frames[12], false)
    table.remove(state.queue, 1)
    if #state.queue == 0 then
        state.isActive = false
        state.waitingClick = false
        state.clickCooldown = false
        showDialogFrames(nil, state, false)
        local cb = state.onFinish
        state.onFinish = nil
        if cb then
            cb(nil)
        end
    else
        playEntry(nil, state)
    end
end
function showQuestButtons(self, state, visible)
    local localPlayer = dzGetLocalPlayer(nil)
    local targetPlayer = dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    dzShow(nil, state.frames[6], visible)
    dzShow(nil, state.frames[7], visible)
    dzShow(nil, state.frames[10], visible)
    dzShow(nil, state.frames[8], visible)
    dzShow(nil, state.frames[9], visible)
    dzShow(nil, state.frames[11], visible)
end
japi = require("jass.japi")
jass = require("jass.common")
DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav"
MAX_PLAYERS = 28
STEP_LEN = 2
TICK = 0.03
TOC_PATH = "ui\\StarGameUI.toc"
TAG_BASE_MAIN = 1024
TAG_BASE_PORTRAIT = 1125
DEFAULT_FONT = "UI\\uizt.ttf"
DEFAULT_TITLE_FONT_SIZE = 0.018
DEFAULT_BODY_FONT_SIZE = 0.012
DEFAULT_BG_TEX = "UI\\wenbenkuang.blp"
DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp"
g_states = {}
local function dzGetPlayerId(self, p)
    return type(jass.GetPlayerId) == "function" and jass.GetPlayerId(p) or -1
end
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
        isActive = false,
        clickCooldown = false,
        waitingClick = false
    }
    g_states[playerId + 1] = state
    return state
end
local function clearState(self, state)
    dzTimerPause(nil, state.tickTimer)
    state.queue = {}
    state.isActive = false
    state.waitingClick = false
    state.clickCooldown = false
    showDialogFrames(nil, state, false)
    local cb = state.onFinish
    state.onFinish = nil
    if cb then
        cb(nil)
    end
end
local function enqueue(self, state, title, text, waitTime, leftTex, midTex, rightTex, titleFontSize, bodyFontSize)
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
    local ____state_queue_5 = state.queue
    ____state_queue_5[#____state_queue_5 + 1] = entry
    if wasEmpty then
        playEntry(nil, state)
    end
end
--- 初始化对话框系统（为全部玩家预创建状态，不创建帧）
-- 可在地图初始化时调用，也可以不调用（首次 display 时懒初始化）
function ____exports.initDialogSystem(self)
    do
        local i = 0
        while i < MAX_PLAYERS do
            ensureState(nil, i)
            i = i + 1
        end
    end
end
--- 为指定玩家添加一条对话（无立绘）
-- 
-- @param p 目标玩家
-- @param title 标题（说话人名字）
-- @param text 正文
-- @param duration 正文打完后停留时间（秒），最小 1
-- @param titleFontSize 标题字体大小（默认 DEFAULT_TITLE_FONT_SIZE）
-- @param bodyFontSize 正文字体大小（默认 DEFAULT_BODY_FONT_SIZE）
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
        title,
        text,
        duration,
        "",
        "",
        "",
        titleFontSize or DEFAULT_TITLE_FONT_SIZE,
        bodyFontSize or DEFAULT_BODY_FONT_SIZE
    )
end
--- 为指定玩家添加一条对话（带立绘）
-- 
-- @param p 目标玩家
-- @param title 标题
-- @param text 正文
-- @param duration 停留时间（秒）
-- @param leftPortrait 左侧立绘路径（""=不显示）
-- @param midPortrait 中间立绘路径
-- @param rightPortrait 右侧立绘路径
-- @param titleFontSize 标题字体大小（默认 DEFAULT_TITLE_FONT_SIZE）
-- @param bodyFontSize 正文字体大小（默认 DEFAULT_BODY_FONT_SIZE）
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
        title,
        text,
        duration,
        leftPortrait,
        midPortrait,
        rightPortrait,
        titleFontSize or DEFAULT_TITLE_FONT_SIZE,
        bodyFontSize or DEFAULT_BODY_FONT_SIZE
    )
end
--- 清除指定玩家的全部对话队列并立即隐藏对话框
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
--- 设置指定玩家是否显示对话框
-- 用本地判断：仅本地玩家生效，不触发 desync
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
--- 设置指定玩家的对话框背景贴图
-- 必须在本地判断内调用，防止 desync
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
--- 设置指定玩家的对话框标题栏贴图
-- 必须在本地判断内调用，防止 desync
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
--- 查询指定玩家的对话框是否正在显示
-- 调用方可用此函数决定是否允许再次触发对话（防止重复点击NPC）
function ____exports.isDialogActive(self, p)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return false
    end
    local state = g_states[pid + 1]
    if not state then
        return false
    end
    return state.isActive
end
--- 注册对话队列全部播完后的回调
-- 用于NPC交互逻辑在对话结束后重置自身的"对话中"状态锁
-- 每次对话结束后回调会自动清除，下次需要重新注册
-- 
-- @param p 目标玩家
-- @param callback 对话全部结束时调用
function ____exports.setDialogFinishCallback(self, p, callback)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    state.onFinish = callback
end
--- 为指定玩家显示任务对话框
-- 打字完成后显示【接受任务】【拒绝任务】按钮，等待玩家选择
-- 
-- @param p 目标玩家
-- @param title 说话人名字
-- @param text 任务描述文本
-- @param onAccept 点击接受任务的回调
-- @param onReject 点击拒绝任务的回调
function ____exports.displayQuest(self, p, title, text, onAccept, onReject)
    local pid = dzGetPlayerId(nil, p)
    if pid < 0 or pid >= MAX_PLAYERS then
        return
    end
    local state = ensureState(nil, pid)
    local entry = {
        title = title,
        text = text,
        waitTime = 0,
        leftTex = "",
        midTex = "",
        rightTex = "",
        titleFontSize = DEFAULT_TITLE_FONT_SIZE,
        bodyFontSize = DEFAULT_BODY_FONT_SIZE,
        isQuest = true,
        questCallbacks = {onAccept = onAccept, onReject = onReject}
    }
    local wasEmpty = #state.queue == 0
    local ____state_queue_6 = state.queue
    ____state_queue_6[#____state_queue_6 + 1] = entry
    if wasEmpty then
        playEntry(nil, state)
    end
end
return ____exports
