--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照")
local _____529F_80FD_5F00_5173_6A21_5757 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关")
local platformAbilityApi = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4 = platformAbilityApi["技能_获取技能当前冷却时间"]
local fourCCTools = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToStringRaw = fourCCTools.fourCCToString
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameShow = japi.DzFrameShow
local DEBUG_FORCE_PLACEHOLDER = true
local REFRESH_MS = 100
local OFFSET_X = 0.01
local OFFSET_Y = 0.006
local SHADOW_OFFSET_X = -0.0012
local SHADOW_OFFSET_Y = -0.0012
local FONT_FILE = "UI\\uizt.ttf"
local FONT_SIZE = 0.02
local TEXT_W = 0.042
local TEXT_H = 0.02
local initialized = false
local _____6587_672C_6846_7F13_5B58 = nil
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
local function _____5B89_5168_8BBE_7F6E_6587_672C(frame, text)
    if not isValidHandle(frame) then
        return
    end
    DzFrameSetText(frame, text)
end
local function _____5B89_5168_663E_793A_6846_4F53(frame, visible)
    if not isValidHandle(frame) then
        return
    end
    DzFrameShow(frame, visible)
end
local function _____5B89_5168_8BBE_7F6E_951A_70B9(frame, relativeFrame, x, y)
    if not isValidHandle(frame) or not isValidHandle(relativeFrame) then
        return
    end
    DzFrameSetPoint(
        frame,
        8,
        relativeFrame,
        8,
        x,
        y
    )
end
local function getLocalHero()
    return selectionSnapshotSystem["获取本地选中技能快照"]().hero
end
local function createTextFrame(name, r, g, b, a)
    local gameUI = DzGetGameUI()
    if not isValidHandle(gameUI) then
        return 0
    end
    local frame = DzCreateFrameByTagName(
        "TEXT",
        name,
        gameUI,
        "template",
        0
    )
    if not isValidHandle(frame) then
        return 0
    end
    DzFrameSetSize(frame, TEXT_W, TEXT_H)
    DzFrameSetText(frame, "")
    DzFrameSetFont(frame, FONT_FILE, FONT_SIZE, 0)
    DzFrameSetTextAlignment(frame, -1)
    DzFrameSetTextAlignment(frame, 8)
    DzFrameSetTextColor(
        frame,
        r,
        g,
        b,
        a
    )
    DzFrameShow(frame, false)
    return frame
end
local function _____786E_4FDD_6587_672C_6846_7F13_5B58()
    if _____6587_672C_6846_7F13_5B58 ~= nil then
        return _____6587_672C_6846_7F13_5B58
    end
    _____6587_672C_6846_7F13_5B58 = {["主文本"] = {
        Q = 0,
        W = 0,
        E = 0,
        R = 0,
        D = 0
    }, ["阴影文本"] = {
        Q = 0,
        W = 0,
        E = 0,
        R = 0,
        D = 0
    }}
    return _____6587_672C_6846_7F13_5B58
end
local function fourCCText(abilityId)
    if abilityId == 0 then
        return "0"
    end
    return fourCCToStringRaw(abilityId)
end
local function getCooldown(whichHero, abilityId)
    if not isValidHandle(whichHero) or abilityId == 0 then
        return 0
    end
    return _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4(whichHero, abilityId) or 0
end
local function formatCooldown(cooldown)
    if not (cooldown > 0.05) then
        return ""
    end
    local tenth = jass.R2I(cooldown * 10 + 0.5)
    local sec = jass.R2I(tenth / 10)
    local decimal = tenth - sec * 10
    return (tostring(jass.I2S(sec)) .. ".") .. tostring(jass.I2S(decimal))
end
local function toWhiteText(text)
    if text == "" then
        return ""
    end
    return ("|cfffff2d8" .. text) .. "|r"
end
local function toShadowText(text)
    if text == "" then
        return ""
    end
    return ("|cff101010" .. text) .. "|r"
end
local function _____6784_5EFA_663E_793A_6587_672C(hotkey, abilityId, cooldown)
    local cdText = formatCooldown(cooldown)
    if cdText ~= "" then
        return cdText
    end
    if DEBUG_FORCE_PLACEHOLDER and abilityId ~= 0 then
        return hotkey
    end
    return ""
end
local function _____83B7_53D6_6309_94AE_6846(hotkey)
    local slot = selectionSnapshotSystem["获取本地选中技能快照"]().slots[hotkey]
    return DzFrameGetCommandBarButton(slot.y, slot.x)
end
local function _____83B7_53D6_6280_80FDId(hotkey)
    return selectionSnapshotSystem["获取本地选中技能快照"]().skills[hotkey]
