/**
 * STES 暴露模块 - 将 JASS 的 STES_* 暴露到 _G，供 Lua 模块使用
 * 在 main 中最早加载
 */
const jass = require("jass.common") as any;
const g = require("jass.globals") as Record<string, any>;

const DEBUG = true;
const P0 = jass.Player(0);

function dbg(msg: string): void {
  if (DEBUG) jass.DisplayTimedTextToPlayer(P0, 0, 0, 12, "[STES] " + msg);
}

function expose(): void {
  const sr = jass.STES_Register ?? g.STES_Register;
  const st = jass.STES_Trigger ?? g.STES_Trigger;
  const gp = jass.STES_GetTriggerPlayer ?? g.STES_GetTriggerPlayer;

  if (typeof sr === "function") {
    (globalThis as any).STES_Register = sr;
    if (!jass.STES_Register) jass.STES_Register = sr;
    dbg("STES_Register: 已暴露");
  } else {
    dbg("STES_Register: 未找到 (jass.common 无此函数)");
  }
  if (typeof st === "function") {
    (globalThis as any).STES_Trigger = st;
    if (!jass.STES_Trigger) jass.STES_Trigger = st;
    dbg("STES_Trigger: 已暴露");
  }
  if (typeof gp === "function") {
    (globalThis as any).STES_GetTriggerPlayer = gp;
    if (!jass.STES_GetTriggerPlayer) jass.STES_GetTriggerPlayer = gp;
  }
}

expose();
export {};
