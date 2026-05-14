--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local _____83B7_53D6_5355_4F4D_82F1_96C4Rawcode = ____require_result_1["获取单位英雄Rawcode"]
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.02．英雄升级系统.01．升级配置表")
local _____83B7_53D6_82F1_96C4_5347_7EA7_914D_7F6E = ____require_result_2["获取英雄升级配置"]
____exports["应用提升等级学习技能"] = function(whichHero)
    if not whichHero or whichHero == 0 then
        return
    end
    local level = jass:GetHeroLevel(whichHero) or 0
    local heroRawcode = _____83B7_53D6_5355_4F4D_82F1_96C4Rawcode(whichHero)
    local heroConfig = _____83B7_53D6_82F1_96C4_5347_7EA7_914D_7F6E(heroRawcode)
    local rules = heroConfig and heroConfig.learnedSkills
    if rules == nil then
        return
    end
    do
        local i = 0
        while i < #rules do
            do
                local rule = rules[i + 1]
                if rule.level ~= level then
                    goto __continue6
                end
                local abilityId = stringToFourCC(nil, rule.abilityId)
                if abilityId == 0 then
                    goto __continue6
                end
                if jass:GetUnitAbilityLevel(whichHero, abilityId) <= 0 then
                    jass:UnitAddAbility(whichHero, abilityId)
                end
                if rule.targetLevel ~= nil and rule.targetLevel > 0 then
                    jass:SetUnitAbilityLevel(whichHero, abilityId, rule.targetLevel)
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
end
return ____exports
