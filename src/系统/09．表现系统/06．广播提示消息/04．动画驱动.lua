--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示玩家槽数"]
local _____6BCF_73A9_5BB6_5E7F_64AD_63D0_793A_69FD_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["每玩家广播提示槽数"]
local _____53D6_5E7F_64AD_63D0_793A_69FD_7D22_5F15 = ____00_FF0E_5E38_91CF_5B9A_4E49["取广播提示槽索引"]
local _____53D6_5E7F_64AD_63D0_793A_69FD_4F4DY = ____00_FF0E_5E38_91CF_5B9A_4E49["取广播提示槽位Y"]
local _____5E7F_64AD_63D0_793A_72B6_6001__9690_85CF = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示状态_隐藏"]
local _____5E7F_64AD_63D0_793A_72B6_6001__6ED1_5165 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示状态_滑入"]
local _____5E7F_64AD_63D0_793A_72B6_6001__505C_7559 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示状态_停留"]
local _____5E7F_64AD_63D0_793A_72B6_6001__6DE1_51FA = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示状态_淡出"]
local _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示滑入毫秒"]
local _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示淡出毫秒"]
local _____5E7F_64AD_63D0_793A_5237_65B0_6BEB_79D2 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示刷新毫秒"]
local _____5E7F_64AD_63D0_793A_8D77_59CBX = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示起始X"]
local _____5E7F_64AD_63D0_793A_505C_7559X = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示停留X"]
local _____5E7F_64AD_63D0_793A_6700_5927_900F_660E_5EA6 = ____00_FF0E_5E38_91CF_5B9A_4E49["广播提示最大透明度"]
local _____5E27_70B9_5DE6 = ____00_FF0E_5E38_91CF_5B9A_4E49["帧点左"]
local ____02_FF0EUI_521B_5EFA = require("系统.09．表现系统.06．广播提示消息.02．UI创建")
local _____5E7F_64AD_63D0_793A_69FD_5E27_8868 = ____02_FF0EUI_521B_5EFA["广播提示槽帧表"]
local ____03_FF0E_6D88_606F_961F_5217 = require("系统.09．表现系统.06．广播提示消息.03．消息队列")
local _____5E7F_64AD_63D0_793A_69FD_72B6_6001_8868 = ____03_FF0E_6D88_606F_961F_5217["广播提示槽状态表"]
local ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____05_FF0E_4E2D_5FC3_8BA1_65F6_5668.addPeriodicCallback
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetLocalPlayer = jass.GetLocalPlayer
local GetPlayerId = jass.GetPlayerId
local R2I = jass.R2I
local DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint
local DzFrameSetAlpha = japi.DzFrameSetAlpha
local DzFrameShow = japi.DzFrameShow
local _____52A8_753B_56DE_8C03ID = 0
local function _____9650_523601(_____503C)
    if _____503C <= 0 then
        return 0
    end
    if _____503C >= 1 then
        return 1
    end
    return _____503C
end
local function _____53D6_672C_673A_73A9_5BB6ID()
    local _____672C_673A_73A9_5BB6 = GetLocalPlayer()
    if _____672C_673A_73A9_5BB6 == nil or _____672C_673A_73A9_5BB6 == 0 then
        return -1
    end
    return GetPlayerId(_____672C_673A_73A9_5BB6)
end
local function _____63A8_8FDB_6ED1_5165(_____72B6_6001)
    local _____8FDB_5EA6 = _____9650_523601(_____72B6_6001.elapsedMs / _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2)
    _____72B6_6001.x = _____5E7F_64AD_63D0_793A_8D77_59CBX + (_____5E7F_64AD_63D0_793A_505C_7559X - _____5E7F_64AD_63D0_793A_8D77_59CBX) * _____8FDB_5EA6
    _____72B6_6001.alpha = _____5E7F_64AD_63D0_793A_6700_5927_900F_660E_5EA6 * _____8FDB_5EA6
    if _____72B6_6001.elapsedMs >= _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 then
        _____72B6_6001.state = _____5E7F_64AD_63D0_793A_72B6_6001__505C_7559
        _____72B6_6001.elapsedMs = 0
        _____72B6_6001.x = _____5E7F_64AD_63D0_793A_505C_7559X
        _____72B6_6001.alpha = _____5E7F_64AD_63D0_793A_6700_5927_900F_660E_5EA6
    end
