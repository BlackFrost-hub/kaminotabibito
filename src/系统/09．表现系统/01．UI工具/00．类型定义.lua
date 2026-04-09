--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Frame类型常量（DzAPI 支持的类型）
____exports.FrameType = {
    BACKDROP = "BACKDROP",
    TEXT = "TEXT",
    TEXTAREA = "TEXTAREA",
    GLUETEXTBUTTON = "GLUETEXTBUTTON",
    GLUECHECKBOX = "GLUECHECKBOX",
    POPUPMENU = "POPUPMENU",
    SCROLLBAR = "SCROLLBAR",
    SPRITE = "SPRITE",
    SLIDER = "SLIDER",
    BUTTON = "BUTTON",
    EDITBOX = "EDITBOX",
    HIGHLIGHT = "HIGHLIGHT",
    MENU = "MENU",
    DIALOG = "DIALOG",
    SIMPLEFRAME = "SIMPLEFRAME",
    SIMPLESTATUSBAR = "SIMPLESTATUSBAR",
    SIMPLECHECKBOX = "SIMPLECHECKBOX"
}
____exports.FrameLayer = {ARTWORK = "ARTWORK"}
____exports.FramePoint = {
    TOPLEFT = 0,
    TOP = 1,
    TOPRIGHT = 2,
    LEFT = 3,
    CENTER = 4,
    RIGHT = 5,
    BOTTOMLEFT = 6,
    BOTTOM = 7,
    BOTTOMRIGHT = 8
}
____exports.EventType = {
    MOUSE_CLICK = 1,
    MOUSE_ENTER = 2,
    MOUSE_LEAVE = 3,
    MOUSE_UP = 4,
    MOUSE_DOWN = 5,
    MOUSE_WHEEL = 6,
    MOUSE_DOUBLE_CLICK = 12,
    SLIDER_VALUE_CHANGED = 11
}
return ____exports
