--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_7269_54C1_63D0_793A_8BFB_53D6_7F13_5B58 = require("系统.09．表现系统.12．物品提示模拟.02．物品提示读取缓存")
local _____786E_4FDD_7269_54C1_63D0_793A_7F13_5B58_6E05_7406Tick = ____02_FF0E_7269_54C1_63D0_793A_8BFB_53D6_7F13_5B58["确保物品提示缓存清理Tick"]
local ____03_FF0E_7269_54C1_63D0_793A_5185_5BB9 = require("系统.09．表现系统.12．物品提示模拟.03．物品提示内容")
local _____6784_5EFA_7269_54C1_63D0_793A_5185_5BB9 = ____03_FF0E_7269_54C1_63D0_793A_5185_5BB9["构建物品提示内容"]
local ____01_FF0E_7269_54C1_63D0_793AUI = require("系统.09．表现系统.12．物品提示模拟.01．物品提示UI")
local _____521B_5EFA_7269_54C1_63D0_793AUI = ____01_FF0E_7269_54C1_63D0_793AUI["创建物品提示UI"]
local _____66F4_65B0_7269_54C1_63D0_793A_5185_5BB9 = ____01_FF0E_7269_54C1_63D0_793AUI["更新物品提示内容"]
local _____951A_5B9A_63D0_793A_6839_6846_5230_539F_751F_7269_54C1_63D0_793A_4F4D_7F6E = ____01_FF0E_7269_54C1_63D0_793AUI["锚定提示根框到原生物品提示位置"]
local _____6709_6548_5E27 = ____01_FF0E_7269_54C1_63D0_793AUI["有效帧"]
local japi = require("jass.japi")
local jass = require("jass.common")
local bjTrigger = require("lib.扩展函数.BJ函数.01．触发与事件")
local centerTimer = require("系统.00．核心系统.05．中心计时器")
local _____6CE8_518C_73A9_5BB6_9009_4E2D_4E8B_4EF6BJ = bjTrigger.TriggerRegisterPlayerSelectionEventBJ
local _____6DFB_52A0_5EF6_8FDF_56DE_8C03 = centerTimer.addDelayedCallback
local _____6DFB_52A0_5468_671F_56DE_8C03 = centerTimer.addPeriodicCallback
local DzGetGameUI = japi.DzGetGameUI
local DzFrameGetItemBarButton = japi.DzFrameGetItemBarButton
local DzFrameSetScriptByCode = japi.DzFrameSetScriptByCode
local DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame
local DzGetTriggerUIEventPlayer = japi.DzGetTriggerUIEventPlayer
local DzFrameGetTooltip = japi.DzFrameGetTooltip
local DzFrameClearAllPoints = japi.DzFrameClearAllPoints
local DzFrameSetPoint = japi.DzFrameSetPoint
local DzFrameShow = japi.DzFrameShow
local UnitItemInSlot = jass.UnitItemInSlot
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local GetTriggerPlayer = jass.GetTriggerPlayer
local GetTriggerUnit = jass.GetTriggerUnit
local GetPlayerId = jass.GetPlayerId
local Player = jass.Player
local POINT_BOTTOM = 7
local POINT_BOTTOMRIGHT = 8
local ITEM_BAR_SLOT_COUNT = 6
local MOUSE_ENTER_EVENT_ID = 2
local MOUSE_LEAVE_EVENT_ID = 3
local _____539F_751F_7269_54C1_63D0_793A_538B_5236_95F4_9694_6BEB_79D2 = 33
local _____539F_751F_7269_54C1_63D0_793A_5EF6_8FDF_538B_5236_6B21_6570 = 6
local _____5DF2_521D_59CB_5316 = false
local _____5E27 = nil
local _____5F53_524D_60AC_505C_7269_54C1_69FD_4F4D = -1
local _____9009_4E2D_5355_4F4D_89E6_53D1_5668 = nil
local _____5DF2_6CE8_518C_9009_4E2D_5355_4F4D_89E6_53D1_5668 = false
local _____793E_533A_5F0F_9009_4E2D_5355_4F4DBy_73A9_5BB6ID = {}
local _____539F_751F_7269_54C1_63D0_793A_538B_5236TickID = 0
local function _____793E_533A_5F0F_9009_4E2D_5355_4F4D_8BB0_5F55()
    local player = GetTriggerPlayer()
    local unit = GetTriggerUnit()
    local playerId = player ~= nil and player ~= 0 and GetPlayerId(player) or -1
    if playerId < 0 then
        return
    end
    _____793E_533A_5F0F_9009_4E2D_5355_4F4DBy_73A9_5BB6ID[playerId] = unit
