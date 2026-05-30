/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const Frame工具 = require("lib.扩展函数.封装函数.04．硬件输入.index") as {
  frameSetScriptByCode: (this: void, frame: number, eventId: number, action: any, sync: boolean, playerId?: number) => void;
};

import { FRAME_EVENT_MOUSE_CLICK, FRAME_EVENT_MOUSE_ENTER, FRAME_EVENT_MOUSE_LEAVE } from "./00．常量定义";
import { 游戏说明页面 } from "./02．内容数据";
import type { 手册UI帧 } from "./03．手册UI创建";
import { 设置手册帧显示 } from "./03．手册UI创建";
import { 开始翻页动画, 是否正在翻页, 停止翻页动画, 显示翻页预览, 隐藏翻页预览 } from "./04．翻页动画";
import { Sound3DII_Mp3PlayReuse } from "../../../lib/扩展函数/封装函数/02．音效系统/index";

const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const 获取本地玩家 = jass.GetLocalPlayer as () => any;
const 翻页音效路径 = "Sound\\UIeffect\\fanye\\fanye.mp3";

let 手册UI: 手册UI帧 | null = null;
let 当前页 = 0;
let 是否打开 = false;

function 有效帧(this: void, frame: number): boolean {
  return frame != null && frame !== 0;
}

function 注册本地帧事件(this: void, frame: number, eventId: number, action: () => void): void {
  const frameSetScriptByCode = Frame工具.frameSetScriptByCode;
  if (typeof frameSetScriptByCode !== "function") return;
  frameSetScriptByCode(frame, eventId, action, false);
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

  if (有效帧(手册UI.titleText)) DzFrameSetText(手册UI.titleText, page.标题);
  if (有效帧(手册UI.bodyText)) DzFrameSetText(手册UI.bodyText, page.正文);
  for (let i = 0; i < 手册UI.overlayTitleTexts.length; i++) {
    if (有效帧(手册UI.overlayTitleTexts[i])) DzFrameSetText(手册UI.overlayTitleTexts[i], page.标题);
  }
  for (let i = 0; i < 手册UI.overlayBodyTexts.length; i++) {
    if (有效帧(手册UI.overlayBodyTexts[i])) DzFrameSetText(手册UI.overlayBodyTexts[i], page.正文);
  }
}

function 翻页结束(this: void): void {
  渲染当前页();
}

function onNextEnter(this: void): void {
  if (手册UI == null || !是否打开) return;
  显示翻页预览();
  if (有效帧(手册UI.indicator)) DzFrameShow(手册UI.indicator, true);
  if (有效帧(手册UI.hintText)) DzFrameShow(手册UI.hintText, true);
}

function onNextLeave(this: void): void {
  if (手册UI == null) return;
  隐藏翻页预览();
  if (有效帧(手册UI.indicator)) DzFrameShow(手册UI.indicator, false);
  if (有效帧(手册UI.hintText)) DzFrameShow(手册UI.hintText, false);
}

function onNextClick(this: void): void {
  if (手册UI == null || !是否打开 || 是否正在翻页()) return;
  if (有效帧(手册UI.indicator)) DzFrameShow(手册UI.indicator, false);
  if (有效帧(手册UI.hintText)) DzFrameShow(手册UI.hintText, false);
  Sound3DII_Mp3PlayReuse(翻页音效路径, 获取本地玩家());
  当前页 = 规范页码(当前页 + 1);
  开始翻页动画(翻页结束);
}

function onCloseClick(this: void): void {
  关闭游戏说明手册();
}

export function 初始化手册交互(this: void, ui: 手册UI帧): void {
  手册UI = ui;
  if (有效帧(ui.nextHotspot)) {
    注册本地帧事件(ui.nextHotspot, FRAME_EVENT_MOUSE_ENTER, onNextEnter);
    注册本地帧事件(ui.nextHotspot, FRAME_EVENT_MOUSE_LEAVE, onNextLeave);
    注册本地帧事件(ui.nextHotspot, FRAME_EVENT_MOUSE_CLICK, onNextClick);
  }
  if (有效帧(ui.closeHotspot)) {
    注册本地帧事件(ui.closeHotspot, FRAME_EVENT_MOUSE_CLICK, onCloseClick);
  }
}

export function 打开游戏说明手册(this: void): void {
  if (手册UI == null) return;
  当前页 = 0;
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
