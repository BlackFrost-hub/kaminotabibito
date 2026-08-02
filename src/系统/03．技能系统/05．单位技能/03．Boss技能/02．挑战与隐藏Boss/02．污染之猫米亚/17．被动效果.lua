--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建米亚上下文"]
local _____6CE8_518C_7C73_4E9A_8FD0_884C_65F6 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册米亚运行时"]
local ____16_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.16．技能入口")
local _____6CE8_518C_7C73_4E9A_6280_80FD_7ED3_6784 = ____16_FF0E_6280_80FD_5165_53E3["注册米亚技能结构"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local _____7C73_4E9A_5355_4F4D_7C7B_578BID = stringToFourCC(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____7C73_4E9A_542F_52A8_76D1_542C_5DF2_6CE8_518C = false
local function ____on_7C73_4E9ABoss_542F_52A8(context)
    _____83B7_53D6_6216_521B_5EFA_7C73_4E9A_4E0A_4E0B_6587(context["Boss单位"])
end
____exports["注册米亚被动效果"] = function()
    if _____7C73_4E9A_542F_52A8_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_542F_52A8_76D1_542C_5DF2_6CE8_518C = true
    _____6CE8_518C_7C73_4E9A_8FD0_884C_65F6()
    _____6CE8_518C_7C73_4E9A_6280_80FD_7ED3_6784()
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "米亚运行时上下文绑定", ["单位类型ID"] = _____7C73_4E9A_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_7C73_4E9ABoss_542F_52A8})
end
____exports["注册米亚被动效果"]()
return ____exports
