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
const equipExcrete = require("系统.装备.装备排泄") as { setLastCreatedItem: (item: any) => void };
const idData =
  (require("系统.装备.装备掉落表") as { default?: Record<string, UnitDataEntry> }).default ??
  (require("系统.装备.装备掉落表") as { idData?: Record<string, UnitDataEntry> }).idData ??
  {};
const itemsData =
  (require("系统.装备.装备数据") as { default?: Record<string, { score?: number }> }).default ?? {};
let _seed = 0;

interface UnitDataEntry {
  id: string;
  itemIds?: string | number;
  picks?: string | number;
  dropProc?: number;
  unitType?: string | number;
  [k: string]: string | number | undefined;
}

const PREFIX = "|cffffff00『系统提示』：|r";

(() => {
  const key = "__equip_drop_seeded";
  if ((globalThis as any)[key]) return;
  (globalThis as any)[key] = true;
  const s = tostring({});
  let h = 0;
  for (let i = 0; i < s.length; i++) h = (h * 33 + s.charCodeAt(i)) % 2147483647;
  if (h <= 0) h = 12345;
  _seed = h;
  math.randomseed(_seed);
})();

function stringToFourCC(s: string): number {
  const b1 = (string as any).byte(s, 1) as number;
  const b2 = (string as any).byte(s, 2) as number;
  const b3 = (string as any).byte(s, 3) as number;
  const b4 = (string as any).byte(s, 4) as number;
  return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
}

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
  return Math.floor(basePicks * mult + 0.5);
}

/** 加权随机取一个（权重不必归一化） */
function weightedPickOne(pool: { id: string; weight: number }[]): string | undefined {
  if (pool.length === 0) return undefined;
  let sum = 0;
  for (const p of pool) sum += p.weight;
  if (sum <= 0) return (pool as any)[(math as any).random(1, pool.length)]?.id;
  const r = (math as any).random(1, 10000) as number / 10000 * sum;
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
  if (picks === 1) {
    const one = weightedPickOne(pool);
    return one ? [one] : [];
  }
  const out: string[] = [];
  for (const p of pool) {
    if (p.weight >= 1 || p.always) {
      out.push(p.id);
    } else {
      const r = (math as any).random(1, 10000) as number / 10000;
      if (r < p.weight) out.push(p.id);
    }
  }
  if (out.length > picks) {
    for (let i = out.length - 1; i >= 1; i--) {
      const j = (math as any).random(1, i + 1) as number;
      const t = out[i];
      out[i] = out[j - 1];
      out[j - 1] = t;
    }
    while (out.length > picks) out.pop();
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
    const idx = (math as any).random(1, list.length) as number;
    const id = (list as any)[idx - 1] as string;
    out.push(id);
    list.splice(idx - 1, 1);
  }
  const needMore = picks - out.length;
  for (let i = 0; i < needMore; i++) {
    const idx = (math as any).random(1, ids.length) as number;
    out.push((ids as any)[idx - 1] as string);
  }
  return out;
}

function createItemAtUnit(unit: any, itemId: string): void {
  const four = stringToFourCC(itemId);
  let loc: any = undefined;
  if (typeof (jass as any).GetUnitLoc === "function") loc = (jass as any).GetUnitLoc(unit);
  if (loc && typeof (jass as any).CreateItemLoc === "function") {
    equipExcrete.setLastCreatedItem((jass as any).CreateItemLoc(four, loc));
  } else if ((jass as any).GetUnitX != null) {
    const x = (jass as any).GetUnitX(unit);
    const y = (jass as any).GetUnitY(unit);
    equipExcrete.setLastCreatedItem((jass as any).CreateItem(four, x, y));
  }
  if (loc && typeof (jass as any).RemoveLocation === "function") (jass as any).RemoveLocation(loc);
}

function onUnitDeath(): void {
  const unit = jass.GetTriggerUnit();
  if (!unit) return;
  if (typeof (jass as any).GetUnitTypeId !== "function") return;
  const typeId = (jass as any).GetUnitTypeId(unit) as number;
  const unitId = typeIdToUnitId(typeId);
  const entry = unitId ? (idData as Record<string, UnitDataEntry>)[unitId] : undefined;

  if (entry && entry.itemIds != null) {
    const dropProc = entry.dropProc != null ? Number(entry.dropProc) : 1;
    const r = (math as any).random(1, 10000) as number;
    if (r > dropProc * 10000) return;
    const rawItemIds = String(entry.itemIds);
    const pool = parseItemPool(rawItemIds);
    if (pool.length === 0) return;
    let picksNum = Math.max(1, Math.floor(Number(entry.picks) || 1));
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
    const r = (math as any).random(1, 10000) as number;
    if (r > rule.proc * 10000) continue;
    const list = getItemsByScoreRange(rule.minScore, rule.maxScore);
    if (list.length === 0) continue;
    const idx = (math as any).random(1, list.length) as number;
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
  return result;
}

function condition(): boolean {
  const u = jass.GetTriggerUnit();
  if (!u) return false;
  if (typeof (jass as any).IsUnitIllusionBJ === "function" && (jass as any).IsUnitIllusionBJ(u)) return false;
  if (jass.IsUnitType(u, (jass as any).UNIT_TYPE_SUMMONED)) return false;
  return true;
}

function init(): void {
  const trig = jass.CreateTrigger();
  const eventId = (jass as any).EVENT_PLAYER_UNIT_DEATH ?? 52;
  for (let i = 0; i < 16; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), eventId, undefined!);
  }
  const neutral = (jass as any).Player?.((jass as any).PLAYER_NEUTRAL_AGGRESSIVE ?? 13);
  if (neutral != null) jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, undefined!);
  const neutralPassive = (jass as any).Player?.((jass as any).PLAYER_NEUTRAL_PASSIVE ?? 15);
  if (neutralPassive != null) jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, undefined!);
  const cond = (jass as any).Condition;
  if (typeof cond === "function") (jass as any).TriggerAddCondition(trig, cond(condition));
  jass.TriggerAddAction(trig, onUnitDeath);
}

init();
export {};
