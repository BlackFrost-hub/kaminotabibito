local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____7533_8BF7_5355_4F4D_6682_505C_72EC_7ACB_5360_7528 = ____require_result_0["申请单位暂停独立占用"]
local _____91CA_653E_5355_4F4D_6682_505C_6765_6E90_5168_90E8 = ____require_result_0["释放单位暂停来源全部"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local SUC_IsUnitInvincible = ____require_result_1.SUC_IsUnitInvincible
local GetHandleId = jass.GetHandleId
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local _____65E0_654C_5360_7528_8BB0_5F55_8868 = {}
local function _____8BFB_53D6_53E5_67C4ID(handle)
    if handle == nil or handle == 0 then
        return 0
    end
    return GetHandleId(handle) or 0
end
local function _____67E5_627E_6765_6E90(_____6765_6E90_5217_8868, _____6765_6E90)
    do
        local i = 0
        while i < #_____6765_6E90_5217_8868 do
            if _____6765_6E90_5217_8868[i + 1] == _____6765_6E90 then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
____exports["单位是否无敌安全"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local unitId = _____8BFB_53D6_53E5_67C4ID(unit)
    if unitId ~= 0 and _____65E0_654C_5360_7528_8BB0_5F55_8868[unitId] ~= nil then
        return true
    end
    return SUC_IsUnitInvincible(unit)
end
--- 统一维护剧情单位的待战状态。
-- 暂停使用来源计数，解除时只释放本次来源，避免破坏其他系统的暂停占用。
____exports["暂停并设置无敌安全"] = function(unit, _____6765_6E90)
    if unit == nil or unit == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = _____8BFB_53D6_53E5_67C4ID(unit)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____8BB0_5F55 = _____65E0_654C_5360_7528_8BB0_5F55_8868[_____5355_4F4DID]
    if _____8BB0_5F55 == nil then
        _____8BB0_5F55 = {
            ["单位"] = unit,
            ["原始无敌"] = SUC_IsUnitInvincible(unit),
            ["来源列表"] = {}
        }
        _____65E0_654C_5360_7528_8BB0_5F55_8868[_____5355_4F4DID] = _____8BB0_5F55
    end
    local _____6765_6E90_7D22_5F15 = _____67E5_627E_6765_6E90(_____8BB0_5F55["来源列表"], _____6765_6E90)
    local _____65B0_589E_6765_6E90 = _____6765_6E90_7D22_5F15 < 0
    if _____65B0_589E_6765_6E90 then
        local ____8BB0_5F55__6765_6E90_5217_8868_2 = _____8BB0_5F55["来源列表"]
        ____8BB0_5F55__6765_6E90_5217_8868_2[#____8BB0_5F55__6765_6E90_5217_8868_2 + 1] = _____6765_6E90
    end
    local _____5DF2_6682_505C = _____7533_8BF7_5355_4F4D_6682_505C_72EC_7ACB_5360_7528(unit, _____6765_6E90)
    if _____5DF2_6682_505C then
        SetUnitInvulnerable(unit, true)
        return true
    end
    if _____65B0_589E_6765_6E90 then
        table.remove(_____8BB0_5F55["来源列表"])
    end
    if #_____8BB0_5F55["来源列表"] <= 0 then
        __TS__Delete(_____65E0_654C_5360_7528_8BB0_5F55_8868, _____5355_4F4DID)
    end
    return false
end
--- 解除由暂停并设置无敌安全建立的剧情待战状态。
____exports["解除暂停并取消无敌安全"] = function(unit, _____6765_6E90)
    if unit == nil or unit == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = _____8BFB_53D6_53E5_67C4ID(unit)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____8BB0_5F55 = _____65E0_654C_5360_7528_8BB0_5F55_8868[_____5355_4F4DID]
    if _____8BB0_5F55 == nil or _____67E5_627E_6765_6E90(_____8BB0_5F55["来源列表"], _____6765_6E90) < 0 then
        return false
    end
    local _____5DF2_89E3_9664_6682_505C = _____91CA_653E_5355_4F4D_6682_505C_6765_6E90_5168_90E8(unit, _____6765_6E90)
    local _____6765_6E90_7D22_5F15 = _____67E5_627E_6765_6E90(_____8BB0_5F55["来源列表"], _____6765_6E90)
    if _____6765_6E90_7D22_5F15 >= 0 then
        __TS__ArraySplice(_____8BB0_5F55["来源列表"], _____6765_6E90_7D22_5F15, 1)
    end
    if #_____8BB0_5F55["来源列表"] == 0 then
        SetUnitInvulnerable(unit, _____8BB0_5F55["原始无敌"])
        __TS__Delete(_____65E0_654C_5360_7528_8BB0_5F55_8868, _____5355_4F4DID)
    else
        SetUnitInvulnerable(unit, true)
    end
    return _____5DF2_89E3_9664_6682_505C
end
return ____exports
