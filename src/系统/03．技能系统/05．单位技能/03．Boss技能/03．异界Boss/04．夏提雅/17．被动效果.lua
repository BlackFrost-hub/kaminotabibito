--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.00．配置")
local _____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["夏提雅单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建夏提雅运行时上下文"]
local _____6CE8_518C_590F_63D0_96C5_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册夏提雅运行时"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____14_FF0E_6280_80FD_8C03_5EA6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.14．技能调度")
local _____6CE8_518C_590F_63D0_96C5_6280_80FD_8C03_5EA6 = ____14_FF0E_6280_80FD_8C03_5EA6["注册夏提雅技能调度"]
local ____03_FF0E_6EF4_7BA1_957F_67AA_8FDE_51FB = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.03．滴管长枪连击")
local _____6CE8_518C_590F_63D0_96C5_6EF4_7BA1_957F_67AA_8FDE_51FB = ____03_FF0E_6EF4_7BA1_957F_67AA_8FDE_51FB["注册夏提雅滴管长枪连击"]
local ____15_FF0E_6311_6218_5165_53E3_4E0E_6536_675F = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.15．挑战入口与收束")
local _____7ED1_5B9A_590F_63D0_96C5_6311_6218_751F_547D_4E0B_9650 = ____15_FF0E_6311_6218_5165_53E3_4E0E_6536_675F["绑定夏提雅挑战生命下限"]
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local _____590F_63D0_96C5_5355_4F4D_7C7B_578BID = stringToFourCC(_____590F_63D0_96C5_5355_4F4D_6280_80FD_914D_7F6E["正式单位ID"])
local _____590F_63D0_96C5_88AB_52A8_5DF2_6CE8_518C = false
local function ____on_590F_63D0_96C5Boss_542F_52A8(context)
    local runtime = _____83B7_53D6_6216_521B_5EFA_590F_63D0_96C5_8FD0_884C_65F6_4E0A_4E0B_6587(context["Boss单位"])
    if runtime ~= nil then
        _____7ED1_5B9A_590F_63D0_96C5_6311_6218_751F_547D_4E0B_9650(runtime)
    end
end
____exports["注册夏提雅被动效果"] = function()
    if _____590F_63D0_96C5_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____590F_63D0_96C5_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_590F_63D0_96C5_8FD0_884C_65F6()
    _____6CE8_518C_590F_63D0_96C5_6EF4_7BA1_957F_67AA_8FDE_51FB()
    _____6CE8_518C_590F_63D0_96C5_6280_80FD_8C03_5EA6()
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "夏提雅运行时上下文绑定", ["单位类型ID"] = _____590F_63D0_96C5_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_590F_63D0_96C5Boss_542F_52A8})
end
____exports["夏提雅被动效果状态"] = {
    ["已设计"] = true,
    ["已实现"] = true,
    ["已注册"] = true,
    ["包含机制"] = {
        "Boss启动上下文绑定",
        "强化普攻监听",
        "猎血段数过期",
        "鲜血枯竭",
        "血印上限",
        "P1/P2/P3单向阶段阈值",
        "一次性复生锁血",
        "第二次致死挑战收束",
        "统一清理篮子"
    },
    ["待实现机制"] = {}
}
____exports["注册夏提雅被动效果"]()
return ____exports
