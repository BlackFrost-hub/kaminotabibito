/**
 * 技能系统 - 统一导出和初始化入口
 */

// ========== 子系统导出 ==========
export * from "./01．技能冷却/index";
export * from "./02．技能消耗/index";
export * from "./04．快捷键技能/index";

// ========== 功能模块导出 ==========
export * from "./01．显示技能名字";
export * from "./02．显示技能名字2";
// 03．技能台词.ts 当前为空文件，暂不导出
// export * from "./03．技能台词";

// ========== 初始化 ==========
// 技能冷却系统
require("系统.03．技能系统.01．技能冷却.index");

// 技能消耗系统
require("系统.03．技能系统.02．技能消耗.index");

// 快捷键技能系统
const bbTeleportMod = require("系统.03．技能系统.04．快捷键技能.index") as { initBBTeleport?: () => void };
if (typeof bbTeleportMod.initBBTeleport === "function") bbTeleportMod.initBBTeleport();

const switchBagMod = require("系统.03．技能系统.04．快捷键技能.index") as { initSwitchBag?: () => void };
if (typeof switchBagMod.initSwitchBag === "function") switchBagMod.initSwitchBag();

// 显示技能名字
const 显示技能名字 = require("系统.03．技能系统.01．显示技能名字") as { initShowSkillName?: () => void };
if (typeof 显示技能名字.initShowSkillName === "function") 显示技能名字.initShowSkillName();

const 显示技能名字2 = require("系统.03．技能系统.02．显示技能名字2") as { initShowSkillName2?: () => void };
if (typeof 显示技能名字2.initShowSkillName2 === "function") 显示技能名字2.initShowSkillName2();

// require("系统.03．技能系统.03．技能台词");

/**
 * 初始化技能系统
 */
export function init(): void {
}

// 自动初始化（可选）
// init();
