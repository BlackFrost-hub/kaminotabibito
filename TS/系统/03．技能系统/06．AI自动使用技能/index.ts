/**
 * AI自动使用技能系统 - 统一导出和初始化入口
 *
 * 功能：
 * 1. 为AI单位注册可自动使用的技能
 * 2. 支持取消注册（单位死亡时自动清理）
 * 3. 定时检测并自动施放技能
 * 4. 支持技能优先级排序
 * 5. 支持多种目标类型（无目标、点目标、单位目标）
 */

// 导出常量
export * from "./00．常量定义";

// 导出核心功能
export * from "./01．核心功能";

// 导入初始化函数
import { initAISkillSystem, isSystemEnabled } from "./01．核心功能";

/**
 * 初始化AI自动使用技能系统
 */
export function init(): void {
  initAISkillSystem();
}

/**
 * 检查系统是否启用
 */
export function isEnabled(): boolean {
  return isSystemEnabled();
}

// 自动初始化（可选）
// init();
