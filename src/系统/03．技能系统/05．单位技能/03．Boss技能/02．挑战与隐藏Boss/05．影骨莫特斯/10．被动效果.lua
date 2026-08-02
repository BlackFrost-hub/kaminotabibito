--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.01．运行时上下文")
local _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册影骨莫特斯运行时"]
local _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建影骨莫特斯上下文"]
local ____09_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.09．技能入口")
local _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_6280_80FD_7ED3_6784 = ____09_FF0E_6280_80FD_5165_53E3["注册影骨莫特斯技能结构"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.00．配置")
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["影骨莫特斯单位技能配置"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.05．影骨莫特斯.11．公共工具")
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local _____5F71_9AA8_83AB_7279_65AF_88AB_52A8_5DF2_6CE8_518C = false
local _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____5F71_9AA8_83AB_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local function ____on_5F71_9AA8_83AB_7279_65AFBoss_542F_52A8(context)
    _____83B7_53D6_6216_521B_5EFA_5F71_9AA8_83AB_7279_65AF_4E0A_4E0B_6587(context["Boss单位"])
end
____exports["注册影骨莫特斯被动效果"] = function()
    if _____5F71_9AA8_83AB_7279_65AF_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____5F71_9AA8_83AB_7279_65AF_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_8FD0_884C_65F6()
    _____6CE8_518C_5F71_9AA8_83AB_7279_65AF_6280_80FD_7ED3_6784()
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "影骨莫特斯运行时上下文绑定", ["单位类型ID"] = _____5F71_9AA8_83AB_7279_65AF_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_5F71_9AA8_83AB_7279_65AFBoss_542F_52A8})
end
____exports["注册影骨莫特斯被动效果"]()
return ____exports
