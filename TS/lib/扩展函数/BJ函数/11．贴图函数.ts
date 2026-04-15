const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

// ===========================================================================
// 最后创建的贴图（Blizzard.j）
// ===========================================================================
export let bj_lastCreatedUbersplat: any = jglobals.bj_lastCreatedUbersplat ?? null;

export function CreateUbersplatBJ(file: string, where: any, red: number, green: number, blue: number, alpha: number, forcePaused: boolean, noBirthTime: boolean): any {
  if (typeof jass.CreateUbersplat !== "function") return null;
  if (where == null || where === 0) return null;

  const x = typeof jass.GetLocationX === "function" ? jass.GetLocationX(where) : 0;
  const y = typeof jass.GetLocationY === "function" ? jass.GetLocationY(where) : 0;

  bj_lastCreatedUbersplat = jass.CreateUbersplat(x, y, red, green, blue, alpha, forcePaused, noBirthTime);
  return bj_lastCreatedUbersplat;
}

export function ShowUbersplatBJ(flag: boolean, whichUbersplat: any): void {
  if (typeof jass.ShowUbersplat !== "function") return;
  if (whichUbersplat == null || whichUbersplat === 0) return;
  jass.ShowUbersplat(whichUbersplat, flag);
}

export function GetLastCreatedUbersplat(): any {
  return bj_lastCreatedUbersplat;
}

export {};
