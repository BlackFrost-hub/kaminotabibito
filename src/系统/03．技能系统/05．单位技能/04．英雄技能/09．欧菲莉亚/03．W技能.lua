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
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_2.getEnemyUnitsInRange
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_4.registerSpellEffectListener
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_5["造成单体技能伤害"]
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成批量AOE技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_5["创建独立技能伤害实例"]
local _____7ED1_5B9A_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_5["绑定单位当前独立技能伤害实例"]
local _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____6B27_83F2_8389_4E9AW_6280_80FDID = stringToFourCCSafe(_____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"])
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local function _____6B27_83F2_8389_4E9AW_76EE_6807_53EF_53D7_4F24(unit)
    return _____5355_4F4D_5B58_6D3B(unit) and IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) ~= true and IsUnitType(unit, jass.UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE) ~= true
end
local function _____5904_7406_6B27_83F2_8389_4E9AW(caster, abilityId)
    if abilityId ~= _____6B27_83F2_8389_4E9AW_6280_80FDID or GetUnitTypeId(caster) ~= _____6B27_83F2_8389_4E9A_5355_4F4D_7C7B_578BID then
        return
    end
    local cfg = _____6B27_83F2_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.W
    local soundIndex = jass.GetRandomInt(0, #cfg["全局音效键"] - 1)
    _____64AD_653E_6B27_83F2_8389_4E9A_5355_4F4D_97F3_6548(caster, cfg["全局音效键"][soundIndex + 1])
    local target = jass.GetSpellTargetUnit()
    if not _____6B27_83F2_8389_4E9AW_76EE_6807_53EF_53D7_4F24(target) then
        return
    end
    local level = GetUnitAbilityLevel(caster, _____6B27_83F2_8389_4E9AW_6280_80FDID)
    local baseDamage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (cfg["基础攻击力倍率"] + cfg["每级攻击力倍率"] * level)
    local skillInstanceId = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["技能ID"] = _____6B27_83F2_8389_4E9AW_6280_80FDID, ["来源类型"] = "单位技能", ["标签"] = "欧菲莉亚-圣光", ["持续时间秒"] = 1})
    _____7ED1_5B9A_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(caster, skillInstanceId)
    local lightWeak = YDUserDataGetSafe("unit", target, "光弱", "boolean") == true
    local mainDamage = lightWeak and baseDamage * cfg["光弱额外倍率"] or baseDamage
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = target,
        ["伤害"] = mainDamage,
        ["伤害类型"] = jass.DAMAGE_TYPE_DIVINE,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____6B27_83F2_8389_4E9AW_6280_80FDID,
        ["技能实例ID"] = skillInstanceId,
        ["标签"] = "欧菲莉亚-圣光-主目标",
        ["参与技能伤害加成"] = true
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["命中特效模型"],
        X = GetUnitX(target),
        Y = GetUnitY(target),
        Z = cfg["命中特效Z"],
        ["Z轴角度"] = cfg["命中特效Z轴角度"],
        ["缩放"] = cfg["命中特效缩放"],
        ["持续秒"] = cfg["命中特效持续秒"]
    })
    local candidates = getEnemyUnitsInRange(
        caster,
        GetUnitX(target),
        GetUnitY(target),
        cfg["溅射范围"]
    )
    local targets = {}
    do
        local i = 0
        while i < #candidates do
            local candidate = candidates[i + 1]
            if candidate ~= target and _____6B27_83F2_8389_4E9AW_76EE_6807_53EF_53D7_4F24(candidate) then
                targets[#targets + 1] = candidate
            end
            i = i + 1
        end
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害"] = baseDamage * cfg["溅射倍率"],
        ["伤害类型"] = jass.DAMAGE_TYPE_DIVINE,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____6B27_83F2_8389_4E9AW_6280_80FDID,
        ["技能实例ID"] = skillInstanceId,
        ["标签"] = "欧菲莉亚-圣光-溅射",
        ["参与技能伤害加成"] = true
    })
end
registerSpellEffectListener(_____5904_7406_6B27_83F2_8389_4E9AW)
return ____exports
