local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__StringPadStart = ____lualib.__TS__StringPadStart
local __TS__TypeOf = ____lualib.__TS__TypeOf
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__Class = ____lualib.__TS__Class
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__New = ____lualib.__TS__New
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
-- - **时间锚点**：不读取平台服务器时间，从 0 开始按游戏逻辑时间递增。
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
local jassGlobals = require("jass.globals")
local R2I = jass.R2I
local CreateTimer = jass.CreateTimer
local DestroyTimer = jass.DestroyTimer
local TimerStart = jass.TimerStart
local _____8C03_8BD5_8F93_51FA = require("lib.扩展函数.自定义扩展函数.03．调试输出")
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
local function nowMs()
    return _serverTime + _millisCounter * 10
end
local function gameElapsedMilliseconds()
    local elapsedSeconds = _gameTimeHMS[3] * 3600 + _gameTimeHMS[2] * 60 + _gameTimeHMS[1]
    return elapsedSeconds * 1000 + _millisCounter * 10
end
local function intFloor(value)
    return R2I(value)
end
local function maxNum(a, b)
    return a > b and a or b
end
local function mathMod(dividend, divisor)
    local m = dividend - intFloor(dividend / divisor) * divisor
    if m < 0 then
        m = m + divisor
    end
    return m
end
local function isLeapYear(y)
    return y % 4 == 0 and y % 100 ~= 0 or y % 400 == 0
end
local function getMonthDays(y, m)
    return m == 2 and isLeapYear(y) and 29 or NORMAL_MON_DAYS[m + 1]
end
local function updateDate(y, remainSec, dayBy2015)
    local dayNum = remainSec / 86400
    local totalDay = intFloor(dayNum)
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
            local curMonDay = getMonthDays(y, m)
            if remainDay <= curMonDay then
                _timeCache.year = y
                _timeCache.month = m
                _timeCache.day = remainDay
                _timeCache.hour = mathMod(
                    intFloor(remainSec / 3600),
                    24
                )
                _timeCache.minute = mathMod(
                    intFloor(remainSec / 60),
                    60
                )
                _timeCache.second = mathMod(remainSec, 60)
                _timeCache.millisecond = _millisCounter * 10
                _timeCache.weekday = mathMod(
                    mathMod(dayBy2015, 7) + 4,
                    7
                )
                return
            end
            remainDay = remainDay - curMonDay
            m = m + 1
        end
    end
end
local function calcDate(now)
    local remain = now - BASE_TIMESTAMP + TIMEZONE_OFFSET
    local y = 2016
    local dayBy2015 = 0
    while y <= 3000 do
        local baseRemain = remain
        local baseDayBy2015 = dayBy2015
        if isLeapYear(y) then
            remain = remain - 31622400
            dayBy2015 = dayBy2015 + 366
        else
            remain = remain - 31536000
            dayBy2015 = dayBy2015 + 365
        end
        if remain < 0 then
            updateDate(y, baseRemain, baseDayBy2015)
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
local function removeFnFromArray(arr, fn)
    local i = __TS__ArrayIndexOf(arr, fn)
    if i > -1 then
        __TS__ArraySplice(arr, i, 1)
    end
end
local function pad2(n)
    return __TS__StringPadStart(
        tostring(n),
        2,
        "0"
    )
end
local function pad3(n)
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
local _currentPeriodicCallback = nil
local _currentPeriodicVariable = nil
local _currentDelayedCallback = nil
local _currentDelayedVariable = nil
local function executeCurrentPeriodicCallback()
    if _currentPeriodicCallback ~= nil then
        _currentPeriodicCallback(_currentPeriodicVariable)
    end
end
local function executeCurrentDelayedCallback()
    local callback = _currentDelayedCallback
    local variable = _currentDelayedVariable
    if callback ~= nil then
        callback(variable)
    end
end
local function getTimerCallbackModule(prefix, callback)
    local callbackLabel = _____8C03_8BD5_8F93_51FA.getCallbackDebugLabel(callback)
    return callbackLabel ~= "" and (prefix .. " -> ") .. callbackLabel or prefix
