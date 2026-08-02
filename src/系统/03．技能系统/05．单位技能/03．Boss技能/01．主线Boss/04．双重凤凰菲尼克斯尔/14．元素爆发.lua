local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔音效配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具")
local stringToFourCC = ____19_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____5EF6_8FDF = ____19_FF0E_516C_5171_5DE5_5177["延迟"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_83F2_5C3C_514B_65AF_5C14_654C_5BF9_76EE_6807_5217_8868 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔敌对目标列表"]
local _____53D6_6700_9AD8_5143_7D20 = ____19_FF0E_516C_5171_5DE5_5177["取最高元素"]
local _____51CF_5C11_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["减少元素层数"]
local _____663E_793A_573A_5730_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示场地读条"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔技能强度倍率"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587 = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔独立伤害上下文"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local _____5F00_59CB_65BD_6CD5_786C_76F4 = ____19_FF0E_516C_5171_5DE5_5177["开始施法硬直"]
local _____5F00_59CB_5143_7D20_7206_53D1_786C_76F4 = ____19_FF0E_516C_5171_5DE5_5177["开始元素爆发硬直"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____06_FF0E_70BD_7FBD_6563_5C04 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.06．炽羽散射")
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_71C3_70E7_533A = ____06_FF0E_70BD_7FBD_6563_5C04["创建菲尼克斯尔燃烧区"]
local jass = require("jass.common")
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitTypeId = jass.GetUnitTypeId
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerHealCallback = ____require_result_0.registerHealCallback
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_1.getBuffRuntime
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6BD2_706B_67AF_7AEDBuffID = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["毒火枯竭"]
local _____6697_706B_589E_5E45BuffID = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["暗火增幅"]
local _____5143_7D20_7206_53D1_9644_52A0_6548_679C_5DF2_6CE8_518C = false
local function _____6BD2_706B_67AF_7AED_6CBB_7597_4FEE_6B63(_source, target, amount, _isItemHeal)
    local runtime = getBuffRuntime(target, _____6BD2_706B_67AF_7AEDBuffID)
    if runtime == nil or not (runtime.effect > 0) then
        return amount
    end
    local modified = amount * (1 - runtime.effect)
    return modified
end
local function _____6697_706B_589E_5E45_6280_80FD_4F24_5BB3_4FEE_6B63(context)
    if context == nil then
        return 0
    end
    if context.attacker == nil or context.target == nil then
        return context.currentDamage
    end
    if GetUnitTypeId(context.attacker) ~= _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID or context.isSkillDamage ~= true then
        return context.currentDamage
    end
    local runtime = getBuffRuntime(context.target, _____6697_706B_589E_5E45BuffID)
    if runtime == nil or not (runtime.effect > 0) then
        return context.currentDamage
    end
    local before = context.currentDamage
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context.target, _____6697_706B_589E_5E45BuffID)
    local modified = before * (1 + runtime.effect)
    return modified
end
local function _____6EE1_8DB3_6697_706B_589E_5E45_6280_80FD_4F24_5BB3_6761_4EF6(context)
    if context == nil or context.attacker == nil or context.target == nil then
        return false
    end
    if GetUnitTypeId(context.attacker) ~= _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID or context.isSkillDamage ~= true then
        return false
    end
    local runtime = getBuffRuntime(context.target, _____6697_706B_589E_5E45BuffID)
    return runtime ~= nil and __TS__Number(runtime.effect) > 0
end
local function _____6CE8_518C_5143_7D20_7206_53D1_9644_52A0_6548_679C()
    if _____5143_7D20_7206_53D1_9644_52A0_6548_679C_5DF2_6CE8_518C then
        return
    end
    _____5143_7D20_7206_53D1_9644_52A0_6548_679C_5DF2_6CE8_518C = true
    registerHealCallback(_____6BD2_706B_67AF_7AED_6CBB_7597_4FEE_6B63)
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "菲尼克斯尔暗火增幅技能伤害", ["优先级"] = 86, ["条件"] = _____6EE1_8DB3_6697_706B_589E_5E45_6280_80FD_4F24_5BB3_6761_4EF6, ["修正"] = _____6697_706B_589E_5E45_6280_80FD_4F24_5BB3_4FEE_6B63})
end
local function _____53D6_5143_7D20_7279_6548(_____5143_7D20)
    if _____5143_7D20 == "冰" then
        return _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["元素爆发冰"]
    end
    if _____5143_7D20 == "毒" then
        return _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["元素爆发毒"]
    end
    if _____5143_7D20 == "暗" then
        return _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["元素爆发暗"]
    end
    return _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["元素爆发火"]
end
local function _____53D6_5143_7D20_97F3_6548(_____5143_7D20)
    if _____5143_7D20 == "冰" then
        return _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["元素爆发"]["冰"]
    end
    if _____5143_7D20 == "毒" then
        return _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["元素爆发"]["毒"]
    end
    if _____5143_7D20 == "暗" then
        return _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["元素爆发"]["暗"]
    end
    return _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["元素爆发"]["火"]
