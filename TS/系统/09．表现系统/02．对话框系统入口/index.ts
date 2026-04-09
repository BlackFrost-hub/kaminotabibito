// ========== 虚拟分区：模块导出 ==========
export * from "./01．常量与工具";
export * from "./02．任务状态";
export * from "./03．配置查询";
export * from "./04．对话构建";
export * from "./05．选择触发入口";

// ========== 虚拟分区：自动初始化 ==========
import { initDialogEntrySelectionTrigger } from "./05．选择触发入口";
initDialogEntrySelectionTrigger();

