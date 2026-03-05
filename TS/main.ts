// main.ts
const runtime = require("jass.runtime") as { console?: boolean };
runtime.console = true;
const jassConsole = require("jass.console") as { write: (s: string) => void };

(globalThis as any).print = (...args: any[]) => {
  let str = "";
  for (let i = 0; i < args.length; i++) {
    str += tostring(args[i]);
    if (i < args.length - 1) str += "\t";
  }
  jassConsole.write(str + "\n");
};

require("系统.装备.装备提取");
const [ok, err] = pcall(() => require("系统.装备.装备系统"));
if (!ok) (globalThis as any).print("装备系统加载失败:", tostring(err));
export {};
