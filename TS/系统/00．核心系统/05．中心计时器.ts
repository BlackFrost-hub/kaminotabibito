/**
 * 核心系统 - 中心计时器
 *
 * 功能：
 * - 提供统一的游戏时间追踪（服务器时间）
 * - 使用 DzAPI_Map_GetGameStartTime() 获取游戏开始时的服务器时间戳
 * - 每10毫秒累加，支持获取年月日时分秒毫秒
 *
 * 后续接手者：所有需要游戏时间的模块都从这里获取
 *
 * 参考：JASS\jass复制粘贴\gettime.j
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jassGlobals = require("jass.globals") as any;

// ==========================================================================================
// 常量
// ==========================================================================================

/** 每月天数（非闰年） */
const NORMAL_MON_DAYS = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

/** 2015-01-01 00:00:00 UTC 的时间戳 */
const BASE_TIMESTAMP = 1451606400;

/** 东八区偏移（秒） */
const TIMEZONE_OFFSET = 28800;

// ==========================================================================================
// 状态变量
// ==========================================================================================

/** 服务器时间（毫秒） */
let _serverTime = 0;

/** 毫秒计数器（0-99） */
let _millisCounter = 0;

/** 是否已初始化 */
let _initialized = false;

/** 游戏难度 */
let _gameDifficulty = 1;

/** 游戏运行时间（秒，含小数） */
let _gameElapsedTime = 0;

/** 游戏时间：[秒, 分, 时] */
let _gameTimeHMS = [0, 0, 0];

/** 时间缓存 */
let _timeCache = {
  year: 2016,
  month: 1,
  day: 1,
  hour: 0,
  minute: 0,
  second: 0,
  millisecond: 0,
  weekday: 0,
};

/** 每秒回调函数列表 */
const _secondCallbacks: Array<() => void> = [];

/** 每10毫秒回调函数列表 */
const _tickCallbacks: Array<() => void> = [];

// ==========================================================================================
// 工具函数
// ==========================================================================================

/** 数学取模 */
function mathMod(dividend: number, divisor: number): number {
  let modulus = dividend - Math.floor(dividend / divisor) * divisor;
  if (modulus < 0) {
    modulus = modulus + divisor;
  }
  return modulus;
}

/** 判断闰年 */
function isLeapYear(y: number): boolean {
  if (mathMod(y, 4) === 0) {
    if (mathMod(y, 100) === 0) {
      return mathMod(y, 400) === 0;
    }
    return true;
  }
  return false;
}

/** 获取某年某月的天数 */
function getMonthDays(y: number, m: number): number {
  if (m === 2 && isLeapYear(y)) {
    return 29;
  }
  return NORMAL_MON_DAYS[m];
}

// ==========================================================================================
// 时间计算
// ==========================================================================================

/**
 * 更新日期缓存
 * @param y 年份
 * @param remainSec 剩余秒数
 * @param dayBy2015 从2015年开始的天数
 */
function updateDate(y: number, remainSec: number, dayBy2015: number): void {
  const bIsLeap = isLeapYear(y);
  let dayNum = remainSec / (24 * 60 * 60);
  let totalDay = Math.floor(dayNum);

  if (dayNum - totalDay > 0) {
    totalDay = totalDay + 1;
  }
  if (totalDay === 0) {
    totalDay = 1;
  }

  dayBy2015 = dayBy2015 + totalDay;

  // 遍历月份
  let remainDay = totalDay;
  for (let m = 1; m <= 12; m++) {
    const curMonDay = getMonthDays(y, m);
    if (remainDay <= curMonDay) {
      _timeCache.year = y;
      _timeCache.month = m;
      _timeCache.day = remainDay;
      _timeCache.hour = mathMod(Math.floor(remainSec / (60 * 60)), 24);
      _timeCache.minute = mathMod(Math.floor(remainSec / 60), 60);
      _timeCache.second = mathMod(remainSec, 60);
      _timeCache.millisecond = _millisCounter * 10;
      _timeCache.weekday = mathMod(mathMod(dayBy2015, 7) + 4, 7);
      return;
    }
    remainDay = remainDay - curMonDay;
  }
}

/**
 * 计算日期
 * 与JASS源代码逻辑完全一致
 * @param now Unix时间戳（秒，从1970-01-01开始）
 */
function calcDate(now: number): void {
  // 与JASS一致：now - 1451606400 + 28800（默认东八区）
  let remain = now - BASE_TIMESTAMP + TIMEZONE_OFFSET;
  let y = 2016;
  let dayBy2015 = 0;

  while (y <= 3000) {
    const baseRemain = remain;
    const baseDayBy2015 = dayBy2015;

    if (isLeapYear(y)) {
      remain = remain - 31622400;
      dayBy2015 = dayBy2015 + 366;
    } else {
      remain = remain - 31536000;
      dayBy2015 = dayBy2015 + 365;
    }

    if (remain < 0) {
      // 与JASS一致：使用baseRemain和baseDayBy2015
      updateDate(y, baseRemain, baseDayBy2015);
      return;
    }

    y = y + 1;
  }
}

