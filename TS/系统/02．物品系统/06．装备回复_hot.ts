/**
 * 装备 hot/abilList 解析与单段治疗量计算（供 `06．装备回复` 与 STES 推算共用）
 */

const jass = require("jass.common") as any;

export interface EquipHealSegmentInfo {
  tokens: string[];
  abilId: string;
  waitSec: number;
}

export function parseEquipHealSegments(hotStr: string, abilList: string): EquipHealSegmentInfo[] {
  const segments = hotStr.split("+");
  const abilIds = abilList.split(",").map((x) => x.trim());
  const result: EquipHealSegmentInfo[] = [];
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

export function calcEquipHealHpMp(tokens: string[], unit: any): { hp: number; mp: number } {
  let hp = 0;
  let mp = 0;
  const maxHp: number = jass.GetUnitState(unit, jass.ConvertUnitState(1)) as number;
  const curHp: number = jass.GetWidgetLife(unit) as number;
  const maxMp: number = jass.GetUnitState(unit, jass.ConvertUnitState(3)) as number;
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

/** 按装备表汇总各段治疗量（不拆 :wait 延时；仅统计 abilId 非空的段） */
export function sumHealFromItemData(
  unit: any,
  item: any,
  itemsData: Record<string, { hot?: string; abilList?: string }>,
  fourCCToString: (four: number) => string,
): { hp: number; mp: number; ok: boolean } {
  if (unit == null || unit === 0 || item == null || item === 0) return { hp: 0, mp: 0, ok: false };
  const itemId = jass.GetItemTypeId(item) as number;
  const idStr = fourCCToString(itemId);
  const entry = itemsData[idStr];
  if (!entry || !entry.hot || !entry.abilList) return { hp: 0, mp: 0, ok: false };
  const segments = parseEquipHealSegments(entry.hot, entry.abilList);
  let hp = 0;
  let mp = 0;
  for (let i = 0; i < segments.length; i++) {
    const seg = segments[i];
    if (seg.abilId === "") continue;
    const c = calcEquipHealHpMp(seg.tokens, unit);
    hp += c.hp;
    mp += c.mp;
  }
  return { hp, mp, ok: hp > 0 || mp > 0 };
}
