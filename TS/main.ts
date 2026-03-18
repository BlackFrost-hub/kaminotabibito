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


require("系统.装备.装备提取");
require("系统.装备.装备掉落");
require("系统.单位.单位狂暴");
require("系统.装备.装备限制");
require("系统.00_核心.封装函数");
require("系统.00_核心.音效函数");
require("系统.00_核心.漂浮文字函数");
require("系统.00_核心.硬件函数");
require("系统.00_核心.泄露审计");
require("系统.07_任务.任务接受");
require("系统.07_任务.任务完成");
require("系统.测试.测试事件");
require("系统.测试.测试事件2");
require("系统.测试.测试233注册");
const [ok, err] = pcall(() => require("系统.装备.装备系统"));
if (!ok) (globalThis as any).print("装备系统加载失败:", tostring(err));
require("系统.装备.装备移速");
require("系统.装备.装备回复");
require("系统.装备.装备成长");
require("系统.装备.物品加工");
require("系统.伤害.伤害事件");
require("系统.伤害.伤害测试");
require("系统.伤害.dot伤害");
const 区域传送 = require("系统.地形.区域传送") as { init区域传送: () => void };
if (typeof 区域传送.init区域传送 === "function") 区域传送.init区域传送();
const 激活传送点 = require("系统.地形.激活传送点") as { init激活传送点: () => void };
if (typeof 激活传送点.init激活传送点 === "function") 激活传送点.init激活传送点();
export {};
