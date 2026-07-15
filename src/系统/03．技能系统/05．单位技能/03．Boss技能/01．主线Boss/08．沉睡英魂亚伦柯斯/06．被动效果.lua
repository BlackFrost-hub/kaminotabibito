--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.00．配置")
local _____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["亚伦柯斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建亚伦柯斯运行时上下文"]
local _____6CE8_518C_4E9A_4F26_67EF_65AF_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册亚伦柯斯运行时"]
local ____10_FF0E_6280_80FD_8C03_5EA6 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.10．技能调度")
local _____6CE8_518C_4E9A_4F26_67EF_65AF_6280_80FD_8C03_5EA6 = ____10_FF0E_6280_80FD_8C03_5EA6["注册亚伦柯斯技能调度"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local _____4E9A_4F26_67EF_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____4E9A_4F26_67EF_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____4E9A_4F26_67EF_65AF_88AB_52A8_5DF2_6CE8_518C = false
local function ____on_4E9A_4F26_67EF_65AFBoss_542F_52A8(context)
    _____83B7_53D6_6216_521B_5EFA_4E9A_4F26_67EF_65AF_8FD0_884C_65F6_4E0A_4E0B_6587(context["Boss单位"])
end
____exports["注册亚伦柯斯被动效果"] = function()
    if _____4E9A_4F26_67EF_65AF_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____4E9A_4F26_67EF_65AF_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_4E9A_4F26_67EF_65AF_8FD0_884C_65F6()
    _____6CE8_518C_4E9A_4F26_67EF_65AF_6280_80FD_8C03_5EA6()
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "亚伦柯斯运行时上下文绑定", ["单位类型ID"] = _____4E9A_4F26_67EF_65AF_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_4E9A_4F26_67EF_65AFBoss_542F_52A8})
end
____exports["亚伦柯斯被动效果状态"] = {["已设计"] = true, ["已实现"] = true, ["已注册"] = true, ["包含机制"] = {
    "Boss启动上下文绑定",
    "阶段生命阈值",
    "墓碑血量锁",
    "不灭军魂",
    "最终强化",
    "战败归静",
    "统一清理篮子"
}}
____exports["注册亚伦柯斯被动效果"]()
return ____exports
