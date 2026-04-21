/**
 * 泄露审计 - 矩形
 */

const jass = require("jass.common") as Record<string, unknown>;
import { track, untrack } from "./01．核心统计";

export function trackRect(tag: string, rect: any): void {
  track("rect", rect, tag);
}

export function removeRect(rect: any): void {
  if (!rect) return;
  untrack("rect", rect);
  (jass as any).RemoveRect(rect);
}
