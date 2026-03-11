// 输入 233 时：findFunction 查找 STES_Register，并注册事件 LuaEvent_GetItem
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { [key: string]: any };

function dumpAllKeys(): void {
  const pr = (globalThis as any).print as (s: string) => void;
  if (!pr) return;
  const j = jass as any;
  const g = globalThis as any;
  pr("--- jass 全部 key ---");
  for (const k in j) pr("jass." + k);
  pr("--- _G 全部 key ---");
  for (const k in g) pr("_G." + k);
}

function listAllCustomJassFunctions(): void {
  const pr = (globalThis as any).print as (s: string) => void;
  if (!pr) return;
  const g = globalThis as any;
  let count = 0;
  pr("=== 所有自定义Jass函数(_G中,非jass) ===");
  for (const k in g) {
    if (typeof g[k] === "function" && k !== "_G" && k.indexOf("jass") !== 0) {
      pr(k);
      count++;
      if (count > 50) break;
    }
  }
  pr("总共找到 " + tostring(count) + "+ 个自定义函数");
}

function listCounts(): void {
  const pr = (globalThis as any).print as (s: string) => void;
  if (!pr) return;
  const j = jass as any;
  const g = globalThis as any;
  let jassCount = 0;
  let globalCount = 0;
  for (const k in j) {
    if (typeof j[k] === "function") jassCount++;
  }
  for (const k in g) {
    if (typeof g[k] === "function" && k !== "_G" && k.indexOf("jass") !== 0) globalCount++;
  }
  pr("---");
  pr("找到 jass 函数 " + tostring(jassCount) + " 个, 全局函数 " + tostring(globalCount) + " 个");
}

function findFunction(funcName: string): ((trig: any, name: string) => void) | undefined {
  const j = jass as any;
  const glob = globalThis as any;
  const pr = glob.print as (s: string) => void;
  if (j[funcName]) {
    pr?.("✅ 在 jass 表里: jass." + funcName);
    return j[funcName];
  }
  if (glob[funcName]) {
    pr?.("✅ 在全局环境: _G." + funcName);
    return glob[funcName];
  }
  pr?.("❌ 找不到: " + funcName);
  dumpAllKeys();
  return undefined;
}

function onChat233(): void {
  const STES_Register = findFunction("STES_Register");
  if (STES_Register) {
    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, () => {
      (globalThis as any).print?.("LuaEvent_GetItem 触发");
      jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 8, "LuaEvent_GetItem 触发");
    });
    STES_Register(trig, "LuaEvent_GetItem");
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 8, "已注册 LuaEvent_GetItem");
  }
  listAllCustomJassFunctions();
  listCounts();
}

function init(): void {
  const tr = jass.CreateTrigger();
  jass.TriggerRegisterPlayerChatEvent(tr, jass.Player(0), "233", true);
  jass.TriggerAddAction(tr, onChat233);
}

init();
export {};
