/** @noSelfInFile */

const japi = require("jass.japi") as any;
const Frame工具 = require("lib.扩展函数.封装函数.04．硬件输入.index") as {
  frameSetScriptByCode: (this: void, frame: number, eventId: number, action: () => void, sync: boolean, playerId?: number) => void;
};

import { FRAME_EVENT_MOUSE_CLICK, FRAME_EVENT_MOUSE_ENTER, FRAME_EVENT_MOUSE_LEAVE } from "./00．常量定义";
import { 游戏说明页面 } from "./02．内容数据";
import type { 手册UI帧 } from "./03．手册UI创建";
import { 设置手册帧显示 } from "./03．手册UI创建";
import { 开始翻页动画, 是否正在翻页, 停止翻页动画 } from "./04．翻页动画";

const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

let 手册UI: 手册UI帧 | null = null;
let 当前页 = 0;
let 是否打开 = false;

function 有效帧(this: void, frame: number): boolean {
  return frame != null && frame !== 0;
}

function 规范页码(this: void, pageIndex: number): number {
  if (游戏说明页面.length <= 0) return 0;
  if (pageIndex < 0) return 游戏说明页面.length - 1;
  if (pageIndex >= 游戏说明页面.length) return 0;
  return pageIndex;
}

function 渲染当前页(this: void): void {
  if (手册UI == null) return;
  const page = 游戏说明页面[当前页];
  if (page == null) return;

  DzFrameSetText(手册UI.titleText, page.标题);
  DzFrameSetText(手册UI.bodyText, page.正文);
}

function 翻页结束(this: void): void {
  当前页 = 规范页码(当前页 + 1);
  渲染当前页();
}

function onNextEnter(this: void): void {
  if (手册UI == null || !是否打开 || 是否正在翻页()) return;
  DzFrameShow(手册UI.indicator, true);
  DzFrameShow(手册UI.hintText, true);
}

function onNextLeave(this: void): void {
  if (手册UI == null) return;
  DzFrameShow(手册UI.indicator, false);
  DzFrameShow(手册UI.hintText, false);
}

function onNextClick(this: void): void {
  if (手册UI == null || !是否打开 || 是否正在翻页()) return;
  DzFrameShow(手册UI.indicator, false);
  DzFrameShow(手册UI.hintText, false);
  开始翻页动画(翻页结束);
}

function onCloseClick(this: void): void {
  关闭游戏说明手册();
}

export function 初始化手册交互(this: void, ui: 手册UI帧): void {
  手册UI = ui;
  if (有效帧(ui.nextHotspot)) {
    Frame工具.frameSetScriptByCode(ui.nextHotspot, FRAME_EVENT_MOUSE_ENTER, onNextEnter, false);
    Frame工具.frameSetScriptByCode(ui.nextHotspot, FRAME_EVENT_MOUSE_LEAVE, onNextLeave, false);
    Frame工具.frameSetScriptByCode(ui.nextHotspot, FRAME_EVENT_MOUSE_CLICK, onNextClick, false);
  }
  if (有效帧(ui.closeHotspot)) {
    Frame工具.frameSetScriptByCode(ui.closeHotspot, FRAME_EVENT_MOUSE_CLICK, onCloseClick, false);
  }
}

export function 打开游戏说明手册(this: void): void {
  if (手册UI == null) return;
  是否打开 = true;
  渲染当前页();
  设置手册帧显示(手册UI, true);
}

export function 关闭游戏说明手册(this: void): void {
  if (手册UI == null) return;
  是否打开 = false;
  停止翻页动画();
  设置手册帧显示(手册UI, false);
}

export function 切换游戏说明手册(this: void): void {
  if (是否打开) {
    关闭游戏说明手册();
  } else {
    打开游戏说明手册();
  }
}
