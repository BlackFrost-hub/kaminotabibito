--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.05．治疗系统.index")
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
    local ____export = require("系统.04．伤害系统.04．伤害计算.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.04．伤害系统.01．伤害事件")
require("系统.04．伤害系统.02．dot伤害")
require("系统.04．伤害系统.02．DOT定义.index")
require("系统.04．伤害系统.03．伤害测试")
require("系统.04．伤害系统.04．伤害计算.05．事件注册")
require("系统.04．伤害系统.05．治疗系统.index")
--- 初始化伤害系统
function ____exports.init(self)
end
return ____exports
