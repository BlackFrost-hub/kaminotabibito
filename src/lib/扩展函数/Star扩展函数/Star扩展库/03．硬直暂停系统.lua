local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- Star扩展库 - 硬直/暂停系统
-- 
-- 来源于 SUSPEND.j，提供单位暂停控制功能。
-- 通过 EXPauseUnit(japi) 暂停单位，计时器到期后自动恢复。
-- 支持暂停时间累加、减少、取最大值等操作。
-- 
-- 公开接口：
--   GS_Suspend(u, time)          - 暂停单位一段时间
--   GS_IsUnitSuspending(u)       - 检查单位是否处于暂停状态
--   GS_LoadSuspend(u)            - 获取单位剩余暂停时间
--   GS_UnitSuspend(u, i, r)      - 修改暂停时间（0=增加，1=减少，2=取最大值）
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local RMaxBJ = ____require_result_0.RMaxBJ
local ____require_result_1 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_1.safeTimerStart
local safeDestroyTimer = ____require_result_1.safeDestroyTimer
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
local HS_S = jass:InitHashtable()
local PauseUnit = jass.PauseUnit
local _____5355_4F4D_6682_505C_5360_7528_603B_8868 = {}
local _____5355_4F4D_6682_505C_5360_7528_6765_6E90_8868 = {}
local function hid(h)
    return jass:GetHandleId(h) or 0
end
local function _____8BBE_7F6E_5E95_5C42_6682_505C_72B6_6001(u, _____662F_5426_6682_505C)
    if u == nil or u == 0 then
        return
    end
    if japi ~= nil and type(japi.EXPauseUnit) == "function" then
        local EXPauseUnit = japi.EXPauseUnit
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
local function onHardStraightTimerExpire()
    local expiredTimer = jass:GetExpiredTimer()
    local tid = hid(expiredTimer)
    local savedUnit = jass:LoadUnitHandle(HS_S, tid, 1)
    if savedUnit ~= nil and savedUnit ~= 0 then
        ____exports["释放单位暂停占用"](savedUnit, "GS_Suspend")
    end
    jass:FlushChildHashtable(HS_S, tid)
    if savedUnit ~= nil and savedUnit ~= 0 then
        jass:FlushChildHashtable(
            HS_S,
            hid(savedUnit)
        )
    end
    safeDestroyTimer(nil, expiredTimer)
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
    local T = jass:LoadTimerHandle(HS_S, uid, 1)
    local ____temp_2
    if T ~= nil then
        ____temp_2 = jass:TimerGetRemaining(T)
    else
        ____temp_2 = 0
    end
    local remaining = ____temp_2
    if T == nil or remaining == 0 then
        T = jass:CreateTimer()
        if T == nil then
            return
        end
        ____exports["申请单位暂停占用"](u, "GS_Suspend")
        jass:SaveUnitHandle(
            HS_S,
            hid(T),
            1,
            u
        )
        jass:SaveTimerHandle(HS_S, uid, 1, T)
    end
    safeTimerStart(
        nil,
        T,
        time,
        false,
        onHardStraightTimerExpire
    )
end
--- 检查单位是否处于暂停状态
-- 
-- @param u 目标单位
-- @returns 是否正在暂停中
function ____exports.GS_IsUnitSuspending(u)
    if u == nil or u == 0 then
        return false
    end
    local T = jass:LoadTimerHandle(
        HS_S,
        hid(u),
        1
    )
    if T == nil then
        return false
    end
    local remaining = jass:TimerGetRemaining(T)
    return remaining ~= 0
end
--- 获取单位剩余暂停时间
-- 
-- @param u 目标单位
-- @returns 剩余暂停时间（秒）
function ____exports.GS_LoadSuspend(u)
    if u == nil or u == 0 then
        return 0
    end
    local T = jass:LoadTimerHandle(
        HS_S,
        hid(u),
        1
    )
    if T == nil then
        return 0
    end
    local remaining = jass:TimerGetRemaining(T)
    return remaining or 0
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
