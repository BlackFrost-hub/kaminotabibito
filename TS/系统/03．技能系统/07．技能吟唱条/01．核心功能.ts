/**
 * 技能吟唱条系统 - 核心功能
 *
 * 功能：创建并显示吟唱进度条UI，支持多种颜色主题
 * 不依赖YDLocal，使用Map存储数据，使用中心计时器
 *
 * 调用方式：通过STES事件「注册吟唱条」触发
 * 传参（YDLocal1Set）兼容旧接口：
 *   - 颜色ID (integer): 1-7 对应不同颜色
 *   - sj (real): 吟唱总时间（秒）
 *   - string (string): 自定义提示文本（可选）
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const {
  CAST_BAR_ENABLED,
  UPDATE_INTERVAL,
  BAR_POS_X,
  BAR_POS_Y,
  TEXT_OFFSET_X,
  TEXT_OFFSET_Y,
  PROGRESS_OFFSET_X,
  PROGRESS_OFFSET_Y,
  SYMBOL_OFFSET_X,
  COUNTDOWN_OFFSET_X,
  TIP_OFFSET_X,
  DEFAULT_COLOR_ID,
  FOREGROUND_MODELS,
  BACKGROUND_MODELS,
  DEFAULT_CAST_TEXT,
  DEFAULT_TIP_TEXT,
  EVENT_NAME_CAST_BAR,
  YDLOCAL_KEYS,
} = require("系统.03．技能系统.07．技能吟唱条.00．常量定义") as {
  CAST_BAR_ENABLED: boolean;
  UPDATE_INTERVAL: number;
  BAR_POS_X: number;
  BAR_POS_Y: number;
  TEXT_OFFSET_X: number;
  TEXT_OFFSET_Y: number;
  PROGRESS_OFFSET_X: number;
  PROGRESS_OFFSET_Y: number;
  SYMBOL_OFFSET_X: number;
  COUNTDOWN_OFFSET_X: number;
  TIP_OFFSET_X: number;
  DEFAULT_COLOR_ID: number;
  FOREGROUND_MODELS: Record<number, string>;
  BACKGROUND_MODELS: Record<number, string>;
  DEFAULT_CAST_TEXT: string;
  DEFAULT_TIP_TEXT: string;
  EVENT_NAME_CAST_BAR: string;
  YDLOCAL_KEYS: Record<string, string>;
};

const {
  YDLocalInitialize,
  YDLocal1Release,
  YDLocal1Get,
} = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocalInitialize: () => void;
  YDLocal1Release: () => void;
  YDLocal1Get: (type: string, name: string) => any;
};

const { STES_Register } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Register: (t: any, name: string) => void;
};

// ==========================================================================================
// 类型定义
// ==========================================================================================

/** 吟唱条数据 */
interface CastBarData {
  totalTime: number;
  elapsedTime: number;
  progress: number;
  foreground: any;
  background: any;
  textDisplay: any;
  progressFrame: any;
  symbol: any;
  countdown: any;
  tip: any;
}

// ==========================================================================================
// 数据存储（使用Map，不依赖YDLocal）
// ==========================================================================================

/** 吟唱条数据Map：frame句柄 -> 数据 */
const castBarDataMap = new Map<number, CastBarData>();

/** 获取下一个可用的句柄ID */
let nextHandleId = 1;
function getNextHandleId(): number {
  return nextHandleId++;
}

// ==========================================================================================
// 工具函数
// ==========================================================================================

/**
 * 格式化时间显示（保留1位小数）
 */
function formatTime(this: void, time: number): string {
  const intPart = Math.floor(time);
  const decPart = Math.floor((time - intPart) * 10);
  return intPart + "." + decPart;
}

/**
 * 获取指定颜色ID的前景模型路径
 */
function getForegroundModel(this: void, colorId: number): string {
  return FOREGROUND_MODELS[colorId] || FOREGROUND_MODELS[DEFAULT_COLOR_ID];
}

/**
 * 获取指定颜色ID的背景模型路径
 */
function getBackgroundModel(this: void, colorId: number): string {
  return BACKGROUND_MODELS[colorId] || BACKGROUND_MODELS[DEFAULT_COLOR_ID];
}

/**
 * 创建帧
 */
function createFrame(this: void, tagName: string, name: string, parent: any): any {
  if (typeof japi.DzCreateFrameByTagName !== "function") return null;
  return japi.DzCreateFrameByTagName(tagName, name, parent, "template", 0);
}

/**
 * 设置帧的绝对位置
 */
function setFrameAbsolutePoint(this: void, frame: any, x: number, y: number): void {
  if (typeof japi.DzFrameSetAbsolutePoint !== "function") return;
  japi.DzFrameSetAbsolutePoint(frame, 4, x, y);
}

/**
 * 设置帧的相对位置
 */
