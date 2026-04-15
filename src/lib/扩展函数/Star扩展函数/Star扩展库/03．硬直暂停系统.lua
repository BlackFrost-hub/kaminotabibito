--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
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
local ____temp_0
if type(jass.InitHashtable) == "function" then
    ____temp_0 = jass.InitHashtable()
else
    ____temp_0 = nil
end
local HS_S = ____temp_0
local function hid(self, h)
    return type(jass.GetHandleId) == "function" and (jass.GetHandleId(h) or 0) or 0
end
--- 暂停单位一段时间
-- 若单位已在暂停中，会重置暂停时间
-- 
-- @param u 目标单位
-- @param time 暂停时间（秒）
function ____exports.GS_Suspend(self, u, time)
    if u == nil or u == 0 or HS_S == nil then
        return
    end
    local uid = hid(nil, u)
    local ____temp_1
    if type(jass.LoadTimerHandle) == "function" then
        ____temp_1 = jass.LoadTimerHandle(HS_S, uid, 1)
    else
        ____temp_1 = nil
    end
    local T = ____temp_1
    local ____temp_2
    if T ~= nil and type(jass.TimerGetRemaining) == "function" then
        ____temp_2 = jass.TimerGetRemaining(T)
    else
        ____temp_2 = 0
    end
    local remaining = ____temp_2
    if T == nil or remaining == 0 then
        local ____temp_3
        if type(jass.CreateTimer) == "function" then
            ____temp_3 = jass.CreateTimer()
        else
            ____temp_3 = nil
        end
        T = ____temp_3
        if T == nil then
            return
        end
        if japi ~= nil and type(japi.EXPauseUnit) == "function" then
            japi.EXPauseUnit(u, true)
        end
        if type(jass.SaveUnitHandle) == "function" then
            jass.SaveUnitHandle(
                HS_S,
                hid(nil, T),
                1,
                u
            )
        end
        if type(jass.SaveTimerHandle) == "function" then
            jass.SaveTimerHandle(HS_S, uid, 1, T)
        end
    end
    if type(jass.TimerStart) ~= "function" then
        return
    end
    local timerRef = T
    jass.TimerStart(
        timerRef,
        time,
        false,
        function()
            local ____temp_4
            if type(jass.GetExpiredTimer) == "function" then
                ____temp_4 = jass.GetExpiredTimer()
            else
                ____temp_4 = timerRef
            end
            local expiredTimer = ____temp_4
            local tid = hid(nil, expiredTimer)
            local ____temp_5
            if type(jass.LoadUnitHandle) == "function" then
                ____temp_5 = jass.LoadUnitHandle(HS_S, tid, 1)
            else
                ____temp_5 = nil
            end
            local savedUnit = ____temp_5
            if savedUnit ~= nil and savedUnit ~= 0 then
                if japi ~= nil and type(japi.EXPauseUnit) == "function" then
                    japi.EXPauseUnit(savedUnit, false)
                end
            end
            if type(jass.FlushChildHashtable) == "function" then
                jass.FlushChildHashtable(HS_S, tid)
                if savedUnit ~= nil and savedUnit ~= 0 then
                    jass.FlushChildHashtable(
                        HS_S,
                        hid(nil, savedUnit)
                    )
                end
            end
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(expiredTimer)
            end
        end
    )
end
--- 检查单位是否处于暂停状态
-- 
-- @param u 目标单位
-- @returns 是否正在暂停中
function ____exports.GS_IsUnitSuspending(self, u)
    if u == nil or u == 0 or HS_S == nil then
        return false
    end
    local ____temp_6
    if type(jass.LoadTimerHandle) == "function" then
        ____temp_6 = jass.LoadTimerHandle(
            HS_S,
            hid(nil, u),
            1
        )
    else
        ____temp_6 = nil
    end
    local T = ____temp_6
    if T == nil then
        return false
    end
    local ____temp_7
    if type(jass.TimerGetRemaining) == "function" then
        ____temp_7 = jass.TimerGetRemaining(T)
    else
        ____temp_7 = 0
    end
    local remaining = ____temp_7
    return remaining ~= 0
end
--- 获取单位剩余暂停时间
-- 
-- @param u 目标单位
-- @returns 剩余暂停时间（秒）
function ____exports.GS_LoadSuspend(self, u)
    if u == nil or u == 0 or HS_S == nil then
        return 0
    end
    local ____temp_8
    if type(jass.LoadTimerHandle) == "function" then
        ____temp_8 = jass.LoadTimerHandle(
            HS_S,
            hid(nil, u),
            1
        )
    else
        ____temp_8 = nil
    end
    local T = ____temp_8
    if T == nil then
        return 0
    end
    local ____temp_9
    if type(jass.TimerGetRemaining) == "function" then
        ____temp_9 = jass.TimerGetRemaining(T)
    else
        ____temp_9 = 0
    end
    local remaining = ____temp_9
    return remaining or 0
end
--- 修改单位暂停时间
-- 
-- @param u 目标单位
-- @param i 操作类型：0=增加时间，1=减少时间，2=取最大值
-- @param r 时间值（秒）
function ____exports.GS_UnitSuspend(self, u, i, r)
    if u == nil or u == 0 or HS_S == nil then
        return
    end
    local currentRemain = ____exports.GS_LoadSuspend(nil, u)
    if i == 0 then
        ____exports.GS_Suspend(nil, u, currentRemain + r)
    elseif i == 1 then
        ____exports.GS_Suspend(
            nil,
            u,
            math.max(0, currentRemain - r)
        )
    elseif i == 2 then
        ____exports.GS_Suspend(
            nil,
            u,
            math.max(currentRemain, r)
        )
    end
end
return ____exports