end
____exports["结算菲尼克斯尔元素爆发"] = function(context)
    if context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["元素爆发"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587("菲尼克斯尔元素爆发", config["吟唱秒"] + 2)
    _____5F00_59CB_65BD_6CD5_786C_76F4(context.Boss, config["吟唱秒"])
    _____8BBE_7F6E_5355_4F4D_52A8_753B(context.Boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["施法"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["施法"]["倍速"])
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "元素爆发")
    _____663E_793A_573A_5730_8BFB_6761(config["吟唱秒"], config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    _____5EF6_8FDF(
        config["吟唱秒"] * 1000,
        function()
            if context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
                return
            end
            local heroes = _____53D6_83F2_5C3C_514B_65AF_5C14_654C_5BF9_76EE_6807_5217_8868(context.Boss)
            do
                local i = 0
                while i < #heroes do
                    do
                        local hero = heroes[i + 1]
                        local top = _____53D6_6700_9AD8_5143_7D20(hero)
                        if top["层数"] <= 0 then
                            goto __continue27
                        end
                        local x = _____53D6_5355_4F4DX(hero)
                        local y = _____53D6_5355_4F4DY(hero)
                        local _____6280_80FD_5F3A_5EA6_500D_7387 = _____53D6_83F2_5C3C_514B_65AF_5C14_6280_80FD_5F3A_5EA6_500D_7387(context.Boss)
                        _____64AD_653E_70B9_7279_6548(
                            _____53D6_5143_7D20_7279_6548(top["元素"]),
                            x,
                            y,
                            1800
                        )
                        _____64AD_653EBoss_5750_6807_97F3_6548(
                            _____53D6_5143_7D20_97F3_6548(top["元素"]),
                            x,
                            y,
                            _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
                        )
                        if _____5355_4F4D_5B58_6D3B(context.Boss) and _____5355_4F4D_5B58_6D3B(hero) then
                            if top["元素"] == "冰" then
                                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                    ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                    ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                    ["来源"] = context.Boss,
                                    ["目标"] = hero,
                                    ["伤害公式"] = {["来源攻击力比例"] = config["冰伤害Boss攻击力比例"], ["目标最大生命比例"] = config["冰伤害目标最大生命比例"], ["总倍率"] = _____6280_80FD_5F3A_5EA6_500D_7387},
                                    ranged = true,
                                    attackType = ATTACK_TYPE_NORMAL,
                                    ["伤害类型"] = DAMAGE_TYPE_COLD,
                                    weaponType = WEAPON_TYPE_WHOKNOWS
                                })
                                _____5F00_59CB_5143_7D20_7206_53D1_786C_76F4(hero, config["冰硬直秒"])
                            elseif top["元素"] == "毒" then
                                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                    ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                    ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                    ["来源"] = context.Boss,
                                    ["目标"] = hero,
                                    ["伤害公式"] = {["目标已损生命比例"] = config["毒伤害目标已损失生命比例"], ["总倍率"] = _____6280_80FD_5F3A_5EA6_500D_7387},
                                    ranged = true,
                                    attackType = ATTACK_TYPE_NORMAL,
                                    ["伤害类型"] = DAMAGE_TYPE_POISON,
                                    weaponType = WEAPON_TYPE_WHOKNOWS
                                })
                                registerManualBuff(
                                    hero,
                                    _____6BD2_706B_67AF_7AEDBuffID,
                                    config["毒治疗降低持续秒"],
                                    config["毒治疗降低比例"],
                                    {stack = 1, sourceName = "菲尼克斯尔元素爆发"}
                                )
                            elseif top["元素"] == "暗" then
                                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                    ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                    ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                    ["来源"] = context.Boss,
                                    ["目标"] = hero,
                                    ["伤害公式"] = {["来源攻击力比例"] = config["暗伤害Boss攻击力比例"], ["目标最大生命比例"] = config["暗伤害目标最大生命比例"], ["总倍率"] = _____6280_80FD_5F3A_5EA6_500D_7387},
                                    ranged = true,
                                    attackType = ATTACK_TYPE_NORMAL,
                                    ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
                                    weaponType = WEAPON_TYPE_WHOKNOWS
                                })
                                registerManualBuff(
                                    hero,
                                    _____6697_706B_589E_5E45BuffID,
                                    config["暗下一次技能增伤持续秒"],
                                    config["暗下一次技能增伤比例"],
                                    {stack = 1, sourceName = "菲尼克斯尔元素爆发"}
                                )
                            else
                                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                                    ["技能实例ID"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["技能实例ID"],
                                    ["标签"] = _____4F24_5BB3_4E0A_4E0B_6587 and _____4F24_5BB3_4E0A_4E0B_6587["标签"],
                                    ["来源"] = context.Boss,
                                    ["目标"] = hero,
                                    ["伤害公式"] = {["来源攻击力比例"] = config["火伤害Boss攻击力比例"], ["目标最大生命比例"] = config["火伤害目标最大生命比例"], ["总倍率"] = _____6280_80FD_5F3A_5EA6_500D_7387},
                                    ranged = true,
                                    attackType = ATTACK_TYPE_NORMAL,
                                    ["伤害类型"] = DAMAGE_TYPE_FIRE,
                                    weaponType = WEAPON_TYPE_WHOKNOWS
                                })
                                _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_71C3_70E7_533A(context, x, y, _____4F24_5BB3_4E0A_4E0B_6587)
                            end
                        end
                        _____51CF_5C11_5143_7D20_5C42_6570(hero, top["元素"], config["结算后最高层降低"])
                    end
                    ::__continue27::
                    i = i + 1
                end
            end
        end
    )
end
____exports["初始化菲尼克斯尔元素爆发节点"] = function(context)
    if context["元素爆发已初始化"] then
        return
    end
    context["元素爆发已初始化"] = true
    local timerId = _____5468_671F(
        _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["元素爆发"]["周期秒"] * 1000,
        function()
            ____exports["结算菲尼克斯尔元素爆发"](context)
        end
    )
    local ____self_18 = context["清理"]
    ____self_18["登记周期回调"](____self_18, "菲尼克斯尔-元素爆发", timerId)
end
____exports["注册菲尼克斯尔元素爆发"] = function()
    _____6CE8_518C_5143_7D20_7206_53D1_9644_52A0_6548_679C()
end
return ____exports
