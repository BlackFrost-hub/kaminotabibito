--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E27_521B_5EFA = require("系统.09．表现系统.01．UI工具.01．帧创建")
local _____521B_5EFA_5E27 = ____01_FF0E_5E27_521B_5EFA.createFrame
local ____00_FF0E_7C7B_578B_5B9A_4E49 = require("系统.09．表现系统.01．UI工具.00．类型定义")
local FramePoint = ____00_FF0E_7C7B_578B_5B9A_4E49.FramePoint
local FrameType = ____00_FF0E_7C7B_578B_5B9A_4E49.FrameType
local ____02_FF0E_4F4D_7F6E_5C3A_5BF8 = require("系统.09．表现系统.01．UI工具.02．位置尺寸")
local _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePointRelative
local _____8BBE_7F6E_5E27_5C3A_5BF8 = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFrameSize
local ____03_FF0E_5185_5BB9_8BBE_7F6E = require("系统.09．表现系统.01．UI工具.03．内容设置")
local _____8BBE_7F6E_5E27_70B9_51FB_4E8B_4EF6 = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameClickEvent
---
-- @noSelfInFile
local japi = require("jass.japi")
local __pcallFrameA = 0
local __pcallFrameB = 0
local function __pcallClearAllPointsBody(self)
    japi.DzFrameClearAllPoints(__pcallFrameA)
end
local function __pcallSetAllPointsBody(self)
    japi.DzFrameSetAllPoints(__pcallFrameA, __pcallFrameB)
end
local function _____6E05_7A7A_5E27_951A_70B9(_____5E27)
    __pcallFrameA = _____5E27
    pcall(__pcallClearAllPointsBody)
end
local function _____94FA_6EE1_76EE_6807_5E27(_____5E27, _____76EE_6807_5E27)
    __pcallFrameA = _____5E27
    __pcallFrameB = _____76EE_6807_5E27
    pcall(__pcallSetAllPointsBody)
end
____exports["创建首领奖励底部操作按钮"] = function(_____7236_5E27, _____540E_7F00, _____540D_5B57, _____6587_5B57, _____547D_4E2DX, _____547D_4E2DY, _____547D_4E2D_5BBD_5EA6, _____547D_4E2D_9AD8_5EA6, _____6587_672CX, _____6587_672CY, _____6587_672C_5BBD_5EA6, _____6587_672C_9AD8_5EA6, _____70B9_51FB_51FD_6570)
    local _____547D_4E2D_6846 = _____521B_5EFA_5E27(nil, {
        type = FrameType.BACKDROP,
        name = (_____540D_5B57 .. "命中框") .. _____540E_7F00,
        parent = _____7236_5E27,
        template = "template",
        visible = true,
        alpha = 0
    }) or 0
    if _____547D_4E2D_6846 ~= 0 then
        _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
            nil,
            _____547D_4E2D_6846,
            FramePoint.CENTER,
            _____7236_5E27,
            FramePoint.CENTER,
            _____547D_4E2DX,
            _____547D_4E2DY
        )
        _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____547D_4E2D_6846, {width = _____547D_4E2D_5BBD_5EA6, height = _____547D_4E2D_9AD8_5EA6})
        japi.DzFrameSetPriority(_____547D_4E2D_6846, 259)
    end
    local _____6587_672C = _____521B_5EFA_5E27(nil, {
        type = FrameType.TEXT,
        name = (_____540D_5B57 .. "文字") .. _____540E_7F00,
        parent = _____7236_5E27,
        template = "template",
        visible = true,
        enable = false
    }) or 0
    if _____6587_672C ~= 0 then
        _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
            nil,
            _____6587_672C,
            FramePoint.TOPLEFT,
            _____7236_5E27,
            FramePoint.CENTER,
            _____6587_672CX,
            _____6587_672CY
        )
        _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____6587_672C, {width = _____6587_672C_5BBD_5EA6, height = _____6587_672C_9AD8_5EA6})
        japi.DzFrameSetTextAlignment(_____6587_672C, 18)
        japi.DzFrameSetFont(_____6587_672C, "Fonts\\dfst-m3u.ttf", 0.018, 0)
        japi.DzFrameSetTextColor(
            _____6587_672C,
            255,
            255,
            255,
            255
        )
        japi.DzFrameSetPriority(_____6587_672C, 255)
        japi.DzFrameSetText(_____6587_672C, _____6587_5B57)
    end
    local _____6309_94AE = _____521B_5EFA_5E27(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = (_____540D_5B57 .. "点击按钮") .. _____540E_7F00,
        parent = _____547D_4E2D_6846 ~= 0 and _____547D_4E2D_6846 or _____7236_5E27,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    }) or 0
    if _____6309_94AE ~= 0 then
        _____6E05_7A7A_5E27_951A_70B9(_____6309_94AE)
        if _____547D_4E2D_6846 ~= 0 then
            _____94FA_6EE1_76EE_6807_5E27(_____6309_94AE, _____547D_4E2D_6846)
        else
            _____8BBE_7F6E_5E27_76F8_5BF9_4F4D_7F6E(
                nil,
                _____6309_94AE,
                FramePoint.CENTER,
                _____7236_5E27,
                FramePoint.CENTER,
                _____547D_4E2DX,
                _____547D_4E2DY
            )
            _____8BBE_7F6E_5E27_5C3A_5BF8(nil, _____6309_94AE, {width = _____547D_4E2D_5BBD_5EA6, height = _____547D_4E2D_9AD8_5EA6})
        end
        japi.DzFrameSetTextAlignment(_____6309_94AE, 18)
        japi.DzFrameSetFont(_____6309_94AE, "Fonts\\dfst-m3u.ttf", 0.014, 0)
        japi.DzFrameSetText(_____6309_94AE, "")
        japi.DzFrameSetPriority(_____6309_94AE, 260)
        _____8BBE_7F6E_5E27_70B9_51FB_4E8B_4EF6(nil, _____6309_94AE, _____70B9_51FB_51FD_6570, true)
    end
    return {["按钮"] = _____6309_94AE, ["文本"] = _____6587_672C, ["命中框"] = _____547D_4E2D_6846}
end
return ____exports
