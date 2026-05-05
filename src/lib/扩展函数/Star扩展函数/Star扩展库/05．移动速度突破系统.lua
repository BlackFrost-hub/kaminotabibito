local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local hid, getUnitX, getUnitY, getUnitFacing, getUnitMoveSpeed, removeSpeedEffect, doEvent, removeEntry, jass, safeDestroyTimer, X_GDBC, X_GAFC, X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY, ORDER_MOVE, ORDER_SMART, TIMER_INTERVAL, ENGINE_SPEED_LIMIT, BJ_DEGTORAD, entryMap, entryList, triggerUnitSpeedEntryUidByTriggerHid, _tickCounter
function hid(self, h)
    return jass.GetHandleId(h) or 0
end
function getUnitX(self, u)
    return jass.GetUnitX(u) or 0
end
function getUnitY(self, u)
    return jass.GetUnitY(u) or 0
end
function getUnitFacing(self, u)
    return jass.GetUnitFacing(u) or 0
end
function getUnitMoveSpeed(self, u)
    return jass.GetUnitMoveSpeed(u) or 0
end
function removeSpeedEffect(self, effect)
    if not effect then
        return
    end
    jass.DestroyEffect(effect)
end
function doEvent(self, entry)
    local u = entry.u
    if u == nil or u == 0 then
        return
    end
    if entry.speed <= ENGINE_SPEED_LIMIT then
        entry.lx = getUnitX(nil, u)
        entry.ly = getUnitY(nil, u)
        entry.lf = getUnitFacing(nil, u)
        return
    end
    local currentOrder = jass.GetUnitCurrentOrder(u)
    if currentOrder ~= ORDER_MOVE and currentOrder ~= ORDER_SMART then
        entry.lx = getUnitX(nil, u)
        entry.ly = getUnitY(nil, u)
        return
    end
    local x = getUnitX(nil, u)
    local y = getUnitY(nil, u)
    local f = getUnitFacing(nil, u)
    local tgtU = jass.GetOrderTargetUnit()
    if tgtU ~= nil and tgtU ~= 0 then
        entry.tx = getUnitX(nil, tgtU)
        entry.ty = getUnitY(nil, tgtU)
    end
    local dx = entry.tx - x
    local dy = entry.ty - y
    local dist = X_GDBC(
        nil,
        x,
        y,
        entry.tx,
        entry.ty
    )
    if dist > 10 then
        local angle = X_GAFC(
            nil,
            x,
            y,
            entry.tx,
            entry.ty
        )
        local engineSpeed = getUnitMoveSpeed(nil, u)
        local speedDiff = entry.speed - engineSpeed
        if speedDiff > 0 then
            local moveDist = speedDiff * TIMER_INTERVAL
            local rad = angle * BJ_DEGTORAD
            local nx = x + moveDist * jass.Cos(rad)
            local ny = y + moveDist * jass.Sin(rad)
            if X_IsTerrainWalkable(nil, nx, ny) then
                jass.SetUnitX(u, nx)
                jass.SetUnitY(u, ny)
                entry.lx = nx
                entry.ly = ny
            else
                local ableX = X_GetAbleX(nil)
                local ableY = X_GetAbleY(nil)
                if ableX ~= 0 or ableY ~= 0 then
                    jass.SetUnitX(u, ableX)
                    jass.SetUnitY(u, ableY)
                    entry.lx = ableX
                    entry.ly = ableY
                else
                    entry.lx = x
                    entry.ly = y
                end
            end
        else
            entry.lx = x
            entry.ly = y
        end
    else
        entry.lx = x
        entry.ly = y
    end
    entry.lf = f
end
function removeEntry(self, uid)
    local entry = entryMap[uid]
    if entry == nil then
        return
    end
    if entry.effect then
        removeSpeedEffect(nil, entry.effect)
        entry.effect = nil
    end
    if entry.tempTimer then
        safeDestroyTimer(nil, entry.tempTimer)
        entry.tempTimer = nil
    end
    if entry.t then
        __TS__Delete(
            triggerUnitSpeedEntryUidByTriggerHid,
            hid(nil, entry.t)
        )
        jass.DestroyTrigger(entry.t)
        entry.t = nil
    end
    entry.u = nil
    local idx = entry.listIndex
    local lastIdx = #entryList - 1
    if idx ~= lastIdx then
        local lastEntry = entryList[lastIdx + 1]
        entryList[idx + 1] = lastEntry
        lastEntry.listIndex = idx
    end
    table.remove(entryList)
    __TS__Delete(entryMap, uid)
