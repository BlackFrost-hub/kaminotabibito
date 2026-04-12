/**
 * 泄露审计 - 计时器
 */

const jass = require("jass.common") as Record<string, unknown>;
import { track, untrack } from "./01．核心统计";

/** 创建计时器（记得用 destroyTimer 回收），tag 代表来源模块 */
export function createTimer(tag: string): any {
  const t = (jass as any).CreateTimer();
  track("timer", t, tag);
  return t;
}

export function destroyTimer(t: any): void {
  if (!t) return;
  untrack("timer", t);
  if (typeof (jass as any).DestroyTimer === "function") {
    (jass as any).DestroyTimer(t);
  }
}
