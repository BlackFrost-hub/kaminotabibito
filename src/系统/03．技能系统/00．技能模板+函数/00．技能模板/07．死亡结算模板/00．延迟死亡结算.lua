local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____6784_5EFA_4E0A_4E0B_6587, _____6765_6E90_4ECD_6709_6548, _____505C_6B62_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_8BB0_5F55, ____on_5EF6_8FDF_6B7B_4EA1_7ED3_7B97Tick, removePeriodicCallback, getServerTime, IsUnitType, UNIT_TYPE_DEAD, _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217
____exports["单位是否死亡或无效"] = function(unit)
    return unit == nil or unit == 0 or IsUnitType(unit, UNIT_TYPE_DEAD) == true
end
function _____6784_5EFA_4E0A_4E0B_6587(_____8BB0_5F55, now)
    return {key = _____8BB0_5F55.key, ["来源单位"] = _____8BB0_5F55["来源单位"], ["目标单位"] = _____8BB0_5F55["目标单位"], ["当前时间毫秒"] = now}
end
function _____6765_6E90_4ECD_6709_6548(_____8BB0_5F55, now)
    if ____exports["单位是否死亡或无效"](_____8BB0_5F55["来源单位"]) then
        return false
    end
    if _____8BB0_5F55["来源有效性检查"] == nil then
        return true
    end
    return _____8BB0_5F55["来源有效性检查"](_____6784_5EFA_4E0A_4E0B_6587(_____8BB0_5F55, now))
end
function _____505C_6B62_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_8BB0_5F55(_____8BB0_5F55)
    if _____8BB0_5F55["驱动ID"] ~= 0 then
        removePeriodicCallback(_____8BB0_5F55["驱动ID"])
        _____8BB0_5F55["驱动ID"] = 0
    end
    local index = __TS__ArrayIndexOf(_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217, _____8BB0_5F55)
    if index >= 0 then
        __TS__ArraySplice(_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217, index, 1)
    end
end
function ____on_5EF6_8FDF_6B7B_4EA1_7ED3_7B97Tick(variable)
    local _____8BB0_5F55 = variable
    if _____8BB0_5F55 == nil or _____8BB0_5F55["驱动ID"] == 0 then
        return
    end
    local now = getServerTime()
    if not _____6765_6E90_4ECD_6709_6548(_____8BB0_5F55, now) then
        _____505C_6B62_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_8BB0_5F55(_____8BB0_5F55)
        return
    end
    if ____exports["单位是否死亡或无效"](_____8BB0_5F55["目标单位"]) then
        _____8BB0_5F55["on目标死亡"](_____6784_5EFA_4E0A_4E0B_6587(_____8BB0_5F55, now))
        _____505C_6B62_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_8BB0_5F55(_____8BB0_5F55)
        return
    end
    if now >= _____8BB0_5F55["到期时间"] then
        _____505C_6B62_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_8BB0_5F55(_____8BB0_5F55)
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local GetHandleId = jass.GetHandleId
IsUnitType = jass.IsUnitType
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____751F_6210_5EF6_8FDF_6B7B_4EA1_7ED3_7B97key(_____53C2_6570)
    local _____6765_6E90ID = _____53D6_5355_4F4D_53E5_67C4ID(_____53C2_6570["来源单位"])
    local _____76EE_6807ID = _____53D6_5355_4F4D_53E5_67C4ID(_____53C2_6570["目标单位"])
    if _____6765_6E90ID == 0 or _____76EE_6807ID == 0 then
        return ""
    end
    return (((_____53C2_6570["key前缀"] .. ":") .. tostring(_____6765_6E90ID)) .. ":") .. tostring(_____76EE_6807ID)
end
local function _____66F4_65B0_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8(_____8BB0_5F55, _____68C0_67E5_95F4_9694_6BEB_79D2)
    local interval = _____68C0_67E5_95F4_9694_6BEB_79D2 > 0 and _____68C0_67E5_95F4_9694_6BEB_79D2 or 100
    if _____8BB0_5F55["驱动ID"] ~= 0 and _____8BB0_5F55["检查间隔毫秒"] == interval then
        return
    end
    if _____8BB0_5F55["驱动ID"] ~= 0 then
        removePeriodicCallback(_____8BB0_5F55["驱动ID"])
    end
    _____8BB0_5F55["检查间隔毫秒"] = interval
    _____8BB0_5F55["驱动ID"] = addPeriodicCallback(interval, ____on_5EF6_8FDF_6B7B_4EA1_7ED3_7B97Tick, _____8BB0_5F55)
end
____exports["记录或刷新延迟死亡结算"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["on目标死亡"] == nil then
        return
    end
    if _____53C2_6570["延迟毫秒"] <= 0 then
        return
    end
    if ____exports["单位是否死亡或无效"](_____53C2_6570["来源单位"]) or ____exports["单位是否死亡或无效"](_____53C2_6570["目标单位"]) then
        return
    end
    local key = _____751F_6210_5EF6_8FDF_6B7B_4EA1_7ED3_7B97key(_____53C2_6570)
    if key == "" then
        return
    end
    local _____5230_671F_65F6_95F4 = getServerTime() + _____53C2_6570["延迟毫秒"]
    do
        local i = 0
        while i < #_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217 do
            do
                local _____8BB0_5F55 = _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217[i + 1]
                if _____8BB0_5F55 == nil or _____8BB0_5F55.key ~= key then
                    goto __continue28
                end
                _____8BB0_5F55["到期时间"] = _____5230_671F_65F6_95F4
                _____8BB0_5F55["来源有效性检查"] = _____53C2_6570["来源有效性检查"]
                _____8BB0_5F55["on目标死亡"] = _____53C2_6570["on目标死亡"]
                if _____53C2_6570["检查间隔毫秒"] ~= nil then
                    _____66F4_65B0_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8(_____8BB0_5F55, _____53C2_6570["检查间隔毫秒"])
                end
                return
            end
            ::__continue28::
            i = i + 1
        end
    end
    local _____8BB0_5F55 = {
        key = key,
        ["来源单位"] = _____53C2_6570["来源单位"],
        ["目标单位"] = _____53C2_6570["目标单位"],
        ["到期时间"] = _____5230_671F_65F6_95F4,
        ["检查间隔毫秒"] = 0,
        ["驱动ID"] = 0,
        ["来源有效性检查"] = _____53C2_6570["来源有效性检查"],
        ["on目标死亡"] = _____53C2_6570["on目标死亡"]
    }
    _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217[#_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217 + 1] = _____8BB0_5F55
    _____66F4_65B0_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8(_____8BB0_5F55, _____53C2_6570["检查间隔毫秒"] or 100)
end
return ____exports
