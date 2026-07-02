--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.02．数值与表现配置")
local _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲尼克斯尔数值与表现配置"]
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建菲尼克斯尔上下文"]
local _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8FD0_884C_65F6 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册菲尼克斯尔运行时"]
local ____05_FF0E_6C38_6052_51B0_6838_4E0E_5BFC_7BA1 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.05．永恒冰核与导管")
local _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6C38_6052_51B0_6838_4E0E_5BFC_7BA1 = ____05_FF0E_6C38_6052_51B0_6838_4E0E_5BFC_7BA1["初始化菲尼克斯尔永恒冰核与导管"]
local ____18_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.18．技能入口")
local _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_6280_80FD_7ED3_6784 = ____18_FF0E_6280_80FD_5165_53E3["注册菲尼克斯尔技能结构"]
local ____19_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.19．公共工具")
local stringToFourCC = ____19_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.01．Boss自动技能注册表")
local _____83B7_53D6_6240_6709Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587 = ____require_result_1["获取所有Boss自动技能启动上下文"]
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local _____83B7_53D6_5355_4F4DBuff_5C42_6570 = ____require_result_3["获取单位Buff层数"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____83F2_5C3C_514B_65AF_5C14_88AB_52A8_5DF2_6CE8_518C = false
local _____83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63_5DF2_6CE8_518C = false
local function _____626B_63CF_83F2_5C3C_514B_65AF_5C14_542F_52A8_4E0A_4E0B_6587()
    local contexts = _____83B7_53D6_6240_6709Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            do
                local item = contexts[i + 1]
                local ____temp_4
                if item ~= nil then
                    ____temp_4 = item["Boss单位"]
                else
                    ____temp_4 = nil
                end
                local boss = ____temp_4
                if boss == nil or boss == 0 or GetUnitTypeId(boss) ~= _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID then
                    goto __continue4
                end
                local context = _____83B7_53D6_6216_521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(boss)
                if context ~= nil then
                    _____521D_59CB_5316_83F2_5C3C_514B_65AF_5C14_6C38_6052_51B0_6838_4E0E_5BFC_7BA1(context)
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
end
local function _____83F2_5C3C_514B_65AF_5C14_5BFC_7BA1_7834_5C01_627F_4F24_4FEE_6B63(damageContext)
    local ____temp_5
    if damageContext ~= nil then
        ____temp_5 = damageContext.target
    else
        ____temp_5 = nil
    end
    local target = ____temp_5
    if target == nil or target == 0 or GetUnitTypeId(target) ~= _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_7C7B_578BID then
        return damageContext.currentDamage
    end
    local layers = _____83B7_53D6_5355_4F4DBuff_5C42_6570(target, _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E.BuffID["导管破封"])
    if layers <= 0 then
        return damageContext.currentDamage
    end
    return damageContext.currentDamage * (1 + layers * _____83F2_5C3C_514B_65AF_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["机制"]["每根导管承伤提高"])
end
local function _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63()
    if _____83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63_5DF2_6CE8_518C then
        return
    end
    _____83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63_5DF2_6CE8_518C = true
    registerDamageModifier(_____83F2_5C3C_514B_65AF_5C14_5BFC_7BA1_7834_5C01_627F_4F24_4FEE_6B63, 15)
end
____exports["注册菲尼克斯尔被动效果"] = function()
    if _____83F2_5C3C_514B_65AF_5C14_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____83F2_5C3C_514B_65AF_5C14_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_8FD0_884C_65F6()
    _____6CE8_518C_83F2_5C3C_514B_65AF_5C14_6280_80FD_7ED3_6784()
    _____786E_4FDD_83F2_5C3C_514B_65AF_5C14_627F_4F24_4FEE_6B63()
    addPeriodicCallback(1000, _____626B_63CF_83F2_5C3C_514B_65AF_5C14_542F_52A8_4E0A_4E0B_6587)
end
____exports["注册菲尼克斯尔被动效果"]()
return ____exports
