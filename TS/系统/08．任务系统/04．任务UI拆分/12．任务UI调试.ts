const jass = require("jass.common") as any;

export const TASK_UI_DEBUG = false;

function getPrint(): ((msg: string) => void) | undefined {
  return (globalThis as any).print as ((msg: string) => void) | undefined;
}

export function taskUiDebug(msg: string): void {
  if (!TASK_UI_DEBUG) return;
  getPrint()?.("[TaskUI] " + msg);
}

export function taskUiDebugPlayerTag(): string {
  const lp = jass.GetLocalPlayer?.();
  const pid = lp != null && typeof jass.GetPlayerId === "function" ? jass.GetPlayerId(lp) : -1;
  return "lp=" + tostring(pid);
}
