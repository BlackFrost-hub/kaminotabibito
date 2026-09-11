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
    local ____export = require("系统.00．核心系统.03．脱战系统.index")
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
do
    local ____export = require("系统.00．核心系统.09．游戏结算开关")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local centerTimer = require("系统.00．核心系统.05．中心计时器")
local function expose(self, name, fn)
    if type(fn) ~= "function" then
        return
    end
    local g = _G
    if type(g[name]) == "function" then
        return
    end
    g[name] = fn
end
--- 强制覆盖式暴露：计时器桥接必须用项目实现，不允许被遮蔽。
-- 
-- 运行时（Luamain.lua）可能已占用同名全局；`expose` 的"已存在则跳过"会让
-- 所有通过 `globalThis.onTick10ms` 取用的模块（击退/跳跃/特效绑定/漂浮文字/
-- 玩家基础核心等）拿到引擎的实现，表现为注册回调时引擎/JAPI 崩溃。
local function exposeForce(self, name, fn)
    if type(fn) ~= "function" then
        return
    end
    _G[name] = fn
end
local function registerCoreGlobals(self)
    expose(nil, "getServerTime", centerTimer.getServerTime)
    expose(nil, "getTime", centerTimer.getTime)
    expose(nil, "getGameTime", centerTimer.getGameTime)
    expose(nil, "getGameElapsedTime", centerTimer.getGameElapsedTime)
    expose(nil, "getGameTimeHMS", centerTimer.getGameTimeHMS)
    expose(nil, "getGameTimeFormatted", centerTimer.getGameTimeFormatted)
    expose(nil, "getGameTimeString", centerTimer.getGameTimeString)
    expose(nil, "getGameTimeStringWithMs", centerTimer.getGameTimeStringWithMs)
    expose(nil, "getDateTimeString", centerTimer.getDateTimeString)
    expose(nil, "getDateTimeStringWithMs", centerTimer.getDateTimeStringWithMs)
    expose(nil, "setGameDifficulty", centerTimer.setGameDifficulty)
    expose(nil, "getGameDifficulty", centerTimer.getGameDifficulty)
    exposeForce(nil, "addPeriodicCallback", centerTimer.addPeriodicCallback)
    exposeForce(nil, "removePeriodicCallback", centerTimer.removePeriodicCallback)
    exposeForce(nil, "addDelayedCallback", centerTimer.addDelayedCallback)
    exposeForce(nil, "removeDelayedCallback", centerTimer.removeDelayedCallback)
    exposeForce(nil, "onSecond", centerTimer.onSecond)
    exposeForce(nil, "offSecond", centerTimer.offSecond)
    exposeForce(nil, "onTick10ms", centerTimer.onTick10ms)
    exposeForce(nil, "offTick10ms", centerTimer.offTick10ms)
    exposeForce(nil, "initCenterTimer", centerTimer.initCenterTimer)
end
require("系统.00．核心系统.01．颜色常量")
require("系统.00．核心系统.02．硬件函数")
require("系统.00．核心系统.02．功能开关.index")
require("系统.00．核心系统.03．UI函数")
require("系统.00．核心系统.01．事件中心.index")
registerCoreGlobals(nil)
require("系统.00．核心系统.06．特效绑定系统")
require("系统.00．核心系统.00．玩家系统.index")
--- 初始化核心系统
function ____exports.init(self)
end
return ____exports