end
local function _____5237_65B0_5355_4E2A_6280_80FD(whichHero, hotkey, textFrame, shadowFrame)
    local buttonFrame = _____83B7_53D6_6309_94AE_6846(hotkey)
    if not isValidHandle(buttonFrame) then
        _____5B89_5168_8BBE_7F6E_6587_672C(textFrame, "")
        _____5B89_5168_663E_793A_6846_4F53(textFrame, false)
        _____5B89_5168_8BBE_7F6E_6587_672C(shadowFrame, "")
        _____5B89_5168_663E_793A_6846_4F53(shadowFrame, false)
        return
    end
    local currentTextFrame = textFrame
    local currentShadowFrame = shadowFrame
    if not isValidHandle(currentTextFrame) then
        currentTextFrame = createTextFrame(
            ("SkillCooldown" .. hotkey) .. "Text2",
            255,
            242,
            216,
            255
        )
        if not isValidHandle(currentTextFrame) then
            return
        end
        if _____6587_672C_6846_7F13_5B58 ~= nil then
            _____6587_672C_6846_7F13_5B58["主文本"][hotkey] = currentTextFrame
        end
    end
    if not isValidHandle(currentShadowFrame) then
        currentShadowFrame = createTextFrame(
            ("SkillCooldown" .. hotkey) .. "Shadow2",
            16,
            16,
            16,
            255
        )
        if not isValidHandle(currentShadowFrame) then
            return
        end
        if _____6587_672C_6846_7F13_5B58 ~= nil then
            _____6587_672C_6846_7F13_5B58["阴影文本"][hotkey] = currentShadowFrame
        end
    end
    _____5B89_5168_8BBE_7F6E_951A_70B9(currentShadowFrame, buttonFrame, OFFSET_X + SHADOW_OFFSET_X, OFFSET_Y + SHADOW_OFFSET_Y)
    _____5B89_5168_8BBE_7F6E_951A_70B9(currentTextFrame, buttonFrame, OFFSET_X, OFFSET_Y)
    local abilityId = _____83B7_53D6_6280_80FDId(hotkey)
    if abilityId == 0 then
        _____5B89_5168_8BBE_7F6E_6587_672C(currentTextFrame, "")
        _____5B89_5168_663E_793A_6846_4F53(currentTextFrame, false)
        _____5B89_5168_8BBE_7F6E_6587_672C(currentShadowFrame, "")
        _____5B89_5168_663E_793A_6846_4F53(currentShadowFrame, false)
        return
    end
    local cooldown = getCooldown(whichHero, abilityId)
    local text = _____6784_5EFA_663E_793A_6587_672C(hotkey, abilityId, cooldown)
    _____5B89_5168_8BBE_7F6E_6587_672C(
        currentShadowFrame,
        toShadowText(text)
    )
    _____5B89_5168_663E_793A_6846_4F53(currentShadowFrame, text ~= "")
    _____5B89_5168_8BBE_7F6E_6587_672C(
        currentTextFrame,
        toWhiteText(text)
    )
    _____5B89_5168_663E_793A_6846_4F53(currentTextFrame, text ~= "")
end
local function hideAll()
    if _____6587_672C_6846_7F13_5B58 == nil then
        return
    end
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["主文本"].Q, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["主文本"].Q, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["主文本"].W, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["主文本"].W, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["主文本"].E, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["主文本"].E, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["主文本"].R, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["主文本"].R, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["主文本"].D, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["主文本"].D, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["阴影文本"].Q, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["阴影文本"].Q, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["阴影文本"].W, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["阴影文本"].W, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["阴影文本"].E, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["阴影文本"].E, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["阴影文本"].R, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["阴影文本"].R, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(_____6587_672C_6846_7F13_5B58["阴影文本"].D, "")
    _____5B89_5168_663E_793A_6846_4F53(_____6587_672C_6846_7F13_5B58["阴影文本"].D, false)
end
local function onTick()
    local currentFrames = _____786E_4FDD_6587_672C_6846_7F13_5B58()
    if currentFrames == nil then
        return
    end
    if _____529F_80FD_5F00_5173_6A21_5757["本地玩家是否开启冷却显示"]() ~= true then
        hideAll()
        return
    end
    local hero = getLocalHero()
    if not isValidHandle(hero) then
        hideAll()
        return
    end
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "Q", currentFrames["主文本"].Q, currentFrames["阴影文本"].Q)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "W", currentFrames["主文本"].W, currentFrames["阴影文本"].W)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "E", currentFrames["主文本"].E, currentFrames["阴影文本"].E)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "R", currentFrames["主文本"].R, currentFrames["阴影文本"].R)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "D", currentFrames["主文本"].D, currentFrames["阴影文本"].D)
end
____exports["获取QWERD冷却调试快照"] = function()
    local hero = getLocalHero()
    if not isValidHandle(hero) then
        return "NO_HERO"
    end
    local qId = _____83B7_53D6_6280_80FDId("Q")
    local wId = _____83B7_53D6_6280_80FDId("W")
    local eId = _____83B7_53D6_6280_80FDId("E")
    local rId = _____83B7_53D6_6280_80FDId("R")
    local dId = _____83B7_53D6_6280_80FDId("D")
    local qCd = getCooldown(hero, qId)
    local wCd = getCooldown(hero, wId)
    local eCd = getCooldown(hero, eId)
    local rCd = getCooldown(hero, rId)
    local dCd = getCooldown(hero, dId)
    return table.concat(
        {
            "hero=" .. tostring(hero),
            (("Q=" .. fourCCText(qId)) .. "/") .. _____6784_5EFA_663E_793A_6587_672C("Q", qId, qCd),
            (("W=" .. fourCCText(wId)) .. "/") .. _____6784_5EFA_663E_793A_6587_672C("W", wId, wCd),
            (("E=" .. fourCCText(eId)) .. "/") .. _____6784_5EFA_663E_793A_6587_672C("E", eId, eCd),
            (("R=" .. fourCCText(rId)) .. "/") .. _____6784_5EFA_663E_793A_6587_672C("R", rId, rCd),
            (("D=" .. fourCCText(dId)) .. "/") .. _____6784_5EFA_663E_793A_6587_672C("D", dId, dCd)
        },
        " "
    )
end
____exports["初始化QWERD冷却显示"] = function()
    if initialized then
        return
    end
    initialized = true
    selectionSnapshotSystem["初始化本地选中技能快照"]()
    addPeriodicCallback(REFRESH_MS, onTick)
end
return ____exports
