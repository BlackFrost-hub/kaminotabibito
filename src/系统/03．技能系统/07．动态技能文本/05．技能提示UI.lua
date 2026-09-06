local ____lualib = require("lualib_bundle")
local __TS__StringSubstr = ____lualib.__TS__StringSubstr
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
--- 技能悬停提示。
-- 采用与物品提示模拟相同的同步 Frame 方案，避免原生提示框固定高度裁剪长说明。
local jass = require("jass.common")
local japi = require("jass.japi")
local selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照")
local dynamicTextCore = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑")
local ____require_result_0 = require("系统.03．技能系统.02．技能消耗.04．原生魔法消耗同步")
local _____83B7_53D6_5DF2_540C_6B65_6280_80FD_9B54_6CD5_6D88_8017 = ____require_result_0["获取已同步技能魔法消耗"]
local DzGetGameUI = japi.DzGetGameUI
local DzLoadToc = japi.DzLoadToc
local DzCreateFrame = japi.DzCreateFrame
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local DzFrameGetTooltip = japi.DzFrameGetTooltip
local DzFrameSetScriptByCode = japi.DzFrameSetScriptByCode
local DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameClearAllPoints = japi.DzFrameClearAllPoints
local DzFrameSetPriority = japi.DzFrameSetPriority
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetEnable = japi.DzFrameSetEnable
local DzFrameShow = japi.DzFrameShow
local DzGetUnitAbilityTip = japi.DzGetUnitAbilityTip
local DzGetUnitAbilityUberTip = japi.DzGetUnitAbilityUberTip
local TOC_PATH = "UI\\BuffTestTooltip.toc"
local FDF_NAME = "AbilityTooltipNativePanel"
local FRAME_CONTEXT = 9401
local TEXT_CONTEXT = 9410
local POINT_BOTTOM = 7
local POINT_TOP = 1
local POINT_TOPLEFT = 0
local TOOLTIP_COMMAND_BAR_ROW = 0
local TOOLTIP_COMMAND_BAR_COLUMN = 1
local TOOLTIP_COMMAND_BAR_OFFSET_X = 0.01
local TOOLTIP_COMMAND_BAR_OFFSET_Y = 0.035
local MOUSE_ENTER = 2
local MOUSE_LEAVE = 3
local ROOT_WIDTH = 0.22
local ROOT_MIN_HEIGHT = 0.07
local PAD_X = 0.004
local NAME_Y = -0.006
local MANA_ICON_Y_OFFSET = 0.0025
local LINE_STEP = 0.015
local BODY_GAP = 0.009
local BODY_LINE_HEIGHT = 0.013
local BODY_BOTTOM_PADDING = 0.008
local BODY_WIDTH = 42
local _____5DF2_521D_59CB_5316 = false
local ____fdf_5DF2_52A0_8F7D = false
local _____63D0_793A_5E27 = nil
local _____5F53_524D_60AC_505C_82F1_96C4 = nil
local _____5F53_524D_60AC_505C_6280_80FDID = 0
local _____539F_59CB_6587_672C_6A21_5F0F = false
local function _____6709_6548_5E27(frame)
    return frame ~= nil and frame ~= 0
end
local function _____5B89_5168_663E_793A(frame, visible)
    if _____6709_6548_5E27(frame) then
        DzFrameShow(frame, visible)
    end
end
local function _____5B89_5168_6587_672C(frame, text)
    if _____6709_6548_5E27(frame) then
        DzFrameSetText(frame, text)
    end
end
local function _____951A_5DE6_4E0A(frame, root, x, y)
    if not _____6709_6548_5E27(frame) or not _____6709_6548_5E27(root) then
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
local function _____9690_85CF_539F_751F_63D0_793A()
    local tooltip = DzFrameGetTooltip()
    local gameUI = DzGetGameUI()
    if not _____6709_6548_5E27(tooltip) or not _____6709_6548_5E27(gameUI) then
        return
    end
    DzFrameClearAllPoints(tooltip)
    DzFrameSetPoint(
        tooltip,
        POINT_BOTTOM,
        gameUI,
        POINT_BOTTOM,
        0,
        -0.6
    )
