/**
 * 装备回复：单位使用物品时，若装备数据有 hot 且 abilList 为 A08C/A0LF/A002/A015/A0B8 之一，则设 udg_TempReal/udg_TempReal2/udg_TempUnit/udg_TempString(匹配的技能 id) 并执行 gg_trg_HealItemEffect
 * 仅对玩家1-7(Player0-6)和中立敌对(Player13)生效
 * 经验：引擎会对一次使用物品派发两次 USE_ITEM 事件，防重须用 globalThis 存 key，详见 .cursor/rules/equip-heal-use-item.md
 */
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { udg_TempUnit?: any; udg_TempReal?: number; udg_TempReal2?: number; [k: string]: any };
const itemsData = (require("系统.装备.装备数据") as { default: Record<string, { hot?: string; abilList?: string }> }).default;

const HEAL_ABIL_IDS = ["A08C", "A0LF", "A002", "A015", "A0B8"];

function fourCCToString(fourcc: number): string {
  const c1 = string.char(fourcc % 256);
  const c2 = string.char(Math.floor(fourcc / 256) % 256);
  const c3 = string.char(Math.floor(fourcc / 65536) % 256);
  const c4 = string.char(Math.floor(fourcc / 16777216) % 256);
  return c4 + c3 + c2 + c1;
}

function parseHot(hotStr: string): { hp: number; mp: number } {
  let hp = 0;
  let mp = 0;
  const parts = hotStr.split(";");
  for (const p of parts) {
    const s = p.trim();
    const sl = s.length;
    if (sl >= 3 && (s.substring(sl - 2, sl) === "hp" || s.substring(sl - 2, sl) === "HP")) {
      const n = parseInt(s.substring(0, sl - 2), 10) || 0;
      hp += n;
    } else if (sl >= 3 && (s.substring(sl - 2, sl) === "mp" || s.substring(sl - 2, sl) === "MP")) {
      const n = parseInt(s.substring(0, sl - 2), 10) || 0;
      mp += n;
    }
  }
  return { hp, mp };
}

/** 返回 abilList 中第一个匹配的 HEAL_ABIL_IDS 项，否则返回 "" */
function getMatchedHealAbilId(abilList: string | undefined): string {
  if (!abilList || typeof abilList !== "string") return "";
  const list = abilList.split(",").map((x) => x.trim());
  for (const id of HEAL_ABIL_IDS) {
    if (list.indexOf(id) >= 0) return id;
  }
  return "";
}

function onUseItem(): void {
  const unit = (jass as any).GetManipulatingUnit?.() ?? (jass as any).GetTriggerUnit?.();
  const item = (jass as any).GetManipulatedItem?.();
  if (!unit || !item) return;
  if (typeof (jass as any).IsUnitType === "function" && jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
  const IsUnitIllusionBJ = (jass as any).IsUnitIllusionBJ;
  if (typeof IsUnitIllusionBJ === "function" && IsUnitIllusionBJ(unit)) return;
  const itemId = typeof (jass as any).GetItemTypeId === "function" ? (jass as any).GetItemTypeId(item) : 0;
  const idStr = fourCCToString(itemId);
  const entry = (itemsData as Record<string, { hot?: string; abilList?: string }>)[idStr];
  const matchedAbilId = getMatchedHealAbilId(entry.abilList);
  if (!entry || !entry.hot || !matchedAbilId) return;
  const { hp, mp } = parseHot(entry.hot);
  if (hp <= 0 && mp <= 0) return;
  const glob = globalThis as any;
  const key = tostring(unit) + "_" + idStr;
  if (glob.__EquipHealExecutedKey === key) return;
  glob.__EquipHealExecutedKey = key;
  const timer = (jass as any).CreateTimer?.();
  if (timer && typeof (jass as any).TimerStart === "function") {
    (jass as any).TimerStart(timer, 0.5, false, () => { glob.__EquipHealExecutedKey = undefined; });
  }
  g.udg_TempReal = hp;
  g.udg_TempReal2 = mp;
  g.udg_TempUnit = unit;
  (g as any).udg_TempString[0] = matchedAbilId;
  const trig = (g as any).gg_trg_HealItemEffect;
  if (trig && typeof (jass as any).TriggerExecute === "function") (jass as any).TriggerExecute(trig);
}

const INIT_KEY = "__EquipHealInited";
function init(): void {
  if ((g as any)[INIT_KEY]) return;
  (g as any)[INIT_KEY] = true;
  const useItemEv = (jass as any).EVENT_PLAYER_UNIT_USE_ITEM ?? 35;
  const trig = jass.CreateTrigger();
  for (let i = 0; i <= 6; i++) jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), useItemEv, undefined!);
  const p13 = (jass as any).Player?.(13);
  if (p13 != null) jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, undefined!);
  jass.TriggerAddAction(trig, onUseItem);
}

init();
export {};