end
jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
X_GDBC = ____require_result_1.X_GDBC
X_GAFC = ____require_result_1.X_GAFC
X_IsTerrainWalkable = ____require_result_1.X_IsTerrainWalkable
X_GetAbleX = ____require_result_1.X_GetAbleX
X_GetAbleY = ____require_result_1.X_GetAbleY
local unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
ORDER_MOVE = 851971
ORDER_SMART = 851986
TIMER_INTERVAL = 0.02
local TICKS_PER_SEC = 1 / TIMER_INTERVAL
--- 中心计时器每10毫秒tick一次，每2次tick执行一次移动速度更新
local CENTER_TIMER_TICKS = 2
local SPEED_MIN = 1
local SPEED_MAX = 2000
ENGINE_SPEED_LIMIT = 522
local ____jglobals_bj_DEGTORAD_2 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_2 == nil then
    ____jglobals_bj_DEGTORAD_2 = 0.017453292519943295
end
BJ_DEGTORAD = ____jglobals_bj_DEGTORAD_2
--- 移动速度突破特效模型路径
local SPEED_EFFECT_MODEL = "resource\\models\\windwalk.mdx"
local function clampSpeed(self, speed)
    if speed < SPEED_MIN then
        return SPEED_MIN
    end
    if speed > SPEED_MAX then
        return SPEED_MAX
    end
    return speed
end
entryMap = {}
entryList = {}
local systemTimer = nil
local isRunning = false
triggerUnitSpeedEntryUidByTriggerHid = {}
local speedBreakTempTimerCtxByHid = {}
local function onSpeedBreakTempTimerExpire(self)
    local t = jass.GetExpiredTimer()
    local uid = speedBreakTempTimerCtxByHid[hid(nil, t)]
    __TS__Delete(
        speedBreakTempTimerCtxByHid,
        hid(nil, t)
    )
    local e = entryMap[uid]
    if e == nil or e.tempTimer ~= t then
        return
    end
    e.tempTimer = nil
    if e.originalSpeed > ENGINE_SPEED_LIMIT then
        e.speed = e.originalSpeed
    else
        removeEntry(nil, uid)
    end
    safeDestroyTimer(nil, t)
end
local function onMoveSpeedBreakTick(self)
    if not isRunning then
        return
    end
    _tickCounter = _tickCounter + 1
    if _tickCounter >= CENTER_TIMER_TICKS then
        _tickCounter = 0
        local count = #entryList
        do
            local i = 0
            while i < count do
                local entry = entryList[i + 1]
                if entry and entryMap[entry.uid] == entry then
                    doEvent(nil, entry)
                end
                i = i + 1
            end
        end
    end
end
--- 为单位添加移动速度突破特效
local function addSpeedEffect(self, u)
    if not u then
        return nil
    end
    local effect = jass.AddSpecialEffectTarget(SPEED_EFFECT_MODEL, u, "origin")
    return effect
end
--- 是否已注册到中心计时器
local _registeredToCenterTimer = false
--- tick计数器
_tickCounter = 0
local function startTimer(self)
    if isRunning then
        return
    end
    isRunning = true
    if _registeredToCenterTimer then
        return
    end
    _registeredToCenterTimer = true
    local ____G_3 = _G
    local onTick10ms = ____G_3.onTick10ms
    onTick10ms(onMoveSpeedBreakTick)
end
local function stopTimer(self)
    isRunning = false
end
--- 同步「突破位移」用的目标点：仅监听点指令时，右键单位/物品不会刷新 tx/ty，
-- 仍朝上次地面点硬拉，会与引擎寻路冲突导致原地踏步。
local function syncEntryOrderDestination(self, e)
    local tgtU = jass.GetOrderTargetUnit()
    if tgtU ~= nil and tgtU ~= 0 then
        e.tx = getUnitX(nil, tgtU)
        e.ty = getUnitY(nil, tgtU)
        return
    end
    local tgtIt = jass.GetOrderTargetItem()
    if tgtIt ~= nil and tgtIt ~= 0 then
        e.tx = jass.GetItemX(tgtIt) or 0
        e.ty = jass.GetItemY(tgtIt) or 0
        return
    end
    e.tx = jass.GetOrderPointX() or 0
    e.ty = jass.GetOrderPointY() or 0
end
local function onSpeedEntryOrderTargetChanged(self)
    local trig = jass.GetTriggeringTrigger()
    if trig == nil or trig == 0 then
        return
    end
    local uid = triggerUnitSpeedEntryUidByTriggerHid[hid(nil, trig)]
    if not uid then
        return
    end
    local e = entryMap[uid]
    if e == nil then
        return
    end
    syncEntryOrderDestination(nil, e)
