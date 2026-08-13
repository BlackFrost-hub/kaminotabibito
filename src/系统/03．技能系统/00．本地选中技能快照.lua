--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local _____73A9_5BB6_7CFB_7EDF_5E38_91CF = require("系统.00．核心系统.00．玩家系统.00．常量")
local selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位")
local _____83B7_53D6_73A9_5BB6_552F_4E00_9009_4E2D_5355_4F4D = selectionCenterSystem.getSoleSelectedUnitForPlayer
local _____56FA_5B9A_69FD_4F4D_8868 = {Q = {x = 0, y = 2}, W = {x = 1, y = 2}, E = {x = 2, y = 2}, R = {x = 3, y = 2}}
local REFRESH_MS = 100
local initialized = false
local _____5F53_524D_5FEB_7167 = {hero = nil, skills = {
    Q = 0,
    W = 0,
    E = 0,
    R = 0,
    D = 0
}, slots = {
    Q = {x = 0, y = 2},
    W = {x = 1, y = 2},
    E = {x = 2, y = 2},
    R = {x = 3, y = 2},
    D = {x = 3, y = 1}
}}
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
local function _____6E05_7A7A_5FEB_7167()
    _____5F53_524D_5FEB_7167.hero = nil
    _____5F53_524D_5FEB_7167.skills.Q = 0
    _____5F53_524D_5FEB_7167.skills.W = 0
    _____5F53_524D_5FEB_7167.skills.E = 0
    _____5F53_524D_5FEB_7167.skills.R = 0
    _____5F53_524D_5FEB_7167.skills.D = 0
    _____5F53_524D_5FEB_7167.slots.Q = {x = 0, y = 2}
    _____5F53_524D_5FEB_7167.slots.W = {x = 1, y = 2}
    _____5F53_524D_5FEB_7167.slots.E = {x = 2, y = 2}
    _____5F53_524D_5FEB_7167.slots.R = {x = 3, y = 2}
    _____5F53_524D_5FEB_7167.slots.D = {x = 3, y = 1}
end
local function _____8BFB_53D6_73A9_5BB6_552F_4E00_9009_4E2D_82F1_96C4(playerId)
    if type(_____83B7_53D6_73A9_5BB6_552F_4E00_9009_4E2D_5355_4F4D) ~= "function" then
        return nil
    end
    local selectedUnit = _____83B7_53D6_73A9_5BB6_552F_4E00_9009_4E2D_5355_4F4D(playerId)
    if not isValidHandle(selectedUnit) then
        return nil
    end
    if jass:IsUnitType(selectedUnit, jass.UNIT_TYPE_HERO) ~= true then
        return nil
    end
    return selectedUnit
end
local function _____83B7_53D6_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(whichPlayer)
    if not isValidHandle(whichPlayer) then
        return nil
    end
    local hero = YDUserDataGetSafe("player", whichPlayer, _____73A9_5BB6_7CFB_7EDF_5E38_91CF.YD_ATTR_PLAYER_HERO_UNIT, "unit")
    local ____isValidHandle_result_2
    if isValidHandle(hero) then
        ____isValidHandle_result_2 = hero
    else
        ____isValidHandle_result_2 = nil
    end
    return ____isValidHandle_result_2
end
local function _____83B7_53D6_672C_5730_5F53_524D_9009_4E2D_82F1_96C4()
    local localPlayer = jass:GetLocalPlayer()
    if not isValidHandle(localPlayer) then
        return nil
    end
    local selectedHero = _____8BFB_53D6_73A9_5BB6_552F_4E00_9009_4E2D_82F1_96C4(jass:GetPlayerId(localPlayer))
    if not isValidHandle(selectedHero) then
        return nil
    end
    local owner = jass:GetOwningPlayer(selectedHero)
    if not isValidHandle(owner) then
        return nil
    end
    local registeredHero = _____83B7_53D6_5DF2_6CE8_518C_73A9_5BB6_82F1_96C4(owner)
    if not isValidHandle(registeredHero) then
        return nil
    end
    if registeredHero ~= selectedHero then
        return nil
    end
    return selectedHero
end
local function _____5237_65B0_5FEB_7167()
    local hero = _____83B7_53D6_672C_5730_5F53_524D_9009_4E2D_82F1_96C4()
    if not isValidHandle(hero) then
        _____6E05_7A7A_5FEB_7167()
        return
    end
    _____5F53_524D_5FEB_7167.hero = hero
    _____5F53_524D_5FEB_7167.slots.Q = _____56FA_5B9A_69FD_4F4D_8868.Q
    _____5F53_524D_5FEB_7167.slots.W = _____56FA_5B9A_69FD_4F4D_8868.W
    _____5F53_524D_5FEB_7167.slots.E = _____56FA_5B9A_69FD_4F4D_8868.E
    _____5F53_524D_5FEB_7167.slots.R = _____56FA_5B9A_69FD_4F4D_8868.R
    local dSlot = commandBarAbility["获取D技能槽位"](hero)
    _____5F53_524D_5FEB_7167.slots.D = {x = dSlot[1], y = dSlot[2]}
    _____5F53_524D_5FEB_7167.skills.Q = commandBarAbility["读取命令卡按钮能力Id"](_____5F53_524D_5FEB_7167.slots.Q.x, _____5F53_524D_5FEB_7167.slots.Q.y)
    _____5F53_524D_5FEB_7167.skills.W = commandBarAbility["读取命令卡按钮能力Id"](_____5F53_524D_5FEB_7167.slots.W.x, _____5F53_524D_5FEB_7167.slots.W.y)
    _____5F53_524D_5FEB_7167.skills.E = commandBarAbility["读取命令卡按钮能力Id"](_____5F53_524D_5FEB_7167.slots.E.x, _____5F53_524D_5FEB_7167.slots.E.y)
    _____5F53_524D_5FEB_7167.skills.R = commandBarAbility["读取命令卡按钮能力Id"](_____5F53_524D_5FEB_7167.slots.R.x, _____5F53_524D_5FEB_7167.slots.R.y)
    _____5F53_524D_5FEB_7167.skills.D = commandBarAbility["读取命令卡按钮能力Id"](_____5F53_524D_5FEB_7167.slots.D.x, _____5F53_524D_5FEB_7167.slots.D.y)
end
____exports["获取本地选中技能快照"] = function()
    return _____5F53_524D_5FEB_7167
end
____exports["初始化本地选中技能快照"] = function()
    if initialized then
        return
    end
    initialized = true
    _____5237_65B0_5FEB_7167()
    addPeriodicCallback(REFRESH_MS, _____5237_65B0_5FEB_7167)
end
return ____exports
