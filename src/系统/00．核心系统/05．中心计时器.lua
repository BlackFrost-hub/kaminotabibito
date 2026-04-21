local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__StringPadStart = ____lualib.__TS__StringPadStart
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local ____exports = {}
---
-- @file 系统/00．核心系统/05．中心计时器.ts
-- @module 中心计时器
-- 
-- ## 职责
-- 全图唯一「逻辑时钟」：用 **0.01s 周期** 驱动游戏内时间、日历缓存、以及与 JASS 全局变量的同步。
-- 其它系统需要「游戏时间 / 定时回调」时应 **require 本模块**，不要各自再建 `CreateTimer(0.01)`。
-- 
-- ## 引用
-- - 推荐：`require("系统.00．核心系统.05．中心计时器")`
-- - 或经 `系统.00．核心系统.index` 的 `export *` 再导入同名导出。
-- 
-- ## 时间模型（内部状态）
-- - **nowMs** ≈ `_serverTime + _millisCounter * 10`：`getServerTime()` / 多数逻辑用的「毫秒」。
-- - **服务器锚点**：`initCenterTimer` 内 `DzAPI_Map_GetGameStartTime()` → `_serverTime`（毫秒档，每秒整 tick 时 +1000）。
-- - **游戏经过时间**：`_gameElapsedTime`（秒，含小数），写入 `jass.globals.udg_Elapsed`（若存在）。
-- - **游戏内 [秒,分,时]**：`_gameTimeHMS`，每秒推进并写入 `jass.udg_Time[0..2]`（若存在）。
-- - **日历**：`calcDate` / `updateDate` 与旧版 JASS `gettime.j` 一致：`BASE_TIMESTAMP`(2015-01-01 UTC) + `TIMEZONE_OFFSET`(东八区秒)。
-- 
-- ## 回调分层（均在 `onTick` 内按序执行）
-- 1. **每 10ms**：`onTick10ms` 注册的回调（全部调用）。
-- 2. **周期性**：`addPeriodicCallback`（按间隔与 `nowMs` 比较）。
-- 3. **每 1s**（每满 100 次 10ms tick）：`calcDate`、`udg_Time`、然后 `onSecond` 回调。
-- 
-- ## 对外导出（摘要）
-- - **读时间**：`getServerTime`、`getTime(0..7)`、`getGameTime`、`getGameElapsedTime`、`getGameTimeHMS`、
-- `getGameTimeFormatted` / `getGameTimeString*`、`getDateTimeString*`。
-- - **难度**：`getGameDifficulty` / `setGameDifficulty`（初始化时从 `udg_N` 读一次）。
-- - **注册回调**：`onTick10ms` / `offTick10ms`、`onSecond` / `offSecond`、`addPeriodicCallback` / `removePeriodicCallback`。
-- - **显式初始化**：`initCenterTimer`（幂等）；文件末尾另有 **0s 延迟单次计时器** 自动调用，一般无需手动调。
-- 
-- ## 副作用
-- 模块加载即注册 `TimerStart(..., 0, false, initCenterTimer)`，游戏开始后一帧内拉起主循环。
local jass = require("jass.common")
local japi = require("jass.japi")
local jassGlobals = require("jass.globals")
local NORMAL_MON_DAYS = {
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
}
local BASE_TIMESTAMP = 1451606400
local TIMEZONE_OFFSET = 28800
local _serverTime = 0
local _millisCounter = 0
local _initialized = false
--- 仅用于 `TimerStart(..., 0, false, initCenterTimer)` 的引导计时器，进入 `initCenterTimer` 后必须销毁，否则会永久占一个句柄。
local bootstrapTimer = nil
local _gameDifficulty = 1
local _gameElapsedTime = 0
local _gameTimeHMS = {0, 0, 0}
local _timeCache = {
    year = 2016,
    month = 1,
    day = 1,
    hour = 0,
    minute = 0,
    second = 0,
    millisecond = 0,
    weekday = 0
}
local _secondCallbacks = {}
local _tickCallbacks = {}
--- 当前逻辑毫秒（与 getServerTime 一致）
local function nowMs(self)
    return _serverTime + _millisCounter * 10
