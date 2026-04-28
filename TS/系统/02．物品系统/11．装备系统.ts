// equip_system.ts
/** 为 true 时在屏幕显示装备限制与 DROP 跳过调试；排查完可设为 true */
// if ((globalThis as any).DEBUG_EQUIP_SKIP_DROP === undefined) (globalThis as any).DEBUG_EQUIP_SKIP_DROP = true;
const jass = require("jass.common") as any;
const itemEventCenter = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (callback: (unit: any, item: any) => void) => number;
  onItemDrop: (callback: (unit: any, item: any) => void) => number;
};
const g = require("jass.globals") as { udg_TempIsAdd: boolean; udg_TempScore: number;[key: string]: any };
const equipLimit = require("系统.02．物品系统.10．装备限制") as { equipLimitWouldAllowPickup?: (unit: any, item: any) => boolean; equipShared: { skipNextDrop: boolean } };
const equipShared = equipLimit.equipShared;
const equipMovespeed = require("系统.02．物品系统.08．装备移速") as { getMaxMovespeed2Info?: (u: any, ignoreItem?: any) => { value: number; name: string; count: number } };
const { applyEquipStatsTS } = require("lib.扩展函数.Star扩展函数.01．装备属性应用") as {
  applyEquipStatsTS: (unit: any, stats: { name: string; value: number }[]) => Record<string, number>;
};
const { fourCCToString, isSpecialUnit } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (four: number) => string;
  isSpecialUnit: (unit: any) => boolean;
};
const { STAT_CONFIG, NAME_TO_KEY, getItemDataEntry } = require("lib.扩展函数.物品相关函数.index") as {
  STAT_CONFIG: { name: string; key: string }[];
  NAME_TO_KEY: Record<string, string>;
  getItemDataEntry: (item: any) => any | null;
};
const { getObjectProperty, ObjectType } = require("lib.扩展函数.YDWE函数.index") as {
  getObjectProperty: (objectType: number, objectId: string | number, property: string) => string;
  ObjectType: { UNIT: number };
};

const EQUIP_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 13] as const;

interface StatEntry {
  name: string;
  value: number;
}

/** 解析 primaryBonus：格式 "力量+7/敏捷+10/智力+5,魔法伤害+5%"，按主属性 STR/AGI/INT 取对应段。返回 key->数值 */
function parsePrimaryBonus(s: string, primaryStr: string): Record<string, number> {
  const out: Record<string, number> = {};
  const attrIndex: Record<string, number> = { STR: 0, AGI: 1, INT: 2 };
  const idx = attrIndex[primaryStr];
  if (!s || idx == null) return out;
  const segments = s.split("/");
  const seg = (segments[idx] || "").trim();
  if (!seg) return out;
  const parts = seg.split(",");
  for (const p of parts) {
    const idx = p.indexOf("+");
    if (idx < 0) continue;
    const name = p.substring(0, idx).trim();
    const valStr = p.substring(idx + 1).trim();
    const key = NAME_TO_KEY[name];
    if (!key) continue;
    const isPct = valStr.indexOf("%") >= 0;
    const num = parseFloat(valStr) || 0;
    out[key] = (out[key] ?? 0) + (isPct ? num / 100 : num);
  }
  return out;
}

const percentNames = [
  "暴击率", "暴击伤害", "命中率", "护甲穿透", "魔法穿透", "技能伤害",
  "闪避率", "魔抗", "冷却缩减", "伤害吸血", "魔法伤害吸血", "普攻伤害吸血",
  "攻速",
  "生命恢复%", "魔法恢复%", "技能治疗率", "受到的治疗率", "魔法消耗", "重伤",
  "技能抗性", "魔法伤害", "物理伤害", "物理抗性", "强化伤害", "普攻伤害", "普攻抗性",
  "光属性伤害", "光属性抗性", "暗属性伤害", "暗属性抗性", "木属性伤害", "木属性抗性",
  "火属性伤害", "火属性抗性", "雷属性伤害", "雷属性抗性", "水属性伤害", "水属性抗性",
  "金属性抗性", "召唤物伤害", "召唤物抗性", "伤害减少%", "被暴击率", "被暴击伤害",
  "眩晕抗性", "魔法普攻伤害", "蝼蚁专精", "伤害%", "最终伤害%", "经验获取率",
  "最大生命值%", "最大法力值%", "基础生命值%", "基础攻击力%", "基础护甲%",
  "生命值%", "法力值%", "攻击力%", "护甲%"
];

