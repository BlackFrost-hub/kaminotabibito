// equip_system.ts
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { udg_TempUnit: any; udg_TempIsAdd: boolean; udg_TempScore: number;[key: string]: any };
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
  "攻速"
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

    const charges = jass.GetItemCharges(item);
    const mult = charges > 0 ? charges : 1;

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
    g.udg_TempScore = itemData.score ?? 0



    const playerStats: StatEntry[] = [];
    const isAdd = g.udg_TempIsAdd;

    const addStat = (val: number | undefined, name: string) => {
      if (val == null || val === 0) return;
      let value = val * mult;
      if (!isAdd) value = -value;
      playerStats.push({ name, value });
    };
    //逆天自定义值动态的属性定义
    addStat(itemData.hp, "生命值");
    addStat(itemData.mp, "魔法值");
    addStat(itemData.dmg, "攻击力");
    addStat(itemData.armor, "护甲");
    addStat(itemData.atkSpeed, "攻速");
    addStat(itemData.movespeed, "移速");
    addStat(itemData.str, "力量");
    addStat(itemData.agi, "敏捷");
    addStat(itemData.int, "智力");
    addStat(itemData.all, "全属性");
    addStat(itemData.critRate, "暴击率");
    addStat(itemData.critDmg, "暴击伤害");
    addStat(itemData.magicResist, "魔抗");
    addStat(itemData.hpRegen, "生命恢复");
    addStat(itemData.hpRegenPct, "生命恢复%");
    addStat(itemData.hpRegenEff, "生命恢复效率");
    addStat(itemData.skillHeal, "技能治疗率");
    addStat(itemData.healReceived, "受到的治疗率");
    addStat(itemData.mpRegen, "魔法恢复");
    addStat(itemData.mpRegenPct, "魔法恢复%");
    addStat(itemData.mpCost, "魔法消耗");
    addStat(itemData.cdReduction, "冷却缩减");
    addStat(itemData.accuracy, "命中率");
    addStat(itemData.dodge, "闪避率");
    addStat(itemData.armorPierce, "护甲穿透");
    addStat(itemData.magicPierce, "魔法穿透");
    addStat(itemData.skillDmg, "技能伤害");
    addStat(itemData.skillResist, "技能抗性");
    addStat(itemData.magicDmg, "魔法伤害");
    addStat(itemData.physDmg, "物理伤害");
    addStat(itemData.physResist, "物理抗性");
    addStat(itemData.enhanceDmg, "强化伤害");
    addStat(itemData.atkDmg, "普攻伤害");
    addStat(itemData.atkResist, "普攻抗性");
    addStat(itemData.lightDmg, "光属性伤害");
    addStat(itemData.lightResist, "光属性抗性");
    addStat(itemData.darkDmg, "暗属性伤害");
    addStat(itemData.darkResist, "暗属性抗性");
    addStat(itemData.woodDmg, "木属性伤害");
    addStat(itemData.woodResist, "木属性抗性");
    addStat(itemData.fireDmg, "火属性伤害");
    addStat(itemData.fireResist, "火属性抗性");
    addStat(itemData.thunderDmg, "雷属性伤害");
    addStat(itemData.thunderResist, "雷属性抗性");
    addStat(itemData.waterDmg, "水属性伤害");
    addStat(itemData.waterResist, "水属性抗性");
    addStat(itemData.MetalResist, "金属性抗性");
    addStat(itemData.summonDmg, "召唤物伤害");
    addStat(itemData.summonResist, "召唤物抗性");
    addStat(itemData.dmgReduction, "伤害减少");
    addStat(itemData.dmgReductionPct, "伤害减少%");
    addStat(itemData.lifeSteal, "伤害吸血");
    addStat(itemData.magicLifeSteal, "魔法伤害吸血");
    addStat(itemData.atkLifeSteal, "普攻伤害吸血");
    addStat(itemData.critRateTaken, "被暴击率");
    addStat(itemData.critDmgTaken, "被暴击伤害");
    addStat(itemData.stunResist, "眩晕抗性");
    addStat(itemData.magicAtkDmg, "魔法普攻伤害");
    addStat(itemData.antMastery, "蝼蚁专精");
    addStat(itemData.movespeed2, "移动速度");
    addStat(itemData.dmgBonus, "伤害%");
    addStat(itemData.finalDmgBonus, "最终伤害%");
    addStat(itemData.expGainRate, "经验获取率");
    //再保存到全局变量（此时 playerStats 已经有数据了）
    g.udg_TempString = {};
    g.udg_TempAmount = {};
    g.udg_TempStatCount = playerStats.length;

    for (let i = 0; i < playerStats.length; i++) {
      g.udg_TempString[i + 1] = playerStats[i].name;
      g.udg_TempAmount[i + 1] = playerStats[i].value;
    }

    const owner = jass.GetOwningPlayer(g.udg_TempUnit);
    const playerName = jass.GetPlayerName(owner);
    const test5Parts: string[] = [];
    for (const s of playerStats) {
      const val = jass.YDUserDataGet2 ? jass.YDUserDataGet2("player", owner, s.name, 0) : s.value;
      test5Parts.push(s.name + "为：" + tostring(Number(val)));
    }
    if (test5Parts.length > 0) {
      jass.DisplayTimedTextToPlayer(owner, 0, 0.02, 5, "测试5：" + playerName + "的当前" + test5Parts.join("，"));
    }

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
    jass.DisplayTimedTextToPlayer(player, 0, 0.01, 5, msg);

    jass.ExecuteFunc("ApplyItemBonus");
  });

  (globalThis as any).print("【调试】事件监听器创建完成");
}

// 立即执行：注册拾取/丢弃物品事件（require 时整块执行，initEvents 会运行）
initEvents();
(globalThis as any).print("【调试】equip_system 加载完成");
export { }; // 保持为模块，使 jass/g/items 等为 local，且 require() 会执行本文件
