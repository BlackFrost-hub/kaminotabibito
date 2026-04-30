/** @noSelfInFile */
/**
 * 任务系统 - 二分开关配置
 *
 * `10．index` 只应依赖本文件做分支，避免各处散落注释开关。
 */

/** 加载 `00．配置表`（对话/任务/NPC/主线表等）。关则 `10．index` 不 require 配置表入口。 */
export const ENABLE_QUEST_CONFIG_TABLE = true;

/**
 * 加载 `01．任务数据` + `02．任务管理器` 并执行 `questManager.init`。
 * 关则仅保留配置表（若上项为 true），无运行时任务数据/管理器——NPC 对话里依赖 questManager 的逻辑会不可用。
 */
export const ENABLE_QUEST_RUNTIME_CORE = true;

/** 加载 `03．任务UI` + `registerHotkey`（及可选 `04．任务UI拆分` 整包） */
export const ENABLE_QUEST_UI_MODULE = true;

/** 加载 `09．主线配置驱动` */
export const ENABLE_QUEST_MAINLINE_DRIVER = false;
