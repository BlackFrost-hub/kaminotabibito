--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["菲尼克斯尔场地配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔音效配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.04．双重凤凰菲尼克斯尔.19．公共工具")
local _____5EF6_8FDF = ____19_FF0E_516C_5171_5DE5_5177["延迟"]
local _____5468_671F = ____19_FF0E_516C_5171_5DE5_5177["周期"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_516C_5171_5DE5_5177["单位存活"]
local _____53D6_6700_5927_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取最大生命"]
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔机制单位"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____53D6_5355_4F4DX = ____19_FF0E_516C_5171_5DE5_5177["取单位X"]
local _____53D6_5355_4F4DY = ____19_FF0E_516C_5171_5DE5_5177["取单位Y"]
local _____8BBE_7F6E_5355_4F4D_52A8_753B = ____19_FF0E_516C_5171_5DE5_5177["设置单位动画"]
local jass = require("jass.common")
local RemoveUnit = jass.RemoveUnit
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_0["造成单体技能伤害"]
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_751F_547D_503C = ____require_result_1["减少生命值"]
local function ____on_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_6B7B_4EA1(context, unit, killer)
    context["怨火核心暴露中"] = false
    local damage = _____53D6_6700_5927_751F_547D(context.Boss) * _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["怨火核心摧毁Boss最大生命伤害比例"]
    if killer ~= nil and killer ~= 0 then
        local _____5DF2_9020_6210_4F24_5BB3 = _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
            ["来源"] = killer,
            ["目标"] = context.Boss,
            ["伤害"] = damage,
            ["伤害类型"] = DAMAGE_TYPE_MIND,
            ["来源类型"] = "其他",
            ["标签"] = "菲尼克斯尔-摧毁怨火核心",
            ["参与技能伤害加成"] = false
        })
        if not _____5DF2_9020_6210_4F24_5BB3 then
            _____51CF_5C11_751F_547D_503C(context.Boss, damage)
        end
    else
        _____51CF_5C11_751F_547D_503C(context.Boss, damage)
    end
    _____64AD_653E_70B9_7279_6548(
        _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["核心暴露"],
        _____53D6_5355_4F4DX(unit),
        _____53D6_5355_4F4DY(unit),
        1800
    )
end
local function _____521B_5EFA_6028_706B_6838_5FC3_6B7B_4EA1_56DE_8C03(context)
    return function(unit, killer)
        ____on_83F2_5C3C_514B_65AF_5C14_6028_706B_6838_5FC3_6B7B_4EA1(context, unit, killer)
    end
end
____exports["触发菲尼克斯尔怨火核心暴露"] = function(context)
    if context["怨火核心暴露中"] or context["当前形态"] ~= "第二形态" or not _____5355_4F4D_5B58_6D3B(context.Boss) then
        return
    end
    context["怨火核心暴露中"] = true
    _____8BBE_7F6E_5355_4F4D_52A8_753B(context.Boss, _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["施法"]["编号"], _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["动画"]["第二形态"]["施法"]["倍速"])
    _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "怨火核心暴露")
    local center = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"]
    context["怨火核心"] = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D(
        context,
        _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["机制单位ID"]["怨火核心"],
        "怨火核心",
        _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["模型"]["怨火核心"],
        center.x,
        center.y,
        _____53D6_6700_5927_751F_547D(context.Boss) * _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["怨火核心生命Boss最大生命比例"],
        _____521B_5EFA_6028_706B_6838_5FC3_6B7B_4EA1_56DE_8C03(context)
    )
    _____64AD_653E_70B9_7279_6548(_____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["核心暴露"], center.x, center.y, 2500)
    _____64AD_653EBoss_5750_6807_97F3_6548(_____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["怨火核心"]["暴露"], center.x, center.y, _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"])
    _____5EF6_8FDF(
        _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["怨火核心暴露持续秒"] * 1000,
        function()
            if _____5355_4F4D_5B58_6D3B(context["怨火核心"]) then
                RemoveUnit(context["怨火核心"])
                context["怨火核心"] = nil
            end
            context["怨火核心暴露中"] = false
        end
    )
end
____exports["初始化菲尼克斯尔怨火核心暴露节点"] = function(context)
    if context["怨火核心暴露已初始化"] then
        return
    end
    context["怨火核心暴露已初始化"] = true
    local timerId = _____5468_671F(
        _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["怨火核心周期暴露秒"] * 1000,
        function()
            ____exports["触发菲尼克斯尔怨火核心暴露"](context)
        end
    )
    local ____self_2 = context["清理"]
    ____self_2["登记周期回调"](____self_2, "菲尼克斯尔-怨火核心周期暴露", timerId)
end
return ____exports
