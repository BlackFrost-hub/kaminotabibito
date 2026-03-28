/**
 * UI工具函数 - 通用的UI创建和管理函数
 * 只使用 BACKDROP + GLUETEXTBUTTON（War3 JAPI 兼容的帧类型）
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { getGameUI, frameSetScriptByCode } from "../00．核心系统/硬件函数";

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

/**
 * 创建Frame
 */
export function createFrame(config: FrameConfig): number | null {
  const { type, name, parent = 0, template = "template", id = 0 } = config;

  if (typeof japi.DzCreateFrameByTagName !== "function") {
    return null;
  }

  // 1.27e 下部分类型（尤其 SIMPLEFRAME）用 DzCreateFrameByTagName 易触发引擎级崩溃
  // 这些类型应优先走 DzCreateFrame(FDF) 路径；此处兜底直接返回 null，交给上层 fallback 策略。
  if (type === FrameType.SIMPLEFRAME) {
    return null;
  }

  const frame = japi.DzCreateFrameByTagName(type, name, parent, template, id);
  // 注意：Lua 里 0 也是 truthy，不能用 `if (!frame)` 这种方式防守
  if (frame == null || frame === 0) return null;

  if (config.visible !== undefined && typeof japi.DzFrameShow === "function") {
    (pcall as any)(() => {
      japi.DzFrameShow(frame, config.visible);
    });
  }

  // 1.27e 下 DzFrameSetEnable 对部分帧类型会直接引擎级 crash。
  // 按需策略：只在明确需要“禁用”时调用；enable=true 依赖默认启用状态。
  if (config.enable === false && typeof japi.DzFrameSetEnable === "function") {
    (pcall as any)(() => {
      japi.DzFrameSetEnable(frame, false);
    });
  }

  if (config.alpha !== undefined && typeof japi.DzFrameSetAlpha === "function") {
    (pcall as any)(() => {
      japi.DzFrameSetAlpha(frame, config.alpha);
    });
  }

  if (config.level !== undefined && typeof japi.DzFrameSetLevel === "function") {
    (pcall as any)(() => {
      japi.DzFrameSetLevel(frame, config.level);
    });
  }

  return frame;
}

/**
 * 安全加载 TOC（只加载一次）：
 * - 允许同时传多个可能路径（你这套项目里常见：`UI\\xxx.toc` 与 `war3mapImported\\UI\\xxx.toc`）
 * - 用 `pcall` 包住 Lua 层异常，避免初始化流程被 Lua 报错打断
 *
 * 注意：如果客户端在绘制/交互阶段对某些 FDF 帧直接“引擎级崩溃”，`pcall` 也拦不住；
 * 所以仍建议“分阶段/白名单”逐步替换控件类型。
 */
const __tocLoadedOnce: Record<string, boolean> = {};

export function loadTocOnce(
  tocLoadKey: string,
  tocPaths: string[],
  debugPrefix: string = "UI"
): void {
  if (__tocLoadedOnce[tocLoadKey]) return;
  __tocLoadedOnce[tocLoadKey] = true;

  if (typeof japi.DzLoadToc !== "function") return;

  for (const p of tocPaths) {
    const ok = (pcall as any)(() => {
      japi.DzLoadToc(p);
    });
    if (!ok) {
      const pr = (globalThis as any).print;
      if (typeof pr === "function") pr("[" + debugPrefix + "] DzLoadToc fail: " + p);
    }
  }
}

export interface TryCreateFromFdfOptions {
  tocLoadKey: string;
  tocPaths: string[];
  debugPrefix?: string;
}

/**
 * `DzLoadToc` + `DzCreateFrame` try/fallback 的通用封装。
 *
 * 用法示例（放在某个 UI 模块里）：
 * ```ts
 * const f = tryCreateFromFdfSafe("TaskEntryIcon", parent, () =>
 *   createFrame({ type: FrameType.BACKDROP, name: "TaskEntryIcon", parent, template: "template", visible: true })
 * , {
 *   tocLoadKey: "TaskUI",
 *   tocPaths: ["UI\\\\TaskUI.toc", "war3mapImported\\\\UI\\\\TaskUI.toc"],
 *   debugPrefix: "TaskUI"
 * });
 * ```
 *
 * @returns 失败时返回 fallback 的结果（允许 fallback 返回 null）
 */
export function tryCreateFromFdfSafe(
  frameName: string,
  parent: number,
  fallback: () => number | null,
  opts: TryCreateFromFdfOptions
): number | null {
  loadTocOnce(opts.tocLoadKey, opts.tocPaths, opts.debugPrefix ?? "UI");

  if (typeof japi.DzCreateFrame !== "function") return fallback();

  let f: number = 0;
  const ok = (pcall as any)(() => {
    f = japi.DzCreateFrame(frameName, parent, 0);
  });

  if (ok && f != null && f !== 0) return f;
  return fallback();
}

