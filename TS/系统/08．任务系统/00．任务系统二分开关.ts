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

/**
 * 加载 `03．任务UI` + `registerHotkey`（及可选 `04．任务UI拆分` 整包）
 *
 * 二分测试（双开闪退排查，见 `系统/13．问题追踪/2026-09-11_双开JAPI闪退.md`）：
 * 本开关只控制"要不要进任务UI"，进去以后细分阶段由
 * `02．任务UI拆分/01．任务UI常量.ts` 的 `QUEST_UI_INIT_STAGE`（0–5）控制。
 * 每轮只动一个变量：要么动本开关，要么动 STAGE。
 */
export const ENABLE_QUEST_UI_MODULE = true;

