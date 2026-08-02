--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____83B7_53D6_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取夏提雅运行时上下文"]
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____04_FF0E_9C9C_8840_5370_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.04．鲜血印记")
local _____521B_5EFA_590F_63D0_96C5_9C9C_8840_5370_8BB0 = ____04_FF0E_9C9C_8840_5370_8BB0["创建夏提雅鲜血印记"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6 = ____01_FF0E_63A7_5236_4E0EBuff["单位是否处于硬控制效果合集"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
local ____02_FF0E_590F_63D0_96C5 = require("系统.05．Buff系统.03．Buff表.01．Boss.03．异界Boss.02．夏提雅")
local _____590F_63D0_96C5BuffID = ____02_FF0E_590F_63D0_96C5["夏提雅BuffID"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_541F_5531_6761 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.19．吟唱条")
local _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761 = ____19_FF0E_541F_5531_6761["显示夏提雅常规吟唱条"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____20_FF0E_5438_8840_8868_73B0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.20．吸血表现")
local _____64AD_653E_590F_63D0_96C5_5438_8840_6062_590D_7279_6548 = ____20_FF0E_5438_8840_8868_73B0["播放夏提雅吸血恢复特效"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local getBuffRuntime = ____require_result_2.getBuffRuntime
local ____require_result_3 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_3.doHeal
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储")
local getThreat = ____require_result_4.getThreat
local setThreat = ____require_result_4.setThreat
local ____require_result_5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_5["取当前有效玩家人数"]
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_6.addDelayedCallback
local getServerTime = ____require_result_6.getServerTime
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_7.createUnitEffect
local _____8BBE_7F6EDz_7ED1_5B9A_7279_6548_7F29_653E = ____require_result_7["设置Dz绑定特效缩放"]
local ____require_result_8 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_8.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomReal = jass.GetRandomReal
local IsUnitType = jass.IsUnitType
local SetUnitFacing = jass.SetUnitFacing
local Atan2 = jass.Atan2
local AddSpecialEffect = jass.AddSpecialEffect
local GetUnitState = japi.GetUnitState
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local _____6EF4_7BA1_957F_67AA_8FDE_51FB_5DF2_6CE8_518C = false
local function _____53D6_5F3A_5316_653B_51FB_9608_503C(context)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]
    return context["阶段"] == "P3真祖血宴" and cfg["P3需要攻击次数"] or cfg["P1P2需要攻击次数"]
end
local function _____662F_590F_63D0_96C5_76F4_63A5_666E_901A_653B_51FB(damageContext, context)
    return damageContext ~= nil and damageContext.isNormalAttack == true and damageContext.attacker == context["Boss单位"] and damageContext.originalAttacker == context["Boss单位"]
end
local function _____53EF_63A8_8FDB_730E_8840_8FDE_51FB(context)
    return not context["挑战已结束"] and context["当前大型技能"] == nil and getServerTime() >= context["普通机制忙碌到Ms"] and not _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(context["Boss单位"])
end
____exports["刷新夏提雅猎血连击Buff"] = function(context)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) or context["当前猎血段数"] <= 0 then
        return
    end
    registerManualBuff(
        context["Boss单位"],
        _____590F_63D0_96C5BuffID["猎血连击"],
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]["连击过期秒"],
        0,
        {stack = context["当前猎血段数"], sourceName = "夏提雅-滴管长枪连击"}
    )
end
local function _____64AD_653E_4E8C_6BB5_9C9C_8840_6807_8BB0(target)
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]
    local effect = createUnitEffect(
        target,
        "overhead",
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["普攻二段鲜血标记特效路径"],
        cfg["二段标记持续秒"],
        "夏提雅-猎血二段"
    )
    if effect ~= nil and effect ~= 0 then
        _____8BBE_7F6EDz_7ED1_5B9A_7279_6548_7F29_653E(effect, cfg["二段标记缩放"])
    end
end
local function _____5C1D_8BD5_64AD_653E_6C72_8840_7A7F_523A_53F0_8BCD(context)
    local now = getServerTime()
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]
    if now < context["汲血穿刺台词冷却到Ms"] then
        return
    end
    context["汲血穿刺台词冷却到Ms"] = now + cfg["广播语音内置冷却秒"] * 1000
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(context["Boss单位"], "汲血穿刺")
end
local function _____6267_884C_5F3A_5316_7A7F_523A_547D_4E2D(context, target)
    local boss = context["Boss单位"]
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]
    local dx = GetUnitX(target) - GetUnitX(boss)
    local dy = GetUnitY(target) - GetUnitY(boss)
    local distanceSquared = dx * dx + dy * dy
    if distanceSquared > cfg["强化穿刺命中距离"] * cfg["强化穿刺命中距离"] then
        return
    end
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["滴管穿心汲血"],
        GetUnitX(target),
        GetUnitY(target),
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    SetUnitFacing(
        boss,
        Atan2(dy, dx) * RAD_TO_DEG
    )
    local hit = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害公式"] = {["来源攻击力比例"] = cfg["强化穿刺伤害攻击力比例"], ["目标最大生命比例"] = cfg["强化穿刺伤害目标最大生命比例"]},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["标签"] = "夏提雅·滴管长枪强化穿刺"
    })["是否造成伤害"]
    if not hit then
        return
    end
    local effect = AddSpecialEffect(
        _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["汲血穿刺特效路径"],
        GetUnitX(target),
        GetUnitY(target)
    )
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(1.1, effect)
    end
    if _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() > 1 then
        local currentThreat = getThreat(boss, target)
        if currentThreat > 0 then
            setThreat(boss, target, currentThreat * cfg["多人命中后仇恨保留比例"])
        end
    end
    if getBuffRuntime(target, _____590F_63D0_96C5BuffID["鲜血枯竭"]) ~= nil then
        return
    end
    doHeal({
        HealSource = boss,
        HealTarget = boss,
        HealAmount = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg["强化穿刺治疗最大生命比例"],
        ItemHeal = false,
        HealEffect = false
    })
    _____64AD_653E_590F_63D0_96C5_5438_8840_6062_590D_7279_6548(boss)
    if context["阶段"] ~= "P3真祖血宴" then
        _____521B_5EFA_590F_63D0_96C5_9C9C_8840_5370_8BB0(
            context,
            GetUnitX(target),
            GetUnitY(target)
        )
    end
    registerManualBuff(
        target,
        _____590F_63D0_96C5BuffID["鲜血枯竭"],
        cfg["鲜血枯竭持续秒"],
        1,
        {sourceName = "夏提雅-滴管长枪强化穿刺"}
    )
