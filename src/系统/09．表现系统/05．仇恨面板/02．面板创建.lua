--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.05．仇恨面板.00．常量定义")
local THREAT_PANEL_BODY_FONT = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_BODY_FONT
local THREAT_PANEL_BODY_SIZE = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_BODY_SIZE
local THREAT_PANEL_BG_TEXTURE = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_BG_TEXTURE
local THREAT_PANEL_FDF_FRAME = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_FDF_FRAME
local THREAT_PANEL_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_HEIGHT
local THREAT_PANEL_HEADER_OFFSET_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_HEADER_OFFSET_Y
local THREAT_PANEL_INNER_ALPHA = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_INNER_ALPHA
local THREAT_PANEL_INNER_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_INNER_HEIGHT
local THREAT_PANEL_INNER_OFFSET_X = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_INNER_OFFSET_X
local THREAT_PANEL_INNER_OFFSET_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_INNER_OFFSET_Y
local THREAT_PANEL_INNER_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_INNER_WIDTH
local THREAT_PANEL_NAME_COL_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_NAME_COL_WIDTH
local THREAT_PANEL_NAME_COL_X = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_NAME_COL_X
local THREAT_PANEL_PERCENT_COL_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PERCENT_COL_WIDTH
local THREAT_PANEL_PERCENT_COL_X = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PERCENT_COL_X
local THREAT_PANEL_PLAYER_SLOTS = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PLAYER_SLOTS
local THREAT_PANEL_PRIORITY = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_PRIORITY
local THREAT_PANEL_ROW_COUNT = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_ROW_COUNT
local THREAT_PANEL_ROW_GAP = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_ROW_GAP
local THREAT_PANEL_ROW_START_OFFSET_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_ROW_START_OFFSET_Y
local THREAT_PANEL_SELECTED_OFFSET_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_SELECTED_OFFSET_Y
local THREAT_PANEL_SUMMARY_OFFSET_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_SUMMARY_OFFSET_Y
local THREAT_PANEL_TEXT_HEIGHT = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TEXT_HEIGHT
local THREAT_PANEL_TEXT_OFFSET_X = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TEXT_OFFSET_X
local THREAT_PANEL_TEXT_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TEXT_WIDTH
local THREAT_PANEL_THREAT_COL_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_THREAT_COL_WIDTH
local THREAT_PANEL_THREAT_COL_X = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_THREAT_COL_X
local THREAT_PANEL_TITLE = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TITLE
local THREAT_PANEL_TITLE_FONT = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TITLE_FONT
local THREAT_PANEL_TITLE_OFFSET_X = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TITLE_OFFSET_X
local THREAT_PANEL_TITLE_OFFSET_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TITLE_OFFSET_Y
local THREAT_PANEL_TITLE_SIZE = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TITLE_SIZE
local THREAT_PANEL_TITLE_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TITLE_WIDTH
local THREAT_PANEL_TOC_PATH = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_TOC_PATH
local THREAT_PANEL_WIDTH = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_WIDTH
local THREAT_PANEL_X = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_X
local THREAT_PANEL_Y = ____00_FF0E_5E38_91CF_5B9A_4E49.THREAT_PANEL_Y
local ____01_FF0E_5171_4EAB = require("系统.09．表现系统.05．仇恨面板.01．共享")
local DzCreateFrame = ____01_FF0E_5171_4EAB.DzCreateFrame
local DzCreateFrameByTagName = ____01_FF0E_5171_4EAB.DzCreateFrameByTagName
local DzFrameSetAbsolutePoint = ____01_FF0E_5171_4EAB.DzFrameSetAbsolutePoint
local DzFrameSetFont = ____01_FF0E_5171_4EAB.DzFrameSetFont
local DzFrameSetPriority = ____01_FF0E_5171_4EAB.DzFrameSetPriority
local DzFrameSetSize = ____01_FF0E_5171_4EAB.DzFrameSetSize
local DzFrameSetTexture = ____01_FF0E_5171_4EAB.DzFrameSetTexture
local DzFrameSetAlpha = ____01_FF0E_5171_4EAB.DzFrameSetAlpha
local DzFrameSetText = ____01_FF0E_5171_4EAB.DzFrameSetText
local DzFrameSetTextAlignment = ____01_FF0E_5171_4EAB.DzFrameSetTextAlignment
local DzFrameShow = ____01_FF0E_5171_4EAB.DzFrameShow
local DzLoadToc = ____01_FF0E_5171_4EAB.DzLoadToc
local ABS_BOTTOMLEFT = ____01_FF0E_5171_4EAB.ABS_BOTTOMLEFT
local TEXT_ALIGN_CENTER = ____01_FF0E_5171_4EAB.TEXT_ALIGN_CENTER
local TEXT_ALIGN_LEFT = ____01_FF0E_5171_4EAB.TEXT_ALIGN_LEFT
local EMPTY_ROW = ____01_FF0E_5171_4EAB.EMPTY_ROW
local _____73A9_5BB6_9762_677F_8868 = ____01_FF0E_5171_4EAB["玩家面板表"]
local _____5DF2_52A0_8F7DToc = false
local _______5F85_52A0_8F7DToc_8DEF_5F84 = ""
local _______5F85_521B_5EFAFdf_540D_79F0 = ""
local _______5F85_521B_5EFAFdf_7236_7EA7 = 0
local _______5F85_521B_5EFAFdf_5B9E_4F8B = 0
local _______521B_5EFAFdf_7ED3_679C = 0
local function _______52A0_8F7DTocPcallBody(self)
    DzLoadToc(_______5F85_52A0_8F7DToc_8DEF_5F84)
