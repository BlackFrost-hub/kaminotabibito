local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.00．配置")
local _____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派剑士单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建教派剑士上下文"]
local _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["教派剑士单位存活"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.02．数值与表现配置")
local _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["教派剑士技能配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.11．台词播放")
local _____64AD_653E_6559_6D3E_5251_58EB_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放教派剑士台词"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位最大生命"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["执行非伤害生命移除"]
local ____11_FF0E_6559_6D3E_5251_58EB = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.11．教派剑士")
local _____6559_6D3E_5251_58EBBuffID = ____11_FF0E_6559_6D3E_5251_58EB["教派剑士BuffID"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_3.addDelayedCallback
local getGameDifficulty = ____require_result_3.getGameDifficulty
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_4["取当前有效玩家人数"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_6["开始硬直"]
local _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6 = ____require_result_6["单位是否处于硬控制效果合集"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_6["施加快速控制Buff"]
local ____require_result_7 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_7.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_7["移除单位指定Buff"]
local ____require_result_8 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_8["显示常规技能吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_8["关闭吟唱条"]
local ____require_result_9 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_9.doHeal
local ____require_result_10 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_10.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_10.YDUserDataSetSafe
local ____require_result_11 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_11.EC_CreateEffect
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_12.stringToFourCCSafe
local ____require_result_13 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_13.debugLogForce
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____9B54_796D_5438_9B42_6280_80FDID = stringToFourCCSafe(_____6559_6D3E_5251_58EB_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["魔祭吸魂"])
local _____9B54_796D_5438_9B42_5DF2_6CE8_518C = false
local function _____7ED3_675F_9B54_796D_5438_9B42(_____72B6_6001, _____539F_56E0)
    if _____72B6_6001["已结束"] then
        return
    end
    _____72B6_6001["已结束"] = true
    _____72B6_6001["阶段"] = "结束"
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____6559_6D3E_5251_58EBBuffID["魔祭吸魂"])
    _____5173_95ED_541F_5531_6761(_____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["魔祭吸魂"]["读条通道"])
    if _____72B6_6001["上下文"]["魔祭状态"] == _____72B6_6001 then
        _____72B6_6001["上下文"]["魔祭状态"] = nil
    end
    debugLogForce(
        "教派剑士-魔祭吸魂",
        "状态结束",
        "bossHid=",
        boss ~= nil and boss ~= 0 and GetHandleId(boss) or 0,
        "reason=",
        _____539F_56E0,
        "accumulatedApplied=",
        _____72B6_6001["累计最终伤害"]
    )
end
local function ____on_9B54_796D_5438_9B42_6E05_7406(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 ~= nil then
        _____7ED3_675F_9B54_796D_5438_9B42(_____72B6_6001, "上下文清理")
    end
end
local function _____65BD_52A0_65E0_89C6_97E7_6027_7729_6655(boss, duration)
    local _____539F_97E7_6027 = __TS__Number(YDUserDataGetSafe("unit", boss, "眩晕抗性", "real")) or 0
    YDUserDataSetSafe(
        "unit",
        boss,
        "眩晕抗性",
        "real",
        0
    )
    _____65BD_52A0_5FEB_901F_63A7_5236Buff(
        boss,
        boss,
        0,
        duration,
        "教派剑士-魔祭吸魂反噬",
        "技能"
    )
    YDUserDataSetSafe(
        "unit",
        boss,
        "眩晕抗性",
        "real",
        _____539F_97E7_6027
    )
end
local function _____89E6_53D1_9B54_796D_53CD_566C(_____72B6_6001, attacker)
    if _____72B6_6001["已结束"] or _____72B6_6001["已反噬"] then
        return
    end
    _____72B6_6001["已反噬"] = true
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["魔祭吸魂"]
    local difficulty = getGameDifficulty() > 0 and getGameDifficulty() or 1
    local ratio = _____914D_7F6E["反噬最大生命基础比例"] - _____914D_7F6E["每难度降低反噬比例"] * difficulty
    _____7ED3_675F_9B54_796D_5438_9B42(_____72B6_6001, "受到火/光伤害反噬")
    _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
        ["目标"] = boss,
        ["数值"] = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(boss) * ratio,
        ["不致死"] = false,
        ["显示文字"] = false,
        ["显示特效"] = false
    })
    if _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) then
        _____65BD_52A0_65E0_89C6_97E7_6027_7729_6655(boss, _____914D_7F6E["反噬眩晕秒"])
    end
    debugLogForce(
        "教派剑士-魔祭吸魂",
        "火/光反噬触发一次",
        "bossHid=",
        GetHandleId(boss),
        "attackerHid=",
        attacker ~= nil and attacker ~= 0 and GetHandleId(attacker) or 0,
        "ratio=",
        ratio,
        "stun=",
        _____914D_7F6E["反噬眩晕秒"]
    )
end
local function ____on_9B54_796D_5438_9B42_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    local ____temp_17 = attacker ~= nil and attacker ~= 0 and GetUnitTypeId(attacker) == _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID
    if ____temp_17 then
        local ____opt_result_16
        if snapshot ~= nil then
            ____opt_result_16 = snapshot.skillDamageTag
        end
        ____temp_17 = ____opt_result_16 == _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["魔祭吸魂"]["伤害标签"]
    end
    if ____temp_17 then
        local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(attacker)
        local _____72B6_6001 = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["魔祭状态"]
        if _____72B6_6001 ~= nil and not _____72B6_6001["已结束"] and _____72B6_6001["阶段"] == "生效" then
            _____72B6_6001["累计最终伤害"] = _____72B6_6001["累计最终伤害"] + applied
            debugLogForce(
                "教派剑士-魔祭吸魂",
                "累计全体伤害最终applied",
                "targetHid=",
                GetHandleId(target),
                "applied=",
                applied,
                "total=",
                _____72B6_6001["累计最终伤害"]
            )
        end
    end
    local ____temp_27 = target == nil or target == 0 or GetUnitTypeId(target) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID
    if not ____temp_27 then
        local ____opt_result_22
        if snapshot ~= nil then
            ____opt_result_22 = snapshot.isFireDamage
        end
        local ____temp_26 = ____opt_result_22 ~= true
        if ____temp_26 then
            local ____opt_result_25
            if snapshot ~= nil then
                ____opt_result_25 = snapshot.isLightDamage
            end
            ____temp_26 = ____opt_result_25 ~= true
        end
        ____temp_27 = ____temp_26
    end
    if ____temp_27 then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(target)
    local _____72B6_6001 = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["魔祭状态"]
    if _____72B6_6001 ~= nil and not _____72B6_6001["已结束"] and _____72B6_6001["阶段"] == "生效" then
        _____89E6_53D1_9B54_796D_53CD_566C(_____72B6_6001, attacker)
    end
end
local function _____9B54_796D_5438_9B42_589E_4F24_4FEE_6B63(context)
    if context == nil or context.attacker == nil or context.attacker == 0 or GetUnitTypeId(context.attacker) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID then
        local ____opt_result_32
        if context ~= nil then
            ____opt_result_32 = context.currentDamage
        end
        local ____opt_result_32_33 = ____opt_result_32
        if ____opt_result_32_33 == nil then
            ____opt_result_32_33 = 0
        end
        return ____opt_result_32_33
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(context.attacker)
    local _____72B6_6001 = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["魔祭状态"]
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] or _____72B6_6001["阶段"] ~= "生效" then
        return context.currentDamage
    end
    return context.currentDamage * (1 + _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["魔祭吸魂"]["伤害提高比例"])
end
local function ____on_9B54_796D_5438_9B42_5168_4F53_7ED3_7B97(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] or _____72B6_6001["阶段"] ~= "生效" or not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(_____72B6_6001["上下文"]["Boss单位"]) then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["魔祭吸魂"]
    local _____76EE_6807_5217_8868 = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    _____72B6_6001["累计最终伤害"] = 0
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            do
                local target = _____76EE_6807_5217_8868[i + 1]
                if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(target) then
                    goto __continue23
                end
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["技能ID"] = _____9B54_796D_5438_9B42_6280_80FDID,
                    ["伤害公式"] = {["来源攻击力比例"] = _____914D_7F6E["全体伤害Boss攻击力比例"]},
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = _____914D_7F6E["伤害标签"]
                })
                EC_CreateEffect(
                    _____914D_7F6E["命中特效路径1"],
                    GetUnitX(target),
                    GetUnitY(target),
                    0,
                    270,
                    1,
                    1,
                    _____914D_7F6E["命中特效持续秒"]
                )
                EC_CreateEffect(
                    _____914D_7F6E["命中特效路径2"],
                    GetUnitX(target),
                    GetUnitY(target),
                    0,
                    270,
                    2,
                    1,
                    _____914D_7F6E["命中特效持续秒"]
                )
            end
            ::__continue23::
            i = i + 1
        end
    end
    local _____6CBB_7597_6BD4_4F8B = _____914D_7F6E["治疗基础比例"] - _____914D_7F6E["每玩家降低治疗比例"] * _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()
    local _____6CBB_7597_91CF = _____72B6_6001["累计最终伤害"] * (_____6CBB_7597_6BD4_4F8B > 0 and _____6CBB_7597_6BD4_4F8B or 0)
    local _____5B9E_9645_6CBB_7597 = _____6CBB_7597_91CF > 0 and doHeal({
        HealSource = boss,
        HealTarget = boss,
        HealAmount = _____6CBB_7597_91CF,
        ItemHeal = false,
        HealEffect = true
    }) or 0
    debugLogForce(
        "教派剑士-魔祭吸魂",
        "全体结算与最终applied吸收完成",
        "bossHid=",
        GetHandleId(boss),
        "targetCount=",
        #_____76EE_6807_5217_8868,
        "appliedTotal=",
        _____72B6_6001["累计最终伤害"],
        "healRatio=",
        _____6CBB_7597_6BD4_4F8B,
        "healed=",
        _____5B9E_9645_6CBB_7597
    )
