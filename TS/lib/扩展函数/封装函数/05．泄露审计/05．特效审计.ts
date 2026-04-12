/**
 * 泄露审计 - 特效
 */

const jass = require("jass.common") as Record<string, unknown>;
import { track, untrack } from "./01．核心统计";

/** 创建特效：你可以先用原生创建好 effect，再传进来 trackEffect(tag, effect) */
export function trackEffect(tag: string, eff: any): void {
  track("effect", eff, tag);
}

export function destroyEffect(eff: any): void {
  if (!eff) return;
  untrack("effect", eff);
  if (typeof (jass as any).DestroyEffect === "function") {
    (jass as any).DestroyEffect(eff);
  }
}
