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
const g = require("jass.globals") as Record<string, unknown>;
const slk = require("jass.slk") as Record<string, Record<string, Record<string, string>>>;
(globalThis as any).slk = slk;
if (g.YDUserDataGet2 && !jass.YDUserDataGet2) jass.YDUserDataGet2 = g.YDUserDataGet2;
if (g.YDUserDataGet && !jass.YDUserDataGet) jass.YDUserDataGet = g.YDUserDataGet;
if (g.Ir_GetUnitAttackType && !(jass as any).Ir_GetUnitAttackType) (jass as any).Ir_GetUnitAttackType = g.Ir_GetUnitAttackType;
if (g.Ir_SetUnitAttackType && !(jass as any).Ir_SetUnitAttackType) (jass as any).Ir_SetUnitAttackType = g.Ir_SetUnitAttackType;

(globalThis as any).print = (...args: any[]) => {
  let str = "";
  for (let i = 0; i < args.length; i++) {
    str += tostring(args[i]);
    if (i < args.length - 1) str += "\t";
  }
  jassConsole.write(str + "\n");
};


require("系统.02．物品系统.07．装备提取");
require("系统.02．物品系统.05．装备掉落");
require("系统.01．单位系统.单位狂暴");
require("系统.02．物品系统.10．装备限制");
require("系统.00．核心系统.封装函数");
require("系统.00．核心系统.音效函数");
require("系统.00．核心系统.漂浮文字函数");
require("系统.00．核心系统.硬件函数");
require("系统.00．核心系统.泄露审计");
require("系统.08．任务系统.任务接受");
require("系统.08．任务系统.任务完成");
require("系统.08．任务系统.任务目标更新");
require("系统.12．测试系统.测试事件");
require("系统.12．测试系统.测试事件2");
require("系统.12．测试系统.测试233注册");
const [ok, err] = pcall(() => require("系统.02．物品系统.11．装备系统"));
if (!ok) (globalThis as any).print("装备系统加载失败:", tostring(err));
require("系统.02．物品系统.08．装备移速");
require("系统.02．物品系统.06．装备回复");
require("系统.02．物品系统.04．装备成长");
require("系统.02．物品系统.03．物品加工");
require("系统.04．伤害系统.伤害事件");
require("系统.04．伤害系统.伤害测试");
const buffPoolCore = require("系统.05．Buff系统.Buff系统") as { initBuffSystem?: () => void };
if (typeof buffPoolCore.initBuffSystem === "function") buffPoolCore.initBuffSystem();
require("系统.04．伤害系统.dot伤害");
// {
//   const dotMod = require("系统.04．伤害系统.dot伤害") as { DOT_DAMAGE_DEBUG?: boolean };
//   if (dotMod && typeof dotMod.DOT_DAMAGE_DEBUG === "boolean") dotMod.DOT_DAMAGE_DEBUG = true;
// }
const 区域传送 = require("系统.07．地形系统.区域传送") as { init区域传送: () => void };
if (typeof 区域传送.init区域传送 === "function") 区域传送.init区域传送();
const 激活传送点 = require("系统.07．地形系统.激活传送点") as { init激活传送点: () => void };
if (typeof 激活传送点.init激活传送点 === "function") 激活传送点.init激活传送点();

// 任务系统初始化
const 任务管理器 = require("系统.08．任务系统.任务管理器") as { init: () => void };
if (typeof 任务管理器.init === "function") 任务管理器.init();

const 任务UI = require("系统.08．任务系统.任务UI") as { init: () => void; registerHotkey: () => void };
if (typeof 任务UI.init === "function") 任务UI.init();
if (typeof 任务UI.registerHotkey === "function") 任务UI.registerHotkey();

// 任务测试（F10运行测试）
require("系统.12．测试系统.任务测试");

const buffUI = require("系统.05．Buff系统.02．BuffUI") as { init?: () => void };
if (typeof buffUI.init === "function") buffUI.init();

export {};
