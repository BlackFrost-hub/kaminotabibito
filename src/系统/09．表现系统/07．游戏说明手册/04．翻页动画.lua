--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.07．游戏说明手册.00．常量定义")
local MANUAL_FLIP_DURATION = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_FLIP_DURATION
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.onTick10ms
---
-- @noSelfInFile
local japi = require("jass.japi")
local DzFrameShow = japi.DzFrameShow
local CENTER_TICK_SECONDS = 0.01
local _____52A8_753BUI = nil
local _____6B63_5728_7FFB_9875 = false
local _____5F53_524D_5E27_5E8F_53F7 = 0
local _____7FFB_9875_7D2F_8BA1_65F6_95F4 = 0
local _____7FFB_9875_5E27_95F4_9694 = 0
local _____7FFB_9875_5B8C_6210_56DE_8C03 = nil
local _____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668 = false
local function _____9690_85CF_6240_6709_7FFB_9875_5E27()
    if _____52A8_753BUI == nil then
        return
    end
    do
        local i = 0
        while i < #_____52A8_753BUI.overlays do
            DzFrameShow(_____52A8_753BUI.overlays[i + 1], false)
            i = i + 1
        end
    end
end
____exports["显示翻页预览"] = function()
    if _____52A8_753BUI == nil or _____6B63_5728_7FFB_9875 or #_____52A8_753BUI.overlays <= 0 then
        return
    end
    _____9690_85CF_6240_6709_7FFB_9875_5E27()
    DzFrameShow(_____52A8_753BUI.overlays[1], true)
end
____exports["隐藏翻页预览"] = function()
    if _____6B63_5728_7FFB_9875 then
        return
    end
    _____9690_85CF_6240_6709_7FFB_9875_5E27()
end
local function _____7FFB_9875_52A8_753BTick()
    if not _____6B63_5728_7FFB_9875 or _____52A8_753BUI == nil then
        return
    end
    _____7FFB_9875_7D2F_8BA1_65F6_95F4 = _____7FFB_9875_7D2F_8BA1_65F6_95F4 + CENTER_TICK_SECONDS
    if _____7FFB_9875_7D2F_8BA1_65F6_95F4 < _____7FFB_9875_5E27_95F4_9694 then
        return
    end
    _____7FFB_9875_7D2F_8BA1_65F6_95F4 = 0
    if _____5F53_524D_5E27_5E8F_53F7 >= #_____52A8_753BUI.overlays then
        _____6B63_5728_7FFB_9875 = false
        _____9690_85CF_6240_6709_7FFB_9875_5E27()
        if _____7FFB_9875_5B8C_6210_56DE_8C03 ~= nil then
            _____7FFB_9875_5B8C_6210_56DE_8C03()
        end
        return
    end
    _____9690_85CF_6240_6709_7FFB_9875_5E27()
    DzFrameShow(_____52A8_753BUI.overlays[_____5F53_524D_5E27_5E8F_53F7 + 1], true)
    _____5F53_524D_5E27_5E8F_53F7 = _____5F53_524D_5E27_5E8F_53F7 + 1
end
____exports["初始化翻页动画"] = function(ui)
    _____52A8_753BUI = ui
    if _____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(_____7FFB_9875_52A8_753BTick)
end
____exports["是否正在翻页"] = function()
    return _____6B63_5728_7FFB_9875
end
____exports["开始翻页动画"] = function(onFinish)
    if _____52A8_753BUI == nil then
        return
    end
    if _____6B63_5728_7FFB_9875 then
        return
    end
    if #_____52A8_753BUI.overlays <= 0 then
        onFinish()
        return
    end
    _____6B63_5728_7FFB_9875 = true
    _____5F53_524D_5E27_5E8F_53F7 = 0
    _____7FFB_9875_5E27_95F4_9694 = MANUAL_FLIP_DURATION / #_____52A8_753BUI.overlays
    _____7FFB_9875_7D2F_8BA1_65F6_95F4 = _____7FFB_9875_5E27_95F4_9694
    _____7FFB_9875_5B8C_6210_56DE_8C03 = onFinish
end
____exports["停止翻页动画"] = function()
    _____6B63_5728_7FFB_9875 = false
    _____7FFB_9875_7D2F_8BA1_65F6_95F4 = 0
    _____9690_85CF_6240_6709_7FFB_9875_5E27()
end
return ____exports
