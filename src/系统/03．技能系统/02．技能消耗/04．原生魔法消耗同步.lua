local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local Player = jass.Player
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local R2I = jass.R2I
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local heroConfigTool = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.01．升级配置表")
local _____83B7_53D6_82F1_96C4_5347_7EA7_914D_7F6E = ____require_result_1["获取英雄升级配置"]
local ____require_result_2 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017 = ____require_result_2["计算最终魔法消耗"]
local platformAbilityAction = require("平台扩展API动作")
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．动态技能数据")
local _____83B7_53D6_52A8_6001_6280_80FD_9B54_8017_767E_5206_6BD4 = ____require_result_4["获取动态技能魔耗百分比"]
local _____6280_80FD__8BBE_7F6E_6280_80FD_9B54_6CD5_6D88_8017 = platformAbilityAction["技能_设置技能魔法消耗"]
local REFRESH_MS = 300
local PLAYER_SYNC_COUNT = 4
local initialized = false
local _____6280_80FD_9B54_6CD5_6D88_8017_7F13_5B58 = {}
local _____82F1_96C4_7C7B_578B_6280_80FD_5217_8868_7F13_5B58 = {}
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
local function _____8FFD_52A0_6280_80FDID(result, seen, rawcode)
    local abilityId = stringToFourCCSafe(rawcode)
    if abilityId == 0 or seen[abilityId] == true then
        return
    end
    seen[abilityId] = true
    result[#result + 1] = abilityId
end
local function _____8FFD_52A0_914D_7F6E_6280_80FD_5B57_6BB5(result, seen, rawList)
    if type(rawList) ~= "string" or rawList == "" then
        return
    end
    local parts = __TS__StringSplit(rawList, ",")
    do
        local i = 0
        while i < #parts do
            _____8FFD_52A0_6280_80FDID(result, seen, parts[i + 1])
            i = i + 1
        end
    end
end
local function _____83B7_53D6_82F1_96C4_786E_5B9A_6027_6280_80FD_5217_8868(whichHero)
    local heroRawcode = heroConfigTool["获取单位英雄Rawcode"](whichHero)
    if heroRawcode == "" then
        return {}
    end
    local cached = _____82F1_96C4_7C7B_578B_6280_80FD_5217_8868_7F13_5B58[heroRawcode]
    if cached ~= nil then
        return cached
    end
    local result = {}
    local seen = {}
    local heroConfig = heroConfigTool["获取单位玩家英雄配置"](whichHero)
    if heroConfig ~= nil then
        _____8FFD_52A0_914D_7F6E_6280_80FD_5B57_6BB5(result, seen, heroConfig.heroAbilList)
        _____8FFD_52A0_914D_7F6E_6280_80FD_5B57_6BB5(result, seen, heroConfig.abilList)
    end
    local upgradeConfig = _____83B7_53D6_82F1_96C4_5347_7EA7_914D_7F6E(heroRawcode)
    local awakeningSkills = upgradeConfig and upgradeConfig.awakeningSkills
    if awakeningSkills ~= nil then
        do
            local i = 0
            while i < #awakeningSkills do
                _____8FFD_52A0_6280_80FDID(result, seen, awakeningSkills[i + 1].abilityId)
                i = i + 1
            end
        end
    end
    local learnedSkills = upgradeConfig and upgradeConfig.learnedSkills
    if learnedSkills ~= nil then
        do
            local i = 0
            while i < #learnedSkills do
                _____8FFD_52A0_6280_80FDID(result, seen, learnedSkills[i + 1].abilityId)
                i = i + 1
            end
        end
    end
    _____82F1_96C4_7C7B_578B_6280_80FD_5217_8868_7F13_5B58[heroRawcode] = result
    return result
end
local function _____53D6_7F13_5B58_952E(unit, abilityId)
    return (tostring(GetHandleId(unit)) .. ":") .. tostring(abilityId)
end
local function _____5199_5165_5355_4E2A_6280_80FD_540C_6B65_7ED3_679C(unit, abilityId, manaCost)
    local cacheKey = _____53D6_7F13_5B58_952E(unit, abilityId)
    if _____6280_80FD_9B54_6CD5_6D88_8017_7F13_5B58[cacheKey] == manaCost then
        return
    end
    local nativeCost = manaCost > 0 and R2I(manaCost + 0.5) or 0
    _____6280_80FD__8BBE_7F6E_6280_80FD_9B54_6CD5_6D88_8017(unit, abilityId, nativeCost)
    _____6280_80FD_9B54_6CD5_6D88_8017_7F13_5B58[cacheKey] = manaCost
end
local function _____540C_6B65_5355_4E2A_6280_80FD(whichHero, abilityId)
    local level = GetUnitAbilityLevel(whichHero, abilityId)
    if level <= 0 then
        return
    end
    local _____914D_7F6E_767E_5206_6BD4 = _____83B7_53D6_52A8_6001_6280_80FD_9B54_8017_767E_5206_6BD4(abilityId)
    local manaCost = _____914D_7F6E_767E_5206_6BD4 >= 0 and (GetUnitStateJapi(whichHero, jass.UNIT_STATE_MAX_MANA) or 0) * _____914D_7F6E_767E_5206_6BD4 or _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017(whichHero, abilityId, level)
    if manaCost < 0 then
        return
    end
    _____5199_5165_5355_4E2A_6280_80FD_540C_6B65_7ED3_679C(whichHero, abilityId, manaCost)
end
local function _____540C_6B65_6CE8_518C_82F1_96C4(hero)
    local abilityIds = _____83B7_53D6_82F1_96C4_786E_5B9A_6027_6280_80FD_5217_8868(hero)
    do
        local i = 0
        while i < #abilityIds do
            _____540C_6B65_5355_4E2A_6280_80FD(hero, abilityIds[i + 1])
            i = i + 1
        end
    end
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