end
local function runPeriodicCallbacks()
    local now = nowMs()
    local i = 0
    while i < #_periodicCallbacks do
        do
            local p = _periodicCallbacks[i + 1]
            if type(p.intervalMs) ~= "number" or not (p.intervalMs > 0) or type(p.lastRunTime) ~= "number" or type(p.callback) ~= "function" then
                _____8C03_8BD5_8F93_51FA.debugLogForce(
                    "中心计时器",
                    "移除非法周期回调",
                    "id",
                    p.id,
                    "intervalType",
                    __TS__TypeOf(p.intervalMs),
                    "intervalSource",
                    _____8C03_8BD5_8F93_51FA.getCallbackDebugLabel(p.intervalMs),
                    "callbackType",
                    __TS__TypeOf(p.callback),
                    "callbackSource",
                    _____8C03_8BD5_8F93_51FA.getCallbackDebugLabel(p.callback)
                )
                __TS__ArraySplice(_periodicCallbacks, i, 1)
                goto __continue31
            end
            if now - p.lastRunTime >= p.intervalMs then
                p.lastRunTime = now
                _currentPeriodicCallback = p.callback
                _currentPeriodicVariable = p.variable
                _____8C03_8BD5_8F93_51FA.safeExecute(
                    getTimerCallbackModule("中心计时器-周期回调", p.callback),
                    executeCurrentPeriodicCallback
                )
                _currentPeriodicCallback = nil
                _currentPeriodicVariable = nil
            end
            i = i + 1
        end
        ::__continue31::
    end
end
local function runDelayedCallbacks()
    local now = nowMs()
    local writeIndex = 0
    do
        local i = 0
        while i < #_delayedCallbacks do
            do
                local d = _delayedCallbacks[i + 1]
                if not d.active then
                    goto __continue36
                end
                if type(d.dueTime) ~= "number" or type(d.callback) ~= "function" then
                    _____8C03_8BD5_8F93_51FA.debugLogForce(
                        "中心计时器",
                        "移除非法延迟回调",
                        "id",
                        d.id,
                        "dueTimeType",
                        __TS__TypeOf(d.dueTime),
                        "callbackType",
                        __TS__TypeOf(d.callback)
                    )
                    d.active = false
                    goto __continue36
                end
                if now >= d.dueTime then
                    d.active = false
                    _currentDelayedCallback = d.callback
                    _currentDelayedVariable = d.variable
                    _____8C03_8BD5_8F93_51FA.safeExecute(
                        getTimerCallbackModule("中心计时器-延迟回调", d.callback),
                        executeCurrentDelayedCallback
                    )
                    _currentDelayedCallback = nil
                    _currentDelayedVariable = nil
                else
                    _delayedCallbacks[writeIndex + 1] = d
                    writeIndex = writeIndex + 1
                end
            end
            ::__continue36::
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
local function onTick()
    _millisCounter = _millisCounter + 1
    _gameElapsedTime = _gameElapsedTime + 0.01
    if jassGlobals.udg_Elapsed ~= nil then
        jassGlobals.udg_Elapsed = _gameElapsedTime
    end
    for ____, cb in ipairs(_tickCallbacks) do
        _____8C03_8BD5_8F93_51FA.safeExecute(
            getTimerCallbackModule("中心计时器-10ms回调", cb),
            cb
        )
    end
    runPeriodicCallbacks()
    runDelayedCallbacks()
    if _millisCounter < 100 then
        return
    end
    _millisCounter = 0
    _serverTime = _serverTime + 1000
    calcDate(BASE_TIMESTAMP + _serverTime / 1000)
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
        _____8C03_8BD5_8F93_51FA.safeExecute(
            getTimerCallbackModule("中心计时器-秒回调", cb),
            cb
        )
    end
end
function ____exports.getServerTime()
    return nowMs()
end
function ____exports.getTime(i)
    if i < 0 or i > 7 then
        return 0
    end
    return _timeCache[TIME_GET_KEYS[i + 1]]
end
function ____exports.getGameTime()
    return gameElapsedMilliseconds()
end
function ____exports.getGameElapsedTime()
    return _gameElapsedTime
end
function ____exports.getGameTimeHMS()
    return {_gameTimeHMS[1], _gameTimeHMS[2], _gameTimeHMS[3]}
end
function ____exports.getGameTimeFormatted()
    local totalMs = gameElapsedMilliseconds()
    local totalSec = intFloor(totalMs / 1000)
    return {
        hours = intFloor(totalSec / 3600),
        minutes = intFloor(totalSec % 3600 / 60),
        seconds = intFloor(totalSec % 60),
        milliseconds = totalMs % 1000,
        totalMs = totalMs
    }
end
function ____exports.getGameTimeString()
    local ____exports_getGameTimeFormatted_result_0 = ____exports.getGameTimeFormatted()
    local hours = ____exports_getGameTimeFormatted_result_0.hours
    local minutes = ____exports_getGameTimeFormatted_result_0.minutes
    local seconds = ____exports_getGameTimeFormatted_result_0.seconds
    return ((((tostring(hours) .. "小时") .. tostring(minutes)) .. "分") .. tostring(seconds)) .. "秒"
