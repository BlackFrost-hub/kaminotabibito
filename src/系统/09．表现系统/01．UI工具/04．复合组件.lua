--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local FrameType = ____00_FF0E_7C7B_578B_5B9A_4E49.FrameType
local ____01_FF0E_5E27_521B_5EFA = require("系统.09．表现系统.01．UI工具.01．帧创建")
local createFrame = ____01_FF0E_5E27_521B_5EFA.createFrame
local ____02_FF0E_4F4D_7F6E_5C3A_5BF8 = require("系统.09．表现系统.01．UI工具.02．位置尺寸")
local setFramePosition = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePosition
local setFramePointRelative = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePointRelative
local setFrameSize = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFrameSize
local ____03_FF0E_5185_5BB9_8BBE_7F6E = require("系统.09．表现系统.01．UI工具.03．内容设置")
local setButtonText = ____03_FF0E_5185_5BB9_8BBE_7F6E.setButtonText
local setFrameClickEvent = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameClickEvent
local setFrameTexture = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameTexture
local ____05_FF0E_5E27_63A7_5236 = require("系统.09．表现系统.01．UI工具.05．帧控制")
local destroyFrame = ____05_FF0E_5E27_63A7_5236.destroyFrame
local japi = require("jass.japi")
function ____exports.createClickableIcon(self, name, parent, texture, position, size, onClick)
    local backdrop = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if not backdrop then
        return nil
    end
    setFramePosition(nil, backdrop, position)
    setFrameSize(nil, backdrop, size)
    setFrameTexture(nil, backdrop, texture)
    local button = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = name .. "_Button",
        parent = backdrop,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if not button then
        return nil
    end
    japi.DzFrameSetAllPoints(button, backdrop)
    setFrameClickEvent(nil, button, onClick)
    return {backdrop = backdrop, button = button}
end
function ____exports.createTextButton(self, name, parent, text, position, size, onClick)
    local frame = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = name,
        parent = parent,
        template = "template",
        visible = true,
        enable = true
    })
    if not frame then
        return nil
    end
    setFramePosition(nil, frame, position)
    setFrameSize(nil, frame, size)
    setButtonText(nil, frame, text)
    if onClick then
        setFrameClickEvent(nil, frame, onClick)
    end
    return frame
end
function ____exports.createTextLabel(self, name, parent, text, position, size)
    local isRelative = position.relativeTo ~= nil
    local function setPos(____, f)
        if isRelative then
            local r = position
            setFramePointRelative(
                nil,
                f,
                r.point,
                r.relativeTo,
                r.relativePoint,
                r.x,
                r.y
            )
        else
            setFramePosition(nil, f, position)
        end
    end
    local frame = createFrame(nil, {
        type = FrameType.TEXT,
        name = name,
        parent = parent,
        template = "template",
        visible = true
    })
    if frame then
        setPos(nil, frame)
        setFrameSize(nil, frame, size)
        japi.DzFrameSetText(frame, text)
        return frame
    end
    local fallback = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = name,
        parent = parent,
        template = "template",
        visible = true
    })
    if not fallback then
        return nil
    end
    setPos(nil, fallback)
    setFrameSize(nil, fallback, size)
    setButtonText(nil, fallback, text)
    return fallback
end
function ____exports.createTextArea(self, name, parent, text, position, size, backgroundTexture)
    local backdrop = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if backdrop then
        setFramePosition(nil, backdrop, position)
        setFrameSize(nil, backdrop, size)
        if backgroundTexture then
            japi.DzFrameSetTexture(backdrop, backgroundTexture, 0)
        end
    end
    local frame = createFrame(nil, {
        type = FrameType.TEXTAREA,
        name = name,
        parent = backdrop or parent,
        template = "template",
        visible = true
    })
    if frame then
        if backdrop then
            japi.DzFrameSetAllPoints(frame, backdrop)
        else
            setFramePosition(nil, frame, position)
            setFrameSize(nil, frame, size)
        end
        japi.DzFrameSetText(frame, text)
        return frame
    end
    return ____exports.createTextLabel(
        nil,
        name,
        parent,
        text,
        position,
        size
    )
end
function ____exports.createTextBox(self, name, parent, text, position, size, backgroundTexture)
    local backdrop = createFrame(nil, {
        type = FrameType.BACKDROP,
        name = name .. "_Backdrop",
        parent = parent,
        template = "template",
        visible = true
    })
    if not backdrop then
        return nil
    end
    setFramePosition(nil, backdrop, position)
    setFrameSize(nil, backdrop, size)
    setFrameTexture(nil, backdrop, backgroundTexture)
    local textFrame = createFrame(nil, {
        type = FrameType.TEXT,
        name = name .. "_Text",
        parent = backdrop,
        template = "template",
        visible = true
    })
    if not textFrame then
        destroyFrame(nil, backdrop)
        return nil
    end
    local innerPos = {point = position.point, x = position.x + 0.005, y = position.y - 0.005}
    local innerSize = {width = size.width - 0.01, height = size.height - 0.01}
    setFramePosition(nil, textFrame, innerPos)
    setFrameSize(nil, textFrame, innerSize)
    japi.DzFrameSetText(textFrame, text)
    return {backdrop = backdrop, text = textFrame}
end
return ____exports
