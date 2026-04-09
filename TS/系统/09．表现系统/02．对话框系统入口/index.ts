// ========== 虚拟分区：导出 ==========
export * from "./01．常量与工具";
export * from "./02．任务状态";
export * from "./03．配置查询";
export * from "./04．对话构建";
export * from "./05．选择触发入口";
export * from "./06．任务奖励解析";
export * from "./07．任务提交流程";
export * from "./08．任务奖励执行";
export * from "./09．任务展示文案";

// ========== 虚拟分区：初始化 ==========
import { initDialogEntrySelectionTrigger } from "./05．选择触发入口";
initDialogEntrySelectionTrigger();

