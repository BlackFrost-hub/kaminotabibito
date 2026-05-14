/**
 * 技能系统 - 统一导出和初始化入口
 */

export * from "./00．技能模板+函数/index";
export * from "./01．技能冷却/index";
export * from "./02．技能消耗/index";
export * from "./04．快捷键技能/index";
export * from "./06．AI自动使用技能/index";

export * from "./01．显示技能名字";

require("系统.03．技能系统.00．技能模板+函数.index");
require("系统.03．技能系统.01．技能冷却.index");
require("系统.03．技能系统.02．技能消耗.index");
require("系统.03．技能系统.快速Buff测试");

const 快捷键技能模块 = require("系统.03．技能系统.04．快捷键技能.index") as {
  initBBTeleport?: (this: void) => void;
  initSwitchBag?: (this: void) => void;
};
快捷键技能模块.initBBTeleport?.();
快捷键技能模块.initSwitchBag?.();

require("系统.03．技能系统.01．显示技能名字");

const ai技能系统 = require("系统.03．技能系统.06．AI自动使用技能.index") as {
  init: (this: void) => void;
};
ai技能系统.init();

const 动态技能文本 = require("系统.03．技能系统.07．动态技能文本.index") as {
  initDynamicSkillTextSystem: (this: void) => void;
};
动态技能文本.initDynamicSkillTextSystem();

export function init(this: void): void {
}
