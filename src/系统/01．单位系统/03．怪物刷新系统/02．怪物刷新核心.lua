local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local Set = ____lualib.Set
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____7EDD_5BF9_503C, _____5B9E_6570_8FD1_4F3C_76F8_7B49, _____83B7_53D6_5237_602A_5355_4F4D_7EC4, _____6E05_7A7A_5355_4F4D_7EC4, _____89E3_6790_5237_602A_914D_7F6E_5355_4F4D_7C7B_578BID, _____6DFB_52A0_5237_602A_914D_7F6E_8868_5230_767D_540D_5355, _____6DFB_52A0_76F4_63A5_5355_4F4DID_5217_8868_5230_767D_540D_5355, _____786E_4FDD_5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408_5DF2_521D_59CB_5316, _____662F_5237_602A_5019_9009_5355_4F4D, _____8BB0_5F55_602A_7269_51FA_751F_70B9, _____8BFB_53D6_602A_7269_5C5E_6027, _____5199_5165_602A_7269_5C5E_6027, _____89E3_6790_76F4_63A5_5355_4F4D_7C7B_578BID, _____521D_59CB_5316_56FA_5B9A_5C5E_6027_914D_7F6E_7F13_5B58, _____5E94_7528_57FA_7840_602A_7269_5C5E_6027, _____5E94_7528_7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199, _____521D_59CB_5316_5355_4E2A_5237_602A_5355_4F4D, _____767B_8BB0_5237_602A_5355_4F4D, _____83B7_53D6_5237_602A_533A_57DF, _____5904_7406_5237_602A_533A_57DF_679A_4E3E_5355_4F4D, _____5B8C_6210_521D_59CB_5237_602A_5355_4F4D_6536_96C6, ____on_521D_59CB_5237_602A_5355_4F4D_6536_96C6_6279_6B21, _____6536_96C6_521D_59CB_5237_602A_5355_4F4D, _____5FEB_7167_6B7B_4EA1_602A_7269_5C5E_6027, _____5E94_7528_5C5E_6027_5FEB_7167_5230_65B0_5355_4F4D, ____on_602A_7269_5237_65B0_8BA1_65F6_5668_5230_671F, _____5B89_6392_602A_7269_5EF6_8FDF_5237_65B0, ____on_5237_602A_5355_4F4D_6B7B_4EA1, jass, _____83B7_53D6_77E9_5F62_533A_57DF, stringToFourCCSafe, _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168, YDUserDataGetSafe, YDUserDataSetSafe, YDUserDataHasSafe, YDUserDataClearTableSafe, registerDeathListener, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, GetRandomDirectionDeg, GroupAddUnit, GroupRemoveUnit, FirstOfGroup, CreateGroup, DestroyGroup, GroupEnumUnitsInRect, GetWorldBounds, GetHandleId, GetOwningPlayer, GetPlayerId, GetUnitTypeId, GetUnitX, GetUnitY, IsUnitInGroup, IsUnitType, IsUnitRace, Player, RemoveUnit, _____5237_602A_8BB0_5F55_8868, _____5EF6_8FDF_5237_65B0_4E0A_4E0B_6587_961F_5217, _____5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408, _____56FA_5B9A_5C5E_6027_914D_7F6E_7F13_5B58, _____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_8FD0_884C_65F6_914D_7F6E_8868, _____521D_59CB_6536_96C6_6BCF_6279_5355_4F4D_6570_91CF, _____521D_59CB_6536_96C6_95F4_9694_6BEB_79D2, _____5DF2_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF, _____5DF2_521D_59CB_5316_5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408, _____56FA_5B9A_5C5E_6027_914D_7F6E_5DF2_521D_59CB_5316, _____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4, _____521D_59CB_6536_96C6_56DE_8C03ID, _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C
local ____01_FF0E_6742_9C7C_51FA_751F_914D_7F6E = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.01．杂鱼出生配置")
local _____4E16_754C_5730_56FE_6742_9C7C_51FA_751F_914D_7F6E_8868 = ____01_FF0E_6742_9C7C_51FA_751F_914D_7F6E["世界地图杂鱼出生配置表"]
local ____02_FF0E_7CBE_82F1_51FA_751F_914D_7F6E = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.02．精英出生配置")
local _____4E16_754C_5730_56FE_7CBE_82F1_51FA_751F_914D_7F6E_8868 = ____02_FF0E_7CBE_82F1_51FA_751F_914D_7F6E["世界地图精英出生配置表"]
local ____00_FF0E_5E38_91CF_4E0E_7C7B_578B = require("系统.01．单位系统.03．怪物刷新系统.00．常量与类型")
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["中立敌对玩家ID"]
local _____5237_602A_533A_57DF_540D_79F0 = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["刷怪区域名称"]
local _____5237_602A_5355_4F4D_7EC4_952E = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["刷怪单位组键"]
local _____5237_602A_5EF6_8FDF_79D2 = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["刷怪延迟秒"]
local _____5237_602A_8868_540D = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["刷怪表名"]
local _____7279_6B8A_654C_5BF9_73A9_5BB6ID = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["特殊敌对玩家ID"]
local _____9700_8981_590D_5236_7684_5C5E_6027_952E_5217_8868 = ____00_FF0E_5E38_91CF_4E0E_7C7B_578B["需要复制的属性键列表"]
local ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868 = require("系统.01．单位系统.03．怪物刷新系统.01．怪物刷新配置表")
local _____547D_4E2D_7387_56FA_5B9A_914D_7F6E_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["命中率固定配置表"]
local _____66B4_51FB_7387_56FA_5B9A_914D_7F6E_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["暴击率固定配置表"]
local _____989D_5916_7CBE_82F1_5237_602A_5355_4F4DID_5217_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["额外精英刷怪单位ID列表"]
local _____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_914D_7F6E_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["特殊精英暴击覆写配置表"]
local _____95EA_907F_7387_56FA_5B9A_914D_7F6E_8868 = ____01_FF0E_602A_7269_5237_65B0_914D_7F6E_8868["闪避率固定配置表"]
function _____7EDD_5BF9_503C(value)
    return value >= 0 and value or -value
