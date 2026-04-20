local ____lualib = require("lualib_bundle")
local __TS__StringPadStart = ____lualib.__TS__StringPadStart
local __TS__ArrayFindIndex = ____lualib.__TS__ArrayFindIndex
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
local runPeriodicCallbacks, _serverTime, _millisCounter, _periodicCallbacks
function runPeriodicCallbacks(self)
    local now = _serverTime + _millisCounter * 10
    for ____, periodicCb in ipairs(_periodicCallbacks) do
        if now - periodicCb.lastRunTime >= periodicCb.intervalMs then
            periodicCb.lastRunTime = now
            periodicCb:callback()
        end
    end
end
--- 核心系统 - 中心计时器
-- 
-- 功能：
-- - 提供统一的游戏时间追踪（服务器时间）
-- - 使用 DzAPI_Map_GetGameStartTime() 获取游戏开始时的服务器时间戳
-- - 每10毫秒累加，支持获取年月日时分秒毫秒
-- 
-- 后续接手者：所有需要游戏时间的模块都从这里获取
-- 
-- 参考：JASS\jass复制粘贴\gettime.j
local jass = require("jass.common")
local japi = require("jass.japi")
local jassGlobals = require("jass.globals")
--- 每月天数（非闰年）
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
--- 2015-01-01 00:00:00 UTC 的时间戳
local BASE_TIMESTAMP = 1451606400
--- 东八区偏移（秒）
local TIMEZONE_OFFSET = 28800
_serverTime = 0
_millisCounter = 0
--- 是否已初始化
local _initialized = false
--- 游戏难度
local _gameDifficulty = 1
--- 游戏运行时间（秒，含小数）
local _gameElapsedTime = 0
--- 游戏时间：[秒, 分, 时]
local _gameTimeHMS = {0, 0, 0}
--- 时间缓存
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
--- 每秒回调函数列表
local _secondCallbacks = {}
--- 每10毫秒回调函数列表
local _tickCallbacks = {}
--- 数学取模
local function mathMod(self, dividend, divisor)
    local modulus = dividend - math.floor(dividend / divisor) * divisor
    if modulus < 0 then
        modulus = modulus + divisor
    end
    return modulus
end
--- 判断闰年
local function isLeapYear(self, y)
    if mathMod(nil, y, 4) == 0 then
        if mathMod(nil, y, 100) == 0 then
            return mathMod(nil, y, 400) == 0
        end
        return true
    end
    return false
end
--- 获取某年某月的天数
local function getMonthDays(self, y, m)
    if m == 2 and isLeapYear(nil, y) then
        return 29
    end
    return NORMAL_MON_DAYS[m + 1]
end
--- 更新日期缓存
-- 
-- @param y 年份
-- @param remainSec 剩余秒数
-- @param dayBy2015 从2015年开始的天数
local function updateDate(self, y, remainSec, dayBy2015)
    local bIsLeap = isLeapYear(nil, y)
    local dayNum = remainSec / (24 * 60 * 60)
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
                    math.floor(remainSec / (60 * 60)),
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
--- 计算日期
-- 与JASS源代码逻辑完全一致
-- 
-- @param now Unix时间戳（秒，从1970-01-01开始）
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
--- 每10毫秒更新服务器时间
local function onTick(self)
    _millisCounter = _millisCounter + 1
    _gameElapsedTime = _gameElapsedTime + 0.01
    if jassGlobals.udg_Elapsed ~= nil then
        jassGlobals.udg_Elapsed = _gameElapsedTime
    end
    for ____, callback in ipairs(_tickCallbacks) do
        callback(nil)
    end
    runPeriodicCallbacks(nil)
    if _millisCounter >= 100 then
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
        if jass.udg_Time ~= nil then
            jass.udg_Time[0] = _gameTimeHMS[1]
            jass.udg_Time[1] = _gameTimeHMS[2]
            jass.udg_Time[2] = _gameTimeHMS[3]
        end
        for ____, callback in ipairs(_secondCallbacks) do
            callback(nil)
        end
    end
end
--- 获取服务器时间（毫秒）
function ____exports.getServerTime(self)
    return _serverTime + _millisCounter * 10
