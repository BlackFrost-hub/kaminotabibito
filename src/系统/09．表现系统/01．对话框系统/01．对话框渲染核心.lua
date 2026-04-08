--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0EUI_5DE5_5177 = require("系统.09．表现系统.01．UI工具")
local createFrame = ____01_FF0EUI_5DE5_5177.createFrame
local FrameType = ____01_FF0EUI_5DE5_5177.FrameType
local ____04_FF0E_786C_4EF6_51FD_6570 = require("系统.00．核心系统.04．硬件函数")
local frameSetScriptByCode = ____04_FF0E_786C_4EF6_51FD_6570.frameSetScriptByCode
local ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60 = require("系统.09．表现系统.04．NPC对话状态池")
local destroyBubbleEffect = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.destroyBubbleEffect
local releaseNpcOccupation = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.releaseNpcOccupation
local getActivePlayerId = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.getActivePlayerId
local resetActivePlayerIdIfMatch = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.resetActivePlayerIdIfMatch
local triggerFinishCallback = ____04_FF0ENPC_5BF9_8BDD_72B6_6001_6C60.triggerFinishCallback
--- 对话框渲染核心
-- 负责DzAPI封装、帧创建、显示控制
local japi = require("jass.japi")
local jass = require("jass.common")
--- 最大支持玩家数
____exports.MAX_PLAYERS = 28
--- TOC 加载路径
local TOC_PATH = "ui\\StarGameUI.toc"
--- 对话框帧标签起始 ID
____exports.TAG_BASE_MAIN = 1024
____exports.TAG_BASE_PORTRAIT = 1125
--- 默认字体路径
____exports.DEFAULT_FONT = "UI\\uizt.ttf"
--- 默认标题字体大小
____exports.DEFAULT_TITLE_FONT_SIZE = 0.018
--- 默认正文字体大小
____exports.DEFAULT_BODY_FONT_SIZE = 0.012
--- 默认背景贴图
____exports.DEFAULT_BG_TEX = "UI\\wenbenkuang.blp"
--- 默认标题栏贴图
____exports.DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp"
--- 对话框首次展开时的提示音效
____exports.DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav"
function ____exports.dzShow(self, f, b)
    if f and f ~= 0 and type(japi.DzFrameShow) == "function" then
        japi.DzFrameShow(f, b)
    end
end
function ____exports.dzSetText(self, f, s)
    if f and f ~= 0 and type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(f, s)
    end
end
function ____exports.dzSetTexture(self, f, path)
    if f and f ~= 0 and type(japi.DzFrameSetTexture) == "function" then
        japi.DzFrameSetTexture(f, path, 0)
    end
end
function ____exports.dzSetAlpha(self, f, a)
    if f and f ~= 0 and type(japi.DzFrameSetAlpha) == "function" then
        japi.DzFrameSetAlpha(f, a)
    end
end
function ____exports.dzSetAbsPoint(self, f, point, x, y)
    if f and f ~= 0 and type(japi.DzFrameSetAbsolutePoint) == "function" then
        japi.DzFrameSetAbsolutePoint(f, point, x, y)
    end
end
function ____exports.dzSetSize(self, f, w, h)
    if f and f ~= 0 and type(japi.DzFrameSetSize) == "function" then
        japi.DzFrameSetSize(f, w, h)
    end
end
function ____exports.dzClearPoints(self, f)
    if f and f ~= 0 and type(japi.DzFrameClearAllPoints) == "function" then
        japi.DzFrameClearAllPoints(f)
    end
end
function ____exports.dzSetEnable(self, f, b)
    if f and f ~= 0 and type(japi.DzFrameSetEnable) == "function" then
        japi.DzFrameSetEnable(f, b)
    end
end
function ____exports.dzSetFont(self, f, font, size)
    if f and f ~= 0 and type(japi.DzFrameSetFont) == "function" then
        japi.DzFrameSetFont(f, font, size, 0)
    end
end
function ____exports.dzCreate(self, template, tag)
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
function ____exports.dzSubString(self, s, start, ____end)
    if type(jass.SubString) == "function" then
        return jass.SubString(s, start, ____end)
    end
    return s:sub(start + 1, ____end)
end
function ____exports.dzStringLength(self, s)
    if type(jass.StringLength) == "function" then
        return jass.StringLength(s)
    end
    return #s
end
function ____exports.dzGetLocalPlayer(self)
    local ____temp_1
    if type(jass.GetLocalPlayer) == "function" then
        ____temp_1 = jass.GetLocalPlayer()
    else
        ____temp_1 = nil
    end
    return ____temp_1
