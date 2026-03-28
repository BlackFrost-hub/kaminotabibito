// equip_system.ts
/** 为 true 时在屏幕显示装备限制与 DROP 跳过调试；排查完可设为 true */
// if ((globalThis as any).DEBUG_EQUIP_SKIP_DROP === undefined) (globalThis as any).DEBUG_EQUIP_SKIP_DROP = true;
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { udg_TempIsAdd: boolean; udg_TempScore: number;[key: string]: any };
const items = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, ItemData> }).default;
const equipLimit = require("系统.02．物品系统.10．装备限制") as { equipLimitWouldAllowPickup?: (unit: any, item: any) => boolean; equipShared: { skipNextDrop: boolean } };
const equipShared = equipLimit.equipShared;
const equipMovespeed = require("系统.02．物品系统.08．装备移速") as { getMaxMovespeed2Info?: (u: any, ignoreItem?: any) => { value: number; name: string; count: number } };

function fourCCToString(fourcc: number): string {
  const c1 = string.char(fourcc % 256);
  const c2 = string.char(Math.floor(fourcc / 256) % 256);
  const c3 = string.char(Math.floor(fourcc / 65536) % 256);
  const c4 = string.char(Math.floor(fourcc / 16777216) % 256);
  return c4 + c3 + c2 + c1;
}

interface ItemData {
  name?: string;
  level?: string;
  hp?: number;
  mp?: number;
  dmg?: number;
  armor?: number;
  atkSpeed?: number;
  moveSpeed?: number;
  str?: number;
  agi?: number;
  int?: number;
  all?: number;
  critRate?: number;
  critDamage?: number;
  [key: string]: any;
}

interface StatEntry {
  name: string;
  value: number;
}

/** 属性配置：显示名 -> itemData key，udg 为 JASS 全局时填写。新增属性只需在此加一行，primaryBonus 即可用该显示名 */
const STAT_CONFIG: { name: string; key: string; udg?: string }[] = [
  { name: "生命值", key: "hp", udg: "udg_TempHp" }, { name: "魔法值", key: "mp", udg: "udg_TempMp" },
  { name: "攻击力", key: "dmg", udg: "udg_TempDmg" }, { name: "护甲", key: "armor", udg: "udg_TempArmor" },
  { name: "攻速", key: "atkSpeed", udg: "udg_TempAtkSpeed" }, { name: "叠加移动速度", key: "movespeed" },
  { name: "力量", key: "str", udg: "udg_TempStr" }, { name: "敏捷", key: "agi", udg: "udg_TempAgi" },
  { name: "智力", key: "int", udg: "udg_TempInt" }, { name: "全属性", key: "all", udg: "udg_TempAll" },
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
  { name: "金属性抗性", key: "MetalResist" }, { name: "召唤物伤害", key: "summonDmg" }, { name: "召唤物抗性", key: "summonResist" },
  { name: "伤害减少", key: "dmgReduction" }, { name: "伤害减少%", key: "dmgReductionPct" },
  { name: "伤害吸血", key: "lifeSteal" }, { name: "魔法伤害吸血", key: "magicLifeSteal" }, { name: "普攻伤害吸血", key: "atkLifeSteal" },
  { name: "被暴击率", key: "critRateTaken" }, { name: "被暴击伤害", key: "critDmgTaken" }, { name: "眩晕抗性", key: "stunResist" },
  { name: "魔法普攻伤害", key: "magicAtkDmg" }, { name: "蝼蚁专精", key: "antMastery" }, { name: "移动速度", key: "movespeed2" },
  { name: "伤害%", key: "dmgBonus" }, { name: "最终伤害%", key: "finalDmgBonus" }, { name: "经验获取率", key: "expGainRate" },
  { name: "最大生命值%", key: "hpPct" }, { name: "基础攻击力%", key: "baseDmgPct" }
];
const NAME_TO_KEY: Record<string, string> = {};
for (const e of STAT_CONFIG) { NAME_TO_KEY[e.name] = e.key; }
if (!NAME_TO_KEY["移速"]) NAME_TO_KEY["移速"] = "moveSpeed"; // JASS TempMoveSpeed 用，不参与 addStat

