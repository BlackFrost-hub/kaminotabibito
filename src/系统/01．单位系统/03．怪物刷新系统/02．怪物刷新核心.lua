local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_5E38_91CF_4E0E_7C7B_578B = require("系统.01．单位系统.03．怪物刷新系统.00．常量与类型")
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["中立敌对玩家ID"]
local _____5237_602A_533A_57DF_5168_5C40_540D = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["刷怪区域全局名"]
local _____5237_602A_5355_4F4D_7EC4_952E = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["刷怪单位组键"]
local _____5237_602A_5EF6_8FDF_79D2 = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["刷怪延迟秒"]
local _____5237_602A_8868_540D = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["刷怪表名"]
local _____602A_7269_5237_65B0_6A21_5757_540D = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["怪物刷新模块名"]
local _____7279_6B8A_654C_5BF9_73A9_5BB6ID = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["特殊敌对玩家ID"]
local _____9700_8981_590D_5236_7684_5C5E_6027_952E_5217_8868 = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["需要复制的属性键列表"]
local ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868 = require("系统.01．单位系统.03．怪物刷新系统.01．怪物刷新配置表")
local _____547D_4E2D_7387_56FA_5B9A_914D_7F6E_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["命中率固定配置表"]
local _____66B4_51FB_7387_56FA_5B9A_914D_7F6E_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["暴击率固定配置表"]
local _____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_914D_7F6E_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["特殊精英暴击覆写配置表"]
local _____95EA_907F_7387_56FA_5B9A_914D_7F6E_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["闪避率固定配置表"]
--- 世界地图怪物刷新系统
-- 
-- 迁移来源：
-- - JASS/jass复制粘贴/刷新怪物.j
-- 
-- 保留：
-- - `YDUserData("刷怪","单位组")`
-- - 怪物单位上的 `暴击率 / 暴击伤害 / 魔抗 / 命中率 / 闪避率`
-- 
-- 优化：
-- - 出生点 X/Y 改为模块内缓存，不再写回单位 YDUserData
-- - 死亡延迟刷新改为具名计时器回调 + 上下文表
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_0.debugLog
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.00．杂鱼配置表")
local _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID = ____require_result_1["按名字反查杂鱼单位ID"]
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.01．精英配置表")
local _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID = ____require_result_2["按名字反查精英单位ID"]
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_3["按名字反查总单位ID"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_5["创建单位并登记排泄安全"]
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_6.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_6.YDUserDataSetSafe
local YDUserDataHasSafe = ____require_result_6.YDUserDataHasSafe
local YDUserDataClearTableSafe = ____require_result_6.YDUserDataClearTableSafe
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_7.registerDeathListener
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_8.addDelayedCallback
local ____require_result_9 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_9.GetRandomDirectionDeg
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.index")
local forEachUnitInGroup = ____require_result_10.forEachUnitInGroup
local GroupAddUnit = jass.GroupAddUnit
local GroupRemoveUnit = jass.GroupRemoveUnit
local FirstOfGroup = jass.FirstOfGroup
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitInGroup = jass.IsUnitInGroup
local IsUnitType = jass.IsUnitType
local IsUnitRace = jass.IsUnitRace
local Player = jass.Player
local RemoveUnit = jass.RemoveUnit
local _____5237_602A_533A_57DF = jglobals[_____5237_602A_533A_57DF_5168_5C40_540D]
local _____5237_602A_8BB0_5F55_8868 = __TS__New(Map)
local _____5EF6_8FDF_5237_65B0_4E0A_4E0B_6587_961F_5217 = {}
local _____56FA_5B9A_5C5E_6027_5355_4F4DID_7F13_5B58 = __TS__New(Map)
local _____5DF2_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF = false
local function _____7EDD_5BF9_503C(value)
    return value >= 0 and value or -value
end
local function _____5B9E_6570_8FD1_4F3C_76F8_7B49(a, b, tolerance)
    return _____7EDD_5BF9_503C(a - b) <= tolerance
end
local function _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    local _____5355_4F4D_7EC4 = YDUserDataGetSafe("string", _____5237_602A_8868_540D, _____5237_602A_5355_4F4D_7EC4_952E, "group")
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        _____5355_4F4D_7EC4 = CreateGroup()
        YDUserDataSetSafe(
            "string",
            _____5237_602A_8868_540D,
            _____5237_602A_5355_4F4D_7EC4_952E,
            "group",
            _____5355_4F4D_7EC4
        )
    end
    return _____5355_4F4D_7EC4
end
local function _____6E05_7A7A_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return
    end
    while true do
        local _____5355_4F4D = FirstOfGroup(_____5355_4F4D_7EC4)
        if _____5355_4F4D == nil or _____5355_4F4D == 0 then
            break
        end
        GroupRemoveUnit(_____5355_4F4D_7EC4, _____5355_4F4D)
    end
end
local function _____662F_5237_602A_5019_9009_5355_4F4D(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local playerId = GetPlayerId(owner)
    return playerId == _____7279_6B8A_654C_5BF9_73A9_5BB6ID or playerId == _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID
end
local function _____8BB0_5F55_602A_7269_51FA_751F_70B9(unit, x, y)
    if unit == nil or unit == 0 then
        return
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return
    end
    _____5237_602A_8BB0_5F55_8868:set(
        GetHandleId(unit),
        {
            ["单位类型ID"] = GetUnitTypeId(unit),
            ["所有者玩家ID"] = GetPlayerId(owner),
            ["出生X"] = x,
            ["出生Y"] = y
        }
    )
end
local function _____8BFB_53D6_602A_7269_5C5E_6027(unit, _____5C5E_6027_540D)
    if not YDUserDataHasSafe("unit", unit, _____5C5E_6027_540D, "real") then
        return nil
    end
    local value = __TS__Number(YDUserDataGetSafe("unit", unit, _____5C5E_6027_540D, "real"))
    if value ~= value then
        return nil
    end
    return value
end
local function _____5199_5165_602A_7269_5C5E_6027(unit, _____5C5E_6027_540D, value)
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5C5E_6027_540D,
        "real",
        value
    )
end
local function _____6309_540D_5B57_89E3_6790_5355_4F4DID(_____5355_4F4D_540D)
    local _____5DF2_7F13_5B58 = _____56FA_5B9A_5C5E_6027_5355_4F4DID_7F13_5B58:get(_____5355_4F4D_540D)
    if type(_____5DF2_7F13_5B58) == "number" then
        return _____5DF2_7F13_5B58
    end
    local rawId = _____6309_540D_5B57_53CD_67E5_6742_9C7C_5355_4F4DID(_____5355_4F4D_540D) or _____6309_540D_5B57_53CD_67E5_7CBE_82F1_5355_4F4DID(_____5355_4F4D_540D) or _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D)
    if rawId == nil or rawId == "" then
        debugLog(_____602A_7269_5237_65B0_6A21_5757_540D, "固定属性配置反查失败", _____5355_4F4D_540D)
        return nil
    end
    local unitTypeId = stringToFourCCSafe(rawId)
    _____56FA_5B9A_5C5E_6027_5355_4F4DID_7F13_5B58:set(_____5355_4F4D_540D, unitTypeId)
    return unitTypeId
