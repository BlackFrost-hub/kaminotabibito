/** @noSelfInFile */

const jass = require("jass.common") as any;
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (four: number) => string;
};
const itemsData: Record<string, any> = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, any> }).default;

export const STAT_CONFIG: { name: string; key: string }[] = [
  { name: "生命值", key: "hp" }, { name: "魔法值", key: "mp" },
  { name: "攻击力", key: "dmg" }, { name: "护甲", key: "armor" },
  { name: "攻速", key: "atkSpeed" }, { name: "叠加移动速度", key: "movespeed" },
  { name: "力量", key: "str" }, { name: "敏捷", key: "agi" },
  { name: "智力", key: "int" }, { name: "全属性", key: "all" },
  { name: "暴击率", key: "critRate" }, { name: "暴击伤害", key: "critDmg" }, { name: "魔抗", key: "magicResist" },
  { name: "生命恢复", key: "hpRegen" }, { name: "生命恢复%", key: "hpRegenPct" }, { name: "生命恢复效率", key: "hpRegenEff" },
  { name: "技能治疗率", key: "skillHeal" }, { name: "受到的治疗率", key: "healReceived" },
  { name: "重伤", key: "wound" },
  { name: "魔法恢复", key: "mpRegen" }, { name: "魔法恢复%", key: "mpRegenPct" }, { name: "魔法消耗", key: "mpCost" },
  { name: "冷却缩减", key: "cdReduction" }, { name: "命中率", key: "accuracy" }, { name: "闪避率", key: "dodge" },
  { name: "护甲穿透", key: "armorPierce" }, { name: "魔法穿透", key: "magicPierce" },
  { name: "技能伤害", key: "skillDmg" }, { name: "技能抗性", key: "skillResist" }, { name: "魔法伤害", key: "magicDmg" },
  { name: "物理伤害", key: "physDmg" }, { name: "物理抗性", key: "physResist" }, { name: "强化伤害", key: "enhanceDmg" },
  { name: "普攻伤害", key: "atkDmg" }, { name: "普攻抗性", key: "atkResist" },
  { name: "光属性伤害", key: "lightDmg" }, { name: "光属性抗性", key: "lightResist" },
  { name: "暗属性伤害", key: "darkDmg" }, { name: "暗属性抗性", key: "darkResist" },
  { name: "木属性伤害", key: "woodDmg" }, { name: "木属性抗性", key: "woodResist" },
  { name: "火属性伤害", key: "fireDmg" }, { name: "火属性抗性", key: "fireResist" },
  { name: "雷属性伤害", key: "thunderDmg" }, { name: "雷属性抗性", key: "thunderResist" },
  { name: "水属性伤害", key: "waterDmg" }, { name: "水属性抗性", key: "waterResist" },
  { name: "金属性抗性", key: "MetalResist" }, { name: "金属性伤害", key: "metalDmg" }, { name: "召唤物伤害", key: "summonDmg" }, { name: "召唤物抗性", key: "summonResist" },
  { name: "伤害减少", key: "dmgReduction" }, { name: "伤害减少%", key: "dmgReductionPct" },
  { name: "伤害吸血", key: "lifeSteal" }, { name: "魔法伤害吸血", key: "magicLifeSteal" }, { name: "普攻伤害吸血", key: "atkLifeSteal" },
  { name: "被暴击率", key: "critRateTaken" }, { name: "被暴击伤害", key: "critDmgTaken" }, { name: "眩晕抗性", key: "stunResist" },
  { name: "魔法普攻伤害", key: "magicAtkDmg" }, { name: "蝼蚁专精", key: "antMastery" }, { name: "移动速度", key: "movespeed2" },
  { name: "伤害%", key: "dmgBonus" }, { name: "最终伤害%", key: "finalDmgBonus" }, { name: "经验获取率", key: "expGainRate" },
  { name: "最大生命值%", key: "hpPct" }, { name: "最大法力值%", key: "mpPct" },
  { name: "基础生命值%", key: "baseHpPct" }, { name: "基础攻击力%", key: "baseDmgPct" }, { name: "基础护甲%", key: "baseArmorPct" },
  { name: "生命值%", key: "hpPercent" }, { name: "法力值%", key: "mpPercent" }, { name: "攻击力%", key: "dmgPercent" }, { name: "护甲%", key: "armorPercent" },
  { name: "受到技伤减少", key: "SpellReduce" }, { name: "受到物伤减少", key: "PhysReduce" },
];

export const KEY_TO_NAME: Record<string, string> = {};
export const NAME_TO_KEY: Record<string, string> = {};
for (const e of STAT_CONFIG) {
  KEY_TO_NAME[e.key] = e.name;
  NAME_TO_KEY[e.name] = e.key;
}
if (!NAME_TO_KEY["移速"]) NAME_TO_KEY["移速"] = "moveSpeed";

export function findStatKey(raw: string): string {
  if (KEY_TO_NAME[raw] !== undefined) return raw;
  const rl = raw.toLowerCase();
  for (const k in KEY_TO_NAME) {
    if (k.toLowerCase() === rl) return k;
  }
  return "";
}

export function getItemDataEntry(item: any): any | null {
  if (item == null || item === 0) return null;
  const itemId = jass.GetItemTypeId(item);
  if (itemId == null || itemId === 0) return null;
  const idStr = fourCCToString(itemId);
  const entry = itemsData[idStr];
  if (!entry) return null;
  return entry;
}

export function getItemDataEntryByIdStr(idStr: string): any | null {
  if (!idStr) return null;
  const entry = itemsData[idStr];
  if (!entry) return null;
  return entry;
}

export function getItemDataEntryByTypeId(itemTypeId: number): any | null {
  if (itemTypeId == null || itemTypeId === 0) return null;
  const idStr = fourCCToString(itemTypeId);
  return getItemDataEntryByIdStr(idStr);
}
