/** @noSelfInFile */

// 手册主背景尺寸与屏幕中心点。Dz UI 坐标不是像素，数值需要结合实际游戏内效果微调。
export const MANUAL_WIDTH = 0.36;
export const MANUAL_HEIGHT = 0.56;
export const MANUAL_CENTER_X = 0.4;
export const MANUAL_CENTER_Y = 0.31;

// 翻页动画总时长，以及右下角翻页热区、关闭热区的可点击范围。
export const MANUAL_FLIP_DURATION = 0.18;
export const MANUAL_HOTSPOT_WIDTH = 0.06;
export const MANUAL_HOTSPOT_HEIGHT = 0.07;
export const MANUAL_CLOSE_WIDTH = 0.035;
export const MANUAL_CLOSE_HEIGHT = 0.035;

// 正文文本框。偏移基于手册背景左上角，Y 为负数表示向下移动。
export const MANUAL_BODY_TEXT_WIDTH = 0.25;
export const MANUAL_BODY_TEXT_HEIGHT = 0.31;
export const MANUAL_BODY_TEXT_OFFSET_X = 0.064;
export const MANUAL_BODY_TEXT_OFFSET_Y = -0.116;

// 标题文本框。需要避开背景上方花纹，所以和正文分开调位置。
export const MANUAL_TITLE_OFFSET_X = 0.064;
export const MANUAL_TITLE_OFFSET_Y = -0.082;
export const MANUAL_TITLE_WIDTH = 0.25;
export const MANUAL_TITLE_HEIGHT = 0.035;

// 手册文本字体与字号。DzFrameSetFont 的字号是 UI 坐标量级，不是传统像素字号。
export const MANUAL_FONT = "UI\\uizt.ttf";
export const MANUAL_BODY_FONT_SIZE = 0.0126;
export const MANUAL_TITLE_FONT_SIZE = 0.015;

// DzFrameSetPoint 使用的锚点枚举。
export const FRAME_POINT_TOPLEFT = 0;
export const FRAME_POINT_CENTER = 4;
export const FRAME_POINT_BOTTOMRIGHT = 8;

// DzFrameSetScriptByCode 使用的鼠标事件 ID。
export const FRAME_EVENT_MOUSE_CLICK = 1;
export const FRAME_EVENT_MOUSE_ENTER = 2;
export const FRAME_EVENT_MOUSE_LEAVE = 3;
export const FRAME_EVENT_MOUSE_UP = 4;

// 帧层级优先级。翻页贴图盖在底图上，正文和提示需要盖在对应可见贴图上。
export const MANUAL_BASE_PRIORITY = 0;
export const MANUAL_FLIP_PRIORITY_START = 1000;
export const MANUAL_BODY_PRIORITY = 1500;
export const MANUAL_INDICATOR_PRIORITY = 2000;
export const MANUAL_HOTSPOT_PRIORITY = 3000;
