import type { DotState } from "./01．DOT配置";

const jass = require("jass.common") as any;

// ========== 虚拟分区：HandleId ==========
/** Lua 下单位作表键时，伤害回调的 target 与选中枚举的 sole 可能不是同一 userdata；统一用 GetHandleId 作键。 */
export function unitHid(u: any): number {
  if (u == null || u === 0) return 0;
  if (typeof (jass as any).GetHandleId !== "function") return 0;
  return (jass as any).GetHandleId(u) as number;
}

// ========== 虚拟分区：Hid 表读写 ==========
/** pairs 迭代可能混用 number / string 键，不合并会导致「同目标两行状态」或 onDamage 读不到 cur、乘积误判。 */
export function tabRowForHid(tab: Record<any, any>, hid: number): any {
  if (hid === 0) return null;
  const n = tab[hid];
  if (n != null) return n;
  return (tab as any)[`${hid}`];
}

export function tabSetHid(tab: Record<any, any>, hid: number, state: DotState): void {
  if (hid === 0) return;
  delete (tab as any)[`${hid}`];
  tab[hid] = state;
}

export function tabDeleteHid(tab: Record<any, any>, hid: number): void {
  if (hid === 0) return;
  delete tab[hid];
  delete (tab as any)[`${hid}`];
}

export function collectHidsInTab(tab: Record<any, any>): number[] {
  const seen: Record<number, boolean> = {};
  const out: number[] = [];
  for (const k in tab) {
    const kn = typeof k === "number" ? (k as number) : parseInt(`${k}`, 10);
    if (isNaN(kn) || kn === 0) continue;
    if (seen[kn]) continue;
    seen[kn] = true;
    out.push(kn);
  }
  return out;
}

// ========== 虚拟分区：DotState 校验/展示 ==========
/** stateByType 槽位应为 DotState 表；若被污染为数字等则剔除，避免 cur.remaining 报错 */
export function isValidDotStateRow(v: any): boolean {
  return v != null && typeof v === "object" && typeof (v as DotState).remaining === "number" && typeof (v as DotState).effect === "number";
}

export function getDotSourceDisplayName(u: any): string {
  if (u == null || u === 0) return "未知";
  if (typeof (jass as any).GetUnitName === "function") {
    const n = (jass as any).GetUnitName(u);
    if (n !== undefined && n !== null && `${n}` !== "") return `${n}`;
  }
  return "未知";
}

