/**
 * 单位系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./00．单位初始化创建/index";
export * from "./01．多面板属性/index";
export * from "./02．恢复系统/index";
export * from "./03．怪物刷新系统/index";
export * from "./04．多杀检测系统/index";

// ========== 核心模块导出 ==========
export * from "./05．单位狂暴/index";
export * from "./06．仇恨系统/index";
export * from "./07．异界Boss/index";
export * from "./08．单位配置表/index";
export * from "./09．科技配置表/index";

/**
 * 初始化单位系统
 * 各子系统已在各自 index.ts 中自动初始化
 */
export function init(): void {
}