end
local function mathMod(self, dividend, divisor)
    local m = dividend - math.floor(dividend / divisor) * divisor
    if m < 0 then
        m = m + divisor
    end
    return m
end
local function isLeapYear(self, y)
    return y % 4 == 0 and y % 100 ~= 0 or y % 400 == 0
end
local function getMonthDays(self, y, m)
    return m == 2 and isLeapYear(nil, y) and 29 or NORMAL_MON_DAYS[m + 1]
end
local function updateDate(self, y, remainSec, dayBy2015)
    local dayNum = remainSec / 86400
    local totalDay = math.floor(dayNum)
    if dayNum - totalDay > 0 then
        totalDay = totalDay + 1
    end
    if totalDay == 0 then
        totalDay = 1
    end
    dayBy2015 = dayBy2015 + totalDay
    local remainDay = totalDay
    do
        local m = 1
        while m <= 12 do
            local curMonDay = getMonthDays(nil, y, m)
            if remainDay <= curMonDay then
                _timeCache.year = y
                _timeCache.month = m
                _timeCache.day = remainDay
                _timeCache.hour = mathMod(
                    nil,
                    math.floor(remainSec / 3600),
                    24
                )
                _timeCache.minute = mathMod(
                    nil,
                    math.floor(remainSec / 60),
                    60
                )
                _timeCache.second = mathMod(nil, remainSec, 60)
                _timeCache.millisecond = _millisCounter * 10
                _timeCache.weekday = mathMod(
                    nil,
                    mathMod(nil, dayBy2015, 7) + 4,
                    7
                )
                return
            end
            remainDay = remainDay - curMonDay
            m = m + 1
        end
    end
end
local function calcDate(self, now)
    local remain = now - BASE_TIMESTAMP + TIMEZONE_OFFSET
    local y = 2016
    local dayBy2015 = 0
    while y <= 3000 do
        local baseRemain = remain
        local baseDayBy2015 = dayBy2015
        if isLeapYear(nil, y) then
            remain = remain - 31622400
            dayBy2015 = dayBy2015 + 366
        else
            remain = remain - 31536000
            dayBy2015 = dayBy2015 + 365
        end
        if remain < 0 then
            updateDate(nil, y, baseRemain, baseDayBy2015)
            return
        end
        y = y + 1
    end
end
local TIME_GET_KEYS = {
    "year",
    "month",
    "day",
    "hour",
    "minute",
    "second",
    "weekday",
    "millisecond"
}
local function removeFnFromArray(self, arr, fn)
    local i = __TS__ArrayIndexOf(arr, fn)
    if i > -1 then
        __TS__ArraySplice(arr, i, 1)
    end
end
local function pad2(self, n)
    return __TS__StringPadStart(
        tostring(n),
        2,
        "0"
    )
end
local function pad3(self, n)
    return __TS__StringPadStart(
        tostring(n),
        3,
        "0"
    )
end
local _periodicCallbackIdCounter = 0
local _periodicCallbacks = {}
local _delayedCallbackIdCounter = 0
local _delayedCallbacks = {}
local function runPeriodicCallbacks(self)
    local now = nowMs(nil)
    for ____, p in ipairs(_periodicCallbacks) do
        if now - p.lastRunTime >= p.intervalMs then
            p.lastRunTime = now
            p:callback()
        end
    end
end
local function runDelayedCallbacks(self)
    local now = nowMs(nil)
    local writeIndex = 0
    do
        local i = 0
        while i < #_delayedCallbacks do
            do
                local d = _delayedCallbacks[i + 1]
                if not d.active then
                    goto __continue28
                end
                if now >= d.dueTime then
                    d.active = false
                    d:callback()
                else
                    _delayedCallbacks[writeIndex + 1] = d
                    writeIndex = writeIndex + 1
                end
            end
            ::__continue28::
            i = i + 1
        end
    end
    do
        local i = #_delayedCallbacks - 1
        while i >= writeIndex do
            table.remove(_delayedCallbacks)
            i = i - 1
        end
    end
