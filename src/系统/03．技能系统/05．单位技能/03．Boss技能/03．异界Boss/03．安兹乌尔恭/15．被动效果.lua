--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.00．配置")
local _____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安兹乌尔恭单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建安兹运行时上下文"]
local _____6CE8_518C_5B89_5179_8FD0_884C_65F6 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册安兹运行时"]
local ____14_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.14．技能入口")
local _____6CE8_518C_5B89_5179_6280_80FD_7ED3_6784 = ____14_FF0E_6280_80FD_5165_53E3["注册安兹技能结构"]
local ____12_FF0E_5B88_62A4_8005_6A21_5F0F = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．守护者模式")
local _____542F_52A8_5B89_5179_5B88_62A4_8005_6A21_5F0F = ____12_FF0E_5B88_62A4_8005_6A21_5F0F["启动安兹守护者模式"]
local ____13_FF0E_6311_6218_5165_53E3_4E0E_6536_675F = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.13．挑战入口与收束")
local _____7ED1_5B9A_5B89_5179_6311_6218_751F_547D_4E0B_9650 = ____13_FF0E_6311_6218_5165_53E3_4E0E_6536_675F["绑定安兹挑战生命下限"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local _____5B89_5179_5355_4F4D_7C7B_578BID = stringToFourCC(_____5B89_5179_4E4C_5C14_606D_5355_4F4D_6280_80FD_914D_7F6E["正式单位ID"])
local _____5B89_5179_88AB_52A8_5DF2_6CE8_518C = false
local function ____on_5B89_5179Boss_542F_52A8(context)
    local runtime = _____83B7_53D6_6216_521B_5EFA_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587(context["Boss单位"])
    if runtime ~= nil then
        _____7ED1_5B9A_5B89_5179_6311_6218_751F_547D_4E0B_9650(runtime)
        _____542F_52A8_5B89_5179_5B88_62A4_8005_6A21_5F0F(runtime)
    end
end
____exports["注册安兹被动效果"] = function()
    if _____5B89_5179_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____5B89_5179_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_5B89_5179_8FD0_884C_65F6()
    _____6CE8_518C_5B89_5179_6280_80FD_7ED3_6784()
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({["名称"] = "安兹运行时上下文绑定", ["单位类型ID"] = _____5B89_5179_5355_4F4D_7C7B_578BID, ["on启动"] = ____on_5B89_5179Boss_542F_52A8})
end
____exports["安兹被动效果状态"] = {
    ["已设计"] = true,
    ["已实现"] = true,
    ["已注册"] = true,
    ["包含机制"] = {"Boss启动上下文绑定", "阶段生命阈值", "死亡清理", "雅儿贝德显式绑定接口"},
    ["待实现机制"] = {}
}
____exports["注册安兹被动效果"]()
return ____exports
