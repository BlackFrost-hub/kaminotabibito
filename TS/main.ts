// main.ts
const runtime = require("jass.runtime") as { console?: boolean };
runtime.console = true;
const jassConsole = require("jass.console") as { write: (s: string) => void };
const originalPrint = (globalThis as any).print as (...args: any[]) => void;

(globalThis as any).print = (...args: any[]) => {
  let str = "";
  for (let i = 0; i < args.length; i++) {
    str += tostring(args[i]);
    if (i < args.length - 1) str += "\t";
  }
  jassConsole.write(str + "\n");
};

(globalThis as any).print("hello world");
(globalThis as any).print("hello world");
(globalThis as any).print("hello world");
(globalThis as any).print("hello world");

const jassMain = require("jass.common") as JassCommon;
const timer = jassMain.CreateTimer();

jassMain.TimerStart(timer, 0.5, false, () => {
  (globalThis as any).print("延迟加载装备系统...");
  const [success, result] = pcall(() => require("item_modules.equip_system"));
  if (success) {
    (globalThis as any).print("装备系统加载完成");
  } else {
    if (originalPrint) {
      originalPrint("装备系统加载失败:", result);
    }
  }
});

(globalThis as any).print("main.lua Loading complete");
export {};