end
--- 获取时间组件
-- 
-- @param i 0=年, 1=月, 2=日, 3=时, 4=分, 5=秒, 6=星期, 7=毫秒
function ____exports.getTime(self, i)
    repeat
        local ____switch32 = i
        local ____cond32 = ____switch32 == 0
        if ____cond32 then
            return _timeCache.year
        end
        ____cond32 = ____cond32 or ____switch32 == 1
        if ____cond32 then
            return _timeCache.month
        end
        ____cond32 = ____cond32 or ____switch32 == 2
        if ____cond32 then
            return _timeCache.day
        end
        ____cond32 = ____cond32 or ____switch32 == 3
        if ____cond32 then
            return _timeCache.hour
        end
        ____cond32 = ____cond32 or ____switch32 == 4
        if ____cond32 then
            return _timeCache.minute
        end
        ____cond32 = ____cond32 or ____switch32 == 5
        if ____cond32 then
            return _timeCache.second
        end
        ____cond32 = ____cond32 or ____switch32 == 6
        if ____cond32 then
            return _timeCache.weekday
        end
        ____cond32 = ____cond32 or ____switch32 == 7
        if ____cond32 then
            return _timeCache.millisecond
        end
        do
            return 0
        end
    until true
end
--- 获取游戏时间（从游戏开始到现在的毫秒数）
-- 注意：这是游戏运行时间，不是服务器时间
function ____exports.getGameTime(self)
    return _serverTime + _millisCounter * 10 - (_initialized and _serverTime or 0)
end
--- 获取游戏运行时间（秒）
function ____exports.getGameElapsedTime(self)
    return _gameElapsedTime
end
--- 获取游戏时间数组 [秒, 分, 时]
function ____exports.getGameTimeHMS(self)
    return {_gameTimeHMS[1], _gameTimeHMS[2], _gameTimeHMS[3]}
end
--- 获取游戏时间格式化对象
function ____exports.getGameTimeFormatted(self)
    local totalMs = _serverTime + _millisCounter * 10
    local totalSec = math.floor(totalMs / 1000)
    local hours = math.floor(totalSec / 3600)
    local minutes = math.floor(totalSec % 3600 / 60)
    local seconds = math.floor(totalSec % 60)
    local milliseconds = totalMs % 1000
    return {
        hours = hours,
        minutes = minutes,
        seconds = seconds,
        milliseconds = milliseconds,
        totalMs = totalMs
    }
end
--- 获取游戏时间字符串
-- 格式：X小时Y分Z秒
function ____exports.getGameTimeString(self)
    local ____exports_getGameTimeFormatted_result_0 = ____exports.getGameTimeFormatted(nil)
    local hours = ____exports_getGameTimeFormatted_result_0.hours
    local minutes = ____exports_getGameTimeFormatted_result_0.minutes
    local seconds = ____exports_getGameTimeFormatted_result_0.seconds
    return ((((tostring(hours) .. "小时") .. tostring(minutes)) .. "分") .. tostring(seconds)) .. "秒"
end
--- 获取游戏时间字符串（含毫秒）
-- 格式：X小时Y分Z秒MMM毫秒
function ____exports.getGameTimeStringWithMs(self)
    local ____exports_getGameTimeFormatted_result_1 = ____exports.getGameTimeFormatted(nil)
    local hours = ____exports_getGameTimeFormatted_result_1.hours
    local minutes = ____exports_getGameTimeFormatted_result_1.minutes
    local seconds = ____exports_getGameTimeFormatted_result_1.seconds
    local milliseconds = ____exports_getGameTimeFormatted_result_1.milliseconds
    return ((((((tostring(hours) .. "小时") .. tostring(minutes)) .. "分") .. tostring(seconds)) .. "秒") .. tostring(milliseconds)) .. "毫秒"
end
--- 获取日期时间字符串
-- 格式：YYYY-MM-DD HH:MM:SS
function ____exports.getDateTimeString(self)
    local ____timeCache_2 = _timeCache
    local year = ____timeCache_2.year
    local month = ____timeCache_2.month
    local day = ____timeCache_2.day
    local hour = ____timeCache_2.hour
    local minute = ____timeCache_2.minute
    local second = ____timeCache_2.second
    local function pad(____, n)
        return __TS__StringPadStart(
            tostring(n),
            2,
            "0"
        )
    end
    return (((((((((tostring(year) .. "-") .. pad(nil, month)) .. "-") .. pad(nil, day)) .. " ") .. pad(nil, hour)) .. ":") .. pad(nil, minute)) .. ":") .. pad(nil, second)
