/** N 槽：最大玩家数（与对话框系统一致） */
export const MAX_PLAYERS = 4;
/** N 槽：DzCreateFrame contextId 偏移基数，每槽位占 1000 个 ID 空间 */
export const TAG_SLOT_OFFSET = 1000;

export const TASK_UI_TOC_PATHS = ["UI\\TaskUI.toc"];
export const TASK_UI_TOC_LOAD_KEY = "TaskUI";

/** 二分开关：关则任务UI客户端不初始化 */
export const ENABLE_TASK_UI_CLIENT = true;

export const ENABLE_FDF_A = true;
export const ENABLE_FDF_B = true;
export const ENABLE_FDF_SCROLLBAR = true;
export const ENABLE_FDF_SCROLLBAR_BORDER = true;
export const ENABLE_FDF_SCROLLBAR_THUMB = true;
export const ENABLE_MOUSE_WHEEL_SCROLL = true;

/** 每分类预设最大页数（用于固定次数遍历隐藏，不依赖 pages.length） */
export const MAX_PAGES_PER_CATEGORY = 50;

/** 二分开关：关则主面板不创建右侧滚动轨道/滑块/拖拽命中 */
export const ENABLE_TASK_UI_RIGHT_SCROLLBAR = true;

export const ENTRY_W = 0.059 * 1.3;
export const ENTRY_H = 0.0156 * 1.4;
export const ENTRY_X = 0.005;
export const ENTRY_Y = 0.60;
export const ENTRY_TITLE_TEXT_BOX_W = 0.82;
export const ENTRY_TITLE_TEXT_BOX_H = 0.46;
export const PANEL_W = 0.35;
export const PANEL_H = 0.5;

export const TAB_FRAME_W = 0.04;
export const TAB_FRAME_H = 0.035;
export const TAB_CATEGORY_FONT_SCALE = 0.012;
export const LIST_ITEM_H = 0.12;
export const BG_TEX = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-background.blp";

export const PANEL_TOP = 0.46;
export const PANEL_TOP_UP = 0.015;
export const LEGACY_ENTRY_X_REF = 0.06;
export const LEGACY_ENTRY_Y_REF = 0.51;
export const LEGACY_PANEL_TOP_Y = PANEL_TOP + PANEL_TOP_UP;
export const LEGACY_LIST_TOP = 0.41 + PANEL_TOP_UP - 0.04;
export const PANEL_TOPLEFT_OFF_X = 0;
export const PANEL_TOPLEFT_OFF_Y = LEGACY_PANEL_TOP_Y - LEGACY_ENTRY_Y_REF;
export const PANEL_EXPANDED_UP = 0.015;
export const PANEL_REL_TO_ENTRY_X = PANEL_TOPLEFT_OFF_X;
export const PANEL_REL_TO_ENTRY_Y = PANEL_TOPLEFT_OFF_Y + PANEL_EXPANDED_UP;
export const LIST_FIRST_ROW_REL_Y = LEGACY_LIST_TOP - LEGACY_PANEL_TOP_Y;
export const LIST_ROW_LEFT_REL_X = 0.09 - LEGACY_ENTRY_X_REF - 0.01;
export const TAB_Y = 0.44;
export const TAB_REL_Y = TAB_Y - PANEL_TOP;
export const COLLAPSED_ROW_PITCH = LIST_ITEM_H * 0.4 + 0.01;
export const LIST_VIEW_TARGET_ROWS = 7;
export const LIST_VIEW_H = COLLAPSED_ROW_PITCH * LIST_VIEW_TARGET_ROWS + 0.012;
export const SCROLLBAR_BOTTOM_INSET = 0.03;
export const SCROLLBAR_TOP_INSET = PANEL_H - LIST_VIEW_H - SCROLLBAR_BOTTOM_INSET;
export const LIST_CONTAINER_REL_TO_PANEL_X = 0.015;
export const LIST_CONTAINER_REL_TO_PANEL_Y = -0.1;
export const LIST_CONTENT_LEFT_INSET = LIST_ROW_LEFT_REL_X - LIST_CONTAINER_REL_TO_PANEL_X;
export const LIST_CONTENT_TOP_INSET = LIST_FIRST_ROW_REL_Y - LIST_CONTAINER_REL_TO_PANEL_Y + 0.025;
export const LIST_CONTAINER_W = 0.32;
export const SCROLLBAR_W = 0.015;
export const SCROLLBAR_REL_X = -0.006 - 0.005 - 0.004;
export const SCROLL_THUMB_SIZE = 0.02;
export const SCROLL_THUMB_TOP_COMPENSATION = 0;
export const SCROLL_THUMB_BOTTOM_COMPENSATION = 0;
export const THUMB_DRAG_TICK = 0.03;
export const THUMB_DRAG_SENSITIVITY = 1;

export const QUEST_ROW_ICON_HEIGHT_FACTOR = 0.84;
export const QUEST_ROW_ICON_PAD_LEFT = 0.003;
export const QUEST_ROW_TEXT_GAP_AFTER_ICON = 0.006;
export const QUEST_ROW_ICON_Y_OFFSET = 0.004;
