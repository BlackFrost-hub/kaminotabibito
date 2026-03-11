// 装备掉落.ts - 单位死亡时按配置掉落物品（如 hfoo 步兵 100% 掉 150-250 分物品）
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { [key: string]: any };
const itemsData =
  (require("系统.装备.装备数据") as { default?: Record<string, { score?: number }> }).default ?? {};
let _seed = 0;

const DEBUG_DROP = true;
const PREFIX = "|cffffff00『系统提示』：|r";
const DEBUG_COLOR = "|cff87ceeb";
const debug = (msg: string) => {
  if (!DEBUG_DROP) return;
  jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0.02, 10, PREFIX + DEBUG_COLOR + msg + "|r");
};

// 只播种一次：避免每次加载/抽取都走同一条随机序列
(() => {
  const key = "__equip_drop_seeded";
  if ((globalThis as any)[key]) return;
  (globalThis as any)[key] = true;
  const s = tostring({}); // 形如 "table: 0xXXXXXXXX"（不同运行通常不同）
  // 简单 hash，足够打散；避免使用 string.match（不同绑定下可能导致 self 调用报错）
  let h = 0;
  for (let i = 0; i < s.length; i++) h = (h * 33 + s.charCodeAt(i)) % 2147483647;
  if (h <= 0) h = 12345;
  _seed = h;
  math.randomseed(_seed);
  debug("装备掉落：seed=" + tostring(_seed));
})();

function stringToFourCC(s: string): number {
  const b1 = (string as any).byte(s, 1) as number;
  const b2 = (string as any).byte(s, 2) as number;
  const b3 = (string as any).byte(s, 3) as number;
  const b4 = (string as any).byte(s, 4) as number;
  return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
}

function getItemsByScoreRange(minScore: number, maxScore: number): string[] {
  const result: string[] = [];
  // 用 for..in（pairs）遍历 Lua table，避免 Object.keys 在部分打包环境下异常
  for (const id in itemsData) {
    if (typeof id !== "string" || id.length !== 4) continue;
    const entry = (itemsData as any)[id] as { score?: number } | undefined;
    const score = entry?.score;
    if (typeof score !== "number") continue;
    if (score >= minScore && score <= maxScore) result.push(id);
  }
  return result;
}

function pickOneItem(minScore: number, maxScore: number): string | undefined {
  const list = getItemsByScoreRange(minScore, maxScore);
  if (DEBUG_DROP) debug("候选数量：" + tostring(list.length) + "（" + tostring(minScore) + "-" + tostring(maxScore) + "）");
  if (list.length === 0) return undefined;
  // Lua 下 math.random()（无参）在部分环境可能不是 [0,1) 浮点，改用区间随机更稳
  const idx = (math as any).random(1, list.length) as number;
  return (list as any)[idx] as string | undefined;
}

// hfoo 步兵：100% 掉落 150-250 分物品
const DROP_RULES: { unitId: string; minScore: number; maxScore: number; proc: number }[] = [
  { unitId: "hfoo", minScore: 150, maxScore: 250, proc: 1 },
];

function onUnitDeath(): void {
  const unit = jass.GetTriggerUnit();
  if (!unit) return;
  if (typeof (jass as any).GetUnitTypeId !== "function") return;
  const typeId = (jass as any).GetUnitTypeId(unit) as number;
  debug("掉落触发：unitType=" + tostring(typeId));
  for (const rule of DROP_RULES) {
    const ruleTypeId = stringToFourCC(rule.unitId);
    if (typeId !== ruleTypeId) continue;
    debug("命中规则：" + rule.unitId + " score=" + rule.minScore + "-" + rule.maxScore + " proc=" + tostring(rule.proc));
    // 概率判定：避免使用 math.random() 无参（不同环境返回值不一致）
    const proc = typeof rule.proc === "number" ? rule.proc : 0;
    const r = (math as any).random(1, 10000) as number;
    if (r > proc * 10000) {
      debug("概率未过：roll=" + tostring(r) + "/10000");
      continue;
    }
    const itemId = pickOneItem(rule.minScore, rule.maxScore);
    if (!itemId) {
      // 额外输出：确认 itemsData 是否为空/score 是否缺失
      let total = 0;
      let withScore = 0;
      let inRange = 0;
      let sample = "";
      let sampled = 0;
      for (const id in itemsData) {
        total++;
        const entry = (itemsData as any)[id] as { score?: number } | undefined;
        if (typeof entry?.score === "number") {
          withScore++;
          if (entry.score >= rule.minScore && entry.score <= rule.maxScore) inRange++;
        }
        if (sampled < 5 && typeof id === "string") {
          sample += (sampled === 0 ? "" : ",") + id;
          sampled++;
        }
      }
      debug("抽取失败：该分数段无物品 total=" + tostring(total) + " withScore=" + tostring(withScore) + " inRange=" + tostring(inRange) + " sample=" + sample);
      continue;
    }
    debug("抽取成功：itemId=" + itemId);
    let loc: any = undefined;
    if (typeof (jass as any).GetUnitLoc === "function") loc = (jass as any).GetUnitLoc(unit);
    if (loc && typeof (jass as any).CreateItemLoc === "function") {
      (jass as any).CreateItemLoc(stringToFourCC(itemId), loc);
      if (typeof (jass as any).RemoveLocation === "function") (jass as any).RemoveLocation(loc);
      debug("已CreateItemLoc");
    } else if ((jass as any).GetUnitX != null) {
      const x = (jass as any).GetUnitX(unit);
      const y = (jass as any).GetUnitY(unit);
      jass.CreateItem(stringToFourCC(itemId), x, y);
      debug("已CreateItem(x,y)");
    } else {
      debug("创建失败：无CreateItemLoc且无GetUnitX/GetUnitY");
    }
    break;
  }
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
  // 尽量覆盖所有玩家归属（含中立）
  for (let i = 0; i < 16; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), eventId, undefined!);
  }
  const neutral = (jass as any).Player?.((jass as any).PLAYER_NEUTRAL_AGGRESSIVE ?? 12);
  if (neutral != null) jass.TriggerRegisterPlayerUnitEvent(trig, neutral, eventId, undefined!);
  const neutralPassive = (jass as any).Player?.((jass as any).PLAYER_NEUTRAL_PASSIVE ?? 15);
  if (neutralPassive != null) jass.TriggerRegisterPlayerUnitEvent(trig, neutralPassive, eventId, undefined!);
  const cond = (jass as any).Condition;
  if (typeof cond === "function") (jass as any).TriggerAddCondition(trig, cond(condition));
  jass.TriggerAddAction(trig, onUnitDeath);
  // 这里也用 for..in 计数，避免 Object.keys 差异
  let cnt = 0;
  for (const _k in itemsData) cnt++;
  debug("装备掉落：init 完成 items=" + tostring(cnt));
}

init();
export { DROP_RULES, pickOneItem };
