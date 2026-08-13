/** @noSelfInFile */
/**
 * @file 系统/00．核心系统/05．中心计时器.ts
 * @module 中心计时器
 *
 * ## 职责
 * 全图唯一「逻辑时钟」：用 **0.01s 周期** 驱动游戏内时间、日历缓存、以及与 JASS 全局变量的同步。
 * 其它系统需要「游戏时间 / 定时回调」时应 **require 本模块**，不要各自再建 `CreateTimer(0.01)`。
 *
 * ## 引用
 * - 推荐：`require("系统.00．核心系统.05．中心计时器")`
 * - 或经 `系统.00．核心系统.index` 的 `export *` 再导入同名导出。
 *
 * ## 时间模型（内部状态）
 * - **nowMs** ≈ `_serverTime + _millisCounter * 10`：`getServerTime()` / 多数逻辑用的「毫秒」。
 * - **时间锚点**：不读取平台服务器时间，从 0 开始按游戏逻辑时间递增。
 * - **游戏经过时间**：`_gameElapsedTime`（秒，含小数），写入 `jass.globals.udg_Elapsed`（若存在）。
 * - **游戏内 [秒,分,时]**：`_gameTimeHMS`，每秒推进并写入 `jass.udg_Time[0..2]`（若存在）。
 * - **日历**：`calcDate` / `updateDate` 与旧版 JASS `gettime.j` 一致：`BASE_TIMESTAMP`(2015-01-01 UTC) + `TIMEZONE_OFFSET`(东八区秒)。
 *
 * ## 回调分层（均在 `onTick` 内按序执行）
 * 1. **每 10ms**：`onTick10ms` 注册的回调（全部调用）。
 * 2. **周期性**：`addPeriodicCallback`（按间隔与 `nowMs` 比较）。
 * 3. **每 1s**（每满 100 次 10ms tick）：`calcDate`、`udg_Time`、然后 `onSecond` 回调。
 *
 * ## 对外导出（摘要）
 * - **读时间**：`getServerTime`、`getTime(0..7)`、`getGameTime`、`getGameElapsedTime`、`getGameTimeHMS`、
 *   `getGameTimeFormatted` / `getGameTimeString*`、`getDateTimeString*`。
 * - **难度**：`getGameDifficulty` / `setGameDifficulty`（初始化时从 `udg_N` 读一次）。
 * - **注册回调**：`onTick10ms` / `offTick10ms`、`onSecond` / `offSecond`、`addPeriodicCallback` / `removePeriodicCallback`。
 * - **显式初始化**：`initCenterTimer`（幂等）；文件末尾另有 **0s 延迟单次计时器** 自动调用，一般无需手动调。
 *
 * ## 副作用
 * 模块加载即注册 `TimerStart(..., 0, false, initCenterTimer)`，游戏开始后一帧内拉起主循环。
 */

const jass = require("jass.common") as any;
// 不读取 DzAPI_Map_GetGameStartTime，保留 Warcraft 原生随机状态。
// const japi = require("jass.japi") as any;
const jassGlobals = require("jass.globals") as any;
const R2I = jass.R2I as (value: number) => number;
const CreateTimer = jass.CreateTimer as () => any;
const DestroyTimer = jass.DestroyTimer as (whichTimer: any) => void;
const TimerStart = jass.TimerStart as (whichTimer: any, timeout: number, periodic: boolean, handlerFunc: (this: void) => void) => void;
// const DzAPI_Map_GetGameStartTime = japi.DzAPI_Map_GetGameStartTime as () => number;
const 调试输出 = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  safeExecute: (this: void, module: string, callback: (this: void) => void) => boolean;
  getCallbackDebugLabel: (this: void, callback: any) => string;
};

const NORMAL_MON_DAYS = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
const BASE_TIMESTAMP = 1451606400;
const TIMEZONE_OFFSET = 28800;

let _serverTime = 0;
let _millisCounter = 0;
let _initialized = false;
/** 仅用于 `TimerStart(..., 0, false, initCenterTimer)` 的引导计时器，进入 `initCenterTimer` 后必须销毁，否则会永久占一个句柄。 */
let bootstrapTimer: any = null;
let _gameDifficulty = 1;
let _gameElapsedTime = 0;
const _gameTimeHMS = [0, 0, 0];

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

const _secondCallbacks: Array<(this: void) => void> = [];
const _tickCallbacks: Array<(this: void) => void> = [];

/** 当前逻辑毫秒（与 getServerTime 一致） */
function nowMs(): number {
  return _serverTime + _millisCounter * 10;
}

