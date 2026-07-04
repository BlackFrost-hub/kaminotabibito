local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_88C5_5907_51B7_5374_663E_793A_6301_6709_8005, _____8BB0_5F55_88C5_5907_51B7_5374_663E_793A_6301_6709_8005, GetHandleId, _____88C5_5907_51B7_5374_663E_793A_6301_6709_8005_8868
function _____53D6_88C5_5907_51B7_5374_663E_793A_6301_6709_8005(_____88C5_5907_540D)
    local holders = _____88C5_5907_51B7_5374_663E_793A_6301_6709_8005_8868[_____88C5_5907_540D]
    if holders == nil then
        holders = {}
        _____88C5_5907_51B7_5374_663E_793A_6301_6709_8005_8868[_____88C5_5907_540D] = holders
    end
    return holders
end
function _____8BB0_5F55_88C5_5907_51B7_5374_663E_793A_6301_6709_8005(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 or _____88C5_5907_540D == "" then
        return
    end
    _____53D6_88C5_5907_51B7_5374_663E_793A_6301_6709_8005(_____88C5_5907_540D)[GetHandleId(unit)] = unit
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_2.UnitHasItemOfTypeBJ
local GetItemOfTypeFromUnitBJ = ____require_result_2.GetItemOfTypeFromUnitBJ
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____require_result_4["装备触发概率通过"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
local _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03 = ____require_result_5["监听指定物品获取丢弃"]
local ____require_result_6 = require("系统.09．表现系统.01．UI工具.07．物品栏冷却显示")
local _____663E_793A_7269_54C1_680F_7269_54C1_51B7_5374 = ____require_result_6["显示物品栏物品冷却"]
local _____8BBE_7F6E_7269_54C1_680F_7269_54C1_51B7_5374 = ____require_result_6["设置物品栏物品冷却"]
local platformAbilityAction = require("平台扩展API动作")
GetHandleId = jass.GetHandleId
local _____8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = platformAbilityAction["技能_设置技能冷却时间"]
local _____88C5_5907_7269_54C1ID_7F13_5B58 = {}
local _____88C5_5907_51B7_5374_8868 = {}
_____88C5_5907_51B7_5374_663E_793A_6301_6709_8005_8868 = {}
local _____88C5_5907_51B7_5374_663E_793A_76D1_542C_5DF2_6CE8_518C = {}
local _____88C5_5907_7269_54C1_663E_793A_51B7_5374_952E_8868 = {}
____exports["取装备物品ID"] = function(_____88C5_5907_540D)
    local cached = _____88C5_5907_7269_54C1ID_7F13_5B58[_____88C5_5907_540D]
    if cached ~= nil then
        return cached
    end
    local id = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D))
    _____88C5_5907_7269_54C1ID_7F13_5B58[_____88C5_5907_540D] = id
    return id
