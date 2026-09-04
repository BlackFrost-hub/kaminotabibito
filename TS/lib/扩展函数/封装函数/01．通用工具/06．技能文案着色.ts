/** @noSelfInFile */
/**
 * 技能文案着色工厂
 *
 * 为技能 tooltip 提供统一的魔兽颜色码语义标记，替代整段纯白文案。
 * 所有英雄技能说明统一走这里生成颜色码，保证风格一致；未来新英雄直接复用。
 * 详细规则见 .cursor/rules/gameplay/skills/技能文案着色与二段说明规范.mdc
 *
 * 颜色规划（结构色 + 伤害类型色）：
 * 【结构色】
 * - 段落标题（技能说明/伤害/二段/强化X 等）：金黄 ffdc32
 * - 机制行标签（施法距离/冷却时间/魔法消耗/护盾/减速 等）：青绿 00ff99
 * - 关键数值（百分比、秒数、距离、半径）：淡蓝 87ceeb
 * - 正文：白色（不包色码，默认白）
 * 【伤害类型色】修饰"XX魔法伤害/物理伤害"中的伤害类型词，让玩家一眼分辨属性：
 * - 冰魔法伤害：冰蓝 66ccff；水魔法伤害：水蓝 3399ff
 * - 火魔法伤害：火红 ff5533；暗魔法伤害：暗紫 aa66ff
 * - 光魔法伤害：金色 ffd700；雷魔法伤害：电紫 b388ff
 * - 物理伤害：棕 b8860b；精神伤害（=真实伤害）：白 ffffff；强化伤害（符号强化/破防类）：橙 ff9900
 * - 毒：绿 66ff66；风/自然：浅绿 99ff66
 */

/** 段落标题色（金黄） */
const 标题色 = "|cffffcc00";
/** 机制行标签色（青绿） */
const 机制色 = "|cff00ff99";
/** 数值高亮色（淡蓝） */
const 数值色 = "|cff87ceeb";
/** 颜色复位 */
const 复位 = "|r";

/** 伤害类型 → 颜色码。新增伤害类型时在此登记，技能文案用 伤害() 引用。 */
const 伤害类型色表: Record<string, string> = {
  冰: "|cff66ccff",
  水: "|cff3399ff",
  火: "|cffff5533",
  暗: "|cffaa66ff",
  暗影: "|cffaa66ff",
  光: "|cffffd700",
  雷: "|cffb388ff",
  电: "|cffb388ff",
  强化: "|cffff9900",
  精神: "|cffffffff",
  物理: "|cffb8860b",
  普通: "|cffb8860b",
  魔法: "|cffc0c0ff",
  自然: "|cff99ff66",
  毒: "|cff66ff66",
};

/** 段落标题：如 标题("技能说明") → 金黄「技能说明：」 */
export function 标题(this: void, 文本: string): string {
  return 标题色 + 文本 + "：" + 复位;
}

/** 机制行标签：如 机制("冷却时间", 值) → 青绿标签 + 白色值 */
export function 机制(this: void, 文本: string, 值?: string): string {
  return 机制色 + 文本 + "：" + 复位 + (值 != null ? 值 : "");
}

/** 数值高亮：如 数值("120%") → 淡蓝数值，正文保持白色 */
export function 数值(this: void, 文本: string): string {
  return 数值色 + 文本 + 复位;
}

/**
 * 伤害类型着色：如 伤害("冰魔法伤害") → 按伤害类型色表上色整段伤害词。
 * 取开头连续的属性字查表（如「冰魔法伤害」→ 冰）；未登记的类型回落淡蓝。
 */
export function 伤害(this: void, 类型文本: string): string {
  let 类型键 = "";
  const 表键列表 = Object.keys(伤害类型色表);
  for (let i = 0; i < 表键列表.length; i++) {
    if (类型文本.indexOf(表键列表[i]) === 0 && 表键列表[i].length > 类型键.length) {
      类型键 = 表键列表[i];
    }
  }
  const 色 = 类型键 !== "" ? 伤害类型色表[类型键] : "|cff87ceeb";
  return 色 + 类型文本 + 复位;
}

/**
 * 二段机制标准段落（一段 tooltip 用）：说明「再次施放会发生什么、不操作会怎样」。
 * 例： 二段("再次按 W", "提前引爆造成攻击力" + 数值("120%") + "的魔法伤害", "自然结束（伤害降为攻击力90%）")
 */
export function 二段(this: void, 操作: string, 触发效果: string, 不操作后果?: string): string {
  let result = 标题("二段") + "再次" + 操作 + "，" + 触发效果;
  if (不操作后果 != null && 不操作后果 !== "") {
    result += "；" + 机制色 + "不做任何操作" + 复位 + "则" + 不操作后果 + "。";
  } else {
    result += "。";
  }
  return result;
}

/**
 * 二段窗口内按钮实例说明的标题行（限时二段技能壳的 二段说明 用）：
 * 首行统一格式，后续由调用方拼 伤害/机制 行。
 */
export function 二段壳标题(this: void, 技能名: string, 热键: string): string {
  return 标题("技能说明") + "二段窗口：再次按 " + 热键 + " 触发「" + 技能名 + "」。|n";
}

export {};