/**
 * 设置Frame位置（绝对坐标，屏幕）
 */
export function setFramePosition(frame: number, position: PositionConfig): boolean {
  if (frame === 0 || frame == null || typeof japi.DzFrameSetAbsolutePoint !== "function") {
    return false;
  }

  japi.DzFrameSetAbsolutePoint(frame, position.point, position.x, position.y);
  return true;
}

/**
 * 设置Frame相对位置（相对父/参考帧，用于子控件）
 */
export function setFramePointRelative(
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number
): boolean {
  if (
    frame === 0 ||
    frame == null ||
    relativeFrame === 0 ||
    relativeFrame == null ||
    typeof japi.DzFrameSetPoint !== "function"
  ) {
    return false;
  }
  japi.DzFrameSetPoint(frame, point, relativeFrame, relativePoint, x, y);
  return true;
}

/**
 * 设置Frame尺寸
 */
export function setFrameSize(frame: number, size: SizeConfig): boolean {
  if (frame === 0 || frame == null || typeof japi.DzFrameSetSize !== "function") {
    return false;
  }

  japi.DzFrameSetSize(frame, size.width, size.height);
  return true;
}

/**
 * 设置Frame纹理（仅设置纹理和透明度，不使用DzFrameSetVertexColor）
 */
export function setFrameTexture(frame: number, texture: string): boolean {
  if (frame === 0 || frame == null) return false;

  if (texture && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(frame, texture, 0);
  }

  return true;
}

/**
 * 设置Frame点击事件
 */
export function setFrameClickEvent(frame: number, callback: () => void, sync: boolean = true): boolean {
  if (frame === 0 || frame == null) return false;

  frameSetScriptByCode(frame, EventType.MOUSE_CLICK, callback, sync);
  return true;
}

/**
 * 设置Frame悬停事件
 */
export function setFrameHoverEvents(
  frame: number,
  onEnter: () => void,
  onLeave: () => void,
  sync: boolean = true
): boolean {
  if (frame === 0 || frame == null) return false;

  frameSetScriptByCode(frame, EventType.MOUSE_ENTER, onEnter, sync);
  frameSetScriptByCode(frame, EventType.MOUSE_LEAVE, onLeave, sync);
  return true;
}

/**
 * 设置GLUETEXTBUTTON的文本（DzFrameSetText仅对GLUETEXTBUTTON有效）
 */
export function setButtonText(frame: number, text: string): boolean {
  if (!frame || typeof japi.DzFrameSetText !== "function") {
    return false;
  }

  japi.DzFrameSetText(frame, text);
  return true;
}

/**
 * 创建可点击的图标（BACKDROP + GLUETEXTBUTTON组合）
 */
export function createClickableIcon(
  name: string,
  parent: number,
  texture: string,
  position: PositionConfig,
  size: SizeConfig,
  onClick: () => void
): { backdrop: number; button: number } | null {
  const backdrop = createFrame({
    type: FrameType.BACKDROP,
    name: `${name}_Backdrop`,
    parent,
    template: "template",
    visible: true,
  });

  if (!backdrop) return null;

  setFramePosition(backdrop, position);
  setFrameSize(backdrop, size);
  setFrameTexture(backdrop, texture);

  const button = createFrame({
    type: FrameType.GLUETEXTBUTTON,
    name: `${name}_Button`,
    parent: backdrop,
    template: "template",
    visible: true,
    enable: true,
    alpha: 0,
  });

  if (!button) return null;

  if (typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(button, backdrop);
  } else {
    setFramePosition(button, position);
    setFrameSize(button, size);
  }

  setFrameClickEvent(button, onClick);

  return { backdrop, button };
}

/**
 * 创建文本按钮（GLUETEXTBUTTON显示文本，可点击）
 */
export function createTextButton(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig,
  size: SizeConfig,
  onClick?: () => void
): number | null {
  const frame = createFrame({
    type: FrameType.GLUETEXTBUTTON,
    name,
    parent,
    template: "template",
    visible: true,
    enable: true,
  });

  if (!frame) return null;

  setFramePosition(frame, position);
  setFrameSize(frame, size);
  setButtonText(frame, text);

  if (onClick) {
    setFrameClickEvent(frame, onClick);
  }

  return frame;
}

/**
 * 创建纯文本标签（使用TEXT类型）
 * position 支持 PositionConfig（绝对）或 RelativePositionConfig（相对父帧）
 */