/** 解析 primaryBonus：格式 "力量+7/敏捷+10/智力+5,魔法伤害+5%"，按主属性 1/2/3 取对应段，段内可用逗号多属性。返回 key->数值 */
function parsePrimaryBonus(s: string, mainAttr: number): Record<string, number> {
  const out: Record<string, number> = {};
  if (!s || mainAttr < 1 || mainAttr > 3) return out;
  const segments = s.split("/");
  const seg = (segments[mainAttr - 1] || "").trim();
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
  "最大生命值%", "基础攻击力%"
];

function initEvents(): void {
  const trig = jass.CreateTrigger();
  for (let i = 0; i <= 7; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_PICKUP_ITEM, undefined!);
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_DROP_ITEM, undefined!);
  }
  jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(13), jass.EVENT_PLAYER_UNIT_PICKUP_ITEM, undefined!);
  jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(13), jass.EVENT_PLAYER_UNIT_DROP_ITEM, undefined!);

  jass.TriggerAddAction(trig, () => {
    const item = jass.GetManipulatedItem();
    const unit = jass.GetManipulatingUnit();
    if (!unit || !item) return;
    if (jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
    if (typeof (jass as any).IsUnitIllusionBJ === "function" && (jass as any).IsUnitIllusionBJ(unit)) return;
    if (typeof (jass as any).IsUnitIllusion === "function" && (jass as any).IsUnitIllusion(unit)) return;
    const player = jass.GetOwningPlayer(unit);
    const itemId = jass.GetItemTypeId(item);
    const event = jass.GetTriggerEventId();
    const isDrop = event === jass.EVENT_PLAYER_UNIT_DROP_ITEM;
    const skipFlag = equipShared.skipNextDrop;
    if (isDrop && skipFlag) {
      equipShared.skipNextDrop = false;
      // if ((globalThis as any).DEBUG_EQUIP_SKIP_DROP) jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0.02, 6, "|cff87ceeb[装备调试]|r DROP 因 SkipNextDrop 已跳过");
      return;
    }
    // if (isDrop && (globalThis as any).DEBUG_EQUIP_SKIP_DROP) jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0.02, 6, "|cff87ceeb[装备调试]|r DROP 未跳过 SkipNextDrop=" + tostring(skipFlag));
    const idStr = fourCCToString(itemId);
    const itemData = items[idStr];
    if (!itemData) {
      if (event === jass.EVENT_PLAYER_UNIT_PICKUP_ITEM) {
        const displayName = (typeof slk !== "undefined" && slk.item && (slk.item as Record<string, { name?: string }>)[idStr]?.name) || idStr;
        const border = "|cff606060────────────────────────|r";
        const msg = border + "\n|cffffff00『系统消息』：|r"+"检测到|cFF87CEEB【装备】|r"+"|cFFFFD700" + "『"+ displayName +"』" +"|r不在装备数据内，可以的话请加作者|cFF00D7FFQ2376886288|r反馈bug和问题，多谢。\n" + border;
        jass.DisplayTimedTextToPlayer(player, 0, 0.01, 10, msg);
      }
      return;
    }
    const skipType = (itemData as { type?: string }).type;
    if (skipType === "任务" || skipType === "药剂" || skipType === "食品") return;
    // 消耗品（有 hot）用完后会触发 DROP，不提示「丢弃」
    if (isDrop && (itemData as { hot?: string }).hot) return;
    // 拾取时：装备限制不通过则不加属性、不提示“获得”，并标记跳过下一次 DROP（装备限制会 UnitRemoveItem 触发丢弃）
    // 被拒时不设 skipNextDrop：只由装备限制在 UnitRemoveItem 前设置，避免误跳过后续玩家手动丢弃
    if (event === jass.EVENT_PLAYER_UNIT_PICKUP_ITEM && typeof equipLimit.equipLimitWouldAllowPickup === "function" && !equipLimit.equipLimitWouldAllowPickup(unit, item)) {
      // if ((globalThis as any).DEBUG_EQUIP_SKIP_DROP) jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0.02, 6, "|cff87ceeb[装备调试]|r PICKUP 被拒，不加属性");
      return;
    }

    const charges = jass.GetItemCharges(item);
    const mult = charges > 0 ? charges : 1;

    (jass as any).udg_TempUnit[1] = unit;
    g.udg_TempIsAdd = event === jass.EVENT_PLAYER_UNIT_PICKUP_ITEM;
    const primaryBonus = (itemData as { primaryBonus?: string }).primaryBonus;
    let primary: Record<string, number> = {};
    if (primaryBonus && typeof (jass as any).ExecuteFunc === "function") {
      jass.ExecuteFunc("GetHeroMainAttribute");
      const mainAttr = ((g as any).udg_TempInteger != null && (g as any).udg_TempInteger[1] != null) ? (g as any).udg_TempInteger[1] : 0;
      primary = parsePrimaryBonus(primaryBonus, mainAttr);
    }
    const merged: Record<string, number> = {};
    for (const e of STAT_CONFIG) {
      merged[e.key] = (itemData[e.key] ?? 0) + (primary[e.key] ?? 0);
    }
    merged["moveSpeed"] = (itemData.moveSpeed ?? 0) + (primary["moveSpeed"] ?? 0);

    g.udg_TempHp = merged.hp ?? 0;
    g.udg_TempMp = merged.mp ?? 0;
    g.udg_TempDmg = merged.dmg ?? 0;
    g.udg_TempArmor = merged.armor ?? 0;
    g.udg_TempAtkSpeed = merged.atkSpeed ?? 0;
    g.udg_TempMoveSpeed = merged.moveSpeed ?? 0;
    g.udg_TempStr = merged.str ?? 0;
    g.udg_TempAgi = merged.agi ?? 0;
    g.udg_TempInt = merged.int ?? 0;
    g.udg_TempAll = merged.all ?? 0;
    g.udg_TempScore = itemData.score ?? 0;

    const playerStats: StatEntry[] = [];
    const isAdd = g.udg_TempIsAdd;
    const addStat = (val: number | undefined, name: string) => {
      if (val == null || val === 0) return;
      let value = val * mult;
      if (!isAdd) value = -value;
      playerStats.push({ name, value });
    };
    for (const e of STAT_CONFIG) {
      addStat(merged[e.key], e.name);
    }
    //再保存到全局变量（此时 playerStats 已经有数据了）
    g.udg_TempString = {};
    g.udg_TempAmount = {};
    g.udg_TempStatCount = playerStats.length;

    for (let i = 0; i < playerStats.length; i++) {
      g.udg_TempString[i + 1] = playerStats[i].name;
      g.udg_TempAmount[i + 1] = playerStats[i].value;
    }

    const owner = jass.GetOwningPlayer(unit);
    const playerName = (typeof (jass as any).GetPlayerName === "function" ? (jass as any).GetPlayerName(owner) : "") ?? "";

    const actionText = g.udg_TempIsAdd ? "获得" : "丢弃";
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

    jass.ExecuteFunc("ApplyItemBonus");
    const tempRead = (g as any).udg_TempReadValue as number[] | undefined;
    const test5Parts: string[] = [];
    for (let i = 0; i < playerStats.length; i++) {
      const idx = i + 1;
      const statName = g.udg_TempString[idx];
      if (statName === "移动速度") continue; // 移速由下方从装备移速取数并显示
      const val = tempRead != null && (tempRead as any)[idx] != null ? (tempRead as any)[idx] : 0;
      const num = Number(val);
      const isPct = percentNames.indexOf(statName) >= 0;
      const nearZero = num > -1e-6 && num < 1e-6;
      const valStr = isPct ? (nearZero ? "0%" : tostring(math.floor(num * 1000 + 0.5) / 10) + "%") : (nearZero ? "0" : tostring(num));
      test5Parts.push(statName + "为：" + valStr);
    }
    // 仅当本次操作的装备带移速时才在「当前装备加成」里显示移速，且 DROP 时排除被丢物品再算
    const hasMovespeed2 = (itemData as { movespeed2?: number }).movespeed2 != null;
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
  });

  // (globalThis as any).print("【调试】事件监听器创建完成");
}

// 立即执行：注册拾取/丢弃物品事件（require 时整块执行，initEvents 会运行）
initEvents();
// (globalThis as any).print("【调试】equip_system 加载完成");
export { }; // 保持为模块，使 jass/g/items 等为 local，且 require() 会执行本文件