local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local stopTimer, jass, systemTimer, isRunning
function stopTimer(self)
    if not isRunning then
        return
    end
    if systemTimer and type(jass.PauseTimer) == "function" then
        jass.PauseTimer(systemTimer)
    end
    isRunning = false
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_GDBC = ____require_result_0.X_GDBC
local X_GAFC = ____require_result_0.X_GAFC
local X_IsTerrainWalkable = ____require_result_0.X_IsTerrainWalkable
local X_GetAbleX = ____require_result_0.X_GetAbleX
local X_GetAbleY = ____require_result_0.X_GetAbleY
local ORDER_MOVE = 851971
local ORDER_SMART = 851986
local TIMER_INTERVAL = 0.02
local TICKS_PER_SEC = 1 / TIMER_INTERVAL
local SPEED_MIN = 1
local SPEED_MAX = 2000
local ENGINE_SPEED_LIMIT = 522
local function hid(self, h)
    return type(jass.GetHandleId) == "function" and (jass.GetHandleId(h) or 0) or 0
end
local function getUnitX(self, u)
    return type(jass.GetUnitX) == "function" and (jass.GetUnitX(u) or 0) or 0
end
local function getUnitY(self, u)
    return type(jass.GetUnitY) == "function" and (jass.GetUnitY(u) or 0) or 0
end
local function getUnitFacing(self, u)
    return type(jass.GetUnitFacing) == "function" and (jass.GetUnitFacing(u) or 0) or 0
end
local function getUnitMoveSpeed(self, u)
    return type(jass.GetUnitMoveSpeed) == "function" and (jass.GetUnitMoveSpeed(u) or 0) or 0
end
local function clampSpeed(self, speed)
    if speed < SPEED_MIN then
        return SPEED_MIN
    end
    if speed > SPEED_MAX then
        return SPEED_MAX
    end
    return speed
end
local entryMap = {}
local entryList = {}
systemTimer = nil
isRunning = false
local function doEvent(self, entry)
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
    local ____temp_1
    if type(jass.GetUnitCurrentOrder) == "function" then
        ____temp_1 = jass.GetUnitCurrentOrder(u)
    else
        ____temp_1 = 0
    end
    local currentOrder = ____temp_1
    if currentOrder ~= ORDER_MOVE and currentOrder ~= ORDER_SMART then
        entry.lx = getUnitX(nil, u)
        entry.ly = getUnitY(nil, u)
        return
    end
    local x = getUnitX(nil, u)
    local y = getUnitY(nil, u)
    local engineSpeed = getUnitMoveSpeed(nil, u)
    local extraSpeed = entry.speed - engineSpeed
    local extraSpeedPerTick = extraSpeed / TICKS_PER_SEC
    local dis = X_GDBC(
        nil,
        x,
        y,
        entry.lx,
        entry.ly
    )
    local dis2 = X_GDBC(
        nil,
        x,
        y,
        entry.tx,
        entry.ty
    )
    local f = getUnitFacing(nil, u)
    if dis > engineSpeed / 60 then
        if math.abs(f) - math.abs(entry.lf) < 2 then
            if dis2 > extraSpeedPerTick then
                local d = X_GAFC(
                    nil,
                    entry.lx,
                    entry.ly,
                    x,
                    y
                )
                local nx = x + math.cos(d * (math.pi / 180)) * extraSpeedPerTick
                local ny = y + math.sin(d * (math.pi / 180)) * extraSpeedPerTick
                if not X_IsTerrainWalkable(nil, nx, ny) then
                    nx = X_GetAbleX(nil)
                    ny = X_GetAbleY(nil)
                end
                entry.lx = nx
                entry.ly = ny
            else
                entry.lx = entry.tx
                entry.ly = entry.ty
            end
            if type(jass.SetUnitX) == "function" then
                jass.SetUnitX(u, entry.lx)
            end
            if type(jass.SetUnitY) == "function" then
                jass.SetUnitY(u, entry.ly)
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
local function startTimer(self)
    if isRunning then
        return
    end
    if not systemTimer then
        local ____temp_2
        if type(jass.CreateTimer) == "function" then
            ____temp_2 = jass.CreateTimer()
        else
            ____temp_2 = nil
        end
        systemTimer = ____temp_2
    end
    if not systemTimer then
        return
    end
    isRunning = true
    jass.TimerStart(
        systemTimer,
        TIMER_INTERVAL,
        true,
        function()
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
            if #entryList == 0 then
                stopTimer(nil)
            end
        end
    )
end
local function removeEntry(self, uid)
    local entry = entryMap[uid]
    if entry == nil then
        return
    end
    if entry.tempTimer and type(jass.DestroyTimer) == "function" then
        jass.DestroyTimer(entry.tempTimer)
        entry.tempTimer = nil
    end
    if entry.t and type(jass.DestroyTrigger) == "function" then
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
local function createTriggerForEntry(self, entry)
    local ____temp_3
    if type(jass.CreateTrigger) == "function" then
        ____temp_3 = jass.CreateTrigger()
    else
        ____temp_3 = nil
    end
    local t = ____temp_3
    entry.t = t
    if t == nil then
        return
    end
    local uid = entry.uid
    if type(jass.TriggerRegisterUnitEvent) == "function" then
        jass.TriggerRegisterUnitEvent(t, entry.u, jass.EVENT_UNIT_ISSUED_POINT_ORDER)
    end
    if type(jass.TriggerAddAction) == "function" then
        jass.TriggerAddAction(
            t,
            function()
                local e = entryMap[uid]
                if e == nil then
                    return
                end
                e.tx = type(jass.GetOrderPointX) == "function" and (jass.GetOrderPointX() or 0) or 0
                e.ty = type(jass.GetOrderPointY) == "function" and (jass.GetOrderPointY() or 0) or 0
            end
        )
    end
end
--- 设置单位移动速度突破（永久）
-- 若单位已在系统中（含临时加速中），取消临时计时器并覆盖为永久速度
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
        if existing.tempTimer and type(jass.DestroyTimer) == "function" then
            jass.DestroyTimer(existing.tempTimer)
            existing.tempTimer = nil
        end
        existing.speed = speed
        existing.originalSpeed = speed
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
        listIndex = #entryList
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
        if existing.tempTimer and type(jass.DestroyTimer) == "function" then
            jass.DestroyTimer(existing.tempTimer)
            existing.tempTimer = nil
        end
        existing.speed = speed
        existing.originalSpeed = savedOriginal
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
            listIndex = #entryList
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
    local ____temp_4
    if type(jass.CreateTimer) == "function" then
        ____temp_4 = jass.CreateTimer()
    else
        ____temp_4 = nil
    end
    local tempT = ____temp_4
    current.tempTimer = tempT
    if tempT then
        jass.TimerStart(
            tempT,
            duration,
            false,
            function()
                local e = entryMap[uid]
                if e == nil or e.tempTimer ~= tempT then
                    return
                end
                e.tempTimer = nil
                if e.originalSpeed > ENGINE_SPEED_LIMIT then
                    e.speed = e.originalSpeed
                else
                    removeEntry(nil, uid)
                end
            end
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