end
function _____5B9E_6570_8FD1_4F3C_76F8_7B49(a, b, tolerance)
    return _____7EDD_5BF9_503C(a - b) <= tolerance
end
function _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
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
function _____6E05_7A7A_5355_4F4D_7EC4(_____5355_4F4D_7EC4)
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
function _____89E3_6790_5237_602A_914D_7F6E_5355_4F4D_7C7B_578BID(_____914D_7F6E)
    local ____opt_7 = _____914D_7F6E["兼容单位ID"]
    local _____517C_5BB9_5355_4F4DID = ____opt_7 and __TS__StringTrim(_____914D_7F6E["兼容单位ID"])
    if _____517C_5BB9_5355_4F4DID == nil or #_____517C_5BB9_5355_4F4DID < 4 then
        return 0
    end
    return stringToFourCCSafe(__TS__StringSubstring(_____517C_5BB9_5355_4F4DID, 0, 4))
end
function _____6DFB_52A0_5237_602A_914D_7F6E_8868_5230_767D_540D_5355(_____914D_7F6E_8868)
    for ____, _____914D_7F6E in ipairs(_____914D_7F6E_8868) do
        local _____5355_4F4D_7C7B_578BID = _____89E3_6790_5237_602A_914D_7F6E_5355_4F4D_7C7B_578BID(_____914D_7F6E)
        if _____5355_4F4D_7C7B_578BID > 0 then
            _____5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408:add(_____5355_4F4D_7C7B_578BID)
        end
    end
end
function _____6DFB_52A0_76F4_63A5_5355_4F4DID_5217_8868_5230_767D_540D_5355(_____5355_4F4DID_5217_8868)
    for ____, _____5355_4F4DID in ipairs(_____5355_4F4DID_5217_8868) do
        local _____5355_4F4D_7C7B_578BID = _____89E3_6790_76F4_63A5_5355_4F4D_7C7B_578BID(_____5355_4F4DID)
        if _____5355_4F4D_7C7B_578BID > 0 then
            _____5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408:add(_____5355_4F4D_7C7B_578BID)
        end
    end
