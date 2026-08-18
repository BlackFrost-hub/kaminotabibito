--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00．配置")
local _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["铃仙单位技能配置"]
local ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406 = require("系统.03．技能系统.05．单位技能.04．英雄技能.14．铃仙.00B．分身与状态管理")
local _____662F_94C3_4ED9_672C_4F53 = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是铃仙本体"]
local _____662F_94C3_4ED9_5206_8EAB = ____00B_FF0E_5206_8EAB_4E0E_72B6_6001_7BA1_7406["是铃仙分身"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_2.registerAppliedFinalDamageListener
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_3["造成技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local _____88AB_52A8_914D_7F6E = _____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E["被动"]
local _____88AB_52A8_6280_80FDID = stringToFourCCSafe(_____94C3_4ED9_5355_4F4D_6280_80FD_914D_7F6E["被动技能ID"])
local _____5DF2_6CE8_518C = false
--- 目标排除检查：古树/机械/建筑
local function _____662F_65E0_6548_76EE_6807(target)
    if target == nil or target == 0 then
        return true
    end
    if IsUnitType(target, UNIT_TYPE_ANCIENT) then
        return true
    end
    if IsUnitType(target, UNIT_TYPE_MECHANICAL) then
        return true
    end
    if IsUnitType(target, UNIT_TYPE_STRUCTURE) then
        return true
    end
    return false
end
local function _____94C3_4ED9_88AB_52A8_4F24_5BB3_4FEE_6B63(context)
    local ____opt_result_7
    if context ~= nil then
        ____opt_result_7 = context.currentDamage
    end
    local ____opt_result_7_8 = ____opt_result_7
    if ____opt_result_7_8 == nil then
        ____opt_result_7_8 = 0
    end
    local damage = ____opt_result_7_8
    if not (damage > 0) then
        return damage
    end
    local ____opt_result_11
    if context ~= nil then
        ____opt_result_11 = context.attacker
    end
    local attacker = ____opt_result_11
    if attacker == nil or attacker == 0 then
        return damage
    end
    local isMain = _____662F_94C3_4ED9_672C_4F53(attacker)
    local isIllusion = _____662F_94C3_4ED9_5206_8EAB(attacker)
    if not isMain and not isIllusion then
        return damage
    end
    local ____opt_result_14
    if context ~= nil then
        ____opt_result_14 = context.isNormalAttack
    end
    if ____opt_result_14 ~= true then
        return damage
    end
    local ____opt_result_17
    if context ~= nil then
        ____opt_result_17 = context.isRangedAttack
    end
    if ____opt_result_17 ~= true then
        return damage
    end
    local ____opt_result_20
    if context ~= nil then
        ____opt_result_20 = context.isWrappedSkillDamage
    end
    if ____opt_result_20 == true then
        return damage
    end
    local ____opt_result_23
    if context ~= nil then
        ____opt_result_23 = context.target
    end
    local target = ____opt_result_23
    if target == nil or target == 0 then
        return damage
    end
    if _____662F_65E0_6548_76EE_6807(target) then
        return damage
    end
    if isIllusion then
        return damage
    end
    return damage * _____88AB_52A8_914D_7F6E["普攻伤害比例"]
end
local function _____94C3_4ED9_88AB_52A8_989D_5916_9B54_6CD5_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or attacker == nil or attacker == 0 or target == nil or target == 0 then
        return
    end
    local isMain = _____662F_94C3_4ED9_672C_4F53(attacker)
    local isIllusion = _____662F_94C3_4ED9_5206_8EAB(attacker)
    if not isMain and not isIllusion then
        return
    end
    local ____opt_result_26
    if snapshot ~= nil then
        ____opt_result_26 = snapshot.isNormalAttack
    end
    if ____opt_result_26 ~= true then
        return
    end
    local ____opt_result_29
    if snapshot ~= nil then
        ____opt_result_29 = snapshot.isWrappedSkillDamage
    end
    if ____opt_result_29 == true then
        return
    end
    if _____662F_65E0_6548_76EE_6807(target) then
        return
    end
    local attackDamage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(attacker)
    local extraDamage
    if isIllusion then
        extraDamage = attackDamage * _____88AB_52A8_914D_7F6E["分身额外魔法倍率"]
    else
        extraDamage = attackDamage * _____88AB_52A8_914D_7F6E["额外魔法倍率"]
    end
    if not (extraDamage > 0) then
        return
    end
    _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = attacker,
        ["目标"] = target,
        ["伤害"] = extraDamage,
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____88AB_52A8_6280_80FDID,
        ["标签"] = "铃仙-被动额外魔法伤害",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
end
____exports["注册铃仙被动"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerDamageModifier(_____94C3_4ED9_88AB_52A8_4F24_5BB3_4FEE_6B63, 100)
    registerAppliedFinalDamageListener(_____94C3_4ED9_88AB_52A8_989D_5916_9B54_6CD5_4F24_5BB3)
end
____exports["注册铃仙被动"]()
return ____exports