end
local function _____6062_590D_539F_751F_63D0_793A()
    local tooltip = DzFrameGetTooltip()
    local gameUI = DzGetGameUI()
    if not _____6709_6548_5E27(tooltip) or not _____6709_6548_5E27(gameUI) then
        return
    end
    DzFrameClearAllPoints(tooltip)
    DzFrameSetPoint(
        tooltip,
        8,
        gameUI,
        8,
        0,
        0.16
    )
end
local function _____52A0_8F7DFdf()
    if ____fdf_5DF2_52A0_8F7D then
        return true
    end
    local ok = false
    local function _____6267_884C_52A0_8F7D(self)
        DzLoadToc(TOC_PATH)
        ok = true
    end
    pcall(_____6267_884C_52A0_8F7D)
    ____fdf_5DF2_52A0_8F7D = ok
    return ok
end
local function _____521B_5EFA_6587_672C_5E27(name, parent, context)
    local frame = DzCreateFrame(name, parent, context)
    if _____6709_6548_5E27(frame) then
        DzFrameSetEnable(frame, false)
    end
    return frame
end
local function _____521B_5EFA_63D0_793A_5E27()
    local gameUI = DzGetGameUI()
    if not _____6709_6548_5E27(gameUI) or not _____52A0_8F7DFdf() then
        return nil
    end
    local root = DzCreateFrame(FDF_NAME, gameUI, FRAME_CONTEXT)
    if not _____6709_6548_5E27(root) then
        return nil
    end
    local name = _____521B_5EFA_6587_672C_5E27("AbilityTooltipNativeNameText", root, TEXT_CONTEXT + 1)
    local manaIcon = DzCreateFrame("AbilityTooltipNativeManaIcon", root, TEXT_CONTEXT + 2)
    local manaText = _____521B_5EFA_6587_672C_5E27("AbilityTooltipNativeManaText", root, TEXT_CONTEXT + 3)
    local body = _____521B_5EFA_6587_672C_5E27("AbilityTooltipNativeBodyText", root, TEXT_CONTEXT + 4)
    if not _____6709_6548_5E27(name) or not _____6709_6548_5E27(manaIcon) or not _____6709_6548_5E27(manaText) or not _____6709_6548_5E27(body) then
        return nil
    end
    DzFrameSetTextColor(
        manaText,
        255,
        204,
        0,
        255
    )
    DzFrameShow(root, false)
    DzFrameSetPriority(root, 8700)
    return {
        root = root,
        name = name,
        manaIcon = manaIcon,
        manaText = manaText,
        body = body
    }
end
local function _____989C_8272_7801_7ED3_675F_4F4D_7F6E(text, index)
    if __TS__StringSubstr(text, index, 2) == "|r" or __TS__StringSubstr(text, index, 2) == "|n" then
        return index + 2
    end
    if __TS__StringSubstr(text, index, 2) == "|c" then
        return index + 10 <= #text and index + 10 or index + 2
    end
    return index
end
local function _____53EF_89C1_5BBD_5EA6(text)
    local width = 0
    local index = 0
    while index < #text do
        do
            local code = string.byte(text, index + 1) or 0
            local colorEnd = code == 124 and _____989C_8272_7801_7ED3_675F_4F4D_7F6E(text, index) or index
            if colorEnd > index then
                index = colorEnd
                goto __continue26
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
        ::__continue26::
    end
    return width
