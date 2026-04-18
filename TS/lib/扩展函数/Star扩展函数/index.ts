export * from "./00．SGSS";
export * from "./01．装备属性应用";
export * from "./02．GS单位属性";
export * from "./03．动态百分比属性";
export * from "./04．EC扩展库";
export * from "./Star扩展库/index";
export * from "./GS扩展库/index";

import * as sgss from "./00．SGSS";
import * as gsProp from "./02．GS单位属性";
import * as ecExt from "./04．EC扩展库";
import * as starLib from "./Star扩展库/index";
import * as gsExt from "./GS扩展库/index";

function expose(name: string, fn: any): void {
  if (typeof fn !== "function") return;
  const g = globalThis as any;
  if (typeof g[name] === "function") return;
  g[name] = fn;
}

export function registerBridge(): void {
  expose("SGSS_SetState", sgss.SGSS_SetState);
  expose("SGSS_SetStatePercentumEX2", sgss.SGSS_SetStatePercentumEX2);
  expose("GS_LoadUintProperty", gsProp.GS_LoadUintProperty);
  expose("GS_LoadUintProperty_B", gsProp.GS_LoadUintProperty_B);
  expose("GS_Unit_Pry_change", gsProp.GS_Unit_Pry_change);
  expose("GS_UnitPry", gsProp.GS_UnitPry);
  expose("GS_UnitPryB", gsProp.GS_UnitPryB);
  expose("EC_GetPointZ", ecExt.EC_GetPointZ);
  expose("EC_CreateEffect", ecExt.EC_CreateEffect);
  expose("GS_PolarProjectionBJ", gsExt.GS_PolarProjectionBJ);
  expose("SoHeroHatm", gsExt.SoHeroHatm);
  expose("GS_news", gsExt.GS_news);
  expose("GS_DisplayTimedTextToForcetakes", gsExt.GS_DisplayTimedTextToForcetakes);
  expose("GS_UnitSector", gsExt.GS_UnitSector);
  expose("GS_Sector", gsExt.GS_Sector);
  expose("StarOther_PanCameraToTimedUnitForPlayer", starLib.StarOther_PanCameraToTimedUnitForPlayer);
  expose("SDR_DebugTimer", starLib.SDR_DebugTimer);
}

export {};
