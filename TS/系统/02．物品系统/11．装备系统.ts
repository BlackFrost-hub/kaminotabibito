// equip_system.ts
/** 为 true 时在屏幕显示装备限制与 DROP 跳过调试；排查完可设为 true */
// if ((globalThis as any).DEBUG_EQUIP_SKIP_DROP === undefined) (globalThis as any).DEBUG_EQUIP_SKIP_DROP = true;
const jass = require("jass.common") as any;
const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const GetItemCharges = jass.GetItemCharges as (this: void, item: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const g = require("jass.globals") as { udg_TempIsAdd: boolean; udg_TempScore: number;[key: string]: any };
const equipLimit = require("系统.02．物品系统.10．装备限制") as { equipLimitWouldAllowPickup?: (this: void, unit: any, item: any) => boolean; equipShared: { skipNextDrop: boolean } };
const equipShared = equipLimit.equipShared;
const equipMovespeed = require("系统.02．物品系统.08．装备移速") as { getMaxMovespeed2Info?: (u: any, ignoreItem?: any) => { value: number; name: string; count: number } };
const { applyEquipStatsTS } = require("lib.扩展函数.Star扩展函数.01．装备属性应用") as {
  applyEquipStatsTS: (this: void, unit: any, stats: { name: string; value: number }[]) => Record<string, number>;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: { sourceName?: string }) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { fourCCToString, isSpecialUnit } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (this: void, four: number) => string;
  isSpecialUnit: (unit: any) => boolean;
};
const itemRelatedFns = require("lib.扩展函数.物品相关函数.index") as {
  STAT_CONFIG: { name: string; key: string }[];
  NAME_TO_KEY: Record<string, string>;
  是否百分比装备属性名: (this: void, name: string) => boolean;
  getItemDataEntry: (this: void, item: any) => any | null;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const dynamicSkillText = require("系统.03．技能系统.07．动态技能文本.03．核心逻辑") as {
  同步刷新英雄技能界面: (this: void, hero: any) => void;
};
const { getObjectProperty, ObjectType } = require("lib.扩展函数.YDWE函数.index") as {
  getObjectProperty: (objectType: number, objectId: string | number, property: string) => string;
  ObjectType: { UNIT: number };
};
const { 装备等级颜色代码, 是否彩虹装备等级, 彩虹颜色文本, 去除颜色代码 } = require("系统.00．核心系统.01．颜色常量") as {
  装备等级颜色代码: (this: void, _?: undefined, level?: string) => string;
  是否彩虹装备等级: (this: void, _?: undefined, level?: string) => boolean;
  彩虹颜色文本: (this: void, _?: undefined, text?: string) => string;
  去除颜色代码: (this: void, text: string) => string;
};
const { 是否允许装备次数叠加 } = require("系统.02．物品系统.16．装备次数叠加配置") as {
  是否允许装备次数叠加: (this: void, 装备名: string) => boolean;
};

const EQUIP_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 13] as const;
let 装备物品消息静默层数 = 0;

export function beginEquipItemMessageSilence(this: void): void {
  装备物品消息静默层数 += 1;
}

export function endEquipItemMessageSilence(this: void): void {
  if (装备物品消息静默层数 > 0) {
    装备物品消息静默层数 -= 1;
  }
}

function isEquipItemMessageSilenced(this: void): boolean {
  return 装备物品消息静默层数 > 0;
}

function 应跳过装备属性结算(this: void, itemData: any): boolean {
  const itemType = itemData.type;
  if (itemType === "任务" || itemType === "药剂" || itemType === "食品") return true;
  return String(itemData.PowerUP || "").trim() !== "" && itemData.PowerUP仍结算装备属性 !== true;
}

const 装备视野BuffID = "C034";
const 装备视野Buff显示持续时间 = 999999;
const 不走装备系统物品ID表: Record<string, true> = {
  I0FK: true,
  I0FL: true,
  I0E5: true,
};

interface StatEntry {
  name: string;
  value: number;
}

function 刷新装备视野显示Buff(unit: any, 当前视野加成: number): void {
  if (unit == null || unit === 0) return;
  if (当前视野加成 !== 0) {
    registerManualBuff(unit, 装备视野BuffID, 装备视野Buff显示持续时间, 当前视野加成, {
      sourceName: "装备视野",
    });
  } else {
    移除单位指定Buff(unit, 装备视野BuffID);
  }
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
    const key = itemRelatedFns.NAME_TO_KEY[name];
    if (!key) continue;
    const isPct = valStr.indexOf("%") >= 0;
    const num = parseFloat(valStr) || 0;
    out[key] = (out[key] ?? 0) + (isPct ? num / 100 : num);
  }
  return out;
}

