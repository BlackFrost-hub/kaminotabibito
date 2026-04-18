--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.07．地形系统.02．区域传送配置")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07．地形系统.03．区域传送")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07．地形系统.04．激活传送点配置")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07．地形系统.05．激活传送点")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.07．地形系统.02．区域传送配置")
local _____533A_57DF_4F20_9001 = require("系统.07．地形系统.03．区域传送")
if type(_____533A_57DF_4F20_9001["init区域传送"]) == "function" then
    _____533A_57DF_4F20_9001["init区域传送"](_____533A_57DF_4F20_9001)
end
require("系统.07．地形系统.04．激活传送点配置")
local _____6FC0_6D3B_4F20_9001_70B9 = require("系统.07．地形系统.05．激活传送点")
if type(_____6FC0_6D3B_4F20_9001_70B9["init激活传送点"]) == "function" then
    _____6FC0_6D3B_4F20_9001_70B9["init激活传送点"](_____6FC0_6D3B_4F20_9001_70B9)
end
--- 初始化地形系统
function ____exports.init(self)
end
return ____exports
