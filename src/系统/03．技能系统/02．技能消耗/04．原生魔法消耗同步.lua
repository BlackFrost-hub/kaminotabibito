--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local Player = jass.Player
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local R2I = jass.R2I
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017 = ____require_result_1["计算最终魔法消耗"]
local platformAbilityAction = require("平台扩展API动作")
local commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位")
local _____6280_80FD__8BBE_7F6E_6280_80FD_9B54_6CD5_6D88_8017 = platformAbilityAction["技能_设置技能魔法消耗"]
local REFRESH_MS = 300
local PLAYER_SYNC_COUNT = 4
local _____56FA_5B9A_69FD_4F4D_8868 = {Q = {x = 0, y = 2}, W = {x = 1, y = 2}, E = {x = 2, y = 2}, R = {x = 3, y = 2}}
local initialized = false
local _____6280_80FD_9B54_6CD5_6D88_8017_7F13_5B58 = {}
local function isValidHandle(handle)
    return handle ~= nil and handle ~= 0
end
local function _____83B7_53D6_6CE8_518C_73A9_5BB6_82F1_96C4(playerId)
    local whichPlayer = Player(playerId)
    if not isValidHandle(whichPlayer) then
        return nil
    end
    local hero = heroBridge.getRegisteredPlayerHero(whichPlayer)
    if not isValidHandle(hero) then
        return nil
    end
    return hero
end
local function _____89E3_6790_69FD_4F4D(whichHero, hotkey)
    if hotkey == "D" then
        local dSlot = commandBarAbility["获取D技能槽位"](whichHero)
        return {x = dSlot[1], y = dSlot[2]}
    end
    return _____56FA_5B9A_69FD_4F4D_8868[hotkey]
end
local function _____83B7_53D6_6280_80FDId(whichHero, hotkey)
    local slot = _____89E3_6790_69FD_4F4D(whichHero, hotkey)
    return commandBarAbility["读取命令卡按钮能力Id"](slot.x, slot.y)
end
local function _____53D6_7F13_5B58_952E(unit, abilityId)
    return (tostring(GetHandleId(unit)) .. ":") .. tostring(abilityId)
end
local function _____5199_5165_5355_4E2A_6280_80FD_540C_6B65_7ED3_679C(unit, abilityId, manaCost)
    local nativeCost = manaCost > 0 and R2I(manaCost + 0.5) or 0
    _____6280_80FD__8BBE_7F6E_6280_80FD_9B54_6CD5_6D88_8017(unit, abilityId, nativeCost)
    _____6280_80FD_9B54_6CD5_6D88_8017_7F13_5B58[_____53D6_7F13_5B58_952E(unit, abilityId)] = manaCost
end
local function _____540C_6B65_5355_4E2A_70ED_952E_6280_80FD(whichHero, hotkey)
    local abilityId = _____83B7_53D6_6280_80FDId(whichHero, hotkey)
    if abilityId == 0 then
        return
    end
    local level = GetUnitAbilityLevel(whichHero, abilityId)
    if level <= 0 then
        return
    end
    local manaCost = _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017(whichHero, abilityId, level)
    if manaCost < 0 then
        return
    end
    _____5199_5165_5355_4E2A_6280_80FD_540C_6B65_7ED3_679C(whichHero, abilityId, manaCost)
end
local function _____540C_6B65_6CE8_518C_82F1_96C4(hero)
    _____540C_6B65_5355_4E2A_70ED_952E_6280_80FD(hero, "Q")
    _____540C_6B65_5355_4E2A_70ED_952E_6280_80FD(hero, "W")
    _____540C_6B65_5355_4E2A_70ED_952E_6280_80FD(hero, "E")
    _____540C_6B65_5355_4E2A_70ED_952E_6280_80FD(hero, "R")
    _____540C_6B65_5355_4E2A_70ED_952E_6280_80FD(hero, "D")
end
local function onSyncTick()
    do
        local playerId = 0
        while playerId < PLAYER_SYNC_COUNT do
            local hero = _____83B7_53D6_6CE8_518C_73A9_5BB6_82F1_96C4(playerId)
            if isValidHandle(hero) then
                _____540C_6B65_6CE8_518C_82F1_96C4(hero)
            end
            playerId = playerId + 1
        end
    end
end
____exports["获取已同步技能魔法消耗"] = function(unit, abilityId)
    if not isValidHandle(unit) or abilityId == 0 then
        return -1
    end
    return _____6280_80FD_9B54_6CD5_6D88_8017_7F13_5B58[_____53D6_7F13_5B58_952E(unit, abilityId)] or -1
end
____exports["初始化原生魔法消耗同步"] = function()
    if initialized then
        return
    end
    initialized = true
    addPeriodicCallback(REFRESH_MS, onSyncTick)
end
return ____exports