end
local function _____63A8_8FDB_505C_7559(_____72B6_6001)
    _____72B6_6001.x = _____5E7F_64AD_63D0_793A_505C_7559X
    _____72B6_6001.alpha = _____5E7F_64AD_63D0_793A_6700_5927_900F_660E_5EA6
    if _____72B6_6001.elapsedMs >= _____72B6_6001.durationMs then
        _____72B6_6001.state = _____5E7F_64AD_63D0_793A_72B6_6001__6DE1_51FA
        _____72B6_6001.elapsedMs = 0
    end
end
local function _____63A8_8FDB_6DE1_51FA(_____72B6_6001)
    local _____8FDB_5EA6 = _____9650_523601(_____72B6_6001.elapsedMs / _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2)
    _____72B6_6001.x = _____5E7F_64AD_63D0_793A_505C_7559X
    _____72B6_6001.alpha = _____5E7F_64AD_63D0_793A_6700_5927_900F_660E_5EA6 * (1 - _____8FDB_5EA6)
    if _____72B6_6001.elapsedMs >= _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2 then
        _____72B6_6001.active = false
        _____72B6_6001.state = _____5E7F_64AD_63D0_793A_72B6_6001__9690_85CF
        _____72B6_6001.elapsedMs = 0
        _____72B6_6001.alpha = 0
    end
end
local function _____63A8_8FDB_69FD_4F4D_72B6_6001(_____72B6_6001)
    if not _____72B6_6001.active then
        return
    end
    _____72B6_6001.elapsedMs = _____72B6_6001.elapsedMs + _____5E7F_64AD_63D0_793A_5237_65B0_6BEB_79D2
    if _____72B6_6001.state == _____5E7F_64AD_63D0_793A_72B6_6001__6ED1_5165 then
        _____63A8_8FDB_6ED1_5165(_____72B6_6001)
    elseif _____72B6_6001.state == _____5E7F_64AD_63D0_793A_72B6_6001__505C_7559 then
        _____63A8_8FDB_505C_7559(_____72B6_6001)
    elseif _____72B6_6001.state == _____5E7F_64AD_63D0_793A_72B6_6001__6DE1_51FA then
        _____63A8_8FDB_6DE1_51FA(_____72B6_6001)
    end
end
local function _____5E94_7528_69FD_4F4D_5E27(_____5E8F_53F7, _____72B6_6001, _____672C_673A_73A9_5BB6ID)
    local _____5E27_7EC4 = _____5E7F_64AD_63D0_793A_69FD_5E27_8868[_____5E8F_53F7 + 1]
    if _____5E27_7EC4 == nil then
        return
    end
    local _____53EF_89C1 = _____72B6_6001.active and _____672C_673A_73A9_5BB6ID == _____72B6_6001.playerId
    DzFrameSetAbsolutePoint(
        _____5E27_7EC4.root,
        _____5E27_70B9_5DE6,
        _____72B6_6001.x,
        _____53D6_5E7F_64AD_63D0_793A_69FD_4F4DY(_____72B6_6001.slotId)
    )
    DzFrameSetAlpha(
        _____5E27_7EC4.root,
        R2I(_____72B6_6001.alpha)
    )
    DzFrameShow(_____5E27_7EC4.root, _____53EF_89C1)
end
____exports["on广播提示消息Tick"] = function()
    local _____672C_673A_73A9_5BB6ID = _____53D6_672C_673A_73A9_5BB6ID()
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            do
                local _____69FD_4F4DID = 0
                while _____69FD_4F4DID < _____6BCF_73A9_5BB6_5E7F_64AD_63D0_793A_69FD_6570 do
                    do
                        local _____5E8F_53F7 = _____53D6_5E7F_64AD_63D0_793A_69FD_7D22_5F15(_____73A9_5BB6ID, _____69FD_4F4DID)
                        local _____72B6_6001 = _____5E7F_64AD_63D0_793A_69FD_72B6_6001_8868[_____5E8F_53F7 + 1]
                        if _____72B6_6001 == nil then
                            goto __continue24
                        end
                        _____63A8_8FDB_69FD_4F4D_72B6_6001(_____72B6_6001)
                        _____5E94_7528_69FD_4F4D_5E27(_____5E8F_53F7, _____72B6_6001, _____672C_673A_73A9_5BB6ID)
                    end
                    ::__continue24::
                    _____69FD_4F4DID = _____69FD_4F4DID + 1
                end
            end
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
____exports["启动广播提示动画驱动"] = function()
    if _____52A8_753B_56DE_8C03ID ~= 0 then
        return
    end
    _____52A8_753B_56DE_8C03ID = addPeriodicCallback(_____5E7F_64AD_63D0_793A_5237_65B0_6BEB_79D2, ____exports["on广播提示消息Tick"])
end
return ____exports
