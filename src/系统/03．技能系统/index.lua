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
require("系统.03．技能系统.快速Buff测试")
local _____5FEB_6377_952E_6280_80FD_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.index")
local ____opt_0 = _____5FEB_6377_952E_6280_80FD_6A21_5757.initBBTeleport
if ____opt_0 ~= nil then
    ____opt_0()
end
local ____opt_2 = _____5FEB_6377_952E_6280_80FD_6A21_5757.initSwitchBag
if ____opt_2 ~= nil then
    ____opt_2()
end
require("系统.03．技能系统.01．显示技能名字")
local ____ai_6280_80FD_7CFB_7EDF = require("系统.03．技能系统.06．AI自动使用技能.index")
____ai_6280_80FD_7CFB_7EDF.init()
function ____exports.init()
end
return ____exports
