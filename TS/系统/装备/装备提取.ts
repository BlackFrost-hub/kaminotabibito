// 装备提取.ts - 玩家输入 233 时创建装备，该玩家第一英雄拾取
const jass = require("jass.common") as JassCommon;
const mod = require("系统.装备.装备数据") as { items?: Record<string, { score?: number; name?: string }>; default?: Record<string, { score?: number; name?: string }> };
const itemsData = mod.items ?? mod.default ?? {};

function getFirstHeroOfPlayer(p: any): any {
  const g = jass.CreateGroup();
  jass.GroupEnumUnitsOfPlayer(g, p, jass.Filter(() => jass.IsUnitType(jass.GetFilterUnit(), jass.UNIT_TYPE_HERO)));
  const u = jass.FirstOfGroup(g);
  jass.DestroyGroup(g);
  return u;
}

// FourCC 大端序：首字符为高字节。Lua 的 string.byte(s,1,4) 一次返回 4 个字节
function stringToFourCC(s: string): number {
  const b1 = (string as any).byte(s, 1) as number;
  const b2 = (string as any).byte(s, 2) as number;
  const b3 = (string as any).byte(s, 3) as number;
  const b4 = (string as any).byte(s, 4) as number;
  return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
}

function getItemsByScoreRange(minScore: number, maxScore: number): string[] {
  const result: string[] = [];
  for (const id of Object.keys(itemsData)) {
    if (typeof id !== "string" || id.length !== 4) continue;
    const entry = itemsData[id];
    if (!entry) continue;
    const score = entry.score;
    if (score != null && score >= minScore && score <= maxScore) {
      result.push(id);
    }
  }
  return result;
}

function shuffleArray<T>(arr: T[]): T[] {
  const a = arr.slice();
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

function createRandomItemInScoreRange(minScore: number, maxScore: number, x: number, y: number): any {
  const candidates = shuffleArray(getItemsByScoreRange(minScore, maxScore));
  if (candidates.length === 0) return null;
  const itemId = candidates[0];
  if (typeof itemId !== "string" || itemId.length !== 4) return null;
  const fourcc = stringToFourCC(itemId);
  return jass.CreateItem(fourcc, x, y);
}

function onChat233(): void {
  math.randomseed(os.clock() * 1000000);
  const [ok, item] = pcall(() => createRandomItemInScoreRange(200, 250, 0, 0));
  if (ok && item) {
    const player = jass.GetTriggerPlayer();
    const hero = getFirstHeroOfPlayer(player);
    if (hero) jass.IssueNeutralTargetOrder(player, hero, "smart", item);
  } else if (!ok) (globalThis as any).print("【装备提取】错误:", tostring(item));
}

function init(): void {
  const trig = jass.CreateTrigger();
  for (let i = 0; i <= 11; i++) {
    jass.TriggerRegisterPlayerChatEvent(trig, jass.Player(i), "233", true);
  }
  jass.TriggerAddAction(trig, onChat233);
}
init();
export {};
