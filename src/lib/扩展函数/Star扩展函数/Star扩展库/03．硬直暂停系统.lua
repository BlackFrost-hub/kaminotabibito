local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local hid, _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15, RMaxBJ, getServerTime, GetHandleId, _____786C_76F4_5230_671F_4EFB_52A1_5217_8868
function hid(h)
    return GetHandleId(h) or 0
end
function _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15(_____5355_4F4DID)
    do
        local i = 0
        while i < #_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 do
            if _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[i + 1]["单位ID"] == _____5355_4F4DID then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
--- 获取单位剩余暂停时间（秒）。
function ____exports.GS_LoadSuspend(u)
    if u == nil or u == 0 then
        return 0
    end
    local uid = hid(u)
    if uid == 0 then
        return 0
    end
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15(uid)
    if _____4EFB_52A1_7D22_5F15 < 0 then
        return 0
    end
    return RMaxBJ(
        0,
        _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[_____4EFB_52A1_7D22_5F15 + 1]["到期时间毫秒"] - getServerTime()
    ) * 0.001
end
--- Star扩展库 - 硬直/暂停系统
-- 
-- 来源于 SUSPEND.j，提供单位暂停控制功能。
-- 通过 EXPauseUnit(japi) 暂停单位，中心计时器驱动到期后自动恢复。
-- 支持暂停时间累加、减少、取最大值等操作。
-- 
-- 公开接口：
--   GS_Suspend(u, time)          - 暂停单位一段时间
--   GS_IsUnitSuspending(u)       - 检查单位是否处于暂停状态
--   GS_LoadSuspend(u)            - 获取单位剩余暂停时间
--   GS_UnitSuspend(u, i, r)      - 修改暂停时间（0=增加，1=减少，2=取最大值）
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
RMaxBJ = ____require_result_0.RMaxBJ
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
getServerTime = ____require_result_1.getServerTime
local japi = nil
do
    local function ____catch(_e)
        japi = nil
    end
    local ____try, ____hasReturned = pcall(function()
        japi = require("jass.japi")
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
end
local PauseUnit = jass.PauseUnit
GetHandleId = jass.GetHandleId
local EXPauseUnit = japi ~= nil and type(japi.EXPauseUnit) == "function" and japi.EXPauseUnit or nil
local _____5355_4F4D_6682_505C_5360_7528_603B_8868 = {}
local _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868 = {}
local function _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, _____662F_5426_6682_505C)
    if u == nil or u == 0 then
        return
    end
    if EXPauseUnit ~= nil then
        EXPauseUnit(u, _____662F_5426_6682_505C)
        return
    end
    PauseUnit(u, _____662F_5426_6682_505C)
end
local function _____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____6765_6E90)
    return (tostring(_____5355_4F4DID) .. ":") .. _____6765_6E90
end
____exports["申请单位暂停占用"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____6765_6E90_952E = _____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____6765_6E90)
    local _____539F_6765_6E90_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____6765_6E90_952E] or 0
    _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____6765_6E90_952E] = _____539F_6765_6E90_8BA1_6570 + 1
    if _____539F_6765_6E90_8BA1_6570 > 0 then
        return true
    end
    local _____539F_603B_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0
    _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] = _____539F_603B_8BA1_6570 + 1
    if _____539F_603B_8BA1_6570 <= 0 then
        _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, true)
    end
    return true
end
____exports["释放单位暂停占用"] = function(u, _____6765_6E90)
    if u == nil or u == 0 or _____6765_6E90 == nil or _____6765_6E90 == "" then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____6765_6E90_952E = _____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____6765_6E90)
    local _____539F_6765_6E90_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____6765_6E90_952E] or 0
    if _____539F_6765_6E90_8BA1_6570 <= 0 then
        return false
    end
    if _____539F_6765_6E90_8BA1_6570 <= 1 then
        __TS__Delete(_____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868, _____6765_6E90_952E)
    else
        _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____6765_6E90_952E] = _____539F_6765_6E90_8BA1_6570 - 1
    end
    local _____539F_603B_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0
    if _____539F_603B_8BA1_6570 <= 1 then
        __TS__Delete(_____5355_4F4D_6682_505C_5360_7528_603B_8868, _____5355_4F4DID)
        _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, false)
    else
        _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] = _____539F_603B_8BA1_6570 - 1
    end
    return true
end
____exports["单位是否存在暂停占用"] = function(u)
    if u == nil or u == 0 then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    return (_____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0) > 0
