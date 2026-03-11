// 装备限制.ts - 玩家1-4英雄：按 type 仅一件、onlyone、双手与主/副互斥；多出的 UnitRemoveItem 丢脚下
const jass = require("jass.common") as JassCommon;
const itemsData = (require("系统.装备.装备数据") as {
  default?: Record<string, { type?: string; name?: string; onlyone?: boolean | string }>;
}).default ?? {};

const ONE_PER_SLOT: string[] = ["主武器", "副武器", "衣服", "鞋子", "裤子", "头盔", "灵魂"];
const TWO_HANDED = "双手武器";
const CONFLICT_WITH_TWO_HANDED: string[] = ["主武器", "副武器"];

const PREFIX = "|cffffff00『系统提示』：|r";
const COLOR_TYPE = "|cff00ff00";  // 类型名 绿
const COLOR_NAME = "|cff00bfff";  // 物品名 蓝
const COLOR_ERR = "|cffff0000";   // 错误/强调 红

// 调试开关：需要排查时改成 true
const DEBUG_EQUIP_LIMIT = false;
const DEBUG_COLOR = "|cff87ceeb"; // 浅蓝

function fourCCToString(four: number): string {
  const a = math.floor(four / 16777216) % 256;
  const b = math.floor(four / 65536) % 256;
  const c = math.floor(four / 256) % 256;
  const d = four % 256;
  return string.char(a, b, c, d);
}

function getEntry(itemTypeId: number): { type?: string; name?: string; onlyone?: boolean | string } | undefined {
  const id = fourCCToString(itemTypeId);
  return (itemsData as Record<string, { type?: string; name?: string; onlyone?: boolean | string }>)[id];
}

function safeGetItemTypeId(it: any): number | undefined {
  const fn = (jass as any).GetItemTypeId;
  if (typeof fn !== "function") return undefined;
  // 关键：直接用 jass.GetItemTypeId(it)，避免 TSTL 生成“带 self”的错误形态
  const a = (jass as any).GetItemTypeId(it);
  if (typeof a === "number") return a;
  // 兜底（极少数情况）
  const b = fn(jass, it);
  if (typeof b === "number") return b;
  const c = fn(undefined as any, it);
  if (typeof c === "number") return c;
  return undefined;
}

function safeUnitItemInSlot(unit: any, slot: number): any | undefined {
  const fn = (jass as any).UnitItemInSlot;
  if (typeof fn !== "function") return undefined;
  // 同上：先用直接调用形态
  const a = (jass as any).UnitItemInSlot(unit, slot);
  if (a) return a;
  // 兜底（极少数情况）
  const b = fn(jass, unit, slot);
  if (b) return b;
  const c = fn(undefined as any, unit, slot);
  if (c) return c;
  return undefined;
}

