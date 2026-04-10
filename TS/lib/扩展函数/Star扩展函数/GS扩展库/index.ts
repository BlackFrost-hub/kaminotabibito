export * from "./00．极坐标投影";

import * as gsExt from "./00．极坐标投影";

function expose(name: string, fn: any): void {
  if (typeof fn !== "function") return;
  const g = globalThis as any;
  if (typeof g[name] === "function") return;
  g[name] = fn;
}

export function registerBridge(): void {
  expose("GS_PolarProjectionBJ", gsExt.GS_PolarProjectionBJ);
}
