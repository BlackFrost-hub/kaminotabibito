/** @noSelfInFile */
/**
 * UI属性系统 - 常量与布局配置
 */

// ==================== 系统开关与基础配置 ====================

/** 是否启用UI属性系统 */
export const UI_ATTRIBUTE_SYSTEM_ENABLED = true;

/** 系统初始化延迟时间（秒），游戏开始后多久启动UI */
export const INIT_DELAY_SECONDS = 0.5;

/** UI刷新间隔（秒），越小刷新越频繁但性能消耗越大 */
export const REFRESH_INTERVAL_SECONDS = 0.5;

/** 最大显示玩家数量（显示前5个玩家） */
export const MAX_DISPLAY_PLAYERS = 5;

// ==================== 通用UI配置 ====================

/** 面板背景纹理路径 */
export const PANEL_TEXTURE = "UI\\wenbenkuang.blp";

/** 界面锚点类型：左下角 = 4 */
export const ABSOLUTE_POINT_BOTTOMLEFT = 4;

/** 鼠标进入事件ID */
export const FRAME_EVENT_MOUSE_ENTER = 2;

/** 鼠标离开事件ID */
export const FRAME_EVENT_MOUSE_LEAVE = 3;

// ==================== 快捷键配置 ====================

/** Tab键的键码 */
export const KEY_TAB = 9;

/** 按键按下状态 */
export const KEY_EVENT_DOWN = 1;

/** 按键抬起状态 */
export const KEY_EVENT_UP = 0;

/** F2-F6功能键的键码（用于跳转到对应玩家英雄） */
export const KEY_F = [113, 114, 115, 116, 117] as const;

// ==================== 伤害统计面板配置 ====================

/** 伤害统计的三列标题 */
export const DAMAGE_LABELS = ["对Boss伤害", "承受Boss伤害", "治疗队友"] as const;

/** 伤害统计三列的颜色代码 */
export const DAMAGE_COLORS = ["|cffff6600", "|cffffcc99", "|cffffffcc"] as const;

/** 伤害面板X坐标（屏幕左下角为原点，向右为X正方向） */
export const DAMAGE_PANEL_X = 0.6775;

/** 伤害面板Y坐标（屏幕左下角为原点，向上为Y正方向） */
export const DAMAGE_PANEL_Y = 0.3311028;

/** 伤害面板宽度 */
export const DAMAGE_PANEL_WIDTH = 0.2308336;

/** 伤害面板高度 */
export const DAMAGE_PANEL_HEIGHT = 0.19;

/** 伤害面板透明度（0-255，越大越不透明） */
export const DAMAGE_PANEL_ALPHA = 210;

/** 伤害面板标题行Y坐标 */
export const DAMAGE_TITLE_Y = 0.4091424;

/** 玩家头像X坐标 */
export const DAMAGE_ICON_X = 0.574792;

/** 玩家头像起始Y坐标 */
export const DAMAGE_ICON_Y = 0.382;

/** 玩家头像宽度 */
export const DAMAGE_ICON_WIDTH = 0.0187504;

/** 玩家头像高度 */
export const DAMAGE_ICON_HEIGHT = 0.026013;

/** 每行数据之间的垂直间距 */
export const DAMAGE_ROW_STEP = 0.028275;

/** 三列数值的X坐标位置 */
export const DAMAGE_VALUE_X = [0.62, 0.68, 0.74] as const;

// ==================== 英雄头像栏配置 ====================

/** 第一个英雄头像的X坐标 */
export const HERO_ICON_START_X = 0.064;

/** 英雄头像之间的水平间距 */
export const HERO_ICON_STEP_X = 0.027;

/** 英雄头像Y坐标 */
export const HERO_ICON_Y = 0.560415;

/** 英雄头像宽度 */
export const HERO_ICON_WIDTH = 0.023;

/** 英雄头像高度 */
export const HERO_ICON_HEIGHT = 0.023;

/** 快捷键提示（F2-F6）的Y坐标 */
export const HERO_KEY_Y = 0.540415;

/** 英雄头像按钮的点击区域大小 */
export const HERO_BUTTON_SIZE = 0.035;

// ==================== 属性详情面板配置 ====================

/** 属性详情框X坐标 */
export const DETAIL_BOX_X = 0.118;

/** 属性详情框Y坐标 */
export const DETAIL_BOX_Y = 0.4077288;

/** 属性详情框宽度 */
export const DETAIL_BOX_WIDTH = 0.20;

/** 属性详情框高度 */
export const DETAIL_BOX_HEIGHT = 0.35;

/** 属性行宽度 */
export const DETAIL_LINE_WIDTH = 0.0766664;

/** 属性行高度 */
export const DETAIL_LINE_HEIGHT = 0.0186618;

/** 属性详情字体大小 */
export const DETAIL_FONT_SIZE = 0.0105;

/** 第一行属性的起始Y坐标 */
export const DETAIL_START_Y = 0.5363808;

/** 每行属性之间的垂直间距 */
export const DETAIL_ROW_STEP = 0.020358;

/** 左列属性的X坐标 */
export const DETAIL_LEFT_X = 0.0758336;

/** 右列属性的X坐标 */
export const DETAIL_RIGHT_X = 0.1545832;

/**
 * 属性详情面板的行布局配置
 * 每行有两个属性（左右两列），共15行显示30个属性
 * 格式：{ x: 水平位置, y: 垂直位置 }
 */
export const DETAIL_LINE_LAYOUTS = [
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 0 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 0 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 1 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 1 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 2 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 2 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 3 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 3 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 4 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 4 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 5 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 5 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 6 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 6 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 7 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 7 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 8 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 8 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 9 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 9 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 10 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 10 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 11 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 11 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 12 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 12 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 13 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 13 },
  { x: DETAIL_LEFT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 14 },
  { x: DETAIL_RIGHT_X, y: DETAIL_START_Y - DETAIL_ROW_STEP * 14 },
] as const;
