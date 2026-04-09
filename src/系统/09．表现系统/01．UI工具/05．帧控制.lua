--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0E_786C_4EF6_51FD_6570 = require("系统.00．核心系统.04．硬件函数")
local getGameUI = ____04_FF0E_786C_4EF6_51FD_6570.getGameUI
local japi = require("jass.japi")
function ____exports.destroyFrame(self, frame)
    if not frame or type(japi.DzDestroyFrame) ~= "function" then
        return false
    end
    japi.DzDestroyFrame(frame)
    return true
end
function ____exports.hideFrame(self, frame)
    if not frame or type(japi.DzFrameShow) ~= "function" then
        return false
    end
    japi.DzFrameShow(frame, false)
    return true
end
function ____exports.showFrame(self, frame)
    if not frame or type(japi.DzFrameShow) ~= "function" then
        return false
    end
    japi.DzFrameShow(frame, true)
    return true
end
function ____exports.getGameUIFrame(self)
    return getGameUI(nil)
end
return ____exports
