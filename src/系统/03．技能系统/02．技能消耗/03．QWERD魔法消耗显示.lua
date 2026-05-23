--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local _____83B7_53D6_73A9_5BB6_552F_4E00_9009_4E2D_5355_4F4D = selectionCenterSystem.getSoleSelectedUnitForPlayer
local _____529F_80FD_5F00_5173_6A21_5757 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关")
local heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017 = ____require_result_1["计算最终魔法消耗"]
local _____539F_751F_9B54_6CD5_6D88_8017_540C_6B65_6A21_5757 = require("系统.03．技能系统.02．技能消耗.04．原生魔法消耗同步")
local _____83B7_53D6_5DF2_540C_6B65_6280_80FD_9B54_6CD5_6D88_8017 = _____539F_751F_9B54_6CD5_6D88_8017_540C_6B65_6A21_5757["获取已同步技能魔法消耗"]
local commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位")
local DzGetGameUI = japi.DzGetGameUI
local DzCreateFrameByTagName = japi.DzCreateFrameByTagName
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameSetSize = japi.DzFrameSetSize
local DzFrameSetFont = japi.DzFrameSetFont
local DzFrameSetText = japi.DzFrameSetText
local DzFrameSetTextColor = japi.DzFrameSetTextColor
local DzFrameSetTexture = japi.DzFrameSetTexture
local DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment
local DzFrameShow = japi.DzFrameShow
local REFRESH_MS = 300
local FONT_FILE = "UI\\uizt.ttf"
local FONT_SIZE = 0.01275
local TEXT_W = 0.025
local TEXT_H = 0.01
local ICON_W = 0.009
local ICON_H = 0.009
local ICON_TEXTURE = "UI\\Widgets\\ToolTips\\Human\\ToolTipManaIcon.blp"
local ICON_OFFSET_X = 0.001
local ICON_OFFSET_Y = -0.0012
local TEXT_OFFSET_X = 0.009
local TEXT_OFFSET_Y = -0.0013
local SHADOW_OFFSET_X = 0.0006
local SHADOW_OFFSET_Y = -0.0006
local _____56FA_5B9A_69FD_4F4D_8868 = {Q = {x = 0, y = 2}, W = {x = 1, y = 2}, E = {x = 2, y = 2}, R = {x = 3, y = 2}}
local initialized = false
local _____663E_793A_7F13_5B58 = nil
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
local function _____5B89_5168_8BBE_7F6E_8D34_56FE(frame, texture)
    if not isValidHandle(frame) then
        return
    end
    DzFrameSetTexture(frame, texture, 0)
end
local function _____5B89_5168_8BBE_7F6E_951A_70B9(frame, relativeFrame, x, y)
    if not isValidHandle(frame) or not isValidHandle(relativeFrame) then
        return
    end
    DzFrameSetPoint(
        frame,
        0,
        relativeFrame,
        0,
        x,
        y
    )
end
local function _____8BFB_53D6_73A9_5BB6_552F_4E00_9009_4E2D_5355_4F4D(playerId)
    if type(_____83B7_53D6_73A9_5BB6_552F_4E00_9009_4E2D_5355_4F4D) ~= "function" then
        return nil
    end
    return _____83B7_53D6_73A9_5BB6_552F_4E00_9009_4E2D_5355_4F4D(playerId)
end
local function getHeroSource(localPlayer)
    local playerId = jass.GetPlayerId(localPlayer)
    local selectedUnit = _____8BFB_53D6_73A9_5BB6_552F_4E00_9009_4E2D_5355_4F4D(playerId)
    if not isValidHandle(selectedUnit) then
        return nil
    end
    if jass.IsUnitType(selectedUnit, jass.UNIT_TYPE_HERO) ~= true then
        return nil
    end
    local owner = jass.GetOwningPlayer(selectedUnit)
    if not isValidHandle(owner) then
        return nil
    end
    local registeredHero = heroBridge.getRegisteredPlayerHero(owner)
    if not isValidHandle(registeredHero) then
        return nil
    end
    if registeredHero ~= selectedUnit then
        return nil
    end
    return selectedUnit
