--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E_8868 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.04．英雄技能成长系统.00．配置表")
local _____82F1_96C4_6280_80FD_6210_957F_914D_7F6E_8868 = ____00_FF0E_914D_7F6E_8868["英雄技能成长配置表"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSkillLearnListener = ____require_result_0.registerSkillLearnListener
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_1["调整玩家属性"]
local _____8C03_6574_5355_4F4D_5C5E_6027 = ____require_result_1["调整单位属性"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local _____5DF2_521D_59CB_5316 = false
local _____5DF2_5904_7406_6280_80FD_7B49_7EA7 = {}
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetHeroInt = jass.GetHeroInt
local SetHeroInt = jass.SetHeroInt
local function _____53D6_6280_80FD_5904_7406_952E(unit, abilityId)
    return (tostring(GetHandleId(unit)) .. "#") .. tostring(abilityId)
end
local function _____5E94_7528_6210_957F_5C5E_6027(unit, attr, _____7B49_7EA7_589E_91CF, _____662F_5426_9996_6B21)
    local amount = attr["每级增量"] * _____7B49_7EA7_589E_91CF + (_____662F_5426_9996_6B21 and (attr["初始增量"] or 0) or 0)
    if amount == 0 then
        return
    end
    repeat
        local ____switch5 = attr["处理方式"] or "玩家属性"
        local ____cond5 = ____switch5 == "英雄智力"
        if ____cond5 then
            SetHeroInt(
                unit,
                GetHeroInt(unit, false) + amount,
                true
            )
            return
        end
        ____cond5 = ____cond5 or ____switch5 == "来源治疗率"
        if ____cond5 then
            _____8C03_6574_5355_4F4D_5C5E_6027(unit, attr["属性名"] or "治疗率", amount)
            return
        end
        ____cond5 = ____cond5 or ____switch5 == "玩家属性"
        do
            _____8C03_6574_73A9_5BB6_5C5E_6027(unit, attr["属性名"], amount)
            return
        end
    until true
end
local function ____on_82F1_96C4_5B66_4E60_6280_80FD(unit, abilityId)
    if unit == nil or unit == 0 then
        return
    end
    local heroId = jass.GetUnitTypeId(unit)
    do
        local i = 0
        while i < #_____82F1_96C4_6280_80FD_6210_957F_914D_7F6E_8868 do
            do
                local config = _____82F1_96C4_6280_80FD_6210_957F_914D_7F6E_8868[i + 1]
                if heroId ~= stringToFourCCSafe(config["英雄ID"]) then
                    goto __continue9
                end
                if abilityId ~= stringToFourCCSafe(config["技能ID"]) then
                    goto __continue9
                end
                local key = _____53D6_6280_80FD_5904_7406_952E(unit, abilityId)
                local currentLevel = GetUnitAbilityLevel(unit, abilityId)
                local previousLevel = _____5DF2_5904_7406_6280_80FD_7B49_7EA7[key] or 0
                local levelDelta = currentLevel - previousLevel
                if levelDelta <= 0 then
                    return
                end
                local firstLearn = previousLevel == 0
                do
                    local j = 0
                    while j < #config["属性"] do
                        local attr = config["属性"][j + 1]
                        _____5E94_7528_6210_957F_5C5E_6027(unit, attr, levelDelta, firstLearn)
                        j = j + 1
                    end
                end
                _____5DF2_5904_7406_6280_80FD_7B49_7EA7[key] = currentLevel
            end
            ::__continue9::
            i = i + 1
        end
    end
end
____exports["初始化英雄技能成长系统"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    registerSkillLearnListener(____on_82F1_96C4_5B66_4E60_6280_80FD)
end
____exports["初始化英雄技能成长系统"]()
return ____exports
