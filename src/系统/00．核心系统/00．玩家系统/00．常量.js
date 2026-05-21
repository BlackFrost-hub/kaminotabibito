/**
 * 玩家单位管理器 — 常量
 * 职责：移速阈值、特效模型路径、轮询节奏、YDUserData表键
 */
/** 移速阈值：超过该值时挂载龙卷提示特效 */
export const MOVE_SPEED_THRESHOLD = 400;
/** 龙卷提示模型（与地图资源路径一致） */
export const TORNADO_EFFECT_MODEL = "Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl";
/** 绑定挂点 */
export const TORNADO_ATTACH_POINT = "origin";
/**
 * 中心计时器 tick 为 10ms；每 N 次 tick 执行一轮同步（默认 5 => 0.05s）
 */
export const EXEC_EVERY_TICKS = 5;
/** STES：玩家英雄注册 */
export const STES_EVENT_REGISTER_PLAYER_HERO = "玩家英雄注册";
export const STES_PARAM_HERO_UNIT = "英雄";
/** 玩家 YDUserData 属性 */
export const YD_ATTR_PLAYER_HERO_UNIT = "英雄";