end
local function _____6B63_6587_884C_6570(text)
    if text == "" then
        return 0
    end
    local count = 0
    local start = 0
    while true do
        local ____end = (string.find(
            text,
            "|n",
            math.max(start + 1, 1),
            true
        ) or 0) - 1
        local line = ____end < 0 and __TS__StringSubstring(text, start) or __TS__StringSubstring(text, start, ____end)
        count = count + math.max(
            1,
            math.ceil(_____53EF_89C1_5BBD_5EA6(line) / BODY_WIDTH)
        )
        if ____end < 0 then
            return count
        end
        start = ____end + 2
    end
end
local function _____683C_5F0F_5316_9B54_8017(value)
    if not (value > 0) then
        return ""
    end
    return ("|cffffcc00" .. tostring(jass.I2S(jass.R2I(value + 0.5)))) .. "|r"
end
local function _____951A_5B9A_6839_6846(root)
    if not _____6709_6548_5E27(root) then
        return
    end
    local commandButton = DzFrameGetCommandBarButton(TOOLTIP_COMMAND_BAR_ROW, TOOLTIP_COMMAND_BAR_COLUMN)
    if not _____6709_6548_5E27(commandButton) then
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
local function _____66F4_65B0_63D0_793A(hero, abilityId)
    if _____63D0_793A_5E27 == nil or not _____6709_6548_5E27(hero) or abilityId == 0 then
        return
    end
    _____5F53_524D_60AC_505C_82F1_96C4 = hero
    _____5F53_524D_60AC_505C_6280_80FDID = abilityId
    if not _____539F_59CB_6587_672C_6A21_5F0F then
        dynamicTextCore["刷新单个英雄技能动态文本"](hero, abilityId)
    end
    local title = DzGetUnitAbilityTip(hero, abilityId) or ""
    local body = _____539F_59CB_6587_672C_6A21_5F0F and dynamicTextCore["获取技能原始提示"](hero, abilityId) or (DzGetUnitAbilityUberTip(hero, abilityId) or "")
    local cost = _____83B7_53D6_5DF2_540C_6B65_6280_80FD_9B54_6CD5_6D88_8017(hero, abilityId)
    _____5B89_5168_6587_672C(_____63D0_793A_5E27.name, title)
    local costText = _____683C_5F0F_5316_9B54_8017(cost)
    _____5B89_5168_6587_672C(_____63D0_793A_5E27.manaText, costText)
    DzFrameSetTextColor(
        _____63D0_793A_5E27.manaText,
        255,
        204,
        0,
        255
    )
    _____5B89_5168_663E_793A(_____63D0_793A_5E27.manaIcon, costText ~= "")
    _____5B89_5168_663E_793A(_____63D0_793A_5E27.manaText, costText ~= "")
    local lineIndex = costText ~= "" and 2 or 1
    local bodyY = NAME_Y - LINE_STEP * lineIndex - BODY_GAP
    local bodyHeight = _____6B63_6587_884C_6570(body) * BODY_LINE_HEIGHT + (body ~= "" and 0.004 or 0)
    local rootHeight = math.max(ROOT_MIN_HEIGHT, -bodyY + bodyHeight + BODY_BOTTOM_PADDING)
    DzFrameSetSize(_____63D0_793A_5E27.root, ROOT_WIDTH, rootHeight)
    DzFrameSetSize(_____63D0_793A_5E27.body, ROOT_WIDTH - PAD_X * 2, bodyHeight)
    _____951A_5DE6_4E0A(_____63D0_793A_5E27.name, _____63D0_793A_5E27.root, PAD_X, NAME_Y)
    _____951A_5DE6_4E0A(_____63D0_793A_5E27.manaIcon, _____63D0_793A_5E27.root, PAD_X, NAME_Y - LINE_STEP + MANA_ICON_Y_OFFSET)
    _____951A_5DE6_4E0A(_____63D0_793A_5E27.manaText, _____63D0_793A_5E27.root, PAD_X + 0.014, NAME_Y - LINE_STEP)
    _____951A_5DE6_4E0A(_____63D0_793A_5E27.body, _____63D0_793A_5E27.root, PAD_X, bodyY)
    _____5B89_5168_6587_672C(_____63D0_793A_5E27.body, body)
    _____5B89_5168_663E_793A(_____63D0_793A_5E27.body, body ~= "")
    _____951A_5B9A_6839_6846(_____63D0_793A_5E27.root)
    _____9690_85CF_539F_751F_63D0_793A()
    DzFrameShow(_____63D0_793A_5E27.root, true)
    _____9690_85CF_539F_751F_63D0_793A()