function gameElapsedMilliseconds(): number {
  const elapsedSeconds = _gameTimeHMS[2] * 3600 + _gameTimeHMS[1] * 60 + _gameTimeHMS[0];
  return elapsedSeconds * 1000 + _millisCounter * 10;
}

function intFloor(value: number): number {
  return R2I(value);
}

function maxNum(a: number, b: number): number {
  return a > b ? a : b;
}

function mathMod(dividend: number, divisor: number): number {
  let m = dividend - intFloor(dividend / divisor) * divisor;
  if (m < 0) m += divisor;
  return m;
}

function isLeapYear(y: number): boolean {
  return (y % 4 === 0 && y % 100 !== 0) || y % 400 === 0;
}

function getMonthDays(y: number, m: number): number {
  return m === 2 && isLeapYear(y) ? 29 : NORMAL_MON_DAYS[m];
}

function updateDate(y: number, remainSec: number, dayBy2015: number): void {
  let dayNum = remainSec / 86400;
  let totalDay = intFloor(dayNum);
  if (dayNum - totalDay > 0) totalDay++;
  if (totalDay === 0) totalDay = 1;
  dayBy2015 += totalDay;

  let remainDay = totalDay;
  for (let m = 1; m <= 12; m++) {
    const curMonDay = getMonthDays(y, m);
    if (remainDay <= curMonDay) {
      _timeCache.year = y;
      _timeCache.month = m;
      _timeCache.day = remainDay;
      _timeCache.hour = mathMod(intFloor(remainSec / 3600), 24);
      _timeCache.minute = mathMod(intFloor(remainSec / 60), 60);
      _timeCache.second = mathMod(remainSec, 60);
      _timeCache.millisecond = _millisCounter * 10;
      _timeCache.weekday = mathMod(mathMod(dayBy2015, 7) + 4, 7);
      return;
    }
    remainDay -= curMonDay;
  }
}

function calcDate(now: number): void {
  let remain = now - BASE_TIMESTAMP + TIMEZONE_OFFSET;
  let y = 2016;
  let dayBy2015 = 0;

  while (y <= 3000) {
    const baseRemain = remain;
    const baseDayBy2015 = dayBy2015;
    if (isLeapYear(y)) {
      remain -= 31622400;
      dayBy2015 += 366;
    } else {
      remain -= 31536000;
      dayBy2015 += 365;
    }
    if (remain < 0) {
      updateDate(y, baseRemain, baseDayBy2015);
      return;
    }
    y++;
  }
}

const TIME_GET_KEYS = ["year", "month", "day", "hour", "minute", "second", "weekday", "millisecond"] as const;

function removeFnFromArray(arr: Array<(this: void) => void>, fn: (this: void) => void): void {
  const i = arr.indexOf(fn);
  if (i > -1) arr.splice(i, 1);
}

function pad2(n: number): string {
  return n.toString().padStart(2, "0");
}

function pad3(n: number): string {
  return n.toString().padStart(3, "0");
}

// --- 周期性回调 ---
interface PeriodicCallback {
  id: number;
  intervalMs: number;
  lastRunTime: number;
  callback: (this: void, variable?: any) => void;
  variable?: any;
}

interface DelayedCallback {
  id: number;
  dueTime: number;
  active: boolean;
  callback: (this: void, variable?: any) => void;
  variable?: any;
}

let _periodicCallbackIdCounter = 0;
const _periodicCallbacks: PeriodicCallback[] = [];
let _delayedCallbackIdCounter = 0;
const _delayedCallbacks: DelayedCallback[] = [];
let _currentPeriodicCallback: ((this: void, variable?: any) => void) | undefined = undefined;
let _currentPeriodicVariable: any = undefined;
let _currentDelayedCallback: ((this: void, variable?: any) => void) | undefined = undefined;
let _currentDelayedVariable: any = undefined;

function executeCurrentPeriodicCallback(this: void): void {
  if (_currentPeriodicCallback != null) _currentPeriodicCallback(_currentPeriodicVariable);
}

function executeCurrentDelayedCallback(this: void): void {
  if (_currentDelayedCallback != null) _currentDelayedCallback(_currentDelayedVariable);
}

function getTimerCallbackModule(this: void, prefix: string, callback: any): string {
  const callbackLabel = 调试输出.getCallbackDebugLabel(callback);
  return callbackLabel !== "" ? prefix + " -> " + callbackLabel : prefix;
}

