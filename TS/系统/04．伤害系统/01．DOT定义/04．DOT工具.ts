/** @noSelfInFile */
import type { DotState } from "./01．DOT配置";

const jass = require("jass.common") as any;

// ========== 虚拟分区：HandleId ==========
/** Lua 下单位作表键时，伤害回调的 target 与选中枚举的 sole 可能不是同一 userdata；统一用 GetHandleId 作键。 */
export function unitHid(u: any): number {
  if (u == null || u === 0) return 0;
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
  const n = (jass as any).GetUnitName(u);
  if (n !== undefined && n !== null && `${n}` !== "") return `${n}`;
  return "未知";
}

// ========== 虚拟分区：扁平化存储（禁止 state[x][y] 二级链式） ==========
/**
 * 扁平化存储：key 格式 "typeId|hid"（typeId 字符串，hid 纯数字）
 * 禁止使用 stateByType[typeId][hid] 形式的二级链式索引
 * 排序规则：先按 typeId 字符串字典序，再按 hid 数值（固定语义，勿改）
 */
export const dotStateFlat: Record<string, DotState> = {};
export const ignoredTargetFlat: Record<string, boolean> = {};

/** 生成扁平 key */
export function makeDotFlatKey(typeId: string, hid: number): string {
  return `${typeId}|${hid}`;
}

/** 严格纯数字解析：整串必须为十进制数字且 > 0，不接受 "123abc" 之类 */
function parseStrictPositiveInt(s: string): number | null {
  if (s === "") return null;
  for (let i = 0; i < s.length; i++) {
    const ch = s.substring(i, i + 1);
    if (ch < "0" || ch > "9") return null;
  }
  const n = parseInt(s, 10);
  if (isNaN(n) || n <= 0) return null;
  return n;
}

/** 解析扁平 key - 使用字符串操作而非正则（TSTL 不支持正则） */
export function parseDotFlatKey(key: string): { typeId: string; hid: number } | null {
  const idx = key.indexOf("|");
  if (idx <= 0) return null;
  const typeId = key.substring(0, idx);
  const hidStr = key.substring(idx + 1);
  const hid = parseStrictPositiveInt(hidStr);
  if (typeId === "" || hid === null) return null;
  return { typeId, hid };
}

/** 读取 DOT 状态 */
export function getDotState(typeId: string, hid: number): DotState | null {
  const key = makeDotFlatKey(typeId, hid);
  const state = dotStateFlat[key];
  return isValidDotStateRow(state) ? state : null;
}

/** 写入 DOT 状态 */
export function setDotState(typeId: string, hid: number, state: DotState): void {
  const key = makeDotFlatKey(typeId, hid);
  dotStateFlat[key] = state;
}

/** 删除 DOT 状态 */
export function deleteDotState(typeId: string, hid: number): void {
  const key = makeDotFlatKey(typeId, hid);
  delete dotStateFlat[key];
}

/** 设置忽略目标 */
export function setIgnoredTarget(typeId: string, hid: number): void {
  ignoredTargetFlat[makeDotFlatKey(typeId, hid)] = true;
}

/** 清除忽略目标 */
export function clearIgnoredTarget(typeId: string, hid: number): void {
  delete ignoredTargetFlat[makeDotFlatKey(typeId, hid)];
}

/** 检查忽略目标 */
export function isIgnoredTarget(typeId: string, hid: number): boolean {
  return ignoredTargetFlat[makeDotFlatKey(typeId, hid)] === true;
}

/**
 * 收集所有活跃的 (typeId, hid) 对，按数值排���
 * 排序：先按 typeId 字符串字典序，再按 hid 数值（固定语义）
 */
export function collectActiveDotPairs(): { typeId: string; hid: number }[] {
  const out: { typeId: string; hid: number }[] = [];
  for (const k in dotStateFlat) {
    const p = parseDotFlatKey(k);
    if (p) out.push(p);
  }
  // 固定排序语义：先 typeId 字典序，再 hid 数值
  out.sort((a, b) => {
    if (a.typeId !== b.typeId) return a.typeId < b.typeId ? -1 : (a.typeId > b.typeId ? 1 : 0);
    return a.hid - b.hid;
  });
  return out;
}

