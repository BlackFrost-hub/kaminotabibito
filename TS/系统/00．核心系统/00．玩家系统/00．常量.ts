/**
 * 玩家单位管理器 — 常量（阈值、资源路径、轮询节奏等）
 */

/** 移速超过该值时挂上龙卷提示特效 */
export const MOVE_SPEED_THRESHOLD = 400;

/** 龙卷提示模型（与地图资源路径一致） */
export const TORNADO_EFFECT_MODEL = "Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl";

/** 绑定挂点 */
export const TORNADO_ATTACH_POINT = "origin";

/**
 * 中心计时器 tick 为 10ms；每 N 次 tick 执行一轮同步（默认 5 => 0.05s）
 */
export const EXEC_EVERY_TICKS = 5;

/** YDUserData：玩家英雄单位组（与 JASS 初始化一致） */
export const YD_TABLE_TYPE_PLAYER_HERO = "string";
export const YD_TABLE_KEY_PLAYER_HERO = "玩家英雄";
export const YD_ATTR_HERO_GROUP = "单位组";
export const YD_VALUE_TYPE_GROUP = "group";
