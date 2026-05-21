/**
 * 玩家系统 - 统一入口
 *
 * 保留系统入口的自动初始化，同时导出明确的初始化函数，
 * 让这个文件既能作为 side-effect 入口，也能作为普通 TS 模块使用。
 */
export * from "./00．常量";
export * from "./01．玩家单位管理器";
const manager = require("系统.00．核心系统.00．玩家系统.01．玩家单位管理器");
export const initPlayerSystem = manager.initPlayerUnitManager;
export const initPlayerUnitManager = manager.initPlayerUnitManager;
initPlayerSystem();
