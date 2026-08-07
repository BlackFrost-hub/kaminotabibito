--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E = require("系统.07．地形系统.08．世界地图.01．世界地图地点配置")
local _____4E16_754C_5730_56FE_5730_70B9_914D_7F6E_8868 = ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E["世界地图地点配置表"]
local ____02_FF0E_4E16_754C_5730_56FE_754C_9762 = require("系统.07．地形系统.08．世界地图.02．世界地图界面")
local _____83B7_53D6_4E16_754C_5730_56FE_5730_70B9_5E27 = ____02_FF0E_4E16_754C_5730_56FE_754C_9762["获取世界地图地点帧"]
local _____4E16_754C_5730_56FE_5E27 = ____02_FF0E_4E16_754C_5730_56FE_754C_9762["世界地图帧"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local ____Frame_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.07．Frame函数")
local _____540C_6B65_8F93_5165 = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local _____786C_4EF6_5E38_91CF = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local _____82F1_96C4_6865_63A5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____77E9_5F62_51FD_6570 = require("lib.扩展函数.BJ函数.04．矩形与区域")
local _____97F3_6548_51FD_6570 = require("lib.扩展函数.封装函数.02．音效系统.04．MP3音效播放")
local DzFrameShow = japi.DzFrameShow
local DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame
local DzIsChatBoxOpen = japi.DzIsChatBoxOpen
local GetLocalPlayer = jass.GetLocalPlayer
local GetPlayerId = jass.GetPlayerId
local CreateTimer = jass.CreateTimer
local TimerStart = jass.TimerStart
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local DestroyTimer = jass.DestroyTimer
local _____5730_70B9_9F20_6807_8FDB_5165_4E8B_4EF6 = 2
local _____5730_70B9_9F20_6807_79BB_5F00_4E8B_4EF6 = 3
local _____5730_56FE_5C55_5F00_5EF6_8FDF_79D2 = 0.3
local _____73A9_5BB6_5730_56FE_6253_5F00_72B6_6001_8868 = {}
local _____5730_56FE_5C55_5F00_73A9_5BB6_8868 = {}
local _____4E16_754C_5730_56FE_4EA4_4E92_5DF2_521D_59CB_5316 = false
local function _____83B7_53D6_77E9_5F62(_____77E9_5F62_952E)
    if _____77E9_5F62_952E == nil or _____77E9_5F62_952E == "" then
        return nil
    end
    return jglobals[_____77E9_5F62_952E]
end
local function _____5355_4F4D_4F4D_4E8E_77E9_5F62(unit, _____77E9_5F62_952E)
    local rect = _____83B7_53D6_77E9_5F62(_____77E9_5F62_952E)
    if rect == nil or rect == 0 then
        return false
    end
    return _____77E9_5F62_51FD_6570.RectContainsUnit(rect, unit)
end
local function _____627E_5230_89E6_53D1_5730_70B9_7D22_5F15(_____89E6_53D1_5E27)
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_5E27["地点帧组表"] do
            local _____5730_70B9_5E27 = _____4E16_754C_5730_56FE_5E27["地点帧组表"][_____7D22_5F15 + 1]
            if _____5730_70B9_5E27 ~= nil and _____5730_70B9_5E27["按钮"] == _____89E6_53D1_5E27 then
                return _____7D22_5F15
            end
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
    return -1
end
local function ____on_5730_70B9_9F20_6807_8FDB_5165()
    local _____7D22_5F15 = _____627E_5230_89E6_53D1_5730_70B9_7D22_5F15(DzGetTriggerUIEventFrame())
    if _____7D22_5F15 < 0 then
        return
    end
    local _____5730_70B9_5E27 = _____4E16_754C_5730_56FE_5E27["地点帧组表"][_____7D22_5F15 + 1]
    if _____5730_70B9_5E27 ~= nil then
        DzFrameShow(_____5730_70B9_5E27["文本框"], true)
    end
end
local function ____on_5730_70B9_9F20_6807_79BB_5F00()
    local _____7D22_5F15 = _____627E_5230_89E6_53D1_5730_70B9_7D22_5F15(DzGetTriggerUIEventFrame())
    if _____7D22_5F15 < 0 then
        return
    end
    local _____5730_70B9_5E27 = _____4E16_754C_5730_56FE_5E27["地点帧组表"][_____7D22_5F15 + 1]
    if _____5730_70B9_5E27 ~= nil then
        DzFrameShow(_____5730_70B9_5E27["文本框"], false)
    end
end
local function ____on_4E16_754C_5730_56FE_5C55_5F00Timer()
    local timer = GetExpiredTimer()
    if timer == nil or timer == 0 then
        return
    end
    local timerID = GetHandleId(timer)
    local _____73A9_5BB6 = _____5730_56FE_5C55_5F00_73A9_5BB6_8868[timerID]
    _____5730_56FE_5C55_5F00_73A9_5BB6_8868[timerID] = nil
    if _____73A9_5BB6 ~= nil and _____73A9_5BB6 ~= 0 and GetLocalPlayer() == _____73A9_5BB6 then
        DzFrameShow(_____4E16_754C_5730_56FE_5E27["放大图标"], false)
        DzFrameShow(_____4E16_754C_5730_56FE_5E27["地图根帧"], true)
    end
    DestroyTimer(timer)
end
local function _____521B_5EFA_5730_56FE_5C55_5F00Timer(_____73A9_5BB6)
    local timer = CreateTimer()
    if timer == nil or timer == 0 then
        return
    end
    _____5730_56FE_5C55_5F00_73A9_5BB6_8868[GetHandleId(timer)] = _____73A9_5BB6
    TimerStart(timer, _____5730_56FE_5C55_5F00_5EF6_8FDF_79D2, false, ____on_4E16_754C_5730_56FE_5C55_5F00Timer)
end
____exports["本地隐藏世界地图"] = function(_____73A9_5BB6)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 or GetLocalPlayer() ~= _____73A9_5BB6 then
        return
    end
    DzFrameShow(_____4E16_754C_5730_56FE_5E27["地图根帧"], false)
end
____exports["刷新世界地图当前位置"] = function(_____73A9_5BB6)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____662F_672C_5730_73A9_5BB6 = GetLocalPlayer() == _____73A9_5BB6
    do
        local _____5730_70B9ID = 1
        while _____5730_70B9ID <= #_____4E16_754C_5730_56FE_5730_70B9_914D_7F6E_8868 do
            local _____5730_70B9_5E27 = _____83B7_53D6_4E16_754C_5730_56FE_5730_70B9_5E27(_____5730_70B9ID)
            if _____662F_672C_5730_73A9_5BB6 and _____5730_70B9_5E27 ~= nil then
                DzFrameShow(_____5730_70B9_5E27["当前位置箭头"], false)
            end
            _____5730_70B9ID = _____5730_70B9ID + 1
        end
    end
    local _____82F1_96C4 = _____82F1_96C4_6865_63A5.getRegisteredPlayerHero(_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_5730_70B9_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E16_754C_5730_56FE_5730_70B9_914D_7F6E_8868[_____7D22_5F15 + 1]
                local _____4F4D_4E8E_5F53_524D_5730_70B9 = _____5355_4F4D_4F4D_4E8E_77E9_5F62(_____82F1_96C4, _____914D_7F6E["当前位置矩形键1"]) or _____5355_4F4D_4F4D_4E8E_77E9_5F62(_____82F1_96C4, _____914D_7F6E["当前位置矩形键2"]) or _____5355_4F4D_4F4D_4E8E_77E9_5F62(_____82F1_96C4, _____914D_7F6E["当前位置矩形键3"])
                if not _____4F4D_4E8E_5F53_524D_5730_70B9 or not _____662F_672C_5730_73A9_5BB6 then
                    goto __continue30
                end
                local _____5730_70B9_5E27 = _____83B7_53D6_4E16_754C_5730_56FE_5730_70B9_5E27(_____914D_7F6E["地点ID"])
                if _____5730_70B9_5E27 ~= nil then
                    DzFrameShow(_____5730_70B9_5E27["当前位置箭头"], true)
                end
            end
            ::__continue30::
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
local function ____on_4E16_754C_5730_56FE_6309_952E(event)
    local _____73A9_5BB6 = event.player
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    if DzIsChatBoxOpen() == true then
        return
    end
    ____exports["刷新世界地图当前位置"](_____73A9_5BB6)
    _____97F3_6548_51FD_6570.Sound3DII_Mp3Play("XT\\YX-FY.mp3", _____73A9_5BB6)
    local _____73A9_5BB6ID = GetPlayerId(_____73A9_5BB6)
    if _____73A9_5BB6_5730_56FE_6253_5F00_72B6_6001_8868[_____73A9_5BB6ID] ~= true then
        _____73A9_5BB6_5730_56FE_6253_5F00_72B6_6001_8868[_____73A9_5BB6ID] = true
        if GetLocalPlayer() == _____73A9_5BB6 then
            DzFrameShow(_____4E16_754C_5730_56FE_5E27["放大图标"], true)
        end
        _____521B_5EFA_5730_56FE_5C55_5F00Timer(_____73A9_5BB6)
    else
        _____73A9_5BB6_5730_56FE_6253_5F00_72B6_6001_8868[_____73A9_5BB6ID] = false
        ____exports["本地隐藏世界地图"](_____73A9_5BB6)
    end
end
local function _____6CE8_518C_5730_70B9_60AC_505C_4E8B_4EF6()
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_5E27["地点帧组表"] do
            do
                local _____5730_70B9_5E27 = _____4E16_754C_5730_56FE_5E27["地点帧组表"][_____7D22_5F15 + 1]
                if _____5730_70B9_5E27 == nil then
                    goto __continue41
                end
                ____Frame_5DE5_5177.frameSetScriptByCode(_____5730_70B9_5E27["按钮"], _____5730_70B9_9F20_6807_8FDB_5165_4E8B_4EF6, ____on_5730_70B9_9F20_6807_8FDB_5165, false)
                ____Frame_5DE5_5177.frameSetScriptByCode(_____5730_70B9_5E27["按钮"], _____5730_70B9_9F20_6807_79BB_5F00_4E8B_4EF6, ____on_5730_70B9_9F20_6807_79BB_5F00, false)
            end
            ::__continue41::
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
____exports["初始化世界地图交互"] = function()
    if _____4E16_754C_5730_56FE_4EA4_4E92_5DF2_521D_59CB_5316 then
        return
    end
    _____4E16_754C_5730_56FE_4EA4_4E92_5DF2_521D_59CB_5316 = true
    _____6CE8_518C_5730_70B9_60AC_505C_4E8B_4EF6()
    _____540C_6B65_8F93_5165.registerSyncHardwareKey(_____786C_4EF6_5E38_91CF.KEY.M, _____786C_4EF6_5E38_91CF.KEY_STATE.DOWN, ____on_4E16_754C_5730_56FE_6309_952E)
end
return ____exports
