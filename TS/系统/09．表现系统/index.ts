/**
 * 表现系统 - 统一导出和初始化入口
 *
 * 须导出 `init`：`main.lua` 对 `require("系统.09．表现系统.index")` 的返回值做 `:init()` 调用。
 * 若本文件无任何 `export`，TSTL 可能生成无 `return ____exports` 的 chunk，`require` 得到 `true`，下一行索引即报错。
 */

export * from "./01．UI工具/index";
export * from "./00．初始化UI";
export * from "./04．翻页UI预研/index";
export * from "./05．仇恨面板/index";
export * from "./06．广播提示消息/index";
export * from "./07．游戏说明手册/index";

// 对话框子系统在自身 index 侧载执行初始化；不在此 `export *`，避免与下方 `init` 同名符号合并冲突
require("系统.09．表现系统.02．对话框系统.index");

import { init as initUiAttributeSystem } from "./03．UI属性系统/index";
import { 初始化广播提示消息系统 } from "./06．广播提示消息/index";
import { init as initGameManual } from "./07．游戏说明手册/index";

const 原生UI = require("系统.09．表现系统.00．初始化UI") as { initNativeUI: () => void };

export function init(): void {
  if (typeof 原生UI.initNativeUI === "function") {
    原生UI.initNativeUI();
  }
  initUiAttributeSystem();
  初始化广播提示消息系统();
  initGameManual();
}
