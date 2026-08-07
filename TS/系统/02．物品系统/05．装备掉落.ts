/** @noSelfInFile */
// 装备掉落.ts - 优先按装备掉落表；无则走旧 DROP_RULES（hfoo 等）
// 自动生成 - 单位数据表
/**
 * 装备掉落表格式说明：
 * - picks：最多掉落多少件（不是必定掉满）。
 * - itemIds 带百分数（如 I03Y:7%;I04R:7%）：每项独立按概率判定，不重复；最多 picks 件。仅当 picks > 物品种类数时，差额按权重再抽（可重复）。
 * - itemIds 纯权重（如 I02C:1.5;I01G:1）：按权重在池中随机抽 picks 件。
 * - itemIds 无权重（如 I00C;I00E;I00D;I00G）：从池中选 min(picks, 池大小) 件不重复；picks > 池大小时多出的可重复随机。
 * - always：必掉且仅掉一次。
 * - unitType 为 elite/Boss 且 T>1 时，picks = round(basePicks×(1+0.334×(T-1)))。
 */
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { [key: string]: any };
const itemCreateFns = require("lib.扩展函数.物品相关函数.index") as {
  在点创建物品并注册排泄监听: (this: void, itemId: number, whichLocation: any) => any;
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { stringToFourCC, isSpecialUnit } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
  isSpecialUnit: (unit: any) => boolean;
};
const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, cb: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const idData =
  (require("系统.02．物品系统.02．装备掉落表") as { default?: Record<string, UnitDataEntry> }).default ??
  (require("系统.02．物品系统.02．装备掉落表") as { idData?: Record<string, UnitDataEntry> }).idData ??
  {};
const itemsData =
  (require("系统.02．物品系统.01．装备数据") as { default?: Record<string, { score?: number }> }).default ?? {};
const { 是否允许限次物品掉落, 记录限次物品掉落 } = require("系统.02．物品系统.19．掉落次数限制表") as {
  是否允许限次物品掉落: (this: void, itemId: string) => boolean;
  记录限次物品掉落: (this: void, itemId: string) => void;
};
interface UnitDataEntry {
  id: string;
  itemIds?: string | number;
  picks?: string | number;
  dropProc?: number;
  unitType?: string | number;
  [k: string]: string | number | undefined;
}

const PREFIX = "|cffffff00『系统提示』：|r";

function typeIdToUnitId(typeId: number): string | undefined {
  for (const id in idData) {
    if (stringToFourCC(id) === typeId) return id;
  }
  return undefined;
}

/** 解析 itemIds → [{id, weight, always?}]。always 标记必掉且仅掉一次、不参与重复抽取 */
function parseItemPool(itemIdsStr: string): { id: string; weight: number; always?: boolean }[] {
  const raw = String(itemIdsStr).trim();
  if (!raw) return [];
  const parts = raw.split(";").map((p) => p.trim()).filter((p) => p.length >= 4);
  const hasColon = parts.some((p) => p.indexOf(":") >= 0);
  const pool: { id: string; weight: number; always?: boolean }[] = [];
  if (hasColon) {
    for (const p of parts) {
      const colon = p.indexOf(":");
      if (colon < 0) continue;
      const id = p.substring(0, colon).trim();
      let w = 0;
      let always = false;
      const rest = (p.substring(colon + 1).trim() as string).toLowerCase();
      if (rest === "always") {
        w = 1;
        always = true;
      } else if (rest.indexOf("%") >= 0) {
        w = parseFloat(rest) / 100;
      } else {
        w = parseFloat(rest);
      }
      if (id.length >= 4) pool.push({ id: id.substring(0, 4), weight: w, always });
    }
  } else {
    for (const p of parts) {
      const id = p.substring(0, 4);
      if (id.length === 4) pool.push({ id, weight: 1 });
    }
  }
  return pool;
}

