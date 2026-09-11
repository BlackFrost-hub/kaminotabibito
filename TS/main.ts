// main.ts
const runtime = require("jass.runtime") as { console?: boolean; handle_level?: number };
runtime.console = false;
runtime.handle_level = 0;
const jassConsole = require("jass.console") as { write: (s: string) => void };
require("jass.japi"); // 1.27 平台扩展入口；不要假设存在 Blz* 原生函数
const jass = require("jass.common") as Record<string, unknown>;
const jglobals = require("jass.globals") as Record<string, unknown>;
const slk = require("jass.slk") as Record<string, Record<string, Record<string, string>>>;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const MAIN_INIT_LOG_MODULE = "main/系统加载";
(globalThis as any).slk = slk;

(globalThis as any).print = (...args: any[]) => {
  let str = "";
  for (let i = 0; i < args.length; i++) {
    str += tostring(args[i]);
    if (i < args.length - 1) str += "\t";
  }
   jassConsole.write(str + "\n");
};


// ---------- 00．核心系统 ----------
const 启用Main系统 = (globalThis as any).__启用Main系统 === true;
if (true) {
  const 启用核心系统诊断 = true;
  if (启用核心系统诊断) {
    const 核心系统 = require("系统.00．核心系统.index") as { init?: () => void };
    if (typeof 核心系统.init === "function") 核心系统.init();
  }
  const 启用其余系统诊断 = true;
  if (启用其余系统诊断) {

// ---------- 扩展函数 ----------
const 扩展函数 = require("lib.扩展函数.index") as { init?: () => void };
if (typeof 扩展函数.init === "function") 扩展函数.init();

// ---------- 01．单位系统 ----------
const 单位系统 = require("系统.01．单位系统.index") as { init?: () => void };
if (typeof 单位系统.init === "function") 单位系统.init();

// ---------- 02．物品系统 ----------
const 物品系统 = require("系统.02．物品系统.index") as { init?: () => void };
if (typeof 物品系统.init === "function") 物品系统.init();

// ---------- 03．技能系统 ----------
const 技能系统 = require("系统.03．技能系统.index") as { init?: () => void };
if (typeof 技能系统.init === "function") 技能系统.init();

// ---------- 04．伤害系统 ----------
const 伤害系统 = require("系统.04．伤害系统.index") as { init?: () => void };
if (typeof 伤害系统.init === "function") 伤害系统.init();

// // ---------- 05．Buff系统 ----------
const Buff系统 = require("系统.05．Buff系统.index") as { init?: () => void };
if (typeof Buff系统.init === "function") Buff系统.init();

// // ---------- 07．地形系统 ----------
const 地形系统 = require("系统.07．地形系统.index") as { init?: () => void };
if (typeof 地形系统.init === "function") 地形系统.init();

// // ---------- 06．经济系统 ----------
const 经济系统 = require("系统.06．经济系统.index") as { init?: () => void };
if (typeof 经济系统.init === "function") 经济系统.init();

const 启用08以后系统诊断 = true;
if (启用08以后系统诊断) {
// // ---------- 08．任务系统 ----------
const 启用08任务系统诊断 = true;
if (启用08任务系统诊断) {
const 任务系统 = require("系统.08．任务系统.03．index") as { init?: () => void };
if (typeof 任务系统.init === "function") 任务系统.init();
}

// // ---------- 09．表现系统 ----------
const 表现系统 = require("系统.09．表现系统.index") as { init?: () => void };
if (typeof 表现系统.init === "function") 表现系统.init();

// // ---------- 10．存档系统 ----------
debugLogForce(MAIN_INIT_LOG_MODULE, "准备加载存档系统");
const 存档系统 = require("系统.10．存档系统.index") as { init?: (this: void) => void };
if (typeof 存档系统.init === "function") 存档系统.init();
debugLogForce(MAIN_INIT_LOG_MODULE, "存档系统加载完成");

// // ---------- 11．剧情系统 ----------
debugLogForce(MAIN_INIT_LOG_MODULE, "准备加载剧情系统");
const 剧情系统 = require("系统.11．剧情系统.index") as { init?: (this: void) => void };
if (typeof 剧情系统.init === "function") 剧情系统.init();
debugLogForce(MAIN_INIT_LOG_MODULE, "剧情系统加载完成");

// // ---------- 12．测试系统 ----------
// 通过统一的 index.ts 入口加载测试，在 系统.12．测试系统.index 中配置开关
debugLogForce(MAIN_INIT_LOG_MODULE, "准备加载测试系统");
require("系统.12．测试系统.index");
debugLogForce(MAIN_INIT_LOG_MODULE, "测试系统加载完成");
}
}
}

export {};