end
function ____exports.getGameTimeStringWithMs()
    local ____exports_getGameTimeFormatted_result_1 = ____exports.getGameTimeFormatted()
    local hours = ____exports_getGameTimeFormatted_result_1.hours
    local minutes = ____exports_getGameTimeFormatted_result_1.minutes
    local seconds = ____exports_getGameTimeFormatted_result_1.seconds
    local milliseconds = ____exports_getGameTimeFormatted_result_1.milliseconds
    return ((((((tostring(hours) .. "小时") .. tostring(minutes)) .. "分") .. tostring(seconds)) .. "秒") .. tostring(milliseconds)) .. "毫秒"
end
function ____exports.getDateTimeString()
    local ____timeCache_2 = _timeCache
    local year = ____timeCache_2.year
    local month = ____timeCache_2.month
    local day = ____timeCache_2.day
    local hour = ____timeCache_2.hour
    local minute = ____timeCache_2.minute
    local second = ____timeCache_2.second
    return (((((((((tostring(year) .. "-") .. pad2(month)) .. "-") .. pad2(day)) .. " ") .. pad2(hour)) .. ":") .. pad2(minute)) .. ":") .. pad2(second)
end
function ____exports.getDateTimeStringWithMs()
    local ____timeCache_3 = _timeCache
    local year = ____timeCache_3.year
    local month = ____timeCache_3.month
    local day = ____timeCache_3.day
    local hour = ____timeCache_3.hour
    local minute = ____timeCache_3.minute
    local second = ____timeCache_3.second
    local millisecond = ____timeCache_3.millisecond
    return (((((((((((tostring(year) .. "-") .. pad2(month)) .. "-") .. pad2(day)) .. " ") .. pad2(hour)) .. ":") .. pad2(minute)) .. ":") .. pad2(second)) .. ".") .. pad3(millisecond)
end
function ____exports.setGameDifficulty(difficulty)
    _gameDifficulty = difficulty
end
function ____exports.getGameDifficulty()
    return _gameDifficulty
end
function ____exports.addPeriodicCallback(intervalMs, callback, variable)
    if type(intervalMs) == "function" and type(callback) == "number" then
        _____8C03_8BD5_8F93_51FA.debugLogForce(
            "中心计时器",
            "纠正旧式周期回调参数顺序",
            _____8C03_8BD5_8F93_51FA.getCallbackDebugLabel(intervalMs),
            callback
        )
        local oldCallback = intervalMs
        intervalMs = callback
        callback = oldCallback
    end
    if type(intervalMs) ~= "number" or not (intervalMs > 0) or type(callback) ~= "function" then
        _____8C03_8BD5_8F93_51FA.debugLogForce(
            "中心计时器",
            "拒绝非法周期回调",
            "intervalType",
            __TS__TypeOf(intervalMs),
            "intervalSource",
            _____8C03_8BD5_8F93_51FA.getCallbackDebugLabel(intervalMs),
            "callbackType",
            __TS__TypeOf(callback),
            "callbackSource",
            _____8C03_8BD5_8F93_51FA.getCallbackDebugLabel(callback)
        )
        return 0
    end
    _periodicCallbackIdCounter = _periodicCallbackIdCounter + 1
    local id = _periodicCallbackIdCounter
    _periodicCallbacks[#_periodicCallbacks + 1] = {
        id = id,
        intervalMs = intervalMs,
        lastRunTime = nowMs(),
        callback = callback,
        variable = variable
    }
    return id
end
function ____exports.removePeriodicCallback(id)
    local idx = __TS__ArrayFindIndex(
        _periodicCallbacks,
        function(____, c) return c.id == id end
    )
    if idx > -1 then
        __TS__ArraySplice(_periodicCallbacks, idx, 1)
    end
end
function ____exports.addDelayedCallback(delayMs, callback, variable)
    if type(delayMs) == "function" and type(callback) == "number" then
        _____8C03_8BD5_8F93_51FA.debugLogForce(
            "中心计时器",
            "纠正旧式延迟回调参数顺序",
            _____8C03_8BD5_8F93_51FA.getCallbackDebugLabel(delayMs),
            callback
        )
        local oldCallback = delayMs
        delayMs = callback
        callback = oldCallback
    end
    if type(delayMs) ~= "number" or delayMs ~= delayMs or type(callback) ~= "function" then
        _____8C03_8BD5_8F93_51FA.debugLogForce(
            "中心计时器",
            "拒绝非法延迟回调",
            "delayType",
            __TS__TypeOf(delayMs),
            "callbackType",
            __TS__TypeOf(callback)
        )
        return 0
    end
    _delayedCallbackIdCounter = _delayedCallbackIdCounter + 1
    local id = _delayedCallbackIdCounter
    local safeDelay = maxNum(
        0,
        intFloor(delayMs)
    )
    _delayedCallbacks[#_delayedCallbacks + 1] = {
        id = id,
        dueTime = nowMs() + safeDelay,
        active = true,
        callback = callback,
        variable = variable
    }
    return id
