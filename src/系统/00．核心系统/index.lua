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
    local ____export = require("系统.00．核心系统.01．事件中心.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.05．中心计时器")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.00．核心系统.06．特效绑定系统")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
require("系统.00．核心系统.01．颜色常量")
require("系统.00．核心系统.02．硬件函数")
require("系统.00．核心系统.03．UI函数")
require("系统.00．核心系统.01．事件中心.index")
require("系统.00．核心系统.05．中心计时器")
require("系统.00．核心系统.06．特效绑定系统")
require("系统.00．核心系统.00．玩家系统.index")
--- 初始化核心系统
function ____exports.init(self)
end
return ____exports