end
local function onTick(self)
    _millisCounter = _millisCounter + 1
    _gameElapsedTime = _gameElapsedTime + 0.01
    if jassGlobals.udg_Elapsed ~= nil then
        jassGlobals.udg_Elapsed = _gameElapsedTime
    end
    for ____, cb in ipairs(_tickCallbacks) do
        cb(nil)
    end
    runPeriodicCallbacks(nil)
    runDelayedCallbacks(nil)
    if _millisCounter < 100 then
        return
    end
    _millisCounter = 0
    _serverTime = _serverTime + 1000
    calcDate(nil, _serverTime / 1000)
    _gameTimeHMS[1] = _gameTimeHMS[1] + 1
    if _gameTimeHMS[1] >= 60 then
        _gameTimeHMS[1] = 0
        _gameTimeHMS[2] = _gameTimeHMS[2] + 1
        if _gameTimeHMS[2] >= 60 then
            _gameTimeHMS[2] = 0
            _gameTimeHMS[3] = _gameTimeHMS[3] + 1
        end
    end
    local jt = jass.udg_Time
    if jt ~= nil then
        jt[0] = _gameTimeHMS[1]
        jt[1] = _gameTimeHMS[2]
        jt[2] = _gameTimeHMS[3]
    end
    for ____, cb in ipairs(_secondCallbacks) do
        cb(nil)
    end
end
function ____exports.getServerTime(self)
    return nowMs(nil)
end
function ____exports.getTime(self, i)
    if i < 0 or i > 7 then
        return 0
    end
    return _timeCache[TIME_GET_KEYS[i + 1]]
end
function ____exports.getGameTime(self)
    return nowMs(nil) - (_initialized and _serverTime or 0)
end
function ____exports.getGameElapsedTime(self)
    return _gameElapsedTime
end
function ____exports.getGameTimeHMS(self)
    return {_gameTimeHMS[1], _gameTimeHMS[2], _gameTimeHMS[3]}
end
function ____exports.getGameTimeFormatted(self)
    local totalMs = nowMs(nil)
    local totalSec = math.floor(totalMs / 1000)
    return {
        hours = math.floor(totalSec / 3600),
        minutes = math.floor(totalSec % 3600 / 60),
        seconds = math.floor(totalSec % 60),
        milliseconds = totalMs % 1000,
        totalMs = totalMs
    }
end
function ____exports.getGameTimeString(self)
    local ____exports_getGameTimeFormatted_result_0 = ____exports.getGameTimeFormatted(nil)
    local hours = ____exports_getGameTimeFormatted_result_0.hours
    local minutes = ____exports_getGameTimeFormatted_result_0.minutes
    local seconds = ____exports_getGameTimeFormatted_result_0.seconds
    return ((((tostring(hours) .. "小时") .. tostring(minutes)) .. "分") .. tostring(seconds)) .. "秒"
end
function ____exports.getGameTimeStringWithMs(self)
    local ____exports_getGameTimeFormatted_result_1 = ____exports.getGameTimeFormatted(nil)
    local hours = ____exports_getGameTimeFormatted_result_1.hours
    local minutes = ____exports_getGameTimeFormatted_result_1.minutes
    local seconds = ____exports_getGameTimeFormatted_result_1.seconds
    local milliseconds = ____exports_getGameTimeFormatted_result_1.milliseconds
    return ((((((tostring(hours) .. "小时") .. tostring(minutes)) .. "分") .. tostring(seconds)) .. "秒") .. tostring(milliseconds)) .. "毫秒"
end
function ____exports.getDateTimeString(self)
    local ____timeCache_2 = _timeCache
    local year = ____timeCache_2.year
    local month = ____timeCache_2.month
    local day = ____timeCache_2.day
    local hour = ____timeCache_2.hour
    local minute = ____timeCache_2.minute
    local second = ____timeCache_2.second
    return (((((((((tostring(year) .. "-") .. pad2(nil, month)) .. "-") .. pad2(nil, day)) .. " ") .. pad2(nil, hour)) .. ":") .. pad2(nil, minute)) .. ":") .. pad2(nil, second)
