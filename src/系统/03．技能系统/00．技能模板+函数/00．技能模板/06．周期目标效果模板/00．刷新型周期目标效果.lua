--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
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
local _____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868 = {}
local _____5468_671F_76EE_6807_6548_679C_9A71_52A8ID = 0
local _____5468_671F_76EE_6807_6548_679C_68C0_67E5_95F4_9694_6BEB_79D2 = 100
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____5355_4F4D_6709_6548_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____751F_6210_5468_671F_76EE_6807_6548_679Ckey(_____53C2_6570)
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
local function _____8BB0_5F55_4ECD_6709_6548(_____8BB0_5F55, now)
    if now >= _____8BB0_5F55.expireTime then
        return false
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(_____8BB0_5F55["来源单位"]) or not _____5355_4F4D_6709_6548_5B58_6D3B(_____8BB0_5F55["目标单位"]) then
        return false
    end
    if _____8BB0_5F55["有效性检查"] == nil then
        return true
    end
    return _____8BB0_5F55["有效性检查"](_____6784_5EFA_4E0A_4E0B_6587(_____8BB0_5F55, now))
end
local function ____on_5237_65B0_578B_5468_671F_76EE_6807_6548_679CTick()
    local now = getServerTime()
    local write = 0
    do
        local i = 0
        while i < #_____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868 do
            do
                local _____8BB0_5F55 = _____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868[i + 1]
                if _____8BB0_5F55 == nil or not _____8BB0_5F55_4ECD_6709_6548(_____8BB0_5F55, now) then
                    goto __continue14
                end
                if now >= _____8BB0_5F55.nextTickTime then
                    _____8BB0_5F55["on周期"](_____6784_5EFA_4E0A_4E0B_6587(_____8BB0_5F55, now))
                    _____8BB0_5F55.nextTickTime = now + _____8BB0_5F55.intervalMs
                end
                _____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868[write + 1] = _____8BB0_5F55
                write = write + 1
            end
            ::__continue14::
            i = i + 1
        end
    end
    while #_____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868 > write do
        table.remove(_____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868)
    end
    if #_____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868 <= 0 and _____5468_671F_76EE_6807_6548_679C_9A71_52A8ID ~= 0 then
        removePeriodicCallback(_____5468_671F_76EE_6807_6548_679C_9A71_52A8ID)
        _____5468_671F_76EE_6807_6548_679C_9A71_52A8ID = 0
    end
end
local function _____786E_4FDD_5237_65B0_578B_5468_671F_76EE_6807_6548_679C_9A71_52A8(_____68C0_67E5_95F4_9694_6BEB_79D2)
    if _____5468_671F_76EE_6807_6548_679C_9A71_52A8ID ~= 0 then
        return
    end
    _____5468_671F_76EE_6807_6548_679C_68C0_67E5_95F4_9694_6BEB_79D2 = _____68C0_67E5_95F4_9694_6BEB_79D2 > 0 and _____68C0_67E5_95F4_9694_6BEB_79D2 or 100
    _____5468_671F_76EE_6807_6548_679C_9A71_52A8ID = addPeriodicCallback(_____5468_671F_76EE_6807_6548_679C_68C0_67E5_95F4_9694_6BEB_79D2, ____on_5237_65B0_578B_5468_671F_76EE_6807_6548_679CTick)
end
____exports["施加或刷新周期目标效果"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["on周期"] == nil then
        return
    end
    if _____53C2_6570["持续毫秒"] <= 0 or _____53C2_6570["间隔毫秒"] <= 0 then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(_____53C2_6570["来源单位"]) or not _____5355_4F4D_6709_6548_5B58_6D3B(_____53C2_6570["目标单位"]) then
        return
    end
    local key = _____751F_6210_5468_671F_76EE_6807_6548_679Ckey(_____53C2_6570)
    if key == "" then
        return
    end
    local now = getServerTime()
    local expireTime = now + _____53C2_6570["持续毫秒"]
    do
        local i = 0
        while i < #_____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868 do
            do
                local _____8BB0_5F55 = _____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868[i + 1]
                if _____8BB0_5F55 == nil or _____8BB0_5F55.key ~= key then
                    goto __continue27
                end
                _____8BB0_5F55.expireTime = expireTime
                _____8BB0_5F55.intervalMs = _____53C2_6570["间隔毫秒"]
                _____8BB0_5F55["有效性检查"] = _____53C2_6570["有效性检查"]
                _____8BB0_5F55["on周期"] = _____53C2_6570["on周期"]
                if _____53C2_6570["刷新时重置下次周期"] == true then
                    _____8BB0_5F55.nextTickTime = now + _____53C2_6570["间隔毫秒"]
                end
                _____786E_4FDD_5237_65B0_578B_5468_671F_76EE_6807_6548_679C_9A71_52A8(_____53C2_6570["检查间隔毫秒"] or _____5468_671F_76EE_6807_6548_679C_68C0_67E5_95F4_9694_6BEB_79D2)
                return
            end
            ::__continue27::
            i = i + 1
        end
    end
    _____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868[#_____5468_671F_76EE_6807_6548_679C_8BB0_5F55_5217_8868 + 1] = {
        key = key,
        ["来源单位"] = _____53C2_6570["来源单位"],
        ["目标单位"] = _____53C2_6570["目标单位"],
        expireTime = expireTime,
        nextTickTime = now + _____53C2_6570["间隔毫秒"],
        intervalMs = _____53C2_6570["间隔毫秒"],
        ["有效性检查"] = _____53C2_6570["有效性检查"],
        ["on周期"] = _____53C2_6570["on周期"]
    }
    _____786E_4FDD_5237_65B0_578B_5468_671F_76EE_6807_6548_679C_9A71_52A8(_____53C2_6570["检查间隔毫秒"] or 100)
end
return ____exports
