local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217 = {}
local _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8ID = 0
local _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_68C0_67E5_95F4_9694_6BEB_79D2 = 100
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["单位是否死亡或无效"] = function(unit)
    return unit == nil or unit == 0 or IsUnitType(unit, UNIT_TYPE_DEAD) == true
end
local function _____751F_6210_5EF6_8FDF_6B7B_4EA1_7ED3_7B97key(_____53C2_6570)
    local _____6765_6E90ID = _____53D6_5355_4F4D_53E5_67C4ID(_____53C2_6570["来源单位"])
    local _____76EE_6807ID = _____53D6_5355_4F4D_53E5_67C4ID(_____53C2_6570["目标单位"])
    if _____6765_6E90ID == 0 or _____76EE_6807ID == 0 then
        return ""
    end
    return (((_____53C2_6570["key前缀"] .. ":") .. tostring(_____6765_6E90ID)) .. ":") .. tostring(_____76EE_6807ID)
end
local function _____6784_5EFA_4E0A_4E0B_6587(_____8BB0_5F55, now)
    return {key = _____8BB0_5F55.key, ["来源单位"] = _____8BB0_5F55["来源单位"], ["目标单位"] = _____8BB0_5F55["目标单位"], ["当前时间毫秒"] = now}
end
local function _____6765_6E90_4ECD_6709_6548(_____8BB0_5F55, now)
    if ____exports["单位是否死亡或无效"](_____8BB0_5F55["来源单位"]) then
        return false
    end
    if _____8BB0_5F55["来源有效性检查"] == nil then
        return true
    end
    return _____8BB0_5F55["来源有效性检查"](_____6784_5EFA_4E0A_4E0B_6587(_____8BB0_5F55, now))
end
local function ____on_5EF6_8FDF_6B7B_4EA1_7ED3_7B97Tick()
    local now = getServerTime()
    do
        local i = #_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217 - 1
        while i >= 0 do
            do
                local _____8BB0_5F55 = _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217[i + 1]
                if _____8BB0_5F55 == nil then
                    __TS__ArraySplice(_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217, i, 1)
                    goto __continue13
                end
                if not _____6765_6E90_4ECD_6709_6548(_____8BB0_5F55, now) then
                    __TS__ArraySplice(_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217, i, 1)
                    goto __continue13
                end
                if ____exports["单位是否死亡或无效"](_____8BB0_5F55["目标单位"]) then
                    _____8BB0_5F55["on目标死亡"](_____6784_5EFA_4E0A_4E0B_6587(_____8BB0_5F55, now))
                    __TS__ArraySplice(_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217, i, 1)
                    goto __continue13
                end
                if now >= _____8BB0_5F55["到期时间"] then
                    __TS__ArraySplice(_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217, i, 1)
                end
            end
            ::__continue13::
            i = i - 1
        end
    end
    if #_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217 <= 0 and _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8ID)
        _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8ID = 0
    end
end
local function _____786E_4FDD_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8(_____68C0_67E5_95F4_9694_6BEB_79D2)
    if _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8ID ~= 0 then
        return
    end
    _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_68C0_67E5_95F4_9694_6BEB_79D2 = _____68C0_67E5_95F4_9694_6BEB_79D2 > 0 and _____68C0_67E5_95F4_9694_6BEB_79D2 or 100
    _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8ID = addPeriodicCallback(_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_68C0_67E5_95F4_9694_6BEB_79D2, ____on_5EF6_8FDF_6B7B_4EA1_7ED3_7B97Tick)
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
                    goto __continue27
                end
                _____8BB0_5F55["到期时间"] = _____5230_671F_65F6_95F4
                _____8BB0_5F55["来源有效性检查"] = _____53C2_6570["来源有效性检查"]
                _____8BB0_5F55["on目标死亡"] = _____53C2_6570["on目标死亡"]
                _____786E_4FDD_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8(_____53C2_6570["检查间隔毫秒"] or _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_68C0_67E5_95F4_9694_6BEB_79D2)
                return
            end
            ::__continue27::
            i = i + 1
        end
    end
    _____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217[#_____5EF6_8FDF_6B7B_4EA1_7ED3_7B97_961F_5217 + 1] = {
        key = key,
        ["来源单位"] = _____53C2_6570["来源单位"],
        ["目标单位"] = _____53C2_6570["目标单位"],
        ["到期时间"] = _____5230_671F_65F6_95F4,
        ["来源有效性检查"] = _____53C2_6570["来源有效性检查"],
        ["on目标死亡"] = _____53C2_6570["on目标死亡"]
    }
    _____786E_4FDD_5EF6_8FDF_6B7B_4EA1_7ED3_7B97_9A71_52A8(_____53C2_6570["检查间隔毫秒"] or 100)
end
return ____exports
