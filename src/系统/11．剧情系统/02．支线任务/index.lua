--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_88AB_9A71_9010_7684_6C34_602A = require("系统.11．剧情系统.02．支线任务.01．被驱逐的水怪.index")
local ____init_88AB_9A71_9010_7684_6C34_602A = ____01_FF0E_88AB_9A71_9010_7684_6C34_602A.init
local ____02_FF0E_6C61_67D3_4E4B_732B_7C73_4E9A = require("系统.11．剧情系统.02．支线任务.02．污染之猫米亚.index")
local ____init_6C61_67D3_4E4B_732B_7C73_4E9A = ____02_FF0E_6C61_67D3_4E4B_732B_7C73_4E9A.init
local ____03_FF0E_745F_5170_8FEA_5C14 = require("系统.11．剧情系统.02．支线任务.03．瑟兰迪尔.index")
local ____init_745F_5170_8FEA_5C14 = ____03_FF0E_745F_5170_8FEA_5C14.init
local ____04_FF0E_83AB_7279_65AF = require("系统.11．剧情系统.02．支线任务.04．莫特斯.index")
local ____init_83AB_7279_65AF = ____04_FF0E_83AB_7279_65AF.init
local ____04_FF0E_83AB_5C14_7279_65AF = require("系统.11．剧情系统.02．支线任务.04．莫尔特斯.index")
local ____init_83AB_5C14_7279_65AF = ____04_FF0E_83AB_5C14_7279_65AF.init
do
    local ____export = require("系统.11．剧情系统.02．支线任务.01．支线NPC配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.11．剧情系统.02．支线任务.00．通用小任务.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
function ____exports.init()
    ____init_88AB_9A71_9010_7684_6C34_602A()
    ____init_6C61_67D3_4E4B_732B_7C73_4E9A()
    ____init_745F_5170_8FEA_5C14()
    ____init_83AB_7279_65AF()
    ____init_83AB_5C14_7279_65AF()
end
return ____exports
