// main.ts
const runtime = require("jass.runtime") as { console?: boolean };
runtime.console = true;
const jassConsole = require("jass.console") as { write: (s: string) => void };
require("jass.japi"); // 扩展 JASS 原生 (Blz* 等)
// bridge: 若 Dz* 只导出到 Lua 的 jass.japi，则补到全局 _G，方便 JASS/Lua 两端同名调用
(() => {
  const g = globalThis as any;
  let japi: any = undefined;
  try {
    japi = require("jass.japi") as any;
  } catch (_e) {
    japi = undefined;
  }
  if (!japi) return;
  for (const k in japi) {
    if (typeof k !== "string") continue;
    if (k.indexOf("Dz") !== 0) continue;
    const v = japi[k];
    if (typeof v !== "function") continue;
    if (typeof g[k] === "function") continue; // 不覆盖已有实现
    g[k] = v;
  }
})();
const jass = require("jass.common") as Record<string, unknown>;
const jglobals = require("jass.globals") as Record<string, unknown>;
const slk = require("jass.slk") as Record<string, Record<string, Record<string, string>>>;
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
require("系统.00．核心系统.00．核心系统入口");
require("系统.00．核心系统.06．UI函数");

// ---------- 扩展函数 ----------
require("lib.扩展函数.00．扩展函数入口");

// ---------- 01．单位系统 ----------
require("系统.01．单位系统.单位狂暴");

// ---------- 02．物品系统 ----------
require("系统.02．物品系统.00．物品系统入口");

// ---------- 03．技能系统 ----------
const 显示技能名字 = require("系统.03．技能系统.01．显示技能名字") as { initShowSkillName: () => void };
if (typeof 显示技能名字.initShowSkillName === "function") 显示技能名字.initShowSkillName();

// ---------- 04．伤害系统 ----------
require("系统.04．伤害系统.01．伤害事件");
// DOT 定义（通过入口文件统一加载）
require("系统.04．伤害系统.02．DOT定义.00．DOT定义入口");
require("系统.04．伤害系统.02．dot伤害");
require("系统.04．伤害系统.03．伤害测试");

// // ---------- 05．Buff系统 ----------
const buffPoolCore = require("系统.05．Buff系统.00．Buff系统") as { initBuffSystem?: () => void };
 if (typeof buffPoolCore.initBuffSystem === "function") buffPoolCore.initBuffSystem();
 require("系统.05．Buff系统.03．BuffJASS桥接");

// // ---------- 07．地形系统 ----------
 const 区域传送 = require("系统.07．地形系统.03．区域传送") as { init区域传送: () => void };
 if (typeof 区域传送.init区域传送 === "function") 区域传送.init区域传送();
 const 激活传送点 = require("系统.07．地形系统.05．激活传送点") as { init激活传送点: () => void };
 if (typeof 激活传送点.init激活传送点 === "function") 激活传送点.init激活传送点();

// // ---------- 08．任务系统 ----------
// // 任务系统初始化
 const 任务管理器 = require("系统.08．任务系统.02．任务管理器") as { init: () => void };
 if (typeof 任务管理器.init === "function") 任务管理器.init();
 require("系统.08．任务系统.05．任务STES桥接");
 require("系统.08．任务系统.06．任务事件桥接");
 require("系统.08．任务系统.08．任务目标更新");
 require("系统.08．任务系统.10．主线配置驱动");

// // ---------- UI系统 ----------
 const 原生UI = require("系统.09．表现系统.00．初始化UI") as { initNativeUI: () => void };
 if (typeof 原生UI.initNativeUI === "function") 原生UI.initNativeUI();
 require("系统.09．表现系统.01．UI工具.index");
 require("系统.09．表现系统.02．垂直滚动条轨道");
 require("系统.09．表现系统.02．对话框系统入口.00．对话框系统入口");
/// 任务 UI 模块（通过入口文件统一加载）
 require("系统.08．任务系统.03．任务UI拆分.00．任务UI拆分入口");
 const 任务UI = require("系统.08．任务系统.03．任务UI") as { init: () => void; registerHotkey: () => void };
 if (typeof 任务UI.init === "function") 任务UI.init();
 if (typeof 任务UI.registerHotkey === "function") 任务UI.registerHotkey();
 const buffUI = require("系统.05．Buff系统.02．BuffUI") as { init?: () => void };
 if (typeof buffUI.init === "function") buffUI.init();

// // ---------- 12．测试系统 ----------
 require("系统.12．测试系统.测试事件");
 require("系统.12．测试系统.测试事件2");
 require("系统.12．测试系统.测试233注册");
 require("系统.12．测试系统.任务测试");
 require("系统.12．测试系统.任意测试");

export {};
