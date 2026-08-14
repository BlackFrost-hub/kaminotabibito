local ____lualib = require("lualib_bundle")
local __TS__StringSubstr = ____lualib.__TS__StringSubstr
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local _____53D6_8F83_5927_6570
function _____53D6_8F83_5927_6570(a, b)
    return a > b and a or b
end
local japi = require("jass.japi")
local DzGetGameUI = japi.DzGetGameUI
local DzLoadToc = japi.DzLoadToc
local DzCreateFrame = japi.DzCreateFrame
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameClearAllPoints = japi.DzFrameClearAllPoints
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetEnable = japi.DzFrameSetEnable
local DzFrameShow = japi.DzFrameShow
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local POINT_TOPLEFT = 0
local POINT_TOP = 1
local POINT_BOTTOM = 7
local TOOLTIP_TOC_PATH = "UI\\BuffTestTooltip.toc"
local TOOLTIP_FDF_NAME = "ItemTooltipNativePanel"
local TOOLTIP_FDF_CONTEXT = 9301
local TOOLTIP_TEXT_CONTEXT_BASE = 9310
local TOOLTIP_WIDTH = 0.22
local TOOLTIP_MIN_HEIGHT = 0.07
local TOOLTIP_COMMAND_BAR_ROW = 0
local TOOLTIP_COMMAND_BAR_COLUMN = 1
local TOOLTIP_COMMAND_BAR_OFFSET_X = 0.01
local TOOLTIP_COMMAND_BAR_OFFSET_Y = 0.035
local HEADER_X = 0.004
local HEADER_TEXT_WITH_ICON_X = 0.018
local HEADER_ICON_Y_OFFSET = -0.002
local NAME_Y = -0.006
local LINE_STEP = 0.015
local BODY_GAP = 0.009
local BODY_LINE_HEIGHT = 0.013
local BODY_BOTTOM_PADDING = 0.008
local BODY_WRAP_VISIBLE_WIDTH = 42
local SELL_HINT_TEXT = "|cff808080将物品扔在商店上以卖出|r"
local GOLD_TEXT_COLOR = "|cffffcc00"
local COLOR_END = "|r"
local USE_HINT_TEXT = (GOLD_TEXT_COLOR .. "点击左键使用") .. COLOR_END
____exports["有效帧"] = function(frame)
    return frame ~= nil and frame ~= 0
end
local function _____5B89_5168_663E_793A(frame, visible)
    if ____exports["有效帧"](frame) then
        DzFrameShow(frame, visible)
    end
end
local function _____5B89_5168_8BBE_6587_672C(frame, text)
    if ____exports["有效帧"](frame) then
        DzFrameSetText(frame, text)
    end
end
local function _____951A_5230_5DE6_4E0A(frame, root, x, y)
    if not ____exports["有效帧"](frame) or not ____exports["有效帧"](root) then
        return
    end
    DzFrameClearAllPoints(frame)
    DzFrameSetPoint(
        frame,
        POINT_TOPLEFT,
        root,
        POINT_TOPLEFT,
        x,
        y
    )
end
____exports["锚定提示根框到原生物品提示位置"] = function(root)
    if not ____exports["有效帧"](root) then
        return
    end
    local commandButton = DzFrameGetCommandBarButton(TOOLTIP_COMMAND_BAR_ROW, TOOLTIP_COMMAND_BAR_COLUMN)
    if not ____exports["有效帧"](commandButton) then
        return
    end
    DzFrameClearAllPoints(root)
    DzFrameSetPoint(
        root,
        POINT_BOTTOM,
        commandButton,
        POINT_TOP,
        TOOLTIP_COMMAND_BAR_OFFSET_X,
        TOOLTIP_COMMAND_BAR_OFFSET_Y
    )
end
local ____fdf_5DF2_52A0_8F7D = false
local _____5F85_52A0_8F7DToc_8DEF_5F84 = ""
local function _____6267_884C_52A0_8F7DToc(self)
    DzLoadToc(_____5F85_52A0_8F7DToc_8DEF_5F84)
end
local function _____52A0_8F7D_7269_54C1_63D0_793AFdf()
    if ____fdf_5DF2_52A0_8F7D then
        return true
    end
    _____5F85_52A0_8F7DToc_8DEF_5F84 = TOOLTIP_TOC_PATH
    local ok = pcall(_____6267_884C_52A0_8F7DToc)
    ____fdf_5DF2_52A0_8F7D = ok == true
    return ____fdf_5DF2_52A0_8F7D
end
local function _____521B_5EFAFdf_6587_672C_5E27(name, parent, contextId)
    local frame = DzCreateFrame(name, parent, contextId)
    if ____exports["有效帧"](frame) then
        DzFrameSetEnable(frame, false)
    end
    return frame
end
local function _____521B_5EFAFdf_56FE_6807_5E27(name, parent, contextId)
    return DzCreateFrame(name, parent, contextId)