function setFramePoint(this: void, frame: any, parent: any, offsetX: number, offsetY: number): void {
  if (typeof japi.DzFrameSetPoint !== "function") return;
  japi.DzFrameSetPoint(frame, 4, parent, 4, offsetX, offsetY);
}

/**
 * 设置帧模型
 */
function setFrameModel(this: void, frame: any, modelPath: string): void {
  if (typeof japi.DzFrameSetModel !== "function") return;
  japi.DzFrameSetModel(frame, modelPath, 0, 0);
}

/**
 * 设置帧动画偏移
 */
function setFrameAnimateOffset(this: void, frame: any, offset: number): void {
  if (typeof japi.DzFrameSetAnimateOffset !== "function") return;
  japi.DzFrameSetAnimateOffset(frame, offset);
}

/**
 * 设置帧动画
 */
function setFrameAnimate(this: void, frame: any, animId: number, autoPlay: boolean): void {
  if (typeof japi.DzFrameSetAnimate !== "function") return;
  japi.DzFrameSetAnimate(frame, animId, autoPlay);
}

/**
 * 显示/隐藏帧
 */
function showFrame(this: void, frame: any, show: boolean): void {
  if (typeof japi.DzFrameShow !== "function") return;
  japi.DzFrameShow(frame, show);
}

/**
 * 设置帧文本
 */
function setFrameText(this: void, frame: any, text: string): void {
  if (typeof japi.DzFrameSetText !== "function") return;
  japi.DzFrameSetText(frame, text);
}

/**
 * 设置帧优先级
 */
function setFramePriority(this: void, frame: any, priority: number): void {
  if (typeof japi.DzFrameSetPriority !== "function") return;
  japi.DzFrameSetPriority(frame, priority);
}

/**
 * 销毁帧
 */
function destroyFrame(this: void, frame: any): void {
  if (typeof japi.DzDestroyFrame !== "function") return;
  japi.DzDestroyFrame(frame);
}

/**
 * 获取游戏UI
 */
function getGameUI(this: void): any {
  if (typeof japi.DzGetGameUI !== "function") return null;
  return japi.DzGetGameUI();
}

// ==========================================================================================
// 吟唱条核心逻辑
// ==========================================================================================

/**
 * 更新所有吟唱条（由中心计时器调用）
 */
function updateAllCastBars(this: void): void {
  const deltaTime = UPDATE_INTERVAL;

  for (const [handleId, data] of castBarDataMap) {
    // 更新进度
    data.elapsedTime += deltaTime;
    data.progress = data.elapsedTime / data.totalTime;

    // 更新前景动画偏移 (1.0 -> 0.0)
    const animOffset = 1.0 - data.progress;
    setFrameAnimateOffset(data.foreground, animOffset);

    // 更新倒计时文本
    const remaining = data.totalTime - data.elapsedTime;
    setFrameText(data.countdown, formatTime(Math.max(0, remaining)));

    // 检查是否完成
    if (data.elapsedTime >= data.totalTime) {
      // 隐藏前景
      showFrame(data.foreground, false);

      // 销毁所有帧
      destroyFrame(data.background);
      destroyFrame(data.textDisplay);
      destroyFrame(data.progressFrame);
      destroyFrame(data.symbol);
      destroyFrame(data.countdown);
      destroyFrame(data.tip);
      destroyFrame(data.foreground);

      // 从Map中移除
      castBarDataMap.delete(handleId);
    }
  }
}

/**
 * 创建吟唱条UI
 */
