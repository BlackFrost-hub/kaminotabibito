--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - 硬直/暂停系统
-- 
-- 提供单位暂停控制功能，支持暂停时间累加、减少、取最大值等操作。
local jass = require("jass.common")
local japi = require("jass.japi")
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
-- 
-- @param u 目标单位
-- @param time 暂停时间（秒）
function ____exports.GS_Suspend(self, u, time)
    if not u or not HS_S then
        return
    end
    local uid = hid(nil, u)
    local T = jass.LoadTimerHandle(HS_S, uid, 1)
    if not T or jass.TimerGetRemaining(T) == 0 then
        T = jass.CreateTimer()
        if type(japi.EXPauseUnit) == "function" then
            japi.EXPauseUnit(u, true)
        end
        jass.SaveUnitHandle(
            HS_S,
            hid(nil, T),
            1,
            u
        )
        jass.SaveTimerHandle(HS_S, uid, 1, T)
    end
    jass.TimerStart(
        T,
        time,
        false,
        function()
            local expiredTimer = jass.GetExpiredTimer()
            local savedUnit = jass.LoadUnitHandle(
                HS_S,
                hid(nil, expiredTimer),
                1
            )
            if type(japi.EXPauseUnit) == "function" then
                japi.EXPauseUnit(savedUnit, false)
            end
            jass.FlushChildHashtable(
                HS_S,
                hid(nil, expiredTimer)
            )
            jass.FlushChildHashtable(
                HS_S,
                hid(nil, savedUnit)
            )
            jass.DestroyTimer(expiredTimer)
        end
    )
end
--- 检查单位是否处于暂停状态
-- 
-- @param u 目标单位
-- @returns 是否正在暂停中
function ____exports.GS_IsUnitSuspending(self, u)
    if not u or not HS_S then
        return false
    end
    local T = jass.LoadTimerHandle(
        HS_S,
        hid(nil, u),
        1
    )
    if not T then
        return false
    end
    return jass.TimerGetRemaining(T) ~= 0
end
--- 获取单位剩余暂停时间
-- 
-- @param u 目标单位
-- @returns 剩余暂停时间（秒）
function ____exports.GS_LoadSuspend(self, u)
    if not u or not HS_S then
        return 0
    end
    local T = jass.LoadTimerHandle(
        HS_S,
        hid(nil, u),
        1
    )
    if not T then
        return 0
    end
    return jass.TimerGetRemaining(T) or 0
end
--- 修改单位暂停时间
-- 
-- @param u 目标单位
-- @param i 操作类型：0=增加时间，1=减少时间，2=取最大值
-- @param r 时间值（秒）
function ____exports.GS_UnitSuspend(self, u, i, r)
    if not u or not HS_S then
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
