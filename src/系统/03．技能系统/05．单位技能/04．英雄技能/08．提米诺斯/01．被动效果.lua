--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00．配置")
local _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["提米诺斯单位技能配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.01．属性读取")
local getRealAttr = ____require_result_1.getRealAttr
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local _____63D0_7C73_8BFA_65AF_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local ____E_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["E技能ID"])
local _____5DF2_6CE8_518C = false
local function _____63D0_7C73_8BFA_65AF_5149_5F31_70B9_4F24_5BB3_4FEE_6B63(context)
    local ____opt_result_5
    if context ~= nil then
        ____opt_result_5 = context.currentDamage
    end
    local ____opt_result_5_6 = ____opt_result_5
    if ____opt_result_5_6 == nil then
        ____opt_result_5_6 = 0
    end
    local damage = ____opt_result_5_6
    local ____opt_result_9
    if context ~= nil then
        ____opt_result_9 = context.attacker
    end
    local attacker = ____opt_result_9
    local ____opt_result_12
    if context ~= nil then
        ____opt_result_12 = context.target
    end
    local target = ____opt_result_12
    if not (damage > 0) or attacker == nil or target == nil then
        return damage
    end
    local ____temp_16 = jass.GetUnitTypeId(attacker) ~= _____63D0_7C73_8BFA_65AF_5355_4F4D_7C7B_578BID
    if not ____temp_16 then
        local ____opt_result_15
        if context ~= nil then
            ____opt_result_15 = context.isLightDamage
        end
        ____temp_16 = ____opt_result_15 ~= true
    end
    if ____temp_16 then
        return damage
    end
    if getRealAttr(target, "光属性抗性", 0) >= 0 then
        return damage
    end
    local level = jass.GetUnitAbilityLevel(attacker, ____E_6280_80FD_7C7B_578BID)
    if not (level > 0) then
        return damage
    end
    return damage * (1 + level * _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.E["光弱点额外增伤"])
end
____exports["注册提米诺斯被动"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerDamageModifier(_____63D0_7C73_8BFA_65AF_5149_5F31_70B9_4F24_5BB3_4FEE_6B63, 5)
end
____exports["注册提米诺斯被动"]()
return ____exports
