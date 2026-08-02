--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____8BBE_7F6E_795E_98CE_62A4_4F53_5C42_6570, _____7ED3_7B97_5355_4E2A_795E_98CE_7C89_788E, _____7ED3_7B97_795E_98CE_7C89_788E, GetUnitX, GetUnitY, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, createTimedEffect, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____91CC_79D1_7279BuffID, _____65BD_52A0_7729_6655, _____795E_98CE_62A4_4F53_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建里科特上下文"]
local _____83B7_53D6_5168_90E8_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部里科特上下文"]
local _____589E_52A0_91CC_79D1_7279_795E_98CE_5370_8BB0 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["增加里科特神风印记"]
local _____53D6_91CC_79D1_7279_795E_98CE_5370_8BB0 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["取里科特神风印记"]
local _____6E05_9664_91CC_79D1_7279_795E_98CE_5370_8BB0 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清除里科特神风印记"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
local _____91CC_79D1_7279_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特音效配置"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.10．台词播放")
local _____64AD_653E_91CC_79D1_7279_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放里科特台词"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.13．公共工具")
local _____5355_4F4D_6709_6548 = ____13_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____64AD_653E_91CC_79D1_7279_9650_65F6_52A8_4F5C = ____13_FF0E_516C_5171_5DE5_5177["播放里科特限时动作"]
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行Boss单体技能伤害"]
function _____8BBE_7F6E_795E_98CE_62A4_4F53_5C42_6570(context)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    context["神风护体层数"] = cfg["基础层数"]
    registerManualBuff(
        context["Boss单位"],
        _____91CC_79D1_7279BuffID["神风护体"],
        cfg["持续秒"],
        cfg["基础层数"],
        {stack = cfg["基础层数"], sourceName = "里科特-神风护体"}
    )
end
function _____7ED3_7B97_5355_4E2A_795E_98CE_7C89_788E(context, target)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local stack = _____53D6_91CC_79D1_7279_795E_98CE_5370_8BB0(context, target)
    if stack <= 0 then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    local stun = cfg["粉碎基础眩晕秒"] + cfg["粉碎每层眩晕秒"] * stack
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local damageResult = _____6267_884CBoss_5355_4F53_6280_80FD_4F24_5BB3({
        ["技能ID"] = _____795E_98CE_62A4_4F53_6280_80FDID,
        ["来源"] = context["Boss单位"],
        ["目标"] = target,
        ["伤害公式"] = {["目标最大生命比例"] = cfg["粉碎每层最大生命比例"] * stack},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_MAGIC,
        weaponType = WEAPON_TYPE_WHOKNOWS
    })
    _____65BD_52A0_7729_6655(context["Boss单位"], target, stun)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____91CC_79D1_7279_97F3_6548_914D_7F6E["神风护体"]["粉碎清算"], targetX, targetY, _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"])
    createTimedEffect(
        cfg["粉碎特效路径"],
        targetX,
        targetY,
        0,
        1
    )
    if damageResult["是否造成伤害"] then
        createTimedEffect(
            cfg["粉碎伤害特效路径"],
            targetX,
            targetY,
            0,
            cfg["粉碎伤害特效持续秒"]
        )
    end
    _____6E05_9664_91CC_79D1_7279_795E_98CE_5370_8BB0(context, target)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____91CC_79D1_7279BuffID["神风印记"])
end
function _____7ED3_7B97_795E_98CE_7C89_788E(context)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    _____64AD_653E_91CC_79D1_7279_9650_65F6_52A8_4F5C(context["Boss单位"], cfg["粉碎动画编号"], 1, cfg["粉碎动画原始时长秒"])
    _____64AD_653E_91CC_79D1_7279_53F0_8BCD(context["Boss单位"], "粉碎")
    for key in pairs(context["神风印记表"]) do
        do
            local stack = context["神风印记表"][key]
            if stack == nil or stack <= 0 then
                goto __continue16
            end
            local target = context["神风印记单位表"][key]
            if target ~= nil then
                _____7ED3_7B97_5355_4E2A_795E_98CE_7C89_788E(context, target)
            end
        end
        ::__continue16::
    end
    context["神风印记表"] = {}
    context["神风印记单位表"] = {}
end
____exports["释放里科特神风护体"] = function(context)
    if not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return false
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["神风护体"]["展开"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____8BBE_7F6E_795E_98CE_62A4_4F53_5C42_6570(context)
    local boss = context["Boss单位"]
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "里科特-神风护体",
        ["施法者"] = boss,
        ["硬直秒"] = cfg["施法硬直秒"],
        ["生效延迟秒"] = cfg["持续秒"],
        ["动画编号"] = 8,
        ["动画速度"] = cfg["动画速度"],
        ["后续动画编号"] = 9,
        ["后续动画速度"] = 1,
        ["后续动画延迟毫秒"] = cfg["施法动作原始时长秒"] * 1000 / cfg["动画速度"],
        ["恢复动画编号"] = 3,
        ["完成后恢复动作"] = false,
        ["清理"] = context["清理"],
        ["播放台词"] = function()
            _____64AD_653E_91CC_79D1_7279_53F0_8BCD(boss, "神风护体")
        end,
        ["on生效"] = function()
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            context["神风护体层数"] = 0
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____91CC_79D1_7279BuffID["神风护体"])
            _____7ED3_7B97_795E_98CE_7C89_788E(context)
        end,
        ["on结束"] = function(_____539F_56E0)
            if _____539F_56E0 == "完成" then
                return
            end
            context["神风护体层数"] = 0
            _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____91CC_79D1_7279BuffID["神风护体"])
        end
    })
    return true
end
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_1.createTimedEffect
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_2.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.06．里科特")
_____91CC_79D1_7279BuffID = ____require_result_3["里科特BuffID"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
_____65BD_52A0_7729_6655 = ____require_result_4["施加眩晕"]
local _____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____795E_98CE_62A4_4F53_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["神风护体"]["技能槽位"])
local _____5DF2_6CE8_518C = false
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
local function _____53D6_91CC_79D1_7279_795E_98CE_62A4_4F53_4E0A_4E0B_6587(damageContext)
    local context = _____53D6_91CC_79D1_7279_4E0A_4E0B_6587ByBoss(damageContext.target)
    if context == nil or context["神风护体层数"] <= 0 or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return nil
    end
    return context
end
local function ____on_91CC_79D1_7279_795E_98CE_62A4_4F53_53D7_4F24_6761_4EF6(damageContext)
    return _____53D6_91CC_79D1_7279_795E_98CE_62A4_4F53_4E0A_4E0B_6587(damageContext) ~= nil
end
local function ____on_91CC_79D1_7279_795E_98CE_62A4_4F53_4F24_5BB3_4FEE_6B63(damageContext)
    local context = _____53D6_91CC_79D1_7279_795E_98CE_62A4_4F53_4E0A_4E0B_6587(damageContext)
    if context == nil then
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
    ____exports["释放里科特神风护体"](context)
end
____exports["注册里科特神风护体与粉碎"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "06．神风护体与粉碎",
        ["单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____795E_98CE_62A4_4F53_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_91CC_79D1_7279_795E_98CE_62A4_4F53_65BD_6CD5(boss, _____795E_98CE_62A4_4F53_6280_80FDID)
        end
    })
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "里科特-神风护体受伤修正", ["优先级"] = 70, ["条件"] = ____on_91CC_79D1_7279_795E_98CE_62A4_4F53_53D7_4F24_6761_4EF6, ["修正"] = ____on_91CC_79D1_7279_795E_98CE_62A4_4F53_4F24_5BB3_4FEE_6B63})
end
return ____exports
