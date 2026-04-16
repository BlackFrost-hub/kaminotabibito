--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
    local ____export = require("系统.03．技能系统.07．技能吟唱条.index")
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
do
    local ____export = require("系统.03．技能系统.02．显示技能名字2")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.03．技能系统.01．技能冷却.index")
require("系统.03．技能系统.02．技能消耗.index")
local bbTeleportMod = require("系统.03．技能系统.04．快捷键技能.index")
if type(bbTeleportMod.initBBTeleport) == "function" then
    bbTeleportMod:initBBTeleport()
end
local switchBagMod = require("系统.03．技能系统.04．快捷键技能.index")
if type(switchBagMod.initSwitchBag) == "function" then
    switchBagMod:initSwitchBag()
end
local _____663E_793A_6280_80FD_540D_5B57 = require("系统.03．技能系统.01．显示技能名字")
if type(_____663E_793A_6280_80FD_540D_5B57.initShowSkillName) == "function" then
    _____663E_793A_6280_80FD_540D_5B57:initShowSkillName()
end
local _____663E_793A_6280_80FD_540D_5B572 = require("系统.03．技能系统.02．显示技能名字2")
if type(_____663E_793A_6280_80FD_540D_5B572.initShowSkillName2) == "function" then
    _____663E_793A_6280_80FD_540D_5B572:initShowSkillName2()
end
local dynamicSkillTip = require("系统.03．技能系统.05．动态技能说明.index")
if type(dynamicSkillTip.init) == "function" then
    dynamicSkillTip:init()
end
local aiSkillSystem = require("系统.03．技能系统.06．AI自动使用技能.index")
if type(aiSkillSystem.init) == "function" then
    aiSkillSystem:init()
end
local castBarSystem = require("系统.03．技能系统.07．技能吟唱条.index")
if type(castBarSystem.init) == "function" then
    castBarSystem:init()
end
--- 初始化技能系统
function ____exports.init(self)
end
return ____exports
