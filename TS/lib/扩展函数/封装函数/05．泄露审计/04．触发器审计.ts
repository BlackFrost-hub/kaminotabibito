/**
 * 泄露审计 - 触发器
 */

const jass = require("jass.common") as Record<string, unknown>;
import { track, untrack } from "./01．核心统计";

export function createTrigger(tag: string): any {
  const trg = (jass as any).CreateTrigger();
  track("trigger", trg, tag);
  return trg;
}

export function destroyTrigger(trg: any): void {
  if (!trg) return;
  untrack("trigger", trg);
  (jass as any).DestroyTrigger(trg);
}
