--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建里科特上下文"]
local _____83B7_53D6_5168_90E8_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部里科特上下文"]
local _____589E_52A0_91CC_79D1_7279_795E_98CE_5370_8BB0 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加里科特神风印记"]
local _____53D6_91CC_79D1_7279_795E_98CE_5370_8BB0 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["取里科特神风印记"]
local _____6E05_9664_91CC_79D1_7279_795E_98CE_5370_8BB0 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清除里科特神风印记"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.10．台词播放")
local _____64AD_653E_91CC_79D1_7279_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放里科特台词"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.13．公共工具")
local _____5355_4F4D_6709_6548 = ____13_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____16_FF0EBoss_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．Boss技能壳监听注册器")
local _____6CE8_518CBoss_6280_80FD_58F3_76D1_542C = ____16_FF0EBoss_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册Boss技能壳监听"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitDamageTarget = jass.UnitDamageTarget
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.05．Buff系统.03．Buff表.01．Boss.07．里科特")
local _____91CC_79D1_7279BuffID = ____require_result_3["里科特BuffID"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．物品技能工具")
local _____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local _____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____795E_98CE_62A4_4F53_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_91CC_79D1_7279_4E0A_4E0B_6587ByBoss(boss)
    local contexts = _____83B7_53D6_5168_90E8_91CC_79D1_7279_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            if contexts[i + 1]["Boss单位"] == boss then
                return contexts[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
local function _____64AD_653E_9650_65F6_76EE_6807_7279_6548(target, model, attach, duration)
    if not _____5355_4F4D_6709_6548(target) or model == "" then
        return
    end
    local effect = AddSpecialEffectTarget(model, target, attach)
    addDelayedCallback(
        duration * 1000,
        function()
            DestroyEffect(effect)
        end
    )
end
local function _____64AD_653E_9650_65F6_70B9_7279_6548(model, x, y, duration)
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    addDelayedCallback(
        duration * 1000,
        function()
            DestroyEffect(effect)
        end
    )
end
local function _____8BBE_7F6E_795E_98CE_62A4_4F53_5C42_6570(context)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    context["神风护体层数"] = cfg["基础层数"]
    registerManualBuff(
        context["Boss单位"],
        _____91CC_79D1_7279BuffID["神风护体"],
        cfg["持续秒"],
        cfg["基础层数"],
        {stack = cfg["基础层数"], sourceName = "里科特-神风护体"}
    )
    _____64AD_653E_9650_65F6_76EE_6807_7279_6548(context["Boss单位"], cfg["护体特效路径"], "origin", cfg["持续秒"])
end
local function _____66F4_65B0_795E_98CE_62A4_4F53_5C42_6570Buff(context)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    if context["神风护体层数"] <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____91CC_79D1_7279BuffID["神风护体"])
        return
    end
    registerManualBuff(
        context["Boss单位"],
        _____91CC_79D1_7279BuffID["神风护体"],
        cfg["持续秒"],
        context["神风护体层数"],
        {stack = context["神风护体层数"], sourceName = "里科特-神风护体"}
    )
end
local function _____8BB0_5F55_795E_98CE_5370_8BB0(context, attacker)
    if not _____5355_4F4D_6709_6548(attacker) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    local stack = _____589E_52A0_91CC_79D1_7279_795E_98CE_5370_8BB0(context, attacker, 1)
    registerManualBuff(
        attacker,
        _____91CC_79D1_7279BuffID["神风印记"],
        cfg["持续秒"] + 0.5,
        stack,
        {stack = stack, sourceName = "里科特-神风印记"}
    )
end
local function _____7ED3_7B97_5355_4E2A_795E_98CE_7C89_788E(context, target)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local stack = _____53D6_91CC_79D1_7279_795E_98CE_5370_8BB0(context, target)
    if stack <= 0 then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE)
    local damage = maxLife * cfg["粉碎每层最大生命比例"] * stack
    local stun = cfg["粉碎基础眩晕秒"] + cfg["粉碎每层眩晕秒"] * stack
    UnitDamageTarget(
        context["Boss单位"],
        target,
        damage,
        false,
        false,
        ATTACK_TYPE_MAGIC,
        DAMAGE_TYPE_MAGIC,
        WEAPON_TYPE_WHOKNOWS
    )
    _____65BD_52A0_7729_6655(context["Boss单位"], target, stun)
    _____64AD_653E_9650_65F6_70B9_7279_6548(
        cfg["粉碎特效路径"],
        GetUnitX(target),
        GetUnitY(target),
        1
    )
    _____6E05_9664_91CC_79D1_7279_795E_98CE_5370_8BB0(context, target)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____91CC_79D1_7279BuffID["神风印记"])
end
local function _____7ED3_7B97_795E_98CE_7C89_788E(context)
    _____64AD_653E_91CC_79D1_7279_53F0_8BCD(context["Boss单位"], "粉碎")
    for key in pairs(context["神风印记表"]) do
        do
            local stack = context["神风印记表"][key]
            if stack == nil or stack <= 0 then
                goto __continue23
            end
            local target = context["神风印记单位表"][key]
            if target ~= nil then
                _____7ED3_7B97_5355_4E2A_795E_98CE_7C89_788E(context, target)
            end
        end
        ::__continue23::
    end
    context["神风印记表"] = {}
    context["神风印记单位表"] = {}
end
local function _____8C03_5EA6_795E_98CE_7C89_788E(context)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    local id = addDelayedCallback(
        cfg["持续秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
                return
            end
            context["神风护体层数"] = 0
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____91CC_79D1_7279BuffID["神风护体"])
            _____7ED3_7B97_795E_98CE_7C89_788E(context)
        end
    )
    local ____self_5 = context["清理"]
    ____self_5["登记延迟回调"](____self_5, "里科特-神风粉碎", id)
end
local function ____on_91CC_79D1_7279_795E_98CE_62A4_4F53_53D7_4F24_4FEE_6B63(damageContext)
    local context = _____53D6_91CC_79D1_7279_4E0A_4E0B_6587ByBoss(damageContext.target)
    if context == nil or context["神风护体层数"] <= 0 or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return damageContext.currentDamage
    end
    context["神风护体层数"] = context["神风护体层数"] - 1
    _____8BB0_5F55_795E_98CE_5370_8BB0(context, damageContext.attacker)
    _____66F4_65B0_795E_98CE_62A4_4F53_5C42_6570Buff(context)
    return damageContext.currentDamage * (1 - _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]["受击减伤比例"])
end
local function ____on_91CC_79D1_7279_795E_98CE_62A4_4F53_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____795E_98CE_62A4_4F53_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____91CC_79D1_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    _____64AD_653E_91CC_79D1_7279_53F0_8BCD(castingUnit, "神风护体")
    _____8BBE_7F6E_795E_98CE_62A4_4F53_5C42_6570(context)
    _____8C03_5EA6_795E_98CE_7C89_788E(context)
end
____exports["注册里科特神风护体与粉碎"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518CBoss_6280_80FD_58F3_76D1_542C({
        ["名称"] = "06．神风护体与粉碎",
        ["Boss单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____795E_98CE_62A4_4F53_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_91CC_79D1_7279_795E_98CE_62A4_4F53_65BD_6CD5(boss, _____795E_98CE_62A4_4F53_6280_80FDID)
        end
    })
    registerDamageModifier(____on_91CC_79D1_7279_795E_98CE_62A4_4F53_53D7_4F24_4FEE_6B63, 70)
end
return ____exports
