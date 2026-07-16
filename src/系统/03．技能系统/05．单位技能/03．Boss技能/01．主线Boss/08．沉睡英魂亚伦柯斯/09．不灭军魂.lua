--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置")
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["亚伦柯斯正式设计配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.11．台词播放")
local _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放亚伦柯斯台词"]
local ____07_FF0E_4E9A_4F26_67EF_65AF = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.07．亚伦柯斯")
local _____4E9A_4F26_67EF_65AFBuffID = ____07_FF0E_4E9A_4F26_67EF_65AF["亚伦柯斯BuffID"]
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.05．Buff系统.06．负面效果免疫状态")
local _____65BD_52A0_5355_4F4D_63A7_5236_8D1F_9762_6548_679C_514D_75AB = ____require_result_2["施加单位控制负面效果免疫"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_3.SGSS_SetState
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____653B_51FB_529B_5C5E_6027ID = 1
local _____653B_901F_5C5E_6027ID = 10
____exports["启用亚伦柯斯不灭军魂"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["阶段"] ~= "P3最后的誓约" or context["不灭军魂已启用"] then
        return false
    end
    context["不灭军魂已启用"] = true
    registerManualBuff(
        boss,
        _____4E9A_4F26_67EF_65AFBuffID["不灭军魂"],
        3600,
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["不灭军魂"]["P3技能间隔缩短比例"] * 100,
        {sourceName = "亚伦柯斯-不灭军魂"}
    )
    local aura = AddSpecialEffectTarget(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["常驻英魂特效路径"], boss, "origin")
    local ____self_5 = context["清理"]
    ____self_5["登记清理"](
        ____self_5,
        "亚伦柯斯-不灭军魂常驻层",
        function()
            if aura ~= nil and aura ~= 0 then
                DestroyEffect(aura)
            end
            if _____5355_4F4D_6709_6548(boss) then
                _____79FB_9664_5355_4F4D_6307_5B9ABuff(boss, _____4E9A_4F26_67EF_65AFBuffID["不灭军魂"])
            end
        end
    )
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, "不灭军魂")
    return true
end
____exports["触发亚伦柯斯最终强化"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["阶段"] ~= "P3最后的誓约" or context["已触发最终强化"] then
        return false
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["不灭军魂"]
    context["已触发最终强化"] = true
    context["最终强化攻击力增量"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["最终强化攻击力比例"]
    context["最终强化攻速增量"] = cfg["最终强化攻击速度提高"]
    if context["最终强化攻击力增量"] ~= 0 then
        SGSS_SetState(boss, _____653B_51FB_529B_5C5E_6027ID, context["最终强化攻击力增量"])
    end
    if context["最终强化攻速增量"] ~= 0 then
        SGSS_SetState(boss, _____653B_901F_5C5E_6027ID, context["最终强化攻速增量"])
    end
    _____65BD_52A0_5355_4F4D_63A7_5236_8D1F_9762_6548_679C_514D_75AB(boss, cfg["最终强化控制免疫秒"], true)
    registerManualBuff(
        boss,
        _____4E9A_4F26_67EF_65AFBuffID["不灭军魂"],
        3600,
        cfg["最终强化攻击力比例"] * 100,
        {sourceName = "亚伦柯斯-不灭军魂最终强化", stack = 2}
    )
    local effect = AddSpecialEffect(
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["不灭军魂特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(1.8, effect)
    end
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, "最终强化10")
    return true
end
____exports["不灭军魂机制状态"] = {
    ["类型"] = "P3被动与最终强化",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "P3小幅缩短技能间隔，10%生命时触发一次抗硬直与攻击强化，不回血也不无敌。"
}
return ____exports
