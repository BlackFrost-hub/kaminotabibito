--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建里科特上下文"]
local _____6CE8_518C_91CC_79D1_7279_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册里科特运行时"]
local ____11_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.11．技能入口")
local _____6CE8_518C_91CC_79D1_7279_6280_80FD_7ED3_6784 = ____11_FF0E_6280_80FD_5165_53E3["注册里科特技能结构"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.07．里科特.13．公共工具")
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local _____91CC_79D1_7279_88AB_52A8_5DF2_6CE8_518C = false
local _____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local function ____on_91CC_79D1_7279Boss_542F_52A8(_____542F_52A8_4E0A_4E0B_6587)
    _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(_____542F_52A8_4E0A_4E0B_6587["Boss单位"])
end
____exports["注册里科特被动效果"] = function()
    if _____91CC_79D1_7279_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____91CC_79D1_7279_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_91CC_79D1_7279_8FD0_884C_65F6()
    _____6CE8_518C_91CC_79D1_7279_6280_80FD_7ED3_6784()
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "里科特运行时上下文绑定", ["单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_91CC_79D1_7279Boss_542F_52A8})
end
____exports["注册里科特被动效果"]()
return ____exports
