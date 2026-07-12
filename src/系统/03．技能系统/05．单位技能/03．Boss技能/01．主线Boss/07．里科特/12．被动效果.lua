--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.01．运行时上下文")
local _____6CE8_518C_91CC_79D1_7279_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册里科特运行时"]
local ____11_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.11．技能入口")
local _____6CE8_518C_91CC_79D1_7279_6280_80FD_7ED3_6784 = ____11_FF0E_6280_80FD_5165_53E3["注册里科特技能结构"]
local _____91CC_79D1_7279_88AB_52A8_5DF2_6CE8_518C = false
____exports["注册里科特被动效果"] = function()
    if _____91CC_79D1_7279_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____91CC_79D1_7279_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_91CC_79D1_7279_8FD0_884C_65F6()
    _____6CE8_518C_91CC_79D1_7279_6280_80FD_7ED3_6784()
end
____exports["注册里科特被动效果"]()
return ____exports
