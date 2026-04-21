/**
 * 泄露审计 - 单位组
 */

const jass = require("jass.common") as Record<string, unknown>;
import { track, untrack } from "./01．核心统计";

export function createGroup(tag: string): any {
  const g = (jass as any).CreateGroup();
  track("group", g, tag);
  return g;
}

export function destroyGroup(gp: any): void {
  if (!gp) return;
  untrack("group", gp);
  (jass as any).DestroyGroup(gp);
}