end
____exports["单位是否存在其他暂停占用"] = function(u, _____81EA_8EAB_6765_6E90)
    if u == nil or u == 0 then
        return false
    end
    local _____5355_4F4DID = hid(u)
    if _____5355_4F4DID == 0 then
        return false
    end
    local _____603B_8BA1_6570 = _____5355_4F4D_6682_505C_5360_7528_603B_8868[_____5355_4F4DID] or 0
    if _____603B_8BA1_6570 <= 0 then
        return false
    end
    local _____81EA_8EAB_6765_6E90_8BA1_6570 = _____81EA_8EAB_6765_6E90 ~= nil and _____81EA_8EAB_6765_6E90 ~= "" and (_____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868[_____751F_6210_6682_505C_6765_6E90_952E(_____5355_4F4DID, _____81EA_8EAB_6765_6E90)] or 0) or 0
    return _____603B_8BA1_6570 > _____81EA_8EAB_6765_6E90_8BA1_6570
end
_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 = {}
local _____786C_76F4_5230_671F_9A71_52A8_5DF2_6CE8_518C = false
local function ____on_786C_76F4_5230_671F_9A71_52A8()
    if #_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 == 0 then
        return
    end
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____5199_5165_4F4D_7F6E = 0
    do
        local i = 0
        while i < #_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 do
            local _____4EFB_52A1 = _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[i + 1]
            if _____5F53_524D_65F6_95F4_6BEB_79D2 >= _____4EFB_52A1["到期时间毫秒"] then
                ____exports["释放单位暂停占用"](_____4EFB_52A1["单位"], "GS_Suspend")
            else
                _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[_____5199_5165_4F4D_7F6E + 1] = _____4EFB_52A1
                _____5199_5165_4F4D_7F6E = _____5199_5165_4F4D_7F6E + 1
            end
            i = i + 1
        end
    end
    while #_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 > _____5199_5165_4F4D_7F6E do
        table.remove(_____786C_76F4_5230_671F_4EFB_52A1_5217_8868)
    end
end
local function _____786E_4FDD_786C_76F4_5230_671F_9A71_52A8()
    if _____786C_76F4_5230_671F_9A71_52A8_5DF2_6CE8_518C then
        return
    end
    _____786C_76F4_5230_671F_9A71_52A8_5DF2_6CE8_518C = true
    addPeriodicCallback(10, ____on_786C_76F4_5230_671F_9A71_52A8)
end
--- 暂停单位一段时间
-- 若单位已在暂停中，会重置暂停时间
-- 
-- @param u 目标单位
-- @param time 暂停时间（秒）
function ____exports.GS_Suspend(u, time)
    if u == nil or u == 0 then
        return
    end
    local uid = hid(u)
    if uid == 0 then
        return
    end
    local _____5230_671F_65F6_95F4_6BEB_79D2 = getServerTime() + RMaxBJ(0, time) * 1000
    local _____4EFB_52A1_7D22_5F15 = _____67E5_627E_786C_76F4_5230_671F_4EFB_52A1_7D22_5F15(uid)
    if _____4EFB_52A1_7D22_5F15 < 0 then
        ____exports["申请单位暂停占用"](u, "GS_Suspend")
        _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[#_____786C_76F4_5230_671F_4EFB_52A1_5217_8868 + 1] = {["单位"] = u, ["单位ID"] = uid, ["到期时间毫秒"] = _____5230_671F_65F6_95F4_6BEB_79D2}
    else
        local _____4EFB_52A1 = _____786C_76F4_5230_671F_4EFB_52A1_5217_8868[_____4EFB_52A1_7D22_5F15 + 1]
        _____4EFB_52A1["单位"] = u
        _____4EFB_52A1["到期时间毫秒"] = _____5230_671F_65F6_95F4_6BEB_79D2
    end
    _____786E_4FDD_786C_76F4_5230_671F_9A71_52A8()
end
--- 检查单位是否处于暂停状态
-- 
-- @param u 目标单位
-- @returns 是否正在暂停中
function ____exports.GS_IsUnitSuspending(u)
    if u == nil or u == 0 then
        return false
    end
    return ____exports.GS_LoadSuspend(u) > 0
end
--- 修改单位暂停时间
-- 
-- @param u 目标单位
-- @param i 操作类型：0=增加时间，1=减少时间，2=取最大值
-- @param r 时间值（秒）
function ____exports.GS_UnitSuspend(u, i, r)
    if u == nil or u == 0 then
        return
    end
    local currentRemain = ____exports.GS_LoadSuspend(u)
    if i == 0 then
        ____exports.GS_Suspend(u, currentRemain + r)
    elseif i == 1 then
        ____exports.GS_Suspend(
            u,
            RMaxBJ(0, currentRemain - r)
        )
    elseif i == 2 then
        ____exports.GS_Suspend(
            u,
            RMaxBJ(currentRemain, r)
        )
    end
end
return ____exports
