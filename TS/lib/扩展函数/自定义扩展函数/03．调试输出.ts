/** @noSelfInFile */

const jass = require("jass.common") as any;

const _print = (globalThis as any).print as ((...args: any[]) => void) | undefined;
const _pcall = pcall as unknown as (callback: (this: any) => void) => boolean;
const _xpcall = (globalThis as any).xpcall as
  | undefined
  | ((callback: (this: any) => void, handler: (this: void, error: any) => string) => boolean);
const _luaDebug = (globalThis as any).debug as {
  traceback?: (message: string, level?: number) => string;
  getinfo?: (callback: any, what?: string) => {
    name?: any;
    short_src?: any;
    source?: any;
    linedefined?: any;
  } | undefined;
} | undefined;
const _traceback = _luaDebug != null
  ? (_luaDebug.traceback as ((this: void, message: string, level?: number) => string) | undefined)
  : undefined;
const _getInfo = _luaDebug != null
  ? (_luaDebug.getinfo as ((this: void, callback: any, what?: string) => {
    name?: any;
    short_src?: any;
    source?: any;
    linedefined?: any;
  } | undefined) | undefined)
  : undefined;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  player: any,
  x: number,
  y: number,
  duration: number,
  msg: string
) => void;
const Player = jass.Player as (index: number) => any;

const DEBUG_FLAGS: Record<string, boolean> = {};
const 运行时错误提示玩家数 = 12;
const 运行时错误提示持续时间 = 20;
const 运行时错误屏幕最大行数 = 6;
const 运行时错误屏幕最大字符数 = 900;
const 当前运行时错误堆栈栈: string[] = [];

function toMessagePart(value: any): string {
  if (value == null) return "nil";
  return tostring(value);
}

function normalizeModuleName(module: any): string {
  if (module == null || module === "") return "未标记模块";
  return tostring(module);
}

function joinMessageParts(args: any[]): string {
  const parts: string[] = [];
  for (let i = 0; i < args.length; i++) {
    parts.push(toMessagePart(args[i]));
  }
  return parts.join(" ");
}

function runtimeErrorTracebackHandler(this: void, error: any): string {
  const errorText = toMessagePart(error);
  let tracebackText = errorText;
  if (typeof _traceback === "function") {
    tracebackText = _traceback(errorText, 2);
  }
  当前运行时错误堆栈栈.push(tracebackText);
  return tracebackText;
}

/**
 * 取得回调的源码位置，供基础调度器把错误归属到实际业务回调。
 * Lua 的函数名在被保存到表后不一定可用，因此同时保留源码和定义行。
 */
export function getCallbackDebugLabel(this: void, callback: any): string {
  if (typeof _getInfo !== "function" || typeof callback !== "function") return "";
  const info = _getInfo(callback, "Snl");
  if (info == null) return "";

  const source = info.short_src != null ? toMessagePart(info.short_src) : toMessagePart(info.source);
  const line = info.linedefined != null ? toMessagePart(info.linedefined) : "";
  if (source !== "nil" && source !== "") {
    return line !== "" && line !== "nil" ? source + ":" + line : source;
  }

  const name = info.name != null ? toMessagePart(info.name) : "";
  return name !== "nil" ? name : "";
}

function limitRuntimeErrorText(text: string): string {
  const lines = text.split("\n");
  let result = "";
  const count = lines.length > 运行时错误屏幕最大行数 ? 运行时错误屏幕最大行数 : lines.length;
  for (let i = 0; i < count; i++) {
    if (i > 0) result += "\n";
    result += lines[i];
  }
  if (lines.length > count) {
    result += "\n...";
  }
  if (result.length > 运行时错误屏幕最大字符数) {
    result = result.substring(0, 运行时错误屏幕最大字符数) + "\n...";
  }
  return result;
}

export function setDebug(module: string, on: boolean): void {
  DEBUG_FLAGS[normalizeModuleName(module)] = on;
}

export function isDebug(module: string): boolean {
  return DEBUG_FLAGS[normalizeModuleName(module)] === true;
}

export function debugLog(module: string, ...args: any[]): void {
  const moduleName = normalizeModuleName(module);
  if (!isDebug(moduleName)) return;
  if (!_print) return;
  const prefix = "[" + moduleName + "] ";
  _print(prefix, ...args);
}

export function debugLogForce(module: string, ...args: any[]): void {
  const moduleName = normalizeModuleName(module);
  if (!_print) return;
  const prefix = "[" + moduleName + "] ";
  _print(prefix, ...args);
}

export function reportRuntimeError(module: string, error: any, ...details: any[]): void {
  const moduleName = normalizeModuleName(module);
  const errorText = toMessagePart(error);
  const detailText = details.length > 0 ? joinMessageParts(details) : "";
  debugLogForce(moduleName, "运行时错误", errorText, detailText);

  let message = "|cffff2020[地图程序错误]|r |cffff8080" + moduleName + "|r\n|cffffffff" + limitRuntimeErrorText(errorText) + "|r";
  if (detailText !== "") {
    message += "\n|cffd8d8d8" + limitRuntimeErrorText(detailText) + "|r";
  }

  for (let i = 0; i < 运行时错误提示玩家数; i++) {
    DisplayTimedTextToPlayer(Player(i), 0, 0, 运行时错误提示持续时间, message);
  }
}

export function safeExecute(module: string | ((this: any) => void), callback?: (this: any) => void): boolean {
  let moduleName = normalizeModuleName(module);
  let targetCallback = callback;
  if (typeof module === "function") {
    const callbackLabel = getCallbackDebugLabel(module);
    moduleName = callbackLabel !== "" ? callbackLabel : "未标记模块";
    targetCallback = module;
  }
  if (typeof targetCallback !== "function") return false;
  if (moduleName === "联机安全回调") {
    const callbackLabel = getCallbackDebugLabel(targetCallback);
    if (callbackLabel !== "") moduleName += " -> " + callbackLabel;
  }
  if (typeof _xpcall === "function") {
    const errorStackStart = 当前运行时错误堆栈栈.length;
    const ok = _xpcall(targetCallback, runtimeErrorTracebackHandler);
    if (!ok) {
      let errorText = "未知运行时错误";
      if (当前运行时错误堆栈栈.length > errorStackStart) {
        errorText = 当前运行时错误堆栈栈[当前运行时错误堆栈栈.length - 1];
      }
      while (当前运行时错误堆栈栈.length > errorStackStart) 当前运行时错误堆栈栈.pop();
      reportRuntimeError(moduleName, errorText);
      return false;
    }
    while (当前运行时错误堆栈栈.length > errorStackStart) 当前运行时错误堆栈栈.pop();
    return true;
  }
  const ok = _pcall(targetCallback);
  if (!ok) {
    reportRuntimeError(moduleName, "运行时错误，当前 Lua 环境未提供 xpcall 堆栈");
    return false;
  }
  return true;
}
