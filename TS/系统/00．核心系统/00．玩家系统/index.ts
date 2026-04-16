/**
 * 玩家系统 - 统一初始化入口
 */

// 绝对路径 require：Lua 运行时不支持相对路径 ./ 的解析
const mgr = require("系统.00．核心系统.00．玩家系统.01．玩家单位管理器") as {
  initPlayerUnitManager?: () => void;
};

if (typeof mgr.initPlayerUnitManager === "function") {
  mgr.initPlayerUnitManager();
}

export {};

