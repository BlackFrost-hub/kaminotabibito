/** @noSelfInFile */
/**
 * UI属性系统 - 统一导出入口
 */

export * from "./00．常量定义";
export * from "./01．属性工具";
export * from "./02．面板渲染";
export * from "./03．系统入口";

const { initUiAttributeSystem } = require("系统.09．表现系统.03．UI属性系统.03．系统入口") as {
  initUiAttributeSystem: () => void;
};

export function init(): void {
  initUiAttributeSystem();
}

