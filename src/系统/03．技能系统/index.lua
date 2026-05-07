--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.01．技能冷却.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.02．技能消耗.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.04．快捷键技能.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.05．动态技能说明.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.06．AI自动使用技能.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.01．显示技能名字")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.03．技能系统.00．技能模板+函数.index")
require("系统.03．技能系统.01．技能冷却.index")
require("系统.03．技能系统.02．技能消耗.index")
local bbTeleportMod = require("系统.03．技能系统.04．快捷键技能.index")
bbTeleportMod:initBBTeleport()
local switchBagMod = require("系统.03．技能系统.04．快捷键技能.index")
switchBagMod:initSwitchBag()
require("系统.03．技能系统.01．显示技能名字")
local dynamicSkillTip = require("系统.03．技能系统.05．动态技能说明.index")
dynamicSkillTip:init()
local aiSkillSystem = require("系统.03．技能系统.06．AI自动使用技能.index")
aiSkillSystem:init()
--- 初始化技能系统
function ____exports.init(self)
end
return ____exports