end
local function _____5199_5165_56FA_5B9A_5C5E_6027_914D_7F6E(unit, _____914D_7F6E_8868)
    local _____5355_4F4D_7C7B_578BID = GetUnitTypeId(unit)
    for ____, _____914D_7F6E in ipairs(_____914D_7F6E_8868) do
        do
            local _____914D_7F6E_5355_4F4DID = _____6309_540D_5B57_89E3_6790_5355_4F4DID(_____914D_7F6E["单位名"])
            if _____914D_7F6E_5355_4F4DID == nil then
                goto __continue24
            end
            if _____5355_4F4D_7C7B_578BID ~= _____914D_7F6E_5355_4F4DID then
                goto __continue24
            end
            _____5199_5165_602A_7269_5C5E_6027(unit, _____914D_7F6E["属性名"], _____914D_7F6E["数值"])
        end
        ::__continue24::
    end
end
local function _____5E94_7528_57FA_7840_602A_7269_5C5E_6027(unit)
    _____5199_5165_56FA_5B9A_5C5E_6027_914D_7F6E(unit, _____66B4_51FB_7387_56FA_5B9A_914D_7F6E_8868)
    _____5199_5165_56FA_5B9A_5C5E_6027_914D_7F6E(unit, _____95EA_907F_7387_56FA_5B9A_914D_7F6E_8868)
    _____5199_5165_56FA_5B9A_5C5E_6027_914D_7F6E(unit, _____547D_4E2D_7387_56FA_5B9A_914D_7F6E_8868)
    if IsUnitType(unit, jass.UNIT_TYPE_HERO) or IsUnitRace(unit, jass.RACE_DEMON) then
        _____5199_5165_602A_7269_5C5E_6027(unit, "暴击率", 0.1)
        _____5199_5165_602A_7269_5C5E_6027(unit, "魔抗", 0.25)
        _____5199_5165_602A_7269_5C5E_6027(unit, "闪避率", 0.1)
    end