end
local function getLocalHero()
    local localPlayer = jass.GetLocalPlayer()
    if not isValidHandle(localPlayer) then
        return nil
    end
    return getHeroSource(localPlayer)
end
local function createBackdrop(name)
    local gameUI = DzGetGameUI()
    if not isValidHandle(gameUI) then
        return 0
    end
    local frame = DzCreateFrameByTagName(
        "BACKDROP",
        name,
        gameUI,
        "template",
        0
    )
    if not isValidHandle(frame) then
        return 0
    end
    DzFrameSetSize(frame, ICON_W, ICON_H)
    DzFrameSetTexture(frame, ICON_TEXTURE, 0)
    DzFrameShow(frame, false)
    return frame
end
local function createText(name, r, g, b, a)
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
    DzFrameSetTextAlignment(frame, 0)
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
local function _____786E_4FDD_663E_793A_7F13_5B58()
    if _____663E_793A_7F13_5B58 ~= nil then
        return _____663E_793A_7F13_5B58
    end
    _____663E_793A_7F13_5B58 = {
        Q = {icon = 0, text = 0, shadow = 0},
        W = {icon = 0, text = 0, shadow = 0},
        E = {icon = 0, text = 0, shadow = 0},
        R = {icon = 0, text = 0, shadow = 0},
        D = {icon = 0, text = 0, shadow = 0}
    }
    return _____663E_793A_7F13_5B58
end
local function formatManaCost(value)
    if not (value > 0.05) then
        return ""
    end
    local tenth = jass.R2I(value * 10 + 0.5)
    local sec = jass.R2I(tenth / 10)
    local decimal = tenth - sec * 10
    if decimal == 0 then
        return jass.I2S(sec)
    end
    return (tostring(jass.I2S(sec)) .. ".") .. tostring(jass.I2S(decimal))
end
local function calcDisplayManaCost(unit, abilityId, level)
    return _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017(unit, abilityId, level)
end
local function _____89E3_6790_69FD_4F4D(whichHero, hotkey)
    if hotkey == "D" then
        local dSlot = commandBarAbility["获取D技能槽位"](whichHero)
        return {x = dSlot[1], y = dSlot[2]}
    end
    return _____56FA_5B9A_69FD_4F4D_8868[hotkey]
end
local function _____83B7_53D6_6309_94AE_6846(whichHero, hotkey)
    local slot = _____89E3_6790_69FD_4F4D(whichHero, hotkey)
    return DzFrameGetCommandBarButton(slot.y, slot.x)
end
local function _____83B7_53D6_6280_80FDId(whichHero, hotkey)
    local slot = _____89E3_6790_69FD_4F4D(whichHero, hotkey)
    return commandBarAbility["读取命令卡按钮能力Id"](slot.x, slot.y)
