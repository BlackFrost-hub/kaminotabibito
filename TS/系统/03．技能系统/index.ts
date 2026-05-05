/**
 * 技能系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．技能冷却/index";
export * from "./02．技能消耗/index";
export * from "./04．快捷键技能/index";
export * from "./05．动态技能说明/index";
export * from "./06．AI自动使用技能/index";

// ========== 功能模块导出 ==========
export * from "./01．显示技能名字";

// ========== 初始化 ==========
require("系统.03．技能系统.01．技能冷却.index");
require("系统.03．技能系统.02．技能消耗.index");

const bbTeleportMod = require("系统.03．技能系统.04．快捷键技能.index") as { initBBTeleport?: () => void };
bbTeleportMod.initBBTeleport!();

const switchBagMod = require("系统.03．技能系统.04．快捷键技能.index") as { initSwitchBag?: () => void };
switchBagMod.initSwitchBag!();

require("系统.03．技能系统.01．显示技能名字");

const dynamicSkillTip = require("系统.03．技能系统.05．动态技能说明.index") as { init: () => void };
dynamicSkillTip.init();

const aiSkillSystem = require("系统.03．技能系统.06．AI自动使用技能.index") as { init: () => void };
aiSkillSystem.init();

const castBarSystem = require("系统.03．技能系统.07．技能吟唱条.index") as { init: () => void };
castBarSystem.init();

/**
 * 初始化技能系统
 */
export function init(): void {
}
