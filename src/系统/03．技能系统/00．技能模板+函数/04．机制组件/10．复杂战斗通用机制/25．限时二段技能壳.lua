--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local GetOwningPlayer = jass.GetOwningPlayer
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
____exports["通用二段技能壳ID"] = {Q = "ASQ2", W = "ASW2", E = "ASE2", R = "ASR2"}
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0
end
local function _____6062_590D_6280_80FD_58F3(_____63A7_5236_5668)
    if not _____5355_4F4D_6709_6548(_____63A7_5236_5668["单位"]) then
        return
    end
    UnitRemoveAbility(_____63A7_5236_5668["单位"], _____63A7_5236_5668["二段技能ID"])
    local owner = GetOwningPlayer(_____63A7_5236_5668["单位"])
    if owner == nil or owner == 0 then
        return
    end
    SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["二段技能ID"], false)
    SetPlayerAbilityAvailable(owner, _____63A7_5236_5668["一段技能ID"], true)
end
local function _____7ED3_675F_6280_80FD_58F3(_____63A7_5236_5668, _____53D6_6D88_8BA1_65F6)
    if _____63A7_5236_5668 == nil or _____63A7_5236_5668["已结束"] then
        return false
    end
    _____63A7_5236_5668["已结束"] = true
    if _____53D6_6D88_8BA1_65F6 and _____63A7_5236_5668["超时回调ID"] ~= 0 then
        removeDelayedCallback(_____63A7_5236_5668["超时回调ID"])
    end
    _____63A7_5236_5668["超时回调ID"] = 0
    _____6062_590D_6280_80FD_58F3(_____63A7_5236_5668)
    return true
end
local function _____9650_65F6_4E8C_6BB5_6280_80FD_58F3_8D85_65F6(variable)
    local _____63A7_5236_5668 = variable
    if not _____7ED3_675F_6280_80FD_58F3(_____63A7_5236_5668, false) or _____63A7_5236_5668 == nil then
        return
    end
    if _____63A7_5236_5668["超时回调"] ~= nil then
        _____63A7_5236_5668["超时回调"](_____63A7_5236_5668)
    end
end
____exports["创建限时二段技能壳"] = function(_____53C2_6570)
    if not _____5355_4F4D_6709_6548(_____53C2_6570["单位"]) or _____53C2_6570["一段技能ID"] == 0 or _____53C2_6570["二段技能ID"] == 0 or _____53C2_6570["持续秒"] <= 0 then
        return nil
    end
    local owner = GetOwningPlayer(_____53C2_6570["单位"])
    if owner == nil or owner == 0 then
        return nil
    end
    UnitRemoveAbility(_____53C2_6570["单位"], _____53C2_6570["二段技能ID"])
    SetPlayerAbilityAvailable(owner, _____53C2_6570["一段技能ID"], false)
    if not UnitAddAbility(_____53C2_6570["单位"], _____53C2_6570["二段技能ID"]) then
        SetPlayerAbilityAvailable(owner, _____53C2_6570["一段技能ID"], true)
        return nil
    end
    SetPlayerAbilityAvailable(owner, _____53C2_6570["二段技能ID"], true)
    local _____63A7_5236_5668 = {
        ["名称"] = _____53C2_6570["名称"],
        ["单位"] = _____53C2_6570["单位"],
        ["一段技能ID"] = _____53C2_6570["一段技能ID"],
        ["二段技能ID"] = _____53C2_6570["二段技能ID"],
        ["超时回调ID"] = 0,
        ["已结束"] = false,
        ["数据"] = _____53C2_6570["数据"],
        ["超时回调"] = _____53C2_6570["超时回调"]
    }
    _____63A7_5236_5668["超时回调ID"] = addDelayedCallback(_____53C2_6570["持续秒"] * 1000, _____9650_65F6_4E8C_6BB5_6280_80FD_58F3_8D85_65F6, _____63A7_5236_5668)
    return _____63A7_5236_5668
end
____exports["确认限时二段技能壳"] = function(_____63A7_5236_5668)
    return _____7ED3_675F_6280_80FD_58F3(_____63A7_5236_5668, true)
end
____exports["清理限时二段技能壳"] = function(_____63A7_5236_5668)
    return _____7ED3_675F_6280_80FD_58F3(_____63A7_5236_5668, true)
end
return ____exports
