--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_9ED1_9B54_6CD5_4FB5_8680 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.03．黑魔法侵蚀")
local _____6CE8_518C_6559_6D3E_5251_58EB_9ED1_9B54_6CD5_4FB5_8680 = ____03_FF0E_9ED1_9B54_6CD5_4FB5_8680["注册教派剑士黑魔法侵蚀"]
local ____04_FF0E_6DF1_6E0A_65CB_98CE = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.04．深渊旋风")
local _____6CE8_518C_6559_6D3E_5251_58EB_6DF1_6E0A_65CB_98CE = ____04_FF0E_6DF1_6E0A_65CB_98CE["注册教派剑士深渊旋风"]
local ____05_FF0E_9ED1_6D1E_8DE8_8D8A = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.05．黑洞跨越")
local _____6CE8_518C_6559_6D3E_5251_58EB_9ED1_6D1E_8DE8_8D8A = ____05_FF0E_9ED1_6D1E_8DE8_8D8A["注册教派剑士黑洞跨越"]
local ____06_FF0E_9B54_796D_5438_9B42 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.06．魔祭吸魂")
local _____6CE8_518C_6559_6D3E_5251_58EB_9B54_796D_5438_9B42 = ____06_FF0E_9B54_796D_5438_9B42["注册教派剑士魔祭吸魂"]
local ____07_FF0E_6DF1_6E0A_5206_8EAB = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.07．深渊分身")
local _____6CE8_518C_6559_6D3E_5251_58EB_6DF1_6E0A_5206_8EAB = ____07_FF0E_6DF1_6E0A_5206_8EAB["注册教派剑士深渊分身"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local _____6559_6D3E_5251_58EB_6280_80FD_7ED3_6784_5DF2_6CE8_518C = false
____exports["注册教派剑士技能结构"] = function()
    if _____6559_6D3E_5251_58EB_6280_80FD_7ED3_6784_5DF2_6CE8_518C then
        return
    end
    _____6559_6D3E_5251_58EB_6280_80FD_7ED3_6784_5DF2_6CE8_518C = true
    _____6CE8_518C_6559_6D3E_5251_58EB_9ED1_9B54_6CD5_4FB5_8680()
    _____6CE8_518C_6559_6D3E_5251_58EB_6DF1_6E0A_65CB_98CE()
    _____6CE8_518C_6559_6D3E_5251_58EB_9ED1_6D1E_8DE8_8D8A()
    _____6CE8_518C_6559_6D3E_5251_58EB_9B54_796D_5438_9B42()
    _____6CE8_518C_6559_6D3E_5251_58EB_6DF1_6E0A_5206_8EAB()
    debugLogForce("教派剑士-技能入口", "黑魔法侵蚀与四个主动技能注册完成")
end
return ____exports