function runPeriodicCallbacks(): void {
  const now = nowMs();
  for (const p of _periodicCallbacks) {
    if (now - p.lastRunTime >= p.intervalMs) {
      p.lastRunTime = now;
      _currentPeriodicCallback = p.callback;
      _currentPeriodicVariable = p.variable;
      调试输出.safeExecute(getTimerCallbackModule("中心计时器-周期回调", p.callback), executeCurrentPeriodicCallback);
      _currentPeriodicCallback = undefined;
      _currentPeriodicVariable = undefined;
    }
  }
}

function runDelayedCallbacks(): void {
  const now = nowMs();
  let writeIndex = 0;
  for (let i = 0; i < _delayedCallbacks.length; i++) {
    const d = _delayedCallbacks[i];
    if (!d.active) continue;
    if (now >= d.dueTime) {
      d.active = false;
      _currentDelayedCallback = d.callback;
      _currentDelayedVariable = d.variable;
      调试输出.safeExecute(getTimerCallbackModule("中心计时器-延迟回调", d.callback), executeCurrentDelayedCallback);
      _currentDelayedCallback = undefined;
      _currentDelayedVariable = undefined;
    } else {
      _delayedCallbacks[writeIndex] = d;
      writeIndex++;
    }
  }
  for (let i = _delayedCallbacks.length - 1; i >= writeIndex; i--) {
    _delayedCallbacks.pop();
  }
}

function onTick(): void {
  _millisCounter++;
  _gameElapsedTime += 0.01;

  if (jassGlobals.udg_Elapsed != null) {
    jassGlobals.udg_Elapsed = _gameElapsedTime;
  }

  for (const cb of _tickCallbacks) {
    调试输出.safeExecute(getTimerCallbackModule("中心计时器-10ms回调", cb), cb);
  }
  runPeriodicCallbacks();
  runDelayedCallbacks();

  if (_millisCounter < 100) return;

  _millisCounter = 0;
  _serverTime += 1000;
  calcDate(BASE_TIMESTAMP + _serverTime / 1000);

  _gameTimeHMS[0]++;
  if (_gameTimeHMS[0] >= 60) {
    _gameTimeHMS[0] = 0;
    _gameTimeHMS[1]++;
    if (_gameTimeHMS[1] >= 60) {
      _gameTimeHMS[1] = 0;
      _gameTimeHMS[2]++;
    }
  }

  const jt = (jass as any).udg_Time;
  if (jt != null) {
    jt[0] = _gameTimeHMS[0];
    jt[1] = _gameTimeHMS[1];
    jt[2] = _gameTimeHMS[2];
  }

  for (const cb of _secondCallbacks) {
    调试输出.safeExecute(getTimerCallbackModule("中心计时器-秒回调", cb), cb);
  }
}

export function getServerTime(): number {
  return nowMs();
}

export function getTime(i: number): number {
  if (i < 0 || i > 7) return 0;
  return (_timeCache as any)[TIME_GET_KEYS[i]];
}

export function getGameTime(): number {
  return gameElapsedMilliseconds();
}

export function getGameElapsedTime(): number {
  return _gameElapsedTime;
}

export function getGameTimeHMS(): [number, number, number] {
  return [_gameTimeHMS[0], _gameTimeHMS[1], _gameTimeHMS[2]];
}

export function getGameTimeFormatted(): {
  hours: number;
  minutes: number;
  seconds: number;
  milliseconds: number;
  totalMs: number;
} {
  const totalMs = gameElapsedMilliseconds();
  const totalSec = intFloor(totalMs / 1000);
  return {
    hours: intFloor(totalSec / 3600),
    minutes: intFloor((totalSec % 3600) / 60),
    seconds: intFloor(totalSec % 60),
    milliseconds: totalMs % 1000,
    totalMs,
  };
}

export function getGameTimeString(): string {
  const { hours, minutes, seconds } = getGameTimeFormatted();
  return `${hours}小时${minutes}分${seconds}秒`;
}

export function getGameTimeStringWithMs(): string {
  const { hours, minutes, seconds, milliseconds } = getGameTimeFormatted();
  return `${hours}小时${minutes}分${seconds}秒${milliseconds}毫秒`;
}

export function getDateTimeString(): string {
  const { year, month, day, hour, minute, second } = _timeCache;
  return `${year}-${pad2(month)}-${pad2(day)} ${pad2(hour)}:${pad2(minute)}:${pad2(second)}`;
}