end
function _____786E_4FDD_5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408_5DF2_521D_59CB_5316()
    if _____5DF2_521D_59CB_5316_5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408 then
        return
    end
    _____5DF2_521D_59CB_5316_5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408 = true
    _____6DFB_52A0_5237_602A_914D_7F6E_8868_5230_767D_540D_5355(_____4E16_754C_5730_56FE_6742_9C7C_51FA_751F_914D_7F6E_8868)
    _____6DFB_52A0_5237_602A_914D_7F6E_8868_5230_767D_540D_5355(_____4E16_754C_5730_56FE_7CBE_82F1_51FA_751F_914D_7F6E_8868)
    _____6DFB_52A0_76F4_63A5_5355_4F4DID_5217_8868_5230_767D_540D_5355(_____989D_5916_7CBE_82F1_5237_602A_5355_4F4DID_5217_8868)
end
function _____662F_5237_602A_5019_9009_5355_4F4D(unit)
    if unit == nil or unit == 0 then
        return false
    end
    _____786E_4FDD_5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408_5DF2_521D_59CB_5316()
    if not _____5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408:has(GetUnitTypeId(unit)) then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local playerId = GetPlayerId(owner)
    return playerId == _____7279_6B8A_654C_5BF9_73A9_5BB6ID or playerId == _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID
end
function _____8BB0_5F55_602A_7269_51FA_751F_70B9(unit, x, y)
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
function _____8BFB_53D6_602A_7269_5C5E_6027(unit, _____5C5E_6027_540D)
    if not YDUserDataHasSafe("unit", unit, _____5C5E_6027_540D, "real") then
        return nil
    end
    local value = __TS__Number(YDUserDataGetSafe("unit", unit, _____5C5E_6027_540D, "real"))
    if value ~= value then
        return nil
    end
    return value
end
function _____5199_5165_602A_7269_5C5E_6027(unit, _____5C5E_6027_540D, value)
    YDUserDataSetSafe(
        "unit",
        unit,
        _____5C5E_6027_540D,
        "real",
        value
    )
end
function _____89E3_6790_76F4_63A5_5355_4F4D_7C7B_578BID(_____5355_4F4DID)
    local ____opt_9 = _____5355_4F4DID
    local _____6E05_7406_540E_5355_4F4DID = ____opt_9 and __TS__StringTrim(_____5355_4F4DID)
    if _____6E05_7406_540E_5355_4F4DID == nil or #_____6E05_7406_540E_5355_4F4DID < 4 then
        return 0
    end
    return stringToFourCCSafe(__TS__StringSubstring(_____6E05_7406_540E_5355_4F4DID, 0, 4))
