--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____12_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.12．技能入口")
local _____6CE8_518C_5361_745F_62C9_6280_80FD_7ED3_6784 = ____12_FF0E_6280_80FD_5165_53E3["注册卡瑟拉技能结构"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建卡瑟拉上下文"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.00．配置")
local _____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["卡瑟拉单位技能配置"]
local ____14_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.03．深渊巨鱿卡瑟拉.14．公共工具")
local stringToFourCC = ____14_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local _____5361_745F_62C9_5355_4F4D_7C7B_578BID = stringToFourCC(_____5361_745F_62C9_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____5361_745F_62C9_88AB_52A8_5DF2_6CE8_518C = false
local function ____on_5361_745F_62C9Boss_542F_52A8(_____542F_52A8_4E0A_4E0B_6587)
    _____83B7_53D6_6216_521B_5EFA_5361_745F_62C9_4E0A_4E0B_6587(_____542F_52A8_4E0A_4E0B_6587["Boss单位"])
end
____exports["注册卡瑟拉被动效果"] = function()
    if _____5361_745F_62C9_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____5361_745F_62C9_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_5361_745F_62C9_6280_80FD_7ED3_6784()
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "卡瑟拉运行时上下文绑定", ["单位类型ID"] = _____5361_745F_62C9_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_5361_745F_62C9Boss_542F_52A8})
end
____exports["注册卡瑟拉被动效果"]()
return ____exports
