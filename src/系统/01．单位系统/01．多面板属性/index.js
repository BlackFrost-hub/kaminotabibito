/**
 * 多面板属性系统 - 统一导出和初始化入口
 */
export * from "./00．常量定义";
export * from "./01．核心功能";
import { initMultiboardSystem } from "./01．核心功能";
/**
 * 初始化多面板属性系统
 */
export function init() {
    initMultiboardSystem();
}
