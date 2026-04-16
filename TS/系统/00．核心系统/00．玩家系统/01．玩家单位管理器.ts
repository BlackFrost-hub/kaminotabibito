/**
 * 玩家单位管理器 — 对外门面（保持原 require 路径不变）
 *
 * 实现已拆到：
 * - `00．常量.ts`
 * - `02．基础核心.ts`
 * - `03．移速龙卷特效.ts`
 */

const core = require("系统.00．核心系统.00．玩家系统.02．基础核心") as {
  initPlayerUnitManager: () => void;
};

export const initPlayerUnitManager = core.initPlayerUnitManager;

export {};
