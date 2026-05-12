/** @noSelfInFile */
/**
 * 漂浮文字 - 销毁与修改
 */

const jass = require("jass.common") as any;
const { LeakWatcher } = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher: any };
const leakDestroyTextTag =
  LeakWatcher && typeof LeakWatcher.destroyTextTag === "function"
    ? (LeakWatcher.destroyTextTag as (this: void, textTag: any) => void)
    : null;

/**
 * 销毁漂浮文字
 */
export function DestroyFloatText(this: void, textTag: any): void {
  if (!textTag) return;

  // 对 permanent=true / lifespan=0 的文字，先强制改成可回收状态，再销毁。
  jass.SetTextTagPermanent(textTag, false);
  jass.SetTextTagVisibility(textTag, false);
  jass.SetTextTagFadepoint(textTag, 0);
  jass.SetTextTagLifespan(textTag, 0.01);

  if (leakDestroyTextTag != null) {
    leakDestroyTextTag(textTag);
  } else {
    jass.DestroyTextTag(textTag);
  }
}

/**
 * 设置漂浮文字文字内容
 */
export function SetFloatTextText(this: void, textTag: any, text: string): void {
  if (textTag) {
    jass.SetTextTagText(textTag, text, 0);
  }
}

/**
 * 设置漂浮文字颜色
 */
export function SetFloatTextColor(
  this: void,
  textTag: any,
  red: number,
  green: number,
  blue: number,
  alpha: number
): void {
  if (textTag) {
    jass.SetTextTagColor(textTag, red, green, blue, alpha);
  }
}

/**
 * 设置漂浮文字位置（固定坐标）
 */
export function SetFloatTextPosition(
  this: void,
  textTag: any,
  x: number,
  y: number,
  height: number
): void {
  if (textTag) {
    jass.SetTextTagPos(textTag, x, y, height);
  }
}

/**
 * 设置漂浮文字速度
 */
export function SetFloatTextVelocity(
  this: void,
  textTag: any,
  speedX: number,
  speedY: number
): void {
  if (textTag) {
    jass.SetTextTagVelocity(textTag, speedX, speedY);
  }
}
