--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.00．配置")
local _____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派剑士单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派剑士上下文"]
local _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派剑士单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.02．数值与表现配置")
local _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派剑士技能配置"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local ____11_FF0E_6559_6D3E_5251_58EB = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.11．教派剑士")
local _____6559_6D3E_5251_58EBBuffID = ____11_FF0E_6559_6D3E_5251_58EB["教派剑士BuffID"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.04．伤害系统.06．暴击系统.01．暴击核心")
local _____6267_884C_66B4_51FB_5224_5B9A = ____require_result_2["执行暴击判定"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local removeDelayedCallback = ____require_result_3.removeDelayedCallback
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_4["移除单位指定Buff"]
local ____require_result_5 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_5.doHeal
local _____82F1_96C4_4E3B_5C5E_6027_666E_901A_7248 = require("lib.扩展函数.Star扩展函数.Star扩展库.10．英雄属性与攻击力函数")
local _____8BFB_53D6_82F1_96C4_4E3B_5C5E_6027_666E_901A_7248 = _____82F1_96C4_4E3B_5C5E_6027_666E_901A_7248.SU_GetHeroParmary
local _____529B_91CF_4E3B_5C5E_6027_7C7B_578B = _____82F1_96C4_4E3B_5C5E_6027_666E_901A_7248.PRIMARY_STR
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_7.debugLogForce
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetHandleId = jass.GetHandleId
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____9ED1_9B54_6CD5_4FB5_8680_9644_52A0_4F24_5BB3_6807_7B7E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑魔法侵蚀"]["附加伤害标签"]
local _____9ED1_6D1E_5F3A_5316_666E_653B_4F24_5BB3_6807_7B7E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]["强化普攻标签"]
local _____9ED1_9B54_6CD5_4FB5_8680_5DF2_6CE8_518C = false
local function _____8BFB_53D6_82F1_96C4_4E3B_5C5E_6027(unit)
    return _____8BFB_53D6_82F1_96C4_4E3B_5C5E_6027_666E_901A_7248(unit)
end
local function ____on_6559_6D3E_5251_58EB_666E_901A_653B_51FB_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(attacker) or GetUnitTypeId(attacker) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID then
        return
    end
    local ____opt_result_10
    if snapshot ~= nil then
        ____opt_result_10 = snapshot.skillDamageTag
    end
    if ____opt_result_10 == _____9ED1_6D1E_5F3A_5316_666E_653B_4F24_5BB3_6807_7B7E then
        local _____6CBB_7597_91CF = applied * _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]["强化普攻治疗比例"]
        local _____5B9E_9645_6CBB_7597 = doHeal({
            HealSource = attacker,
            HealTarget = attacker,
            HealAmount = _____6CBB_7597_91CF,
            ItemHeal = false,
            HealEffect = true
        })
        debugLogForce(
            "教派剑士-黑洞跨越",
            "强化普攻按最终伤害治疗",
            "bossHid=",
            GetHandleId(attacker),
            "targetHid=",
            target ~= nil and target ~= 0 and GetHandleId(target) or 0,
            "applied=",
            applied,
            "heal=",
            _____5B9E_9645_6CBB_7597
        )
        return
    end
    local ____temp_14 = not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(target)
    if not ____temp_14 then
        local ____opt_result_13
        if snapshot ~= nil then
            ____opt_result_13 = snapshot.isNormalAttack
        end
        ____temp_14 = ____opt_result_13 ~= true
    end
    if ____temp_14 then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(attacker)
    if _____4E0A_4E0B_6587 == nil or _____4E0A_4E0B_6587["黑魔法侵蚀递归锁"] then
        return
    end
    local _____5E94_6D88_8D39_5F3A_5316_666E_653B = _____4E0A_4E0B_6587["黑洞强化普攻就绪"]
    if _____5E94_6D88_8D39_5F3A_5316_666E_653B then
        if _____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"] ~= 0 then
            removeDelayedCallback(_____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"])
        end
        _____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"] = 0
        _____4E0A_4E0B_6587["黑洞强化普攻就绪"] = false
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(attacker, _____6559_6D3E_5251_58EBBuffID["黑洞强化普攻"])
        debugLogForce(
            "教派剑士-黑洞跨越",
            "首次成功普通攻击消费强化状态",
            "bossHid=",
            GetHandleId(attacker),
            "targetHid=",
            GetHandleId(target),
            "originalApplied=",
            applied
        )
    end
    local _____4E3B_5C5E_6027_7C7B_578B = _____8BFB_53D6_82F1_96C4_4E3B_5C5E_6027(target)
    local _____4F24_5BB3_6BD4_4F8B = _____4E3B_5C5E_6027_7C7B_578B == _____529B_91CF_4E3B_5C5E_6027_7C7B_578B and _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑魔法侵蚀"]["力量英雄目标最大生命比例"] or _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑魔法侵蚀"]["其他目标最大生命比例"]
    _____4E0A_4E0B_6587["黑魔法侵蚀递归锁"] = true
    if _____5E94_6D88_8D39_5F3A_5316_666E_653B then
        local _____5F3A_5316_7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = attacker,
            ["目标"] = target,
            ["伤害公式"] = {["来源攻击力比例"] = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑洞跨越"]["强化普攻Boss攻击力比例"]},
            attack = false,
            ranged = false,
            attackType = ATTACK_TYPE_NORMAL,
            ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["标签"] = _____9ED1_6D1E_5F3A_5316_666E_653B_4F24_5BB3_6807_7B7E
        })
        debugLogForce(
            "教派剑士-黑洞跨越",
            "强化普攻附加暗伤提交",
            "bossHid=",
            GetHandleId(attacker),
            "targetHid=",
            GetHandleId(target),
            "damage=",
            _____5F3A_5316_7ED3_679C["伤害"],
            "submitted=",
            _____5F3A_5316_7ED3_679C["是否造成伤害"]
        )
    end
    local _____7ED3_679C = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = attacker,
        ["目标"] = target,
        ["伤害公式"] = {["目标最大生命比例"] = _____4F24_5BB3_6BD4_4F8B},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = _____9ED1_9B54_6CD5_4FB5_8680_9644_52A0_4F24_5BB3_6807_7B7E,
        ["参与技能伤害加成"] = false
    })
    _____4E0A_4E0B_6587["黑魔法侵蚀递归锁"] = false
    debugLogForce(
        "教派剑士-黑魔法侵蚀",
        "普通攻击附加暗魔法伤害结算",
        "bossHid=",
        GetHandleId(attacker),
        "targetHid=",
        GetHandleId(target),
        "originalApplied=",
        applied,
        "primaryType=",
        _____4E3B_5C5E_6027_7C7B_578B,
        "ratio=",
        _____4F24_5BB3_6BD4_4F8B,
        "damage=",
        _____7ED3_679C["伤害"],
        "submitted=",
        _____7ED3_679C["是否造成伤害"]
    )
