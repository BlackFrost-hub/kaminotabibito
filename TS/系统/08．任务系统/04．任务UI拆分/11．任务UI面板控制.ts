const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { questManager } from "../02．任务管理器/index";

export function registerTaskUIRefreshCallback(rebuildPages: () => void): void {
  if (!questManager || typeof questManager.registerUIRefreshCallback !== "function") return;
  questManager.registerUIRefreshCallback((_playerId: number, _questId?: string) => {
    (pcall as any)(() => rebuildPages());
  });
}

export function showTaskUITabTooltip(msg: string): void {
  const p = typeof (japi as any).DzGetTriggerUIEventPlayer === "function" ? (japi as any).DzGetTriggerUIEventPlayer() : null;
  if (p) (jass as any).DisplayTextToPlayer(p, 0, 0, msg);
}
