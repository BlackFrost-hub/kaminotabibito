/**
 * 泄露审计 - 漂浮文字
 */

const jass = require("jass.common") as Record<string, unknown>;
import { track, untrack } from "./01．核心统计";

/** 创建漂浮文字 texttag（建议搭配 destroyTextTag 回收） */
export function createTextTag(tag: string): any {
  if (typeof (jass as any).CreateTextTag !== "function") return null;
  const tt = (jass as any).CreateTextTag();
  track("texttag", tt, tag);
  return tt;
}

export function destroyTextTag(tt: any): void {
  if (!tt) return;
  untrack("texttag", tt);
  if (typeof (jass as any).DestroyTextTag === "function") {
    (jass as any).DestroyTextTag(tt);
  }
}
