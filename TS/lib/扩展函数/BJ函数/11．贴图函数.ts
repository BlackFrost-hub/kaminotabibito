/** @noSelfInFile */
const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const GetLocationX = jass.GetLocationX as (whichLocation: any) => number;
const GetLocationY = jass.GetLocationY as (whichLocation: any) => number;
const CreateUbersplat = jass.CreateUbersplat as (x: number, y: number, name: string, red: number, green: number, blue: number, alpha: number, forcePaused: boolean, noBirthTime: boolean) => any;
const ShowUbersplat = jass.ShowUbersplat as (whichUbersplat: any, flag: boolean) => void;

// ===========================================================================
// 最后创建的贴图（Blizzard.j）
// ===========================================================================
export let bj_lastCreatedUbersplat: any = jglobals.bj_lastCreatedUbersplat ?? null;

export function CreateUbersplatBJ(file: string, where: any, red: number, green: number, blue: number, alpha: number, forcePaused: boolean, noBirthTime: boolean): any {
  if (where == null || where === 0) return null;

  const x = GetLocationX(where);
  const y = GetLocationY(where);

  bj_lastCreatedUbersplat = CreateUbersplat(x, y, file, red, green, blue, alpha, forcePaused, noBirthTime);
  return bj_lastCreatedUbersplat;
}

export function ShowUbersplatBJ(flag: boolean, whichUbersplat: any): void {
  if (whichUbersplat == null || whichUbersplat === 0) return;
  ShowUbersplat(whichUbersplat, flag);
}

export function GetLastCreatedUbersplat(): any {
  return bj_lastCreatedUbersplat;
}

export {};
