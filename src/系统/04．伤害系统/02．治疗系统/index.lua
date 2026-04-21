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
    local ____export = require("系统.04．伤害系统.02．治疗系统.02．治疗事件_旧版")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.03．持续治疗效果")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.04．物品治疗效果")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.05．魔法恢复")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．治疗系统.06．施法治疗事件")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
--- 初始化治疗系统
function ____exports.init(self)
    local healEventOld = require("系统.04．伤害系统.02．治疗系统.02．治疗事件_旧版")
    if type(healEventOld.initHealEventOld) == "function" then
        healEventOld:initHealEventOld()
    end
    local hotSystem = require("系统.04．伤害系统.02．治疗系统.03．持续治疗效果")
    if type(hotSystem.initHotSystem) == "function" then
        hotSystem:initHotSystem()
    end
    local healEvent = require("系统.04．伤害系统.02．治疗系统.06．施法治疗事件")
    if type(healEvent.initHealEvent) == "function" then
        healEvent:initHealEvent()
    end
end
return ____exports
