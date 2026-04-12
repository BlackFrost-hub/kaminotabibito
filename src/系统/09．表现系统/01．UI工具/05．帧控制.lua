--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local getGameUI = ____index.getGameUI
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
