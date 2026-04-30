/**
 * 任务UI拆分 - 统一导出和初始化入口
 *
 * 加载顺序说明：
 * - 常量先加载（无依赖）
 * - 辅助函数次之（依赖常量）
 * - 列表与滚动、热键
 * - 入口图标 → 分类标签 → 主面板与滚动（后者依赖前者）
 */

// ========== 虚拟分区：子模块统一导出与初始化 ==========
export * from "./01．任务UI常量";
export * from "./02．任务UI辅助";
export * from "./03．任务UI列表与滚动";
export * from "./04．任务UI热键";
export * from "./05．任务UI入口图标";
export * from "./06．任务UI分类标签";
export * from "./07．任务UI主面板与滚动";
// 注意：08 不在这里导出，因为它与 12 有命名冲突（createTaskUIPrecreatedListPool）
// 08 的函数通过 11 内部引用使用
export * from "./09．任务UI滚动与滚轮";
export * from "./10．任务UI列表控制辅助";
export * from "./11．任务UI管理器";
export * from "./12．任务UI预设构建";
export * from "./13．任务UI本地显示";
export * from "./14．任务UI列表帧构建";

/**
 * 初始化任务UI拆分模块
 */
export function init(): void {
}
