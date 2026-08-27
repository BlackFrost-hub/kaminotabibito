local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00．配置")
local _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["提米诺斯单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.08．提米诺斯.00A．表现工具")
local _____64AD_653E_63D0_7C73_8BFA_65AF_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放提米诺斯单位音效"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_1["造成单体技能伤害"]
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_1["造成批量AOE技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_1["创建独立技能伤害实例"]
local _____7ED1_5B9A_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_1["绑定单位当前独立技能伤害实例"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_2["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____require_result_2["单位存活"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_3.getEnemyUnitsInRange
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local ____W_6280_80FDID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["W技能ID"])
local _____63D0_7C73_8BFA_65AF_5355_4F4DID = stringToFourCCSafe(_____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local function ____on_63D0_7C73_8BFA_65AFW(caster, abilityId)
    if abilityId ~= ____W_6280_80FDID or jass:GetUnitTypeId(caster) ~= _____63D0_7C73_8BFA_65AF_5355_4F4DID then
        return
    end
    local target = jass:GetSpellTargetUnit()
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local cfg = _____63D0_7C73_8BFA_65AF_5355_4F4D_6280_80FD_914D_7F6E.W
    local level = jass:GetUnitAbilityLevel(caster, ____W_6280_80FDID)
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (cfg["基础攻击力倍率"] + cfg["每级攻击力倍率"] * level)
    local skillInstanceId = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["技能ID"] = ____W_6280_80FDID, ["来源类型"] = "单位技能", ["标签"] = "提米诺斯-圣光", ["持续时间秒"] = 1})
    _____7ED1_5B9A_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(caster, skillInstanceId)
    local soundIndex = jass:GetRandomInt(0, #cfg["全局音效键"] - 1)
    _____64AD_653E_63D0_7C73_8BFA_65AF_5355_4F4D_97F3_6548(caster, cfg["全局音效键"][soundIndex + 1])
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = target,
        ["伤害"] = damage,
        ["伤害类型"] = jass.DAMAGE_TYPE_DIVINE,
        attack = true,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FDID,
        ["技能实例ID"] = skillInstanceId,
        ["标签"] = "提米诺斯-圣光-主目标",
        ["参与技能伤害加成"] = true
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["特效模型"],
        X = jass:GetUnitX(target),
        Y = jass:GetUnitY(target),
        Z = cfg["特效Z"],
        ["Z轴角度"] = cfg["特效Z轴角度"],
        ["缩放"] = cfg["特效缩放"],
        ["持续秒"] = cfg["特效持续秒"]
    })
    local targets = getEnemyUnitsInRange(
        caster,
        jass:GetUnitX(target),
        jass:GetUnitY(target),
        cfg["溅射范围"]
    )
    do
        local i = #targets - 1
        while i >= 0 do
            if targets[i + 1] == target then
                __TS__ArraySplice(targets, i, 1)
            end
            i = i - 1
        end
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害"] = damage * cfg["溅射倍率"],
        ["伤害类型"] = jass.DAMAGE_TYPE_DIVINE,
        attack = true,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FDID,
        ["技能实例ID"] = skillInstanceId,
        ["标签"] = "提米诺斯-圣光-溅射",
        ["参与技能伤害加成"] = true
    })
end
registerSpellEffectListener(____on_63D0_7C73_8BFA_65AFW)
return ____exports