end
local function ____on_9B54_796D_5438_9B42_72B6_6001_5230_671F(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 ~= nil then
        _____7ED3_675F_9B54_796D_5438_9B42(_____72B6_6001, "两秒状态自然结束")
    end
end
local function ____on_9B54_796D_5438_9B42_65BD_6CD5_5B8C_6210(variable)
    local _____72B6_6001 = variable
    if _____72B6_6001 == nil or _____72B6_6001["已结束"] then
        return
    end
    local boss = _____72B6_6001["上下文"]["Boss单位"]
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["魔祭吸魂"]
    _____5173_95ED_541F_5531_6761(_____914D_7F6E["读条通道"])
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) or _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(boss) then
        _____7ED3_675F_9B54_796D_5438_9B42(_____72B6_6001, "施法阶段被打断")
        return
    end
    _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
        ["目标"] = boss,
        ["数值"] = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(boss) * _____914D_7F6E["自损最大生命比例"],
        ["不致死"] = false,
        ["显示文字"] = false,
        ["显示特效"] = false
    })
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) then
        _____7ED3_675F_9B54_796D_5438_9B42(_____72B6_6001, "自损后死亡")
        return
    end
    _____72B6_6001["阶段"] = "生效"
    registerManualBuff(
        boss,
        _____6559_6D3E_5251_58EBBuffID["魔祭吸魂"],
        _____914D_7F6E["状态持续秒"],
        _____914D_7F6E["伤害提高比例"],
        {sourceUnit = boss, effectSourceName = "魔祭吸魂", effectSourceType = "技能"}
    )
    local _____7ED3_7B97ID = addDelayedCallback(_____914D_7F6E["全体结算延迟秒"] * 1000, ____on_9B54_796D_5438_9B42_5168_4F53_7ED3_7B97, _____72B6_6001)
    local _____5230_671FID = addDelayedCallback(_____914D_7F6E["状态持续秒"] * 1000, ____on_9B54_796D_5438_9B42_72B6_6001_5230_671F, _____72B6_6001)
    local ____self_36 = _____72B6_6001["上下文"]["清理"]
    ____self_36["登记延迟回调"](____self_36, "教派剑士-魔祭吸魂全体结算", _____7ED3_7B97ID)
    local ____self_37 = _____72B6_6001["上下文"]["清理"]
    ____self_37["登记延迟回调"](____self_37, "教派剑士-魔祭吸魂状态到期", _____5230_671FID)
    debugLogForce(
        "教派剑士-魔祭吸魂",
        "施法成功并进入两秒状态",
        "bossHid=",
        GetHandleId(boss),
        "damageBonus=",
        _____914D_7F6E["伤害提高比例"],
        "settleDelay=",
        _____914D_7F6E["全体结算延迟秒"]
    )
