--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_7EBF_914D_7F6E_9A71_52A8 = require("系统.11．剧情系统.01．主线任务.01．主线配置驱动")
local ____init_4E3B_7EBF_5267_60C5_914D_7F6E_9A71_52A8 = ____01_FF0E_4E3B_7EBF_914D_7F6E_9A71_52A8["init主线剧情配置驱动"]
local ____01_FF0E_4E3B_7EBF_5267_60C5_5165_53E3 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.index")
local _____521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = ____01_FF0E_4E3B_7EBF_5267_60C5_5165_53E3["初始化主线剧情入口"]
local ____02_FF0E_5267_60C5_6B65_9AA4 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.index")
local _____521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668 = ____02_FF0E_5267_60C5_6B65_9AA4["初始化剧情步骤播放器"]
do
    local ____export = require("系统.11．剧情系统.01．主线任务.00．主线任务配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.11．剧情系统.01．主线任务.01．主线配置驱动")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
function ____exports.init()
    _____521D_59CB_5316_5267_60C5_6B65_9AA4_64AD_653E_5668()
    _____521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3()
    ____init_4E3B_7EBF_5267_60C5_914D_7F6E_9A71_52A8()
end
return ____exports
