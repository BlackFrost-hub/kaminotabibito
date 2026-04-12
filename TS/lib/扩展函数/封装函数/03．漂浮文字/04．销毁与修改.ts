/**
 * 漂浮文字 - 销毁与修改
 */

const jass = require("jass.common") as any;
const { LeakWatcher } = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher: any };

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
