/** @noSelfInFile */

export * from "./01．物品提示UI";
export * from "./02．物品提示读取缓存";
export * from "./03．物品提示内容";
export * from "./04．物品栏提示劫持";

const 物品栏提示劫持 = require("系统.09．表现系统.12．物品提示模拟.04．物品栏提示劫持") as {
  初始化物品提示模拟UI: (this: void) => void;
};

export function init(this: void): void {
  物品栏提示劫持.初始化物品提示模拟UI();
}

export {};