end
____exports["释放教派剑士魔祭吸魂"] = function(_____4E0A_4E0B_6587)
    local boss = _____4E0A_4E0B_6587 and _____4E0A_4E0B_6587["Boss单位"]
    if not _____6559_6D3E_5251_58EB_5355_4F4D_5B58_6D3B(boss) or _____4E0A_4E0B_6587["魔祭状态"] ~= nil then
        return false
    end
    local _____914D_7F6E = _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["魔祭吸魂"]
    local _____72B6_6001 = {
        ["已结束"] = false,
        ["已反噬"] = false,
        ["上下文"] = _____4E0A_4E0B_6587,
        ["阶段"] = "施法",
        ["累计最终伤害"] = 0
    }
    _____4E0A_4E0B_6587["魔祭状态"] = _____72B6_6001
    local ____self_40 = _____4E0A_4E0B_6587["清理"]
    ____self_40["登记清理"](____self_40, "教派剑士-魔祭吸魂清理", ____on_9B54_796D_5438_9B42_6E05_7406, _____72B6_6001)
    _____5F00_59CB_786C_76F4(boss, _____914D_7F6E["施法秒"])
    SetUnitAnimationByIndex(boss, _____914D_7F6E["动作编号"])
    _____64AD_653E_6559_6D3E_5251_58EB_53F0_8BCD(boss, "魔祭吸魂")
    EC_CreateEffect(
        _____914D_7F6E["起始特效路径"],
        GetUnitX(boss),
        GetUnitY(boss),
        0,
        270,
        _____914D_7F6E["起始特效缩放"],
        1,
        _____914D_7F6E["起始特效持续秒"]
    )
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({
        ["通道"] = _____914D_7F6E["读条通道"],
        ["总时长"] = _____914D_7F6E["施法秒"],
        ["颜色ID"] = _____914D_7F6E["读条颜色ID"],
        ["标题文本"] = _____914D_7F6E["读条标题"],
        ["提示文本"] = _____914D_7F6E["读条提示"]
    })
    local _____5B8C_6210ID = addDelayedCallback(_____914D_7F6E["施法秒"] * 1000, ____on_9B54_796D_5438_9B42_65BD_6CD5_5B8C_6210, _____72B6_6001)
    local ____self_41 = _____4E0A_4E0B_6587["清理"]
    ____self_41["登记延迟回调"](____self_41, "教派剑士-魔祭吸魂施法完成", _____5B8C_6210ID)
    debugLogForce(
        "教派剑士-魔祭吸魂",
        "1.2秒施法开始",
        "bossHid=",
        GetHandleId(boss),
        "cast=",
        _____914D_7F6E["施法秒"]
    )
    return true