end
local function _____542F_52A8_5F3A_5316_7A7F_523A(context, target)
    local boss = context["Boss单位"]
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]
    local windup = GetRandomReal(cfg["强化穿刺前摇最小秒"], cfg["强化穿刺前摇最大秒"])
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    context["普通机制忙碌到Ms"] = getServerTime() + (windup + 0.25) * 1000
    SetUnitFacing(
        boss,
        Atan2(
            GetUnitY(target) - GetUnitY(boss),
            GetUnitX(target) - GetUnitX(boss)
        ) * RAD_TO_DEG
    )
    _____5C1D_8BD5_64AD_653E_6C72_8840_7A7F_523A_53F0_8BCD(context)
    _____5F00_59CB_786C_76F4(boss, windup)
    _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761(windup, cfg["吟唱条颜色ID"], cfg["吟唱条标题文本"], cfg["吟唱条提示文本"])
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["强化穿刺动画编号"], ["持续秒"] = windup + 0.2, ["恢复动画编号"] = 0})
    local delayedId = addDelayedCallback(
        windup * 1000,
        function()
            if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
                return
            end
            if _____5355_4F4D_662F_5426_5904_4E8E_786C_63A7_5236_6548_679C_5408_96C6(boss) then
                return
            end
            _____6267_884C_5F3A_5316_7A7F_523A_547D_4E2D(context, target)
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "夏提雅-滴管长枪强化穿刺", delayedId)
end
local function _____66FF_6362_5F3A_5316_7A7F_523A_666E_901A_653B_51FB(damageContext)
    local ____83B7_53D6_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587_13 = _____83B7_53D6_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587
    local ____opt_result_12
    if damageContext ~= nil then
        ____opt_result_12 = damageContext.attacker
    end
    local context = ____83B7_53D6_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587_13(____opt_result_12)
    if context == nil or not _____662F_590F_63D0_96C5_76F4_63A5_666E_901A_653B_51FB(damageContext, context) then
        return damageContext.currentDamage
    end
    if not _____53EF_63A8_8FDB_730E_8840_8FDE_51FB(context) then
        _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
        return damageContext.currentDamage
    end
    local now = getServerTime()
    if context["猎血段数过期时间Ms"] > 0 and now >= context["猎血段数过期时间Ms"] then
        _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
        return damageContext.currentDamage
    end
    if context["当前猎血目标"] ~= damageContext.target or context["当前猎血段数"] ~= _____53D6_5F3A_5316_653B_51FB_9608_503C(context) - 1 then
        return damageContext.currentDamage
    end
    context["待结算强化穿刺目标"] = damageContext.target
    return 0