function createCastBar(this: void, colorId: number, totalTime: number, customString: string): CastBarData | null {
  const gameUI = getGameUI();
  if (!gameUI) return null;

  // 隐藏上一个场地UI
  const prevUI = (globalThis as any).__lastCastBarUI;
  if (prevUI) {
    showFrame(prevUI, false);
  }

  // 创建前景帧
  const foreground = createFrame("SPRITE", "吟唱条前景", gameUI);
  if (!foreground) return null;

  // 设置前景模型
  setFrameModel(foreground, getForegroundModel(colorId));
  setFrameAbsolutePoint(foreground, BAR_POS_X, BAR_POS_Y);
  setFrameAnimate(foreground, 0, false);
  setFrameAnimateOffset(foreground, 1.0);
  showFrame(foreground, true);

  // 保存到全局，供下次隐藏
  (globalThis as any).__lastCastBarUI = foreground;

  // 创建背景帧
  const background = createFrame("SPRITE", "吟唱条背景", foreground);
  if (background) {
    setFrameModel(background, getBackgroundModel(colorId));
    setFrameAbsolutePoint(background, BAR_POS_X, BAR_POS_Y);
    setFramePriority(background, 0);
  }

  // 创建显示文本
  const textDisplay = createFrame("TEXT", "吟唱条文本", foreground);
  if (textDisplay) {
    setFramePoint(textDisplay, foreground, TEXT_OFFSET_X, TEXT_OFFSET_Y);
    setFrameText(textDisplay, DEFAULT_CAST_TEXT);
    setFramePriority(textDisplay, 2);
  }

  // 创建进度文本
  const progressFrame = createFrame("TEXT", "吟唱条进度", foreground);
  if (progressFrame) {
    setFramePoint(progressFrame, foreground, PROGRESS_OFFSET_X, PROGRESS_OFFSET_Y);
    setFrameText(progressFrame, "0.0");
    setFramePriority(progressFrame, 2);
  }

  // 创建中间符号
  const symbol = createFrame("TEXT", "吟唱条符号", foreground);
  if (symbol) {
    setFramePoint(symbol, foreground, SYMBOL_OFFSET_X, PROGRESS_OFFSET_Y);
    setFrameText(symbol, "/");
    setFramePriority(symbol, 2);
  }

  // 创建倒计时
  const countdown = createFrame("TEXT", "吟唱条时间", foreground);
  if (countdown) {
    setFramePoint(countdown, foreground, COUNTDOWN_OFFSET_X, PROGRESS_OFFSET_Y);
    setFrameText(countdown, formatTime(totalTime));
    setFramePriority(countdown, 2);
  }

  // 创建文本提示
  const tip = createFrame("TEXT", "吟唱条文本提示", foreground);
  if (tip) {
    setFramePoint(tip, foreground, TIP_OFFSET_X, PROGRESS_OFFSET_Y);
    setFrameText(tip, customString || DEFAULT_TIP_TEXT);
    setFramePriority(tip, 2);
  }

  return {
    totalTime,
    elapsedTime: 0,
    progress: 0,
    foreground,
    background,
    textDisplay,
    progressFrame,
    symbol,
    countdown,
    tip,
  };
}

/**
 * 启动吟唱条
 */
function startCastBar(this: void, colorId: number, totalTime: number, customString: string): void {
  // 创建吟唱条UI
  const data = createCastBar(colorId, totalTime, customString);
  if (!data) return;

  // 生成唯一ID并保存到Map
  const handleId = getNextHandleId();
  castBarDataMap.set(handleId, data);

  // 确保已注册到中心计时器
  ensureRegisteredToCenterTimer();
}

// ==========================================================================================
// 中心计时器集成
// ==========================================================================================

/** 是否已注册到中心计时器 */
let _registeredToCenterTimer = false;
/** tick计数器 */
let _tickCounter = 0;
/** 中心计时器每10毫秒tick一次，每2次tick执行一次更新（0.02秒） */
const CENTER_TIMER_TICKS = Math.ceil(UPDATE_INTERVAL / 0.01);

/**
 * 注册到中心计时器
 */
function ensureRegisteredToCenterTimer(this: void): void {
  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

  const { onTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
    onTick10ms: (callback: () => void) => void;
  };

  onTick10ms(() => {
    if (castBarDataMap.size === 0) return;

    _tickCounter = _tickCounter + 1;
    if (_tickCounter >= CENTER_TIMER_TICKS) {
      _tickCounter = 0;
      updateAllCastBars();
    }
  });
}

// ==========================================================================================
// STES事件处理
// ==========================================================================================

/**
 * STES事件处理函数
 */
function onCastBarEvent(this: void): void {
  if (!CAST_BAR_ENABLED) return;

  YDLocalInitialize();

  // 读取参数（兼容旧接口）
  const colorId = YDLocal1Get("integer", YDLOCAL_KEYS.COLOR_ID) || DEFAULT_COLOR_ID;
  const totalTime = YDLocal1Get("real", YDLOCAL_KEYS.TOTAL_TIME) || 1.0;
  const customString = YDLocal1Get("string", YDLOCAL_KEYS.CUSTOM_STRING) || "";

  YDLocal1Release();

  // 启动吟唱条
  startCastBar(colorId, totalTime, customString);
}

// ==========================================================================================
// 初始化
// ==========================================================================================

let _initialized = false;

/**
 * 初始化技能吟唱条系统
 */
export function init(this: void): void {
  if (_initialized) return;
  if (!CAST_BAR_ENABLED) return;

  if (typeof jass.CreateTrigger !== "function") return;
  if (typeof jass.TriggerAddAction !== "function") return;

  const trig = jass.CreateTrigger();
  jass.TriggerAddAction(trig, onCastBarEvent);

  STES_Register(trig, EVENT_NAME_CAST_BAR);

  _initialized = true;
}

/**
 * 手动触发吟唱条（供Lua/TS直接调用）
 * @param colorId 颜色ID (1-7)
 * @param totalTime 吟唱总时间（秒）
 * @param customString 自定义提示文本（可选）
 */
export function showCastBar(this: void, colorId: number, totalTime: number, customString?: string): void {
  if (!CAST_BAR_ENABLED) return;

  startCastBar(colorId || DEFAULT_COLOR_ID, totalTime, customString || "");
}

export {};
