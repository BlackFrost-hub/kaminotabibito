--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建里科特上下文"]
local _____83B7_53D6_5168_90E8_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部里科特上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
local _____91CC_79D1_7279_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特音效配置"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.10．台词播放")
local _____64AD_653E_91CC_79D1_7279_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放里科特台词"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.13．公共工具")
local _____5355_4F4D_6709_6548 = ____13_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____64AD_653E_91CC_79D1_7279_65BD_6CD5_7EF4_6301_52A8_4F5C = ____13_FF0E_516C_5171_5DE5_5177["播放里科特施法维持动作"]
local _____64AD_653E_91CC_79D1_7279_9650_65F6_52A8_4F5C = ____13_FF0E_516C_5171_5DE5_5177["播放里科特限时动作"]
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____8DDD_79BB_5E73_65B9XY = ____13_FF0E_516C_5171_5DE5_5177["距离平方XY"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomReal = jass.GetRandomReal
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_2.createTimedUnitEffect
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6309_6BD4_4F8B_79FB_9664_5F53_524D_751F_547D = ____require_result_4["按比例移除当前生命"]
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_5.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_5["移除单位指定Buff"]
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.06．里科特")
local _____91CC_79D1_7279BuffID = ____require_result_6["里科特BuffID"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容")
local _____65BD_52A0_7729_6655 = ____require_result_7["施加眩晕"]
local _____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____7834_9B54_53CD_51FB_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["破魔反击"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____53D6_53CD_51FB_4E0A_4E0B_6587(boss)
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
local function _____64AD_653E_9650_65F6_53CD_51FB_7279_6548(target)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["破魔反击"]
    local model = cfg["反击特效路径"]
    if not _____5355_4F4D_6709_6548(target) or model == "" then
        return
    end
    createTimedUnitEffect(target, "origin", model, cfg["反击特效持续秒"])
end
local function _____7ED3_675F_7834_9B54_53CD_51FB_7A97_53E3(context)
    context["破魔反击中"] = false
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____91CC_79D1_7279BuffID["破魔反击"])
end
local function _____5F00_59CB_7834_9B54_53CD_51FB_7A97_53E3(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["破魔反击"]
    context["破魔反击中"] = true
    _____64AD_653E_91CC_79D1_7279_65BD_6CD5_7EF4_6301_52A8_4F5C(boss, cfg["反击窗口秒"], cfg["动画速度"])
    registerManualBuff(
        boss,
        _____91CC_79D1_7279BuffID["破魔反击"],
        cfg["反击窗口秒"],
        1,
        {sourceName = "里科特-破魔反击"}
    )
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["破魔反击"]["窗口开启"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____64AD_653E_9650_65F6_53CD_51FB_7279_6548(boss)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["半径"] = cfg["近距离阈值"],
        ["持续时间"] = cfg["反击窗口秒"],
        ["来源单位"] = boss
    })
    local id = addDelayedCallback(
        cfg["反击窗口秒"] * 1000,
        function()
            _____7ED3_675F_7834_9B54_53CD_51FB_7A97_53E3(context)
        end
    )
    local ____self_8 = context["清理"]
    ____self_8["登记延迟回调"](____self_8, "里科特-破魔反击窗口", id)
end
____exports["释放里科特破魔反击"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["破魔反击"]
    _____64AD_653E_91CC_79D1_7279_53F0_8BCD(boss, "破魔反击")
    local prepare = GetRandomReal(cfg["预备最小秒"], cfg["预备最大秒"])
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["半径"] = cfg["近距离阈值"],
        ["持续时间"] = prepare,
        ["来源单位"] = boss
    })
    local id = addDelayedCallback(
        prepare * 1000,
        function()
            _____5F00_59CB_7834_9B54_53CD_51FB_7A97_53E3(context)
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "里科特-破魔反击预备", id)
end
local function ____on_91CC_79D1_7279_7834_9B54_53CD_51FB_4F24_5BB3_4FEE_6B63(damageContext)
    local context = _____53D6_53CD_51FB_4E0A_4E0B_6587(damageContext.target)
    if context == nil or context["破魔反击中"] ~= true then
        return damageContext.currentDamage
    end
    local boss = context["Boss单位"]
    local attacker = damageContext.attacker
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(attacker) then
        return damageContext.currentDamage
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["破魔反击"]
    local distance2 = _____8DDD_79BB_5E73_65B9XY(
        GetUnitX(boss),
        GetUnitY(boss),
        GetUnitX(attacker),
        GetUnitY(attacker)
    )
    local near2 = cfg["近距离阈值"] * cfg["近距离阈值"]
    local ratio = distance2 <= near2 and cfg["近距离当前生命移除比例"] or cfg["远距离当前生命移除比例"]
    _____64AD_653E_91CC_79D1_7279_9650_65F6_52A8_4F5C(boss, cfg["触发动画编号"], 1, cfg["触发动画原始时长秒"])
    _____6309_6BD4_4F8B_79FB_9664_5F53_524D_751F_547D(attacker, ratio, true)
    _____65BD_52A0_7729_6655(boss, attacker, cfg["眩晕秒"])
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["破魔反击"]["触发剥离"],
        GetUnitX(attacker),
        GetUnitY(attacker),
        _____91CC_79D1_7279_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____64AD_653E_9650_65F6_53CD_51FB_7279_6548(attacker)
    _____7ED3_675F_7834_9B54_53CD_51FB_7A97_53E3(context)
    return damageContext.currentDamage
end
local function ____on_91CC_79D1_7279_7834_9B54_53CD_51FB_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____7834_9B54_53CD_51FB_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____91CC_79D1_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放里科特破魔反击"](context)
end
____exports["注册里科特破魔反击"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "09．破魔反击",
        ["单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7834_9B54_53CD_51FB_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_91CC_79D1_7279_7834_9B54_53CD_51FB_65BD_6CD5(boss, _____7834_9B54_53CD_51FB_6280_80FDID)
        end
    })
    registerDamageModifier(____on_91CC_79D1_7279_7834_9B54_53CD_51FB_4F24_5BB3_4FEE_6B63, 85)
end
return ____exports
