/**
 * 任务管理器 — 对外唯一入口
 *
 * 使用方式：
 * - TypeScript：`import { questManager, … } from "./01．任务管理器/index"`
 * - Lua 侧：`require("系统.08．任务系统.01．任务管理器.index")`
 *
 * 子模块依赖（仅供阅读，不要绕过 index 直接依赖内部文件路径）：
 * - `04．QuestManager`：单例业务逻辑
 * - `05．事件桥接`：从 udg_* 读参并转调 `questManager`
 *
 * 导出说明：
 * - `QuestManager` / `questManager`：TS 代码里操作任务（接取、查询、注册 UI 回调等）
 * - `handleQuestAccepted` 等：给 JASS/触发器「执行自定义脚本」调用，无参，靠全局变量传参
 * - `init`：地图初始化时调用一次（与 `10．index` 中 require 配套）
 */
export { QuestManager, questManager } from "./04．QuestManager";
export { handleQuestAccepted, handleQuestCompleted, handleObjectiveUpdated, handleQuestFailed, handleQuestAbandoned, init, } from "./05．事件桥接";
