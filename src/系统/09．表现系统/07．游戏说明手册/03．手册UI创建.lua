--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.07．游戏说明手册.00．常量定义")
local FRAME_POINT_BOTTOMRIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.FRAME_POINT_BOTTOMRIGHT
local FRAME_POINT_CENTER = ____00_FF0E_5E38_91CF_5B9A_4E49.FRAME_POINT_CENTER
local FRAME_POINT_TOPLEFT = ____00_FF0E_5E38_91CF_5B9A_4E49.FRAME_POINT_TOPLEFT
local MANUAL_BASE_PRIORITY = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_BASE_PRIORITY
local MANUAL_BODY_FONT_SIZE = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_BODY_FONT_SIZE
local MANUAL_BODY_PRIORITY = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_BODY_PRIORITY
local MANUAL_BODY_TEXT_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_BODY_TEXT_HEIGHT
local MANUAL_BODY_TEXT_OFFSET_X = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_BODY_TEXT_OFFSET_X
local MANUAL_BODY_TEXT_OFFSET_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_BODY_TEXT_OFFSET_Y
local MANUAL_BODY_TEXT_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_BODY_TEXT_WIDTH
local MANUAL_CENTER_X = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_CENTER_X
local MANUAL_CENTER_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_CENTER_Y
local MANUAL_CLOSE_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_CLOSE_HEIGHT
local MANUAL_CLOSE_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_CLOSE_WIDTH
local MANUAL_FLIP_PRIORITY_START = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_FLIP_PRIORITY_START
local MANUAL_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_HEIGHT
local MANUAL_HOTSPOT_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_HOTSPOT_HEIGHT
local MANUAL_HOTSPOT_PRIORITY = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_HOTSPOT_PRIORITY
local MANUAL_HOTSPOT_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_HOTSPOT_WIDTH
local MANUAL_INDICATOR_PRIORITY = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_INDICATOR_PRIORITY
local MANUAL_TITLE_FONT_SIZE = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_TITLE_FONT_SIZE
local MANUAL_TITLE_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_TITLE_HEIGHT
local MANUAL_TITLE_OFFSET_X = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_TITLE_OFFSET_X
local MANUAL_TITLE_OFFSET_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_TITLE_OFFSET_Y
local MANUAL_TITLE_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_TITLE_WIDTH
local MANUAL_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_WIDTH
local MANUAL_FONT = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_FONT
local ____01_FF0E_8D44_6E90_5B9A_4E49 = require("系统.09．表现系统.07．游戏说明手册.01．资源定义")
local MANUAL_BASE_TEXTURE = ____01_FF0E_8D44_6E90_5B9A_4E49.MANUAL_BASE_TEXTURE
local MANUAL_FLIP_TEXTURES = ____01_FF0E_8D44_6E90_5B9A_4E49.MANUAL_FLIP_TEXTURES
local MANUAL_INDICATOR_TEXTURE = ____01_FF0E_8D44_6E90_5B9A_4E49.MANUAL_INDICATOR_TEXTURE
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetAlpha = japi.DzFrameSetAlpha
local DzFrameShow = japi.DzFrameShow
local function _____6709_6548_5E27(frame)
    return frame ~= nil and frame ~= 0
end
local function _____521B_5EFA_80CC_666F_5E27(name, texture, priority)
    local parent = DzGetGameUI()
    if not _____6709_6548_5E27(parent) then
        return 0
    end
    local frame = DzCreateFrameByTagName(
        "BACKDROP",
        name,
        parent,
        "template",
        0
    )
    if not _____6709_6548_5E27(frame) then
        return 0
    end
    DzFrameSetSize(frame, MANUAL_WIDTH, MANUAL_HEIGHT)
    DzFrameSetAbsolutePoint(frame, FRAME_POINT_CENTER, MANUAL_CENTER_X, MANUAL_CENTER_Y)
    DzFrameSetTexture(frame, texture, 0)
    DzFrameSetPriority(frame, priority)
    return frame
