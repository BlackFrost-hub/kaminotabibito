--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E = require("系统.07．地形系统.08．世界地图.01．世界地图地点配置")
local _____4E16_754C_5730_56FE_4F20_9001_914D_7F6E_8868 = ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E["世界地图传送配置表"]
local ____02_FF0E_4E16_754C_5730_56FE_754C_9762 = require("系统.07．地形系统.08．世界地图.02．世界地图界面")
local _____83B7_53D6_4E16_754C_5730_56FE_5730_70B9_5E27 = ____02_FF0E_4E16_754C_5730_56FE_754C_9762["获取世界地图地点帧"]
local ____03_FF0E_4E16_754C_5730_56FE_4EA4_4E92 = require("系统.07．地形系统.08．世界地图.03．世界地图交互")
local _____672C_5730_9690_85CF_4E16_754C_5730_56FE = ____03_FF0E_4E16_754C_5730_56FE_4EA4_4E92["本地隐藏世界地图"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____Frame_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.07．Frame函数")
local _____82F1_96C4_6865_63A5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local ____FourCC_5B89_5168_7248 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local _____5355_4F4D_51FD_6570 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local _____7535_5F71_51FD_6570 = require("lib.扩展函数.BJ函数.05A．电影函数")
local _____955C_5934_51FD_6570 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local _____97F3_6548_51FD_6570 = require("lib.扩展函数.封装函数.02．音效系统.04．MP3音效播放")
local _____5267_60C5_8FDB_5EA6_7CFB_7EDF = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8C03_8BD5_8F93_51FA = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame
local DzGetTriggerUIEventPlayer = japi.DzGetTriggerUIEventPlayer
local GetLocalPlayer = jass.GetLocalPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitPosition = jass.SetUnitPosition
local CreateTimer = jass.CreateTimer
local TimerStart = jass.TimerStart
local GetExpiredTimer = jass.GetExpiredTimer
local DestroyTimer = jass.DestroyTimer
local DisplayCineFilter = jass.DisplayCineFilter
local _____53CC_51FB_4E8B_4EF6 = 12
local _____9ED1_5E55_6301_7EED_79D2 = 2.5
local _____955C_5934_79FB_52A8_79D2 = 0.03
local _____5DF2_6CE8_518C_4F20_9001_5730_70B9_8868 = {}
local function _____83B7_53D6_4F20_9001_914D_7F6EBy_5730_70B9ID(_____5730_70B9ID)
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_4F20_9001_914D_7F6E_8868 do
            local _____914D_7F6E = _____4E16_754C_5730_56FE_4F20_9001_914D_7F6E_8868[_____7D22_5F15 + 1]
            if _____914D_7F6E["地点ID"] == _____5730_70B9ID then
                return _____914D_7F6E
            end
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
    return nil
end
local function _____83B7_53D6_4F20_9001_914D_7F6EBy_914D_7F6EID(_____914D_7F6EID)
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_4F20_9001_914D_7F6E_8868 do
            local _____914D_7F6E = _____4E16_754C_5730_56FE_4F20_9001_914D_7F6E_8868[_____7D22_5F15 + 1]
            if _____914D_7F6E["配置ID"] == _____914D_7F6EID then
                return _____914D_7F6E
            end
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
    return nil
end
local function _____83B7_53D6_89E6_53D1_5E27_4F20_9001_914D_7F6E()
    local _____89E6_53D1_5E27 = DzGetTriggerUIEventFrame()
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_4F20_9001_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E16_754C_5730_56FE_4F20_9001_914D_7F6E_8868[_____7D22_5F15 + 1]
                if _____914D_7F6E["地点ID"] == nil then
                    goto __continue12
                end
                local _____5730_70B9_5E27 = _____83B7_53D6_4E16_754C_5730_56FE_5730_70B9_5E27(_____914D_7F6E["地点ID"])
                if _____5730_70B9_5E27 ~= nil and _____5730_70B9_5E27["按钮"] == _____89E6_53D1_5E27 then
                    return _____914D_7F6E
                end
            end
            ::__continue12::
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
    return nil
end
local function ____on_4E16_754C_5730_56FE_9ED1_5E55_7ED3_675F()
    local timer = GetExpiredTimer()
    DisplayCineFilter(false)
    if timer ~= nil and timer ~= 0 then
        DestroyTimer(timer)
    end
end
local function _____521B_5EFA_4E16_754C_5730_56FE_9ED1_5E55Timer()
    local timer = CreateTimer()
    if timer == nil or timer == 0 then
        return
    end
    TimerStart(timer, _____9ED1_5E55_6301_7EED_79D2, false, ____on_4E16_754C_5730_56FE_9ED1_5E55_7ED3_675F)
end
local function _____4F20_9001_6761_4EF6_901A_8FC7(_____914D_7F6E, _____82F1_96C4)
    if _____914D_7F6E["禁止剧情进度"] ~= nil then
        if _____5267_60C5_8FDB_5EA6_7CFB_7EDF["读取剧情进度"]() == _____914D_7F6E["禁止剧情进度"] then
            return false
        end
    end
    local BuffID = ____FourCC_5B89_5168_7248.stringToFourCCSafe(_____914D_7F6E["所需BuffID"])
    return BuffID > 0 and _____5355_4F4D_51FD_6570.UnitHasBuffBJ(_____82F1_96C4, BuffID)
end
local function _____6267_884C_4F20_9001_914D_7F6E(_____914D_7F6E, _____73A9_5BB6)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return false
    end
    local _____82F1_96C4 = _____82F1_96C4_6865_63A5.getRegisteredPlayerHero(_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or not _____4F20_9001_6761_4EF6_901A_8FC7(_____914D_7F6E, _____82F1_96C4) then
        return false
    end
    if GetLocalPlayer() == _____73A9_5BB6 then
        _____672C_5730_9690_85CF_4E16_754C_5730_56FE(_____73A9_5BB6)
        _____7535_5F71_51FD_6570.CinematicFilterGenericBJ(
            0.5,
            jass.BLEND_MODE_BLEND,
            "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
            15,
            15,
            15,
            15,
            0,
            0,
            0,
            0
        )
    end
    _____521B_5EFA_4E16_754C_5730_56FE_9ED1_5E55Timer()
    _____97F3_6548_51FD_6570.Sound3DII_Mp3Play("XT\\YX-CS.mp3", _____73A9_5BB6)
    _____8C03_8BD5_8F93_51FA.debugLogForce(
        "世界地图传送",
        "执行传送",
        "地点ID=",
        _____914D_7F6E["地点ID"],
        "配置ID=",
        _____914D_7F6E["配置ID"],
        "玩家ID=",
        GetPlayerId(_____73A9_5BB6),
        "英雄当前位置=",
        GetUnitX(_____82F1_96C4),
        GetUnitY(_____82F1_96C4),
        "目标坐标=",
        _____914D_7F6E["目标X"],
        _____914D_7F6E["目标Y"],
        "镜头坐标=",
        _____914D_7F6E["镜头X"],
        _____914D_7F6E["镜头Y"]
    )
    if _____914D_7F6E["镜头先于单位"] then
        _____955C_5934_51FD_6570.StarOther_PanCameraToTimedForPlayer(_____73A9_5BB6, _____914D_7F6E["镜头X"], _____914D_7F6E["镜头Y"], _____955C_5934_79FB_52A8_79D2)
        SetUnitPosition(_____82F1_96C4, _____914D_7F6E["目标X"], _____914D_7F6E["目标Y"])
    else
        SetUnitPosition(_____82F1_96C4, _____914D_7F6E["目标X"], _____914D_7F6E["目标Y"])
        _____955C_5934_51FD_6570.StarOther_PanCameraToTimedForPlayer(_____73A9_5BB6, _____914D_7F6E["镜头X"], _____914D_7F6E["镜头Y"], _____955C_5934_79FB_52A8_79D2)
    end
    return true
end
local function ____on_4E16_754C_5730_56FE_5730_70B9_53CC_51FB()
    local _____914D_7F6E = _____83B7_53D6_89E6_53D1_5E27_4F20_9001_914D_7F6E()
    if _____914D_7F6E == nil then
        return
    end
    _____6267_884C_4F20_9001_914D_7F6E(
        _____914D_7F6E,
        DzGetTriggerUIEventPlayer()
    )
end
____exports["执行世界地图传送"] = function(_____914D_7F6EID, _____73A9_5BB6)
    local _____914D_7F6E = _____83B7_53D6_4F20_9001_914D_7F6EBy_914D_7F6EID(_____914D_7F6EID)
    if _____914D_7F6E == nil then
        return false
    end
    return _____6267_884C_4F20_9001_914D_7F6E(_____914D_7F6E, _____73A9_5BB6)
end
____exports["注册世界地图地点传送"] = function(_____5730_70B9ID)
    if _____5DF2_6CE8_518C_4F20_9001_5730_70B9_8868[_____5730_70B9ID] == true then
        return
    end
    local _____914D_7F6E = _____83B7_53D6_4F20_9001_914D_7F6EBy_5730_70B9ID(_____5730_70B9ID)
    if _____914D_7F6E == nil then
        return
    end
    local _____5730_70B9_5E27 = _____83B7_53D6_4E16_754C_5730_56FE_5730_70B9_5E27(_____5730_70B9ID)
    if _____5730_70B9_5E27 == nil or _____5730_70B9_5E27["按钮"] == 0 then
        return
    end
    ____Frame_5DE5_5177.frameSetScriptByCode(_____5730_70B9_5E27["按钮"], _____53CC_51FB_4E8B_4EF6, ____on_4E16_754C_5730_56FE_5730_70B9_53CC_51FB, true)
    _____5DF2_6CE8_518C_4F20_9001_5730_70B9_8868[_____5730_70B9ID] = true
end
return ____exports
