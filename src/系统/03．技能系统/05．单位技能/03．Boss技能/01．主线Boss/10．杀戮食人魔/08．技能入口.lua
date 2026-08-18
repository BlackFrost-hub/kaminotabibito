--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB_673A_5236 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.01．共享机制")
local _____6CE8_518C_98DF_4EBA_9B54_5171_4EAB_673A_5236 = ____01_FF0E_5171_4EAB_673A_5236["注册食人魔共享机制"]
local ____02_FF0E_5FC3_810F_638C_63E1 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.02．心脏掌握")
local _____6CE8_518C_98DF_4EBA_9B54_5FC3_810F_638C_63E1 = ____02_FF0E_5FC3_810F_638C_63E1["注册食人魔心脏掌握"]
local ____03_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.03．被动效果")
local _____6CE8_518C_6740_622E_98DF_4EBA_9B54_88AB_52A8_6548_679C = ____03_FF0E_88AB_52A8_6548_679C["注册杀戮食人魔被动效果"]
local ____04_FF0E_6DF1_6E0A_9B54_5492 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.04．深渊魔咒")
local _____6CE8_518C_6740_622E_98DF_4EBA_9B54_6DF1_6E0A_9B54_5492 = ____04_FF0E_6DF1_6E0A_9B54_5492["注册杀戮食人魔深渊魔咒"]
local ____05_FF0E_8840_6D77_7EDE_6740 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.05．血海绞杀")
local _____6CE8_518C_6740_622E_98DF_4EBA_9B54_8840_6D77_7EDE_6740 = ____05_FF0E_8840_6D77_7EDE_6740["注册杀戮食人魔血海绞杀"]
local ____06_FF0E_75DB_4E4B_675F_7F1A = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.06．痛之束缚")
local _____6CE8_518C_6740_622E_98DF_4EBA_9B54_75DB_4E4B_675F_7F1A = ____06_FF0E_75DB_4E4B_675F_7F1A["注册杀戮食人魔痛之束缚"]
local ____07_FF0E_96F7_9706_9707_6012 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.07．雷霆震怒")
local _____6CE8_518C_6740_622E_98DF_4EBA_9B54_96F7_9706_9707_6012 = ____07_FF0E_96F7_9706_9707_6012["注册杀戮食人魔雷霆震怒"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____6740_622E_98DF_4EBA_9B54_6280_80FD_7ED3_6784_5DF2_6CE8_518C = false
____exports["注册杀戮食人魔技能结构"] = function()
    if _____6740_622E_98DF_4EBA_9B54_6280_80FD_7ED3_6784_5DF2_6CE8_518C then
        debugLogForce("杀戮食人魔-技能入口", "重复注册请求已忽略")
        return
    end
    _____6740_622E_98DF_4EBA_9B54_6280_80FD_7ED3_6784_5DF2_6CE8_518C = true
    _____6CE8_518C_98DF_4EBA_9B54_5171_4EAB_673A_5236()
    _____6CE8_518C_98DF_4EBA_9B54_5FC3_810F_638C_63E1()
    _____6CE8_518C_6740_622E_98DF_4EBA_9B54_88AB_52A8_6548_679C()
    _____6CE8_518C_6740_622E_98DF_4EBA_9B54_6DF1_6E0A_9B54_5492()
    _____6CE8_518C_6740_622E_98DF_4EBA_9B54_8840_6D77_7EDE_6740()
    _____6CE8_518C_6740_622E_98DF_4EBA_9B54_75DB_4E4B_675F_7F1A()
    _____6CE8_518C_6740_622E_98DF_4EBA_9B54_96F7_9706_9707_6012()
end
return ____exports
