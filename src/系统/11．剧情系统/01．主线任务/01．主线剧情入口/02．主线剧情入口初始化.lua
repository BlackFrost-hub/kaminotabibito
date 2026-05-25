--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.01．主线NPC初始化配置表")
local _____4E3B_7EBFNPC_521D_59CB_5316_5EF6_8FDF_79D2 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线NPC初始化延迟秒"]
local _____4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线NPC初始化配置表"]
local _____4E3B_7EBF_5267_60C5_5168_5C40_5355_4F4D_5165_53E3_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线剧情全局单位入口配置表"]
local _____4E3B_7EBF_5267_60C5_5355_4F4D_8303_56F4_5165_53E3_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线剧情单位范围入口配置表"]
local _____4E3B_7EBF_5267_60C5_53EF_7834_574F_7269_521D_59CB_5316_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线剧情可破坏物初始化配置表"]
local _____4E3B_7EBF_5267_60C5_77E9_5F62_5165_53E3_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线剧情矩形入口配置表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_1.safeTimerStart
local safeDestroyTimer = ____require_result_1.safeDestroyTimer
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.index")
local _____67E5_627E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_3["查找主线剧情片段"]
local CreateTrigger = jass.CreateTrigger
local CreateTimer = jass.CreateTimer
local CreateUnit = jass.CreateUnit
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local GetTriggerUnit = jass.GetTriggerUnit
local GetTriggeringTrigger = jass.GetTriggeringTrigger
local Player = jass.Player
local SetDestructableInvulnerable = jass.SetDestructableInvulnerable
local TriggerAddAction = jass.TriggerAddAction
local TriggerRegisterEnterRectSimple = jass.TriggerRegisterEnterRectSimple
local TriggerRegisterUnitInRange = jass.TriggerRegisterUnitInRange
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local _____5DF2_8BF7_6C42_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = false
local _____5DF2_6267_884C_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = false
local ____NPC_8FD0_884C_65F6_8868 = {}
local _____5165_53E3_914D_7F6EBy_89E6_53D1_5668ID = {}
local function _____83B7_53D6_5168_5C40_53E5_67C4(_____53D8_91CF_540D)
    return jglobals[_____53D8_91CF_540D]
end
local function _____8BFB_53D6_5DF2_7ED1_5B9ANPC(_____914D_7F6E)
    if _____914D_7F6E["YD表"] == nil or _____914D_7F6E["YD键"] == nil or _____914D_7F6E["YD字段"] == nil then
        return nil
    end
    return YDUserDataGetSafe("string", _____914D_7F6E["YD表"], _____914D_7F6E["YD键"], _____914D_7F6E["YD类型"] or "unit")
end
local function _____5199_5165NPC_7ED1_5B9A(_____914D_7F6E, unit)
    if _____914D_7F6E["YD表"] == nil or _____914D_7F6E["YD键"] == nil or _____914D_7F6E["YD字段"] == nil then
        return
    end
    YDUserDataSetSafe(
        "string",
        _____914D_7F6E["YD表"],
        _____914D_7F6E["YD键"],
        _____914D_7F6E["YD类型"] or "unit",
        unit
    )
end
local function _____8BB0_5F55NPC_8FD0_884C_65F6(_____914D_7F6E, unit)
    if unit == nil then
        return
    end
    ____NPC_8FD0_884C_65F6_8868[_____914D_7F6E["配置名"]] = unit