end
function ____exports.getDateTimeStringWithMs(self)
    local ____timeCache_3 = _timeCache
    local year = ____timeCache_3.year
    local month = ____timeCache_3.month
    local day = ____timeCache_3.day
    local hour = ____timeCache_3.hour
    local minute = ____timeCache_3.minute
    local second = ____timeCache_3.second
    local millisecond = ____timeCache_3.millisecond
    return (((((((((((tostring(year) .. "-") .. pad2(nil, month)) .. "-") .. pad2(nil, day)) .. " ") .. pad2(nil, hour)) .. ":") .. pad2(nil, minute)) .. ":") .. pad2(nil, second)) .. ".") .. pad3(nil, millisecond)
end
function ____exports.setGameDifficulty(self, difficulty)
    _gameDifficulty = difficulty
end
function ____exports.getGameDifficulty(self)
    return _gameDifficulty
end
function ____exports.addPeriodicCallback(self, intervalMs, callback)
    _periodicCallbackIdCounter = _periodicCallbackIdCounter + 1
    local id = _periodicCallbackIdCounter
    _periodicCallbacks[#_periodicCallbacks + 1] = {
        id = id,
        intervalMs = intervalMs,
        lastRunTime = nowMs(nil),
        callback = callback
    }
    return id
end
function ____exports.removePeriodicCallback(self, id)
    local idx = __TS__ArrayFindIndex(
        _periodicCallbacks,
        function(____, c) return c.id == id end
    )
    if idx > -1 then
        __TS__ArraySplice(_periodicCallbacks, idx, 1)
    end
end
function ____exports.addDelayedCallback(self, delayMs, callback)
    _delayedCallbackIdCounter = _delayedCallbackIdCounter + 1
    local id = _delayedCallbackIdCounter
    local safeDelay = math.max(
        0,
        math.floor(delayMs)
    )
    _delayedCallbacks[#_delayedCallbacks + 1] = {
        id = id,
        dueTime = nowMs(nil) + safeDelay,
        active = true,
        callback = callback
    }
    return id
end
function ____exports.removeDelayedCallback(self, id)
    for ____, d in ipairs(_delayedCallbacks) do
        if d.id == id then
            d.active = false
        end
    end
end
function ____exports.onSecond(self, callback)
    _secondCallbacks[#_secondCallbacks + 1] = callback
end
function ____exports.onTick10ms(self, callback)
    _tickCallbacks[#_tickCallbacks + 1] = callback
end
function ____exports.offSecond(self, callback)
    removeFnFromArray(nil, _secondCallbacks, callback)
end
function ____exports.offTick10ms(self, callback)
    removeFnFromArray(nil, _tickCallbacks, callback)
end
function ____exports.initCenterTimer(self)
    if _initialized then
        return
    end
    if bootstrapTimer then
        jass.DestroyTimer(bootstrapTimer)
        bootstrapTimer = nil
    end
    _initialized = true
    local startTime = japi.DzAPI_Map_GetGameStartTime()
    _serverTime = startTime * 1000
    jass.DisplayTimedTextToPlayer(
        jass.GetLocalPlayer(),
        0,
        0,
        10,
        (("[中心计时器初始化] DzAPI: " .. tostring(startTime)) .. ", _serverTime = ") .. tostring(_serverTime)
    )
    local dr = jassGlobals.udg_N
    if dr ~= nil then
        _gameDifficulty = math.max(
            1,
            math.floor(dr)
        )
    end
    calcDate(nil, _serverTime / 1000)
    local timer = jass.CreateTimer()
    jass.TimerStart(timer, 0.01, true, onTick)
end
bootstrapTimer = jass.CreateTimer()
jass.TimerStart(bootstrapTimer, 0, false, ____exports.initCenterTimer)
return ____exports
