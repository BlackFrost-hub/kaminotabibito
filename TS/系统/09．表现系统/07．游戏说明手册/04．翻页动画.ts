/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { MANUAL_FLIP_DURATION } from "./00．常量定义";
import type { 手册UI帧 } from "./03．手册UI创建";

const CreateTimer = jass.CreateTimer as () => any;
const PauseTimer = jass.PauseTimer as (timer: any) => void;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, handler: () => void) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

let 动画UI: 手册UI帧 | null = null;
let 翻页计时器: any = null;
let 正在翻页 = false;
let 当前帧序号 = 0;
let 翻页完成回调: (() => void) | null = null;

function 确保计时器(this: void): void {
  if (翻页计时器 != null && 翻页计时器 !== 0) return;
  翻页计时器 = CreateTimer();
}

function 停止计时器(this: void): void {
  if (翻页计时器 == null || 翻页计时器 === 0) return;
  PauseTimer(翻页计时器);
}

function 隐藏所有翻页帧(this: void): void {
  if (动画UI == null) return;
  for (let i = 0; i < 动画UI.overlays.length; i++) {
    DzFrameShow(动画UI.overlays[i], false);
  }
}

function 翻页动画Tick(this: void): void {
  if (!正在翻页 || 动画UI == null) {
    停止计时器();
    return;
  }

  if (当前帧序号 >= 动画UI.overlays.length) {
    正在翻页 = false;
    隐藏所有翻页帧();
    停止计时器();
    if (翻页完成回调 != null) 翻页完成回调();
    return;
  }

  隐藏所有翻页帧();
  DzFrameShow(动画UI.overlays[当前帧序号], true);
  当前帧序号 += 1;
}

export function 初始化翻页动画(this: void, ui: 手册UI帧): void {
  动画UI = ui;
  确保计时器();
}

export function 是否正在翻页(this: void): boolean {
  return 正在翻页;
}

export function 开始翻页动画(this: void, onFinish: () => void): void {
  if (动画UI == null) return;
  if (正在翻页) return;
  if (动画UI.overlays.length <= 0) {
    onFinish();
    return;
  }

  确保计时器();
  正在翻页 = true;
  当前帧序号 = 0;
  翻页完成回调 = onFinish;

  const interval = MANUAL_FLIP_DURATION / 动画UI.overlays.length;
  TimerStart(翻页计时器, interval, true, 翻页动画Tick);
}

export function 停止翻页动画(this: void): void {
  正在翻页 = false;
  隐藏所有翻页帧();
  停止计时器();
}