end
local function _____683C_5F0F_5316_6574_6570(value)
    return tostring(math.floor(value + 0.5)
    )
end
local function _____683C_5F0F_5316_91D1_8272_6574_6570(value)
    return (GOLD_TEXT_COLOR .. _____683C_5F0F_5316_6574_6570(value)) .. COLOR_END
end
local function _____53D6_989C_8272_7801_7ED3_675F_4F4D_7F6E(text, index)
    if __TS__StringSubstr(text, index, 2) == "|r" or __TS__StringSubstr(text, index, 2) == "|n" then
        return index + 2
    end
    if __TS__StringSubstr(text, index, 2) ~= "|c" then
        return index
    end
    return index + 10 <= #text and index + 10 or index + 2
end
local function _____8BA1_7B97_53EF_89C1_6587_672C_5BBD_5EA6(text)
    local width = 0
    local index = 0
    while index < #text do
        do
            local code = string.byte(text, index + 1) or 0
            if code == 124 then
                local nextIndex = _____53D6_989C_8272_7801_7ED3_675F_4F4D_7F6E(text, index)
                if nextIndex > index then
                    index = nextIndex
                    goto __continue24
                end
            end
            if code >= 240 then
                width = width + 1.6
                index = index + 4
            elseif code >= 224 then
                width = width + 1.6
                index = index + 3
            elseif code >= 192 then
                width = width + 1.6
                index = index + 2
            else
                width = width + 0.8
                index = index + 1
            end
        end
        ::__continue24::
    end
    return width
end
local function _____8BA1_7B97_63D0_793A_6B63_6587_884C_6570(text)
    if text == "" then
        return 0
    end
    local count = 0
    local searchIndex = 0
    while true do
        local nextIndex = (string.find(
            text,
            "|n",
            math.max(searchIndex + 1, 1),
            true
        ) or 0) - 1
        local lineText = nextIndex < 0 and __TS__StringSubstring(text, searchIndex) or __TS__StringSubstring(text, searchIndex, nextIndex)
        local visibleWidth = _____8BA1_7B97_53EF_89C1_6587_672C_5BBD_5EA6(lineText)
        count = count + _____53D6_8F83_5927_6570(
            1,
            math.ceil(visibleWidth / BODY_WRAP_VISIBLE_WIDTH)
        )
        if nextIndex < 0 then
            break
        end
        searchIndex = nextIndex + 2
    end
    return count
end
____exports["更新物品提示内容"] = function(_____5E27, _____5185_5BB9)
    local titleText = _____5185_5BB9.activeUseHotkey ~= nil and _____5185_5BB9.activeUseHotkey ~= "" and ((_____5185_5BB9.name .. " |cffffcc00（小键盘") .. _____5185_5BB9.activeUseHotkey) .. "）|r" or _____5185_5BB9.name
    _____5B89_5168_8BBE_6587_672C(_____5E27.name, titleText)
    local lineIndex = 1
    if (_____5185_5BB9.manaCost or 0) > 0 then
        local y = NAME_Y - LINE_STEP * lineIndex
        _____951A_5230_5DE6_4E0A(_____5E27.manaIcon, _____5E27.root, HEADER_X, y + HEADER_ICON_Y_OFFSET)
        _____951A_5230_5DE6_4E0A(_____5E27.manaText, _____5E27.root, HEADER_TEXT_WITH_ICON_X, y)
        _____5B89_5168_8BBE_6587_672C(
            _____5E27.manaText,
            _____683C_5F0F_5316_6574_6570(_____5185_5BB9.manaCost or 0)
        )
        _____5B89_5168_663E_793A(_____5E27.manaIcon, true)
        _____5B89_5168_663E_793A(_____5E27.manaText, true)
        lineIndex = lineIndex + 1
    else
        _____5B89_5168_663E_793A(_____5E27.manaIcon, false)
        _____5B89_5168_663E_793A(_____5E27.manaText, false)
    end
    if _____5185_5BB9.sellable == true and (_____5185_5BB9.sellGold or 0) > 0 then
        local goldY = NAME_Y - LINE_STEP * lineIndex
        _____951A_5230_5DE6_4E0A(_____5E27.goldIcon, _____5E27.root, HEADER_X, goldY + HEADER_ICON_Y_OFFSET)
        _____951A_5230_5DE6_4E0A(_____5E27.goldText, _____5E27.root, HEADER_TEXT_WITH_ICON_X, goldY)
        _____5B89_5168_8BBE_6587_672C(
            _____5E27.goldText,
            _____683C_5F0F_5316_91D1_8272_6574_6570(_____5185_5BB9.sellGold or 0)
        )
        _____5B89_5168_663E_793A(_____5E27.goldIcon, true)
        _____5B89_5168_663E_793A(_____5E27.goldText, true)
        lineIndex = lineIndex + 1
        local sellY = NAME_Y - LINE_STEP * lineIndex
        _____951A_5230_5DE6_4E0A(_____5E27.sellText, _____5E27.root, HEADER_X, sellY)
        _____5B89_5168_8BBE_6587_672C(_____5E27.sellText, SELL_HINT_TEXT)
        _____5B89_5168_663E_793A(_____5E27.sellText, true)
        lineIndex = lineIndex + 1
    else
        _____5B89_5168_663E_793A(_____5E27.goldIcon, false)
        _____5B89_5168_663E_793A(_____5E27.goldText, false)
        _____5B89_5168_663E_793A(_____5E27.sellText, false)
    end
    if _____5185_5BB9.activeUsable == true then
        local useY = NAME_Y - LINE_STEP * lineIndex
        _____951A_5230_5DE6_4E0A(_____5E27.useText, _____5E27.root, HEADER_X, useY)
        _____5B89_5168_8BBE_6587_672C(_____5E27.useText, USE_HINT_TEXT)
        _____5B89_5168_663E_793A(_____5E27.useText, true)
        lineIndex = lineIndex + 1
    else
        _____5B89_5168_663E_793A(_____5E27.useText, false)
    end
    local bodyY = NAME_Y - LINE_STEP * lineIndex - BODY_GAP
    local bodyLineCount = _____8BA1_7B97_63D0_793A_6B63_6587_884C_6570(_____5185_5BB9.dynamicText)
    local bodyHeight = bodyLineCount > 0 and bodyLineCount * BODY_LINE_HEIGHT + 0.004 or 0
    local tooltipHeight = _____53D6_8F83_5927_6570(TOOLTIP_MIN_HEIGHT, -bodyY + bodyHeight + BODY_BOTTOM_PADDING)
    DzFrameSetSize(_____5E27.root, TOOLTIP_WIDTH, tooltipHeight)
    if ____exports["有效帧"](_____5E27.body) then
        DzFrameSetSize(_____5E27.body, 0.19, bodyHeight)
    end
    _____951A_5230_5DE6_4E0A(_____5E27.body, _____5E27.root, HEADER_X, bodyY)
    _____5B89_5168_8BBE_6587_672C(_____5E27.body, _____5185_5BB9.dynamicText)
    _____5B89_5168_663E_793A(_____5E27.body, _____5185_5BB9.dynamicText ~= "")
