--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.09．表现系统.01．UI工具.index")
local createFrame = ____index.createFrame
local FrameType = ____index.FrameType
local ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001 = require("系统.09．表现系统.02．对话框系统.17．对话框渲染-Dz与状态")
local DEFAULT_BG_TEX = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_BG_TEX
local DEFAULT_BODY_FONT_SIZE = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_BODY_FONT_SIZE
local DEFAULT_FONT = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_FONT
local DEFAULT_TITLE_FONT_SIZE = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_TITLE_FONT_SIZE
local DEFAULT_TITLE_TEX = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.DEFAULT_TITLE_TEX
local dzClearPoints = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzClearPoints
local dzCreate = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzCreate
local dzSetAbsPoint = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetAbsPoint
local dzSetAlpha = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetAlpha
local dzSetEnable = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetEnable
local dzSetFont = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetFont
local dzSetPriority = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetPriority
local dzSetSize = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetSize
local dzSetText = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetText
local dzSetTexture = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzSetTexture
local dzShow = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.dzShow
local TAG_BASE_MAIN = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.TAG_BASE_MAIN
local TAG_BASE_PORTRAIT = ____17_FF0E_5BF9_8BDD_6846_6E32_67D3_2DDz_4E0E_72B6_6001.TAG_BASE_PORTRAIT
local japi = require("jass.japi")
--- 由「任务回调与命中」模块在加载末尾注入，避免 createDialogFrames ↔ dialogPanelHitCallback 循环依赖
local g_bindDialogPanelHitFrame
function ____exports.setDialogPanelHitBinder(self, fn)
    g_bindDialogPanelHitFrame = fn
end
local function bindDialogPanelHitFrame(self, hitFrame)
    if g_bindDialogPanelHitFrame then
        g_bindDialogPanelHitFrame(nil, hitFrame)
    end
end
function ____exports.createDialogFrames(self)
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
    local gameUI = japi.DzGetGameUI()
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
        pcall(function () return japi.DzFrameSetParent(bgBtn, bg) end
        )
        pcall(function () return japi.DzFrameClearAllPoints(bgBtn) end
        )
        pcall(function () return japi.DzFrameSetAllPoints(bgBtn, bg) end
        )
        japi.DzFrameSetText(bgBtn, "")
        pcall(function () return japi.DzFrameSetAlpha(bgBtn, 0) end
        )
    end
    bindDialogPanelHitFrame(nil, bgBtn)
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
    if nameText ~= 0 then
        pcall(function () return japi.DzFrameSetAllPoints(nameText, titleBg) end
        )
    end
    dzSetText(nil, nameText, "")
    dzSetFont(nil, nameText, DEFAULT_FONT, DEFAULT_TITLE_FONT_SIZE)
    dzSetEnable(nil, nameText, false)
    if nameText ~= 0 then
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
    if acceptBg ~= 0 then
        japi.DzFrameSetAbsolutePoint(acceptBg, 4, 0.311, 0.18)
    end
    if acceptBg ~= 0 then
        japi.DzFrameSetSize(acceptBg, 0.08, 0.022)
    end
    if acceptBg ~= 0 then
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
    if acceptLabel ~= 0 then
        japi.DzFrameSetAllPoints(acceptLabel, acceptBg)
    end
    if acceptLabel ~= 0 then
        japi.DzFrameSetText(acceptLabel, "接受任务")
    end
    if acceptLabel ~= 0 then
        japi.DzFrameSetTextColor(
            acceptLabel,
            255,
            255,
            255,
            255
        )
    end
    if acceptLabel ~= 0 then
        japi.DzFrameSetFont(acceptLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0)
    end
    if acceptLabel ~= 0 then
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
    if acceptBtn ~= 0 then
        japi.DzFrameSetAllPoints(acceptBtn, acceptBg)
    end
    if acceptBtn ~= 0 then
        japi.DzFrameSetAlpha(acceptBtn, 0)
    end
    if acceptBtn ~= 0 then
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
    if rejectBg ~= 0 then
        japi.DzFrameSetAbsolutePoint(rejectBg, 4, 0.406, 0.18)
    end
    if rejectBg ~= 0 then
        japi.DzFrameSetSize(rejectBg, 0.08, 0.022)
    end
    if rejectBg ~= 0 then
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
    if rejectLabel ~= 0 then
        japi.DzFrameSetAllPoints(rejectLabel, rejectBg)
    end
    if rejectLabel ~= 0 then
        japi.DzFrameSetText(rejectLabel, "拒绝任务")
    end
    if rejectLabel ~= 0 then
        japi.DzFrameSetTextColor(
            rejectLabel,
            255,
            255,
            255,
            255
        )
    end
    if rejectLabel ~= 0 then
        japi.DzFrameSetFont(rejectLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0)
    end
    if rejectLabel ~= 0 then
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
    if rejectBtn ~= 0 then
        japi.DzFrameSetAllPoints(rejectBtn, rejectBg)
    end
    if rejectBtn ~= 0 then
        japi.DzFrameSetAlpha(rejectBtn, 0)
    end
    if rejectBtn ~= 0 then
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
        pcall(function () return japi.DzFrameSetPoint(
                hintLabel,
                8,
                bg,
                8,
                -0.008,
                0.008
            ) end
        )
        japi.DzFrameSetSize(hintLabel, 0.12, 0.018)
        japi.DzFrameSetText(hintLabel, "|cff333333[点击以继续] ↓|r")
        japi.DzFrameSetFont(hintLabel, DEFAULT_FONT, 0.016, 0)
        japi.DzFrameSetTextAlignment(hintLabel, -1)
        japi.DzFrameSetTextAlignment(hintLabel, 5)
    end
    local skipHintLabel = createFrame(nil, {
        type = FrameType.TEXT,
        name = "DialogSkipHint",
        parent = gameUI,
        template = "template",
        visible = false
    }) or 0
    frames[13] = skipHintLabel
    if skipHintLabel ~= 0 then
        pcall(function () return japi.DzFrameSetPoint(
                skipHintLabel,
                0,
                titleBg,
                2,
                0.005,
                -0.022
            ) end
        )
        japi.DzFrameSetSize(skipHintLabel, 0.12, 0.018)
        japi.DzFrameSetText(skipHintLabel, "|cff333333按下 ~ 键跳过对话|r")
        japi.DzFrameSetFont(skipHintLabel, DEFAULT_FONT, 0.012, 0)
        japi.DzFrameSetTextAlignment(skipHintLabel, -1)
        japi.DzFrameSetTextAlignment(skipHintLabel, 4)
    end
    bindDialogPanelHitFrame(nil, nameText)
    bindDialogPanelHitFrame(nil, bodyText)
    bindDialogPanelHitFrame(nil, hintLabel)
    bindDialogPanelHitFrame(nil, skipHintLabel)
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
    dzSetPriority(nil, frames[13], p)
    dzSetPriority(nil, frames[102], p)
    dzSetPriority(nil, frames[103], p)
    dzSetPriority(nil, frames[104], p)
    return frames
end
return ____exports
