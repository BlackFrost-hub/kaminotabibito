/**
 * 主线引导框架
 *
 * DzFrame UI 创建、frame 句柄模块变量
 * UI 全局创建，不放 GetLocalPlayer 内创建
 */

const japi = require("jass.japi") as any;

// ========== JASS / japi 局部别名 ==========

const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (
  this: void,
  type: string,
  name: string,
  parent: number,
  template: string,
  id: number,
) => number;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (
  this: void,
  frame: number,
  point: number,
  x: number,
  y: number,
) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (this: void, frame: number, w: number, h: number) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (this: void, frame: number, texture: string, flag: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (
  this: void,
  frame: number,
  point: number,
  relFrame: number,
  relPoint: number,
  x: number,
  y: number,
) => void;
const DzFrameSetText = japi.DzFrameSetText as (this: void, frame: number, text: string) => void;
const DzFrameShow = japi.DzFrameShow as (this: void, frame: number, show: boolean) => void;
const DzGetGameUI = japi.DzGetGameUI as (this: void) => number;

// ========== 常量 ==========

const FRAME_POINT_CENTER = 4;

const BTN_ICON_TEXTURE = "ReplaceableTextures\\CommandButtons\\BTNStaffOfPurification.blp";
const TEXTBOX_TEXTURE = "war3mapImported\\wenbenkuang.blp";

// ========== 帧引用（模块级） ==========

export const 帧 = {
  主线任务: 0,
  任务提示: 0,
  放大效果: 0,
  文本框: 0,
  提示文本: 0,
  按钮: 0,
};

// ========== UI 创建 ==========

/**
 * 创建主线引导 UI 帧树
 * 全局创建，不放 GetLocalPlayer 内
 */
export function 创建主线引导帧(this: void): void {
  const gameUI = DzGetGameUI();

  // 主线任务入口图标
  帧.主线任务 = DzCreateFrameByTagName("BACKDROP", "主线任务", gameUI, "template", 0);
  DzFrameSetAbsolutePoint(帧.主线任务, FRAME_POINT_CENTER, 0.20, 0.5573046);
  DzFrameSetSize(帧.主线任务, 0.03, 0.03);
  DzFrameSetTexture(帧.主线任务, BTN_ICON_TEXTURE, 0);

  // "主线引导" 标签
  帧.任务提示 = DzCreateFrameByTagName("TEXT", "任务提示", 帧.主线任务, "template", 0);
  DzFrameSetAbsolutePoint(帧.任务提示, FRAME_POINT_CENTER, 0.21, 0.55);
  DzFrameSetSize(帧.任务提示, 0.055, 0.056);
  DzFrameSetText(帧.任务提示, "|cffffff00主线引导|r");
  DzFrameShow(帧.任务提示, true);

  // 放大效果帧（默认隐藏）
  帧.放大效果 = DzCreateFrameByTagName("BACKDROP", "放大效果", 帧.主线任务, "template", 0);
  DzFrameSetPoint(帧.放大效果, FRAME_POINT_CENTER, 帧.主线任务, FRAME_POINT_CENTER, 0, 0);
  DzFrameSetSize(帧.放大效果, 0.04, 0.04);
  DzFrameSetTexture(帧.放大效果, BTN_ICON_TEXTURE, 0);
  DzFrameShow(帧.放大效果, false);

  // 文本框背景（默认隐藏）
  帧.文本框 = DzCreateFrameByTagName("BACKDROP", "主线任务文本框", 帧.主线任务, "template", 0);
  DzFrameSetTexture(帧.文本框, TEXTBOX_TEXTURE, 0);
  DzFrameSetSize(帧.文本框, 0.10, 0.10);
  DzFrameSetPoint(帧.文本框, FRAME_POINT_CENTER, 帧.主线任务, FRAME_POINT_CENTER, 0.00, 0);
  DzFrameShow(帧.文本框, false);

  // 提示文本
  帧.提示文本 = DzCreateFrameByTagName("TEXT", "主线任务提示文本", 帧.文本框, "template", 0);
  DzFrameSetSize(帧.提示文本, 0.03, 0.03);
  DzFrameSetPoint(帧.提示文本, FRAME_POINT_CENTER, 帧.文本框, FRAME_POINT_CENTER, 0.00, 0);
  DzFrameSetText(帧.提示文本, "");
}

/**
 * 创建可点击按钮并注册 sync=true 回调
 * 按钮覆盖在主图标上
 */
export function 创建主线引导按钮(this: void, onClick: (this: void) => void): void {
  const DzFrameSetScriptByCode = japi.DzFrameSetScriptByCode as (
    this: void,
    frame: number,
    eventId: number,
    action: (this: void) => void,
    sync: boolean,
  ) => void;

  const FRAME_EVENT_MOUSE_CLICK = 1;

  帧.按钮 = DzCreateFrameByTagName("GLUETEXTBUTTON", "主线按钮", 帧.主线任务, "template", 0);
  DzFrameSetAbsolutePoint(帧.按钮, FRAME_POINT_CENTER, 0.20, 0.5573046);
  DzFrameSetSize(帧.按钮, 0.03, 0.03);
  DzFrameSetScriptByCode(帧.按钮, FRAME_EVENT_MOUSE_CLICK, onClick, true);
}
