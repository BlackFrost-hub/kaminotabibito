--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local _____83B7_53D6_5355_4F4D_82F1_96C4Rawcode = ____require_result_0["获取单位英雄Rawcode"]
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.01．升级配置表")
local _____901A_7528_5347_7EA7_989D_5916_5C5E_6027_914D_7F6E = ____require_result_1["通用升级额外属性配置"]
local _____83B7_53D6_82F1_96C4_5347_7EA7_914D_7F6E = ____require_result_1["获取英雄升级配置"]
local UNIT_STATE_ATTACK1_BASE = 18
local UNIT_STATE_MANA_REGEN = 32
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local SetUnitStateJapi = japi.SetUnitState
local function _____5339_914D_989D_5916_5C5E_6027_89C4_5219(unit, rule)
    if rule.onlyMelee == true and jass.IsUnitType(unit, jass.UNIT_TYPE_MELEE_ATTACKER) ~= true then
        return false
    end
    if rule.onlyRanged == true and jass.IsUnitType(unit, jass.UNIT_TYPE_MELEE_ATTACKER) == true then
        return false
    end
    return true
end
local function _____589E_52A0_5355_4F4D_72B6_6001(unit, state, delta)
    local current = jass.GetUnitState(unit, state) or 0
    SetUnitStateJapi(unit, state, current + delta)
end
local function _____5E94_7528_5355_6761_989D_5916_5C5E_6027_89C4_5219(unit, level, rule)
    if rule.repeatEveryLevel == true then
        if level < rule.level then
            return
        end
    elseif rule.level ~= level then
        return
    end
    if not _____5339_914D_989D_5916_5C5E_6027_89C4_5219(unit, rule) then
        return
    end
    if rule.attackBonus ~= nil and rule.attackBonus ~= 0 then
        _____589E_52A0_5355_4F4D_72B6_6001(
            unit,
            jass.ConvertUnitState(UNIT_STATE_ATTACK1_BASE),
            rule.attackBonus
        )
    end
    if rule.manaRegenBonus ~= nil and rule.manaRegenBonus ~= 0 then
        _____589E_52A0_5355_4F4D_72B6_6001(
            unit,
            jass.ConvertUnitState(UNIT_STATE_MANA_REGEN),
            rule.manaRegenBonus
        )
    end
    if rule.maxLifeBonus ~= nil and rule.maxLifeBonus ~= 0 then
        _____589E_52A0_5355_4F4D_72B6_6001(unit, UNIT_STATE_MAX_LIFE, rule.maxLifeBonus)
    end
    if rule.maxManaBonus ~= nil and rule.maxManaBonus ~= 0 then
        _____589E_52A0_5355_4F4D_72B6_6001(unit, UNIT_STATE_MAX_MANA, rule.maxManaBonus)
    end
end
____exports["应用升级额外属性"] = function(whichHero)
    if not whichHero or whichHero == 0 then
        return
    end
    local level = jass.GetHeroLevel(whichHero) or 0
    local heroRawcode = _____83B7_53D6_5355_4F4D_82F1_96C4Rawcode(whichHero)
    local heroConfig = _____83B7_53D6_82F1_96C4_5347_7EA7_914D_7F6E(heroRawcode)
    do
        local i = 0
        while i < #_____901A_7528_5347_7EA7_989D_5916_5C5E_6027_914D_7F6E do
            _____5E94_7528_5355_6761_989D_5916_5C5E_6027_89C4_5219(whichHero, level, _____901A_7528_5347_7EA7_989D_5916_5C5E_6027_914D_7F6E[i + 1])
            i = i + 1
        end
    end
    local rules = heroConfig and heroConfig.extraAttrs
    if rules == nil then
        return
    end
    do
        local i = 0
        while i < #rules do
            _____5E94_7528_5355_6761_989D_5916_5C5E_6027_89C4_5219(whichHero, level, rules[i + 1])
            i = i + 1
        end
    end
end
return ____exports
