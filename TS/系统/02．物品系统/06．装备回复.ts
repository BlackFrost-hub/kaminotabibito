/**
 * 装备回复：单位使用物品时解析 hot 字段，支持多段（+分隔）、百分比(%hp/%hpLost/%mp)、固定值、wait延迟。
 * 规则详见 .cursor/rules/equip-heal-hot-format.md
 * 防重复事件见 .cursor/rules/equip-heal-use-item.md
 */
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { udg_TempReal?: { [k: number]: number }; [k: string]: any };
const itemsData = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, { hot?: string; abilList?: string }> }).default;

function fourCCToString(fourcc: number): string {
  const c1 = string.char(fourcc % 256);
  const c2 = string.char(Math.floor(fourcc / 256) % 256);
  const c3 = string.char(Math.floor(fourcc / 65536) % 256);
  const c4 = string.char(Math.floor(fourcc / 16777216) % 256);
  return c4 + c3 + c2 + c1;
}

interface SegmentInfo {
  tokens: string[];
  abilId: string;
  waitSec: number;
}

/** 解析 hot 字符串和 abilList，返回每段的信息 */
function parseSegments(hotStr: string, abilList: string): SegmentInfo[] {
  const segments = hotStr.split("+");
  const abilIds = abilList.split(",").map((x) => x.trim());
  const result: SegmentInfo[] = [];
  for (let i = 0; i < segments.length; i++) {
    const seg = segments[i].trim();
    if (seg === "") continue;
    const tokens = seg.split(";").map((x) => x.trim()).filter((x) => x !== "");
    let waitSec = 0;
    for (const t of tokens) {
      const waitIdx = t.indexOf(":wait");
      if (waitIdx >= 0) {
        const w = parseFloat(t.substring(waitIdx + 5)) || 0;
        if (w > waitSec) waitSec = w;
      }
    }
    result.push({ tokens, abilId: abilIds[i] ?? "", waitSec });
  }
  return result;
}

/** 根据 token 列表和单位，计算 TempReal[1]=HP、TempReal[2]=MP，token 中 :waitN 后缀在此忽略（已提取） */
function calcHpMp(tokens: string[], unit: any): { hp: number; mp: number } {
  let hp = 0;
  let mp = 0;
  const maxHp: number = typeof (jass as any).GetUnitState === "function"
    ? (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(1)) : 0;
  const curHp: number = typeof (jass as any).GetWidgetLife === "function"
    ? (jass as any).GetWidgetLife(unit) : 0;
  const maxMp: number = typeof (jass as any).GetUnitState === "function"
    ? (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(3)) : 0;
  const lostHp = maxHp - curHp;

  for (const rawToken of tokens) {
    const waitIdx = rawToken.indexOf(":wait");
    const t = (waitIdx >= 0 ? rawToken.substring(0, waitIdx) : rawToken).trim();
    const tl = t.toLowerCase();
    if (tl.endsWith("hplost")) {
      const prefix = t.substring(0, t.length - 6);
      if (prefix.endsWith("%")) {
        const pct = parseFloat(prefix.substring(0, prefix.length - 1)) / 100;
        hp += lostHp * pct;
      } else {
        hp += parseFloat(prefix) || 0;
      }
    } else if (tl.endsWith("hp")) {
      const prefix = t.substring(0, t.length - 2);
      if (prefix.endsWith("%")) {
        const pct = parseFloat(prefix.substring(0, prefix.length - 1)) / 100;
        hp += maxHp * pct;
      } else {
        hp += parseFloat(prefix) || 0;
      }
    } else if (tl.endsWith("mp")) {
      const prefix = t.substring(0, t.length - 2);
      if (prefix.endsWith("%")) {
        const pct = parseFloat(prefix.substring(0, prefix.length - 1)) / 100;
        mp += maxMp * pct;
      } else {
        mp += parseFloat(prefix) || 0;
      }
    }
  }
  return { hp, mp };
}

/** 立即执行一段的赋值+TriggerExecute */
function executeSegment(unit: any, seg: SegmentInfo): void {
  const { hp, mp } = calcHpMp(seg.tokens, unit);
  const tr = (g as any).udg_TempReal != null ? (g as any).udg_TempReal : ((g as any).udg_TempReal = {});
  tr[1] = hp;
  tr[2] = mp;
  (jass as any).udg_TempUnit[1] = unit;
  (g as any).udg_TempString[0] = seg.abilId;
  const trig = (g as any).gg_trg_HealItemEffect;
  if (trig && typeof (jass as any).TriggerExecute === "function") (jass as any).TriggerExecute(trig);
}

function onUseItem(): void {
  const unit = (jass as any).GetManipulatingUnit?.() ?? (jass as any).GetTriggerUnit?.();
  const item = (jass as any).GetManipulatedItem?.();
  if (!unit || !item) return;
  if (typeof (jass as any).IsUnitType === "function" && jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
  if (typeof (jass as any).IsUnitIllusionBJ === "function" && (jass as any).IsUnitIllusionBJ(unit)) return;
  const itemId = typeof (jass as any).GetItemTypeId === "function" ? (jass as any).GetItemTypeId(item) : 0;
  const idStr = fourCCToString(itemId);
  const entry = (itemsData as Record<string, { hot?: string; abilList?: string }>)[idStr];
  if (!entry || !entry.hot || !entry.abilList) return;

  const glob = globalThis as any;
  const key = tostring(unit) + "_" + idStr;
  if (glob.__EquipHealExecutedKey === key) return;
  glob.__EquipHealExecutedKey = key;
  const clearTimer = (jass as any).CreateTimer?.();
  if (clearTimer && typeof (jass as any).TimerStart === "function") {
    const ct = clearTimer;
    (jass as any).TimerStart(ct, 0.5, false, () => {
      glob.__EquipHealExecutedKey = undefined;
      if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(ct);
    });
  }

  const segments = parseSegments(entry.hot, entry.abilList);
  for (const seg of segments) {
    if (seg.abilId === "") continue;
    if (seg.waitSec <= 0) {
      executeSegment(unit, seg);
    } else {
      const delayTimer = (jass as any).CreateTimer?.();
      if (delayTimer && typeof (jass as any).TimerStart === "function") {
        const dt = delayTimer;
        const capturedSeg = seg;
        const capturedUnit = unit;
        (jass as any).TimerStart(dt, seg.waitSec, false, () => {
          executeSegment(capturedUnit, capturedSeg);
          if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(dt);
        });
      }
    }
  }
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