end
local function _____521B_5EFA_6587_672C_5E27(name, baseFrame, width, height, x, y, fontSize, priority)
    if not _____6709_6548_5E27(baseFrame) then
        return 0
    end
    local frame = DzCreateFrameByTagName(
        "TEXT",
        name,
        baseFrame,
        "template",
        0
    )
    if not _____6709_6548_5E27(frame) then
        return 0
    end
    DzFrameSetSize(frame, width, height)
    DzFrameSetPoint(
        frame,
        FRAME_POINT_TOPLEFT,
        baseFrame,
        FRAME_POINT_TOPLEFT,
        x,
        y
    )
    DzFrameSetTextAlignment(frame, -1)
    DzFrameSetTextAlignment(frame, 0)
    DzFrameSetFont(frame, MANUAL_FONT, fontSize, 0)
    DzFrameSetTextColor(
        frame,
        80,
        48,
        24,
        255
    )
    DzFrameSetPriority(frame, priority)
    return frame
end
local function _____521B_5EFA_6309_94AE_70ED_533A(name, baseFrame, width, height, x, y)
    local parent = DzGetGameUI()
    if not _____6709_6548_5E27(parent) or not _____6709_6548_5E27(baseFrame) then
        return 0
    end
    local frame = DzCreateFrameByTagName(
        "GLUETEXTBUTTON",
        name,
        parent,
        "template",
        0
    )
    if not _____6709_6548_5E27(frame) then
        return 0
    end
    DzFrameSetSize(frame, width, height)
    DzFrameSetPoint(
        frame,
        FRAME_POINT_BOTTOMRIGHT,
        baseFrame,
        FRAME_POINT_BOTTOMRIGHT,
        x,
        y
    )
    DzFrameSetText(frame, "")
    DzFrameSetAlpha(frame, 0)
    DzFrameSetPriority(frame, MANUAL_HOTSPOT_PRIORITY)
    return frame
end
local function _____521B_5EFA_63D0_793A_6587_672C(nextHotspot)
    local parent = DzGetGameUI()
    if not _____6709_6548_5E27(parent) or not _____6709_6548_5E27(nextHotspot) then
        return 0
    end
    local frame = DzCreateFrameByTagName(
        "TEXT",
        "GameManualHintText",
        parent,
        "template",
        0
    )
    if not _____6709_6548_5E27(frame) then
        return 0
    end
    DzFrameSetSize(frame, MANUAL_HOTSPOT_WIDTH, MANUAL_HOTSPOT_HEIGHT)
    DzFrameSetPoint(
        frame,
        FRAME_POINT_CENTER,
        nextHotspot,
        FRAME_POINT_CENTER,
        0,
        0
    )
    DzFrameSetTextAlignment(frame, -1)
    DzFrameSetTextAlignment(frame, 18)
    DzFrameSetTextColor(
        frame,
        201,
        160,
        103,
        255
    )
    DzFrameSetPriority(frame, MANUAL_HOTSPOT_PRIORITY - 1)
    return frame
