--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB_673A_5236 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.01．共享机制")
local _____6CE8_518C_98DF_4EBA_9B54_5171_4EAB_673A_5236 = ____01_FF0E_5171_4EAB_673A_5236["注册食人魔共享机制"]
local ____02_FF0E_5FC3_810F_638C_63E1 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.02．心脏掌握")
local _____6CE8_518C_98DF_4EBA_9B54_5FC3_810F_638C_63E1 = ____02_FF0E_5FC3_810F_638C_63E1["注册食人魔心脏掌握"]
local ____01_FF0E_88AB_52A8_6548_679C = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.01．被动效果")
local _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_88AB_52A8_6548_679C = ____01_FF0E_88AB_52A8_6548_679C["注册沙漠食人魔被动效果"]
local ____03_FF0E_98DF_4EBA_9B54_5492 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.03．食人魔咒")
local _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_5492 = ____03_FF0E_98DF_4EBA_9B54_5492["注册沙漠食人魔咒"]
local ____04_FF0E_98CE_66B4_4E4B_9524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.04．风暴之锤")
local _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_98CE_66B4_4E4B_9524 = ____04_FF0E_98CE_66B4_4E4B_9524["注册沙漠食人魔风暴之锤"]
local ____05_FF0E_96F7_9706_6572_6253 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.05．雷霆敲打")
local _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_96F7_9706_6572_6253 = ____05_FF0E_96F7_9706_6572_6253["注册沙漠食人魔雷霆敲打"]
local ____06_FF0E_96F7_9706_9707_6012 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.06．雷霆震怒")
local _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_96F7_9706_9707_6012 = ____06_FF0E_96F7_9706_9707_6012["注册沙漠食人魔雷霆震怒"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_7ED3_6784_5DF2_6CE8_518C = false
____exports["注册沙漠食人魔技能结构"] = function()
    if _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_7ED3_6784_5DF2_6CE8_518C then
        return
    end
    _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_7ED3_6784_5DF2_6CE8_518C = true
    _____6CE8_518C_98DF_4EBA_9B54_5171_4EAB_673A_5236()
    _____6CE8_518C_98DF_4EBA_9B54_5FC3_810F_638C_63E1()
    _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_88AB_52A8_6548_679C()
    _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_5492()
    _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_98CE_66B4_4E4B_9524()
    _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_96F7_9706_6572_6253()
    _____6CE8_518C_6C99_6F20_98DF_4EBA_9B54_96F7_9706_9707_6012()
    debugLogForce("沙漠食人魔-技能入口", "技能结构注册完成")
end
return ____exports
