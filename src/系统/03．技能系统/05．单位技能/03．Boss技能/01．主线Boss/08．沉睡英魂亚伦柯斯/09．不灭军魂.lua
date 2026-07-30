--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置")
local _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["亚伦柯斯正式设计配置"]
local ____11_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.11．台词播放")
local _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD = ____11_FF0E_53F0_8BCD_64AD_653E["播放亚伦柯斯台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____07_FF0E_4E9A_4F26_67EF_65AF = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.07．亚伦柯斯")
local _____4E9A_4F26_67EF_65AFBuffID = ____07_FF0E_4E9A_4F26_67EF_65AF["亚伦柯斯BuffID"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____08_FF0E_65E0_654C_5E27 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧")
local _____5F00_59CB_65E0_654C_5E27 = ____08_FF0E_65E0_654C_5E27["开始无敌帧"]
local _____53D6_6D88_65E0_654C_5E27 = ____08_FF0E_65E0_654C_5E27["取消无敌帧"]
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local ____require_result_2 = require("系统.05．Buff系统.06．负面效果免疫状态")
local _____65BD_52A0_5355_4F4D_63A7_5236_8D1F_9762_6548_679C_514D_75AB = ____require_result_2["施加单位控制负面效果免疫"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_3.SGSS_SetState
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local jass = require("jass.common")
local japi = require("jass.japi")
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local EXSetEffectSize = japi.EXSetEffectSize
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____653B_51FB_529B_5C5E_6027ID = 1
local _____653B_901F_5C5E_6027ID = 10
local function _____521B_5EFA_6700_7EC8_5F3A_5316_7279_6548(context)
    local boss = context["Boss单位"]
    local ____temp_6 = not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"]
    if not ____temp_6 then
        local ____self_5 = context["清理"]
        ____temp_6 = ____self_5["已清理"](____self_5)
    end
    if ____temp_6 then
        return
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["不灭军魂"]
    local effect = AddSpecialEffect(
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["不灭军魂特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    if effect ~= nil and effect ~= 0 then
        EXSetEffectSize(effect, cfg["最终强化特效缩放"])
        local ____self_7 = context["清理"]
        ____self_7["登记限时特效"](____self_7, "亚伦柯斯-最终强化脉冲特效", effect, cfg["最终强化特效持续秒"] * 1000)
    end
    local stomp = AddSpecialEffect(
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["最终强化叠加特效路径"],
        GetUnitX(boss),
        GetUnitY(boss)
    )
    if stomp ~= nil and stomp ~= 0 then
        EXSetEffectSize(stomp, cfg["最终强化叠加特效缩放"])
        local ____self_8 = context["清理"]
        ____self_8["登记限时特效"](____self_8, "亚伦柯斯-最终强化战争践踏特效", stomp, cfg["最终强化特效持续秒"] * 1000)
    end
end
____exports["启用亚伦柯斯不灭军魂"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] or context["阶段"] ~= "P3最后的誓约" or context["不灭军魂已启用"] then
        return false
    end
    local cfg = _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["不灭军魂"]
    context["不灭军魂已启用"] = true
    _____5F00_59CB_786C_76F4(boss, cfg["启动硬直秒"])
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["启动动画编号"], ["持续秒"] = cfg["启动硬直秒"], ["恢复动画编号"] = 1})
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效"]["不灭军魂"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["音效默认裁断距离"]
    )
    registerManualBuff(
        boss,
        _____4E9A_4F26_67EF_65AFBuffID["不灭军魂"],
        3600,
        _____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["不灭军魂"]["P3技能间隔缩短比例"] * 100,
        {sourceName = "亚伦柯斯-不灭军魂"}
    )
    local aura = AddSpecialEffectTarget(_____4E9A_4F26_67EF_65AF_6B63_5F0F_8BBE_8BA1_914D_7F6E["表现资源"]["常驻英魂特效路径"], boss, "origin")
    local ____self_9 = context["清理"]
    ____self_9["登记清理"](
        ____self_9,
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
    _____5F00_59CB_786C_76F4(boss, cfg["最终强化硬直秒"])
    local invulnerableId = _____5F00_59CB_65E0_654C_5E27(boss, cfg["最终强化施法无敌秒"])
    local ____self_10 = context["清理"]
    ____self_10["登记清理"](
        ____self_10,
        "亚伦柯斯-最终强化施法无敌",
        function()
            if invulnerableId ~= 0 then
                _____53D6_6D88_65E0_654C_5E27(invulnerableId)
            end
        end
    )
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["最终强化动画编号"], ["持续秒"] = cfg["最终强化硬直秒"], ["恢复动画编号"] = 1})
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
    _____521B_5EFA_6700_7EC8_5F3A_5316_7279_6548(context)
    do
        local pulseIndex = 1
        while pulseIndex < cfg["最终强化特效次数"] do
            local delayedId = addDelayedCallback(
                pulseIndex * cfg["最终强化特效间隔秒"] * 1000,
                function()
                    _____521B_5EFA_6700_7EC8_5F3A_5316_7279_6548(context)
                end
            )
            local ____self_11 = context["清理"]
            ____self_11["登记延迟回调"](____self_11, "亚伦柯斯-最终强化后续脉冲", delayedId)
            pulseIndex = pulseIndex + 1
        end
    end
    _____64AD_653E_4E9A_4F26_67EF_65AF_53F0_8BCD(boss, "最终强化10")
    return true
end
____exports["不灭军魂机制状态"] = {
    ["类型"] = "P3被动与最终强化",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "P3小幅缩短技能间隔，10%生命时触发一次免控、施法无敌与攻击强化，不回血。"
}
return ____exports
