/**
 * 动态技能说明系统 - 统一导出和初始化入口
 */

// 导出常量
export * from "./00．常量定义";

// 导出公式解析器
export * from "./02．公式解析器";

// 导出核心功能
export * from "./01．核心功能";

// 导入初始化函数
import { initDynamicSkillTipSystem } from "./01．核心功能";

/**
 * 初始化动态技能说明系统
 */
export function init(): void {
  initDynamicSkillTipSystem();
}
