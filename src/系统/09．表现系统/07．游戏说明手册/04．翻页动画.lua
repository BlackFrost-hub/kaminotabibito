--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.07．游戏说明手册.00．常量定义")
local MANUAL_FLIP_DURATION = ____00_FF0E_5E38_91CF_5B9A_4E49.MANUAL_FLIP_DURATION
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local CreateTimer = jass.CreateTimer
local PauseTimer = jass.PauseTimer
local TimerStart = jass.TimerStart
local DzFrameShow = japi.DzFrameShow
local _____52A8_753BUI = nil
local _____7FFB_9875_8BA1_65F6_5668 = nil
local _____6B63_5728_7FFB_9875 = false
local _____5F53_524D_5E27_5E8F_53F7 = 0
local _____7FFB_9875_5B8C_6210_56DE_8C03 = nil
local function _____786E_4FDD_8BA1_65F6_5668()
    if _____7FFB_9875_8BA1_65F6_5668 ~= nil and _____7FFB_9875_8BA1_65F6_5668 ~= 0 then
        return
    end
    _____7FFB_9875_8BA1_65F6_5668 = CreateTimer()
end
local function _____505C_6B62_8BA1_65F6_5668()
    if _____7FFB_9875_8BA1_65F6_5668 == nil or _____7FFB_9875_8BA1_65F6_5668 == 0 then
        return
    end
    PauseTimer(_____7FFB_9875_8BA1_65F6_5668)
end
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
local function _____7FFB_9875_52A8_753BTick()
    if not _____6B63_5728_7FFB_9875 or _____52A8_753BUI == nil then
        _____505C_6B62_8BA1_65F6_5668()
        return
    end
    if _____5F53_524D_5E27_5E8F_53F7 >= #_____52A8_753BUI.overlays then
        _____6B63_5728_7FFB_9875 = false
        _____9690_85CF_6240_6709_7FFB_9875_5E27()
        _____505C_6B62_8BA1_65F6_5668()
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
    _____786E_4FDD_8BA1_65F6_5668()
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
    _____786E_4FDD_8BA1_65F6_5668()
    _____6B63_5728_7FFB_9875 = true
    _____5F53_524D_5E27_5E8F_53F7 = 0
    _____7FFB_9875_5B8C_6210_56DE_8C03 = onFinish
    local interval = MANUAL_FLIP_DURATION / #_____52A8_753BUI.overlays
    TimerStart(_____7FFB_9875_8BA1_65F6_5668, interval, true, _____7FFB_9875_52A8_753BTick)
end
____exports["停止翻页动画"] = function()
    _____6B63_5728_7FFB_9875 = false
    _____9690_85CF_6240_6709_7FFB_9875_5E27()
    _____505C_6B62_8BA1_65F6_5668()
end
return ____exports