end
____exports["创建游戏说明手册UI"] = function()
    local base = _____521B_5EFA_80CC_666F_5E27("GameManualBase", MANUAL_BASE_TEXTURE, MANUAL_BASE_PRIORITY)
    local indicator = _____521B_5EFA_80CC_666F_5E27("GameManualIndicator", MANUAL_INDICATOR_TEXTURE, MANUAL_INDICATOR_PRIORITY)
    local overlays = {}
    local overlayTitleTexts = {}
    local overlayBodyTexts = {}
    do
        local i = 0
        while i < #MANUAL_FLIP_TEXTURES do
            local frame = _____521B_5EFA_80CC_666F_5E27(
                "GameManualFlipOverlay" .. tostring(i + 1),
                MANUAL_FLIP_TEXTURES[i + 1],
                MANUAL_FLIP_PRIORITY_START + i
            )
            if _____6709_6548_5E27(frame) then
                local overlayTitleText = i == 0 and _____521B_5EFA_6587_672C_5E27(
                    "GameManualOverlayTitleText1",
                    frame,
                    MANUAL_TITLE_WIDTH,
                    MANUAL_TITLE_HEIGHT,
                    MANUAL_TITLE_OFFSET_X,
                    MANUAL_TITLE_OFFSET_Y,
                    MANUAL_TITLE_FONT_SIZE,
                    MANUAL_BODY_PRIORITY
                ) or 0
                local overlayBodyText = i == 0 and _____521B_5EFA_6587_672C_5E27(
                    "GameManualOverlayBodyText1",
                    frame,
                    MANUAL_BODY_TEXT_WIDTH,
                    MANUAL_BODY_TEXT_HEIGHT,
                    MANUAL_BODY_TEXT_OFFSET_X,
                    MANUAL_BODY_TEXT_OFFSET_Y,
                    MANUAL_BODY_FONT_SIZE,
                    MANUAL_BODY_PRIORITY
                ) or 0
                overlayTitleTexts[#overlayTitleTexts + 1] = overlayTitleText
                overlayBodyTexts[#overlayBodyTexts + 1] = overlayBodyText
                DzFrameShow(frame, false)
                overlays[#overlays + 1] = frame
            end
            i = i + 1
        end
    end
    local titleText = _____521B_5EFA_6587_672C_5E27(
        "GameManualTitleText",
        base,
        MANUAL_TITLE_WIDTH,
        MANUAL_TITLE_HEIGHT,
        MANUAL_TITLE_OFFSET_X,
        MANUAL_TITLE_OFFSET_Y,
        MANUAL_TITLE_FONT_SIZE,
        MANUAL_BODY_PRIORITY
    )
    local bodyText = _____521B_5EFA_6587_672C_5E27(
        "GameManualBodyText",
        base,
        MANUAL_BODY_TEXT_WIDTH,
        MANUAL_BODY_TEXT_HEIGHT,
        MANUAL_BODY_TEXT_OFFSET_X,
        MANUAL_BODY_TEXT_OFFSET_Y,
        MANUAL_BODY_FONT_SIZE,
        MANUAL_BODY_PRIORITY
    )
    local nextHotspot = _____521B_5EFA_6309_94AE_70ED_533A(
        "GameManualNextHotspot",
        base,
        MANUAL_HOTSPOT_WIDTH,
        MANUAL_HOTSPOT_HEIGHT,
        0,
        0
    )
    local closeHotspot = _____521B_5EFA_6309_94AE_70ED_533A(
        "GameManualCloseHotspot",
        base,
        MANUAL_CLOSE_WIDTH,
        MANUAL_CLOSE_HEIGHT,
        -0.018,
        -0.018
    )
    local hintText = _____521B_5EFA_63D0_793A_6587_672C(nextHotspot)
    if _____6709_6548_5E27(indicator) then
        DzFrameShow(indicator, false)
    end
    if _____6709_6548_5E27(hintText) then
        DzFrameSetText(hintText, "翻页")
        DzFrameShow(hintText, false)
    end
    return {
        base = base,
        indicator = indicator,
        overlays = overlays,
        overlayTitleTexts = overlayTitleTexts,
        overlayBodyTexts = overlayBodyTexts,
        nextHotspot = nextHotspot,
        closeHotspot = closeHotspot,
        titleText = titleText,
        bodyText = bodyText,
        hintText = hintText
    }
end
____exports["设置手册帧显示"] = function(ui, visible)
    if _____6709_6548_5E27(ui.base) then
        DzFrameShow(ui.base, visible)
    end
    if _____6709_6548_5E27(ui.nextHotspot) then
        DzFrameShow(ui.nextHotspot, visible)
    end
    if _____6709_6548_5E27(ui.closeHotspot) then
        DzFrameShow(ui.closeHotspot, visible)
    end
    if _____6709_6548_5E27(ui.titleText) then
        DzFrameShow(ui.titleText, visible)
    end
    if _____6709_6548_5E27(ui.bodyText) then
        DzFrameShow(ui.bodyText, visible)
    end
    if _____6709_6548_5E27(ui.hintText) then
        DzFrameShow(ui.hintText, false)
    end
    if _____6709_6548_5E27(ui.indicator) then
        DzFrameShow(ui.indicator, false)
    end
    do
        local i = 0
        while i < #ui.overlays do
            DzFrameShow(ui.overlays[i + 1], false)
            i = i + 1
        end
    end
end
return ____exports