// ==========================================================================================
// 计时器回调
// ==========================================================================================

/** 每10毫秒更新服务器时间 */
function onTick(): void {
  _millisCounter = _millisCounter + 1;

  // 游戏运行时间+0.01秒
  _gameElapsedTime = _gameElapsedTime + 0.01;

  // 同步到JASS全局变量（秒，含小数）
  if (jassGlobals.udg_Elapsed != null) {
    jassGlobals.udg_Elapsed = _gameElapsedTime;
  }

  // 执行每10毫秒回调
  for (const callback of _tickCallbacks) {
    callback();
  }

  // 执行周期性回调
  runPeriodicCallbacks();

  if (_millisCounter >= 100) {
    _millisCounter = 0;
    _serverTime = _serverTime + 1000;
    calcDate(_serverTime / 1000);

    // 更新游戏时间 [秒, 分, 时]
    _gameTimeHMS[0] = _gameTimeHMS[0] + 1;
    if (_gameTimeHMS[0] >= 60) {
      _gameTimeHMS[0] = 0;
      _gameTimeHMS[1] = _gameTimeHMS[1] + 1;
      if (_gameTimeHMS[1] >= 60) {
        _gameTimeHMS[1] = 0;
        _gameTimeHMS[2] = _gameTimeHMS[2] + 1;
      }
    }

    // 同步到JASS全局变量
    if ((jass as any).udg_Time != null) {
      (jass as any).udg_Time[0] = _gameTimeHMS[0];
      (jass as any).udg_Time[1] = _gameTimeHMS[1];
      (jass as any).udg_Time[2] = _gameTimeHMS[2];
    }

    // 执行每秒回调
    for (const callback of _secondCallbacks) {
      callback();
    }
  }
}

// ==========================================================================================
// 导出函数
// ==========================================================================================

/**
 * 获取服务器时间（毫秒）
 */
export function getServerTime(): number {
  return _serverTime + _millisCounter * 10;
}

/**
 * 获取时间组件
 * @param i 0=年, 1=月, 2=日, 3=时, 4=分, 5=秒, 6=星期, 7=毫秒
 */
export function getTime(i: number): number {
  switch (i) {
    case 0: return _timeCache.year;
    case 1: return _timeCache.month;
    case 2: return _timeCache.day;
    case 3: return _timeCache.hour;
    case 4: return _timeCache.minute;
    case 5: return _timeCache.second;
    case 6: return _timeCache.weekday;
    case 7: return _timeCache.millisecond;
    default: return 0;
  }
}

/**
 * 获取游戏时间（从游戏开始到现在的毫秒数）
 * 注意：这是游戏运行时间，不是服务器时间
 */
export function getGameTime(): number {
  return _serverTime + _millisCounter * 10 - (_initialized ? _serverTime : 0);
}

/**
 * 获取游戏运行时间（秒）
 */
export function getGameElapsedTime(): number {
  return _gameElapsedTime;
}

/**
 * 获取游戏时间数组 [秒, 分, 时]
 */
export function getGameTimeHMS(): [number, number, number] {
  return [_gameTimeHMS[0], _gameTimeHMS[1], _gameTimeHMS[2]];
}

/**
 * 获取游戏时间格式化对象
 */
export function getGameTimeFormatted(): { hours: number; minutes: number; seconds: number; milliseconds: number; totalMs: number } {
  const totalMs = _serverTime + _millisCounter * 10;
  const totalSec = Math.floor(totalMs / 1000);
  const hours = Math.floor(totalSec / 3600);
  const minutes = Math.floor((totalSec % 3600) / 60);
  const seconds = Math.floor(totalSec % 60);
  const milliseconds = totalMs % 1000;
  return { hours, minutes, seconds, milliseconds, totalMs };
}

/**
 * 获取游戏时间字符串
 * 格式：X小时Y分Z秒
 */
export function getGameTimeString(): string {
  const { hours, minutes, seconds } = getGameTimeFormatted();
  return `${hours}小时${minutes}分${seconds}秒`;
}

/**
 * 获取游戏时间字符串（含毫秒）
 * 格式：X小时Y分Z秒MMM毫秒
 */
export function getGameTimeStringWithMs(): string {
  const { hours, minutes, seconds, milliseconds } = getGameTimeFormatted();
  return `${hours}小时${minutes}分${seconds}秒${milliseconds}毫秒`;
}

/**
 * 获取日期时间字符串
 * 格式：YYYY-MM-DD HH:MM:SS
 */
