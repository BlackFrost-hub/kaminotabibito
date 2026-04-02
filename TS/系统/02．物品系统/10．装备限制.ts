// 装备限制.ts - 玩家1-4英雄：按 type 仅一件、onlyone、双手与主/副互斥；多出的 UnitRemoveItem 丢脚下
const jass = require("jass.common") as JassCommon;
const { fourCCToString } = require("系统.00．核心系统.01．封装函数") as {
  fourCCToString: (four: number) => string;
};
/** 与 `11．装备系统.ts` 相同：`require("jass.globals")` 得到 `g`，GUI 变量一律 `g.udg_Xxx`（如 `g.udg_TempIsAdd`、`g.udg_TempHp`） */
const g = require("jass.globals") as { udg_Itmeboolean?: boolean | number; [key: string]: any };

/** 地图 Jass：`set udg_Itmeboolean = true` → 此处 `g.udg_Itmeboolean`；为 true/1 时不做装备限制 */
function isEquipLimitDisabledByJass(): boolean {
  const v = g.udg_Itmeboolean;
  return v === true || v === 1;
}
const itemsData = (require("系统.02．物品系统.01．装备数据") as {
  default?: Record<string, { type?: string; name?: string; onlyone?: boolean | string }>;
}).default ?? {};
/** 与装备系统共用：装备限制 UnitRemoveItem 前设为 true，装备系统 DROP 时跳过扣属性 */
export const equipShared = { skipNextDrop: false };

const ONE_PER_SLOT: string[] = ["主武器", "副武器", "衣服", "鞋子", "裤子", "头盔", "灵魂"];
const TWO_HANDED = "双手武器";
const CONFLICT_WITH_TWO_HANDED: string[] = ["主武器", "副武器"];

const PREFIX = "|cffffff00『系统提示』：|r";
const COLOR_TYPE = "|cff00ff00";  // 类型名 绿
const COLOR_NAME = "|cff00bfff";  // 物品名 蓝
const COLOR_ERR = "|cffff0000";   // 错误/强调 红

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

/** 仅判断：该拾取是否会被装备限制拒绝（true=允许保留，false=会被丢出）。供装备系统在加属性前调用。
 * 事件触发时物品可能尚未入背包，故把“当前拾取的这件”也计入数量。 */
export function equipLimitWouldAllowPickup(unit: any, item: any): boolean {
  if (isEquipLimitDisabledByJass()) return true;
  if (!unit || !item) return true;
  const pickedTypeId = safeGetItemTypeId(item);
  if (pickedTypeId == null) return true;
  const entry = getEntry(pickedTypeId);
  if (!entry) return true;
  const pickedSlotType = entry.type;
  const onlyOne = entry.onlyone === true || entry.onlyone === "TRUE";
  let sameIdCount = 0;
  let sameSlotTypeCount = 0;
  let hasTwoHanded = false;
  let hasMain = false;
  let hasSub = false;
  for (let i = 0; i <= 5; i++) {
    const it = safeUnitItemInSlot(unit, i);
    if (!it || it === item) continue;
    const itTypeId = safeGetItemTypeId(it);
    if (itTypeId == null) continue;
    const e = getEntry(itTypeId);
    if (!e) continue;
    if (itTypeId === pickedTypeId) sameIdCount++;
    if (pickedSlotType != null && e.type === pickedSlotType) sameSlotTypeCount++;
    if (e.type === TWO_HANDED) hasTwoHanded = true;
    if (e.type === "主武器") hasMain = true;
    if (e.type === "副武器") hasSub = true;
  }
  sameIdCount += 1;
  sameSlotTypeCount += 1;
  if (pickedSlotType === "主武器") hasMain = true;
  if (pickedSlotType === "副武器") hasSub = true;
  if (pickedSlotType === TWO_HANDED) hasTwoHanded = true;
  let msg = "";
  if (pickedSlotType === TWO_HANDED) {
    if (hasMain || hasSub) msg = "x";
  } else if (pickedSlotType && CONFLICT_WITH_TWO_HANDED.indexOf(pickedSlotType) >= 0) {
    if (hasTwoHanded) msg = "x";
  }
  if (msg === "" && onlyOne && sameIdCount > 1) msg = "x";
  if (msg === "" && pickedSlotType && ONE_PER_SLOT.indexOf(pickedSlotType) >= 0 && sameSlotTypeCount > 1) msg = "x";
  return msg === "";
}

function onPickup(): void {
  if (isEquipLimitDisabledByJass()) return;
  const unit = jass.GetManipulatingUnit?.() ?? jass.GetTriggerUnit?.();
  const item = jass.GetManipulatedItem?.();
  if (!unit || !item) return;
  if (!jass.IsUnitType(unit, (jass as any).UNIT_TYPE_HERO)) return;
  if (jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
  if (typeof (jass as any).IsUnitIllusionBJ === "function" && (jass as any).IsUnitIllusionBJ(unit)) return;
  if (typeof (jass as any).IsUnitIllusion === "function" && (jass as any).IsUnitIllusion(unit)) return;
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
    if (!e) continue;
    if (itTypeId === pickedTypeId) sameIdCount++;
    if (pickedSlotType != null && e.type === pickedSlotType) sameSlotTypeCount++;
    if (e.type === TWO_HANDED) hasTwoHanded = true;
    if (e.type === "主武器") hasMain = true;
    if (e.type === "副武器") hasSub = true;
  }

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

  if (msg === "") return;

  equipShared.skipNextDrop = true;
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
