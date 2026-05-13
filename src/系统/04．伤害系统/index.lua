--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.04．伤害系统.01．DOT定义.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.01．伤害事件")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．dot伤害")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.03．伤害测试")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.00．伤害计算.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.04．伤害系统.01．伤害事件")
require("系统.04．伤害系统.02．dot伤害")
require("系统.04．伤害系统.01．DOT定义.index")
require("系统.04．伤害系统.03．伤害测试")
require("系统.04．伤害系统.00．伤害计算.05．事件注册")
require("系统.04．伤害系统.02．治疗系统.index")
require("系统.04．伤害系统.03．重伤系统.index")
--- 初始化伤害系统
function ____exports.init(self)
    local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
    local debugLogForce = ____require_result_0.debugLogForce
    local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.index")
    local initHealSystem = ____require_result_1.init
    local ____require_result_2 = require("系统.04．伤害系统.03．重伤系统.index")
    local initWoundSystem = ____require_result_2.init
    debugLogForce("伤害系统", "伤害系统init开始")
    if type(initHealSystem) == "function" then
        debugLogForce("伤害系统", "调用治疗系统.init")
        initHealSystem(nil)
    end
    if type(initWoundSystem) == "function" then
        debugLogForce("伤害系统", "调用重伤系统.init")
        initWoundSystem(nil)
    end
    debugLogForce("伤害系统", "伤害系统init完成")
end
return ____exports