end
function ____exports.dzGetPlayerId(self, p)
    return type(jass.GetPlayerId) == "function" and jass.GetPlayerId(p) or -1
end
function ____exports.dzPlayer(self, index)
    local ____temp_2
    if type(jass.Player) == "function" then
        ____temp_2 = jass.Player(index)
    else
        ____temp_2 = nil
    end
    return ____temp_2
end
function ____exports.dzTimerCreate(self)
    local ____temp_3
    if type(jass.CreateTimer) == "function" then
        ____temp_3 = jass.CreateTimer()
    else
        ____temp_3 = nil
    end
    return ____temp_3
end
function ____exports.dzTimerStart(self, t, timeout, periodic, cb)
    if t and type(jass.TimerStart) == "function" then
        jass.TimerStart(t, timeout, periodic, cb)
    end
end
function ____exports.dzTimerPause(self, t)
    if t and type(jass.PauseTimer) == "function" then
        jass.PauseTimer(t)
    end
end
local function dzLoadToc(self)
    if type(japi.DzLoadToc) == "function" then
        japi.DzLoadToc(TOC_PATH)
    end
end
--- TOC 是否已加载过（全局只需一次）
local g_tocLoaded = false
function ____exports.dzLoadTocOnce(self)
    if g_tocLoaded then
        return
    end
    g_tocLoaded = true
    dzLoadToc(nil)
end
local g_states = {}
function ____exports.getState(self, playerId)
    return g_states[playerId + 1]
end
function ____exports.ensureState(self, playerId)
    if g_states[playerId + 1] then
        return g_states[playerId + 1]
    end
    local state = {
        playerId = playerId,
        queue = {},
        tickTimer = ____exports.dzTimerCreate(nil),
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
function ____exports.initAllStates(self)
    do
        local i = 0
        while i < ____exports.MAX_PLAYERS do
            ____exports.ensureState(nil, i)
            i = i + 1
        end
    end
end
--- 为指定玩家创建对话框帧（只有本地玩家才真正执行创建）
-- 返回帧数组（非本地玩家返回全0数组，避免 desync）
function ____exports.createDialogFrames(self, onBgClick)
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
    local ____temp_4
    if type(japi.DzGetGameUI) == "function" then
        ____temp_4 = japi.DzGetGameUI()
    else
        ____temp_4 = 0
    end
    local gameUI = ____temp_4
    local portraits = {{idx = 101, tag = ____exports.TAG_BASE_PORTRAIT, x = 0.24, y = 0.1421 + 0.2}, {idx = 102, tag = ____exports.TAG_BASE_PORTRAIT + 1, x = 0.24 + 0.377 / 3, y = 0.1421 + 0.2}, {idx = 103, tag = ____exports.TAG_BASE_PORTRAIT + 2, x = 0.24 + 0.377 / 1.5, y = 0.1421 + 0.2}}
    for ____, p in ipairs(portraits) do
        local f = ____exports.dzCreate(nil, "GameUI", p.tag)
        frames[p.idx + 1] = f
        ____exports.dzShow(nil, f, false)
        ____exports.dzClearPoints(nil, f)
        ____exports.dzSetAbsPoint(
            nil,
            f,
            3,
            p.x,
            p.y
        )
        ____exports.dzSetSize(nil, f, 0.367 / 3, 0.231)
        ____exports.dzSetAlpha(nil, f, 255)
        ____exports.dzSetTexture(nil, f, "")
    end
    local bg = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = "DialogBG",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[1] = bg
    ____exports.dzClearPoints(nil, bg)
    ____exports.dzSetAbsPoint(
        nil,
        bg,
        3,
        0.23,
        0.2421
    )
    ____exports.dzSetSize(nil, bg, 0.377, 0.131)
    ____exports.dzSetAlpha(nil, bg, 255)
    ____exports.dzSetTexture(nil, bg, ____exports.DEFAULT_BG_TEX)
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
            local pid = getActivePlayerId(nil)
            if pid < 0 or pid >= ____exports.MAX_PLAYERS then
                return
            end
            local s = g_states[pid + 1]
            if not s then
                return
            end
            onBgClick(nil, s)
        end,
        true
    )
    local titleBg = ____exports.dzCreate(nil, "GameUI", ____exports.TAG_BASE_MAIN + 2)
    frames[2] = titleBg
    ____exports.dzShow(nil, titleBg, false)
    ____exports.dzClearPoints(nil, titleBg)
    ____exports.dzSetAbsPoint(
        nil,
        titleBg,
        3,
        0.24,
        0.3083
    )
    ____exports.dzSetSize(nil, titleBg, 0.107, 0.0328)
    ____exports.dzSetAlpha(nil, titleBg, 255)
    ____exports.dzSetTexture(nil, titleBg, ____exports.DEFAULT_TITLE_TEX)
    local nameText = ____exports.dzCreate(nil, "GameText", ____exports.TAG_BASE_MAIN + 3)
    frames[3] = nameText
    ____exports.dzShow(nil, nameText, false)
    ____exports.dzClearPoints(nil, nameText)
    if nameText ~= 0 and type(japi.DzFrameSetAllPoints) == "function" then
        pcall(function () return japi.DzFrameSetAllPoints(nameText, titleBg) end
        )
    end
    ____exports.dzSetText(nil, nameText, "")
    ____exports.dzSetFont(nil, nameText, ____exports.DEFAULT_FONT, ____exports.DEFAULT_TITLE_FONT_SIZE)
    ____exports.dzSetEnable(nil, nameText, false)
    if nameText ~= 0 and type(japi.DzFrameSetTextAlignment) == "function" then
        pcall(function ()
                japi.DzFrameSetTextAlignment(nameText, -1)
                japi.DzFrameSetTextAlignment(nameText, 18)
            end
        )
    end
    local bodyText = ____exports.dzCreate(nil, "GameTextpxL", ____exports.TAG_BASE_MAIN + 4)
    frames[4] = bodyText
    ____exports.dzShow(nil, bodyText, false)
    ____exports.dzClearPoints(nil, bodyText)
    ____exports.dzSetAbsPoint(
        nil,
        bodyText,
        0,
        0.24,
        0.28
    )
    ____exports.dzSetSize(nil, bodyText, 0.35, 0.22)
    ____exports.dzSetText(nil, bodyText, "")
    ____exports.dzSetFont(nil, bodyText, ____exports.DEFAULT_FONT, ____exports.DEFAULT_BODY_FONT_SIZE)
    ____exports.dzSetEnable(nil, bodyText, false)
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
        japi.DzFrameSetFont(acceptLabel, ____exports.DEFAULT_FONT, ____exports.DEFAULT_BODY_FONT_SIZE, 0)
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
        japi.DzFrameSetFont(rejectLabel, ____exports.DEFAULT_FONT, ____exports.DEFAULT_BODY_FONT_SIZE, 0)
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
            japi.DzFrameSetFont(hintLabel, ____exports.DEFAULT_FONT, 0.016, 0)
        end
        if type(japi.DzFrameSetTextAlignment) == "function" then
            japi.DzFrameSetTextAlignment(hintLabel, -1)
            japi.DzFrameSetTextAlignment(hintLabel, 5)
        end
    end
    return frames
