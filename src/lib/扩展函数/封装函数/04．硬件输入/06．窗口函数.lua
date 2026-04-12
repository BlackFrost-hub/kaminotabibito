--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 硬件输入 - 窗口函数
-- 
-- 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
local japi = require("jass.japi")
function ____exports.getWindowWidth(self)
    if type(japi.DzGetWindowWidth) ~= "function" then
        return 800
    end
    return japi.DzGetWindowWidth()
end
function ____exports.getWindowHeight(self)
    if type(japi.DzGetWindowHeight) ~= "function" then
        return 600
    end
    return japi.DzGetWindowHeight()
end
function ____exports.getWindowX(self)
    if type(japi.DzGetWindowX) ~= "function" then
        return 0
    end
    return japi.DzGetWindowX()
end
function ____exports.getWindowY(self)
    if type(japi.DzGetWindowY) ~= "function" then
        return 0
    end
    return japi.DzGetWindowY()
end
function ____exports.isWindowActive(self)
    if type(japi.DzIsWindowActive) ~= "function" then
        return true
    end
    return not not japi.DzIsWindowActive()
end
return ____exports