end
local function _____6559_6D3E_5251_58EB_9ED1_9B54_6CD5_66B4_51FB_4FEE_6B63(context)
    if context == nil then
        return 0
    end
    local currentDamage = context.currentDamage
    local attacker = context.attacker
    if attacker == nil or attacker == 0 or GetUnitTypeId(attacker) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID then
        return currentDamage
    end
    if context.isMagicDamage ~= true or context.isNormalAttack == true or context.isSkillAttack == true then
        return currentDamage
    end
    if context.skillDamageTag == _____9ED1_9B54_6CD5_4FB5_8680_9644_52A0_4F24_5BB3_6807_7B7E then
        debugLogForce(
            "教派剑士-黑魔法侵蚀",
            "附加暗伤明确跳过黑魔法法术暴击",
            "bossHid=",
            GetHandleId(attacker),
            "damage=",
            currentDamage
        )
        return currentDamage
    end
    local _____66B4_51FB_7ED3_679C = _____6267_884C_66B4_51FB_5224_5B9A({
        attacker = attacker,
        target = context.target,
        currentDamage = currentDamage,
        isPhysicalDamage = context.isPhysicalDamage == true,
        isEnhancedDamage = context.isEnhancedDamage == true,
        isNormalAttack = false,
        isRangedAttack = context.isRangedAttack == true,
        isSkillAttack = true
    })
    if _____66B4_51FB_7ED3_679C["是否暴击"] then
        debugLogForce(
            "教派剑士-黑魔法侵蚀",
            "黑魔法伤害法术暴击成功",
            "bossHid=",
            GetHandleId(attacker),
            "targetHid=",
            context.target ~= nil and context.target ~= 0 and GetHandleId(context.target) or 0,
            "before=",
            currentDamage,
            "after=",
            _____66B4_51FB_7ED3_679C["伤害"],
            "multiplier=",
            _____66B4_51FB_7ED3_679C["暴击倍率"]
        )
    end
    return _____66B4_51FB_7ED3_679C["伤害"]
end
____exports["注册教派剑士黑魔法侵蚀"] = function()
    if _____9ED1_9B54_6CD5_4FB5_8680_5DF2_6CE8_518C then
        return
    end
    _____9ED1_9B54_6CD5_4FB5_8680_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_6559_6D3E_5251_58EB_666E_901A_653B_51FB_6700_7EC8_4F24_5BB3)
    registerDamageModifier(_____6559_6D3E_5251_58EB_9ED1_9B54_6CD5_66B4_51FB_4FEE_6B63, _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["黑魔法侵蚀"]["黑魔法暴击修正器优先级"])
end
return ____exports