end
local function _____8BFB_53D6_6280_80FD_4F4D(hero, frame)
    local snapshot = selectionSnapshotSystem["获取本地选中技能快照"]()
    if snapshot.hero ~= hero then
        return nil
    end
    local keys = {
        "Q",
        "W",
        "E",
        "R",
        "D"
    }
    do
        local i = 0
        while i < #keys do
            local key = keys[i + 1]
            local slot = snapshot.slots[key]
            if DzFrameGetCommandBarButton(slot.y, slot.x) == frame then
                return key
            end
            i = i + 1
        end
    end
    return nil
end
local function _____6280_80FD_6309_94AE_8FDB_5165()
    if _____63D0_793A_5E27 == nil then
        return
    end
    local frame = DzGetTriggerUIEventFrame()
    local hero = selectionSnapshotSystem["获取本地选中技能快照"]().hero
    if not _____6709_6548_5E27(hero) then
        return
    end
    local key = _____8BFB_53D6_6280_80FD_4F4D(hero, frame)
    if key == nil then
        return
    end
    local abilityId = selectionSnapshotSystem["获取本地选中技能快照"]().skills[key]
    if abilityId == 0 then
        return
    end
    _____66F4_65B0_63D0_793A(hero, abilityId)
end
--- Alt 按住时仍使用自定义框，只切换到首次缓存的原始技能说明。
____exports["设置技能提示原始模式"] = function(_____539F_59CB_6A21_5F0F)
    _____539F_59CB_6587_672C_6A21_5F0F = _____539F_59CB_6A21_5F0F
    if _____5F53_524D_60AC_505C_82F1_96C4 ~= nil and _____5F53_524D_60AC_505C_82F1_96C4 ~= 0 and _____5F53_524D_60AC_505C_6280_80FDID ~= 0 then
        _____66F4_65B0_63D0_793A(_____5F53_524D_60AC_505C_82F1_96C4, _____5F53_524D_60AC_505C_6280_80FDID)
    end
end
local function _____6280_80FD_6309_94AE_79BB_5F00()
    if _____63D0_793A_5E27 ~= nil then
        DzFrameShow(_____63D0_793A_5E27.root, false)
    end
    _____5F53_524D_60AC_505C_82F1_96C4 = nil
    _____5F53_524D_60AC_505C_6280_80FDID = 0
    _____6062_590D_539F_751F_63D0_793A()
end
local function _____6CE8_518C_6280_80FD_6309_94AE()
    local positions = {
        {0, 2},
        {1, 2},
        {2, 2},
        {3, 2},
        {0, 1},
        {1, 1},
        {2, 1},
        {3, 1}
    }
    do
        local i = 0
        while i < #positions do
            do
                local button = DzFrameGetCommandBarButton(positions[i + 1][2], positions[i + 1][1])
                if not _____6709_6548_5E27(button) then
                    goto __continue60
                end
                DzFrameSetScriptByCode(button, MOUSE_ENTER, _____6280_80FD_6309_94AE_8FDB_5165, false)
                DzFrameSetScriptByCode(button, MOUSE_LEAVE, _____6280_80FD_6309_94AE_79BB_5F00, false)
            end
            ::__continue60::
            i = i + 1
        end
    end
end
____exports["初始化技能提示UI"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____63D0_793A_5E27 = _____521B_5EFA_63D0_793A_5E27()
    if _____63D0_793A_5E27 == nil then
        return
    end
    _____6CE8_518C_6280_80FD_6309_94AE()
end
return ____exports
