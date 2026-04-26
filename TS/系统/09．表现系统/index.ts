/**
 * 表现系统 - 统一导出和初始化入口
 *
 * 须导出 `init`：`main.lua` 对 `require("系统.09．表现系统.index")` 的返回值做 `:init()` 调用。
 * 若本文件无任何 export，TSTL 会生成无 `return ____exports` 的 chunk，`require` 得到 `true`，下一行索引即报错。
 */

// ========== 子系统导出（按需取消注释） ==========
// export * from "./01．UI工具/index";
// export * from "./02．对话框系统/index";
// export * from "./03．UI属性系统/index";

export function init(): void {
  const 原生UI = require("系统.09．表现系统.00．初始化UI") as { initNativeUI?: () => void };
  if (typeof 原生UI.initNativeUI === "function") {
    原生UI.initNativeUI();
  }
}
