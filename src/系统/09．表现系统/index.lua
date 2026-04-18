--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.09．表现系统.01．UI工具.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.02．对话框系统.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.03．UI属性系统.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.00．初始化UI")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.01．UI工具.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.09．表现系统.03．垂直滚动条轨道")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local _____539F_751FUI = require("系统.09．表现系统.00．初始化UI")
if type(_____539F_751FUI.initNativeUI) == "function" then
    _____539F_751FUI:initNativeUI()
end
require("系统.09．表现系统.01．UI工具.index")
require("系统.09．表现系统.03．垂直滚动条轨道")
require("系统.09．表现系统.02．对话框系统.index")
require("系统.09．表现系统.03．UI属性系统.index")
--- 初始化表现系统
function ____exports.init(self)
end
return ____exports
