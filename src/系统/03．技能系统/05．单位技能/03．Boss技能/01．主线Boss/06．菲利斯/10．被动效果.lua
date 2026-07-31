--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.01．运行时上下文")
local _____6CE8_518C_83F2_5229_65AF_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册菲利斯运行时"]
local ____09_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.09．技能入口")
local _____6CE8_518C_83F2_5229_65AF_6280_80FD_7ED3_6784 = ____09_FF0E_6280_80FD_5165_53E3["注册菲利斯技能结构"]
local ____12_FF0E_7B2C_4E8C_519B_56E2_968F_4ECE = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.06．菲利斯.12．第二军团随从")
local _____6CE8_518C_83F2_5229_65AF_7B2C_4E8C_519B_56E2_968F_4ECE_6548_679C = ____12_FF0E_7B2C_4E8C_519B_56E2_968F_4ECE["注册菲利斯第二军团随从效果"]
local _____83F2_5229_65AF_88AB_52A8_5DF2_6CE8_518C = false
____exports["注册菲利斯被动效果"] = function()
    if _____83F2_5229_65AF_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____83F2_5229_65AF_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_83F2_5229_65AF_8FD0_884C_65F6()
    _____6CE8_518C_83F2_5229_65AF_6280_80FD_7ED3_6784()
    _____6CE8_518C_83F2_5229_65AF_7B2C_4E8C_519B_56E2_968F_4ECE_6548_679C()
end
____exports["注册菲利斯被动效果"]()
return ____exports
