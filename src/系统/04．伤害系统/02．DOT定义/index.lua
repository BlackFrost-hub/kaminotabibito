--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.01．DOT配置")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.02．DOT解析")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.03．DOT类型定义")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.04．DOT工具")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.05．DOT状态同步")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.06．DOT执行器")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.07．DOT施加策略")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.04．伤害系统.02．DOT定义.08．DOT基础工具")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.04．伤害系统.02．DOT定义.01．DOT配置")
require("系统.04．伤害系统.02．DOT定义.02．DOT解析")
require("系统.04．伤害系统.02．DOT定义.03．DOT类型定义")
require("系统.04．伤害系统.02．DOT定义.04．DOT工具")
require("系统.04．伤害系统.02．DOT定义.05．DOT状态同步")
require("系统.04．伤害系统.02．DOT定义.06．DOT执行器")
require("系统.04．伤害系统.02．DOT定义.07．DOT施加策略")
require("系统.04．伤害系统.02．DOT定义.08．DOT基础工具")
--- 初始化DOT定义模块
function ____exports.init(self)
    local p = _G.print
    if type(p) == "function" then
        p(nil, "[DOT定义] 初始化完成")
    end
end
return ____exports
