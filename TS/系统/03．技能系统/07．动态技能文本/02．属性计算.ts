/** @noSelfInFile */
/**
 * 动态技能文本 - 属性计算
 *
 * 根据属性类型获取英雄的属性值，并计算公式结果
 * 属性通过 YDUserDataGet2 从玩家数据表中读取
 */

const jass = require("jass.common") as any;

const GetHeroStr = jass.GetHeroStr as (hero: any, includeBonuses: boolean) => number;
const GetHeroAgi = jass.GetHeroAgi as (hero: any, includeBonuses: boolean) => number;
const GetHeroInt = jass.GetHeroInt as (hero: any, includeBonuses: boolean) => number;
const GetUnitState = jass.GetUnitState as (unit: any, whichState: number) => number;
const ConvertUnitState = jass.ConvertUnitState as (index: number) => number;

const { YDUserDataGet2 } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet2: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};

import type { 属性类型 } from "./01．公式配置";

function 获取玩家属性(this: void, unit: any, 属性名: string): number {
  const owner = jass.GetOwningPlayer(unit);
  if (owner == null || owner === 0) return 0;
  return Number(YDUserDataGet2("player", owner, 属性名, "real")) || 0;
}

/**
 * 根据属性类型获取英雄属性值
 */
export function 获取属性值(this: void, unit: any, 属性: 属性类型): number {
  switch (属性) {
    // 基础属性 - 原生API
    case "力量":
      return GetHeroStr(unit, true);
    case "敏捷":
      return GetHeroAgi(unit, true);
    case "智力":
      return GetHeroInt(unit, true);
    case "全属性":
      return GetHeroStr(unit, true) + GetHeroAgi(unit, true) + GetHeroInt(unit, true);
    // 核心属性 - 原生API
    case "攻击力":
      return GetUnitState(unit, ConvertUnitState(0x12)) + GetUnitState(unit, ConvertUnitState(0x20));
    case "最大攻击力":
      return GetUnitState(unit, ConvertUnitState(0x12)) + GetUnitState(unit, ConvertUnitState(0x20));
    case "基础攻击力":
      return GetUnitState(unit, ConvertUnitState(0x12));
    case "生命值":
      return GetUnitState(unit, 42);
    case "最大生命值":
      return GetUnitState(unit, 42);
    case "基础生命值":
      return GetUnitState(unit, 42) - 获取玩家属性(unit, "生命值");
    case "魔法值":
      return GetUnitState(unit, 44);
    case "最大魔法值":
      return GetUnitState(unit, 44);
    case "基础魔法值":
      return GetUnitState(unit, 44) - 获取玩家属性(unit, "魔法值");
    case "护甲":
      return GetUnitState(unit, ConvertUnitState(0x20));
    case "攻速":
      return GetUnitState(unit, ConvertUnitState(0x51));
    case "移动速度":
      return GetUnitState(unit, ConvertUnitState(0x52));
    // 装备属性 - YDUserData
    case "每秒攻速":
      return 获取玩家属性(unit, "每秒攻速");
    // 暴击/命中/闪避
    case "暴击率":
      return 获取玩家属性(unit, "暴击率");
    case "暴击伤害":
      return 获取玩家属性(unit, "暴击伤害");
    case "命中率":
      return 获取玩家属性(unit, "命中率");
    case "闪避率":
      return 获取玩家属性(unit, "闪避率");
    case "魔抗":
      return 获取玩家属性(unit, "魔抗");
    case "被暴击率":
      return 获取玩家属性(unit, "被暴击率");
    case "被暴击伤害":
      return 获取玩家属性(unit, "被暴击伤害");
    // 穿透
    case "护甲穿透":
      return 获取玩家属性(unit, "护甲穿透");
    case "魔法穿透":
      return 获取玩家属性(unit, "魔法穿透");
    // 伤害类型
    case "技能伤害":
      return 获取玩家属性(unit, "技能伤害");
    case "物理伤害":
      return 获取玩家属性(unit, "物理伤害");
    case "魔法伤害":
      return 获取玩家属性(unit, "魔法伤害");
    case "普攻伤害":
      return 获取玩家属性(unit, "普攻伤害");
    case "强化伤害":
      return 获取玩家属性(unit, "强化伤害");
    case "魔法普攻伤害":
      return 获取玩家属性(unit, "魔法普攻伤害");
    case "伤害%":
      return 获取玩家属性(unit, "伤害%");
    case "最终伤害%":
      return 获取玩家属性(unit, "最终伤害%");
    // 抗性类型
    case "物理抗性":
      return 获取玩家属性(unit, "物理抗性");
    case "技能抗性":
      return 获取玩家属性(unit, "技能抗性");
    case "普攻抗性":
      return 获取玩家属性(unit, "普攻抗性");
    case "强化抗性":
      return 获取玩家属性(unit, "强化抗性");
    // 生命恢复
    case "生命恢复":
      return 获取玩家属性(unit, "生命恢复");
    case "生命恢复%":
      return 获取玩家属性(unit, "生命恢复%");
    case "生命恢复效率":
      return 获取玩家属性(unit, "生命恢复效率");
    case "百分比生命回复":
      return 获取玩家属性(unit, "百分比生命回复");
    case "生命恢复属性增幅":
      return 获取玩家属性(unit, "生命恢复属性增幅");
    case "总生命恢复":
      return 获取玩家属性(unit, "总生命恢复");
    // 魔法恢复
    case "魔法恢复":
      return 获取玩家属性(unit, "魔法恢复");
    case "魔法恢复%":
      return 获取玩家属性(unit, "魔法恢复%");
    case "百分比魔法回复":
      return 获取玩家属性(unit, "百分比魔法回复");
    case "总魔法恢复":
      return 获取玩家属性(unit, "总魔法恢复");
    case "魔法消耗":
      return 获取玩家属性(unit, "魔法消耗");
    // 治疗
    case "技能治疗率":
      return 获取玩家属性(unit, "技能治疗率");
    case "受到的治疗率":
      return 获取玩家属性(unit, "受到的治疗率");
    // 吸血
    case "伤害吸血":
      return 获取玩家属性(unit, "伤害吸血");
    case "魔法伤害吸血":
      return 获取玩家属性(unit, "魔法伤害吸血");
    case "普攻伤害吸血":
      return 获取玩家属性(unit, "普攻伤害吸血");
    // 减伤
    case "伤害减少":
      return 获取玩家属性(unit, "伤害减少");
    case "伤害减少%":
      return 获取玩家属性(unit, "伤害减少%");
    // 控制
    case "眩晕抗性":
      return 获取玩家属性(unit, "眩晕抗性");
    case "冷却缩减":
      return 获取玩家属性(unit, "冷却缩减");
    // 召唤物
    case "召唤物伤害":
      return 获取玩家属性(unit, "召唤物伤害");
    case "召唤物抗性":
      return 获取玩家属性(unit, "召唤物抗性");
    // 经济
    case "金币获取率":
      return 获取玩家属性(unit, "金币获取率");
    case "经验获取率":
      return 获取玩家属性(unit, "经验获取率");
    // 元素伤害
    case "光属性伤害":
      return 获取玩家属性(unit, "光属性伤害");
    case "暗属性伤害":
      return 获取玩家属性(unit, "暗属性伤害");
    case "木属性伤害":
      return 获取玩家属性(unit, "木属性伤害");
    case "火属性伤害":
      return 获取玩家属性(unit, "火属性伤害");
    case "雷属性伤害":
      return 获取玩家属性(unit, "雷属性伤害");
    case "水属性伤害":
      return 获取玩家属性(unit, "水属性伤害");
    case "土属性伤害":
      return 获取玩家属性(unit, "土属性伤害");
    // 元素抗性
    case "光属性抗性":
      return 获取玩家属性(unit, "光属性抗性");
    case "暗属性抗性":
      return 获取玩家属性(unit, "暗属性抗性");
    case "木属性抗性":
      return 获取玩家属性(unit, "木属性抗性");
    case "火属性抗性":
      return 获取玩家属性(unit, "火属性抗性");
    case "雷属性抗性":
      return 获取玩家属性(unit, "雷属性抗性");
    case "水属性抗性":
      return 获取玩家属性(unit, "水属性抗性");
    case "土属性抗性":
      return 获取玩家属性(unit, "土属性抗性");
    // 其他
    case "蝼蚁专精":
      return 获取玩家属性(unit, "蝼蚁专精");
    default:
      return 0;
  }
}

/**
 * 解析倍率字符串，例如 "3" -> 3, "50%" -> 0.5
 */
export function 解析倍率(this: void, 倍率字符串: string): number {
  if (倍率字符串.indexOf("%") >= 0) {
    const 数值 = parseFloat(倍率字符串.replace("%", ""));
    return 数值 / 100;
  }
  return parseFloat(倍率字符串);
}

/**
 * 计算公式结果：属性值 × 倍率
 */
export function 计算公式伤害(this: void, unit: any, 属性: 属性类型, 倍率字符串: string): number {
  const 属性值 = 获取属性值(unit, 属性);
  const 倍率 = 解析倍率(倍率字符串);
  return 属性值 * 倍率;
}