end
local function _____521D_59CB_5316_5355_4E2ANPC(_____914D_7F6E)
    local unit = _____8BFB_53D6_5DF2_7ED1_5B9ANPC(_____914D_7F6E)
    if unit == nil then
        unit = CreateUnit(
            Player(_____914D_7F6E["玩家ID"] or _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
            stringToFourCC(_____914D_7F6E["单位ID"]),
            _____914D_7F6E.X,
            _____914D_7F6E.Y,
            _____914D_7F6E["朝向"]
        )
        _____5199_5165NPC_7ED1_5B9A(_____914D_7F6E, unit)
    end
    _____8BB0_5F55NPC_8FD0_884C_65F6(_____914D_7F6E, unit)
end
local function _____8BB0_5F55_5165_53E3_89E6_53D1_5668_914D_7F6E(trigger, _____914D_7F6E)
    if trigger == nil then
        return
    end
    _____5165_53E3_914D_7F6EBy_89E6_53D1_5668ID[tostring(GetHandleId(trigger)
    )] = _____914D_7F6E
end
local function ____on_4E3B_7EBF_5267_60C5_5165_53E3_89E6_53D1()
    local trigger = GetTriggeringTrigger()
    if trigger == nil then
        return
    end
    local _____914D_7F6E = _____5165_53E3_914D_7F6EBy_89E6_53D1_5668ID[tostring(GetHandleId(trigger)
    )]
    if _____914D_7F6E == nil or _____914D_7F6E["剧情片段ID"] == nil then
        return
    end
    local _____7247_6BB5 = _____67E5_627E_4E3B_7EBF_5267_60C5_7247_6BB5(_____914D_7F6E["剧情片段ID"])
    if _____7247_6BB5 == nil then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    YDUserDataSetSafe(
        "string",
        "主线剧情入口",
        "触发配置",
        "string",
        _____914D_7F6E["配置名"]
    )
    YDUserDataSetSafe(
        "string",
        "主线剧情入口",
        "剧情片段ID",
        "string",
        _____914D_7F6E["剧情片段ID"]
    )
    if _____89E6_53D1_5355_4F4D ~= nil then
        YDUserDataSetSafe(
            "string",
            "主线剧情入口",
            "触发单位",
            "unit",
            _____89E6_53D1_5355_4F4D
        )
    end
end
local function _____521B_5EFA_5165_53E3_89E6_53D1_5668(_____914D_7F6E)
    local trigger = CreateTrigger()
    _____8BB0_5F55_5165_53E3_89E6_53D1_5668_914D_7F6E(trigger, _____914D_7F6E)
    TriggerAddAction(trigger, ____on_4E3B_7EBF_5267_60C5_5165_53E3_89E6_53D1)
    return trigger
end
local function _____521D_59CB_5316_5355_4F4D_8303_56F4_5165_53E3()
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_5355_4F4D_8303_56F4_5165_53E3_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_5355_4F4D_8303_56F4_5165_53E3_914D_7F6E_8868[i + 1]
                local unit = ____NPC_8FD0_884C_65F6_8868[_____914D_7F6E["NPC配置名"]]
                if unit == nil then
                    goto __continue21
                end
                TriggerRegisterUnitInRange(
                    _____521B_5EFA_5165_53E3_89E6_53D1_5668(_____914D_7F6E),
                    unit,
                    _____914D_7F6E["注册范围"],
                    nil
                )
            end
            ::__continue21::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_77E9_5F62_5165_53E3()
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_77E9_5F62_5165_53E3_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_77E9_5F62_5165_53E3_914D_7F6E_8868[i + 1]
                local _____77E9_5F62 = _____83B7_53D6_5168_5C40_53E5_67C4(_____914D_7F6E["矩形变量名"])
                if _____77E9_5F62 == nil then
                    goto __continue25
                end
                TriggerRegisterEnterRectSimple(
                    _____521B_5EFA_5165_53E3_89E6_53D1_5668(_____914D_7F6E),
                    _____77E9_5F62
                )
            end
            ::__continue25::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_5168_5C40_5355_4F4D_5165_53E3()
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_5168_5C40_5355_4F4D_5165_53E3_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_5168_5C40_5355_4F4D_5165_53E3_914D_7F6E_8868[i + 1]
                local unit = _____83B7_53D6_5168_5C40_53E5_67C4(_____914D_7F6E["单位变量名"])
                if unit == nil then
                    goto __continue29
                end
                TriggerRegisterUnitInRange(
                    _____521B_5EFA_5165_53E3_89E6_53D1_5668(_____914D_7F6E),
                    unit,
                    _____914D_7F6E["注册范围"],
                    nil
                )
            end
            ::__continue29::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_53EF_7834_574F_7269()
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_53EF_7834_574F_7269_521D_59CB_5316_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_53EF_7834_574F_7269_521D_59CB_5316_914D_7F6E_8868[i + 1]
                local destructable = _____83B7_53D6_5168_5C40_53E5_67C4(_____914D_7F6E["变量名"])
                if destructable == nil then
                    goto __continue33
                end
                SetDestructableInvulnerable(destructable, _____914D_7F6E["无敌"])
            end
            ::__continue33::
            i = i + 1
        end
    end
end
local function ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316()
    if _____5DF2_6267_884C_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 then
        return
    end
    _____5DF2_6267_884C_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = true
    do
        local i = 0
        while i < #_____4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868 do
            _____521D_59CB_5316_5355_4E2ANPC(_____4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868[i + 1])
            i = i + 1
        end
    end
    _____521D_59CB_5316_5355_4F4D_8303_56F4_5165_53E3()
    _____521D_59CB_5316_77E9_5F62_5165_53E3()
    _____521D_59CB_5316_5168_5C40_5355_4F4D_5165_53E3()
    _____521D_59CB_5316_53EF_7834_574F_7269()
end
local function ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316_5E76_9500_6BC1_8BA1_65F6_5668()
    ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316()
    safeDestroyTimer(GetExpiredTimer())
end
____exports["初始化主线剧情入口"] = function()
    if _____5DF2_8BF7_6C42_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 then
        return
    end
    _____5DF2_8BF7_6C42_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = true
    local timer = CreateTimer()
    safeTimerStart(timer, _____4E3B_7EBFNPC_521D_59CB_5316_5EF6_8FDF_79D2, false, ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316_5E76_9500_6BC1_8BA1_65F6_5668)
end
____exports["立即初始化主线剧情入口_兼容旧JASS数据"] = function()
    ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316()
end
return ____exports
