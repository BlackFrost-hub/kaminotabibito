// main.ts
const runtime = require("jass.runtime") as { console?: boolean };
runtime.console = true;
const jassConsole = require("jass.console") as { write: (s: string) => void };
require("jass.japi"); // 扩展 JASS 原生 (Blz* 等)
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
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
require("系统.测试.测试事件");
const [ok, err] = pcall(() => require("系统.装备.装备系统"));
if (!ok) (globalThis as any).print("装备系统加载失败:", tostring(err));
export {};