end
local function _____5E94_7528_7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199(unit, _____51FA_751FX, _____51FA_751FY)
    local _____5355_4F4D_7C7B_578BID = GetUnitTypeId(unit)
    for ____, _____914D_7F6E in ipairs(_____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_914D_7F6E_8868) do
        do
            if _____914D_7F6E["单位名"] ~= nil and _____914D_7F6E["单位名"] ~= "" then
                local _____914D_7F6E_5355_4F4DID = _____6309_540D_5B57_89E3_6790_5355_4F4DID(_____914D_7F6E["单位名"])
                if _____914D_7F6E_5355_4F4DID == nil then
                    goto __continue31
                end
                if _____5355_4F4D_7C7B_578BID ~= _____914D_7F6E_5355_4F4DID then
                    goto __continue31
                end
            end
            if not _____5B9E_6570_8FD1_4F3C_76F8_7B49(_____51FA_751FX, _____914D_7F6E.X, 0.05) then
                goto __continue31
            end
            if not _____5B9E_6570_8FD1_4F3C_76F8_7B49(_____51FA_751FY, _____914D_7F6E.Y, 0.05) then
                goto __continue31
            end
            _____5199_5165_602A_7269_5C5E_6027(unit, "暴击率", _____914D_7F6E["暴击率"])
            return
        end
        ::__continue31::
    end
end
local function _____521D_59CB_5316_5355_4E2A_5237_602A_5355_4F4D(unit)
    local _____51FA_751FX = GetUnitX(unit)
    local _____51FA_751FY = GetUnitY(unit)
    _____8BB0_5F55_602A_7269_51FA_751F_70B9(unit, _____51FA_751FX, _____51FA_751FY)
    _____5E94_7528_57FA_7840_602A_7269_5C5E_6027(unit)
    _____5E94_7528_7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199(unit, _____51FA_751FX, _____51FA_751FY)
end
local function _____5904_7406_5237_602A_533A_57DF_679A_4E3E_5355_4F4D(unit)
    if not _____662F_5237_602A_5019_9009_5355_4F4D(unit) then
        return
    end
    local _____5237_602A_5355_4F4D_7EC4 = _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    GroupAddUnit(_____5237_602A_5355_4F4D_7EC4, unit)
    _____521D_59CB_5316_5355_4E2A_5237_602A_5355_4F4D(unit)
end
local function _____6536_96C6_521D_59CB_5237_602A_5355_4F4D()
    local _____5237_602A_5355_4F4D_7EC4 = _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    _____6E05_7A7A_5355_4F4D_7EC4(_____5237_602A_5355_4F4D_7EC4)
    _____5237_602A_8BB0_5F55_8868:clear()
    if _____5237_602A_533A_57DF == nil or _____5237_602A_533A_57DF == 0 then
        debugLog(_____602A_7269_5237_65B0_6A21_5757_540D, "未找到刷怪矩形", _____5237_602A_533A_57DF_5168_5C40_540D, "跳过初始化")
        return
    end
    local _____4E34_65F6_7EC4 = CreateGroup()
    GroupEnumUnitsInRect(_____4E34_65F6_7EC4, _____5237_602A_533A_57DF, nil)
    forEachUnitInGroup(_____4E34_65F6_7EC4, _____5904_7406_5237_602A_533A_57DF_679A_4E3E_5355_4F4D)
    DestroyGroup(_____4E34_65F6_7EC4)
end
local function _____5FEB_7167_6B7B_4EA1_602A_7269_5C5E_6027(unit)
    local result = {}
    for ____, _____5C5E_6027_540D in ipairs(_____9700_8981_590D_5236_7684_5C5E_6027_952E_5217_8868) do
        local value = _____8BFB_53D6_602A_7269_5C5E_6027(unit, _____5C5E_6027_540D)
        if type(value) == "number" then
            result[_____5C5E_6027_540D] = value
        end
    end
    return result
