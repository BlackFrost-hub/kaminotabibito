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
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_1.SGSS_SetState
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local matchUnitFilter = ____require_result_3.matchUnitFilter
local isValidUnit = ____require_result_3.isValidUnit
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local getServerTime = ____require_result_4.getServerTime
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____9ED8_8BA4_62A4_7532_964D_4F4EBuffID = "C032"
local _____62A4_7532_5C5E_6027ID = 2
local _____62A4_7532_964D_4F4E_72B6_6001_8868 = {}
local _____62A4_7532_964D_4F4E_5230_671F_961F_5217 = {}
local _____4E0B_4E00_4E2A_62A4_7532_964D_4F4E_53E0_52A0ID = 0
local function _____53D6_5355_4F4D_952E(_____5355_4F4D, BuffID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or BuffID == "" then
        return ""
    end
    return (tostring(GetHandleId(_____5355_4F4D)) .. "|") .. BuffID
end
local function _____53D6_6709_6548BuffID(BuffID)
    return BuffID ~= nil and BuffID ~= "" and BuffID or _____9ED8_8BA4_62A4_7532_964D_4F4EBuffID
end
local function _____53D6_53E0_52A0_952E(_____53E0_52A0_952E)
    if _____53E0_52A0_952E ~= nil and _____53E0_52A0_952E ~= "" then
        return _____53E0_52A0_952E
    end
    _____4E0B_4E00_4E2A_62A4_7532_964D_4F4E_53E0_52A0ID = _____4E0B_4E00_4E2A_62A4_7532_964D_4F4E_53E0_52A0ID + 1
    return "护甲降低#" .. tostring(_____4E0B_4E00_4E2A_62A4_7532_964D_4F4E_53E0_52A0ID)
end
local function _____8C03_6574_5355_4F4D_62A4_7532(_____5355_4F4D, _____6570_503C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____6570_503C == 0 then
        return
    end
    SGSS_SetState(_____5355_4F4D, _____62A4_7532_5C5E_6027ID, _____6570_503C)
end
local function ____on_62A4_7532_964D_4F4E_79FB_9664(_____5355_4F4D, BuffID, _row)
    local key = _____53D6_5355_4F4D_952E(_____5355_4F4D, BuffID)
    if key == "" then
        return
    end
    local _____72B6_6001 = _____62A4_7532_964D_4F4E_72B6_6001_8868[key]
    __TS__Delete(_____62A4_7532_964D_4F4E_72B6_6001_8868, key)
    if _____72B6_6001 == nil then
        return
    end
    _____8C03_6574_5355_4F4D_62A4_7532(_____5355_4F4D, _____72B6_6001["总数值"])
end
local function _____5237_65B0_62A4_7532_964D_4F4E_663E_793ABuff(_____72B6_6001, _____56FE_6807_8DEF_5F84, _____7279_6548_8DEF_5F84)
    local now = getServerTime()
    local _____603B_6570_503C = 0
    local _____6700_665A_5230_671F = 0
    for _____53E0_52A0_952E in pairs(_____72B6_6001["栈表"]) do
        do
            local _____6808 = _____72B6_6001["栈表"][_____53E0_52A0_952E]
            if _____6808 == nil then
                goto __continue13
            end
            _____603B_6570_503C = _____603B_6570_503C + _____6808["数值"]
            if _____6808["到期时间"] > _____6700_665A_5230_671F then
                _____6700_665A_5230_671F = _____6808["到期时间"]
            end
        end
        ::__continue13::
    end
    _____72B6_6001["总数值"] = _____603B_6570_503C
    if not (_____603B_6570_503C > 0) or not (_____6700_665A_5230_671F > now) then
        __TS__Delete(
            _____62A4_7532_964D_4F4E_72B6_6001_8868,
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
        {
            sourceName = _____72B6_6001["来源名称"],
            effectSourceName = _____72B6_6001["效果来源名称"],
            effectSourceType = _____72B6_6001["效果来源类型"],
            iconOverride = _____56FE_6807_8DEF_5F84,
            effectModelOverride = _____7279_6548_8DEF_5F84,
            onRemove = ____on_62A4_7532_964D_4F4E_79FB_9664
        }
    )
end
local function _____5904_7406_62A4_7532_964D_4F4E_5230_671F()
    local now = getServerTime()
    local index = 0
    while index < #_____62A4_7532_964D_4F4E_5230_671F_961F_5217 do
        do
            local _____8BB0_5F55 = _____62A4_7532_964D_4F4E_5230_671F_961F_5217[index + 1]
            if _____8BB0_5F55 == nil or _____8BB0_5F55["到期时间"] > now then
                index = index + 1
                goto __continue19
            end
            __TS__ArraySplice(_____62A4_7532_964D_4F4E_5230_671F_961F_5217, index, 1)
            local key = _____53D6_5355_4F4D_952E(_____8BB0_5F55["单位"], _____8BB0_5F55.BuffID)
            if key == "" then
                goto __continue19
            end
            local _____72B6_6001 = _____62A4_7532_964D_4F4E_72B6_6001_8868[key]
            if _____72B6_6001 == nil then
                goto __continue19
            end
            local _____6808 = _____72B6_6001["栈表"][_____8BB0_5F55["叠加键"]]
            if _____6808 == nil or _____6808["版本"] ~= _____8BB0_5F55["版本"] then
                goto __continue19
            end
            __TS__Delete(_____72B6_6001["栈表"], _____8BB0_5F55["叠加键"])
            _____8C03_6574_5355_4F4D_62A4_7532(_____8BB0_5F55["单位"], _____6808["数值"])
            _____5237_65B0_62A4_7532_964D_4F4E_663E_793ABuff(_____72B6_6001)
        end
        ::__continue19::
    end
end
____exports["施加单体护甲降低Buff"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return false
    end
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    if not (_____53C2_6570["持续时间"] > 0) or not (_____53C2_6570["护甲"] > 0) then
        return false
    end
    if not isValidUnit(_____76EE_6807_5355_4F4D) then
        return false
    end
    local BuffID = _____53D6_6709_6548BuffID(_____53C2_6570.BuffID)
    local key = _____53D6_5355_4F4D_952E(_____76EE_6807_5355_4F4D, BuffID)
    if key == "" then
        return false
    end
    local _____72B6_6001 = _____62A4_7532_964D_4F4E_72B6_6001_8868[key]
    if _____72B6_6001 == nil then
        _____72B6_6001 = {["单位"] = _____76EE_6807_5355_4F4D, BuffID = BuffID, ["总数值"] = 0, ["栈表"] = {}}
        _____62A4_7532_964D_4F4E_72B6_6001_8868[key] = _____72B6_6001
    end
    local _____53E0_52A0_952E = _____53D6_53E0_52A0_952E(_____53C2_6570["叠加键"])
    local _____65E7_72B6_6001 = _____72B6_6001["栈表"][_____53E0_52A0_952E]
    local _____65E7_503C = _____65E7_72B6_6001 ~= nil and _____65E7_72B6_6001["数值"] or 0
    local _____751F_6548_62A4_7532 = _____53C2_6570["护甲"]
    local _____5DEE_503C = _____751F_6548_62A4_7532 - _____65E7_503C
    if _____5DEE_503C ~= 0 then
        _____8C03_6574_5355_4F4D_62A4_7532(_____76EE_6807_5355_4F4D, -_____5DEE_503C)
    end
    local _____7248_672C = _____65E7_72B6_6001 ~= nil and _____65E7_72B6_6001["版本"] + 1 or 1
    local _____5230_671F_65F6_95F4 = getServerTime() + _____53C2_6570["持续时间"] * 1000
    _____72B6_6001["栈表"][_____53E0_52A0_952E] = {["数值"] = _____751F_6548_62A4_7532, ["到期时间"] = _____5230_671F_65F6_95F4, ["版本"] = _____7248_672C}
    _____72B6_6001["总数值"] = _____72B6_6001["总数值"] + _____5DEE_503C
    _____72B6_6001["来源名称"] = GetUnitName(_____6765_6E90_5355_4F4D)
    _____72B6_6001["效果来源名称"] = _____53C2_6570["效果来源名称"]
    _____72B6_6001["效果来源类型"] = _____53C2_6570["效果来源类型"]
    _____5237_65B0_62A4_7532_964D_4F4E_663E_793ABuff(_____72B6_6001, _____53C2_6570["图标路径"], _____53C2_6570["特效路径"])
    _____62A4_7532_964D_4F4E_5230_671F_961F_5217[#_____62A4_7532_964D_4F4E_5230_671F_961F_5217 + 1] = {
        ["单位"] = _____76EE_6807_5355_4F4D,
        BuffID = BuffID,
        ["叠加键"] = _____53E0_52A0_952E,
        ["到期时间"] = _____5230_671F_65F6_95F4,
        ["版本"] = _____7248_672C
    }
    addDelayedCallback(_____53C2_6570["持续时间"] * 1000, _____5904_7406_62A4_7532_964D_4F4E_5230_671F)
    return true
end
____exports["施加范围护甲降低Buff"] = function(_____6765_6E90_5355_4F4D, _____53C2_6570)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return 0
    end
    if not (_____53C2_6570["范围"] > 0) then
        return 0
    end
    local ____temp_5
    if _____53C2_6570["中心单位"] ~= nil and _____53C2_6570["中心单位"] ~= 0 then
        ____temp_5 = _____53C2_6570["中心单位"]
    else
        ____temp_5 = _____6765_6E90_5355_4F4D
    end
    local _____4E2D_5FC3_5355_4F4D = ____temp_5
    local x = _____53C2_6570.x ~= nil and _____53C2_6570.x or GetUnitX(_____4E2D_5FC3_5355_4F4D)
    local y = _____53C2_6570.y ~= nil and _____53C2_6570.y or GetUnitY(_____4E2D_5FC3_5355_4F4D)
    local _____5355_4F4D_5217_8868 = getUnitsInRange(x, y, _____53C2_6570["范围"])
    local _____7B5B_9009 = _____53C2_6570["筛选"] or ({["仅敌人"] = true, ["排除自身"] = false})
    local _____6210_529F_6570_91CF = 0
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____76EE_6807_5355_4F4D = _____5355_4F4D_5217_8868[i + 1]
                if not matchUnitFilter(_____76EE_6807_5355_4F4D, _____6765_6E90_5355_4F4D, _____7B5B_9009) then
                    goto __continue36
                end
                if ____exports["施加单体护甲降低Buff"](_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570) then
                    _____6210_529F_6570_91CF = _____6210_529F_6570_91CF + 1
                end
            end
            ::__continue36::
            i = i + 1
        end
    end
    return _____6210_529F_6570_91CF
end
return ____exports
