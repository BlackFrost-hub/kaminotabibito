/**
 * DOT定义 - 统一导出和初始化入口
 *
 * 按依赖顺序加载：配置 → 解析 → 类型定义/工具 → 状态同步/执行器/施加策略/基础工具
 */

// ========== 子模块导出 ==========
export * from "./01．DOT配置";
export * from "./02．DOT解析";
export * from "./03．DOT类型定义";
export * from "./04．DOT工具";
export * from "./05．DOT状态同步";
export * from "./06．DOT执行器";
export * from "./07．DOT施加策略";
export * from "./08．DOT基础工具";

// ========== 初始化 ==========
require("系统.04．伤害系统.02．DOT定义.01．DOT配置");
require("系统.04．伤害系统.02．DOT定义.02．DOT解析");
require("系统.04．伤害系统.02．DOT定义.03．DOT类型定义");
require("系统.04．伤害系统.02．DOT定义.04．DOT工具");
require("系统.04．伤害系统.02．DOT定义.05．DOT状态同步");
require("系统.04．伤害系统.02．DOT定义.06．DOT执行器");
require("系统.04．伤害系统.02．DOT定义.07．DOT施加策略");
require("系统.04．伤害系统.02．DOT定义.08．DOT基础工具");

/**
 * 初始化DOT定义模块
 */
export function init(): void {
}