/** Jass 全局 T = 玩家人数。unitType 为 elite/Boss 时，picks = round(basePicks × (1 + 0.334×(T-1)))，如 T=5、picks=2 得 5 */
function getEffectivePicks(basePicks: number, unitType: string | number | undefined): number {
  const ut = String(unitType || "").toLowerCase();
  if (ut !== "elite" && ut !== "boss") return basePicks;
  const T = (g.udg_T as number) != null ? Number(g.udg_T) : 0;
  if (T <= 1) return basePicks;
  const mult = 1 + 0.334 * (T - 1);
  return (jass as any).R2I(basePicks * mult + 0.5);
}

/** 加权随机取一个（权重不必归一化） */
function weightedPickOne(pool: { id: string; weight: number }[]): string | undefined {
  if (pool.length === 0) return undefined;
  let sum = 0;
  for (const p of pool) sum += p.weight;
  if (sum <= 0) return (pool as any)[(jass as any).GetRandomInt(1, pool.length)]?.id;
  const r = ((jass as any).GetRandomReal(0, 1) as number) * sum;
  let acc = 0;
  for (const p of pool) {
    acc += p.weight;
    if (r <= acc) return p.id;
  }
  return pool[pool.length - 1].id;
}

/**
 * 权重/百分比池：最多 picks 件；首轮每项独立按概率 roll，不重复。
 * 仅当 picks > 池子物品种类数时，差额按权重再抽（可重复掉落）。
 */
function pickFromWeightedPool(
  pool: { id: string; weight: number; always?: boolean }[],
  picks: number
): string[] {
  if (pool.length === 0) return [];
  const out: string[] = [];
  for (const p of pool) {
    if (p.weight >= 1 || p.always) {
      debugLog("装备掉落", "必掉物品:", p.id, p.weight);
      out.push(p.id);
    } else {
      const r = (jass as any).GetRandomReal(0, 1) as number;
      debugLog("装备掉落", "概率判定:", p.id, "weight:", p.weight, "r:", r, "命中:", r < p.weight);
      if (r < p.weight) out.push(p.id);
    }
  }
  if (out.length > picks) {
    const protectedOut: string[] = [];
    const removableOut: string[] = [];
    for (let i = 0; i < out.length; i++) {
      let isAlways = false;
      for (let j = 0; j < pool.length; j++) {
        if (pool[j].always && pool[j].id === out[i]) {
          isAlways = true;
          break;
        }
      }
      if (isAlways) protectedOut.push(out[i]);
      else removableOut.push(out[i]);
    }
    for (let i = removableOut.length - 1; i >= 1; i--) {
      const j = (jass as any).GetRandomInt(1, i + 1) as number;
      const t = removableOut[i];
      removableOut[i] = removableOut[j - 1];
      removableOut[j - 1] = t;
    }
    out.length = 0;
    for (let i = 0; i < protectedOut.length; i++) out.push(protectedOut[i]);
    const removableToKeep = picks - protectedOut.length;
    for (let i = 0; i < removableToKeep && i < removableOut.length; i++) out.push(removableOut[i]);
  }
  const needMore = picks - out.length;
  if (needMore <= 0) return out;
  if (picks <= pool.length) return out;
  for (let i = 0; i < needMore; i++) {
    const one = weightedPickOne(pool);
    if (one != null) out.push(one);
  }
  return out;
}

/** 无权重池（I00C;I00E;I00D;I00G）：从池中选 min(picks, 池大小) 件不重复；若 picks > 池大小，多出的按池内随机再抽（可重复） */
function pickFromEqualPool(ids: string[], picks: number): string[] {
  if (ids.length === 0 || picks <= 0) return [];
  const out: string[] = [];
  const list = ids.slice();
  const firstPicks = picks <= list.length ? picks : list.length;
  for (let i = 0; i < firstPicks; i++) {
    const idx = (jass as any).GetRandomInt(1, list.length) as number;
    const id = (list as any)[idx - 1] as string;
    out.push(id);
    list.splice(idx - 1, 1);
  }
  const needMore = picks - out.length;
  for (let i = 0; i < needMore; i++) {
    const idx = (jass as any).GetRandomInt(1, ids.length) as number;
    out.push((ids as any)[idx - 1] as string);
  }
  return out;
}

