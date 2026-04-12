--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
require("系统.08．任务系统.00．配置表.index")
do
    local ____export = require("系统.08．任务系统.03．任务UI拆分.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.01．任务数据")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.02．任务管理器")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.03．任务UI")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.04．任务STES配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.05．任务STES桥接")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.06．任务事件桥接")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.08．任务目标更新")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.10．主线配置驱动")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.08．任务系统.01．任务数据")
local _____4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
if type(_____4EFB_52A1_7BA1_7406_5668.init) == "function" then
    _____4EFB_52A1_7BA1_7406_5668:init()
end
local _____4EFB_52A1UI = require("系统.08．任务系统.03．任务UI")
if type(_____4EFB_52A1UI.init) == "function" then
    _____4EFB_52A1UI:init()
end
if type(_____4EFB_52A1UI.registerHotkey) == "function" then
    _____4EFB_52A1UI:registerHotkey()
end
require("系统.08．任务系统.03．任务UI拆分.index")
require("系统.08．任务系统.04．任务STES配置表")
require("系统.08．任务系统.05．任务STES桥接")
require("系统.08．任务系统.06．任务事件桥接")
require("系统.08．任务系统.08．任务目标更新")
require("系统.08．任务系统.10．主线配置驱动")
--- 初始化任务系统
function ____exports.init(self)
end
return ____exports
