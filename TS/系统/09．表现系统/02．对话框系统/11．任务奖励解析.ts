const jass = require("jass.common") as any;

export interface RewardExecContext {
  triggerPlayerId?: number;
  submittedItemId?: string;
  submittedItemLevel?: string;
}

export interface RewardExecResult {
  matchedRuleIndex: number;
  matchedCondition: string;
}

function readFirstNumber(s: string): number {
  let found = false;
  let n = 0;
  for (let i = 0; i < s.length; i++) {
    const c = s.charAt(i);
    if (c >= "0" && c <= "9") {
      found = true;
      n = n * 10 + (c.charCodeAt(0) - 48);
    } else if (found) {
      break;
    }
  }
  return n;
}

function parseItemLevelRank(levelRaw?: string): number {
  if (!levelRaw || levelRaw === "") return -999;
  const lv = levelRaw.trim();
  const table: Record<string, number> = {
    "E-": 10, "E": 11, "E+": 12, "E++": 13, "E+++": 14,
    "D-": 20, "D": 21, "D+": 22, "D++": 23, "D+++": 24,
    "C-": 30, "C": 31, "C+": 32, "C++": 33, "C+++": 34,
    "B-": 40, "B": 41, "B+": 42, "B++": 43, "B+++": 44,
    "A-": 50, "A": 51, "A+": 52,
    "S-": 60, "S": 61, "S+": 62,
  };
  return table[lv] ?? -999;
}

function parseEquipBoundToken(token: string): { op: "<" | ">" | "="; rank: number } | null {
  const t = token.trim();
  if (t === "") return null;
  const first = t.charAt(0);
  let op: "<" | ">" | "=" = "=";
  let levelStr = t;
  if (first === "<" || first === "＞" || first === ">" || first === "＜" || first === "=") {
    op = first === "＜" ? "<" : first === "＞" ? ">" : (first as "<" | ">" | "=");
    levelStr = t.substring(1).trim();
  }
  const rank = parseItemLevelRank(levelStr);
  if (rank < 0) return null;
  return { op, rank };
}

function isEquipConditionMatched(condition: string, submittedItemLevel?: string): boolean {
  if (!submittedItemLevel || submittedItemLevel === "") return false;
  const levelRank = parseItemLevelRank(submittedItemLevel);
  if (levelRank < 0) return false;
  if (condition.indexOf("装备等级") !== 0) return false;
  const expr = condition.substring("装备等级".length).trim();
  if (expr === "") return false;
  const parts = expr.split("&");
  for (const raw of parts) {
    const bound = parseEquipBoundToken(raw);
    if (!bound) continue;
    if (bound.op === "<" && !(levelRank < bound.rank)) return false;
    if (bound.op === ">" && !(levelRank > bound.rank)) return false;
    if (bound.op === "=" && !(levelRank === bound.rank)) return false;
  }
  return true;
}

function isItemIdConditionMatched(condition: string, submittedItemId?: string): boolean {
  if (!submittedItemId || submittedItemId.length !== 4) return false;
  const tokens = condition.split("|");
  for (const t of tokens) {
    if (t.trim() === submittedItemId) return true;
  }
  return false;
}

function isHeroLevelConditionMatched(text: string, triggerPlayerId?: number): boolean {
  if (text.indexOf("英雄等级＞") === 0 || text.indexOf("英雄等级>") === 0) {
    const limit = readFirstNumber(text);
    const p = triggerPlayerId != null ? jass.Player(triggerPlayerId) : null;
    const hero = p ? getPlayerFirstHero(p) : null;
    const lv = hero ? (jass.GetHeroLevel(hero) as number) : 0;
    return lv > limit;
  }
  if (text.indexOf("英雄等级≤") === 0 || text.indexOf("英雄等级<=") === 0) {
    const limit = readFirstNumber(text);
    const p = triggerPlayerId != null ? jass.Player(triggerPlayerId) : null;
    const hero = p ? getPlayerFirstHero(p) : null;
    const lv = hero ? (jass.GetHeroLevel(hero) as number) : 0;
    return lv <= limit;
  }
  return true;
}

// 由奖励执行文件导入后回填，避免循环依赖
let getPlayerFirstHero: (player: any) => any = () => null;
export function bindRewardParseHeroResolver(fn: (player: any) => any): void {
  getPlayerFirstHero = fn;
}

export function isConditionMatchedWithContext(condition: string, ctx: RewardExecContext): boolean {
  const text = condition.trim();
  if (text === "") return true;
  if (text.indexOf("装备等级") === 0) return isEquipConditionMatched(text, ctx.submittedItemLevel);
  if (text.indexOf("|") >= 0 && text.indexOf("I") >= 0) return isItemIdConditionMatched(text, ctx.submittedItemId);
  return isHeroLevelConditionMatched(text, ctx.triggerPlayerId);
}

export {};