end
function ____exports.showDialogFrames(self, state, visible)
    local localPlayer = ____exports.dzGetLocalPlayer(nil)
    local targetPlayer = ____exports.dzPlayer(nil, state.playerId)
    if localPlayer ~= targetPlayer then
        return
    end
    if not state.canShow then
        do
            local i = 0
            while i < 9 do
                ____exports.dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
        do
            local i = 101
            while i < 104 do
                ____exports.dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
        return
    end
    do
        local i = 0
        while i < 5 do
            ____exports.dzShow(nil, state.frames[i + 1], visible)
            i = i + 1
        end
    end
    if not visible then
        do
            local i = 5
            while i <= 11 do
                ____exports.dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
    end
    if visible then
        ____exports.dzSetAlpha(nil, state.frames[1], 155)
    end
    do
        local i = 101
        while i < 104 do
            ____exports.dzShow(nil, state.frames[i + 1], visible)
            i = i + 1
        end
    end
end
function ____exports.onDialogEnd(self, playerId)
    local state = g_states[playerId + 1]
    if not state then
        return
    end
    resetActivePlayerIdIfMatch(nil, playerId)
    destroyBubbleEffect(nil, playerId)
    releaseNpcOccupation(nil, playerId)
    local localPlayer = ____exports.dzGetLocalPlayer(nil)
    local targetPlayer = ____exports.dzPlayer(nil, playerId)
    local isLocal = localPlayer == targetPlayer
    if isLocal and state.initialized then
        do
            local i = 0
            while i <= 11 do
                ____exports.dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
        do
            local i = 101
            while i < 104 do
                ____exports.dzShow(nil, state.frames[i + 1], false)
                i = i + 1
            end
        end
    end
    state.isActive = false
    state.waitingClick = false
    state.clickCooldown = false
    triggerFinishCallback(nil, playerId)
end
function ____exports.clearState(self, state)
    ____exports.dzTimerPause(nil, state.tickTimer)
    state.queue = {}
    ____exports.onDialogEnd(nil, state.playerId)
end
return ____exports
