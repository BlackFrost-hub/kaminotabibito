/**
 * UI工具 - 类型定义
 * Frame类型常量、事件类型、配置接口
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { getGameUI, frameSetScriptByCode } from "../../00．核心系统/04．硬件函数";

/**
 * Frame类型常量（DzAPI 支持的类型）
 */
export const FrameType = {
  BACKDROP: "BACKDROP",             // 背景
  TEXT: "TEXT",                     // 文本
  TEXTAREA: "TEXTAREA",             // 文字框
  GLUETEXTBUTTON: "GLUETEXTBUTTON", // 按钮
  GLUECHECKBOX: "GLUECHECKBOX",     // 复选框
  POPUPMENU: "POPUPMENU",           // 弹出菜单
  SCROLLBAR: "SCROLLBAR",           // 滚动条
  SPRITE: "SPRITE",                 // 小精灵/电影肖像
  SLIDER: "SLIDER",                 // 滑块
  BUTTON: "BUTTON",                 // 按钮
  EDITBOX: "EDITBOX",               // 编辑框/文本框
  HIGHLIGHT: "HIGHLIGHT",           // 高光模板
  MENU: "MENU",                     // 菜单
  DIALOG: "DIALOG",                 // 对话框
  SIMPLEFRAME: "SIMPLEFRAME",       // 简单框架
  SIMPLESTATUSBAR: "SIMPLESTATUSBAR", // 简易状态条
  SIMPLECHECKBOX: "SIMPLECHECKBOX", // 简单复选框
} as const;

/** FDF 层：Layer "ARTWORK" = 插图层 */
export const FrameLayer = {
  ARTWORK: "ARTWORK",
} as const;

/**
 * Frame点常量（对应DzFrameSetAbsolutePoint的point参数）
 */
export const FramePoint = {
  TOPLEFT: 0,
  TOP: 1,
  TOPRIGHT: 2,
  LEFT: 3,
  CENTER: 4,
  RIGHT: 5,
  BOTTOMLEFT: 6,
  BOTTOM: 7,
  BOTTOMRIGHT: 8,
} as const;

/**
 * 事件类型常量（对应 DzFrameSetScript / DzFrameSetScriptByCode 的 eventId，与 Blizzard Frame 事件编号一致）。
 * 说明：部分 GUI/1.27e 下 Frame 层**不保证**单独派发「按下」；若 ID5 无效，拖拽起点请用 **DzTriggerRegisterMouseEventByCode**（全局鼠标），勿死绑帧上 MOUSE_DOWN。
 */
export const EventType = {
  MOUSE_CLICK: 1,
  MOUSE_ENTER: 2,
  MOUSE_LEAVE: 3,
  MOUSE_UP: 4,
  /** 理论上的鼠标按下（Blizzard FRAMEEVENT_MOUSE_DOWN）；Frame 层可能不暴露/不触发，勿当作必有 */
  MOUSE_DOWN: 5,
  MOUSE_WHEEL: 6,
  MOUSE_DOUBLE_CLICK: 12,
  SLIDER_VALUE_CHANGED: 11, // FRAMEEVENT_SLIDER_VALUE_CHANGED
} as const;

/**
 * 创建Frame的配置接口
 */
export interface FrameConfig {
  type: string;
  name: string;
  parent?: number;
  template?: string;
  id?: number;
  visible?: boolean;
  enable?: boolean;
  alpha?: number;
  level?: number;
}

/**
 * 位置配置接口
 */
export interface PositionConfig {
  point: number;
  x: number;
  y: number;
}

/** 相对父帧的位置配置 */
export interface RelativePositionConfig {
  relativeTo: number;
  point: number;
  relativePoint: number;
  x: number;
  y: number;
}

/**
 * 尺寸配置接口
 */
export interface SizeConfig {
  width: number;
  height: number;
}

export interface TryCreateFromFdfOptions {
  tocLoadKey: string;
  tocPaths: string[];
  debugPrefix?: string;
}
