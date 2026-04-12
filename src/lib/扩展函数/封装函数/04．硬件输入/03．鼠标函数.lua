--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 硬件输入 - 鼠标函数
-- 
-- 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致参数错位。
local japi = require("jass.japi")
function ____exports.getMouseTerrainX(self)
    if type(japi.DzGetMouseTerrainX) ~= "function" then
        return 0
    end
    return japi.DzGetMouseTerrainX()
end
function ____exports.getMouseTerrainY(self)
    if type(japi.DzGetMouseTerrainY) ~= "function" then
        return 0
    end
    return japi.DzGetMouseTerrainY()
end
function ____exports.getMouseTerrainZ(self)
    if type(japi.DzGetMouseTerrainZ) ~= "function" then
        return 0
    end
    return japi.DzGetMouseTerrainZ()
end
function ____exports.isMouseOverUI(self)
    if type(japi.DzIsMouseOverUI) ~= "function" then
        return false
    end
    return not not japi.DzIsMouseOverUI()
end
function ____exports.getMouseX(self)
    if type(japi.DzGetMouseX) ~= "function" then
        return 0
    end
    return japi.DzGetMouseX()
end
function ____exports.getMouseY(self)
    if type(japi.DzGetMouseY) ~= "function" then
        return 0
    end
    return japi.DzGetMouseY()
end
function ____exports.getMouseXRelative(self)
    if type(japi.DzGetMouseXRelative) ~= "function" then
        return 0
    end
    return japi.DzGetMouseXRelative()
end
function ____exports.getMouseYRelative(self)
    if type(japi.DzGetMouseYRelative) ~= "function" then
        return 0
    end
    return japi.DzGetMouseYRelative()
end
function ____exports.setMousePos(self, x, y)
    if type(japi.DzSetMousePos) ~= "function" then
        return
    end
    japi.DzSetMousePos(x, y)
end
return ____exports
