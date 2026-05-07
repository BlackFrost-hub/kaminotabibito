/** @noSelfInFile */
import type { BuffData } from "../../05．Buff系统/01．Buff表";

// ========== 虚拟分区：Buff 表数据源 ==========
const debuffMod = require("系统.05．Buff系统.01．Buff表") as { buffs: Record<string, BuffData> };
const debuffBuffs = debuffMod.buffs;
const DOT_BUFF_ROWS = {
  antiHeal: "D001",
  burn: "D002",
  poison: "D003",
  trollCurse: "D004",
} as const;
type DotBuffTypeId = keyof typeof DOT_BUFF_ROWS;

// ========== 虚拟分区：效果/ID 映射 ==========
/** DOT 每跳 `AddSpecialEffectTarget` 的模型路径，与同 ID 行的 `effect` 一致 */
export function dotEffectModelFromBuffRow(rowId: "D001" | "D002" | "D003" | "D004"): string {
  const row = debuffBuffs[rowId];
  return row != null && typeof row.effect === "string" && row.effect !== "" ? row.effect : "";
}

/** 与 Buff表 buffID 对齐，供 UI/其它系统引用 */
export const DOT_DEBUFF_IDS = {
  antiHeal: debuffBuffs[DOT_BUFF_ROWS.antiHeal]?.buffID ?? DOT_BUFF_ROWS.antiHeal,
  burn: debuffBuffs[DOT_BUFF_ROWS.burn]?.buffID ?? DOT_BUFF_ROWS.burn,
  poison: debuffBuffs[DOT_BUFF_ROWS.poison]?.buffID ?? DOT_BUFF_ROWS.poison,
  trollCurse: debuffBuffs[DOT_BUFF_ROWS.trollCurse]?.buffID ?? DOT_BUFF_ROWS.trollCurse,
} as const;

export function getDotBuffRow(typeId: DotBuffTypeId): "D001" | "D002" | "D003" | "D004" {
  return DOT_BUFF_ROWS[typeId];
}

// ========== 虚拟分区：DOT 类型定义 ==========
/** 单种 DOT 的配置 */
export interface DotTypeConfig {
  id: string;
  debuffDotEnemyNoStructure?: boolean;
  parseBuff: (this: void, buffStr: string) => { duration: number; [key: string]: any } | null;
  getBestFromUnit: (this: void, unit: any) => { duration: number; [key: string]: any } | null;
  computeAmount: (this: void, target: any, parsed: any) => number;
  damageType: any;
  effectModel: string;
  effectDuration: number;
  onApply?: (this: void, target: any, state: any) => void;
  onTick?: (this: void, target: any, state: any) => void;
  onEnd?: (this: void, target: any, state: any) => void;
  attackOnlyTrigger?: boolean;
}

// ========== 虚拟分区：DOT 运行时状态 ==========
/** 单目标某种 DOT 的状态 */
export interface DotState {
  effect: number;
  remaining: number;
  sourceName?: string;
  _dotParsedDuration?: number;
  [key: string]: any;
}
