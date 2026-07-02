--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_6218_6597_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.index")
local _____521B_5EFA_52A8_6001_77E9_5F62_533A_57DF_7EC4 = ____02_FF0E_6218_6597_533A_57DF["创建动态矩形区域组"]
local _____9500_6BC1_52A8_6001_77E9_5F62_533A_57DF_7EC4 = ____02_FF0E_6218_6597_533A_57DF["销毁动态矩形区域组"]
____exports["巴尔扎罗斯战斗区域配置"] = {
    ID = "balzaroth-battlefield",
    ["名称"] = "巴尔扎罗斯战斗区域",
    ["左"] = 27104,
    ["右"] = 29568,
    ["下"] = -544,
    ["上"] = 2304
}
____exports["巴尔扎罗斯固定安全区配置表"] = {{
    ID = "balzaroth-safe-left",
    ["名称"] = "巴尔扎罗斯左侧安全区",
    ["左"] = 27424,
    ["右"] = 27872,
    ["下"] = 1728,
    ["上"] = 2240
}, {
    ID = "balzaroth-safe-right",
    ["名称"] = "巴尔扎罗斯右侧安全区",
    ["左"] = 28960,
    ["右"] = 29408,
    ["下"] = 1728,
    ["上"] = 2240
}}
____exports["创建巴尔扎罗斯战斗区域组"] = function()
    return _____521B_5EFA_52A8_6001_77E9_5F62_533A_57DF_7EC4("巴尔扎罗斯战斗区域", {____exports["巴尔扎罗斯战斗区域配置"]})
end
____exports["清理巴尔扎罗斯战斗区域组"] = function(_____533A_57DF_7EC4)
    _____9500_6BC1_52A8_6001_77E9_5F62_533A_57DF_7EC4(_____533A_57DF_7EC4)
end
return ____exports
