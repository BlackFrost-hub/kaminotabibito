--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.00．常量定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.02．原生治疗入口")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.03．治疗事件入口")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.05．物品治疗效果")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.06．魔法恢复")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 初始化治疗系统
function ____exports.init()
    local nativeHealEntry = require("系统.04．伤害系统.02．治疗系统.02．原生治疗入口")
    if type(nativeHealEntry.initNativeHealEntry) == "function" then
        nativeHealEntry:initNativeHealEntry()
    end
    local hotSystem = require("系统.04．伤害系统.02．治疗系统.04．持续治疗效果")
    if type(hotSystem.initHotSystem) == "function" then
        hotSystem:initHotSystem()
    end
    local healRequestEntry = require("系统.04．伤害系统.02．治疗系统.03．治疗事件入口")
    if type(healRequestEntry.initHealRequestEntry) == "function" then
        healRequestEntry:initHealRequestEntry()
    end
end
return ____exports
