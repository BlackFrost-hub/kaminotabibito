/**
 * 泄露审计 - 核心统计
 */

const jass = require("jass.common") as Record<string, unknown>;

// 目前只审计"理应被排泄"的资源：
// - 计时器 / 单位组 / 触发器 / 临时特效 / 临时矩形
// - 不记录长期存在的资源（例如可见度修正器 FogModifier），避免把设计上的常驻对象也当成泄露
export type LeakType = "timer" | "group" | "trigger" | "effect" | "rect" | "sound" | "texttag";

export interface LeakInfo {
  type: LeakType;
  tag: string;
  createdIndex: number;
  handleText: string;
}

export const alive: Record<string, LeakInfo | undefined> = {};
export const types: LeakType[] = ["timer", "group", "trigger", "effect", "rect", "sound", "texttag"];

export const stats: Record<LeakType, { created: number; destroyed: number }> = {
  timer: { created: 0, destroyed: 0 },
  group: { created: 0, destroyed: 0 },
  trigger: { created: 0, destroyed: 0 },
  effect: { created: 0, destroyed: 0 },
  rect: { created: 0, destroyed: 0 },
  sound: { created: 0, destroyed: 0 },
  texttag: { created: 0, destroyed: 0 },
};

/**
 * Lua 里同一句柄可能以不同引用传入；用 leakType+稳定字符串 作键，避免 delete 对不上导致假 alive。
 * 禁止 `local j=jass; j.GetHandleId(h)`：TSTL 会编成 `j:GetHandleId(h)`，self 传成 jass 表会崩 → 只用 `(jass as any).GetHandleId(h)`。
 * CreateSound 等若返回 table 包装，GetHandleId 会报错 → 退回 tostring(handle) 作为稳定调试键。
 * 用 TS 的 typeof：Lua 里 table→__TS__TypeOf 为 "object"，userdata 为 "userdata"，不会误判。
 */
export function leakKey(leakType: LeakType, handle: any): string {
  if (handle == null) return `${leakType}:nil`;
  if (typeof handle === "object" && handle !== null) {
    return `${leakType}:obj:${tostring(handle)}`;
  }
  return `${leakType}:${(jass as any).GetHandleId(handle)}`;
}

export function track(type: LeakType, handle: any, tag: string): void {
  if (!handle) return;
  const s = stats[type];
  s.created++;
  alive[leakKey(type, handle)] = { type, tag, createdIndex: s.created, handleText: tostring(handle) };
}

export function untrack(type: LeakType, handle: any): void {
  if (!handle) return;
  const s = stats[type];
  const key = leakKey(type, handle);
  if (alive[key] != null) {
    delete alive[key];
    s.destroyed++;
  }
}
