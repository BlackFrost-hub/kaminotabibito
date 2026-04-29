/** @noSelfInFile */
/**
 * 技能吟唱条系统 - 渲染层
 *
 * 职责：
 * - 吟唱条 Frame 工具封装（DzFrame 系列）
 * - 创建 / 每帧更新 / 销毁 UI 帧
 * - 吟唱条数据存储（Map）与中心计时器驱动
 *
 * 不包含：生命周期入口、STES 输入注册。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { ceil, max, forEachSorted } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  ceil: (value: number) => number;
  max: (a: number, b: number) => number;
  forEachSorted: <K extends number | string, V>(map: Map<K, V>, callback: (key: K, value: V) => void) => void;
};

const {
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
} = require("系统.03．技能系统.07．技能吟唱条.00．常量定义") as {
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
};

// ==========================================================================================
// 类型定义
// ==========================================================================================

/** 吟唱条数据 */
export interface CastBarData {
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
// 数据存储 + 句柄分配
// ==========================================================================================

/** 吟唱条数据 Map：句柄ID -> 数据 */
export const castBarDataMap = new Map<number, CastBarData>();

let nextHandleId = 1;
function getNextHandleId(): number {
  return nextHandleId++;
}

// ==========================================================================================
// 帧工具（DzFrame 系列）
// ==========================================================================================

function formatTime(this: void, time: number): string {
  const intPart = jass.R2I(time);
  const decPart = jass.R2I((time - intPart) * 10);
  return intPart + "." + decPart;
}

function getForegroundModel(this: void, colorId: number): string {
  return FOREGROUND_MODELS[colorId] || FOREGROUND_MODELS[DEFAULT_COLOR_ID];
}

function getBackgroundModel(this: void, colorId: number): string {
  return BACKGROUND_MODELS[colorId] || BACKGROUND_MODELS[DEFAULT_COLOR_ID];
}

function createFrame(this: void, tagName: string, name: string, parent: any): any {
  return japi.DzCreateFrameByTagName(tagName, name, parent, "template", 0);
}

function setFrameAbsolutePoint(this: void, frame: any, x: number, y: number): void {
  japi.DzFrameSetAbsolutePoint(frame, 4, x, y);
}

function setFramePoint(this: void, frame: any, parent: any, offsetX: number, offsetY: number): void {
  japi.DzFrameSetPoint(frame, 4, parent, 4, offsetX, offsetY);
}

function setFrameModel(this: void, frame: any, modelPath: string): void {
  japi.DzFrameSetModel(frame, modelPath, 0, 0);
}

function setFrameAnimateOffset(this: void, frame: any, offset: number): void {
  japi.DzFrameSetAnimateOffset(frame, offset);
}

function setFrameAnimate(this: void, frame: any, animId: number, autoPlay: boolean): void {
  japi.DzFrameSetAnimate(frame, animId, autoPlay);
}

function showFrame(this: void, frame: any, show: boolean): void {
  japi.DzFrameShow(frame, show);
}

function setFrameText(this: void, frame: any, text: string): void {
  japi.DzFrameSetText(frame, text);
}

function setFramePriority(this: void, frame: any, priority: number): void {
  japi.DzFrameSetPriority(frame, priority);
}

function destroyFrame(this: void, frame: any): void {
  japi.DzDestroyFrame(frame);
}

function getGameUI(this: void): any {
  return japi.DzGetGameUI();
}

// ==========================================================================================
// 渲染：创建 / 更新 / 销毁
// ==========================================================================================

/** 每 tick 推进所有吟唱条，完成时销毁帧并从 Map 移除 */
function updateAllCastBars(this: void): void {
  const deltaTime = UPDATE_INTERVAL;

  forEachSorted(castBarDataMap, (handleId, data) => {
    data.elapsedTime += deltaTime;
    data.progress = data.elapsedTime / data.totalTime;

    const animOffset = 1.0 - data.progress;
    setFrameAnimateOffset(data.foreground, animOffset);

    const remaining = data.totalTime - data.elapsedTime;
    setFrameText(data.countdown, formatTime(max(0, remaining)));

    if (data.elapsedTime >= data.totalTime) {
      showFrame(data.foreground, false);

      destroyFrame(data.background);
      destroyFrame(data.textDisplay);
      destroyFrame(data.progressFrame);
      destroyFrame(data.symbol);
      destroyFrame(data.countdown);
      destroyFrame(data.tip);
      destroyFrame(data.foreground);

      castBarDataMap.delete(handleId);
    }
  });
}

/** 创建吟唱条 UI 帧组 */
function createCastBarUI(this: void, colorId: number, totalTime: number, customString: string): CastBarData | null {
  const gameUI = getGameUI();
  if (!gameUI) return null;

  // 隐藏上一个场地 UI
  const prevUI = (globalThis as any).__lastCastBarUI;
  if (prevUI) {
    showFrame(prevUI, false);
  }

  const foreground = createFrame("SPRITE", "吟唱条前景", gameUI);
  if (!foreground) return null;

  setFrameModel(foreground, getForegroundModel(colorId));
  setFrameAbsolutePoint(foreground, BAR_POS_X, BAR_POS_Y);
  setFrameAnimate(foreground, 0, false);
  setFrameAnimateOffset(foreground, 1.0);
  showFrame(foreground, true);

  (globalThis as any).__lastCastBarUI = foreground;

  const background = createFrame("SPRITE", "吟唱条背景", foreground);
  if (background) {
    setFrameModel(background, getBackgroundModel(colorId));
    setFrameAbsolutePoint(background, BAR_POS_X, BAR_POS_Y);
    setFramePriority(background, 0);
  }

  const textDisplay = createFrame("TEXT", "吟唱条文本", foreground);
  if (textDisplay) {
    setFramePoint(textDisplay, foreground, TEXT_OFFSET_X, TEXT_OFFSET_Y);
    setFrameText(textDisplay, DEFAULT_CAST_TEXT);
    setFramePriority(textDisplay, 2);
  }

  const progressFrame = createFrame("TEXT", "吟唱条进度", foreground);
  if (progressFrame) {
    setFramePoint(progressFrame, foreground, PROGRESS_OFFSET_X, PROGRESS_OFFSET_Y);
    setFrameText(progressFrame, "0.0");
    setFramePriority(progressFrame, 2);
  }

  const symbol = createFrame("TEXT", "吟唱条符号", foreground);
  if (symbol) {
    setFramePoint(symbol, foreground, SYMBOL_OFFSET_X, PROGRESS_OFFSET_Y);
    setFrameText(symbol, "/");
    setFramePriority(symbol, 2);
  }

  const countdown = createFrame("TEXT", "吟唱条时间", foreground);
  if (countdown) {
    setFramePoint(countdown, foreground, COUNTDOWN_OFFSET_X, PROGRESS_OFFSET_Y);
    setFrameText(countdown, formatTime(totalTime));
    setFramePriority(countdown, 2);
  }

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

// ==========================================================================================
// 中心计时器集成
// ==========================================================================================

let _registeredToCenterTimer = false;
let _tickCounter = 0;
const CENTER_TIMER_TICKS = ceil(UPDATE_INTERVAL / 0.01);

function onCastBarCenterTimerTick(this: void): void {
  if (castBarDataMap.size === 0) return;

  _tickCounter = _tickCounter + 1;
  if (_tickCounter >= CENTER_TIMER_TICKS) {
    _tickCounter = 0;
    updateAllCastBars();
  }
}

function ensureRegisteredToCenterTimer(this: void): void {
  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

const { onTick10ms } = globalThis as unknown as {
    onTick10ms: (callback: () => void) => void;
  };

  onTick10ms(onCastBarCenterTimerTick);
}

// ==========================================================================================
// 对外：启动一个吟唱条（生命周期入口调用）
// ==========================================================================================

/** 创建 UI + 入表 + 确保 tick 已注册 */
export function startCastBar(this: void, colorId: number, totalTime: number, customString: string): void {
  const data = createCastBarUI(colorId, totalTime, customString);
  if (!data) return;

  const handleId = getNextHandleId();
  castBarDataMap.set(handleId, data);

  ensureRegisteredToCenterTimer();
}

export {};
