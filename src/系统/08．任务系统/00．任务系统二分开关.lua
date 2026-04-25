--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 加载 `00．配置表`（对话/任务/NPC/主线表等）。关则 `10．index` 不 require 配置表入口。
____exports.ENABLE_QUEST_CONFIG_TABLE = true
--- 加载 `01．任务数据` + `02．任务管理器` 并执行 `questManager.init`。
-- 关则仅保留配置表（若上项为 true），无运行时任务数据/管理器——NPC 对话里依赖 questManager 的逻辑会不可用。
____exports.ENABLE_QUEST_RUNTIME_CORE = true
--- 加载 `03．任务UI` + `registerHotkey`（及可选 `04．任务UI拆分` 整包）
____exports.ENABLE_QUEST_UI_MODULE = true
--- 加载 `09．主线配置驱动`
____exports.ENABLE_QUEST_MAINLINE_DRIVER = false
--- 加载 `07．任务事件桥接`
____exports.ENABLE_QUEST_EVENT_BRIDGE = false
--- 是否启用任务STES目标桥接（`05`/`06` 配套）
____exports.ENABLE_QUEST_STES_OBJECTIVE_BRIDGE = false
--- 是否启用任务STES接受/完成桥接
____exports.ENABLE_QUEST_STES_ACCEPT_COMPLETE_BRIDGE = false
--- 加载 `08．任务目标更新` 并在其模块内执行 init
____exports.ENABLE_QUEST_OBJECTIVE_UPDATE_EVENT = false
return ____exports