end
local function _______521B_5EFAFdfPcallBody(self)
    _______521B_5EFAFdf_7ED3_679C = DzCreateFrame(_______5F85_521B_5EFAFdf_540D_79F0, _______5F85_521B_5EFAFdf_7236_7EA7, _______5F85_521B_5EFAFdf_5B9E_4F8B)
end
____exports["加载仇恨面板Toc"] = function()
    if _____5DF2_52A0_8F7DToc then
        return
    end
    _____5DF2_52A0_8F7DToc = true
    _______5F85_52A0_8F7DToc_8DEF_5F84 = THREAT_PANEL_TOC_PATH
    pcall(_______52A0_8F7DTocPcallBody)
end
local function _____521B_5EFAFdf_9762_677F(name, parent, instanceId, x, y, width, height, priority)
    _______5F85_521B_5EFAFdf_540D_79F0 = name
    _______5F85_521B_5EFAFdf_7236_7EA7 = parent
    _______5F85_521B_5EFAFdf_5B9E_4F8B = instanceId
    _______521B_5EFAFdf_7ED3_679C = 0
    local ok = pcall(_______521B_5EFAFdfPcallBody)
    local frame = _______521B_5EFAFdf_7ED3_679C
    if not ok or frame == 0 then
        return 0
    end
    DzFrameSetAbsolutePoint(frame, ABS_BOTTOMLEFT, x, y)
    DzFrameSetSize(frame, width, height)
    DzFrameSetPriority(frame, priority)
    DzFrameShow(frame, true)
    return frame
end
local function _____521B_5EFA_80CC_666F(name, parent, x, y, width, height, texture, alpha, priority)
    local frame = DzCreateFrameByTagName(
        "BACKDROP",
        name,
        parent,
        "template",
        0
    )
    if frame == 0 then
        return 0
    end
    DzFrameSetAbsolutePoint(frame, ABS_BOTTOMLEFT, x, y)
    DzFrameSetSize(frame, width, height)
    DzFrameSetTexture(frame, texture, 0)
    DzFrameSetAlpha(frame, alpha)
    DzFrameSetPriority(frame, priority)
    DzFrameShow(frame, true)
    return frame
end
local function _____521B_5EFA_6587_672C_5E26_5BF9_9F50(name, parent, x, y, text, font, size, priority, align, width, height)
    if width == nil then
        width = THREAT_PANEL_TEXT_WIDTH
    end
    if height == nil then
        height = THREAT_PANEL_TEXT_HEIGHT
    end
    local frame = DzCreateFrameByTagName(
        "TEXT",
        name,
        parent,
        "template",
        0
    )
    if frame == 0 then
        return 0
    end
    DzFrameSetAbsolutePoint(frame, ABS_BOTTOMLEFT, x, y)
    DzFrameSetSize(frame, width, height)
    DzFrameSetText(frame, text)
    DzFrameSetFont(frame, font, size, 0)
    DzFrameSetTextAlignment(frame, -1)
    DzFrameSetTextAlignment(frame, align)
    DzFrameSetPriority(frame, priority)
    DzFrameShow(frame, true)
    return frame