end
function _____521D_59CB_5316_56FA_5B9A_5C5E_6027_914D_7F6E_7F13_5B58()
    if _____56FA_5B9A_5C5E_6027_914D_7F6E_5DF2_521D_59CB_5316 then
        return
    end
    _____56FA_5B9A_5C5E_6027_914D_7F6E_5DF2_521D_59CB_5316 = true
    local _____56FA_5B9A_5C5E_6027_914D_7F6E_8868_5217_8868 = {_____66B4_51FB_7387_56FA_5B9A_914D_7F6E_8868, _____95EA_907F_7387_56FA_5B9A_914D_7F6E_8868, _____547D_4E2D_7387_56FA_5B9A_914D_7F6E_8868}
    for ____, _____914D_7F6E_8868 in ipairs(_____56FA_5B9A_5C5E_6027_914D_7F6E_8868_5217_8868) do
        for ____, _____914D_7F6E in ipairs(_____914D_7F6E_8868) do
            do
                local _____5355_4F4D_7C7B_578BID = _____89E3_6790_76F4_63A5_5355_4F4D_7C7B_578BID(_____914D_7F6E["单位ID"])
                if _____5355_4F4D_7C7B_578BID <= 0 then
                    goto __continue38
                end
                local _____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868 = _____56FA_5B9A_5C5E_6027_914D_7F6E_7F13_5B58:get(_____5355_4F4D_7C7B_578BID)
                if _____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868 == nil then
                    _____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868 = {}
                    _____56FA_5B9A_5C5E_6027_914D_7F6E_7F13_5B58:set(_____5355_4F4D_7C7B_578BID, _____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868)
                end
                _____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868[#_____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868 + 1] = {["属性名"] = _____914D_7F6E["属性名"], ["数值"] = _____914D_7F6E["数值"]}
            end
            ::__continue38::
        end
    end
    for ____, _____914D_7F6E in ipairs(_____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_914D_7F6E_8868) do
        _____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_8FD0_884C_65F6_914D_7F6E_8868[#_____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_8FD0_884C_65F6_914D_7F6E_8868 + 1] = {
            ["单位类型ID"] = _____89E3_6790_76F4_63A5_5355_4F4D_7C7B_578BID(_____914D_7F6E["单位ID"]),
            X = _____914D_7F6E.X,
            Y = _____914D_7F6E.Y,
            ["暴击率"] = _____914D_7F6E["暴击率"]
        }
    end
end
function _____5E94_7528_57FA_7840_602A_7269_5C5E_6027(unit)
    local _____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868 = _____56FA_5B9A_5C5E_6027_914D_7F6E_7F13_5B58:get(GetUnitTypeId(unit))
    if _____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868 ~= nil then
        for ____, _____914D_7F6E in ipairs(_____5355_4F4D_5C5E_6027_914D_7F6E_5217_8868) do
            _____5199_5165_602A_7269_5C5E_6027(unit, _____914D_7F6E["属性名"], _____914D_7F6E["数值"])
        end
    end
    if IsUnitType(unit, jass.UNIT_TYPE_HERO) or IsUnitRace(unit, jass.RACE_DEMON) then
        _____5199_5165_602A_7269_5C5E_6027(unit, "暴击率", 0.1)
        _____5199_5165_602A_7269_5C5E_6027(unit, "魔抗", 0.25)
        _____5199_5165_602A_7269_5C5E_6027(unit, "闪避率", 0.1)
    end
end
function _____5E94_7528_7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199(unit, _____51FA_751FX, _____51FA_751FY)
    local _____5355_4F4D_7C7B_578BID = GetUnitTypeId(unit)
    for ____, _____914D_7F6E in ipairs(_____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_8FD0_884C_65F6_914D_7F6E_8868) do
        do
            if _____914D_7F6E["单位类型ID"] <= 0 or _____5355_4F4D_7C7B_578BID ~= _____914D_7F6E["单位类型ID"] then
                goto __continue51
            end
            if not _____5B9E_6570_8FD1_4F3C_76F8_7B49(_____51FA_751FX, _____914D_7F6E.X, 0.05) then
                goto __continue51
            end
            if not _____5B9E_6570_8FD1_4F3C_76F8_7B49(_____51FA_751FY, _____914D_7F6E.Y, 0.05) then
                goto __continue51
            end
            _____5199_5165_602A_7269_5C5E_6027(unit, "暴击率", _____914D_7F6E["暴击率"])
            return
        end
        ::__continue51::
    end
end
function _____521D_59CB_5316_5355_4E2A_5237_602A_5355_4F4D(unit)
    local _____51FA_751FX = GetUnitX(unit)
    local _____51FA_751FY = GetUnitY(unit)
    _____8BB0_5F55_602A_7269_51FA_751F_70B9(unit, _____51FA_751FX, _____51FA_751FY)
    _____5E94_7528_57FA_7840_602A_7269_5C5E_6027(unit)
    _____5E94_7528_7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199(unit, _____51FA_751FX, _____51FA_751FY)
end
function _____767B_8BB0_5237_602A_5355_4F4D(unit)
    if not _____662F_5237_602A_5019_9009_5355_4F4D(unit) then
        return
    end
    local _____5355_4F4D_53E5_67C4ID = GetHandleId(unit)
    if _____5237_602A_8BB0_5F55_8868:has(_____5355_4F4D_53E5_67C4ID) then
        return
    end
    local _____5237_602A_5355_4F4D_7EC4 = _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    if not IsUnitInGroup(unit, _____5237_602A_5355_4F4D_7EC4) then
        GroupAddUnit(_____5237_602A_5355_4F4D_7EC4, unit)
    end
    _____521D_59CB_5316_5355_4E2A_5237_602A_5355_4F4D(unit)
end
function _____83B7_53D6_5237_602A_533A_57DF()
    local _____914D_7F6E_533A_57DF = _____83B7_53D6_77E9_5F62_533A_57DF(_____5237_602A_533A_57DF_540D_79F0)
    if _____914D_7F6E_533A_57DF ~= nil and _____914D_7F6E_533A_57DF ~= 0 then
        return _____914D_7F6E_533A_57DF
    end
    local _____4E16_754C_8FB9_754C = GetWorldBounds()
    if _____4E16_754C_8FB9_754C ~= nil and _____4E16_754C_8FB9_754C ~= 0 then
        return _____4E16_754C_8FB9_754C
    end
    return nil
end
function _____5904_7406_5237_602A_533A_57DF_679A_4E3E_5355_4F4D(unit)
    _____767B_8BB0_5237_602A_5355_4F4D(unit)
end
function _____5B8C_6210_521D_59CB_5237_602A_5355_4F4D_6536_96C6()
    if _____521D_59CB_6536_96C6_56DE_8C03ID ~= nil then
        removePeriodicCallback(_____521D_59CB_6536_96C6_56DE_8C03ID)
        _____521D_59CB_6536_96C6_56DE_8C03ID = nil
    end
    if _____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4 ~= nil and _____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4 ~= 0 then
        DestroyGroup(_____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4)
        _____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4 = nil
    end
    if _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    registerDeathListener(____on_5237_602A_5355_4F4D_6B7B_4EA1)
end
function ____on_521D_59CB_5237_602A_5355_4F4D_6536_96C6_6279_6B21()
    local _____4E34_65F6_7EC4 = _____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4
    if _____4E34_65F6_7EC4 == nil or _____4E34_65F6_7EC4 == 0 then
        _____5B8C_6210_521D_59CB_5237_602A_5355_4F4D_6536_96C6()
        return
    end
    local _____672C_6279_5904_7406_6570_91CF = 0
    while _____672C_6279_5904_7406_6570_91CF < _____521D_59CB_6536_96C6_6BCF_6279_5355_4F4D_6570_91CF do
        local _____5355_4F4D = FirstOfGroup(_____4E34_65F6_7EC4)
        if _____5355_4F4D == nil or _____5355_4F4D == 0 then
            break
        end
        GroupRemoveUnit(_____4E34_65F6_7EC4, _____5355_4F4D)
        _____5904_7406_5237_602A_533A_57DF_679A_4E3E_5355_4F4D(_____5355_4F4D)
        _____672C_6279_5904_7406_6570_91CF = _____672C_6279_5904_7406_6570_91CF + 1
    end
    local _____5269_4F59_5355_4F4D = FirstOfGroup(_____4E34_65F6_7EC4)
    if _____5269_4F59_5355_4F4D == nil or _____5269_4F59_5355_4F4D == 0 then
        _____5B8C_6210_521D_59CB_5237_602A_5355_4F4D_6536_96C6()
    end
end
function _____6536_96C6_521D_59CB_5237_602A_5355_4F4D()
    local _____5237_602A_5355_4F4D_7EC4 = _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    _____6E05_7A7A_5355_4F4D_7EC4(_____5237_602A_5355_4F4D_7EC4)
    _____5237_602A_8BB0_5F55_8868:clear()
    _____521D_59CB_5316_56FA_5B9A_5C5E_6027_914D_7F6E_7F13_5B58()
    local _____5237_602A_533A_57DF = _____83B7_53D6_5237_602A_533A_57DF()
    if _____5237_602A_533A_57DF == nil or _____5237_602A_533A_57DF == 0 then
        _____5B8C_6210_521D_59CB_5237_602A_5355_4F4D_6536_96C6()
        return
    end
    _____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4 = CreateGroup()
    GroupEnumUnitsInRect(_____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4, _____5237_602A_533A_57DF, nil)
    _____521D_59CB_6536_96C6_56DE_8C03ID = addPeriodicCallback(_____521D_59CB_6536_96C6_95F4_9694_6BEB_79D2, ____on_521D_59CB_5237_602A_5355_4F4D_6536_96C6_6279_6B21)
end
function _____5FEB_7167_6B7B_4EA1_602A_7269_5C5E_6027(unit)
    local result = {}
    for ____, _____5C5E_6027_540D in ipairs(_____9700_8981_590D_5236_7684_5C5E_6027_952E_5217_8868) do
        local value = _____8BFB_53D6_602A_7269_5C5E_6027(unit, _____5C5E_6027_540D)
        if type(value) == "number" then
            result[_____5C5E_6027_540D] = value
        end
    end
    return result
end
function _____5E94_7528_5C5E_6027_5FEB_7167_5230_65B0_5355_4F4D(unit, _____5C5E_6027_5FEB_7167)
    for ____, _____5C5E_6027_540D in ipairs(_____9700_8981_590D_5236_7684_5C5E_6027_952E_5217_8868) do
        local value = _____5C5E_6027_5FEB_7167[_____5C5E_6027_540D]
        if type(value) == "number" then
            _____5199_5165_602A_7269_5C5E_6027(unit, _____5C5E_6027_540D, value)
        end
    end
end
function ____on_602A_7269_5237_65B0_8BA1_65F6_5668_5230_671F()
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
function _____5B89_6392_602A_7269_5EF6_8FDF_5237_65B0(dyingUnit, record)
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
function ____on_5237_602A_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local _____5237_602A_5355_4F4D_7EC4 = _____83B7_53D6_5237_602A_5355_4F4D_7EC4()
    if not IsUnitInGroup(dyingUnit, _____5237_602A_5355_4F4D_7EC4) then
        return
    end
    local record = _____5237_602A_8BB0_5F55_8868:get(GetHandleId(dyingUnit))
    if record == nil then
        return
    end
    _____5B89_6392_602A_7269_5EF6_8FDF_5237_65B0(dyingUnit, record)
end
____exports["初始化怪物刷新系统"] = function()
    if _____5DF2_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF then
        return
    end
    _____5DF2_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF = true
    _____6536_96C6_521D_59CB_5237_602A_5355_4F4D()
end
jass = require("jass.common")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
_____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
_____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
YDUserDataHasSafe = ____require_result_3.YDUserDataHasSafe
YDUserDataClearTableSafe = ____require_result_3.YDUserDataClearTableSafe
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
registerDeathListener = ____require_result_4.registerDeathListener
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_5.addDelayedCallback
addPeriodicCallback = ____require_result_5.addPeriodicCallback
removePeriodicCallback = ____require_result_5.removePeriodicCallback
local ____require_result_6 = require("lib.扩展函数.BJ函数.07．杂项")
GetRandomDirectionDeg = ____require_result_6.GetRandomDirectionDeg
GroupAddUnit = jass.GroupAddUnit
GroupRemoveUnit = jass.GroupRemoveUnit
FirstOfGroup = jass.FirstOfGroup
CreateGroup = jass.CreateGroup
DestroyGroup = jass.DestroyGroup
GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect
GetWorldBounds = jass.GetWorldBounds
GetHandleId = jass.GetHandleId
GetOwningPlayer = jass.GetOwningPlayer
GetPlayerId = jass.GetPlayerId
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
IsUnitInGroup = jass.IsUnitInGroup
IsUnitType = jass.IsUnitType
IsUnitRace = jass.IsUnitRace
Player = jass.Player
RemoveUnit = jass.RemoveUnit
_____5237_602A_8BB0_5F55_8868 = __TS__New(Map)
_____5EF6_8FDF_5237_65B0_4E0A_4E0B_6587_961F_5217 = {}
_____5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408 = __TS__New(Set)
_____56FA_5B9A_5C5E_6027_914D_7F6E_7F13_5B58 = __TS__New(Map)
_____7279_6B8A_7CBE_82F1_66B4_51FB_8986_5199_8FD0_884C_65F6_914D_7F6E_8868 = {}
_____521D_59CB_6536_96C6_6BCF_6279_5355_4F4D_6570_91CF = 10
_____521D_59CB_6536_96C6_95F4_9694_6BEB_79D2 = 10
_____5DF2_521D_59CB_5316_602A_7269_5237_65B0_7CFB_7EDF = false
_____5DF2_521D_59CB_5316_5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408 = false
_____56FA_5B9A_5C5E_6027_914D_7F6E_5DF2_521D_59CB_5316 = false
_____521D_59CB_6536_96C6_4E34_65F6_5355_4F4D_7EC4 = nil
_____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
--- 供任务等运行时入口把新建敌人纳入同一套死亡刷新流程。
____exports["登记动态刷怪单位"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    ____exports["初始化怪物刷新系统"]()
    _____786E_4FDD_5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408_5DF2_521D_59CB_5316()
    local _____5355_4F4D_7C7B_578BID = GetUnitTypeId(unit)
    if _____5355_4F4D_7C7B_578BID <= 0 then
        return false
    end
    _____5141_8BB8_5237_602A_5355_4F4D_7C7B_578BID_96C6_5408:add(_____5355_4F4D_7C7B_578BID)
    _____767B_8BB0_5237_602A_5355_4F4D(unit)
    return _____5237_602A_8BB0_5F55_8868:has(GetHandleId(unit))
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
return ____exports
