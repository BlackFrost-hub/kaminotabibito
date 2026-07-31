/** @noSelfInFile */
const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { PercentTo255 } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  PercentTo255: (this: void, percentage: number) => number;
};
const GetLocationX = jass.GetLocationX as (whichLocation: any) => number;
const GetLocationY = jass.GetLocationY as (whichLocation: any) => number;
const CreateUbersplat = jass.CreateUbersplat as (x: number, y: number, name: string, red: number, green: number, blue: number, alpha: number, forcePaused: boolean, noBirthTime: boolean) => any;
const ShowUbersplat = jass.ShowUbersplat as (whichUbersplat: any, flag: boolean) => void;
const SetUbersplatRenderAlwaysNative = jass.SetUbersplatRenderAlways as (whichUbersplat: any, flag: boolean) => void;

// ===========================================================================
// 最后创建的贴图（Blizzard.j）
// ===========================================================================
export let bj_lastCreatedUbersplat: any = jglobals.bj_lastCreatedUbersplat ?? null;

export function CreateUbersplatBJ(this: void, where: any, file: string, red: number, green: number, blue: number, alpha: number, forcePaused: boolean, noBirthTime: boolean): any {
  if (where == null || where === 0) return null;

  const x = GetLocationX(where);
  const y = GetLocationY(where);

  bj_lastCreatedUbersplat = CreateUbersplat(
    x,
    y,
    file,
    PercentTo255(red),
    PercentTo255(green),
    PercentTo255(blue),
    PercentTo255(100 - alpha),
    forcePaused,
    noBirthTime,
  );
  return bj_lastCreatedUbersplat;
}

export function ShowUbersplatBJ(this: void, flag: boolean, whichUbersplat: any): void {
  if (whichUbersplat == null || whichUbersplat === 0) return;
  ShowUbersplat(whichUbersplat, flag);
}

export function SetUbersplatRenderAlways(this: void, whichUbersplat: any, flag: boolean): void {
  if (whichUbersplat == null || whichUbersplat === 0) return;
  SetUbersplatRenderAlwaysNative(whichUbersplat, flag);
}

export function GetLastCreatedUbersplat(this: void): any {
  return bj_lastCreatedUbersplat;
}

export {};