end
function ____exports.removeDelayedCallback(id)
    for ____, d in ipairs(_delayedCallbacks) do
        if d.id == id then
            d.active = false
        end
    end
end
local _____53EF_53D6_6D88_4EFB_52A1_7EC4_5B9E_73B0 = __TS__Class()
_____53EF_53D6_6D88_4EFB_52A1_7EC4_5B9E_73B0.name = "可取消任务组实现"
function _____53EF_53D6_6D88_4EFB_52A1_7EC4_5B9E_73B0.prototype.____constructor(self)
    self["任务列表"] = {}
end
_____53EF_53D6_6D88_4EFB_52A1_7EC4_5B9E_73B0.prototype["添加延迟"] = function(self, _____6BEB_79D2, _____56DE_8C03, _____53D8_91CF)
    local id = ____exports.addDelayedCallback(_____6BEB_79D2, _____56DE_8C03, _____53D8_91CF)
    local ____self__4EFB_52A1_5217_8868_4 = self["任务列表"]
    ____self__4EFB_52A1_5217_8868_4[#____self__4EFB_52A1_5217_8868_4 + 1] = {id = id, ["类型"] = "延迟"}
    return id
end
_____53EF_53D6_6D88_4EFB_52A1_7EC4_5B9E_73B0.prototype["添加周期"] = function(self, _____95F4_9694_6BEB_79D2, _____56DE_8C03, _____53D8_91CF)
    local id = ____exports.addPeriodicCallback(_____95F4_9694_6BEB_79D2, _____56DE_8C03, _____53D8_91CF)
    local ____self__4EFB_52A1_5217_8868_5 = self["任务列表"]
    ____self__4EFB_52A1_5217_8868_5[#____self__4EFB_52A1_5217_8868_5 + 1] = {id = id, ["类型"] = "周期"}
    return id
end
_____53EF_53D6_6D88_4EFB_52A1_7EC4_5B9E_73B0.prototype["取消"] = function(self, _____4EFB_52A1ID)
    if not (_____4EFB_52A1ID > 0) then
        return
    end
    do
        local i = #self["任务列表"] - 1
        while i >= 0 do
            do
                local task = self["任务列表"][i + 1]
                if task.id ~= _____4EFB_52A1ID then
                    goto __continue85
                end
                if task["类型"] == "延迟" then
                    ____exports.removeDelayedCallback(task.id)
                else
                    ____exports.removePeriodicCallback(task.id)
                end
                __TS__ArraySplice(self["任务列表"], i, 1)
                return
            end
            ::__continue85::
            i = i - 1
        end
    end
end
_____53EF_53D6_6D88_4EFB_52A1_7EC4_5B9E_73B0.prototype["清空"] = function(self)
    do
        local i = 0
        while i < #self["任务列表"] do
            local task = self["任务列表"][i + 1]
            if task["类型"] == "延迟" then
                ____exports.removeDelayedCallback(task.id)
            else
                ____exports.removePeriodicCallback(task.id)
            end
            i = i + 1
        end
    end
    __TS__ArraySetLength(self["任务列表"], 0)
end
____exports["创建可取消任务组"] = function()
    return __TS__New(_____53EF_53D6_6D88_4EFB_52A1_7EC4_5B9E_73B0)
end
function ____exports.onSecond(callback)
    _secondCallbacks[#_secondCallbacks + 1] = callback
end
function ____exports.onTick10ms(callback)
    _tickCallbacks[#_tickCallbacks + 1] = callback
end
function ____exports.offSecond(callback)
    removeFnFromArray(_secondCallbacks, callback)
end
function ____exports.offTick10ms(callback)
    removeFnFromArray(_tickCallbacks, callback)
end
function ____exports.initCenterTimer()
    if _initialized then
        return
    end
    if bootstrapTimer then
        DestroyTimer(bootstrapTimer)
        bootstrapTimer = nil
    end
    _initialized = true
    local dr = jassGlobals.udg_N
    if dr ~= nil then
        _gameDifficulty = maxNum(
            1,
            intFloor(dr)
        )
    end
    calcDate(BASE_TIMESTAMP + _serverTime / 1000)
    local timer = CreateTimer()
    TimerStart(timer, 0.01, true, onTick)
end
bootstrapTimer = CreateTimer()
TimerStart(bootstrapTimer, 0, false, ____exports.initCenterTimer)
return ____exports