end
local function _____6CE8_518C_793E_533A_5F0F_9009_4E2D_5355_4F4D_8BB0_5F55()
    if _____5DF2_6CE8_518C_9009_4E2D_5355_4F4D_89E6_53D1_5668 then
        return
    end
    _____5DF2_6CE8_518C_9009_4E2D_5355_4F4D_89E6_53D1_5668 = true
    _____9009_4E2D_5355_4F4D_89E6_53D1_5668 = CreateTrigger()
    TriggerAddAction(_____9009_4E2D_5355_4F4D_89E6_53D1_5668, _____793E_533A_5F0F_9009_4E2D_5355_4F4D_8BB0_5F55)
    do
        local playerId = 0
        while playerId < 16 do
            _____6CE8_518C_73A9_5BB6_9009_4E2D_4E8B_4EF6BJ(
                _____9009_4E2D_5355_4F4D_89E6_53D1_5668,
                Player(playerId),
                true
            )
            playerId = playerId + 1
        end
    end
end
local function _____53D6_793E_533A_5F0F_89E6_53D1_73A9_5BB6_9009_4E2D_5355_4F4D()
    local triggerPlayer = DzGetTriggerUIEventPlayer()
    local playerId = triggerPlayer ~= nil and triggerPlayer ~= 0 and GetPlayerId(triggerPlayer) or -1
    local ____temp_0
    if playerId >= 0 then
        ____temp_0 = _____793E_533A_5F0F_9009_4E2D_5355_4F4DBy_73A9_5BB6ID[playerId]
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
local function _____9690_85CF_539F_751F_7269_54C1_63D0_793A()
    local tooltip = DzFrameGetTooltip()
    if not _____6709_6548_5E27(tooltip) then
        return
    end
    DzFrameClearAllPoints(tooltip)
    DzFrameSetPoint(
        tooltip,
        POINT_BOTTOM,
        DzGetGameUI(),
        POINT_BOTTOM,
        0,
        -0.6
    )
end
local function _____6267_884C_539F_751F_7269_54C1_63D0_793A_538B_5236()
    if _____5F53_524D_60AC_505C_7269_54C1_69FD_4F4D < 0 then
        return
    end
    _____9690_85CF_539F_751F_7269_54C1_63D0_793A()
end
local function _____8C03_5EA6_539F_751F_7269_54C1_63D0_793A_5EF6_8FDF_538B_5236()
    do
        local i = 1
        while i <= _____539F_751F_7269_54C1_63D0_793A_5EF6_8FDF_538B_5236_6B21_6570 do
            _____6DFB_52A0_5EF6_8FDF_56DE_8C03(i * 10, _____6267_884C_539F_751F_7269_54C1_63D0_793A_538B_5236)
            i = i + 1
        end
    end
end
local function _____786E_4FDD_539F_751F_7269_54C1_63D0_793A_538B_5236Tick()
    if _____539F_751F_7269_54C1_63D0_793A_538B_5236TickID ~= 0 then
        return
    end
    _____539F_751F_7269_54C1_63D0_793A_538B_5236TickID = _____6DFB_52A0_5468_671F_56DE_8C03(_____539F_751F_7269_54C1_63D0_793A_538B_5236_95F4_9694_6BEB_79D2, _____6267_884C_539F_751F_7269_54C1_63D0_793A_538B_5236)
end
local function _____6062_590D_539F_751F_7269_54C1_63D0_793A()
    local tooltip = DzFrameGetTooltip()
    if not _____6709_6548_5E27(tooltip) then
        return
    end
    DzFrameClearAllPoints(tooltip)
    DzFrameSetPoint(
        tooltip,
        POINT_BOTTOMRIGHT,
        DzGetGameUI(),
        POINT_BOTTOMRIGHT,
        0,
        0.16
    )
end
local function _____9690_85CF_7269_54C1_63D0_793A_6A21_62DFUI()
    _____5F53_524D_60AC_505C_7269_54C1_69FD_4F4D = -1
    if _____5E27 ~= nil then
        DzFrameShow(_____5E27.root, false)
    end
