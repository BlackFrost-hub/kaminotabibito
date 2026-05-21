local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
local applyEquipStatsTS = ____require_result_2.applyEquipStatsTS
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local R2I = jass.R2I
local _____9ED8_8BA4_89C6_91CE_53D8_5316BuffID = "C035"
local _____89C6_91CE_53D8_5316_6280_80FD_500D_7387 = 50
local _____89C6_91CE_53D8_5316_72B6_6001_8868 = {}
local _____89C6_91CE_53D8_5316_5230_671F_961F_5217 = {}
local _____4E0B_4E00_4E2A_89C6_91CE_53D8_5316_53E0_52A0ID = 0
local function _____53D6_5355_4F4D_952E(_____5355_4F4D, BuffID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or BuffID == "" then
        return ""
    end
    return (tostring(GetHandleId(_____5355_4F4D)) .. "|") .. BuffID
end
local function _____53D6_6709_6548BuffID(BuffID)
    return BuffID ~= nil and BuffID ~= "" and BuffID or _____9ED8_8BA4_89C6_91CE_53D8_5316BuffID
end
local function _____53D6_53E0_52A0_952E(_____53E0_52A0_952E)
    if _____53E0_52A0_952E ~= nil and _____53E0_52A0_952E ~= "" then
        return _____53E0_52A0_952E
    end
    _____4E0B_4E00_4E2A_89C6_91CE_53D8_5316_53E0_52A0ID = _____4E0B_4E00_4E2A_89C6_91CE_53D8_5316_53E0_52A0ID + 1
    return "视野变化#" .. tostring(_____4E0B_4E00_4E2A_89C6_91CE_53D8_5316_53E0_52A0ID)
end
local function _____89C4_8303_5316_89C6_91CE_503C(_____6570_503C)
    if _____6570_503C > 0 then
        return R2I(_____6570_503C / _____89C6_91CE_53D8_5316_6280_80FD_500D_7387 + 0.5) * _____89C6_91CE_53D8_5316_6280_80FD_500D_7387
    end
    if _____6570_503C < 0 then
        return -R2I(-_____6570_503C / _____89C6_91CE_53D8_5316_6280_80FD_500D_7387 + 0.5) * _____89C6_91CE_53D8_5316_6280_80FD_500D_7387
    end
    return 0
end
local function _____8C03_6574_5355_4F4D_89C6_91CE(_____5355_4F4D, _____6570_503C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____6570_503C == 0 then
        return
    end
    applyEquipStatsTS(_____5355_4F4D, {{name = "视野", value = _____6570_503C}})
end
local function ____on_89C6_91CE_53D8_5316_79FB_9664(_____5355_4F4D, BuffID, _row)
    local key = _____53D6_5355_4F4D_952E(_____5355_4F4D, BuffID)
    if key == "" then
        return
    end
    local _____72B6_6001 = _____89C6_91CE_53D8_5316_72B6_6001_8868[key]
    __TS__Delete(_____89C6_91CE_53D8_5316_72B6_6001_8868, key)
    if _____72B6_6001 == nil then
        return
    end
    _____8C03_6574_5355_4F4D_89C6_91CE(_____5355_4F4D, -_____72B6_6001["总数值"])
end
local function _____5237_65B0_89C6_91CE_53D8_5316_663E_793ABuff(_____72B6_6001)
    local now = getServerTime()
    local _____603B_6570_503C = 0
    local _____6700_665A_5230_671F = 0
    for _____53E0_52A0_952E in pairs(_____72B6_6001["栈表"]) do
        do
            local _____6808 = _____72B6_6001["栈表"][_____53E0_52A0_952E]
            if _____6808 == nil then
                goto __continue16
            end
            _____603B_6570_503C = _____603B_6570_503C + _____6808["数值"]
            if _____6808["到期时间"] > _____6700_665A_5230_671F then
                _____6700_665A_5230_671F = _____6808["到期时间"]
            end
        end
        ::__continue16::
    end
    _____72B6_6001["总数值"] = _____603B_6570_503C
    if not (_____603B_6570_503C ~= 0) or not (_____6700_665A_5230_671F > now) then
        __TS__Delete(
            _____89C6_91CE_53D8_5316_72B6_6001_8868,
            _____53D6_5355_4F4D_952E(_____72B6_6001["单位"], _____72B6_6001.BuffID)
        )
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____72B6_6001["单位"], _____72B6_6001.BuffID)
        return
    end
    registerManualBuff(
        _____72B6_6001["单位"],
        _____72B6_6001.BuffID,
        (_____6700_665A_5230_671F - now) / 1000,
        _____603B_6570_503C,
        {sourceName = _____72B6_6001["来源名称"], iconOverride = _____72B6_6001["图标路径"], effectModelOverride = _____72B6_6001["特效路径"], onRemove = ____on_89C6_91CE_53D8_5316_79FB_9664}
    )
end
local function _____5904_7406_89C6_91CE_53D8_5316_5230_671F()
    local now = getServerTime()
    local index = 0
    while index < #_____89C6_91CE_53D8_5316_5230_671F_961F_5217 do
        do
            local _____8BB0_5F55 = _____89C6_91CE_53D8_5316_5230_671F_961F_5217[index + 1]
            if _____8BB0_5F55 == nil or _____8BB0_5F55["到期时间"] > now then
                index = index + 1
                goto __continue22
            end
            __TS__ArraySplice(_____89C6_91CE_53D8_5316_5230_671F_961F_5217, index, 1)
            local key = _____53D6_5355_4F4D_952E(_____8BB0_5F55["单位"], _____8BB0_5F55.BuffID)
            if key == "" then
                goto __continue22
            end
            local _____72B6_6001 = _____89C6_91CE_53D8_5316_72B6_6001_8868[key]
            if _____72B6_6001 == nil then
                goto __continue22
            end
            local _____6808 = _____72B6_6001["栈表"][_____8BB0_5F55["叠加键"]]
            if _____6808 == nil or _____6808["版本"] ~= _____8BB0_5F55["版本"] then
                goto __continue22
            end
            __TS__Delete(_____72B6_6001["栈表"], _____8BB0_5F55["叠加键"])
            _____8C03_6574_5355_4F4D_89C6_91CE(_____8BB0_5F55["单位"], -_____6808["数值"])
            _____5237_65B0_89C6_91CE_53D8_5316_663E_793ABuff(_____72B6_6001)
        end
        ::__continue22::
    end
end
____exports["施加视野变化Buff"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    if not (_____53C2_6570["持续时间"] > 0) or _____53C2_6570["视野值"] == 0 then
        return false
    end
    local BuffID = _____53D6_6709_6548BuffID(_____53C2_6570.BuffID)
    local key = _____53D6_5355_4F4D_952E(_____76EE_6807_5355_4F4D, BuffID)
    if key == "" then
        return false
    end
    local _____72B6_6001 = _____89C6_91CE_53D8_5316_72B6_6001_8868[key]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {["单位"] = _____76EE_6807_5355_4F4D, BuffID = BuffID, ["总数值"] = 0, ["栈表"] = {}}
        _____89C6_91CE_53D8_5316_72B6_6001_8868[key] = _____72B6_6001
    end
    local _____53E0_52A0_952E = _____53D6_53E0_52A0_952E(_____53C2_6570["叠加键"])
    local _____65E7_72B6_6001 = _____72B6_6001["栈表"][_____53E0_52A0_952E]
    local _____65E7_503C = _____65E7_72B6_6001 ~= nil and _____65E7_72B6_6001["数值"] or 0
    local _____751F_6548_89C6_91CE_503C = _____89C4_8303_5316_89C6_91CE_503C(_____53C2_6570["视野值"])
    if _____751F_6548_89C6_91CE_503C == 0 then
        return false
    end
    local _____5DEE_503C = _____751F_6548_89C6_91CE_503C - _____65E7_503C
    if _____5DEE_503C ~= 0 then
        _____8C03_6574_5355_4F4D_89C6_91CE(_____76EE_6807_5355_4F4D, _____5DEE_503C)
    end
    local _____7248_672C = _____65E7_72B6_6001 ~= nil and _____65E7_72B6_6001["版本"] + 1 or 1
    local _____5230_671F_65F6_95F4 = getServerTime() + _____53C2_6570["持续时间"] * 1000
    _____72B6_6001["栈表"][_____53E0_52A0_952E] = {["数值"] = _____751F_6548_89C6_91CE_503C, ["到期时间"] = _____5230_671F_65F6_95F4, ["版本"] = _____7248_672C}
    _____72B6_6001["总数值"] = _____72B6_6001["总数值"] + _____5DEE_503C
    _____72B6_6001["来源名称"] = _____6765_6E90_5355_4F4D ~= nil and _____6765_6E90_5355_4F4D ~= 0 and GetUnitName(_____6765_6E90_5355_4F4D) or nil
    _____72B6_6001["图标路径"] = _____53C2_6570["图标路径"]
    _____72B6_6001["特效路径"] = _____53C2_6570["特效路径"]
    _____5237_65B0_89C6_91CE_53D8_5316_663E_793ABuff(_____72B6_6001)
    _____89C6_91CE_53D8_5316_5230_671F_961F_5217[#_____89C6_91CE_53D8_5316_5230_671F_961F_5217 + 1] = {
        ["单位"] = _____76EE_6807_5355_4F4D,
        BuffID = BuffID,
        ["叠加键"] = _____53E0_52A0_952E,
        ["到期时间"] = _____5230_671F_65F6_95F4,
        ["版本"] = _____7248_672C
    }
    addDelayedCallback(_____53C2_6570["持续时间"] * 1000, _____5904_7406_89C6_91CE_53D8_5316_5230_671F)
    return true
end
____exports["移除单位视野变化Buff"] = function(_____5355_4F4D)
    return _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5355_4F4D, _____9ED8_8BA4_89C6_91CE_53D8_5316BuffID)
end
return ____exports
