/** @noSelfInFile */

import {
  Boss战候选音频变量名列表,
  Boss战运行模块名,
  Boss战胜利音乐保留毫秒,
} from "./00．常量定义";
import {
  type Boss战运行上下文,
  读取矩形当前Boss战上下文,
  设置矩形当前Boss战上下文,
} from "./01．Boss战运行上下文";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { SetStackedSoundBJ } = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  SetStackedSoundBJ: (this: void, add: boolean, soundHandle: any, rectHandle: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, moduleName: string, ...args: any[]) => void;
};

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

function 获取句柄ID(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

function 矩形添加音频(this: void, rectHandle: any, soundHandle: any): void {
  if (rectHandle == null || rectHandle === 0) return;
  if (soundHandle == null || soundHandle === 0) return;
  SetStackedSoundBJ(true, soundHandle, rectHandle);
}

function 矩形移除音频(this: void, rectHandle: any, soundHandle: any): void {
  if (rectHandle == null || rectHandle === 0) return;
  if (soundHandle == null || soundHandle === 0) return;
  SetStackedSoundBJ(false, soundHandle, rectHandle);
}

export function 清理矩形Boss战候选音频(this: void, rectHandle: any): void {
  if (rectHandle == null || rectHandle === 0) return;

  const 已处理音频表: Record<number, true | undefined> = {};
  for (let i = 0; i < Boss战候选音频变量名列表.length; i++) {
    const 变量名 = Boss战候选音频变量名列表[i];
    const 音频句柄 = jglobals[变量名];
    const 音频句柄ID = 获取句柄ID(音频句柄);
    if (音频句柄ID === 0 || 已处理音频表[音频句柄ID]) continue;
    已处理音频表[音频句柄ID] = true;
    矩形移除音频(rectHandle, 音频句柄);
  }
}

export function 接管Boss战区域音频(this: void, context: Boss战运行上下文): void {
  if (context.地点句柄ID === 0 || context.地点矩形 == null || context.地点矩形 === 0) return;

  const 旧上下文 = 读取矩形当前Boss战上下文(context.地点句柄ID);
  if (旧上下文 != null && 旧上下文.运行代次 !== context.运行代次) {
    旧上下文.胜利音乐移除时间 = 0;
  }

  清理矩形Boss战候选音频(context.地点矩形);
  矩形添加音频(context.地点矩形, context.战斗音乐);
  设置矩形当前Boss战上下文(context.地点句柄ID, context);

  debugLogForce(Boss战运行模块名, "接管区域音频", "rect=", context.地点句柄ID, "generation=", context.运行代次);
}

export function 结束Boss战区域音频(this: void, context: Boss战运行上下文, nowMs: number): void {
  if (context.地点句柄ID === 0 || context.地点矩形 == null || context.地点矩形 === 0) return;

  const 当前矩形上下文 = 读取矩形当前Boss战上下文(context.地点句柄ID);
  if (当前矩形上下文 != null && 当前矩形上下文.运行代次 !== context.运行代次) {
    return;
  }

  矩形移除音频(context.地点矩形, context.战斗音乐);
  矩形添加音频(context.地点矩形, context.胜利音乐);
  context.胜利音乐移除时间 = nowMs + Boss战胜利音乐保留毫秒;
  设置矩形当前Boss战上下文(context.地点句柄ID, context);

  debugLogForce(
    Boss战运行模块名,
    "切换胜利音频",
    "rect=",
    context.地点句柄ID,
    "generation=",
    context.运行代次,
    "removeAt=",
    context.胜利音乐移除时间
  );
}

export function 尝试移除过期胜利音频(this: void, context: Boss战运行上下文, nowMs: number): boolean {
  if (!context.是否已结束) return false;
  if (context.胜利音乐移除时间 <= 0 || nowMs < context.胜利音乐移除时间) return false;
  if (context.地点句柄ID === 0 || context.地点矩形 == null || context.地点矩形 === 0) return false;

  const 当前矩形上下文 = 读取矩形当前Boss战上下文(context.地点句柄ID);
  if (当前矩形上下文 == null || 当前矩形上下文.运行代次 !== context.运行代次) {
    context.胜利音乐移除时间 = 0;
    return true;
  }

  矩形移除音频(context.地点矩形, context.胜利音乐);
  context.胜利音乐移除时间 = 0;
  设置矩形当前Boss战上下文(context.地点句柄ID, undefined);

  debugLogForce(Boss战运行模块名, "移除过期胜利音频", "rect=", context.地点句柄ID, "generation=", context.运行代次);
  return true;
}