export function createTextLabel(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig | RelativePositionConfig,
  size: SizeConfig
): number | null {
  const isRelative = "relativeTo" in position;
  const setPos = (f: number) => {
    if (isRelative) {
      const r = position as RelativePositionConfig;
      setFramePointRelative(f, r.point, r.relativeTo, r.relativePoint, r.x, r.y);
    } else {
      setFramePosition(f, position as PositionConfig);
    }
  };

  // 优先使用TEXT类型
  const frame = createFrame({
    type: FrameType.TEXT,
    name,
    parent,
    template: "template",
    visible: true,
  });

  if (frame) {
    setPos(frame);
    setFrameSize(frame, size);
    if (typeof japi.DzFrameSetText === "function") {
      japi.DzFrameSetText(frame, text);
    }
    return frame;
  }

  // 回退到GLUETEXTBUTTON
  const fallbackFrame = createFrame({
    type: FrameType.GLUETEXTBUTTON,
    name,
    parent,
    template: "template",
    visible: true,
  });

  if (!fallbackFrame) return null;

  setPos(fallbackFrame);
  setFrameSize(fallbackFrame, size);
  setButtonText(fallbackFrame, text);

  return fallbackFrame;
}

/**
 * 创建文本框（使用TEXTAREA类型，带背景）
 */
export function createTextArea(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig,
  size: SizeConfig,
  backgroundTexture?: string
): number | null {
  // 创建背景
  const backdrop = createFrame({
    type: FrameType.BACKDROP,
    name: `${name}_Backdrop`,
    parent,
    template: "template",
    visible: true,
  });

  if (backdrop) {
    setFramePosition(backdrop, position);
    setFrameSize(backdrop, size);
    if (backgroundTexture && typeof japi.DzFrameSetTexture === "function") {
      japi.DzFrameSetTexture(backdrop, backgroundTexture, 0);
    }
  }

  // 创建TEXTAREA
  const frame = createFrame({
    type: FrameType.TEXTAREA,
    name,
    parent: backdrop || parent,
    template: "template",
    visible: true,
  });

  if (frame) {
    // 使用DzFrameSetAllPoints让TEXTAREA填充背景
    if (backdrop && typeof japi.DzFrameSetAllPoints === "function") {
      japi.DzFrameSetAllPoints(frame, backdrop);
    } else {
      setFramePosition(frame, position);
      setFrameSize(frame, size);
    }
    if (typeof japi.DzFrameSetText === "function") {
      japi.DzFrameSetText(frame, text);
    }
    return frame;
  }

  // 回退到TEXT
  return createTextLabel(name, parent, text, position, size);
}

/**
 * 创建带背景的文本框容器
 */
export function createTextBox(
  name: string,
  parent: number,
  text: string,
  position: PositionConfig,
  size: SizeConfig,
  backgroundTexture: string
): { backdrop: number; text: number } | null {
  // 创建背景
  const backdrop = createFrame({
    type: FrameType.BACKDROP,
    name: `${name}_Backdrop`,
    parent,
    template: "template",
    visible: true,
  });

  if (!backdrop) return null;

  setFramePosition(backdrop, position);
  setFrameSize(backdrop, size);
  setFrameTexture(backdrop, backgroundTexture);

  // 创建文本
  const textFrame = createFrame({
    type: FrameType.TEXT,
    name: `${name}_Text`,
    parent: backdrop,
    template: "template",
    visible: true,
  });

  if (!textFrame) {
    destroyFrame(backdrop);
    return null;
  }

  // 文本稍微内缩
  const innerPos: PositionConfig = {
    point: position.point,
    x: position.x + 0.005,
    y: position.y - 0.005,
  };
  const innerSize: SizeConfig = {
    width: size.width - 0.01,
    height: size.height - 0.01,
  };

  setFramePosition(textFrame, innerPos);
  setFrameSize(textFrame, innerSize);

  if (typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(textFrame, text);
  }

  return { backdrop, text: textFrame };
}

/**
 * 销毁Frame
 */
export function destroyFrame(frame: number): boolean {
  if (!frame || typeof japi.DzDestroyFrame !== "function") {
    return false;
  }

  japi.DzDestroyFrame(frame);
  return true;
}

/**
 * 隐藏Frame
 */
export function hideFrame(frame: number): boolean {
  if (!frame || typeof japi.DzFrameShow !== "function") {
    return false;
  }

  japi.DzFrameShow(frame, false);
  return true;
}

/**
 * 显示Frame
 */
export function showFrame(frame: number): boolean {
  if (!frame || typeof japi.DzFrameShow !== "function") {
    return false;
  }

  japi.DzFrameShow(frame, true);
  return true;
}

/**
 * 获取游戏UI根Frame
 */
export function getGameUIFrame(): number {
  return getGameUI();
}