end
local function ____on_6559_6D3E_5251_58EB_9B54_796D_5438_9B42_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____9B54_796D_5438_9B42_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____6559_6D3E_5251_58EB_5355_4F4D_7C7B_578BID then
        return
    end
    local _____4E0A_4E0B_6587 = _____83B7_53D6_6216_521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(castingUnit)
    local _____5DF2_5F00_59CB = _____4E0A_4E0B_6587 ~= nil and ____exports["释放教派剑士魔祭吸魂"](_____4E0A_4E0B_6587)
    debugLogForce(
        "教派剑士-魔祭吸魂",
        "正式SPELL_EFFECT入口",
        "bossHid=",
        GetHandleId(castingUnit),
        "started=",
        _____5DF2_5F00_59CB
    )
end
____exports["注册教派剑士魔祭吸魂"] = function()
    if _____9B54_796D_5438_9B42_5DF2_6CE8_518C then
        return
    end
    _____9B54_796D_5438_9B42_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_6559_6D3E_5251_58EB_9B54_796D_5438_9B42_751F_6548)
    registerAppliedFinalDamageListener(____on_9B54_796D_5438_9B42_6700_7EC8_4F24_5BB3)
    registerDamageModifier(_____9B54_796D_5438_9B42_589E_4F24_4FEE_6B63, _____6559_6D3E_5251_58EB_6280_80FD_914D_7F6E["魔祭吸魂"]["伤害提高修正优先级"])
    debugLogForce("教派剑士-魔祭吸魂", "技能壳、增伤与最终伤害监听注册完成", "skillId=", _____9B54_796D_5438_9B42_6280_80FDID)
end
return ____exports
