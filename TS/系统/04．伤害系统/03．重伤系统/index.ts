/** @noSelfInFile */
/**
 * 重伤系统 - 初始化入口
 *
 * 技能侧如需功能，请直接依赖 `01．核心功能`，不要通过这里的总 index 走导出聚合。
 */

let 重伤系统已初始化 = false;

export function init(this: void): void {
  if (重伤系统已初始化) return;
  重伤系统已初始化 = true;

  const { initWoundSystem } = require("系统.04．伤害系统.03．重伤系统.01．核心功能") as {
    initWoundSystem: (this: void) => void;
  };
  initWoundSystem();
}

export {};
