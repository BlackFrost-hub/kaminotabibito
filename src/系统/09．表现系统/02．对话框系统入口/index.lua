--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.01．常量与工具")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.02．任务状态")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.03．配置查询")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.04．对话构建")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.05．选择触发入口")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.06．任务奖励解析")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.07．任务提交流程")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.08．任务奖励执行")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统入口.09．任务展示文案")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local ____NPC_751F_6210_5668 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
if type(____NPC_751F_6210_5668.init) == "function" then
    ____NPC_751F_6210_5668:init()
end
require("系统.09．表现系统.04．NPC对话状态池")
local _____5BF9_8BDD_6846UI = require("系统.09．表现系统.03．对话框系统.00．对话框UI入口")
if type(_____5BF9_8BDD_6846UI.initDialogSystem) == "function" then
    _____5BF9_8BDD_6846UI:initDialogSystem()
end
local ____require_result_0 = require("系统.09．表现系统.02．对话框系统入口.05．选择触发入口")
local initDialogEntrySelectionTrigger = ____require_result_0.initDialogEntrySelectionTrigger
if type(initDialogEntrySelectionTrigger) == "function" then
    initDialogEntrySelectionTrigger(nil)
end
--- 初始化对话框系统入口
function ____exports.init(self)
    local p = _G.print
    if type(p) == "function" then
        p(nil, "[对话框系统入口] 初始化完成")
    end
end
return ____exports
