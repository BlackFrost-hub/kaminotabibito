--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E = require("系统.07．地形系统.08．世界地图.01．世界地图地点配置")
local _____4E16_754C_5730_56FE_65C5_884C_5956_52B1_914D_7F6E_8868 = ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E["世界地图旅行奖励配置表"]
local _____4E16_754C_5730_56FE_89E3_9501_914D_7F6E_8868 = ____01_FF0E_4E16_754C_5730_56FE_5730_70B9_914D_7F6E["世界地图解锁配置表"]
local ____02_FF0E_4E16_754C_5730_56FE_754C_9762 = require("系统.07．地形系统.08．世界地图.02．世界地图界面")
local _____66F4_65B0_4E16_754C_5730_56FE_5730_70B9_663E_793A = ____02_FF0E_4E16_754C_5730_56FE_754C_9762["更新世界地图地点显示"]
local ____05_FF0E_4E16_754C_5730_56FE_4F20_9001 = require("系统.07．地形系统.08．世界地图.05．世界地图传送")
local _____6CE8_518C_4E16_754C_5730_56FE_5730_70B9_4F20_9001 = ____05_FF0E_4E16_754C_5730_56FE_4F20_9001["注册世界地图地点传送"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local _____533A_57DF_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local _____82F1_96C4_6865_63A5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local ____YD_5B89_5168_7248 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local ____FourCC_5B89_5168_7248 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local _____5267_60C5_8FDB_5EA6_7CFB_7EDF = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local CreateTrigger = jass.CreateTrigger
local TriggerAddAction = jass.TriggerAddAction
local CreateRegion = jass.CreateRegion
local RegionAddRect = jass.RegionAddRect
local GetTriggerUnit = jass.GetTriggerUnit
local GetTriggeringRegion = jass.GetTriggeringRegion
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local UnitAddItemById = jass.UnitAddItemById
local _____4E16_754C_5730_56FE_533A_57DF_914D_7F6EBy_77E9_5F62_952E = {}
local _____4E16_754C_5730_56FE_533A_57DF_914D_7F6EBy_53E5_67C4ID = {}
local _____4E16_754C_5730_56FE_533A_57DF_8FD0_884C_914D_7F6E_8868 = {}
local _____5DF2_89E3_9501_5730_70B9_8868 = {}
local _____4E16_754C_5730_56FE_89E3_9501_5DF2_521D_59CB_5316 = false
local function _____53D6_6216_521B_5EFA_533A_57DF_914D_7F6E(_____77E9_5F62_952E)
    local _____914D_7F6E = _____4E16_754C_5730_56FE_533A_57DF_914D_7F6EBy_77E9_5F62_952E[_____77E9_5F62_952E]
    if _____914D_7F6E == nil then
        _____914D_7F6E = {["矩形键"] = _____77E9_5F62_952E}
        _____4E16_754C_5730_56FE_533A_57DF_914D_7F6EBy_77E9_5F62_952E[_____77E9_5F62_952E] = _____914D_7F6E
        _____4E16_754C_5730_56FE_533A_57DF_8FD0_884C_914D_7F6E_8868[#_____4E16_754C_5730_56FE_533A_57DF_8FD0_884C_914D_7F6E_8868 + 1] = _____914D_7F6E
    end
    return _____914D_7F6E
end
local function _____6784_5EFA_533A_57DF_8FD0_884C_914D_7F6E()
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_89E3_9501_914D_7F6E_8868 do
            do
                local _____89E3_9501_914D_7F6E = _____4E16_754C_5730_56FE_89E3_9501_914D_7F6E_8868[_____7D22_5F15 + 1]
                if _____89E3_9501_914D_7F6E["解锁来源"] ~= nil and _____89E3_9501_914D_7F6E["解锁来源"] ~= "区域探索" or _____89E3_9501_914D_7F6E["矩形键"] == nil then
                    goto __continue6
                end
                _____53D6_6216_521B_5EFA_533A_57DF_914D_7F6E(_____89E3_9501_914D_7F6E["矩形键"])["解锁配置索引"] = _____7D22_5F15
            end
            ::__continue6::
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_65C5_884C_5956_52B1_914D_7F6E_8868 do
            local _____5956_52B1_914D_7F6E = _____4E16_754C_5730_56FE_65C5_884C_5956_52B1_914D_7F6E_8868[_____7D22_5F15 + 1]
            _____53D6_6216_521B_5EFA_533A_57DF_914D_7F6E(_____5956_52B1_914D_7F6E["矩形键"])["旅行奖励配置索引"] = _____7D22_5F15
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
local function _____5904_7406_65C5_884C_5956_52B1(unit, _____914D_7F6E_7D22_5F15)
    if _____914D_7F6E_7D22_5F15 == nil then
        return
    end
    if GetUnitTypeId(unit) ~= ____FourCC_5B89_5168_7248.stringToFourCCSafe("H014") then
        return
    end
    local _____914D_7F6E = _____4E16_754C_5730_56FE_65C5_884C_5956_52B1_914D_7F6E_8868[_____914D_7F6E_7D22_5F15 + 1]
    if _____914D_7F6E == nil then
        return
    end
    local _____5B57_6BB5 = "旅行" .. tostring(_____914D_7F6E["旅行编号"])
    if ____YD_5B89_5168_7248.YDUserDataGetSafe("unit", unit, _____5B57_6BB5, "boolean") == true then
        return
    end
    ____YD_5B89_5168_7248.YDUserDataSetSafe(
        "unit",
        unit,
        _____5B57_6BB5,
        "boolean",
        true
    )
    UnitAddItemById(
        unit,
        ____FourCC_5B89_5168_7248.stringToFourCCSafe("I0DN")
    )
end
local function _____5E94_7528_5730_70B9_89E3_9501(_____914D_7F6E_7D22_5F15)
    local _____914D_7F6E = _____4E16_754C_5730_56FE_89E3_9501_914D_7F6E_8868[_____914D_7F6E_7D22_5F15 + 1]
    if _____914D_7F6E == nil or _____5DF2_89E3_9501_5730_70B9_8868[_____914D_7F6E["地点ID"]] == true then
        return
    end
    _____5DF2_89E3_9501_5730_70B9_8868[_____914D_7F6E["地点ID"]] = true
    _____66F4_65B0_4E16_754C_5730_56FE_5730_70B9_663E_793A(_____914D_7F6E["地点ID"], _____914D_7F6E["解锁提示"], _____914D_7F6E["解锁图标"])
    if _____914D_7F6E["解锁后注册传送"] == true then
        _____6CE8_518C_4E16_754C_5730_56FE_5730_70B9_4F20_9001(_____914D_7F6E["地点ID"])
    end
end
local function _____5904_7406_533A_57DF_5730_70B9_89E3_9501(_____914D_7F6E_7D22_5F15)
    if _____914D_7F6E_7D22_5F15 == nil then
        return
    end
    _____5E94_7528_5730_70B9_89E3_9501(_____914D_7F6E_7D22_5F15)
end
local function ____on_5267_60C5_8FDB_5EA6_53D8_66F4_89E3_9501_4E16_754C_5730_56FE(_____65B0_8FDB_5EA6, _____65E7_8FDB_5EA6)
    if _____65B0_8FDB_5EA6 <= _____65E7_8FDB_5EA6 then
        return
    end
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_89E3_9501_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E16_754C_5730_56FE_89E3_9501_914D_7F6E_8868[_____7D22_5F15 + 1]
                if _____914D_7F6E["解锁来源"] ~= "主线剧情" or _____914D_7F6E["目标剧情进度"] == nil then
                    goto __continue23
                end
                if _____914D_7F6E["目标剧情进度"] > _____65E7_8FDB_5EA6 and _____914D_7F6E["目标剧情进度"] <= _____65B0_8FDB_5EA6 then
                    _____5E94_7528_5730_70B9_89E3_9501(_____7D22_5F15)
                end
            end
            ::__continue23::
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
local function _____6062_590D_5F53_524D_5267_60C5_8FDB_5EA6_5730_56FE_89E3_9501()
    local _____5F53_524D_5267_60C5_8FDB_5EA6 = _____5267_60C5_8FDB_5EA6_7CFB_7EDF["读取剧情进度"]()
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_89E3_9501_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E16_754C_5730_56FE_89E3_9501_914D_7F6E_8868[_____7D22_5F15 + 1]
                if _____914D_7F6E["解锁来源"] ~= "主线剧情" or _____914D_7F6E["目标剧情进度"] == nil then
                    goto __continue28
                end
                if _____914D_7F6E["目标剧情进度"] <= _____5F53_524D_5267_60C5_8FDB_5EA6 then
                    _____5E94_7528_5730_70B9_89E3_9501(_____7D22_5F15)
                end
            end
            ::__continue28::
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
local function ____on_4E16_754C_5730_56FE_533A_57DF_8FDB_5165()
    local unit = GetTriggerUnit()
    if unit == nil or unit == 0 or not _____82F1_96C4_6865_63A5["是玩家英雄组单位"](unit) then
        return
    end
    local region = GetTriggeringRegion()
    if region == nil or region == 0 then
        return
    end
    local _____8FD0_884C_914D_7F6E = _____4E16_754C_5730_56FE_533A_57DF_914D_7F6EBy_53E5_67C4ID[GetHandleId(region)]
    if _____8FD0_884C_914D_7F6E == nil then
        return
    end
    _____5904_7406_65C5_884C_5956_52B1(unit, _____8FD0_884C_914D_7F6E["旅行奖励配置索引"])
    _____5904_7406_533A_57DF_5730_70B9_89E3_9501(_____8FD0_884C_914D_7F6E["解锁配置索引"])
end
local function _____6CE8_518C_533A_57DF(_____4E1A_52A1_89E6_53D1_5668, _____8FD0_884C_914D_7F6E)
    local rect = jglobals[_____8FD0_884C_914D_7F6E["矩形键"]]
    if rect == nil or rect == 0 then
        return
    end
    local region = CreateRegion()
    if region == nil or region == 0 then
        return
    end
    RegionAddRect(region, rect)
    _____4E16_754C_5730_56FE_533A_57DF_914D_7F6EBy_53E5_67C4ID[GetHandleId(region)] = _____8FD0_884C_914D_7F6E
    _____533A_57DF_4E8B_4EF6_4E2D_5FC3.registerEnterRegionTrigger(_____4E1A_52A1_89E6_53D1_5668, region, nil)
end
____exports["初始化世界地图解锁"] = function()
    if _____4E16_754C_5730_56FE_89E3_9501_5DF2_521D_59CB_5316 then
        return
    end
    _____4E16_754C_5730_56FE_89E3_9501_5DF2_521D_59CB_5316 = true
    _____6784_5EFA_533A_57DF_8FD0_884C_914D_7F6E()
    _____5267_60C5_8FDB_5EA6_7CFB_7EDF["注册剧情进度变更监听"](____on_5267_60C5_8FDB_5EA6_53D8_66F4_89E3_9501_4E16_754C_5730_56FE)
    _____6062_590D_5F53_524D_5267_60C5_8FDB_5EA6_5730_56FE_89E3_9501()
    local _____4E1A_52A1_89E6_53D1_5668 = CreateTrigger()
    if _____4E1A_52A1_89E6_53D1_5668 == nil or _____4E1A_52A1_89E6_53D1_5668 == 0 then
        return
    end
    TriggerAddAction(_____4E1A_52A1_89E6_53D1_5668, ____on_4E16_754C_5730_56FE_533A_57DF_8FDB_5165)
    do
        local _____7D22_5F15 = 0
        while _____7D22_5F15 < #_____4E16_754C_5730_56FE_533A_57DF_8FD0_884C_914D_7F6E_8868 do
            local _____8FD0_884C_914D_7F6E = _____4E16_754C_5730_56FE_533A_57DF_8FD0_884C_914D_7F6E_8868[_____7D22_5F15 + 1]
            if _____8FD0_884C_914D_7F6E ~= nil then
                _____6CE8_518C_533A_57DF(_____4E1A_52A1_89E6_53D1_5668, _____8FD0_884C_914D_7F6E)
            end
            _____7D22_5F15 = _____7D22_5F15 + 1
        end
    end
end
return ____exports
