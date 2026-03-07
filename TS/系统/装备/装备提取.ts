// 装备提取.ts - 聊天/拾取树枝触发，按 udg_TempScoreMin/Max 随机选1个物品写入 udg_TempItemType
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { udg_TempItemType?: number; udg_TempScoreMin?: number; udg_TempScoreMax?: number; [key: string]: any };
const mod = require("系统.装备.装备数据") as { items?: Record<string, { score?: number }>; default?: Record<string, { score?: number }> };
const itemsData = mod.items ?? mod.default ?? {};
let _seedCnt = 0;
const DEBUG = true;
const ITEM_TRIGGER = "tret"; // 触发物品ID

function stringToFourCC(s: string): number {
  const b1 = (string as any).byte(s, 1) as number;
  const b2 = (string as any).byte(s, 2) as number;
  const b3 = (string as any).byte(s, 3) as number;
  const b4 = (string as any).byte(s, 4) as number;
  return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
}

function getItemsByScoreRange(minScore: number, maxScore: number): string[] {
  const min = minScore ?? 0;
  const max = maxScore ?? 0;
  const result: string[] = [];
  for (const id of Object.keys(itemsData)) {
    if (typeof id !== "string" || id.length !== 4) continue;
    const entry = itemsData[id];
    if (!entry) continue;
    const score = entry.score;
    if (score != null && score >= min && score <= max) result.push(id);
  }
  return result;
}

function EquipExtract_CreateByLevel(): void {
  (globalThis as any).print?.("[装备提取] EquipExtract_CreateByLevel 被调用");
  jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "[装备提取] 执行中");
  _seedCnt++;
  math.randomseed(_seedCnt);
  // 优先从 YDLocal1Get 取入参，否则用 udg_TempScoreMin/Max
  const inputMin = jass.YDLocal1Get?.("integer", "EquipExtract_MinScore");
  const inputMax = jass.YDLocal1Get?.("integer", "EquipExtract_MaxScore");
  let minS = typeof inputMin === "number" ? inputMin : Number(g.udg_TempScoreMin) || 0;
  let maxS = typeof inputMax === "number" ? inputMax : Number(g.udg_TempScoreMax) || 0;
  if (minS <= 0 && maxS <= 0) {
    minS = 200;
    maxS = 250;
  }
  const candidates = getItemsByScoreRange(minS, maxS);
  const player = (jass as any).STES_GetTriggerPlayer?.() ?? jass.GetTriggerPlayer?.() ?? jass.Player(0);
  if (candidates.length === 0) {
    g.udg_TempItemType = 0;
    if (DEBUG) jass.DisplayTimedTextToPlayer(player, 0, 0, 8, "TempItemType=0 无候选 min=" + minS + " max=" + maxS);
    return;
  }
  const arr = candidates.slice();
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  const itemId = arr[0];
  g.udg_TempItemType = typeof itemId === "string" && itemId.length === 4 ? stringToFourCC(itemId) : 0;
  (globalThis as any).print?.("TempItemType=" + g.udg_TempItemType + " itemId=" + itemId);
  if (DEBUG) jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "TempItemType=" + g.udg_TempItemType + " itemId=" + itemId);
}

function dbg(msg: string): void {
  if (DEBUG) jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 10, "[装备提取] " + msg);
}

function onTrigger(): void {
  const evt = jass.GetTriggerEventId();
  const player = jass.GetTriggerPlayer?.() ?? jass.Player(0);
  if (evt === jass.EVENT_PLAYER_UNIT_PICKUP_ITEM) {
    if (DEBUG) jass.DisplayTimedTextToPlayer(player, 0, 0, 8, "拾取事件被触发");
    const item = jass.GetManipulatedItem();
    const tid = jass.GetItemTypeId(item);
    if (tid !== stringToFourCC(ITEM_TRIGGER)) return; // 非 tret 不触发
    if (DEBUG) jass.DisplayTimedTextToPlayer(player, 0, 0, 8, "物品ID正确");
  }
  EquipExtract_CreateByLevel();
}

function init(): void {
  (globalThis as any).EquipExtract_CreateByLevel = EquipExtract_CreateByLevel;
  const trig = jass.CreateTrigger();

  // 玩家1-4拾取物品
  for (let i = 0; i < 4; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_PICKUP_ITEM, undefined!);
  }

  jass.TriggerAddAction(trig, onTrigger);

  // 注册到 STES 事件 "提取物品事件"（参数同 GS：trigger, string），优先直接调用，否则走桥接
  const evtTrig = jass.CreateTrigger();
  jass.TriggerAddAction(evtTrig, () => EquipExtract_CreateByLevel());
  const STES_Reg = (jass as any).STES_Register ?? (g as any).STES_Register ?? (globalThis as any).STES_Register;
  if (typeof STES_Reg === "function") {
    STES_Reg(evtTrig, "提取物品事件");
    dbg("已通过 STES_Register 注册事件 提取物品事件");
  } else {
    (g as any).udg_RegTrigger = evtTrig;
    (g as any).udg_RegEventStr = "提取物品事件";
    jass.ExecuteFunc("Bridge_STES_Register");
    dbg("已通过桥接注册 STES 事件 提取物品事件");
  }
}
init();
export { EquipExtract_CreateByLevel };