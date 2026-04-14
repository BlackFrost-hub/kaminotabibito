--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("lib.扩展函数.封装函数.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.01．颜色常量")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.03．UI函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.04．治疗事件")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.00．核心系统.01．颜色常量")
require("系统.00．核心系统.02．硬件函数")
require("系统.00．核心系统.03．UI函数")
local healEventMod = require("系统.00．核心系统.04．治疗事件")
if type(healEventMod.initHealEvent) == "function" then
    healEventMod:initHealEvent()
end
--- 初始化核心系统
function ____exports.init(self)
end
return ____exports
