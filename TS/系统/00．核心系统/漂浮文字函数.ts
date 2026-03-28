/**
 * 漂浮文字系统 - 创建各种浮动文字效果
 * 
 * 功能：
 * - 可附着单位（自动跟随）
 * - 可固定坐标
 * - 自定义颜色、透明度、大小
 * - 自定义移动速度
 * - 自动销毁（存在时间）
 */

const jass = require("jass.common") as any;
const { LeakWatcher } = require("系统.00．核心系统.泄露审计") as { LeakWatcher: any };

// 回收队列：避免“每个 texttag 一个 timer”在高频创建时丢回调导致不销毁
type FloatTextItem = { tt: any; ticksLeft: number };
const floatTextQueue: FloatTextItem[] = [];
let floatTextRecycleTimer: any = null;
const RECYCLE_TICK = 0.05; // 20Hz 足够平滑且开销低

function ensureFloatTextRecycleTimer(): void {
  if (floatTextRecycleTimer != null) return;
  if (typeof (jass as any).TimerStart !== "function") return;
  floatTextRecycleTimer =
    LeakWatcher && typeof LeakWatcher.createTimer === "function"
      ? LeakWatcher.createTimer("float_text_recycle")
      : (jass as any).CreateTimer?.();
  if (floatTextRecycleTimer == null) return;
  (jass as any).TimerStart(floatTextRecycleTimer, RECYCLE_TICK, true, () => {
    // 倒序遍历，便于删除
    for (let i = floatTextQueue.length - 1; i >= 0; i--) {
      const it = floatTextQueue[i];
      it.ticksLeft--;
      if (it.ticksLeft <= 0) {
        const tt = it.tt;
        if (tt) {
          if (LeakWatcher && typeof LeakWatcher.destroyTextTag === "function") LeakWatcher.destroyTextTag(tt);
          else if (typeof (jass as any).DestroyTextTag === "function") (jass as any).DestroyTextTag(tt);
        }
        floatTextQueue.splice(i, 1);
      }
    }
    if (floatTextQueue.length === 0) {
      // 停掉并销毁回收 timer
      const t = floatTextRecycleTimer;
      floatTextRecycleTimer = null;
      if (LeakWatcher && typeof LeakWatcher.destroyTimer === "function") LeakWatcher.destroyTimer(t);
      else if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(t);
    }
  });
}

// 存储最后创建的漂浮文字（替代 bj_lastCreatedTextTag）
export let lastCreatedTextTag: any = null;

/**
 * 漂浮文字配置选项
 */
export interface FloatTextOptions {
  /** 显示的文字 */
  text: string;
  
  /** 字体大小 */
  size?: number;
  
  /** 红色分量 (0-255) */
  red?: number;
  
  /** 绿色分量 (0-255) */
  green?: number;
  
  /** 蓝色分量 (0-255) */
  blue?: number;
  
  /** 透明度 (0-255, 0=不透明, 255=全透明) */
  alpha?: number;
  
  /** 存在时间（秒），0=永久 */
  duration?: number;
  
  /** X轴移动速度 */
  speedX?: number;
  
  /** Y轴移动速度 */
  speedY?: number;
  
  /** 高度偏移（默认0） */
  height?: number;
  
  /** 是否允许永久显示（duration=0时有效） */
  permanent?: boolean;
}

/**
 * 创建漂浮文字
 * @param targetUnit 目标单位（指定则忽略坐标）
 * @param x X坐标（当targetUnit为null时使用）
 * @param y Y坐标（当targetUnit为null时使用）
 * @param options 文字配置选项
 * @returns 创建的漂浮文字句柄
 */
