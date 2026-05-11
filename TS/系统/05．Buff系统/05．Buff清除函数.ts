/** @noSelfInFile */
/**
 * Buff 清除函数
 *
 * 显眼入口：按 `01．Buff表.ts` 的 type 字段清除单位 Buff。
 *
 * 常用：
 * - `移除单位增益Buff(unit)`：清除 `type` 以 `Buff:` 开头的条目。
 * - `移除单位负面Buff(unit)`：清除 `type` 以 `Debuff:` 开头的条目。
 * - `移除单位指定类型Buff(unit, "Debuff:control")`：清除指定 type 前缀。
 *
 * 说明：
 * - D001-D004 是纯 TS DOT，没有原生魔法效果；清除时只停止 DOT 和自定义 BuffUI。
 * - 快速 Buff 如果绑定了原生魔法效果 rawId，底层会同步 UnitRemoveAbility。
 */

const buffPool = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffIdsOnUnit: (this: void, unit: any) => string[];
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { type?: string; canPurge?: boolean; dispelLevel?: number } | undefined>;
};

const BUFF_TABLE = buffTableMod.buffs;
const getBuffIdsOnUnit = buffPool.getBuffIdsOnUnit;
const 移除单位指定Buff = buffPool.移除单位指定Buff;

function isBuffTypeMatched(buffID: string, typePrefix: string, onlyPurgable: boolean): boolean {
  const meta = BUFF_TABLE[buffID];
  if (meta == null) return false;
  const typeName = meta.type;
  if (typeof typeName !== "string" || typeName === "") return false;
  if (typeName.substring(0, typePrefix.length) !== typePrefix) return false;
  if (onlyPurgable && meta.canPurge !== true) return false;
  return true;
}

function isBuffDispelMatched(buffID: string, typePrefix: string, maxDispelLevel: number, onlyPurgable: boolean): boolean {
  const meta = BUFF_TABLE[buffID];
  if (meta == null) return false;
  const typeName = meta.type;
  if (typeof typeName !== "string" || typeName === "") return false;
  if (typePrefix !== "" && typeName.substring(0, typePrefix.length) !== typePrefix) return false;
  if (onlyPurgable && meta.canPurge !== true) return false;
  const dispelLevel = meta.dispelLevel;
  if (typeof dispelLevel !== "number") return false;
  if (dispelLevel < 0) return false;
  return dispelLevel <= maxDispelLevel;
}

/**
 * 按 `01．Buff表.ts` 的 type 前缀清除单位 Buff。
 *
 * - `Buff:`    增益类
 * - `Debuff:` 负面类
 * - `Debuff:control` 控制类负面
 * - `Debuff:magic` 魔法类负面
 * - onlyPurgable=true 时只清 `canPurge: true` 的条目
 */
export function 移除单位指定类型Buff(unit: any, typePrefix: string, onlyPurgable: boolean = false): number {
  if (unit == null || unit === 0 || typePrefix === "") return 0;

  const ids = getBuffIdsOnUnit(unit);
  let removed = 0;
  for (let i = 0; i < ids.length; i++) {
    const buffID = ids[i];
    if (!isBuffTypeMatched(buffID, typePrefix, onlyPurgable)) continue;
    if (移除单位指定Buff(unit, buffID)) removed = removed + 1;
  }
  return removed;
}

/** 清除单位增益 Buff（Buff 表 type 以 `Buff:` 开头）。 */
export function 移除单位增益Buff(unit: any, onlyPurgable: boolean = false): number {
  return 移除单位指定类型Buff(unit, "Buff:", onlyPurgable);
}

/** 清除单位负面 Buff（Buff 表 type 以 `Debuff:` 开头）。 */
export function 移除单位负面Buff(unit: any, onlyPurgable: boolean = false): number {
  return 移除单位指定类型Buff(unit, "Debuff:", onlyPurgable);
}

/**
 * 按 Buff 表 `dispelLevel` 执行驱散。
 *
 * - `maxDispelLevel=1`：只驱散 1 级及以下
 * - `maxDispelLevel=2`：驱散 2 级及以下
 * - `typePrefix=""`：不限制类型；也可传 `Buff:` / `Debuff:` / `Debuff:control` / `Debuff:magic`
 * - `onlyPurgable=true`：只驱散 `canPurge: true` 的条目
 */
export function 按驱散等级移除单位Buff(
  unit: any,
  maxDispelLevel: number,
  typePrefix: string = "",
  onlyPurgable: boolean = true
): number {
  if (unit == null || unit === 0) return 0;
  if (typeof maxDispelLevel !== "number" || maxDispelLevel < 0) return 0;

  const ids = getBuffIdsOnUnit(unit);
  let removed = 0;
  for (let i = 0; i < ids.length; i++) {
    const buffID = ids[i];
    if (!isBuffDispelMatched(buffID, typePrefix, maxDispelLevel, onlyPurgable)) continue;
    if (移除单位指定Buff(unit, buffID)) removed = removed + 1;
  }
  return removed;
}

/** 1 级驱散：常规净化/驱散。默认只驱散 `canPurge: true`。 */
export function 一级驱散单位Buff(unit: any, typePrefix: string = "", onlyPurgable: boolean = true): number {
  return 按驱散等级移除单位Buff(unit, 1, typePrefix, onlyPurgable);
}

/** 2 级驱散：强驱散。默认只驱散 `canPurge: true`。 */
export function 二级驱散单位Buff(unit: any, typePrefix: string = "", onlyPurgable: boolean = true): number {
  return 按驱散等级移除单位Buff(unit, 2, typePrefix, onlyPurgable);
}

export {};
