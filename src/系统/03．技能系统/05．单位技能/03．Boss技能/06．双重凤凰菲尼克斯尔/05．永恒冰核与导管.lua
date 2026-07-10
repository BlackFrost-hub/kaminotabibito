--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["菲尼克斯尔场地配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔音效配置"]
local ____17_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.17．台词播放")
local _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD = ____17_FF0E_53F0_8BCD_64AD_653E["播放菲尼克斯尔台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.19．公共工具")
local _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D = ____19_FF0E_516C_5171_5DE5_5177["创建菲尼克斯尔机制单位"]
local _____53D6_6700_5927_751F_547D = ____19_FF0E_516C_5171_5DE5_5177["取最大生命"]
local _____64AD_653E_70B9_7279_6548 = ____19_FF0E_516C_5171_5DE5_5177["播放点特效"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_516C_5171_5DE5_5177["单位有效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_0["创建单位绑定闪电"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____95EA_7535_6548_679C_4EE3_7801 = ____require_result_1["闪电效果代码"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local function ____on_83F2_5C3C_514B_65AF_5C14_5BFC_7BA1_6B7B_4EA1(context, unit)
    if context["当前形态"] ~= "第一形态" then
        return
    end
    context["已摧毁导管数"] = context["已摧毁导管数"] + 1
    _____64AD_653E_70B9_7279_6548(
        _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["特效"]["导管死亡"],
        GetUnitX(unit),
        GetUnitY(unit),
        1800
    )
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["导管死亡"]["小封印破口"],
        GetUnitX(unit),
        GetUnitY(unit),
        _____83F2_5C3C_514B_65AF_5C14_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    registerManualBuff(
        context.Boss,
        _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["导管破封"],
        3600,
        context["已摧毁导管数"],
        {stack = context["已摧毁导管数"], sourceName = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位名称"]}
    )
    if context["已摧毁导管数"] >= _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["导管数量"] then
        local mod = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.09．浴火重生准备")
        mod["触发菲尼克斯尔P1转场"](context)
    else
        _____64AD_653E_83F2_5C3C_514B_65AF_5C14_53F0_8BCD(context.Boss, "导管摧毁")
    end
end
local function _____521B_5EFA_5BFC_7BA1_6B7B_4EA1_56DE_8C03(context)
    return function(unit)
        ____on_83F2_5C3C_514B_65AF_5C14_5BFC_7BA1_6B7B_4EA1(context, unit)
    end
end
____exports["初始化菲尼克斯尔永恒冰核与导管"] = function(context)
    if context["P1机制已初始化"] then
        return
    end
    context["P1机制已初始化"] = true
    local maxLife = _____53D6_6700_5927_751F_547D(context.Boss)
    local ice = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["永恒冰核点"]
    context["永恒冰核"] = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D(
        context,
        _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["机制单位ID"]["永恒冰核"],
        "永恒冰核",
        _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["模型"]["永恒冰核"],
        ice.x,
        ice.y,
        9999999
    )
    local points = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["导管点位"]
    do
        local i = 0
        while i < #points do
            local p = points[i + 1]
            local conduit = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_673A_5236_5355_4F4D(
                context,
                _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["机制单位ID"]["能量导管"],
                "能量导管" .. tostring(i + 1),
                _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["模型"]["能量导管"],
                p.x,
                p.y,
                maxLife * _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["导管生命Boss最大生命比例"],
                _____521B_5EFA_5BFC_7BA1_6B7B_4EA1_56DE_8C03(context)
            )
            local ____context__5BFC_7BA1_5217_8868_3 = context["导管列表"]
            ____context__5BFC_7BA1_5217_8868_3[#____context__5BFC_7BA1_5217_8868_3 + 1] = {["单位"] = conduit, ["已摧毁"] = false}
            if _____5355_4F4D_6709_6548(conduit) and _____5355_4F4D_6709_6548(context["永恒冰核"]) then
                local lightning = _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({
                    ["效果代码"] = _____95EA_7535_6548_679C_4EE3_7801["蓝色细束"],
                    ["起点单位"] = conduit,
                    ["终点单位"] = context["永恒冰核"],
                    ["持续时间"] = 3600,
                    ["起点高度偏移"] = 90,
                    ["终点高度偏移"] = 140,
                    ["任一死亡时销毁"] = true
                })
                local ____self_4 = context["清理"]
                ____self_4["登记闪电"](____self_4, "菲尼克斯尔导管闪电", lightning)
            end
            i = i + 1
        end
    end
end
____exports["注册菲尼克斯尔永恒冰核与导管"] = function()
end
return ____exports