end
local function _____521B_5EFA_6587_672C(name, parent, x, y, text, font, size, priority, align, width, height)
    if align == nil then
        align = TEXT_ALIGN_CENTER
    end
    if width == nil then
        width = THREAT_PANEL_TEXT_WIDTH
    end
    if height == nil then
        height = THREAT_PANEL_TEXT_HEIGHT
    end
    return _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
        name,
        parent,
        x,
        y,
        text,
        font,
        size,
        priority,
        align,
        width,
        height
    )
end
local function _____521B_5EFA_5355_73A9_5BB6_9762_677F(playerId, gameUI)
    local root = _____521B_5EFAFdf_9762_677F(
        THREAT_PANEL_FDF_FRAME,
        gameUI,
        playerId + 1,
        THREAT_PANEL_X,
        THREAT_PANEL_Y,
        THREAT_PANEL_WIDTH,
        THREAT_PANEL_HEIGHT,
        THREAT_PANEL_PRIORITY
    )
    if root == 0 then
        return nil
    end
    local inner = _____521B_5EFA_80CC_666F(
        "ThreatPanelInner_P" .. tostring(playerId),
        gameUI,
        THREAT_PANEL_X + THREAT_PANEL_INNER_OFFSET_X,
        THREAT_PANEL_Y + THREAT_PANEL_INNER_OFFSET_Y,
        THREAT_PANEL_INNER_WIDTH,
        THREAT_PANEL_INNER_HEIGHT,
        THREAT_PANEL_BG_TEXTURE,
        THREAT_PANEL_INNER_ALPHA,
        THREAT_PANEL_PRIORITY + 2
    )
    local title = _____521B_5EFA_6587_672C(
        "ThreatPanelTitle_P" .. tostring(playerId),
        root,
        THREAT_PANEL_X + THREAT_PANEL_TITLE_OFFSET_X,
        THREAT_PANEL_Y + THREAT_PANEL_TITLE_OFFSET_Y,
        ("|cffffcc33" .. THREAT_PANEL_TITLE) .. "|r",
        THREAT_PANEL_TITLE_FONT,
        THREAT_PANEL_TITLE_SIZE,
        THREAT_PANEL_PRIORITY + 2,
        TEXT_ALIGN_CENTER,
        THREAT_PANEL_TITLE_WIDTH,
        THREAT_PANEL_TEXT_HEIGHT
    )
    local selected = _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
        "ThreatPanelSelected_P" .. tostring(playerId),
        root,
        THREAT_PANEL_X + THREAT_PANEL_TEXT_OFFSET_X,
        THREAT_PANEL_Y + THREAT_PANEL_SELECTED_OFFSET_Y,
        "",
        THREAT_PANEL_BODY_FONT,
        THREAT_PANEL_BODY_SIZE,
        THREAT_PANEL_PRIORITY + 2,
        TEXT_ALIGN_LEFT
    )
    local summary = _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
        "ThreatPanelSummary_P" .. tostring(playerId),
        root,
        THREAT_PANEL_X + THREAT_PANEL_TEXT_OFFSET_X,
        THREAT_PANEL_Y + THREAT_PANEL_SUMMARY_OFFSET_Y,
        "",
        THREAT_PANEL_BODY_FONT,
        THREAT_PANEL_BODY_SIZE,
        THREAT_PANEL_PRIORITY + 2,
        TEXT_ALIGN_LEFT
    )
    local header = _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
        "ThreatPanelHeaderName_P" .. tostring(playerId),
        root,
        THREAT_PANEL_X + THREAT_PANEL_NAME_COL_X,
        THREAT_PANEL_Y + THREAT_PANEL_HEADER_OFFSET_Y,
        "",
        THREAT_PANEL_BODY_FONT,
        THREAT_PANEL_BODY_SIZE,
        THREAT_PANEL_PRIORITY + 2,
        TEXT_ALIGN_LEFT,
        THREAT_PANEL_NAME_COL_WIDTH,
        THREAT_PANEL_TEXT_HEIGHT
    )
    local headerPercent = _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
        "ThreatPanelHeaderPercent_P" .. tostring(playerId),
        root,
        THREAT_PANEL_X + THREAT_PANEL_PERCENT_COL_X,
        THREAT_PANEL_Y + THREAT_PANEL_HEADER_OFFSET_Y,
        "",
        THREAT_PANEL_BODY_FONT,
        THREAT_PANEL_BODY_SIZE,
        THREAT_PANEL_PRIORITY + 2,
        TEXT_ALIGN_LEFT,
        THREAT_PANEL_PERCENT_COL_WIDTH,
        THREAT_PANEL_TEXT_HEIGHT
    )
    local headerThreat = _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
        "ThreatPanelHeaderThreat_P" .. tostring(playerId),
        root,
        THREAT_PANEL_X + THREAT_PANEL_THREAT_COL_X,
        THREAT_PANEL_Y + THREAT_PANEL_HEADER_OFFSET_Y,
        "",
        THREAT_PANEL_BODY_FONT,
        THREAT_PANEL_BODY_SIZE,
        THREAT_PANEL_PRIORITY + 2,
        TEXT_ALIGN_LEFT,
        THREAT_PANEL_THREAT_COL_WIDTH,
        THREAT_PANEL_TEXT_HEIGHT
    )
    local rowNames = {}
    local rowPercents = {}
    local rowThreats = {}
    do
        local i = 0
        while i < THREAT_PANEL_ROW_COUNT do
            local nameFrame = _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
                (("ThreatPanelRowName_P" .. tostring(playerId)) .. "_") .. tostring(i),
                root,
                THREAT_PANEL_X + THREAT_PANEL_NAME_COL_X,
                THREAT_PANEL_Y + THREAT_PANEL_ROW_START_OFFSET_Y - THREAT_PANEL_ROW_GAP * i,
                EMPTY_ROW,
                THREAT_PANEL_BODY_FONT,
                THREAT_PANEL_BODY_SIZE,
                THREAT_PANEL_PRIORITY + 2,
                TEXT_ALIGN_LEFT,
                THREAT_PANEL_NAME_COL_WIDTH,
                THREAT_PANEL_TEXT_HEIGHT
            )
            local percentFrame = _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
                (("ThreatPanelRowPercent_P" .. tostring(playerId)) .. "_") .. tostring(i),
                root,
                THREAT_PANEL_X + THREAT_PANEL_PERCENT_COL_X,
                THREAT_PANEL_Y + THREAT_PANEL_ROW_START_OFFSET_Y - THREAT_PANEL_ROW_GAP * i,
                EMPTY_ROW,
                THREAT_PANEL_BODY_FONT,
                THREAT_PANEL_BODY_SIZE,
                THREAT_PANEL_PRIORITY + 2,
                TEXT_ALIGN_LEFT,
                THREAT_PANEL_PERCENT_COL_WIDTH,
                THREAT_PANEL_TEXT_HEIGHT
            )
            local threatFrame = _____521B_5EFA_6587_672C_5E26_5BF9_9F50(
                (("ThreatPanelRowThreat_P" .. tostring(playerId)) .. "_") .. tostring(i),
                root,
                THREAT_PANEL_X + THREAT_PANEL_THREAT_COL_X,
                THREAT_PANEL_Y + THREAT_PANEL_ROW_START_OFFSET_Y - THREAT_PANEL_ROW_GAP * i,
                EMPTY_ROW,
                THREAT_PANEL_BODY_FONT,
                THREAT_PANEL_BODY_SIZE,
                THREAT_PANEL_PRIORITY + 2,
                TEXT_ALIGN_LEFT,
                THREAT_PANEL_THREAT_COL_WIDTH,
                THREAT_PANEL_TEXT_HEIGHT
            )
            rowNames[#rowNames + 1] = nameFrame
            rowPercents[#rowPercents + 1] = percentFrame
            rowThreats[#rowThreats + 1] = threatFrame
            i = i + 1
        end
    end
    return {
        root = root,
        inner = inner,
        title = title,
        selected = selected,
        summary = summary,
        headerName = header,
        headerPercent = headerPercent,
        headerThreat = headerThreat,
        rowNames = rowNames,
        rowPercents = rowPercents,
        rowThreats = rowThreats
    }
end
____exports["创建全部玩家面板"] = function(gameUI)
    do
        local playerId = 0
        while playerId < THREAT_PANEL_PLAYER_SLOTS do
            local panel = _____521B_5EFA_5355_73A9_5BB6_9762_677F(playerId, gameUI)
            if panel ~= nil then
                _____73A9_5BB6_9762_677F_8868[playerId] = panel
            end
            playerId = playerId + 1
        end
    end
end
return ____exports