end
local function _____9690_85CF_5355_5143(ui)
    _____5B89_5168_663E_793A_6846_4F53(ui.icon, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(ui.text, "")
    _____5B89_5168_663E_793A_6846_4F53(ui.text, false)
    _____5B89_5168_8BBE_7F6E_6587_672C(ui.shadow, "")
    _____5B89_5168_663E_793A_6846_4F53(ui.shadow, false)
end
local function toManaText(text)
    if text == "" then
        return ""
    end
    return ("|cffffd24a" .. text) .. "|r"
end
local function toShadowText(text)
    if text == "" then
        return ""
    end
    return ("|cff101010" .. text) .. "|r"
end
local function _____786E_4FDD_6309_94AE_663E_793A_5355_5143(hotkey, ui)
    if not isValidHandle(ui.icon) then
        ui.icon = createBackdrop(("SkillMana" .. hotkey) .. "Icon")
    end
    if not isValidHandle(ui.text) then
        ui.text = createText(
            ("SkillMana" .. hotkey) .. "Text",
            255,
            210,
            74,
            255
        )
    end
    if not isValidHandle(ui.shadow) then
        ui.shadow = createText(
            ("SkillMana" .. hotkey) .. "Shadow",
            16,
            16,
            16,
            255
        )
    end
    return isValidHandle(ui.icon) and isValidHandle(ui.text) and isValidHandle(ui.shadow)
end
local function _____5237_65B0_5355_4E2A_6280_80FD(whichHero, hotkey, ui)
    local buttonFrame = _____83B7_53D6_6309_94AE_6846(whichHero, hotkey)
    if not isValidHandle(buttonFrame) then
        _____9690_85CF_5355_5143(ui)
        return
    end
    if not _____786E_4FDD_6309_94AE_663E_793A_5355_5143(hotkey, ui) then
        return
    end
    local abilityId = _____83B7_53D6_6280_80FDId(whichHero, hotkey)
    if abilityId == 0 then
        _____9690_85CF_5355_5143(ui)
        return
    end
    local level = jass.GetUnitAbilityLevel(whichHero, abilityId)
    if level <= 0 then
        _____9690_85CF_5355_5143(ui)
        return
    end
    local syncedManaCost = _____83B7_53D6_5DF2_540C_6B65_6280_80FD_9B54_6CD5_6D88_8017(whichHero, abilityId)
    local manaCost = syncedManaCost >= 0 and syncedManaCost or calcDisplayManaCost(whichHero, abilityId, level)
    if not (manaCost > 0) then
        _____9690_85CF_5355_5143(ui)
        return
    end
    local text = formatManaCost(manaCost)
    if text == "" then
        _____9690_85CF_5355_5143(ui)
        return
    end
    _____5B89_5168_8BBE_7F6E_951A_70B9(ui.icon, buttonFrame, ICON_OFFSET_X, ICON_OFFSET_Y)
    _____5B89_5168_8BBE_7F6E_951A_70B9(ui.shadow, buttonFrame, TEXT_OFFSET_X + SHADOW_OFFSET_X, TEXT_OFFSET_Y + SHADOW_OFFSET_Y)
    _____5B89_5168_8BBE_7F6E_951A_70B9(ui.text, buttonFrame, TEXT_OFFSET_X, TEXT_OFFSET_Y)
    _____5B89_5168_8BBE_7F6E_8D34_56FE(ui.icon, ICON_TEXTURE)
    _____5B89_5168_663E_793A_6846_4F53(ui.icon, true)
    _____5B89_5168_8BBE_7F6E_6587_672C(
        ui.shadow,
        toShadowText(text)
    )
    _____5B89_5168_663E_793A_6846_4F53(ui.shadow, true)
    _____5B89_5168_8BBE_7F6E_6587_672C(
        ui.text,
        toManaText(text)
    )
    _____5B89_5168_663E_793A_6846_4F53(ui.text, true)
end
local function hideAll()
    if _____663E_793A_7F13_5B58 == nil then
        return
    end
    _____9690_85CF_5355_5143(_____663E_793A_7F13_5B58.Q)
    _____9690_85CF_5355_5143(_____663E_793A_7F13_5B58.W)
    _____9690_85CF_5355_5143(_____663E_793A_7F13_5B58.E)
    _____9690_85CF_5355_5143(_____663E_793A_7F13_5B58.R)
    _____9690_85CF_5355_5143(_____663E_793A_7F13_5B58.D)
end
local function onTick()
    local currentUi = _____786E_4FDD_663E_793A_7F13_5B58()
    if currentUi == nil then
        return
    end
    if _____529F_80FD_5F00_5173_6A21_5757["本地玩家是否开启魔法消耗显示"]() ~= true then
        hideAll()
        return
    end
    local hero = getLocalHero()
    if not isValidHandle(hero) then
        hideAll()
        return
    end
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "Q", currentUi.Q)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "W", currentUi.W)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "E", currentUi.E)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "R", currentUi.R)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "D", currentUi.D)
end
____exports["初始化QWERD魔法消耗显示"] = function()
    if initialized then
        return
    end
    initialized = true
    addPeriodicCallback(REFRESH_MS, onTick)
end
return ____exports
