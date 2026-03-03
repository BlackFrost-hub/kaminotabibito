// equip_system.ts
(globalThis as any).print("【调试】equip_system 开始加载");

const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { udg_TempUnit: any; udg_TempIsAdd: boolean; [key: string]: any };
const items = (require("系统.装备.装备数据") as { default: Record<string, ItemData> }).default;

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

const percentNames = [
  "暴击率", "暴击伤害", "命中率", "护甲穿透", "魔法穿透", "技能伤害",
  "闪避率", "魔抗", "冷却缩减", "伤害吸血", "魔法伤害吸血", "普通攻击吸血",
  "攻速", "移速"
];

function initEvents(): void {
  const trig = jass.CreateTrigger();
  for (let i = 0; i <= 7; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_PICKUP_ITEM, undefined!);
    jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), jass.EVENT_PLAYER_UNIT_DROP_ITEM, undefined!);
  }
  jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(12), jass.EVENT_PLAYER_UNIT_PICKUP_ITEM, undefined!);
  jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(12), jass.EVENT_PLAYER_UNIT_DROP_ITEM, undefined!);

  jass.TriggerAddAction(trig, () => {
    const item = jass.GetManipulatedItem();
    const unit = jass.GetManipulatingUnit();
    const player = jass.GetOwningPlayer(unit);
    const itemId = jass.GetItemTypeId(item);
    const event = jass.GetTriggerEventId();
    const idStr = fourCCToString(itemId);
    const itemData = items[idStr];
    if (!itemData) return;

    g.udg_TempUnit = unit;
    g.udg_TempIsAdd = event === jass.EVENT_PLAYER_UNIT_PICKUP_ITEM;
    g.udg_TempHp = itemData.hp ?? 0;
    g.udg_TempMp = itemData.mp ?? 0;
    g.udg_TempDmg = itemData.dmg ?? 0;
    g.udg_TempArmor = itemData.armor ?? 0;
    g.udg_TempAtkSpeed = itemData.atkSpeed ?? 0;
    g.udg_TempMoveSpeed = itemData.moveSpeed ?? 0;
    g.udg_TempStr = itemData.str ?? 0;
    g.udg_TempAgi = itemData.agi ?? 0;
    g.udg_TempInt = itemData.int ?? 0;
    g.udg_TempAll = itemData.all ?? 0;

    const playerStats: StatEntry[] = [];
    const isAdd = g.udg_TempIsAdd;

    const addStat = (val: number | undefined, name: string) => {
      if (val == null || val === 0) return;
      let value = val;
      if (!isAdd) value = -value;
      playerStats.push({ name, value });
    };
    addStat(itemData.hp, "生命");
    addStat(itemData.mp, "魔法");
    addStat(itemData.dmg, "攻击");
    addStat(itemData.armor, "护甲");
    addStat(itemData.atkSpeed, "攻速");
    addStat(itemData.moveSpeed, "移速");
    addStat(itemData.str, "力量");
    addStat(itemData.agi, "敏捷");
    addStat(itemData.int, "智力");
    addStat(itemData.all, "全属性");
    addStat(itemData.critRate, "暴击率");
    addStat(itemData.critDamage, "暴击伤害");

    jass.ExecuteFunc("ApplyItemBonus");

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
    let msg = "|cFF87CEEB【装备】|r " + actionText + "[" + coloredLevel + "]" + "级" + "『" + coloredName + "』";
    for (const stat of playerStats) {
      const sign = stat.value > 0 ? "+" : "";
      if (percentNames.indexOf(stat.name) >= 0) {
        msg += " " + stat.name + sign + (stat.value * 100) + "%";
      } else {
        msg += " " + stat.name + sign + stat.value;
      }
    }
    jass.DisplayTimedTextToPlayer(player, 0, 0, 5, msg);
  });

  (globalThis as any).print("【调试】事件监听器创建完成");
}

// 立即执行：注册拾取/丢弃物品事件（require 时整块执行，initEvents 会运行）
initEvents();
(globalThis as any).print("【调试】equip_system 加载完成");
export {}; // 保持为模块，使 jass/g/items 等为 local，且 require() 会执行本文件
