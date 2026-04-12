/**
 * 技能系统 - 统一导出和初始化入口
 */

// 导出显示技能名字功能
export * from "./01．显示技能名字";
export * from "./02．显示技能名字2";
// 03．技能台词.ts 当前为空文件，暂不导出
// export * from "./03．技能台词";

// 加载所有子模块并初始化
const 显示技能名字 = require("系统.03．技能系统.01．显示技能名字") as { initShowSkillName?: () => void };
if (typeof 显示技能名字.initShowSkillName === "function") 显示技能名字.initShowSkillName();

const 显示技能名字2 = require("系统.03．技能系统.02．显示技能名字2") as { initShowSkillName2?: () => void };
if (typeof 显示技能名字2.initShowSkillName2 === "function") 显示技能名字2.initShowSkillName2();

// require("系统.03．技能系统.03．技能台词");

/**
 * 初始化技能系统
 */
export function init(): void {
  const p = (globalThis as any).print;
  if (typeof p === "function") {
    p("[技能系统] 初始化完成");
  }
}

// 自动初始化（可选）
// init();
