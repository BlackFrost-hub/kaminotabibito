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
local _____51B7_5374_6570_5B57_6587_672C_6A21_5757 = require("系统.09．表现系统.01．UI工具.06．冷却数字文本")
local _____521B_5EFA_51B7_5374_6570_5B57_6587_672C_7EC4 = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["创建冷却数字文本组"]
local _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C_951A_70B9 = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["设置冷却数字文本锚点"]
local _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["设置冷却数字文本"]
local _____663E_793A_51B7_5374_6570_5B57_6587_672C = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["显示冷却数字文本"]
local DzGetGameUI = japi.DzGetGameUI
local DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton
local DEBUG_FORCE_PLACEHOLDER = true
local REFRESH_MS = 100
local OFFSET_X = 0.01
local OFFSET_Y = 0.006
local FONT_SIZE = 0.02
local TEXT_W = 0.042
local TEXT_H = 0.02
local initialized = false
local _____6587_672C_7EC4_7F13_5B58 = nil
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
local function getLocalHero()
    return selectionSnapshotSystem["获取本地选中技能快照"]().hero
end
local function createTextGroup(name)
    local gameUI = DzGetGameUI()
    if not isValidHandle(gameUI) then
        return nil
    end
    return _____521B_5EFA_51B7_5374_6570_5B57_6587_672C_7EC4({
        ["名称前缀"] = name,
        ["父级"] = gameUI,
        ["宽度"] = TEXT_W,
        ["高度"] = TEXT_H,
        ["字体大小"] = FONT_SIZE,
        ["优先级"] = 0,
        ["对齐"] = 8,
        ["层"] = _____51B7_5374_6570_5B57_6587_672C_6A21_5757["技能冷却数字层"]
    })
end
local function _____786E_4FDD_6587_672C_7EC4_7F13_5B58()
    if _____6587_672C_7EC4_7F13_5B58 ~= nil then
        return _____6587_672C_7EC4_7F13_5B58
    end
    _____6587_672C_7EC4_7F13_5B58 = {
        Q = nil,
        W = nil,
        E = nil,
        R = nil,
        D = nil
    }
    return _____6587_672C_7EC4_7F13_5B58
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
local function _____5237_65B0_5355_4E2A_6280_80FD(whichHero, hotkey, textGroup)
    local buttonFrame = _____83B7_53D6_6309_94AE_6846(hotkey)
    if not isValidHandle(buttonFrame) then
        _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(textGroup, "")
        _____663E_793A_51B7_5374_6570_5B57_6587_672C(textGroup, false)
        return
    end
    local currentTextGroup = textGroup
    if currentTextGroup == nil then
        currentTextGroup = createTextGroup("SkillCooldown" .. hotkey)
        if currentTextGroup == nil then
            return
        end
        if _____6587_672C_7EC4_7F13_5B58 ~= nil then
            _____6587_672C_7EC4_7F13_5B58[hotkey] = currentTextGroup
        end
    end
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C_951A_70B9(
        currentTextGroup,
        buttonFrame,
        8,
        8,
        OFFSET_X,
        OFFSET_Y
    )
    local abilityId = _____83B7_53D6_6280_80FDId(hotkey)
    if abilityId == 0 then
        _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(currentTextGroup, "")
        _____663E_793A_51B7_5374_6570_5B57_6587_672C(currentTextGroup, false)
        return
    end
    local cooldown = getCooldown(whichHero, abilityId)
    local text = _____6784_5EFA_663E_793A_6587_672C(hotkey, abilityId, cooldown)
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(currentTextGroup, text)
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(currentTextGroup, text ~= "")
end
local function hideAll()
    if _____6587_672C_7EC4_7F13_5B58 == nil then
        return
    end
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.Q, "")
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.Q, false)
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.W, "")
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.W, false)
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.E, "")
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.E, false)
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.R, "")
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.R, false)
    _____8BBE_7F6E_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.D, "")
    _____663E_793A_51B7_5374_6570_5B57_6587_672C(_____6587_672C_7EC4_7F13_5B58.D, false)
end
local function onTick()
    local currentGroups = _____786E_4FDD_6587_672C_7EC4_7F13_5B58()
    if currentGroups == nil then
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
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "Q", currentGroups.Q)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "W", currentGroups.W)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "E", currentGroups.E)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "R", currentGroups.R)
    _____5237_65B0_5355_4E2A_6280_80FD(hero, "D", currentGroups.D)
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