end
--- 获取日期时间字符串（含毫秒）
-- 格式：YYYY-MM-DD HH:MM:SS.mmm
function ____exports.getDateTimeStringWithMs(self)
    local ____timeCache_3 = _timeCache
    local year = ____timeCache_3.year
    local month = ____timeCache_3.month
    local day = ____timeCache_3.day
    local hour = ____timeCache_3.hour
    local minute = ____timeCache_3.minute
    local second = ____timeCache_3.second
    local millisecond = ____timeCache_3.millisecond
    local function pad(____, n)
        return __TS__StringPadStart(
            tostring(n),
            2,
            "0"
        )
    end
    local function padMs(____, n)
        return __TS__StringPadStart(
            tostring(n),
            3,
            "0"
        )
    end
    return (((((((((((tostring(year) .. "-") .. pad(nil, month)) .. "-") .. pad(nil, day)) .. " ") .. pad(nil, hour)) .. ":") .. pad(nil, minute)) .. ":") .. pad(nil, second)) .. ".") .. padMs(nil, millisecond)
end
--- 设置游戏难度
function ____exports.setGameDifficulty(self, difficulty)
    _gameDifficulty = difficulty
end
--- 获取游戏难度
function ____exports.getGameDifficulty(self)
    return _gameDifficulty
end
local _periodicCallbackIdCounter = 0
_periodicCallbacks = {}
--- 注册周期性回调函数
-- 
-- @param intervalMs 间隔时间（毫秒）
-- @param callback 回调函数
-- @returns 回调ID，用于取消注册
function ____exports.addPeriodicCallback(self, intervalMs, callback)
    _periodicCallbackIdCounter = _periodicCallbackIdCounter + 1
    local id = _periodicCallbackIdCounter
    _periodicCallbacks[#_periodicCallbacks + 1] = {id = id, intervalMs = intervalMs, lastRunTime = _serverTime + _millisCounter * 10, callback = callback}
    return id
end
--- 移除周期性回调函数
-- 
-- @param id 回调ID
function ____exports.removePeriodicCallback(self, id)
    local index = __TS__ArrayFindIndex(
        _periodicCallbacks,
        function(____, cb) return cb.id == id end
    )
    if index > -1 then
        __TS__ArraySplice(_periodicCallbacks, index, 1)
    end
end
--- 注册每秒回调函数
-- 
-- @param callback 每秒执行一次的回调函数
function ____exports.onSecond(self, callback)
    _secondCallbacks[#_secondCallbacks + 1] = callback
end
--- 注册每10毫秒回调函数
-- 
-- @param callback 每10毫秒执行一次的回调函数
function ____exports.onTick10ms(self, callback)
    _tickCallbacks[#_tickCallbacks + 1] = callback
end
--- 移除每秒回调函数
-- 
-- @param callback 要移除的回调函数
function ____exports.offSecond(self, callback)
    local index = __TS__ArrayIndexOf(_secondCallbacks, callback)
    if index > -1 then
        __TS__ArraySplice(_secondCallbacks, index, 1)
    end
end
--- 移除每10毫秒回调函数
-- 
-- @param callback 要移除的回调函数
function ____exports.offTick10ms(self, callback)
    local index = __TS__ArrayIndexOf(_tickCallbacks, callback)
    if index > -1 then
        __TS__ArraySplice(_tickCallbacks, index, 1)
    end
end
--- 初始化中心计时器
function ____exports.initCenterTimer(self)
    if _initialized then
        return
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
    local difficultyReal = jassGlobals.udg_N
    if difficultyReal ~= nil then
        _gameDifficulty = math.floor(difficultyReal)
        if _gameDifficulty < 1 then
            _gameDifficulty = 1
        end
    end
    calcDate(nil, _serverTime / 1000)
    local timer = jass.CreateTimer()
    jass.TimerStart(timer, 0.01, true, onTick)
end
local initTimer = jass.CreateTimer()
jass.TimerStart(initTimer, 0, false, ____exports.initCenterTimer)
return ____exports