export function getDateTimeStringWithMs(): string {
  const { year, month, day, hour, minute, second, millisecond } = _timeCache;
  return `${year}-${pad2(month)}-${pad2(day)} ${pad2(hour)}:${pad2(minute)}:${pad2(second)}.${pad3(millisecond)}`;
}

export function setGameDifficulty(difficulty: number): void {
  _gameDifficulty = difficulty;
}

export function getGameDifficulty(): number {
  return _gameDifficulty;
}

export function addPeriodicCallback(intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any): number {
  const id = ++_periodicCallbackIdCounter;
  _periodicCallbacks.push({ id, intervalMs, lastRunTime: nowMs(), callback, variable });
  return id;
}

export function removePeriodicCallback(id: number): void {
  const idx = _periodicCallbacks.findIndex((c) => c.id === id);
  if (idx > -1) _periodicCallbacks.splice(idx, 1);
}

export function addDelayedCallback(delayMs: number, callback: (this: void, variable?: any) => void, variable?: any): number {
  const id = ++_delayedCallbackIdCounter;
  const safeDelay = maxNum(0, intFloor(delayMs));
  _delayedCallbacks.push({ id, dueTime: nowMs() + safeDelay, active: true, callback, variable });
  return id;
}

export function removeDelayedCallback(id: number): void {
  for (const d of _delayedCallbacks) {
    if (d.id === id) d.active = false;
  }
}

/** 可由剧情片段、技能机制或场景控制器统一取消的任务组。 */
export interface 可取消任务组 {
  添加延迟(毫秒: number, 回调: (this: void, variable?: any) => void, 变量?: any): number;
  添加周期(间隔毫秒: number, 回调: (this: void, variable?: any) => void, 变量?: any): number;
  取消(任务ID: number): void;
  清空(): void;
}

class 可取消任务组实现 implements 可取消任务组 {
  private readonly 任务列表: Array<{ id: number; 类型: "延迟" | "周期" }> = [];

  添加延迟(毫秒: number, 回调: (this: void, variable?: any) => void, 变量?: any): number {
    const id = addDelayedCallback(毫秒, 回调, 变量);
    this.任务列表.push({ id, 类型: "延迟" });
    return id;
  }

  添加周期(间隔毫秒: number, 回调: (this: void, variable?: any) => void, 变量?: any): number {
    const id = addPeriodicCallback(间隔毫秒, 回调, 变量);
    this.任务列表.push({ id, 类型: "周期" });
    return id;
  }

  取消(任务ID: number): void {
    if (!(任务ID > 0)) return;
    for (let i = this.任务列表.length - 1; i >= 0; i--) {
      const task = this.任务列表[i];
      if (task.id !== 任务ID) continue;
      if (task.类型 === "延迟") removeDelayedCallback(task.id);
      else removePeriodicCallback(task.id);
      this.任务列表.splice(i, 1);
      return;
    }
  }

  清空(): void {
    for (let i = 0; i < this.任务列表.length; i++) {
      const task = this.任务列表[i];
      if (task.类型 === "延迟") removeDelayedCallback(task.id);
      else removePeriodicCallback(task.id);
    }
    this.任务列表.length = 0;
  }
}

export function 创建可取消任务组(this: void): 可取消任务组 {
  return new 可取消任务组实现();
}

export function onSecond(callback: () => void): void {
  _secondCallbacks.push(callback);
}

export function onTick10ms(callback: () => void): void {
  _tickCallbacks.push(callback);
}

export function offSecond(callback: () => void): void {
  removeFnFromArray(_secondCallbacks, callback);
}

export function offTick10ms(callback: () => void): void {
  removeFnFromArray(_tickCallbacks, callback);
}

export function initCenterTimer(): void {
  if (_initialized) return;
  if (bootstrapTimer) {
    DestroyTimer(bootstrapTimer);
    bootstrapTimer = null;
  }
  _initialized = true;

  // 不再使用平台服务器开局时间，逻辑时钟从 0 开始。
  // const startTime = DzAPI_Map_GetGameStartTime();
  // _serverTime = startTime * 1000;

  const dr = jassGlobals.udg_N as number | undefined;
  if (dr !== undefined) {
    _gameDifficulty = maxNum(1, intFloor(dr));
  }

  calcDate(BASE_TIMESTAMP + _serverTime / 1000);

  const timer = CreateTimer();
  TimerStart(timer, 0.01, true, onTick);
}

bootstrapTimer = CreateTimer();
TimerStart(bootstrapTimer, 0.0, false, initCenterTimer);

export {};