function createItemAtUnit(unit: any, itemId: string): void {
  if (!是否允许限次物品掉落(itemId)) return;

  const four = stringToFourCC(itemId);
  const loc: any = (jass as any).GetUnitLoc(unit);
  let createdItem: any = null;
  if (loc) {
    createdItem = itemCreateFns.在点创建物品并注册排泄监听(four, loc);
  } else if ((jass as any).GetUnitX != null) {
    const x = (jass as any).GetUnitX(unit);
    const y = (jass as any).GetUnitY(unit);
    createdItem = itemCreateFns.创建物品并注册排泄监听(four, x, y);
  }
  if (loc) (jass as any).RemoveLocation(loc);
  if (createdItem != null && createdItem !== 0) 记录限次物品掉落(itemId);
}

function onUnitDeath(this: void, unit: any, _killer: any): void {
  if (!unit) return;
  if (isSpecialUnit(unit)) return;
  const typeId = (jass as any).GetUnitTypeId(unit) as number;
  const unitId = typeIdToUnitId(typeId);
  const entry = unitId ? (idData as Record<string, UnitDataEntry>)[unitId] : undefined;

  debugLog("装备掉落", "单位死亡 typeId:", typeId, "unitId:", unitId, "entry:", entry?.name);

  if (entry && entry.itemIds != null) {
    debugLog("装备掉落", "找到掉落表 itemIds:", entry.itemIds);
    const dropProc = entry.dropProc != null ? Number(entry.dropProc) : 1;
    const r = (jass as any).GetRandomInt(1, 10000) as number;
    if (r > dropProc * 10000) return;
    const rawItemIds = String(entry.itemIds);
    const pool = parseItemPool(rawItemIds);
    if (pool.length === 0) return;
    let picksNum = (jass as any).R2I(Number(entry.picks) || 1);
    if (picksNum < 1) picksNum = 1;
    picksNum = getEffectivePicks(picksNum, entry.unitType);
    const ids = pool.map((p) => p.id);
    // 只有 “I00C;I00E;I00D” 这种无冒号的格式才走等概率抽 picks 个
    const isEqualPool = rawItemIds.indexOf(":") < 0;
    const toDrop: string[] = isEqualPool
      ? pickFromEqualPool(ids, picksNum)
      : pickFromWeightedPool(pool, picksNum);
    for (const id of toDrop) createItemAtUnit(unit, id);
    return;
  }

  // 旧逻辑：hfoo 等 DROP_RULES
  const DROP_RULES: { unitId: string; minScore: number; maxScore: number; proc: number }[] = [
    { unitId: "hfoo", minScore: 150, maxScore: 250, proc: 1 },
  ];
  for (const rule of DROP_RULES) {
    if (typeId !== stringToFourCC(rule.unitId)) continue;
    const r = (jass as any).GetRandomInt(1, 10000) as number;
    if (r > rule.proc * 10000) continue;
    const list = getItemsByScoreRange(rule.minScore, rule.maxScore);
    if (list.length === 0) continue;
    const idx = (jass as any).GetRandomInt(1, list.length) as number;
    const itemId = (list as any)[idx] as string;
    if (itemId != null && itemId !== "") createItemAtUnit(unit, itemId);
    break;
  }
}

function getItemsByScoreRange(minScore: number, maxScore: number): string[] {
  const result: string[] = [];
  for (const id in itemsData) {
    if (typeof id !== "string" || id.length !== 4) continue;
    const entry = (itemsData as any)[id] as { score?: number } | undefined;
    const score = entry?.score;
    if (typeof score !== "number") continue;
    if (score >= minScore && score <= maxScore) result.push(id);
  }
  result.sort();
  return result;
}

registerDeathListener(onUnitDeath);

export {};
