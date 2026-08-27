--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.09．欧菲莉亚.00．配置")
local _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["欧菲莉亚单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.09．欧菲莉亚.00A．表现工具")
local _____64AD_653E_6B27_83F2_8389_4E9A_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放欧菲莉亚单位音效"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local spellHeal = ____require_result_3.spellHeal
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_4.registerSpellEffectListener
local _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____6B27_83F2_8389_4E9AQ_6280_80FDID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["Q技能ID"])
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local IsUnitType = jass.IsUnitType
local function _____6B27_83F2_8389_4E9AQ_76EE_6807_5408_6CD5(caster, target, owner)
    if target == nil or target == 0 or not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if target ~= caster and jass:IsUnitAlly(target, owner) ~= true then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_ANCIENT) == true then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_MECHANICAL) == true then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_STRUCTURE) == true then
        return false
    end
    local currentLife = GetUnitState(target, jass.UNIT_STATE_LIFE)
    local maxLife = GetUnitStateJapi(target, jass.UNIT_STATE_MAX_LIFE)
    return currentLife > 0.405 and maxLife > currentLife
end
local function _____5904_7406_6B27_83F2_8389_4E9AQ(caster, abilityId)
    if abilityId ~= _____6B27_83F2_8389_4E9AQ_6280_80FDID or GetUnitTypeId(caster) ~= _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local cfg = _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.Q
    local level = GetUnitAbilityLevel(caster, _____6B27_83F2_8389_4E9AQ_6280_80FDID)
    _____64AD_653E_6B27_83F2_8389_4E9A_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["主体特效模型"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        Z = cfg["主体特效Z"],
        ["缩放"] = cfg["主体特效缩放"],
        ["持续秒"] = cfg["主体特效持续秒"]
    })
    local lifeAmount = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (cfg["基础治疗攻击力倍率"] + cfg["每级治疗攻击力倍率"] * level)
    local manaAmount = cfg["每级额外魔法恢复"] * level
    local owner = jass:GetOwningPlayer(caster)
    local targets = getUnitsInRange(
        GetUnitX(caster),
        GetUnitY(caster),
        cfg["范围"]
    )
    do
        local i = 0
        while i < #targets do
            do
                local target = targets[i + 1]
                if not _____6B27_83F2_8389_4E9AQ_76EE_6807_5408_6CD5(caster, target, owner) then
                    goto __continue11
                end
                spellHeal(
                    caster,
                    target,
                    lifeAmount,
                    false,
                    nil,
                    target == caster and 0 or manaAmount,
                    false
                )
                do
                    local j = 0
                    while j < #cfg["特效"] do
                        local effect = cfg["特效"][j + 1]
                        _____521B_5EFA_70B9_7279_6548({
                            ["模型路径"] = effect["模型"],
                            X = GetUnitX(target),
                            Y = GetUnitY(target),
                            Z = effect.Z,
                            ["Z轴角度"] = effect["Z轴角度"],
                            ["缩放"] = effect["缩放"],
                            ["持续秒"] = cfg["特效持续秒"]
                        })
                        j = j + 1
                    end
                end
            end
            ::__continue11::
            i = i + 1
        end
    end
end
registerSpellEffectListener(_____5904_7406_6B27_83F2_8389_4E9AQ)
return ____exports
