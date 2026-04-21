--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
require("系统.00．核心系统.01．事件中心.02．区域事件中心")
require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
require("系统.00．核心系统.01．事件中心.04．物品事件中心")
return ____exports
