/**
 * 重伤系统 - 统一导出和初始化入口
 */

export * from "./00．常量定义";
export * from "./01．核心功能";

/**
 * 初始化重伤系统
 */
export function init(): void {
  const { initWoundSystem } = require("系统.04．伤害系统.03．重伤系统.01．核心功能") as {
    initWoundSystem: () => void;
  };
  initWoundSystem();
}
