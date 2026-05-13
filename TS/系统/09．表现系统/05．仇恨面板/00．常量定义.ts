/** @noSelfInFile */
/**
 * 仇恨面板 - 常量定义
 *
 * 定义仇恨面板的所有布局、样式、刷新参数。
 * 所有坐标基于 [0,1] 归一化屏幕空间，原点在左下角。
 */

// ===== 面板基础布局 =====
/** 面板左下角 X 坐标 */
export const THREAT_PANEL_X = 0.6260;
/** 面板左下角 Y 坐标 */
export const THREAT_PANEL_Y = 0.2802;
/** 面板宽度 */
export const THREAT_PANEL_WIDTH = 0.2940;
/** 面板高度 */
export const THREAT_PANEL_HEIGHT = 0.1880;
/** 支持的玩家槽位数（4人局） */
export const THREAT_PANEL_PLAYER_SLOTS = 4;
/** 单位所有者玩家 ID 上限（超过此值视为怪物） */
export const THREAT_PANEL_PLAYER_UNIT_MAX_PID = 3;
/** 每个面板显示的仇恨行数 */
export const THREAT_PANEL_ROW_COUNT = 6;
/** 面板刷新间隔（毫秒） */
export const THREAT_PANEL_REFRESH_MS = 80;

// ===== 资源路径 =====
/** FDF TOC 文件路径 */
export const THREAT_PANEL_TOC_PATH = "ui\\BuffTestTooltip.toc";
/** FDF 面板模板名称 */
export const THREAT_PANEL_FDF_FRAME = "ThreatUiResearchPanelFrame";
/** 面板背景纹理 */
export const THREAT_PANEL_BG_TEXTURE = "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp";
/** 面板整体透明度 */
export const THREAT_PANEL_ALPHA = 255;
/** 面板层级优先级 */
export const THREAT_PANEL_PRIORITY = 200;

// ===== 标题样式 =====
/** 标题文本 */
export const THREAT_PANEL_TITLE = "仇恨面板（V）";
/** 标题字体 */
export const THREAT_PANEL_TITLE_FONT = "UI\\uizt.ttf";
/** 标题字号 */
export const THREAT_PANEL_TITLE_SIZE = 0.0105;
/** 标题 X 偏移（相对面板左下角） */
export const THREAT_PANEL_TITLE_OFFSET_X = 0.0080;
/** 标题 Y 偏移（相对面板左下角） */
export const THREAT_PANEL_TITLE_OFFSET_Y = 0.1600;

// ===== 正文样式 =====
/** 正文字体 */
export const THREAT_PANEL_BODY_FONT = "UI\\uizt.ttf";
/** 正文字号 */
export const THREAT_PANEL_BODY_SIZE = 0.0083;
/** 正文内容 X 偏移 */
export const THREAT_PANEL_TEXT_OFFSET_X = 0.0120;

// ===== 内容垂直布局（从上到下） =====
/** "请选择敌方单位" 文本 Y 偏移 */
export const THREAT_PANEL_SELECTED_OFFSET_Y = 0.1390;
/** 仇恨池摘要行 Y 偏移 */
export const THREAT_PANEL_SUMMARY_OFFSET_Y = 0.1220;
/** 表头行（目标/占比/仇恨）Y 偏移 */
export const THREAT_PANEL_HEADER_OFFSET_Y = 0.1010;
/** 第一行数据 Y 偏移 */
export const THREAT_PANEL_ROW_START_OFFSET_Y = 0.0850;
/** 行间距 */
export const THREAT_PANEL_ROW_GAP = 0.0136;

// ===== 列宽与对齐 =====
/** 文本区域宽度 */
export const THREAT_PANEL_TEXT_WIDTH = 0.2660;
/** 标题区域宽度 */
export const THREAT_PANEL_TITLE_WIDTH = 0.2660;
/** 单行文本高度 */
export const THREAT_PANEL_TEXT_HEIGHT = 0.0110;
/** "目标"列 X 偏移 */
export const THREAT_PANEL_NAME_COL_X = 0.0105;
/** "目标"列宽度 */
export const THREAT_PANEL_NAME_COL_WIDTH = 0.1280;
/** "占比"列 X 偏移 */
export const THREAT_PANEL_PERCENT_COL_X = 0.070;
/** "占比"列宽度 */
export const THREAT_PANEL_PERCENT_COL_WIDTH = 0.0340;
/** "仇恨"列 X 偏移 */
export const THREAT_PANEL_THREAT_COL_X = 0.13;
/** "仇恨"列宽度 */
export const THREAT_PANEL_THREAT_COL_WIDTH = 0.0400;

// ===== 内部背景面板 =====
/** 内部背景 X 偏移 */
export const THREAT_PANEL_INNER_OFFSET_X = 0.0100;
/** 内部背景 Y 偏移 */
export const THREAT_PANEL_INNER_OFFSET_Y = 0.0120;
/** 内部背景宽度 */
export const THREAT_PANEL_INNER_WIDTH = 0.2700;
/** 内部背景高度 */
export const THREAT_PANEL_INNER_HEIGHT = 0.1100;
/** 内部背景透明度 */
export const THREAT_PANEL_INNER_ALPHA = 235;
