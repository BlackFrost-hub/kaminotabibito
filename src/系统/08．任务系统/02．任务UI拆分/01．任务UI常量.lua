--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- N 槽：最大玩家数（与对话框系统一致）
____exports.MAX_PLAYERS = 5
--- N 槽：DzCreateFrame contextId 偏移基数，每槽位占 1000 个 ID 空间
____exports.TAG_SLOT_OFFSET = 1000
____exports.TASK_UI_TOC_PATHS = {"UI\\TaskUI.toc"}
____exports.TASK_UI_TOC_LOAD_KEY = "TaskUI"
--- 二分开关：关则任务UI客户端不初始化
____exports.ENABLE_TASK_UI_CLIENT = true
____exports.ENABLE_FDF_A = true
____exports.ENABLE_FDF_B = true
____exports.ENABLE_FDF_SCROLLBAR = true
____exports.ENABLE_FDF_SCROLLBAR_BORDER = true
____exports.ENABLE_FDF_SCROLLBAR_THUMB = true
____exports.ENABLE_MOUSE_WHEEL_SCROLL = true
--- 历史兼容配置。任务页现在按实际任务数据动态创建，不再按此值预创建空页。
____exports.MAX_PAGES_PER_CATEGORY = 35
--- 二分开关：关则任务UI主面板不创建右侧滚动轨道/滑块/拖拽命中
____exports.ENABLE_TASK_UI_RIGHT_SCROLLBAR = true
--- 二分开关：滚动轨道点击跳页（帧事件 ID 1，挂轨道命中帧，`sync=false`）。
-- 历史：拖拽滑块曾依赖全局鼠标注册（`sync=false`/`sync=true` 双开均卡死，2026-09-12 实测），
-- 已移除全局注册；滚轮改用帧事件 ID 6（同一文件 `registerTaskUIListWheel`）。
____exports.ENABLE_TASK_UI_TRACK_CLICK = true
--- 任务UI 初始化阶段上限（二分主开关，见 `00．任务系统二分开关.ts` 的 ENABLE_QUEST_UI_MODULE）：
--  0 = 完全不初始化（等同关闭整块）
--  1 = 仅入口图标（05）
--  2 = + 主面板与滚动条（07，含 FDF 帧创建）
--  3 = + 动态列表页创建与首次数据填充（12/14/08）
--  4 = 与3相同；硬件输入始终在面板首次打开后注册，禁止恢复加载期注册
--  5 = + 页面刷新回调（08/13，完整初始化）
-- 每档都是合法前缀，可独立运行；改动后必须 Run Map 重打包再双开测试。
____exports.QUEST_UI_INIT_STAGE = 3
____exports.ENTRY_W = 0.088
____exports.ENTRY_H = 0.0227
____exports.ENTRY_X = 0
____exports.ENTRY_Y = 0.599
____exports.ENTRY_TITLE_TEXT_BOX_W = 0.82
____exports.ENTRY_TITLE_TEXT_BOX_H = 0.46
____exports.PANEL_W = 0.35
____exports.PANEL_H = 0.5
____exports.TAB_FRAME_W = 0.04
____exports.TAB_FRAME_H = 0.035
____exports.TAB_CATEGORY_FONT_SCALE = 0.012
____exports.LIST_ITEM_H = 0.12
____exports.BG_TEX = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-background.blp"
____exports.PANEL_TOP = 0.46
____exports.PANEL_TOP_UP = 0.015
____exports.LEGACY_ENTRY_X_REF = 0.06
____exports.LEGACY_ENTRY_Y_REF = 0.51
____exports.LEGACY_PANEL_TOP_Y = ____exports.PANEL_TOP + ____exports.PANEL_TOP_UP
____exports.LEGACY_LIST_TOP = 0.41 + ____exports.PANEL_TOP_UP - 0.04
____exports.PANEL_TOPLEFT_OFF_X = 0
____exports.PANEL_TOPLEFT_OFF_Y = ____exports.LEGACY_PANEL_TOP_Y - ____exports.LEGACY_ENTRY_Y_REF
____exports.PANEL_EXPANDED_UP = 0.015
____exports.PANEL_REL_TO_ENTRY_X = ____exports.PANEL_TOPLEFT_OFF_X
____exports.PANEL_REL_TO_ENTRY_Y = ____exports.PANEL_TOPLEFT_OFF_Y + ____exports.PANEL_EXPANDED_UP
____exports.LIST_FIRST_ROW_REL_Y = ____exports.LEGACY_LIST_TOP - ____exports.LEGACY_PANEL_TOP_Y
____exports.LIST_ROW_LEFT_REL_X = 0.09 - ____exports.LEGACY_ENTRY_X_REF - 0.01
____exports.TAB_Y = 0.44
____exports.TAB_REL_Y = ____exports.TAB_Y - ____exports.PANEL_TOP
____exports.COLLAPSED_ROW_PITCH = ____exports.LIST_ITEM_H * 0.4 + 0.01
____exports.LIST_VIEW_TARGET_ROWS = 7
____exports.LIST_VIEW_H = ____exports.COLLAPSED_ROW_PITCH * ____exports.LIST_VIEW_TARGET_ROWS + 0.012
____exports.SCROLLBAR_BOTTOM_INSET = 0.03
____exports.SCROLLBAR_TOP_INSET = ____exports.PANEL_H - ____exports.LIST_VIEW_H - ____exports.SCROLLBAR_BOTTOM_INSET
____exports.LIST_CONTAINER_REL_TO_PANEL_X = 0.015
____exports.LIST_CONTAINER_REL_TO_PANEL_Y = -0.1
____exports.LIST_CONTENT_LEFT_INSET = ____exports.LIST_ROW_LEFT_REL_X - ____exports.LIST_CONTAINER_REL_TO_PANEL_X
____exports.LIST_CONTENT_TOP_INSET = ____exports.LIST_FIRST_ROW_REL_Y - ____exports.LIST_CONTAINER_REL_TO_PANEL_Y + 0.025
____exports.LIST_CONTAINER_W = 0.32
____exports.SCROLLBAR_W = 0.015
____exports.SCROLLBAR_REL_X = -0.006 - 0.005 - 0.004
____exports.SCROLL_THUMB_SIZE = 0.02
____exports.SCROLL_THUMB_TOP_COMPENSATION = 0
____exports.SCROLL_THUMB_BOTTOM_COMPENSATION = 0
____exports.QUEST_ROW_ICON_HEIGHT_FACTOR = 0.84
____exports.QUEST_ROW_ICON_PAD_LEFT = 0.003
____exports.QUEST_ROW_TEXT_GAP_AFTER_ICON = 0.006
____exports.QUEST_ROW_ICON_Y_OFFSET = 0.004
return ____exports
