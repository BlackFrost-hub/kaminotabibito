/** @noSelfInFile */

const japi = require("jass.japi") as any;

import { MANUAL_FLIP_DURATION } from "./00．常量定义";
import type { 手册UI帧 } from "./03．手册UI创建";
import { onTick10ms } from "../../00．核心系统/05．中心计时器";

const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

const CENTER_TICK_SECONDS = 0.01;

let 动画UI: 手册UI帧 | null = null;
let 正在翻页 = false;
let 当前帧序号 = 0;
let 翻页累计时间 = 0;
let 翻页帧间隔 = 0;
let 翻页完成回调: (() => void) | null = null;
let 已注册中心计时器 = false;

function 隐藏所有翻页帧(this: void): void {
  if (动画UI == null) return;
  for (let i = 0; i < 动画UI.overlays.length; i++) {
    DzFrameShow(动画UI.overlays[i], false);
  }
}

export function 显示翻页预览(this: void): void {
  if (动画UI == null || 正在翻页 || 动画UI.overlays.length <= 0) return;
  隐藏所有翻页帧();
  DzFrameShow(动画UI.overlays[0], true);
}

export function 隐藏翻页预览(this: void): void {
  if (正在翻页) return;
  隐藏所有翻页帧();
}

function 翻页动画Tick(this: void): void {
  if (!正在翻页 || 动画UI == null) {
    return;
  }

  翻页累计时间 += CENTER_TICK_SECONDS;
  if (翻页累计时间 < 翻页帧间隔) return;
  翻页累计时间 = 0;

  if (当前帧序号 >= 动画UI.overlays.length) {
    正在翻页 = false;
    隐藏所有翻页帧();
    if (翻页完成回调 != null) 翻页完成回调();
    return;
  }

  隐藏所有翻页帧();
  DzFrameShow(动画UI.overlays[当前帧序号], true);
  当前帧序号 += 1;
}

export function 初始化翻页动画(this: void, ui: 手册UI帧): void {
  动画UI = ui;
  if (已注册中心计时器) return;
  已注册中心计时器 = true;
  onTick10ms(翻页动画Tick);
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

  正在翻页 = true;
  当前帧序号 = 0;
  翻页帧间隔 = MANUAL_FLIP_DURATION / 动画UI.overlays.length;
  翻页累计时间 = 翻页帧间隔;
  翻页完成回调 = onFinish;
}

export function 停止翻页动画(this: void): void {
  正在翻页 = false;
  翻页累计时间 = 0;
  隐藏所有翻页帧();
}
