/**
 * 玩家单位管理器 — 对外门面
 * 职责：保持原require路径不变，统一导出初始化入口
 * 实现分散在：00．常量.ts / 02．基础核心.ts / 00．英雄注册联动/
 */

const core = require("系统.00．核心系统.00．玩家系统.02．基础核心") as {
  initPlayerUnitManager: () => void;
};

export const initPlayerUnitManager = core.initPlayerUnitManager;

export {};