function onPickup(): void {
  if (Itmeboolean) return; /* 装备限制开关 */
  const unit = jass.GetManipulatingUnit?.() ?? jass.GetTriggerUnit?.();
  const item = jass.GetManipulatedItem?.();
  if (!unit || !item) return;
  if (!jass.IsUnitType(unit, (jass as any).UNIT_TYPE_HERO)) return;
  if (jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
  const IsUnitIllusion = (jass as any).IsUnitIllusion;
  const IsUnitIllusionBJ = (jass as any).IsUnitIllusionBJ;
  if (typeof IsUnitIllusionBJ === "function") {
    if (IsUnitIllusionBJ(unit) || IsUnitIllusionBJ(jass, unit) || IsUnitIllusionBJ(undefined as any, unit)) return;
  } else if (typeof IsUnitIllusion === "function") {
    if (IsUnitIllusion(unit) || IsUnitIllusion(jass, unit) || IsUnitIllusion(undefined as any, unit)) return;
  }
  const pickedTypeId = safeGetItemTypeId(item);
  if (pickedTypeId == null) return;
  const entry = getEntry(pickedTypeId);
  if (!entry) return;

  const pickedSlotType = entry.type;
  const onlyOne = entry.onlyone === true || entry.onlyone === "TRUE";
  let name = entry.name != null ? String(entry.name) : "";
  const stripColor = (s: string): string => {
    let out = "";
    let i = 0;
    while (i < s.length) {
      if (s.substring(i, i + 2) === "|r") { i += 2; continue; }
      if (s.substring(i, i + 2) === "|c" && i + 10 <= s.length) {
        let hex = true;
        for (let j = i + 2; j < i + 10 && hex; j++) hex = "0123456789aAbBcCdDeEfF".indexOf(s[j]) >= 0;
        if (hex) { i += 10; continue; }
      }
      out += s[i]; i++;
    }
    return out;
  };
  name = stripColor(name).trim();
  const nameColored = COLOR_NAME + "『" + name + "』|r";
  let msg = "";

  let player = jass.Player(0);
  if (typeof (jass as any).GetOwningPlayer === "function") {
    const p = (jass as any).GetOwningPlayer(unit);
    if (p) player = p;
  }
  const debug = (s: string) => {
    if (!DEBUG_EQUIP_LIMIT) return;
    jass.DisplayTimedTextToPlayer(player, 0, 0.01, 8, PREFIX + DEBUG_COLOR + s + "|r");
  };

  // 直接遍历 6 格，判断是否与“本次拾取 item”冲突（冲突就丢本次拾取这件）
  let sameIdCount = 0;
  let sameSlotTypeCount = 0;
  let hasTwoHanded = false;
  let hasMain = false;
  let hasSub = false;
  for (let i = 0; i <= 5; i++) {
    const it = safeUnitItemInSlot(unit, i);
    if (!it) continue;
    const itTypeId = safeGetItemTypeId(it);
    if (itTypeId == null) continue;
    const e = getEntry(itTypeId);
    if (!e) continue; // 不在装备数据里的不参与限制
    if (itTypeId === pickedTypeId) sameIdCount++;
    if (pickedSlotType != null && e.type === pickedSlotType) sameSlotTypeCount++;
    if (e.type === TWO_HANDED) hasTwoHanded = true;
    if (e.type === "主武器") hasMain = true;
    if (e.type === "副武器") hasSub = true;
  }

  debug(
    "DEBUG 装备限制：拾取=" +
      fourCCToString(pickedTypeId) +
      " type=" +
      (pickedSlotType ?? "无") +
      " onlyone=" +
      tostring(onlyOne) +
      " name=" +
      name
  );
  debug(
    "统计：sameId=" +
      tostring(sameIdCount) +
      " sameType=" +
      tostring(sameSlotTypeCount) +
      " hasTwoHand=" +
      tostring(hasTwoHanded) +
      " hasMain=" +
      tostring(hasMain) +
      " hasSub=" +
      tostring(hasSub)
  );

  if (pickedSlotType === TWO_HANDED) {
    if (hasMain || hasSub) msg = PREFIX + COLOR_ERR + "双手武器与主武器/副武器不能同时装备！|r";
  } else if (pickedSlotType && CONFLICT_WITH_TWO_HANDED.indexOf(pickedSlotType) >= 0) {
    if (hasTwoHanded) msg = PREFIX + COLOR_ERR + "双手武器与主武器/副武器不能同时装备！|r";
  }

  if (msg === "" && onlyOne && sameIdCount > 1) {
    msg = PREFIX + COLOR_ERR + "该物品" + nameColored + "只能装备一件！|r";
  }

  if (msg === "" && pickedSlotType && ONE_PER_SLOT.indexOf(pickedSlotType) >= 0 && sameSlotTypeCount > 1) {
    msg = PREFIX + COLOR_TYPE + pickedSlotType + "|r物品：" + nameColored + COLOR_ERR + "只能装备一件！|r";
  }

  debug("结果：msg=" + (msg !== "" ? "有(将丢弃)" : "无(放行)"));
  if (msg === "") return;

  // 关键：不要取局部函数再调用（TSTL 可能生成错误 self 调用导致无效）
  if (typeof (jass as any).UnitRemoveItem === "function") {
    (jass as any).UnitRemoveItem(unit, item);
  } else {
    const UnitDropItemPoint = (jass as any).UnitDropItemPoint;
    const GetUnitX = (jass as any).GetUnitX;
    const GetUnitY = (jass as any).GetUnitY;
    if (typeof UnitDropItemPoint === "function" && typeof GetUnitX === "function" && typeof GetUnitY === "function") {
      UnitDropItemPoint(unit, item, GetUnitX(unit), GetUnitY(unit));
    }
  }
  jass.DisplayTimedTextToPlayer(player, 0, 0, 6, msg);
}

function isHeroCond(): boolean {
  const u = jass.GetTriggerUnit?.() ?? (jass as any).GetManipulatingUnit?.();
  return u != null && jass.IsUnitType(u, (jass as any).UNIT_TYPE_HERO);
}

function init(): void {
  const trig = jass.CreateTrigger();
  const eventId = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM;
  for (let i = 0; i < 4; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), eventId, undefined!);
  }
  const cond = (jass as any).Condition;
  if (typeof cond === "function") (jass as any).TriggerAddCondition(trig, cond(isHeroCond));
  jass.TriggerAddAction(trig, onPickup);
}

init();
export {};
