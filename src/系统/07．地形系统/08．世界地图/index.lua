--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.07．地形系统.08．世界地图.00．类型定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07．地形系统.08．世界地图.01．世界地图地点配置")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07．地形系统.08．世界地图.02．世界地图界面")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07．地形系统.08．世界地图.03．世界地图交互")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07．地形系统.08．世界地图.04．世界地图解锁")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.07．地形系统.08．世界地图.05．世界地图传送")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local _____754C_9762_6A21_5757 = require("系统.07．地形系统.08．世界地图.02．世界地图界面")
local _____4EA4_4E92_6A21_5757 = require("系统.07．地形系统.08．世界地图.03．世界地图交互")
local _____89E3_9501_6A21_5757 = require("系统.07．地形系统.08．世界地图.04．世界地图解锁")
local _____4E16_754C_5730_56FE_5DF2_521D_59CB_5316 = false
____exports["初始化世界地图"] = function()
    if _____4E16_754C_5730_56FE_5DF2_521D_59CB_5316 then
        return
    end
    _____4E16_754C_5730_56FE_5DF2_521D_59CB_5316 = true
    _____754C_9762_6A21_5757["初始化世界地图界面"]()
    _____4EA4_4E92_6A21_5757["初始化世界地图交互"]()
    _____89E3_9501_6A21_5757["初始化世界地图解锁"]()
end
return ____exports
