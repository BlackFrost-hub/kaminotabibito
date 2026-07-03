--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____6CE8_518C_5361_745F_62C9_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册卡瑟拉运行时"]
local ____12_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.10．深渊巨鱿卡瑟拉.12．技能入口")
local _____6CE8_518C_5361_745F_62C9_6280_80FD_7ED3_6784 = ____12_FF0E_6280_80FD_5165_53E3["注册卡瑟拉技能结构"]
local _____5361_745F_62C9_88AB_52A8_5DF2_6CE8_518C = false
____exports["注册卡瑟拉被动效果"] = function()
    if _____5361_745F_62C9_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____5361_745F_62C9_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_5361_745F_62C9_8FD0_884C_65F6()
    _____6CE8_518C_5361_745F_62C9_6280_80FD_7ED3_6784()
end
____exports["注册卡瑟拉被动效果"]()
return ____exports