end
____exports["单位持有装备"] = function(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local itemId = ____exports["取装备物品ID"](_____88C5_5907_540D)
    local _____6301_6709 = itemId ~= 0 and UnitHasItemOfTypeBJ(unit, itemId) == true
    if _____6301_6709 then
        _____8BB0_5F55_88C5_5907_51B7_5374_663E_793A_6301_6709_8005(unit, _____88C5_5907_540D)
    end
    return _____6301_6709
end
____exports["获取单位装备物品"] = function(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 then
        return nil
    end
    local itemId = ____exports["取装备物品ID"](_____88C5_5907_540D)
    if itemId == 0 then
        return nil
    end
    return GetItemOfTypeFromUnitBJ(unit, itemId)
end
____exports["取装备冷却键"] = function(unit, tag, _____524D_7F00)
    if _____524D_7F00 == nil then
        _____524D_7F00 = "装备"
    end
    if unit == nil or unit == 0 or tag == "" then
        return ""
    end
    return (((_____524D_7F00 .. ":") .. tag) .. ":") .. tostring(GetHandleId(unit))
end
____exports["取单位对单位冷却键"] = function(source, target, tag, _____524D_7F00)
    if _____524D_7F00 == nil then
        _____524D_7F00 = "装备单位对单位"
    end
    if source == nil or source == 0 or target == nil or target == 0 or tag == "" then
        return ""
    end
    return (((((_____524D_7F00 .. ":") .. tag) .. ":") .. tostring(GetHandleId(source))) .. ":") .. tostring(GetHandleId(target))
end
____exports["装备冷却就绪"] = function(key)
    return key ~= "" and (_____88C5_5907_51B7_5374_8868[key] or 0) <= getServerTime()
end
____exports["装备冷却中"] = function(key)
    return key == "" or (_____88C5_5907_51B7_5374_8868[key] or 0) > getServerTime()
end
____exports["取装备冷却剩余毫秒"] = function(key)
    if key == "" then
        return 0
    end
    local remaining = (_____88C5_5907_51B7_5374_8868[key] or 0) - getServerTime()
    return remaining > 0 and remaining or 0
end
local function _____53D6_51B7_5374_952E_96C6_5408_6700_5927_5269_4F59_6BEB_79D2(_____51B7_5374_952E)
    if _____51B7_5374_952E == nil then
        return 0
    end
    if type(_____51B7_5374_952E) == "string" then
        return ____exports["取装备冷却剩余毫秒"](_____51B7_5374_952E)
    end
    local maxRemaining = 0
    do
        local i = 0
        while i < #_____51B7_5374_952E do
            local remaining = ____exports["取装备冷却剩余毫秒"](_____51B7_5374_952E[i + 1])
            if remaining > maxRemaining then
                maxRemaining = remaining
            end
            i = i + 1
        end
    end
    return maxRemaining
end
local function _____5408_5E76_51B7_5374_952E(_____4E3B_51B7_5374_952E, _____76F8_5173_51B7_5374_952E)
    local result = {}
    if _____4E3B_51B7_5374_952E ~= "" then
        result[#result + 1] = _____4E3B_51B7_5374_952E
    end
    if _____76F8_5173_51B7_5374_952E == nil then
        return result
    end
    if type(_____76F8_5173_51B7_5374_952E) == "string" then
        if _____76F8_5173_51B7_5374_952E ~= "" and _____76F8_5173_51B7_5374_952E ~= _____4E3B_51B7_5374_952E then
            result[#result + 1] = _____76F8_5173_51B7_5374_952E
        end
        return result
    end
    do
        local i = 0
        while i < #_____76F8_5173_51B7_5374_952E do
            local key = _____76F8_5173_51B7_5374_952E[i + 1]
            if key ~= "" and key ~= _____4E3B_51B7_5374_952E then
                result[#result + 1] = key
            end
            i = i + 1
        end
    end
    return result
end
local function _____6DFB_52A0_51B7_5374_952E_5230_5217_8868(list, key)
    if key == "" then
        return
    end
    do
        local i = 0
        while i < #list do
            if list[i + 1] == key then
                return
            end
            i = i + 1
        end
    end
    list[#list + 1] = key
end
local function _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(list, _____51B7_5374_952E)
    if _____51B7_5374_952E == nil then
        return
    end
    if type(_____51B7_5374_952E) == "string" then
        _____6DFB_52A0_51B7_5374_952E_5230_5217_8868(list, _____51B7_5374_952E)
        return
    end
    do
        local i = 0
        while i < #_____51B7_5374_952E do
            _____6DFB_52A0_51B7_5374_952E_5230_5217_8868(list, _____51B7_5374_952E[i + 1])
            i = i + 1
        end
    end
end
local function _____53D6_7269_54C1_663E_793A_51B7_5374_952EID(item)
    if item == nil or item == 0 then
        return ""
    end
    return tostring(GetHandleId(item))
end
local function _____521B_5EFA_7269_54C1_663E_793A_51B7_5374_952E_8BB0_5F55()
    return {["独有"] = {}, ["公共"] = {}, ["其他"] = {}, ["主动"] = {}}
end
local function _____53D6_7269_54C1_663E_793A_51B7_5374_952E_8BB0_5F55(item)
    local itemKey = _____53D6_7269_54C1_663E_793A_51B7_5374_952EID(item)
    if itemKey == "" then
        return nil
    end
    local record = _____88C5_5907_7269_54C1_663E_793A_51B7_5374_952E_8868[itemKey]
    if record == nil then
        record = _____521B_5EFA_7269_54C1_663E_793A_51B7_5374_952E_8BB0_5F55()
        _____88C5_5907_7269_54C1_663E_793A_51B7_5374_952E_8868[itemKey] = record
    end
    return record
end
local function _____53D6_7269_54C1_663E_793A_51B7_5374_952E_5217_8868(record, _____7C7B_578B)
    if _____7C7B_578B == "独有" then
        return record["独有"]
    end
    if _____7C7B_578B == "公共" then
        return record["公共"]
    end
    if _____7C7B_578B == "主动" then
        return record["主动"]
    end
    return record["其他"]
end
local function _____8BB0_5F55_7269_54C1_663E_793A_51B7_5374_952E(item, _____51B7_5374_952E, _____7C7B_578B)
    if _____7C7B_578B == nil then
        _____7C7B_578B = "其他"
    end
    local record = _____53D6_7269_54C1_663E_793A_51B7_5374_952E_8BB0_5F55(item)
    if record == nil then
        return
    end
    _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(
        _____53D6_7269_54C1_663E_793A_51B7_5374_952E_5217_8868(record, _____7C7B_578B),
        _____51B7_5374_952E
    )
end
local function _____5408_5E76_7269_54C1_5168_90E8_5DF2_77E5_51B7_5374_952E(item, _____51B7_5374_952E)
    local result = {}
    _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, _____51B7_5374_952E)
    local itemKey = _____53D6_7269_54C1_663E_793A_51B7_5374_952EID(item)
    local ____temp_7
    if itemKey ~= "" then
        ____temp_7 = _____88C5_5907_7269_54C1_663E_793A_51B7_5374_952E_8868[itemKey]
    else
        ____temp_7 = nil
    end
    local record = ____temp_7
    if record ~= nil then
        _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, record["独有"])
        _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, record["公共"])
        _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, record["其他"])
        _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, record["主动"])
    end
    return result
end
____exports["取装备显示冷却剩余"] = function(hero, item, _____51B7_5374_952E)
    if hero == nil or hero == 0 or item == nil or item == 0 then
        return 0
    end
    return _____53D6_51B7_5374_952E_96C6_5408_6700_5927_5269_4F59_6BEB_79D2(_____5408_5E76_7269_54C1_5168_90E8_5DF2_77E5_51B7_5374_952E(item, _____51B7_5374_952E))
end
local function _____79FB_9664_88C5_5907_51B7_5374_663E_793A_6301_6709_8005(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 or _____88C5_5907_540D == "" then
        return
    end
    local holders = _____88C5_5907_51B7_5374_663E_793A_6301_6709_8005_8868[_____88C5_5907_540D]
    if holders == nil then
        return
    end
    __TS__Delete(
        holders,
        GetHandleId(unit)
    )
end
____exports["注册装备冷却显示持有者追踪"] = function(_____88C5_5907_540D)
    if _____88C5_5907_540D == "" or _____88C5_5907_51B7_5374_663E_793A_76D1_542C_5DF2_6CE8_518C[_____88C5_5907_540D] == true then
        return
    end
    local itemId = ____exports["取装备物品ID"](_____88C5_5907_540D)
    if itemId == 0 then
        return
    end
    _____88C5_5907_51B7_5374_663E_793A_76D1_542C_5DF2_6CE8_518C[_____88C5_5907_540D] = true
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(
        itemId,
        function(unit)
            _____8BB0_5F55_88C5_5907_51B7_5374_663E_793A_6301_6709_8005(unit, _____88C5_5907_540D)
        end,
        function(unit, _item, currentCount)
            if currentCount <= 0 then
                _____79FB_9664_88C5_5907_51B7_5374_663E_793A_6301_6709_8005(unit, _____88C5_5907_540D)
            end
        end
    )
end
____exports["显示单位装备冷却"] = function(unit, _____88C5_5907_540D, _____51B7_5374_952E, _____7C7B_578B)
    if _____7C7B_578B == nil then
        _____7C7B_578B = "其他"
    end
    if unit == nil or unit == 0 or _____88C5_5907_540D == "" then
        return
    end
    local item = ____exports["获取单位装备物品"](unit, _____88C5_5907_540D)
    if item == nil or item == 0 then
        return
    end
    _____8BB0_5F55_7269_54C1_663E_793A_51B7_5374_952E(item, _____51B7_5374_952E, _____7C7B_578B)
    local remaining = ____exports["取装备显示冷却剩余"](unit, item, _____51B7_5374_952E)
    if remaining > 0 then
        _____663E_793A_7269_54C1_680F_7269_54C1_51B7_5374(unit, item, remaining)
    end
end
____exports["显示所有持有者装备冷却"] = function(_____88C5_5907_540D, _____51B7_5374_952E, _____7C7B_578B)
    if _____7C7B_578B == nil then
        _____7C7B_578B = "公共"
    end
    if _____88C5_5907_540D == "" then
        return
    end
    ____exports["注册装备冷却显示持有者追踪"](_____88C5_5907_540D)
    local holders = _____88C5_5907_51B7_5374_663E_793A_6301_6709_8005_8868[_____88C5_5907_540D]
    if holders == nil then
        return
    end
    for id in pairs(holders) do
        ____exports["显示单位装备冷却"](holders[id], _____88C5_5907_540D, _____51B7_5374_952E, _____7C7B_578B)
    end
end
____exports["进入装备冷却"] = function(key, _____79D2_6570)
    if key == "" then
        return
    end
    _____88C5_5907_51B7_5374_8868[key] = getServerTime() + _____79D2_6570 * 1000
end
____exports["进入装备冷却并显示"] = function(key, _____79D2_6570, unit, _____88C5_5907_540D, _____76F8_5173_51B7_5374_952E)
    ____exports["进入装备冷却"](key, _____79D2_6570)
    if key == "" or not (_____79D2_6570 > 0) then
        return
    end
    ____exports["显示单位装备冷却"](
        unit,
        _____88C5_5907_540D,
        _____5408_5E76_51B7_5374_952E(key, _____76F8_5173_51B7_5374_952E),
        "独有"
    )
end
____exports["进入装备公共冷却并显示"] = function(key, _____79D2_6570, _____88C5_5907_540D, _____76F8_5173_51B7_5374_952E)
    ____exports["进入装备冷却"](key, _____79D2_6570)
    if key == "" or not (_____79D2_6570 > 0) then
        return
    end
    ____exports["显示所有持有者装备冷却"](
        _____88C5_5907_540D,
        _____5408_5E76_51B7_5374_952E(key, _____76F8_5173_51B7_5374_952E),
        "公共"
    )
end
____exports["设置装备冷却"] = function(key, _____79D2_6570)
    if key == "" then
        return
    end
    if not (_____79D2_6570 > 0) then
        __TS__Delete(_____88C5_5907_51B7_5374_8868, key)
        return
    end
    _____88C5_5907_51B7_5374_8868[key] = getServerTime() + _____79D2_6570 * 1000
end
____exports["刷新装备冷却"] = function(key)
    ____exports["设置装备冷却"](key, 0)
end
local function _____8BBE_7F6E_88C5_5907_51B7_5374_6BEB_79D2(key, _____6BEB_79D2)
    ____exports["设置装备冷却"](key, _____6BEB_79D2 / 1000)
end
local function _____53D6_8BBE_7F6E_7269_54C1CD_6BEB_79D2(_____53C2_6570)
    if _____53C2_6570["毫秒"] ~= nil then
        return _____53C2_6570["毫秒"]
    end
    if _____53C2_6570["秒数"] ~= nil then
        return _____53C2_6570["秒数"] * 1000
    end
    return 0
end
local function _____53D6_4E3B_52A8_6700_5927_51B7_5374_79D2_6570(_____53C2_6570, _____5F53_524D_51B7_5374_79D2_6570)
    if _____53C2_6570["主动最大冷却毫秒"] ~= nil and _____53C2_6570["主动最大冷却毫秒"] > 0 then
        return _____53C2_6570["主动最大冷却毫秒"] / 1000
    end
    if _____53C2_6570["主动最大冷却秒数"] ~= nil and _____53C2_6570["主动最大冷却秒数"] > 0 then
        return _____53C2_6570["主动最大冷却秒数"]
    end
    if _____5F53_524D_51B7_5374_79D2_6570 > 0 then
        return _____5F53_524D_51B7_5374_79D2_6570
    end
    return 1
end
local function _____83B7_53D6_53C2_6570_7269_54C1(_____53C2_6570)
    if _____53C2_6570.item ~= nil and _____53C2_6570.item ~= 0 then
        return _____53C2_6570.item
    end
    if _____53C2_6570["装备名"] == nil or _____53C2_6570["装备名"] == "" then
        return nil
    end
    return ____exports["获取单位装备物品"](_____53C2_6570.unit, _____53C2_6570["装备名"])
end
local function _____8303_56F4_5305_542B_4E3B_52A8(_____8303_56F4)
    return _____8303_56F4 == "全部" or _____8303_56F4 == "主动"
end
local function _____8303_56F4_5305_542B_72EC_6709(_____8303_56F4)
    return _____8303_56F4 == "全部" or _____8303_56F4 == "被动" or _____8303_56F4 == "独有"
end
local function _____8303_56F4_5305_542B_516C_5171(_____8303_56F4)
    return _____8303_56F4 == "全部" or _____8303_56F4 == "被动" or _____8303_56F4 == "公共"
end
local function _____8303_56F4_5305_542B_5176_4ED6(_____8303_56F4)
    return _____8303_56F4 == "全部" or _____8303_56F4 == "被动" or _____8303_56F4 == "其他"
end
local function _____53D6_7269_54C1_4E3B_52A8_51B7_5374_952E(item)
    local itemKey = _____53D6_7269_54C1_663E_793A_51B7_5374_952EID(item)
    return itemKey == "" and "" or "物品主动:" .. itemKey
end
local function _____89C4_8303_5316_4E3B_52A8_6280_80FDID_5217_8868(_____4E3B_52A8_6280_80FDID)
    local result = {}
    if _____4E3B_52A8_6280_80FDID == nil then
        return result
    end
    if type(_____4E3B_52A8_6280_80FDID) == "number" then
        if _____4E3B_52A8_6280_80FDID ~= 0 then
            result[#result + 1] = _____4E3B_52A8_6280_80FDID
        end
        return result
    end
    if type(_____4E3B_52A8_6280_80FDID) == "string" then
        local id = stringToFourCCSafe(_____4E3B_52A8_6280_80FDID)
        if id ~= 0 then
            result[#result + 1] = id
        end
        return result
    end
    do
        local i = 0
        while i < #_____4E3B_52A8_6280_80FDID do
            local raw = _____4E3B_52A8_6280_80FDID[i + 1]
            local id = type(raw) == "number" and raw or stringToFourCCSafe(raw)
            if id ~= 0 then
                result[#result + 1] = id
            end
            i = i + 1
        end
    end
    return result
end
local function _____53D6_8303_56F4_5185_7269_54C1_51B7_5374_952E(item, _____8303_56F4)
    local result = {}
    local record = _____53D6_7269_54C1_663E_793A_51B7_5374_952E_8BB0_5F55(item)
    if record == nil then
        return result
    end
    if _____8303_56F4_5305_542B_72EC_6709(_____8303_56F4) then
        _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, record["独有"])
    end
    if _____8303_56F4_5305_542B_516C_5171(_____8303_56F4) then
        _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, record["公共"])
    end
    if _____8303_56F4_5305_542B_5176_4ED6(_____8303_56F4) then
        _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, record["其他"])
    end
    if _____8303_56F4_5305_542B_4E3B_52A8(_____8303_56F4) then
        _____6DFB_52A0_51B7_5374_952E_96C6_5408_5230_5217_8868(result, record["主动"])
    end
    return result
end
local function _____8BB0_5F55_53C2_6570_51B7_5374_952E(item, _____53C2_6570)
    if _____53C2_6570["独有冷却键"] ~= nil then
        _____8BB0_5F55_7269_54C1_663E_793A_51B7_5374_952E(item, _____53C2_6570["独有冷却键"], "独有")
    end
    if _____53C2_6570["公共冷却键"] ~= nil then
        _____8BB0_5F55_7269_54C1_663E_793A_51B7_5374_952E(item, _____53C2_6570["公共冷却键"], "公共")
    end
    if _____53C2_6570["其他冷却键"] ~= nil then
        _____8BB0_5F55_7269_54C1_663E_793A_51B7_5374_952E(item, _____53C2_6570["其他冷却键"], "其他")
    end
end
local function _____540C_6B65_7269_54C1CD_663E_793A(unit, item)
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    local remaining = _____53D6_51B7_5374_952E_96C6_5408_6700_5927_5269_4F59_6BEB_79D2(_____5408_5E76_7269_54C1_5168_90E8_5DF2_77E5_51B7_5374_952E(item))
    _____8BBE_7F6E_7269_54C1_680F_7269_54C1_51B7_5374(unit, item, remaining)
end
____exports["设置物品CD"] = function(_____53C2_6570)
    local unit = _____53C2_6570.unit
    local item = _____83B7_53D6_53C2_6570_7269_54C1(_____53C2_6570)
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return 0
    end
    local _____8303_56F4 = _____53C2_6570["范围"] or "全部"
    local durationMs = _____53D6_8BBE_7F6E_7269_54C1CD_6BEB_79D2(_____53C2_6570)
    local durationSec = durationMs > 0 and durationMs / 1000 or 0
    local count = 0
    _____8BB0_5F55_53C2_6570_51B7_5374_952E(item, _____53C2_6570)
    if _____8303_56F4_5305_542B_4E3B_52A8(_____8303_56F4) then
        local activeMaxSec = _____53D6_4E3B_52A8_6700_5927_51B7_5374_79D2_6570(_____53C2_6570, durationSec)
        local activeKey = _____53D6_7269_54C1_4E3B_52A8_51B7_5374_952E(item)
        if activeKey ~= "" then
            _____8BB0_5F55_7269_54C1_663E_793A_51B7_5374_952E(item, activeKey, "主动")
        end
        local abilityIds = _____89C4_8303_5316_4E3B_52A8_6280_80FDID_5217_8868(_____53C2_6570["主动技能ID"])
        do
            local i = 0
            while i < #abilityIds do
                if _____8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(unit, abilityIds[i + 1], durationSec, activeMaxSec) then
                    count = count + 1
                end
                i = i + 1
            end
        end
    end
    local keys = _____53D6_8303_56F4_5185_7269_54C1_51B7_5374_952E(item, _____8303_56F4)
    do
        local i = 0
        while i < #keys do
            _____8BBE_7F6E_88C5_5907_51B7_5374_6BEB_79D2(keys[i + 1], durationMs)
            count = count + 1
            i = i + 1
        end
    end
    if _____53C2_6570["同步UI"] ~= false then
        _____540C_6B65_7269_54C1CD_663E_793A(unit, item)
    end
    return count
end
____exports["刷新物品CD"] = function(_____53C2_6570)
    local oldMs = _____53C2_6570["毫秒"]
    local oldSec = _____53C2_6570["秒数"]
    _____53C2_6570["毫秒"] = 0
    _____53C2_6570["秒数"] = nil
    local result = ____exports["设置物品CD"](_____53C2_6570)
    _____53C2_6570["毫秒"] = oldMs
    _____53C2_6570["秒数"] = oldSec
    return result
end
____exports["设置物品冷却"] = function(_____53C2_6570)
    return ____exports["设置物品CD"](_____53C2_6570)
end
____exports["刷新物品冷却"] = function(_____53C2_6570)
    return ____exports["刷新物品CD"](_____53C2_6570)
end
____exports["装备概率通过"] = function(unit, chance)
    return chance >= 1 or chance > 0 and _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(chance, unit) == true
end
____exports["取第二章后段Boss战利品ID"] = function(_____88C5_5907_540D)
    return ____exports["取装备物品ID"](_____88C5_5907_540D)
end
____exports["单位持有第二章后段Boss战利品"] = function(unit, _____88C5_5907_540D)
    return ____exports["单位持有装备"](unit, _____88C5_5907_540D)
end
____exports["取冷却键"] = function(unit, tag)
    return ____exports["取装备冷却键"](unit, tag, "第二章后段Boss战利品")
end
____exports["冷却就绪"] = function(key)
    return ____exports["装备冷却就绪"](key)
end
____exports["进入冷却"] = function(key, _____79D2_6570)
    ____exports["进入装备冷却"](key, _____79D2_6570)
end
____exports["进入冷却并显示"] = function(key, _____79D2_6570, unit, _____88C5_5907_540D, _____76F8_5173_51B7_5374_952E)
    ____exports["进入装备冷却并显示"](
        key,
        _____79D2_6570,
        unit,
        _____88C5_5907_540D,
        _____76F8_5173_51B7_5374_952E
    )
end
____exports["概率通过"] = function(unit, chance)
    return ____exports["装备概率通过"](unit, chance)
end
____exports["监听装备丢弃清理"] = function(_____88C5_5907_540D, _____6E05_7406_56DE_8C03)
    local itemId = ____exports["取装备物品ID"](_____88C5_5907_540D)
    if itemId == 0 then
        return
    end
    _____76D1_542C_6307_5B9A_7269_54C1_83B7_53D6_4E22_5F03(
        itemId,
        nil,
        function(unit)
            _____6E05_7406_56DE_8C03(unit)
        end
    )
end
return ____exports
