/** @noSelfInFile */

const QWERD显示开关模块 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关") as {
  初始化QWERD显示开关: (this: void) => void;
};
const 自杀命令模块 = require("系统.00．核心系统.02．功能开关.02．英雄自杀系统") as {
  初始化自杀命令: (this: void) => void;
};
const 游戏难度选择模块 = require("系统.00．核心系统.02．功能开关.03．游戏难度选择.index") as {
  初始化游戏难度选择: (this: void) => void;
};
const 控制台开关模块 = require("系统.00．核心系统.02．功能开关.03．控制台开关") as {
  初始化控制台开关: (this: void) => void;
};

let 功能开关已初始化 = false;

export function 初始化功能开关(this: void): void {
  if (功能开关已初始化) return;
  功能开关已初始化 = true;
  QWERD显示开关模块.初始化QWERD显示开关();
  自杀命令模块.初始化自杀命令();
  游戏难度选择模块.初始化游戏难度选择();
  控制台开关模块.初始化控制台开关();
}

初始化功能开关();

export {};
