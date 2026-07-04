/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 启用装备调试日志 = false;
const 启用主动物品调试日志 = false;

export function 装备调试日志(this: void, module: string, ...args: any[]): void {
  if (!启用装备调试日志) return;
  debugLogForce(module, ...args);
}

export function 主动物品调试日志(this: void, module: string, ...args: any[]): void {
  if (!启用主动物品调试日志) return;
  debugLogForce(module, ...args);
}

export {};