export function CreateFloatText(
  targetUnit: any | null,
  x: number,
  y: number,
  options: FloatTextOptions
): any {
  const {
    text,
    size = 10,
    red = 255,
    green = 255,
    blue = 255,
    alpha = 0,
    duration = 1,
    speedX = 0,
    speedY = 0.07,
    height = 0,
    permanent = false
  } = options;

  // 使用 common.j 原生 API（CreateTextTagUnitBJ/CreateTextTagLocBJ 在 1.27 Lua 中可能为 nil）
  const textTag =
    LeakWatcher && typeof LeakWatcher.createTextTag === "function"
      ? LeakWatcher.createTextTag("float_text")
      : typeof (jass as any).CreateTextTag === "function"
        ? (jass as any).CreateTextTag()
        : null;
  if (!textTag) return null;

  const sizeToHeight = size * 0.0023; // 约等于 TextTagSize2Height(size)，10 -> 0.023
  if (typeof (jass as any).SetTextTagText === "function") {
    (jass as any).SetTextTagText(textTag, text, sizeToHeight);
  }
  if (typeof (jass as any).SetTextTagColor === "function") {
    (jass as any).SetTextTagColor(textTag, red, green, blue, alpha);
  }
  if (targetUnit && typeof (jass as any).SetTextTagPosUnit === "function") {
    (jass as any).SetTextTagPosUnit(textTag, targetUnit, height);
  } else if (typeof (jass as any).SetTextTagPos === "function") {
    (jass as any).SetTextTagPos(textTag, x, y, height);
  }
  if (typeof (jass as any).SetTextTagVisibility === "function") {
    (jass as any).SetTextTagVisibility(textTag, true);
  }
  if ((speedX !== 0 || speedY !== 0) && typeof (jass as any).SetTextTagVelocity === "function") {
    (jass as any).SetTextTagVelocity(textTag, speedX, speedY);
  }
  if (!permanent && duration > 0) {
    if (typeof (jass as any).SetTextTagLifespan === "function") (jass as any).SetTextTagLifespan(textTag, duration);
    if (typeof (jass as any).SetTextTagFadepoint === "function") (jass as any).SetTextTagFadepoint(textTag, duration - 0.5);
    // 统一进入回收队列（避免高频创建时 timer 回调丢失）
    const ticks = Math.max(1, Math.floor(duration / RECYCLE_TICK + 0.999)); // ceil
    floatTextQueue.push({ tt: textTag, ticksLeft: ticks });
    ensureFloatTextRecycleTimer();
  }

  // 记录最后创建的漂浮文字
  lastCreatedTextTag = textTag;

  return textTag;
}

/**
 * 创建漂浮文字（简化版，仅单位）
 */
export function CreateFloatTextOnUnit(
  unit: any,
  text: string,
  options?: Partial<FloatTextOptions>
): any {
  return CreateFloatText(unit, 0, 0, {
    text,
    ...options
  });
}

/**
 * 创建漂浮文字（简化版，仅坐标）
 */
export function CreateFloatTextAtPoint(
  x: number,
  y: number,
  text: string,
  options?: Partial<FloatTextOptions>
): any {
  return CreateFloatText(null, x, y, {
    text,
    ...options
  });
}

/**
 * 销毁漂浮文字
 */
export function DestroyFloatText(textTag: any): void {
  if (!textTag) return;

  if (LeakWatcher && typeof LeakWatcher.destroyTextTag === "function") {
    LeakWatcher.destroyTextTag(textTag);
  } else if (typeof (jass as any).DestroyTextTag === "function") {
    (jass as any).DestroyTextTag(textTag);
  }
}

/**
 * 设置漂浮文字文字内容
 */
export function SetFloatTextText(textTag: any, text: string): void {
  if (textTag) {
    (jass as any).SetTextTagText(textTag, text, 0);
  }
}

/**
 * 设置漂浮文字颜色
 */
export function SetFloatTextColor(
  textTag: any,
  red: number,
  green: number,
  blue: number,
  alpha: number
): void {
  if (textTag) {
    (jass as any).SetTextTagColor(textTag, red, green, blue, alpha);
  }
}

/**
 * 设置漂浮文字位置（固定坐标）
 */
export function SetFloatTextPosition(
  textTag: any,
  x: number,
  y: number,
  height: number
): void {
  if (textTag) {
    (jass as any).SetTextTagPos(textTag, x, y, height);
  }
}

/**
 * 设置漂浮文字速度
 */
export function SetFloatTextVelocity(
  textTag: any,
  speedX: number,
  speedY: number
): void {
  if (textTag) {
    (jass as any).SetTextTagVelocity(textTag, speedX, speedY);
  }
}