end
____exports["创建物品提示UI"] = function()
    local gameUI = DzGetGameUI()
    if not ____exports["有效帧"](gameUI) then
        return nil
    end
    if not _____52A0_8F7D_7269_54C1_63D0_793AFdf() then
        return nil
    end
    local root = DzCreateFrame(TOOLTIP_FDF_NAME, gameUI, TOOLTIP_FDF_CONTEXT)
    if not ____exports["有效帧"](root) then
        return nil
    end
    DzFrameShow(root, false)
    ____exports["锚定提示根框到原生物品提示位置"](root)
    DzFrameSetPriority(root, 8700)
    local name = _____521B_5EFAFdf_6587_672C_5E27("ItemTooltipNativeNameText", root, TOOLTIP_TEXT_CONTEXT_BASE + 1)
    local manaIcon = _____521B_5EFAFdf_56FE_6807_5E27("ItemTooltipNativeManaIcon", root, TOOLTIP_TEXT_CONTEXT_BASE + 2)
    local manaText = _____521B_5EFAFdf_6587_672C_5E27("ItemTooltipNativeManaText", root, TOOLTIP_TEXT_CONTEXT_BASE + 3)
    local goldIcon = _____521B_5EFAFdf_56FE_6807_5E27("ItemTooltipNativeGoldIcon", root, TOOLTIP_TEXT_CONTEXT_BASE + 4)
    local goldText = _____521B_5EFAFdf_6587_672C_5E27("ItemTooltipNativeGoldText", root, TOOLTIP_TEXT_CONTEXT_BASE + 5)
    local sellText = _____521B_5EFAFdf_6587_672C_5E27("ItemTooltipNativeSellText", root, TOOLTIP_TEXT_CONTEXT_BASE + 6)
    local useText = _____521B_5EFAFdf_6587_672C_5E27("ItemTooltipNativeUseText", root, TOOLTIP_TEXT_CONTEXT_BASE + 7)
    local body = _____521B_5EFAFdf_6587_672C_5E27("ItemTooltipNativeBodyText", root, TOOLTIP_TEXT_CONTEXT_BASE + 8)
    if ____exports["有效帧"](name) then
        DzFrameSetPoint(
            name,
            POINT_TOPLEFT,
            root,
            POINT_TOPLEFT,
            HEADER_X,
            NAME_Y
        )
    end
    if not ____exports["有效帧"](name) or not ____exports["有效帧"](body) then
        return nil
    end
    return {
        root = root,
        name = name,
        manaIcon = manaIcon,
        manaText = manaText,
        goldIcon = goldIcon,
        goldText = goldText,
        sellText = sellText,
        useText = useText,
        body = body
    }
end
return ____exports
