const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { PercentTo255 } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  PercentTo255: (percentage: number) => number;
};

// ===========================================================================
// 最后创建的图像（Blizzard.j）
// ===========================================================================
export let bj_lastCreatedImage: any = jglobals.bj_lastCreatedImage ?? null;

export function CreateImageBJ(file: string, size: number, where: any, zOffset: number, imageType: number): any {
  if (typeof jass.CreateImage !== "function") return null;
  if (where == null || where === 0) return null;

  const x = typeof jass.GetLocationX === "function" ? jass.GetLocationX(where) : 0;
  const y = typeof jass.GetLocationY === "function" ? jass.GetLocationY(where) : 0;

  bj_lastCreatedImage = jass.CreateImage(file, size, size, size, x, y, zOffset, 0, 0, 0, imageType);
  return bj_lastCreatedImage;
}

export function ShowImageBJ(flag: boolean, whichImage: any): void {
  if (typeof jass.ShowImage !== "function") return;
  if (whichImage == null || whichImage === 0) return;
  jass.ShowImage(whichImage, flag);
}

export function SetImagePositionBJ(whichImage: any, where: any, zOffset: number): void {
  if (typeof jass.SetImagePosition !== "function") return;
  if (whichImage == null || whichImage === 0) return;
  if (where == null || where === 0) return;

  const x = typeof jass.GetLocationX === "function" ? jass.GetLocationX(where) : 0;
  const y = typeof jass.GetLocationY === "function" ? jass.GetLocationY(where) : 0;
  jass.SetImagePosition(whichImage, x, y, zOffset);
}

export function SetImageColorBJ(whichImage: any, red: number, green: number, blue: number, alpha: number): void {
  if (typeof jass.SetImageColor !== "function") return;
  if (whichImage == null || whichImage === 0) return;
  jass.SetImageColor(whichImage, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0 - alpha));
}

export function GetLastCreatedImage(): any {
  return bj_lastCreatedImage;
}

export {};
