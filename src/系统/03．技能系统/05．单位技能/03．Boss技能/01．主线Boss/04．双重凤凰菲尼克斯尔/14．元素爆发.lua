--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具")
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_83F2_5C3C_514B_65AF_5C14_73A9_5BB6_82F1_96C4_5217_8868 = ____19_FF0E_516C_5171_5DE5_5177["取菲尼克斯尔玩家英雄列表"]
local _____53D6_6700_9AD8_5143_7D20 = ____19_FF0E_516C_5171_5DE5_5177["取最高元素"]
local _____51CF_5C11_5143_7D20_5C42_6570 = ____19_FF0E_516C_5171_5DE5_5177["减少元素层数"]
local _____663E_793A_573A_5730_8BFB_6761 = ____19_FF0E_516C_5171_5DE5_5177["显示场地读条"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____9020_6210_706B_7130_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成火焰伤害"]
local _____9020_6210_51B0_971C_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成冰霜伤害"]
local _____9020_6210_6BD2_706B_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成毒火伤害"]
local _____9020_6210_6697_706B_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["造成暗火伤害"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587 = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔独立伤害上下文"]
local _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["计算攻击最大生命伤害"]
local _____8BA1_7B97_653B_51FB_5DF2_635F_5931_4F24_5BB3 = ____19_FF0E_516C_5171_5DE5_5177["计算攻击已损失伤害"]
local _____53D6_6700_5927_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取最大生命"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
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
____exports["结算菲尼克斯尔元素爆发"] = function(context)
    if context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    local config = _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["元素爆发"]
    local _____4F24_5BB3_4E0A_4E0B_6587 = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_72EC_7ACB_4F24_5BB3_4E0A_4E0B_6587("菲尼克斯尔元素爆发", 3)
    _____8BBE_7F6E_5355_4F4D_52A8_753B(context.Boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["施法"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["施法"]["倍速"])
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "元素爆发")
    _____663E_793A_573A_5730_8BFB_6761(3, config["吟唱条颜色ID"], config["吟唱条标题文本"], config["吟唱条提示文本"])
    local heroes = _____53D6_83F2_5C3C_514B_65AF_5C14_73A9_5BB6_82F1_96C4_5217_8868()
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                local top = _____53D6_6700_9AD8_5143_7D20(hero)
                if top["层数"] <= 0 then
                    goto __continue9
                end
                _____64AD_653E_70B9_7279_6548(
                    _____53D6_5143_7D20_7279_6548(top["元素"]),
                    _____53D6_5355_4F4DX(hero),
                    _____53D6_5355_4F4DY(hero),
                    1800
                )
                if top["元素"] == "冰" then
                    _____9020_6210_51B0_971C_4F24_5BB3(
                        context.Boss,
                        hero,
                        _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3(context.Boss, hero, config["冰伤害Boss攻击力比例"], config["冰伤害目标最大生命比例"]),
                        "AOE",
                        _____4F24_5BB3_4E0A_4E0B_6587
                    )
                elseif top["元素"] == "毒" then
                    _____9020_6210_6BD2_706B_4F24_5BB3(
                        context.Boss,
                        hero,
                        (_____53D6_6700_5927_751F_547D(hero) - 0) * 0 + _____8BA1_7B97_653B_51FB_5DF2_635F_5931_4F24_5BB3(context.Boss, hero, 0, config["毒伤害目标已损失生命比例"]),
                        "AOE",
                        _____4F24_5BB3_4E0A_4E0B_6587
                    )
                elseif top["元素"] == "暗" then
                    _____9020_6210_6697_706B_4F24_5BB3(
                        context.Boss,
                        hero,
                        _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3(context.Boss, hero, config["暗伤害Boss攻击力比例"], config["暗伤害目标最大生命比例"]),
                        "AOE",
                        _____4F24_5BB3_4E0A_4E0B_6587
                    )
                else
                    _____9020_6210_706B_7130_4F24_5BB3(
                        context.Boss,
                        hero,
                        _____8BA1_7B97_653B_51FB_6700_5927_751F_547D_4F24_5BB3(context.Boss, hero, config["火伤害Boss攻击力比例"], config["火伤害目标最大生命比例"]),
                        "AOE",
                        _____4F24_5BB3_4E0A_4E0B_6587
                    )
                end
                _____51CF_5C11_5143_7D20_5C42_6570(hero, top["元素"], config["结算后最高层降低"])
            end
            ::__continue9::
            i = i + 1
        end
    end
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
    local ____self_0 = context["清理"]
    ____self_0["登记周期回调"](____self_0, "菲尼克斯尔-元素爆发", timerId)
end
____exports["注册菲尼克斯尔元素爆发"] = function()
end
return ____exports