end
local function _____663E_793A_7269_54C1_680F_69FD_4F4D_63D0_793A(slot, hero, item)
    if _____5E27 == nil then
        _____9690_85CF_7269_54C1_63D0_793A_6A21_62DFUI()
        return
    end
    local _____5185_5BB9 = _____6784_5EFA_7269_54C1_63D0_793A_5185_5BB9(item, hero)
    if _____5185_5BB9 == nil then
        _____9690_85CF_7269_54C1_63D0_793A_6A21_62DFUI()
        return
    end
    _____5F53_524D_60AC_505C_7269_54C1_69FD_4F4D = slot
    _____66F4_65B0_7269_54C1_63D0_793A_5185_5BB9(_____5E27, _____5185_5BB9)
    _____951A_5B9A_63D0_793A_6839_6846_5230_539F_751F_7269_54C1_63D0_793A_4F4D_7F6E(_____5E27.root)
    _____9690_85CF_539F_751F_7269_54C1_63D0_793A()
    DzFrameShow(_____5E27.root, true)
    _____9690_85CF_539F_751F_7269_54C1_63D0_793A()
    _____8C03_5EA6_539F_751F_7269_54C1_63D0_793A_5EF6_8FDF_538B_5236()
end
local function _____7269_54C1_680F_6309_94AE_8FDB_5165()
    local triggerFrame = DzGetTriggerUIEventFrame()
    local hero = _____53D6_793E_533A_5F0F_89E6_53D1_73A9_5BB6_9009_4E2D_5355_4F4D()
    local matched = false
    do
        local slot = 0
        while slot < ITEM_BAR_SLOT_COUNT do
            local button = DzFrameGetItemBarButton(slot)
            local ____temp_1
            if hero ~= nil and hero ~= 0 then
                ____temp_1 = UnitItemInSlot(hero, slot)
            else
                ____temp_1 = nil
            end
            local item = ____temp_1
            if item ~= nil and item ~= 0 and triggerFrame == button then
                matched = true
                _____9690_85CF_539F_751F_7269_54C1_63D0_793A()
                _____663E_793A_7269_54C1_680F_69FD_4F4D_63D0_793A(slot, hero, item)
                _____9690_85CF_539F_751F_7269_54C1_63D0_793A()
            end
            slot = slot + 1
        end
    end
    if not matched then
        _____9690_85CF_7269_54C1_63D0_793A_6A21_62DFUI()
    end
end
local function _____7269_54C1_680F_6309_94AE_79BB_5F00()
    _____9690_85CF_7269_54C1_63D0_793A_6A21_62DFUI()
    _____6062_590D_539F_751F_7269_54C1_63D0_793A()
end
local function _____6CE8_518C_539F_751F_7269_54C1_680F_63D0_793A_52AB_6301()
    if _____5E27 == nil then
        return
    end
    do
        local slot = 0
        while slot < ITEM_BAR_SLOT_COUNT do
            do
                local button = DzFrameGetItemBarButton(slot)
                if not _____6709_6548_5E27(button) then
                    goto __continue34
                end
                DzFrameSetScriptByCode(button, MOUSE_ENTER_EVENT_ID, _____7269_54C1_680F_6309_94AE_8FDB_5165, false)
                DzFrameSetScriptByCode(button, MOUSE_LEAVE_EVENT_ID, _____7269_54C1_680F_6309_94AE_79BB_5F00, false)
            end
            ::__continue34::
            slot = slot + 1
        end
    end
end
local function _____521B_5EFA_5E76_663E_793A_7269_54C1_63D0_793A_6A21_62DFUI()
    _____5E27 = _____521B_5EFA_7269_54C1_63D0_793AUI()
    if _____5E27 == nil then
        return
    end
    _____6CE8_518C_539F_751F_7269_54C1_680F_63D0_793A_52AB_6301()
    DzFrameShow(_____5E27.root, false)
end
____exports["初始化物品提示模拟UI"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____6CE8_518C_793E_533A_5F0F_9009_4E2D_5355_4F4D_8BB0_5F55()
    _____786E_4FDD_7269_54C1_63D0_793A_7F13_5B58_6E05_7406Tick()
    _____786E_4FDD_539F_751F_7269_54C1_63D0_793A_538B_5236Tick()
    _____6DFB_52A0_5EF6_8FDF_56DE_8C03(500, _____521B_5EFA_5E76_663E_793A_7269_54C1_63D0_793A_6A21_62DFUI)
end
return ____exports
