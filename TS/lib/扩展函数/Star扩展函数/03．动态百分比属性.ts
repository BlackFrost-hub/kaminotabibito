const { SGSS_SetStatePercentumEX2 } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
    SGSS_SetStatePercentumEX2: (u: any, id: number, v: number) => void;
};

/**
 * 统一处理“动态基础/最大百分比属性”
 * 支持命名格式：
 * - 最大X%
 * - 基础X%
 * 例如：最大生命值%、基础攻击力%、基础护甲%
 */

type PercentMode = "max" | "base";
type PercentApply = (unit: any, value: number) => void;

const aliasToCanonical: Record<string, string> = {
  "生命": "生命值",
  "生命上限": "生命值",
  "法力": "法力值",
  "魔法值": "法力值",
  "法力上限": "法力值",
  "攻击": "攻击力",
  "防御": "护甲",
};

const maxPercentRegistry: Record<string, PercentApply> = {
  "生命值": (unit, value) => SGSS_SetStatePercentumEX2(unit, 7, value),
  "法力值": (unit, value) => SGSS_SetStatePercentumEX2(unit, 8, value),
};

const basePercentRegistry: Record<string, PercentApply> = {
  "生命值": (unit, value) => callGSUnitPry(unit, 13, value),
  "攻击力": (unit, value) => callGSUnitPry(unit, 14, value),
  "护甲": (unit, value) => callGSUnitPry(unit, 15, value),
};

function callGSUnitPry(unit: any, id: number, value: number): void {
  const fn = (globalThis as any).GS_UnitPry;
  if (typeof fn === "function") fn(unit, 0, id, value);
}

function normalizeKey(base: string): string {
  const trimmed = (base || "").trim();
  if (trimmed === "") return "";
  return aliasToCanonical[trimmed] || trimmed;
}

function trimPercentName(name: string): { mode: PercentMode | "none"; base: string } {
  if (!name || name.length < 3 || name.indexOf("%") !== name.length - 1) return { mode: "none", base: "" };
  const core = name.substring(0, name.length - 1); // 去掉 %
  if (core.indexOf("最大") === 0) return { mode: "max", base: normalizeKey(core.substring(2)) };
  if (core.indexOf("基础") === 0) return { mode: "base", base: normalizeKey(core.substring(2)) };
  // 无前缀百分比，默认按“基础%”处理（如 护甲%、攻击力%、生命值%）
  return { mode: "base", base: normalizeKey(core) };
}

function applyFromRegistry(mode: PercentMode, base: string, unit: any, value: number): boolean {
  if (mode === "max") {
    const applier = maxPercentRegistry[base];
    if (applier != null) {
      applier(unit, value);
      return true;
    }
    return false;
  }
  const applier = basePercentRegistry[base];
  if (applier != null) {
    applier(unit, value);
    return true;
  }
  return false;
}

export function registerDynamicPercentProperty(mode: PercentMode, key: string, applier: PercentApply): void {
  const normalized = normalizeKey(key);
  if (normalized === "") return;
  if (mode === "max") {
    maxPercentRegistry[normalized] = applier;
  } else {
    basePercentRegistry[normalized] = applier;
  }
}

export function applyDynamicPercentProperty(unit: any, statName: string, value: number): boolean {
  if (!unit || value === 0) return false;
  const parsed = trimPercentName(statName);
  if (parsed.mode === "none" || parsed.base === "") return false;
  return applyFromRegistry(parsed.mode, parsed.base, unit, value);
}

export {};
