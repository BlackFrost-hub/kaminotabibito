/** @noSelfInFile */
/**
 * 治疗系统 - 常量定义
 *
 * 后续接手者：修改开关、特效路径、颜色请在此文件
 */

// ==========================================================================================
// 系统开关
// ==========================================================================================

/**
 * 治疗系统总开关
 * true: 启用，false: 禁用（doHeal直接返回0）
 */
export const HEAL_SYSTEM_ENABLED = true;

// ==========================================================================================
// 事件常量
// ==========================================================================================

/** STES 事件名称（必须与JASS端一致） */
export const HEAL_EVENTS = {
  /** 治疗入口事件 */
  REQUEST: "治疗事件",
  /** 任意单位被治疗事件 */
  HEAL: "任意单位被治疗",
} as const;

/** STES「治疗事件」入口参数键名 */
export const HEAL_REQUEST_KEYS = {
  AMOUNT: "HealAmount",
  MANA_AMOUNT: "HealManaAmount",
  TARGET: "HealTarget",
  SOURCE: "HealSource",
  SOURCE_PLAYER: "HealSourcePlayer",
  EFFECT: "HealEffect",
  MANA_EFFECT: "ManaEffect",
} as const;

/** STES「任意单位被治疗」结果事件参数键名 */
export const HEAL_RESULT_KEYS = {
  AMOUNT: "HealAmount",
  TARGET: "HealUnit",
  SOURCE: "HealSource",
} as const;

/** 治疗统计与旧 JASS 对齐用到的键名 */
export const HEAL_STATS_KEYS = {
  PLAYER_TOTAL_HEAL: "治疗量",
  PLAYER_GROUP_TABLE: "玩家",
  PLAYER_GROUP_FORCE: "玩家组",
  BOSS_BATTLE_TABLE: "Boss战",
  BOSS_BATTLE_UNIT: "单位",
} as const;

// ==========================================================================================
// 默认配置
// ==========================================================================================

/** 默认治疗特效路径 */
export const DEFAULT_HEAL_EFFECT_PATH = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl";

/** 默认魔法恢复特效路径 */
export const DEFAULT_MANA_HEAL_EFFECT_PATH = "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl";

/** 治疗漂浮文字颜色 RGB */
export const HEAL_TEXT_COLOR = {
  red: 80,
  green: 255,
  blue: 80,
} as const;

/** 魔法恢复漂浮文字颜色 RGB */
export const MANA_TEXT_COLOR = {
  red: 53,
  green: 80,
  blue: 92,
} as const;

// ==========================================================================================
// 属性名常量
// ==========================================================================================

/** 治疗率属性名（治疗别人时生效，如0.2=+20%） */
export const ATTR_HEAL_RATE = "治疗率";

/** 玩家技能治疗率属性名（装备、英雄成长等全局来源，如0.2=+20%） */
export const ATTR_SKILL_HEAL_RATE = "技能治疗率";

/** 受到治疗率属性名（被治疗时生效，如0.1=+10%） */
export const ATTR_RECEIVED_HEAL_RATE = "受到的治疗率";

export {};
/** @noSelfInFile */
