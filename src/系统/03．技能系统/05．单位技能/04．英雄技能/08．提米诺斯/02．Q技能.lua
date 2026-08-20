--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00．配置")
local _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["提米诺斯单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00A．表现工具")
local _____64AD_653E_63D0_7C73_8BFA_65AF_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放提米诺斯单位音效"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017 = ____require_result_1["计算最终魔法消耗"]
local getAbilityManaCost = ____require_result_1.getAbilityManaCost
local getAbilityPercentCost = ____require_result_1.getAbilityPercentCost
local getManaCostReduction = ____require_result_1.getManaCostReduction
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local spellHeal = ____require_result_2.spellHeal
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_3.getUnitsInRange
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local createTimedUnitEffect = ____require_result_5.createTimedUnitEffect
local ____Q_6280_80FDID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local _____63D0_7C73_8BFA_65AF_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local function _____53D6_6709_6548_9B54_8017(caster, level)
    local fixedCost = getAbilityManaCost(caster, ____Q_6280_80FDID, level)
    local percentCost = getAbilityPercentCost(caster, ____Q_6280_80FDID, level)
    local maxMana = japi.GetUnitState(caster, jass.UNIT_STATE_MAX_MANA)
    local reduction = getManaCostReduction(caster)
    local reductionRatio = reduction < 0 and -reduction or reduction
    local calculatedCost = _____8BA1_7B97_6700_7EC8_9B54_6CD5_6D88_8017(caster, ____Q_6280_80FDID, level)
    local cost = calculatedCost
    if not (cost >= 0) and fixedCost >= 0 and percentCost >= 0 and percentCost < 0.9 then
        local rawCost = fixedCost + maxMana * percentCost
        cost = reductionRatio < 1 and rawCost * (1 - reductionRatio) or 0
    end
    return cost
end
local function ____on_63D0_7C73_8BFA_65AFQ(caster, abilityId)
    if abilityId ~= ____Q_6280_80FDID then
        return
    end
    local casterTypeId = jass.GetUnitTypeId(caster)
    if casterTypeId ~= _____63D0_7C73_8BFA_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local cfg = _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.Q
    local level = jass.GetUnitAbilityLevel(caster, ____Q_6280_80FDID)
    _____64AD_653E_63D0_7C73_8BFA_65AF_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    local casterX = jass.GetUnitX(caster)
    local casterY = jass.GetUnitY(caster)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["主体特效模型"],
        X = casterX,
        Y = casterY,
        Z = cfg["主体特效Z"],
        ["缩放"] = cfg["主体特效缩放"],
        ["持续秒"] = cfg["主体特效持续秒"]
    })
    local cost = _____53D6_6709_6548_9B54_8017(caster, level)
    if not (cost > 0) then
        return
    end
    local owner = jass.GetOwningPlayer(caster)
    local units = getUnitsInRange(casterX, casterY, cfg["范围"])
    do
        local i = 0
        while i < #units do
            do
                local target = units[i + 1]
                local currentLife = jass.GetUnitState(target, jass.UNIT_STATE_LIFE)
                local maxLife = japi.GetUnitState(target, jass.UNIT_STATE_MAX_LIFE)
                if target ~= caster and jass.IsUnitAlly(target, owner) ~= true then
                    goto __continue9
                end
                if not (currentLife > 0.405) then
                    goto __continue9
                end
                if jass.IsUnitType(target, jass.UNIT_TYPE_ANCIENT) == true then
                    goto __continue9
                end
                if jass.IsUnitType(target, jass.UNIT_TYPE_MECHANICAL) == true then
                    goto __continue9
                end
                if jass.IsUnitType(target, jass.UNIT_TYPE_STRUCTURE) == true then
                    goto __continue9
                end
                if currentLife >= maxLife then
                    goto __continue9
                end
                spellHeal(caster, target, cost * cfg["实际魔耗治疗倍率"], false)
                do
                    local j = 0
                    while j < #cfg["特效"] do
                        local effectCfg = cfg["特效"][j + 1]
                        createTimedUnitEffect(target, effectCfg["挂点"], effectCfg["模型"], cfg["特效持续秒"])
                        j = j + 1
                    end
                end
            end
            ::__continue9::
            i = i + 1
        end
    end
end
registerSpellEffectListener(____on_63D0_7C73_8BFA_65AFQ)
return ____exports