end
local function createTriggerForEntry(self, entry)
    local t = jass.CreateTrigger()
    entry.t = t
    if t == nil then
        return
    end
    local uid = entry.uid
    triggerUnitSpeedEntryUidByTriggerHid[hid(nil, t)] = uid
    unitSpecificEventCenter.registerUnitEventTrigger(t, entry.u, jass.EVENT_UNIT_ISSUED_POINT_ORDER)
    local evTarget = jass.EVENT_UNIT_ISSUED_TARGET_ORDER
    if evTarget ~= nil then
        unitSpecificEventCenter.registerUnitEventTrigger(t, entry.u, evTarget)
    end
    jass.TriggerAddAction(t, onSpeedEntryOrderTargetChanged)
end
--- 设置单位移动速度突破（永久）
-- 若单位已在系统中（含临时加速中），取消临时计时器并覆盖为永久速度
-- 若速度未超过522，自动取消注册
-- 
-- @param u 目标单位
-- @param speed 目标移动速度（限制在1~2000）
function ____exports.SOS_SetUnitSpeed(self, u, speed)
    if u == nil or u == 0 then
        return
    end
    speed = clampSpeed(nil, speed)
    local uid = hid(nil, u)
    if speed <= ENGINE_SPEED_LIMIT then
        removeEntry(nil, uid)
        return
    end
    local existing = entryMap[uid]
    if existing ~= nil then
        if existing.tempTimer then
            safeDestroyTimer(nil, existing.tempTimer)
            existing.tempTimer = nil
        end
        existing.speed = speed
        existing.originalSpeed = speed
        if not existing.effect then
            existing.effect = addSpeedEffect(nil, u)
        end
        return
    end
    local entry = {
        speed = speed,
        originalSpeed = speed,
        u = u,
        uid = uid,
        t = nil,
        tx = 0,
        ty = 0,
        lx = getUnitX(nil, u),
        ly = getUnitY(nil, u),
        lf = getUnitFacing(nil, u),
        tempTimer = nil,
        listIndex = #entryList,
        effect = addSpeedEffect(nil, u)
    }
    createTriggerForEntry(nil, entry)
    entryMap[uid] = entry
    entryList[#entryList + 1] = entry
    startTimer(nil)
end
--- 设置单位移动速度突破（临时，持续一段时间后恢复）
-- 若单位已有永久速度，到期后恢复为永久速度；
-- 若单位原本不在系统中，到期后自动移除。
-- 
-- @param u 目标单位
-- @param speed 目标移动速度（限制在1~2000）
-- @param duration 持续时间（秒）
function ____exports.SOS_SetUnitSpeedTemp(self, u, speed, duration)
    if u == nil or u == 0 then
        return
    end
    if duration <= 0 then
        ____exports.SOS_SetUnitSpeed(nil, u, speed)
        return
    end
    speed = clampSpeed(nil, speed)
    local uid = hid(nil, u)
    local existing = entryMap[uid]
    if speed <= ENGINE_SPEED_LIMIT and existing == nil then
        return
    end
    local savedOriginal = existing ~= nil and existing.originalSpeed or 0
    if existing ~= nil then
        if existing.tempTimer then
            jass.DestroyTimer(existing.tempTimer)
            existing.tempTimer = nil
        end
        existing.speed = speed
        existing.originalSpeed = savedOriginal
        if not existing.effect then
            existing.effect = addSpeedEffect(nil, u)
        end
    else
        local entry = {
            speed = speed,
            originalSpeed = 0,
            u = u,
            uid = uid,
            t = nil,
            tx = 0,
            ty = 0,
            lx = getUnitX(nil, u),
            ly = getUnitY(nil, u),
            lf = getUnitFacing(nil, u),
            tempTimer = nil,
            listIndex = #entryList,
            effect = addSpeedEffect(nil, u)
        }
        createTriggerForEntry(nil, entry)
        entryMap[uid] = entry
        entryList[#entryList + 1] = entry
        startTimer(nil)
    end
    local current = entryMap[uid]
    if current == nil then
        return
    end
    local tempT = jass.CreateTimer()
    current.tempTimer = tempT
    if tempT then
        speedBreakTempTimerCtxByHid[hid(nil, tempT)] = uid
        safeTimerStart(
            nil,
            tempT,
            duration,
            false,
            onSpeedBreakTempTimerExpire
        )
    end
end
--- 获取单位当前突破移动速度
-- 若单位不在系统中，返回引擎当前移动速度
-- 
-- @param u 目标单位
-- @returns 移动速度
function ____exports.SOS_GetUnitSpeed(self, u)
    if u == nil or u == 0 then
        return 0
    end
    local uid = hid(nil, u)
    local entry = entryMap[uid]
    if entry ~= nil then
        return entry.speed
    end
    return getUnitMoveSpeed(nil, u)
end
--- 取消单位移动速度突破
-- 
-- @param u 目标单位
function ____exports.SOS_UnSetUnitSpeed(self, u)
    if u == nil or u == 0 then
        return
    end
    local uid = hid(nil, u)
    removeEntry(nil, uid)
end
return ____exports
