--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local frameSetScriptByCode = ____index.frameSetScriptByCode
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local EventType = ____00_FF0E_7C7B_578B_5B9A_4E49.EventType
local japi = require("jass.japi")
function ____exports.setFrameTexture(self, frame, texture)
    if frame == 0 or frame == nil then
        return false
    end
    if texture ~= "" then
        japi.DzFrameSetTexture(frame, texture, 0)
    end
    return true
end
function ____exports.setFrameClickEvent(self, frame, callback, sync)
    if sync == nil then
        sync = true
    end
    if frame == 0 or frame == nil then
        return false
    end
    frameSetScriptByCode(frame, EventType.MOUSE_CLICK, callback, sync)
    return true
end
function ____exports.setFrameHoverEvents(self, frame, onEnter, onLeave, sync)
    if sync == nil then
        sync = true
    end
    if frame == 0 or frame == nil then
        return false
    end
    frameSetScriptByCode(frame, EventType.MOUSE_ENTER, onEnter, sync)
    frameSetScriptByCode(frame, EventType.MOUSE_LEAVE, onLeave, sync)
    return true
end
function ____exports.setButtonText(self, frame, text)
    if not frame then
        return false
    end
    japi.DzFrameSetText(frame, text)
    return true
end
return ____exports