end
local function _____5E94_7528_5C5E_6027_5FEB_7167_5230_65B0_5355_4F4D(unit, _____5C5E_6027_5FEB_7167)
    for ____, _____5C5E_6027_540D in ipairs(_____9700_8981_590D_5236_7684_5C5E_6027_952E_5217_8868) do
        local value = _____5C5E_6027_5FEB_7167[_____5C5E_6027_540D]
        if type(value) == "number" then
            _____5199_5165_602A_7269_5C5E_6027(unit, _____5C5E_6027_540D, value)
        end
    end
end
local function ____on_602A_7269_5237_65B0_8BA1_65F6_5668_5230_671F()
    local ctx = table.remove(_____5EF6_8FDF_5237_65B0_4E0A_4E0B_6587_961F_5217, 1)
    if ctx == nil then
        return
    end
    local owner = Player(ctx["所有者玩家ID"])
    local _____65B0_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        ctx["单位类型ID"],
        ctx["出生X"],
        ctx["出生Y"],
        GetRandomDirectionDeg()
    )
    if _____65B0_5355_4F4D == nil or _____65B0_5355_4F4D == 0 then
        debugLog(
            _____602A_7269_5237_65B0_6A21_5757_540D,
            "刷新怪物失败",
            "typeId=",
            ctx["单位类型ID"],
            "x=",
            ctx["出生X"],
            "y=",
            ctx["出生Y"]
        )
        return
    end
    _____8BB0_5F55_602A_7269_51FA_751F_70B9(_____65B0_5355_4F4D, ctx["出生X"], ctx["出生Y"])
    _____5E94_7528_5C5E_6027_5FEB_7167_5230_65B0_5355_4F4D(_____65B0_5355_4F4D, ctx["属性快照"])
    local _____5237_602A_5355_4F4D_7EC4 = _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    GroupAddUnit(_____5237_602A_5355_4F4D_7EC4, _____65B0_5355_4F4D)
    GroupRemoveUnit(_____5237_602A_5355_4F4D_7EC4, ctx["死亡单位"])
    YDUserDataClearTableSafe("unit", ctx["死亡单位"])
    _____5237_602A_8BB0_5F55_8868:delete(GetHandleId(ctx["死亡单位"]))
    RemoveUnit(ctx["死亡单位"])
end
local function _____5B89_6392_602A_7269_5EF6_8FDF_5237_65B0(dyingUnit, record)
    _____5EF6_8FDF_5237_65B0_4E0A_4E0B_6587_961F_5217[#_____5EF6_8FDF_5237_65B0_4E0A_4E0B_6587_961F_5217 + 1] = {
        ["死亡单位"] = dyingUnit,
        ["单位类型ID"] = record["单位类型ID"],
        ["所有者玩家ID"] = record["所有者玩家ID"],
        ["出生X"] = record["出生X"],
        ["出生Y"] = record["出生Y"],
        ["属性快照"] = _____5FEB_7167_6B7B_4EA1_602A_7269_5C5E_6027(dyingUnit)
    }
    addDelayedCallback(_____5237_602A_5EF6_8FDF_79D2 * 1000, ____on_602A_7269_5237_65B0_8BA1_65F6_5668_5230_671F)
end
local function ____on_5237_602A_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____5237_602A_5355_4F4D_7EC4 = _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    if not IsUnitInGroup(dyingUnit, _____5237_602A_5355_4F4D_7EC4) then
        return
    end
    local record = _____5237_602A_8BB0_5F55_8868:get(GetHandleId(dyingUnit))
    if record ~= nil then
        _____5B89_6392_602A_7269_5EF6_8FDF_5237_65B0(dyingUnit, record)
        return
    end
    local owner = GetOwningPlayer(dyingUnit)
    if owner == nil or owner == 0 then
        return
    end
    _____5B89_6392_602A_7269_5EF6_8FDF_5237_65B0(
        dyingUnit,
        {
            ["单位类型ID"] = GetUnitTypeId(dyingUnit),
            ["所有者玩家ID"] = GetPlayerId(owner),
            ["出生X"] = GetUnitX(dyingUnit),
            ["出生Y"] = GetUnitY(dyingUnit)
        }
    )
end
____exports["初始化怪物刷新系统"] = function()
    if _____5DF2_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF then
        return
    end
    _____5DF2_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF = true
    _____6536_96C6_521D_59CB_5237_602A_5355_4F4D()
    registerDeathListener(____on_5237_602A_5355_4F4D_6B7B_4EA1)
end
____exports["获取刷怪单位组引用"] = function()
    return _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
end
____exports["是刷怪单位"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return IsUnitInGroup(
        unit,
        _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    ) == true
end
____exports["初始化怪物刷新系统"]()
return ____exports
