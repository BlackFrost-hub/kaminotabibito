local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_1.SGSS_SetState
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_2.getUnitsInRange
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local matchUnitFilter = ____require_result_3.matchUnitFilter
local isValidUnit = ____require_result_3.isValidUnit
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local _____9ED8_8BA4_653B_51FB_529B_964D_4F4EBuffID = "C031"
local _____653B_51FB_529B_5C5E_6027ID = 1
local _____653B_51FB_529B_964D_4F4E_72B6_6001_8868 = {}
local function _____53D6_5355_4F4D_952E(_____5355_4F4D, BuffID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or BuffID == "" then
        return ""
    end
    return (tostring(GetHandleId(_____5355_4F4D)) .. "|") .. BuffID
end
local function _____53D6_6709_6548BuffID(BuffID)
    return BuffID ~= nil and BuffID ~= "" and BuffID or _____9ED8_8BA4_653B_51FB_529B_964D_4F4EBuffID
end
local function _____8C03_6574_5355_4F4D_653B_51FB_529B(_____5355_4F4D, _____6570_503C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____6570_503C == 0 then
        return
    end
    SGSS_SetState(_____5355_4F4D, _____653B_51FB_529B_5C5E_6027ID, _____6570_503C)
end
local function ____on_653B_51FB_529B_964D_4F4E_79FB_9664(_____5355_4F4D, BuffID, _row)
    local key = _____53D6_5355_4F4D_952E(_____5355_4F4D, BuffID)
    if key == "" then
        return
    end
    local _____72B6_6001 = _____653B_51FB_529B_964D_4F4E_72B6_6001_8868[key]
    __TS__Delete(_____653B_51FB_529B_964D_4F4E_72B6_6001_8868, key)
    if _____72B6_6001 == nil then
        return
    end
    _____8C03_6574_5355_4F4D_653B_51FB_529B(_____5355_4F4D, _____72B6_6001["数值"])
end
____exports["施加单体攻击力降低Buff"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return false
    end
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    if not (_____53C2_6570["持续时间"] > 0) or not (_____53C2_6570["攻击力"] > 0) then
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
    local _____65E7_72B6_6001 = _____653B_51FB_529B_964D_4F4E_72B6_6001_8868[key]
    local _____751F_6548_653B_51FB_529B = _____53C2_6570["攻击力"]
    if _____65E7_72B6_6001 ~= nil and _____65E7_72B6_6001["数值"] >= _____751F_6548_653B_51FB_529B then
        _____751F_6548_653B_51FB_529B = _____65E7_72B6_6001["数值"]
    end
    local _____65E7_503C = _____65E7_72B6_6001 ~= nil and _____65E7_72B6_6001["数值"] or 0
    local _____5DEE_503C = _____751F_6548_653B_51FB_529B - _____65E7_503C
    if _____5DEE_503C ~= 0 then
        _____8C03_6574_5355_4F4D_653B_51FB_529B(_____76EE_6807_5355_4F4D, -_____5DEE_503C)
    end
    _____653B_51FB_529B_964D_4F4E_72B6_6001_8868[key] = {["数值"] = _____751F_6548_653B_51FB_529B}
    registerManualBuff(
        _____76EE_6807_5355_4F4D,
        BuffID,
        _____53C2_6570["持续时间"],
        _____751F_6548_653B_51FB_529B,
        {
            sourceName = GetUnitName(_____6765_6E90_5355_4F4D),
            iconOverride = _____53C2_6570["图标路径"],
            effectModelOverride = _____53C2_6570["特效路径"],
            onRemove = ____on_653B_51FB_529B_964D_4F4E_79FB_9664
        }
    )
    return true
end
____exports["施加范围攻击力降低Buff"] = function(_____6765_6E90_5355_4F4D, _____53C2_6570)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return 0
    end
    if not (_____53C2_6570["范围"] > 0) then
        return 0
    end
    local ____temp_4
    if _____53C2_6570["中心单位"] ~= nil and _____53C2_6570["中心单位"] ~= 0 then
        ____temp_4 = _____53C2_6570["中心单位"]
    else
        ____temp_4 = _____6765_6E90_5355_4F4D
    end
    local _____4E2D_5FC3_5355_4F4D = ____temp_4
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
                    goto __continue22
                end
                if ____exports["施加单体攻击力降低Buff"](_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570) then
                    _____6210_529F_6570_91CF = _____6210_529F_6570_91CF + 1
                end
            end
            ::__continue22::
            i = i + 1
        end
    end
    return _____6210_529F_6570_91CF
end
return ____exports