export function getDateTimeString(): string {
  const { year, month, day, hour, minute, second } = _timeCache;
  const pad = (n: number) => n.toString().padStart(2, "0");
  return `${year}-${pad(month)}-${pad(day)} ${pad(hour)}:${pad(minute)}:${pad(second)}`;
}

/**
 * 获取日期时间字符串（含毫秒）
 * 格式：YYYY-MM-DD HH:MM:SS.mmm
 */
export function getDateTimeStringWithMs(): string {
  const { year, month, day, hour, minute, second, millisecond } = _timeCache;
  const pad = (n: number) => n.toString().padStart(2, "0");
  const padMs = (n: number) => n.toString().padStart(3, "0");
  return `${year}-${pad(month)}-${pad(day)} ${pad(hour)}:${pad(minute)}:${pad(second)}.${padMs(millisecond)}`;
}

/**
 * 设置游戏难度
 */
export function setGameDifficulty(difficulty: number): void {
  _gameDifficulty = difficulty;
}

/**
 * 获取游戏难度
 */
export function getGameDifficulty(): number {
  return _gameDifficulty;
}

// ==========================================================================================
// 回调注册功能
// ==========================================================================================

/** 周期性回调列表 */
interface PeriodicCallback {
  id: number;
  intervalMs: number;
  lastRunTime: number;
  callback: () => void;
}

let _periodicCallbackIdCounter = 0;
const _periodicCallbacks: PeriodicCallback[] = [];

/**
 * 注册周期性回调函数
 * @param intervalMs 间隔时间（毫秒）
 * @param callback 回调函数
 * @returns 回调ID，用于取消注册
 */
export function addPeriodicCallback(intervalMs: number, callback: () => void): number {
  const id = ++_periodicCallbackIdCounter;
  _periodicCallbacks.push({
    id,
    intervalMs,
    lastRunTime: _serverTime + _millisCounter * 10,
    callback,
  });
  return id;
}

/**
 * 移除周期性回调函数
 * @param id 回调ID
 */
export function removePeriodicCallback(id: number): void {
  const index = _periodicCallbacks.findIndex((cb) => cb.id === id);
  if (index > -1) {
    _periodicCallbacks.splice(index, 1);
  }
}

/**
 * 执行周期性回调（在onTick中调用）
 */
function runPeriodicCallbacks(): void {
  const now = _serverTime + _millisCounter * 10;
  for (const periodicCb of _periodicCallbacks) {
    if (now - periodicCb.lastRunTime >= periodicCb.intervalMs) {
      periodicCb.lastRunTime = now;
      periodicCb.callback();
    }
  }
}

/**
 * 注册每秒回调函数
 * @param callback 每秒执行一次的回调函数
 */
export function onSecond(callback: () => void): void {
  _secondCallbacks.push(callback);
}

/**
 * 注册每10毫秒回调函数
 * @param callback 每10毫秒执行一次的回调函数
 */
export function onTick10ms(callback: () => void): void {
  _tickCallbacks.push(callback);
}

/**
 * 移除每秒回调函数
 * @param callback 要移除的回调函数
 */
export function offSecond(callback: () => void): void {
  const index = _secondCallbacks.indexOf(callback);
  if (index > -1) {
    _secondCallbacks.splice(index, 1);
  }
}

/**
 * 移除每10毫秒回调函数
 * @param callback 要移除的回调函数
 */
export function offTick10ms(callback: () => void): void {
  const index = _tickCallbacks.indexOf(callback);
  if (index > -1) {
    _tickCallbacks.splice(index, 1);
  }
}

// ==========================================================================================
// 初始化
// ==========================================================================================

/**
 * 初始化中心计时器
 */
export function initCenterTimer(): void {
  if (_initialized) return;
  _initialized = true;

  // 获取游戏开始时的服务器时间（转换为毫秒）
  const startTime = japi.DzAPI_Map_GetGameStartTime();
  _serverTime = startTime * 1000;
  jass.DisplayTimedTextToPlayer(
    jass.GetLocalPlayer(),
    0,
    0,
    10,
    `[中心计时器初始化] DzAPI: ${startTime}, _serverTime = ${_serverTime}`
  );

  // 从JASS全局变量获取游戏难度（变量名为 udg_N）
  const difficultyReal = jassGlobals.udg_N as number | undefined;
  if (difficultyReal !== undefined) {
    _gameDifficulty = Math.floor(difficultyReal);
    if (_gameDifficulty < 1) {
      _gameDifficulty = 1;
    }
  }

  // 初始计算日期
  calcDate(_serverTime / 1000);

  // 创建每10毫秒计时器
  const timer = jass.CreateTimer();
  jass.TimerStart(timer, 0.01, true, onTick);
}

// 延迟初始化：游戏开始后立即执行
const initTimer = jass.CreateTimer();
jass.TimerStart(initTimer, 0.0, false, initCenterTimer);

export {};
