--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.08．任务系统.00．配置表.01．对话配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.00．配置表.02．任务配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.00．配置表.03．NPC配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.00．配置表.04．NPC生成器")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.00．配置表.05．NPC初始化动作")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.08．任务系统.00．配置表.06．主线任务配置表")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.08．任务系统.00．配置表.01．对话配置表")
require("系统.08．任务系统.00．配置表.02．任务配置表")
require("系统.08．任务系统.00．配置表.03．NPC配置表")
local ____NPC_751F_6210_5668 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
if type(____NPC_751F_6210_5668.init) == "function" then
    ____NPC_751F_6210_5668:init()
end
require("系统.08．任务系统.00．配置表.05．NPC初始化动作")
require("系统.08．任务系统.00．配置表.06．主线任务配置表")
--- 初始化任务系统配置表
function ____exports.init(self)
    local p = _G.print
    if type(p) == "function" then
        p(nil, "[任务系统配置表] 初始化完成")
    end
end
return ____exports
