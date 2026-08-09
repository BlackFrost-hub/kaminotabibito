/** @noSelfInFile */
/**
 * UI属性系统 - 统一导出入口
 *
 * JASS参考源：JASS/jass复制粘贴/属性查看.j
 * 表现系统总入口：TS/系统/09．表现系统/index.ts
 */

export * from "./00．常量定义";
export * from "./01．属性工具";
// 02．面板渲染的 onPlayerHeroRegistered 由 03．系统入口重新导出
export { createUiFrames, showDamagePanel, updateDamagePanel, updateDetailPanels } from "./02．面板渲染";
export * from "./03．系统入口";

const { initUiAttributeSystem } = require("系统.09．表现系统.03．UI属性系统.03．系统入口") as {
  initUiAttributeSystem: (this: void) => void;
};

export function init(): void {
  initUiAttributeSystem();
}