/**
 * 处理物品拾取/丢弃的核心逻辑
 */
function handleItemEvent(unit: any, item: any, isPickup: boolean): void {
  if (unit === null || unit === 0 || item === null || item === 0) return;
  if (isSpecialUnit(unit)) return;
  const player = jass.GetOwningPlayer(unit);
  const isDrop = !isPickup;
  const skipFlag = equipShared.skipNextDrop;
  if (isDrop && skipFlag) {
    equipShared.skipNextDrop = false;
    return;
  }
  const idStr = fourCCToString(jass.GetItemTypeId(item));
  const itemData = getItemDataEntry(item);
  if (!itemData) {
    if (isPickup) {
      const displayName = (typeof slk !== "undefined" && slk.item && (slk.item as Record<string, { name?: string }>)[idStr]?.name) || idStr;
      const border = "|cff606060────────────────────────|r";
      const msg = border + "\n|cffffff00『系统消息』：|r"+"检测到|cFF87CEEB【装备】|r"+"|cFFFFD700" + "『"+ displayName +"』" +"|r不在装备数据内，可以的话请加作者|cFF00D7FFQ2376886288|r反馈bug和问题，多谢。\n" + border;
      jass.DisplayTimedTextToPlayer(player, 0, 0.01, 10, msg);
    }
    return;
  }
  const skipType = itemData.type;
  if (skipType === "任务" || skipType === "药剂" || skipType === "食品") return;
  // 消耗品（有 hot）用完后会触发 DROP，不提示「丢弃」，但仍需计算属性
  const isConsumable = isDrop && itemData.hot != null;
  // 拾取时：装备限制不通过则不加属性、不提示"获得"，并标记跳过下一次 DROP（装备限制会 UnitRemoveItem 触发丢弃）
  // 被拒时不设 skipNextDrop：只由装备限制在 UnitRemoveItem 前设置，避免误跳过后续玩家手动丢弃
  if (isPickup && typeof equipLimit.equipLimitWouldAllowPickup === "function" && !equipLimit.equipLimitWouldAllowPickup(unit, item)) {
    return;
  }

  const charges = jass.GetItemCharges(item);
  const mult = charges > 0 ? charges : 1;

  const isAdd = isPickup;
  const primaryBonus = itemData.primaryBonus;
  let primary: Record<string, number> = {};
  if (primaryBonus) {
    const typeId = (jass as any).GetUnitTypeId(unit);
    const unitId = typeId !== 0 ? fourCCToString(typeId) : "";
    const primaryStr = unitId !== "" ? getObjectProperty(ObjectType.UNIT, unitId, "Primary") : "";
    primary = parsePrimaryBonus(primaryBonus, primaryStr);
  }
  const merged: Record<string, number> = {};
  for (const e of STAT_CONFIG) {
    merged[e.key] = (itemData[e.key] ?? 0) + (primary[e.key] ?? 0);
  }
  merged["moveSpeed"] = (itemData.moveSpeed ?? 0) + (primary["moveSpeed"] ?? 0);

  const playerStats: StatEntry[] = [];
  const addStat = (val: number | undefined, name: string) => {
    if (val == null || val === 0) return;
    let value = val * mult;
    if (!isAdd) value = -value;
    playerStats.push({ name, value });
  };
  for (const e of STAT_CONFIG) {
    addStat(merged[e.key], e.name);
  }
  const owner = jass.GetOwningPlayer(unit);
  const playerName = ((jass as any).GetPlayerName(owner) as string) ?? "";

  const actionText = isAdd ? "获得" : "丢弃";
  const levelText = itemData.level || "";
  let levelColor: string;
  if (levelText === "E-" || levelText === "E") levelColor = "|cFF808080";
  else if (levelText === "D") levelColor = "|cFF00FF00";
  else if (levelText === "C") levelColor = "|cFF0000FF";
  else if (levelText === "B") levelColor = "|cFF800080";
  else if (levelText === "A") levelColor = "|cFFFFA500";
  else if (levelText === "S") levelColor = "|cFFFF0000";
  else levelColor = "|cFFFFFFFF";

  const coloredLevel = levelColor + levelText + "|r";
  const coloredName = "|cFFFFD700" + (itemData.name || "未知") + "|r";
  // 消耗品丢弃不显示消息，但仍计算属性
  if (!isConsumable) {
    let msg = "|cffffff00『系统消息』：|r" +"|cFF87CEEB【装备】|r " + actionText + "[" + coloredLevel + "]" + "级" + "『" + coloredName + "』";
    for (const stat of playerStats) {
      const sign = stat.value > 0 ? "+" : "";
      const isPct = percentNames.indexOf(stat.name) >= 0;
      const v = isPct ? stat.value * 100 : stat.value;
      const nearZero = v > -1e-6 && v < 1e-6;
      const vStr = nearZero ? "0" : tostring(v);
      msg += " " + stat.name + sign + vStr + (isPct ? "%" : "");
    }
    jass.DisplayTimedTextToPlayer(player, 0, 0.01, 5, msg);
  }

  const tempReadMap = applyEquipStatsTS(unit, playerStats);
  const test5Parts: string[] = [];
  for (let i = 0; i < playerStats.length; i++) {
    const statName = playerStats[i].name;
    if (statName === "移动速度") continue; // 移速由下方从装备移速取数并显示
    const val = tempReadMap[statName] != null ? tempReadMap[statName] : 0;
    const num = Number(val);
    const isPct = percentNames.indexOf(statName) >= 0;
    const nearZero = num > -1e-6 && num < 1e-6;
      const valStr = isPct ? (nearZero ? "0%" : tostring(jass.R2I(num * 1000 + 0.5) / 10) + "%") : (nearZero ? "0" : tostring(num));
    test5Parts.push(statName + "为：" + valStr);
  }
  // 仅当本次操作的装备带移速时才在「当前装备加成」里显示移速，且 DROP 时排除被丢物品再算
  const hasMovespeed2 = itemData.movespeed2 != null;
  if (hasMovespeed2 && unit != null && typeof equipMovespeed.getMaxMovespeed2Info === "function") {
    const ms = equipMovespeed.getMaxMovespeed2Info(unit, isDrop ? item : undefined);
    if (ms.value > 0) test5Parts.push("移动速度为：" + tostring(ms.value));
    if (ms.value > 0 && ms.name !== "" && ms.count >= 2) {
      jass.DisplayTimedTextToPlayer(owner, 0, 0.02, 5, "|cffffff00『系统提示』：|r有多个不可叠加移速装备，当前只生效|cff00bfff『" + ms.name + "』|r");
    }
  }
  if (test5Parts.length > 0) {
    jass.DisplayTimedTextToPlayer(owner, 0, 0.02, 5, "|cffffff00『系统消息』：|r" + playerName + "的当前装备加成" + test5Parts.join("，"));
  }
}

// (globalThis as any).print("【调试】事件监听器创建完成");

// 立即执行：注册拾取/丢弃物品事件（require 时整块执行，initEvents 会运行）
/**
 * 初始化事件：使用物品事件中心统一注册
 */
function initEvents(): void {
  // 使用物品事件中心注册，减少触发器数量
  itemEventCenter.onItemPickup((unit, item) => {
    handleItemEvent(unit, item, true);
  });
  itemEventCenter.onItemDrop((unit, item) => {
    handleItemEvent(unit, item, false);
  });
}

initEvents();
// (globalThis as any).print("【调试】equip_system 加载完成");
export { }; // 保持为模块，使 jass/g/items 等为 local，且 require() 会执行本文件
