export * from "./00．镜头函数";
export * from "./01．SDR调试计时器";
export * from "./02．Star自定义事件";

import * as cameraFunc from "./00．镜头函数";
import * as sdrDebug from "./01．SDR调试计时器";
import * as starEvent from "./02．Star自定义事件";

function expose(name: string, fn: any): void {
  if (typeof fn !== "function") return;
  const g = globalThis as any;
  if (typeof g[name] === "function") return;
  g[name] = fn;
}

export function registerBridge(): void {
  expose("PanCameraToTimedUnitForPlayer", cameraFunc.PanCameraToTimedUnitForPlayer);
  expose("SDR_DebugTimer", sdrDebug.SDR_DebugTimer);
  expose("STES_Register", starEvent.STES_Register);
  expose("STES_GetTable", starEvent.STES_GetTable);
  expose("STES_Fire", starEvent.STES_Fire);
}