/** 合成直接移除物品时，补偿该物品已经由装备系统加入的属性。 */
export function 处理合成消耗装备属性(this: void, unit: any, item: any, consumedCount: number): void {
  if (unit == null || unit === 0 || item == null || item === 0 || !(consumedCount > 0)) return;
  if (isSpecialUnit(unit)) return;

  const idStr = fourCCToString(GetItemTypeId(item));
  if (不走装备系统物品ID表[idStr] === true) return;
  const itemData = itemRelatedFns.getItemDataEntry(item);
  if (!itemData) return;
  if (应跳过装备属性结算(itemData)) return;

  const charges = GetItemCharges(item);
  const itemCount = charges > 0 ? charges : 1;
  const itemNamePlain = 去除颜色代码(String(itemData.name || ""));
  let mult = 1;
  if (是否允许装备次数叠加(itemNamePlain)) {
    mult = consumedCount < itemCount ? consumedCount : itemCount;
  } else if (consumedCount < itemCount) {
    // 未按次数计算属性的充能物品，只有整件移除时才需要回退属性。
    return;
  }

  const primaryBonus = itemData.primaryBonus;
  let primary: Record<string, number> = {};
  if (primaryBonus) {
    const typeId = GetUnitTypeId(unit);
    const unitId = typeId !== 0 ? fourCCToString(typeId) : "";
    const primaryStr = unitId !== "" ? getObjectProperty(ObjectType.UNIT, unitId, "Primary") : "";
    primary = parsePrimaryBonus(primaryBonus, primaryStr);
  }

  const merged: Record<string, number> = {};
  for (const e of itemRelatedFns.STAT_CONFIG) {
    merged[e.key] = (itemData[e.key] ?? 0) + (primary[e.key] ?? 0);
  }
  merged["moveSpeed"] = (itemData.moveSpeed ?? 0) + (primary["moveSpeed"] ?? 0);

  const playerStats: StatEntry[] = [];
  for (const e of itemRelatedFns.STAT_CONFIG) {
    const value = merged[e.key];
    if (value == null || value === 0) continue;
    playerStats.push({ name: e.name, value: -value * mult });
  }

  const tempReadMap = applyEquipStatsTS(unit, playerStats);
  if (tempReadMap["视野"] != null) {
    刷新装备视野显示Buff(unit, Number(tempReadMap["视野"]) || 0);
  }
}

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
  if (getRegisteredPlayerHero(player) !== unit) return;
  const idStr = fourCCToString(GetItemTypeId(item));
  if (不走装备系统物品ID表[idStr] === true) return;
  const itemData = itemRelatedFns.getItemDataEntry(item);
  if (!itemData) {
    if (isPickup && !isEquipItemMessageSilenced()) {
      const displayName = (typeof slk !== "undefined" && slk.item && (slk.item as Record<string, { name?: string }>)[idStr]?.name) || idStr;
      const border = "|cff606060────────────────────────|r";
      const msg = border + "\n|cffffff00『系统消息』：|r"+"检测到|cFF87CEEB【装备】|r"+"|cFFFFD700" + "『"+ displayName +"』" +"|r不在装备数据内，可以的话请加作者|cFF00D7FFQ2376886288|r反馈bug和问题，多谢。\n" + border;
      jass.DisplayTimedTextToPlayer(player, 0, 0.01, 10, msg);
    }
    return;
  }
  if (应跳过装备属性结算(itemData)) return;
  // 消耗品（有 hot）用完后会触发 DROP，不提示「丢弃」，但仍需计算属性
  const isConsumable = isDrop && itemData.hot != null;
  // 拾取时：装备限制不通过则不加属性、不提示"获得"，并标记跳过下一次 DROP（装备限制会 UnitRemoveItem 触发丢弃）
  // 被拒时不设 skipNextDrop：只由装备限制在 UnitRemoveItem 前设置，避免误跳过后续玩家手动丢弃
  if (isPickup && typeof equipLimit.equipLimitWouldAllowPickup === "function" && !equipLimit.equipLimitWouldAllowPickup(unit, item)) {
    return;
  }

  const charges = jass.GetItemCharges(item);
  const itemNamePlain = 去除颜色代码(String(itemData.name || ""));
  const mult = 是否允许装备次数叠加(itemNamePlain) ? (charges > 0 ? charges : 1) : 1;

  const isAdd = isPickup;
  const primaryBonus = itemData.primaryBonus;
  let primary: Record<string, number> = {};
  if (primaryBonus) {
    const typeId = GetUnitTypeId(unit);
    const unitId = typeId !== 0 ? fourCCToString(typeId) : "";
    const primaryStr = unitId !== "" ? getObjectProperty(ObjectType.UNIT, unitId, "Primary") : "";
    primary = parsePrimaryBonus(primaryBonus, primaryStr);
  }
  const merged: Record<string, number> = {};
  for (const e of itemRelatedFns.STAT_CONFIG) {
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
  for (const e of itemRelatedFns.STAT_CONFIG) {
    addStat(merged[e.key], e.name);
  }
  const owner = jass.GetOwningPlayer(unit);
  const playerName = ((jass as any).GetPlayerName(owner) as string) ?? "";

  const actionText = isAdd ? "获得" : "丢弃";
  const levelText = String(itemData.level || "").trim();
      const 装备原名 = itemData.name || "未知";
  const 装备颜色代码 = 装备等级颜色代码(undefined, levelText);
  const coloredLevel = 是否彩虹装备等级(undefined, levelText) ? 彩虹颜色文本(undefined, levelText) : 装备颜色代码 + levelText + "|r";
  const coloredName = 是否彩虹装备等级(undefined, levelText) ? 彩虹颜色文本(undefined, 装备原名) : 装备颜色代码 + 装备原名 + "|r";
  // 消耗品丢弃不显示消息，但仍计算属性。
  if (!isConsumable && !isEquipItemMessageSilenced()) {
    let msg = "|cffffff00『系统消息』：|r" + "|cFF87CEEB【装备】|r " + actionText + coloredLevel + "级装备『" + coloredName + "』";
        for (const stat of playerStats) {
      const sign = stat.value > 0 ? "+" : "";
      const isPct = itemRelatedFns.是否百分比装备属性名(stat.name);
      const v = isPct ? stat.value * 100 : stat.value;
      const nearZero = v > -1e-6 && v < 1e-6;
      const vStr = nearZero ? "0" : tostring(v);
      msg += " " + stat.name + sign + vStr + (isPct ? "%" : "");
    }
    jass.DisplayTimedTextToPlayer(player, 0, 0.01, 5, msg);
  }

  const tempReadMap = applyEquipStatsTS(unit, playerStats);
  dynamicSkillText.同步刷新英雄技能界面(unit);
  if (tempReadMap["视野"] != null) {
    刷新装备视野显示Buff(unit, Number(tempReadMap["视野"]) || 0);
  }
  const test5Parts: string[] = [];
  for (let i = 0; i < playerStats.length; i++) {
    const statName = playerStats[i].name;
    if (statName === "移动速度") continue; // 移速由下方从装备移速取数并显示
    const val = tempReadMap[statName] != null ? tempReadMap[statName] : 0;
    const num = Number(val);
    const isPct = itemRelatedFns.是否百分比装备属性名(statName);
    const nearZero = num > -1e-6 && num < 1e-6;
      const valStr = isPct ? (nearZero ? "0%" : tostring(jass.R2I(num * 1000 + 0.5) / 10) + "%") : (nearZero ? "0" : tostring(num));
    test5Parts.push(statName + "为：" + valStr);
  }
  // 仅当本次操作的装备带移速时才在「当前装备加成」里显示移速，且 DROP 时排除被丢物品再算
  const hasMovespeed2 = itemData.movespeed2 != null;
  if (hasMovespeed2 && unit != null && typeof equipMovespeed.getMaxMovespeed2Info === "function") {
    const ms = equipMovespeed.getMaxMovespeed2Info(unit, isDrop ? item : undefined);
    if (ms.value > 0) test5Parts.push("移动速度为：" + tostring(ms.value));
    if (ms.value > 0 && ms.name !== "" && ms.count >= 2 && !isEquipItemMessageSilenced()) {
      jass.DisplayTimedTextToPlayer(owner, 0, 0.02, 5, "|cffffff00『系统提示』：|r有多个不可叠加移速装备，当前只生效|cff00bfff『" + ms.name + "』|r");
    }
  }
  if (test5Parts.length > 0 && !isEquipItemMessageSilenced()) {
    jass.DisplayTimedTextToPlayer(owner, 0, 0.02, 5, "|cffffff00『系统消息』：|r" + playerName + "的当前装备加成" + test5Parts.join("，"));
  }
}

// 立即执行：注册拾取/丢弃物品事件（require 时整块执行，initEvents 会运行）
/**
 * 初始化事件：使用物品事件中心统一注册
 */
function 处理装备拾取事件(this: void, unit: any, item: any): void {
  handleItemEvent(unit, item, true);
}

function 处理装备丢弃事件(this: void, unit: any, item: any): void {
  handleItemEvent(unit, item, false);
}

function initEvents(): void {
  // 使用物品事件中心注册，减少触发器数量
  onItemPickup(处理装备拾取事件);
  onItemDrop(处理装备丢弃事件);
}

initEvents();
export { }; // 保持为模块，使 jass/g/items 等为 local，且 require() 会执行本文件
