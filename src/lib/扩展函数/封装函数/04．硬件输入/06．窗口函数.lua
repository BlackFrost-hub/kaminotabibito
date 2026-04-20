--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 硬件输入 - 窗口函数
-- 
-- 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
local japi = require("jass.japi")
function ____exports.getWindowWidth(self)
    return japi.DzGetWindowWidth()
end
function ____exports.getWindowHeight(self)
    return japi.DzGetWindowHeight()
end
function ____exports.getWindowX(self)
    return japi.DzGetWindowX()
end
function ____exports.getWindowY(self)
    return japi.DzGetWindowY()
end
function ____exports.isWindowActive(self)
    return not not japi.DzIsWindowActive()
end
return ____exports