end
local function ____on_590F_63D0_96C5_666E_901A_653B_51FB_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    local context = _____83B7_53D6_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587(attacker)
    local ____temp_17 = context == nil
    if not ____temp_17 then
        local ____opt_result_16
        if snapshot ~= nil then
            ____opt_result_16 = snapshot.isNormalAttack
        end
        ____temp_17 = ____opt_result_16 ~= true
    end
    local ____temp_17_21 = ____temp_17
    if not ____temp_17_21 then
        local ____opt_result_20
        if snapshot ~= nil then
            ____opt_result_20 = snapshot.originalAttacker
        end
        ____temp_17_21 = ____opt_result_20 ~= context["Boss单位"]
    end
    if ____temp_17_21 then
        return
    end
    if context["待结算强化穿刺目标"] == target then
        context["待结算强化穿刺目标"] = nil
        if _____5355_4F4D_6709_6548(target) then
            _____542F_52A8_5F3A_5316_7A7F_523A(context, target)
        end
        return
    end
    if not (applied > 0) or not _____53EF_63A8_8FDB_730E_8840_8FDE_51FB(context) then
        return
    end
    if context["当前猎血目标"] ~= target then
        context["当前猎血目标"] = target
        context["当前猎血段数"] = 1
    else
        context["当前猎血段数"] = context["当前猎血段数"] + 1
    end
    context["猎血段数过期时间Ms"] = getServerTime() + _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["滴管长枪连击"]["连击过期秒"] * 1000
    ____exports["刷新夏提雅猎血连击Buff"](context)
    if context["当前猎血段数"] == _____53D6_5F3A_5316_653B_51FB_9608_503C(context) - 1 then
        _____64AD_653E_4E8C_6BB5_9C9C_8840_6807_8BB0(target)
    end
end
____exports["注册夏提雅滴管长枪连击"] = function()
    if _____6EF4_7BA1_957F_67AA_8FDE_51FB_5DF2_6CE8_518C then
        return
    end
    _____6EF4_7BA1_957F_67AA_8FDE_51FB_5DF2_6CE8_518C = true
    registerDamageModifier(_____66FF_6362_5F3A_5316_7A7F_523A_666E_901A_653B_51FB, -90)
    registerAppliedFinalDamageListener(____on_590F_63D0_96C5_666E_901A_653B_51FB_6700_7EC8_4F24_5BB3)
end
____exports["滴管长枪连击机制状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "普通攻击替换机制",
    ["伤害形态"] = "单体",
    ["语义"] = "同一目标连续受击后，将阈值普通攻击归零并替换为可被拉开距离或硬控制打断的汲血穿刺。",
    ["实现要求"] = "换目标、超时、硬控制和大型技能清空段数；鲜血枯竭阻止短时间重复回血与血印生成，P3不再生成血印。"
}
return ____exports
