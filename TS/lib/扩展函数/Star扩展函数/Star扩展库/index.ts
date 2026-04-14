export * from "./00．镜头函数";
export * from "./01．SDR调试计时器";
export * from "./02．Star自定义事件";
export * from "./03．硬直暂停系统";
export * from "./04．快速Buff系统";

import * as cameraFunc from "./00．镜头函数";
import * as sdrDebug from "./01．SDR调试计时器";
import * as starEvent from "./02．Star自定义事件";
import * as suspend from "./03．硬直暂停系统";
import * as fastBuff from "./04．快速Buff系统";

function expose(name: string, fn: any): void {
  if (typeof fn !== "function") return;
  const g = globalThis as any;
  if (typeof g[name] === "function") return;
  g[name] = fn;
}

export function registerBridge(): void {
  expose("StarOther_PanCameraToTimedUnitForPlayer", cameraFunc.StarOther_PanCameraToTimedUnitForPlayer);
  expose("SDR_DebugTimer", sdrDebug.SDR_DebugTimer);
  expose("STES_Register", starEvent.STES_Register);
  expose("STES_RegisterEx", starEvent.STES_RegisterEx);
  expose("STES_GetTable", starEvent.STES_GetTable);
  expose("STES_Fire", starEvent.STES_Fire);
  expose("STES_FireWithReal11Step", starEvent.STES_FireWithReal11Step);
  expose("STES_Execute", starEvent.STES_Execute);
  expose("STES_GetUnitEvent", starEvent.STES_GetUnitEvent);
  expose("STES_RemoveEvent", starEvent.STES_RemoveEvent);
  expose("STES_Remove", starEvent.STES_Remove);
  // 硬直暂停系统
  expose("GS_Suspend", suspend.GS_Suspend);
  expose("GS_IsUnitSuspending", suspend.GS_IsUnitSuspending);
  expose("GS_LoadSuspend", suspend.GS_LoadSuspend);
  expose("GS_UnitSuspend", suspend.GS_UnitSuspend);
  // 快速Buff系统
  expose("SFB_setBuff", fastBuff.SFB_setBuff);
  expose("SFB_setSlow", fastBuff.SFB_setSlow);
  expose("SFB_Init", fastBuff.SFB_Init);
}
