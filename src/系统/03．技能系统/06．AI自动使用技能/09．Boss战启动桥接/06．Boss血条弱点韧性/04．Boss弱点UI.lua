local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.01．常量定义")
local ____Boss_5F31_70B9UI_5E38_91CF = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点UI常量"]
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.04．硬件输入.index")
local frameSetScriptByCode = ____require_result_0.frameSetScriptByCode
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetText = japi.DzFrameSetText
local DzFrameShow = japi.DzFrameShow
local DzDestroyFrame = japi.DzDestroyFrame
local DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame
local DzFrameSetAlpha = japi.DzFrameSetAlpha
local DzFrameSetPriority = japi.DzFrameSetPriority
local FRAME_EVENT_MOUSE_ENTER = 2
local FRAME_EVENT_MOUSE_LEAVE = 3
local _____62A4_76FE_63D0_793A_6846By_6309_94AE = {}
local function _____8BB0_5F55_5F31_70B9UIFrame(state, frame)
    if frame == 0 then
        return
    end
    local ____state__5F31_70B9UIFrame_5217_8868_1 = state["弱点UIFrame列表"]
    ____state__5F31_70B9UIFrame_5217_8868_1[#____state__5F31_70B9UIFrame_5217_8868_1 + 1] = frame
end
local function _____79FB_9664_5F31_70B9UIFrame_8BB0_5F55(state, frame)
    if frame == 0 then
        return
    end
    do
        local i = #state["弱点UIFrame列表"] - 1
        while i >= 0 do
            if state["弱点UIFrame列表"][i + 1] == frame then
                __TS__ArraySplice(state["弱点UIFrame列表"], i, 1)
            end
            i = i - 1
        end
    end
end
local function _____9500_6BC1_5E27(frame)
    if frame == 0 then
        return
    end
    DzFrameShow(frame, false)
    DzDestroyFrame(frame)
end
local function ____on_62A4_76FE_8BF4_660E_6309_94AE_8FDB_5165()
    local buttonFrame = DzGetTriggerUIEventFrame()
    local tooltipFrame = _____62A4_76FE_63D0_793A_6846By_6309_94AE[buttonFrame] or 0
    if tooltipFrame ~= 0 then
        DzFrameShow(tooltipFrame, true)
    end
end
local function ____on_62A4_76FE_8BF4_660E_6309_94AE_79BB_5F00()
    local buttonFrame = DzGetTriggerUIEventFrame()
    local tooltipFrame = _____62A4_76FE_63D0_793A_6846By_6309_94AE[buttonFrame] or 0
    if tooltipFrame ~= 0 then
        DzFrameShow(tooltipFrame, false)
    end
end
local function _____521B_5EFABoss_5F31_70B9_95EE_53F7UI(state)
    if state["配置"] == nil then
        return
    end
    local weakList = state["配置"]["弱点列表"]
    do
        local i = 0
        while i < #weakList do
            local x = ____Boss_5F31_70B9UI_5E38_91CF["弱点起始X"] + ____Boss_5F31_70B9UI_5E38_91CF["弱点间距"] * (i + 1)
            local frame = DzCreateFrameByTagName(
                "BACKDROP",
                "BossWeakQuestion",
                state["血条Frame"],
                "template",
                i + 1
            )
            DzFrameSetSize(frame, ____Boss_5F31_70B9UI_5E38_91CF["弱点图标宽"], ____Boss_5F31_70B9UI_5E38_91CF["弱点图标高"])
            DzFrameSetAbsolutePoint(frame, ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"], x, ____Boss_5F31_70B9UI_5E38_91CF["弱点Y"])
            DzFrameSetTexture(frame, ____Boss_5F31_70B9UI_5E38_91CF["问号图标"], 0)
            DzFrameShow(frame, true)
            local ____state__5F31_70B9_95EE_53F7Frame_5217_8868_2 = state["弱点问号Frame列表"]
            ____state__5F31_70B9_95EE_53F7Frame_5217_8868_2[#____state__5F31_70B9_95EE_53F7Frame_5217_8868_2 + 1] = frame
            local ____state__5F31_70B9_56FE_6807Frame_5217_8868_3 = state["弱点图标Frame列表"]
            ____state__5F31_70B9_56FE_6807Frame_5217_8868_3[#____state__5F31_70B9_56FE_6807Frame_5217_8868_3 + 1] = 0
            local ____state__5F31_70B9X_8F74_5217_8868_4 = state["弱点X轴列表"]
            ____state__5F31_70B9X_8F74_5217_8868_4[#____state__5F31_70B9X_8F74_5217_8868_4 + 1] = x
            local ____state__5F31_70B9_5DF2_66B4_9732_5217_8868_5 = state["弱点已暴露列表"]
            ____state__5F31_70B9_5DF2_66B4_9732_5217_8868_5[#____state__5F31_70B9_5DF2_66B4_9732_5217_8868_5 + 1] = false
            local ____state__5F31_70B9_4FDD_62A4_5217_8868_6 = state["弱点保护列表"]
            ____state__5F31_70B9_4FDD_62A4_5217_8868_6[#____state__5F31_70B9_4FDD_62A4_5217_8868_6 + 1] = false
            local ____state__5F31_70B9_4FDD_62A4_622A_6B62_6BEB_79D2_5217_8868_7 = state["弱点保护截止毫秒列表"]
            ____state__5F31_70B9_4FDD_62A4_622A_6B62_6BEB_79D2_5217_8868_7[#____state__5F31_70B9_4FDD_62A4_622A_6B62_6BEB_79D2_5217_8868_7 + 1] = 0
            local ____state__5F31_70B9_547D_4E2D_8868_73B0_622A_6B62_6BEB_79D2_5217_8868_8 = state["弱点命中表现截止毫秒列表"]
            ____state__5F31_70B9_547D_4E2D_8868_73B0_622A_6B62_6BEB_79D2_5217_8868_8[#____state__5F31_70B9_547D_4E2D_8868_73B0_622A_6B62_6BEB_79D2_5217_8868_8 + 1] = 0
            _____8BB0_5F55_5F31_70B9UIFrame(state, frame)
            i = i + 1
        end
    end
end
local function _____521B_5EFABoss_62A4_76FE_8BF4_660EUI(state)
    local shieldMax = state["最大护盾值"]
    state["护盾图标Frame"] = DzCreateFrameByTagName(
        "BACKDROP",
        "BossWeakShieldIcon",
        state["血条Frame"],
        "template",
        13
    )
    DzFrameSetAbsolutePoint(state["护盾图标Frame"], ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标X"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标Y"])
    DzFrameSetTexture(state["护盾图标Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标"], 0)
    DzFrameSetSize(state["护盾图标Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标宽"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标高"])
    _____8BB0_5F55_5F31_70B9UIFrame(state, state["护盾图标Frame"])
    state["护盾文本Frame"] = DzCreateFrameByTagName(
        "TEXT",
        "BossWeakShieldText",
        state["护盾图标Frame"],
        "template",
        0
    )
    DzFrameSetPoint(
        state["护盾文本Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        state["护盾图标Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        0,
        0
    )
    DzFrameSetText(
        state["护盾文本Frame"],
        ("|cffff6600" .. tostring(shieldMax)) .. "|r"
    )
    DzFrameSetSize(state["护盾文本Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾文本宽"], ____Boss_5F31_70B9UI_5E38_91CF["护盾文本高"])
    _____8BB0_5F55_5F31_70B9UIFrame(state, state["护盾文本Frame"])
    state["护盾说明按钮Frame"] = DzCreateFrameByTagName(
        "GLUETEXTBUTTON",
        "BossWeakShieldHelpButton",
        state["血条Frame"],
        "template",
        0
    )
    DzFrameSetAbsolutePoint(state["护盾说明按钮Frame"], ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标X"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标Y"])
    DzFrameSetSize(state["护盾说明按钮Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾说明按钮宽"], ____Boss_5F31_70B9UI_5E38_91CF["护盾说明按钮高"])
    DzFrameSetText(state["护盾说明按钮Frame"], "")
    DzFrameSetAlpha(state["护盾说明按钮Frame"], 0)
    DzFrameSetPriority(state["护盾说明按钮Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾说明按钮优先级"])
    frameSetScriptByCode(state["护盾说明按钮Frame"], FRAME_EVENT_MOUSE_ENTER, ____on_62A4_76FE_8BF4_660E_6309_94AE_8FDB_5165, false)
    frameSetScriptByCode(state["护盾说明按钮Frame"], FRAME_EVENT_MOUSE_LEAVE, ____on_62A4_76FE_8BF4_660E_6309_94AE_79BB_5F00, false)
    _____8BB0_5F55_5F31_70B9UIFrame(state, state["护盾说明按钮Frame"])
    state["护盾提示文本框Frame"] = DzCreateFrameByTagName(
        "BACKDROP",
        "BossWeakShieldTooltipBg",
        state["血条Frame"],
        "template",
        0
    )
    DzFrameSetTexture(state["护盾提示文本框Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾提示框图"], 0)
    DzFrameSetSize(state["护盾提示文本框Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾提示框宽"], ____Boss_5F31_70B9UI_5E38_91CF["护盾提示框高"])
    DzFrameSetPoint(
        state["护盾提示文本框Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        state["护盾图标Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        ____Boss_5F31_70B9UI_5E38_91CF["护盾提示框偏移X"],
        ____Boss_5F31_70B9UI_5E38_91CF["护盾提示框偏移Y"]
    )
    DzFrameSetPriority(state["护盾提示文本框Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾提示框优先级"])
    DzFrameShow(state["护盾提示文本框Frame"], false)
    _____62A4_76FE_63D0_793A_6846By_6309_94AE[state["护盾说明按钮Frame"]] = state["护盾提示文本框Frame"]
    _____8BB0_5F55_5F31_70B9UIFrame(state, state["护盾提示文本框Frame"])
    state["护盾提示文本Frame"] = DzCreateFrameByTagName(
        "TEXT",
        "BossWeakShieldTooltipText",
        state["护盾提示文本框Frame"],
        "template",
        0
    )
    DzFrameSetSize(state["护盾提示文本Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾提示文本宽"], ____Boss_5F31_70B9UI_5E38_91CF["护盾提示文本高"])
    DzFrameSetPoint(
        state["护盾提示文本Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        state["护盾提示文本框Frame"],
        ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"],
        0,
        0
    )
    DzFrameSetText(state["护盾提示文本Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾说明文本"])
    DzFrameSetPriority(state["护盾提示文本Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾提示框优先级"])
    _____8BB0_5F55_5F31_70B9UIFrame(state, state["护盾提示文本Frame"])
    state["破碎护盾Frame"] = DzCreateFrameByTagName(
        "BACKDROP",
        "BossWeakShieldBroken",
        state["血条Frame"],
        "template",
        14
    )
    DzFrameSetAbsolutePoint(state["破碎护盾Frame"], ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标X"], ____Boss_5F31_70B9UI_5E38_91CF["护盾状态图标Y"])
    DzFrameSetTexture(state["破碎护盾Frame"], ____Boss_5F31_70B9UI_5E38_91CF["破碎护盾图标"], 0)
    DzFrameSetSize(state["破碎护盾Frame"], ____Boss_5F31_70B9UI_5E38_91CF["破碎护盾宽"], ____Boss_5F31_70B9UI_5E38_91CF["破碎护盾高"])
    DzFrameShow(state["破碎护盾Frame"], false)
    _____8BB0_5F55_5F31_70B9UIFrame(state, state["破碎护盾Frame"])
    state["灰色护盾Frame"] = DzCreateFrameByTagName(
        "BACKDROP",
        "BossWeakShieldGray",
        state["血条Frame"],
        "template",
        15
    )
    DzFrameSetAbsolutePoint(state["灰色护盾Frame"], ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标X"], ____Boss_5F31_70B9UI_5E38_91CF["护盾状态图标Y"])
    DzFrameSetTexture(state["灰色护盾Frame"], ____Boss_5F31_70B9UI_5E38_91CF["灰色护盾图标"], 0)
    DzFrameSetSize(state["灰色护盾Frame"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标宽"], ____Boss_5F31_70B9UI_5E38_91CF["护盾图标高"])
    DzFrameShow(state["灰色护盾Frame"], false)
    _____8BB0_5F55_5F31_70B9UIFrame(state, state["灰色护盾Frame"])
end
____exports["注册Boss弱点UI"] = function(state)
    if state["是否已结束"] or state["是否弱点已注册"] then
        return
    end
    if not state["是否血条已注册"] then
        return
    end
    _____521B_5EFABoss_5F31_70B9_95EE_53F7UI(state)
    _____521B_5EFABoss_62A4_76FE_8BF4_660EUI(state)
    state["是否弱点已注册"] = true
end
____exports["注销Boss弱点UI"] = function(state)
    if not state["是否弱点已注册"] then
        return
    end
    if state["护盾说明按钮Frame"] ~= 0 then
        _____62A4_76FE_63D0_793A_6846By_6309_94AE[state["护盾说明按钮Frame"]] = nil
    end
    do
        local i = #state["弱点UIFrame列表"] - 1
        while i >= 0 do
            _____9500_6BC1_5E27(state["弱点UIFrame列表"][i + 1])
            i = i - 1
        end
    end
    state["弱点UIFrame列表"] = {}
    state["弱点问号Frame列表"] = {}
    state["弱点图标Frame列表"] = {}
    state["弱点X轴列表"] = {}
    state["弱点已暴露列表"] = {}
    state["弱点保护列表"] = {}
    state["弱点保护截止毫秒列表"] = {}
    state["弱点命中表现截止毫秒列表"] = {}
    state["护盾图标Frame"] = 0
    state["灰色护盾Frame"] = 0
    state["破碎护盾Frame"] = 0
    state["护盾文本Frame"] = 0
    state["护盾说明按钮Frame"] = 0
    state["护盾提示文本框Frame"] = 0
    state["护盾提示文本Frame"] = 0
    state["是否弱点已注册"] = false
end
____exports["显示Boss弱点真实图标"] = function(state, weakIndex)
    if state["配置"] == nil then
        return
    end
    if weakIndex < 0 or weakIndex >= #state["配置"]["弱点列表"] then
        return
    end
    if state["弱点已暴露列表"][weakIndex + 1] == true then
        return
    end
    local questionFrame = state["弱点问号Frame列表"][weakIndex + 1] or 0
    if questionFrame ~= 0 then
        _____79FB_9664_5F31_70B9UIFrame_8BB0_5F55(state, questionFrame)
        _____9500_6BC1_5E27(questionFrame)
    end
    state["弱点问号Frame列表"][weakIndex + 1] = 0
    local weak = state["配置"]["弱点列表"][weakIndex + 1]
    local x = state["弱点X轴列表"][weakIndex + 1] or ____Boss_5F31_70B9UI_5E38_91CF["弱点起始X"] + ____Boss_5F31_70B9UI_5E38_91CF["弱点间距"] * (weakIndex + 1)
    local iconFrame = DzCreateFrameByTagName(
        "BACKDROP",
        "BossWeakIcon",
        state["血条Frame"],
        "template",
        30 + weakIndex
    )
    DzFrameSetSize(iconFrame, ____Boss_5F31_70B9UI_5E38_91CF["弱点图标宽"], ____Boss_5F31_70B9UI_5E38_91CF["弱点图标高"])
    DzFrameSetAbsolutePoint(iconFrame, ____Boss_5F31_70B9UI_5E38_91CF["锚点中心"], x, ____Boss_5F31_70B9UI_5E38_91CF["弱点Y"])
    DzFrameSetTexture(iconFrame, weak["贴图路径"], 0)
    DzFrameShow(iconFrame, true)
    state["弱点图标Frame列表"][weakIndex + 1] = iconFrame
    state["弱点已暴露列表"][weakIndex + 1] = true
    _____8BB0_5F55_5F31_70B9UIFrame(state, iconFrame)
end
____exports["设置Boss弱点命中表现"] = function(state, weakIndex, active)
    local frame = state["弱点图标Frame列表"][weakIndex + 1] or 0
    if frame == 0 then
        return
    end
    DzFrameSetSize(frame, active and ____Boss_5F31_70B9UI_5E38_91CF["弱点命中图标宽"] or ____Boss_5F31_70B9UI_5E38_91CF["弱点图标宽"], active and ____Boss_5F31_70B9UI_5E38_91CF["弱点命中图标高"] or ____Boss_5F31_70B9UI_5E38_91CF["弱点图标高"])
end
____exports["刷新Boss护盾文本"] = function(state, shieldValue)
    if state["护盾文本Frame"] == 0 then
        return
    end
    DzFrameSetText(
        state["护盾文本Frame"],
        ("|cffff6600" .. tostring(shieldValue)) .. "|r"
    )
end
____exports["设置Boss护盾完整显示"] = function(state)
    if state["护盾图标Frame"] ~= 0 then
        DzFrameShow(state["护盾图标Frame"], true)
    end
    if state["护盾文本Frame"] ~= 0 then
        DzFrameShow(state["护盾文本Frame"], true)
    end
    if state["护盾说明按钮Frame"] ~= 0 then
        DzFrameShow(state["护盾说明按钮Frame"], true)
    end
    if state["护盾提示文本框Frame"] ~= 0 then
        DzFrameShow(state["护盾提示文本框Frame"], false)
    end
    if state["破碎护盾Frame"] ~= 0 then
        DzFrameShow(state["破碎护盾Frame"], false)
    end
    if state["灰色护盾Frame"] ~= 0 then
        DzFrameShow(state["灰色护盾Frame"], false)
    end
end
____exports["设置Boss护盾破碎显示"] = function(state)
    if state["护盾图标Frame"] ~= 0 then
        DzFrameShow(state["护盾图标Frame"], false)
    end
    if state["护盾提示文本框Frame"] ~= 0 then
        DzFrameShow(state["护盾提示文本框Frame"], false)
    end
    if state["破碎护盾Frame"] ~= 0 then
        DzFrameShow(state["破碎护盾Frame"], true)
    end
    if state["灰色护盾Frame"] ~= 0 then
        DzFrameShow(state["灰色护盾Frame"], false)
    end
end
____exports["设置Boss护盾灰色显示"] = function(state)
    if state["护盾图标Frame"] ~= 0 then
        DzFrameShow(state["护盾图标Frame"], false)
    end
    if state["护盾提示文本框Frame"] ~= 0 then
        DzFrameShow(state["护盾提示文本框Frame"], false)
    end
    if state["破碎护盾Frame"] ~= 0 then
        DzFrameShow(state["破碎护盾Frame"], false)
    end
    if state["灰色护盾Frame"] ~= 0 then
        DzFrameShow(state["灰色护盾Frame"], true)
    end
end
return ____exports
