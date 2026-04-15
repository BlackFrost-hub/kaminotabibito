const doodadApi: any = require("lib.扩展函数.KK扩展API.00．装饰物函数");
const effectApi: any = require("lib.扩展函数.KK扩展API.01．特效函数");
const eventApi: any = require("lib.扩展函数.KK扩展API.02．事件注册函数");
const utilApi: any = require("lib.扩展函数.KK扩展API.03．工具函数");

export const DzDoodadCreate: (id: number, varId: number, x: number, y: number, z: number, rotate: number, scale: number) => number = doodadApi.DzDoodadCreate;
export const DzDoodadGetTypeId: (doodad: number) => number = doodadApi.DzDoodadGetTypeId;
export const DzDoodadSetModel: (doodad: number, modelFile: string) => void = doodadApi.DzDoodadSetModel;
export const DzDoodadSetTeamColor: (doodad: number, color: number) => void = doodadApi.DzDoodadSetTeamColor;
export const DzDoodadSetColor: (doodad: number, color: number) => void = doodadApi.DzDoodadSetColor;
export const DzDoodadGetX: (doodad: number) => number = doodadApi.DzDoodadGetX;
export const DzDoodadGetY: (doodad: number) => number = doodadApi.DzDoodadGetY;
export const DzDoodadGetZ: (doodad: number) => number = doodadApi.DzDoodadGetZ;
export const DzDoodadSetPosition: (doodad: number, x: number, y: number, z: number) => void = doodadApi.DzDoodadSetPosition;
export const DzDoodadSetOrientMatrixRotate: (doodad: number, angle: number, axisX: number, axisY: number, axisZ: number) => void = doodadApi.DzDoodadSetOrientMatrixRotate;
export const DzDoodadSetOrientMatrixScale: (doodad: number, x: number, y: number, z: number) => void = doodadApi.DzDoodadSetOrientMatrixScale;
export const DzDoodadSetOrientMatrixResize: (doodad: number) => void = doodadApi.DzDoodadSetOrientMatrixResize;
export const DzDoodadSetVisible: (doodad: number, enable: boolean) => void = doodadApi.DzDoodadSetVisible;
export const DzDoodadSetAnimation: (doodad: number, animName: string, animRandom: boolean) => void = doodadApi.DzDoodadSetAnimation;
export const DzDoodadSetTimeScale: (doodad: number, scale: number) => void = doodadApi.DzDoodadSetTimeScale;
export const DzDoodadGetTimeScale: (doodad: number) => number = doodadApi.DzDoodadGetTimeScale;
export const DzDoodadGetCurrentAnimationIndex: (doodad: number) => number = doodadApi.DzDoodadGetCurrentAnimationIndex;
export const DzDoodadGetAnimationCount: (doodad: number) => number = doodadApi.DzDoodadGetAnimationCount;
export const DzDoodadGetAnimationName: (doodad: number, index: number) => string = doodadApi.DzDoodadGetAnimationName;
export const DzDoodadGetAnimationTime: (doodad: number, index: number) => number = doodadApi.DzDoodadGetAnimationTime;

export const DzBindEffect: (parent: any, attachPoint: string, whichEffect: any) => boolean = effectApi.DzBindEffect;
export const DzUnbindEffect: (whichEffect: any) => boolean = effectApi.DzUnbindEffect;
export const DzSetEffectScale: (whichEffect: any, scale: number) => boolean = effectApi.DzSetEffectScale;

export const DzTriggerRegisterMouseEventTrg: (trg: any, status: number, btn: number) => void = eventApi.DzTriggerRegisterMouseEventTrg;
export const DzTriggerRegisterKeyEventTrg: (trg: any, status: number, btn: number | string) => void = eventApi.DzTriggerRegisterKeyEventTrg;
export const DzTriggerRegisterMouseMoveEventTrg: (trg: any) => void = eventApi.DzTriggerRegisterMouseMoveEventTrg;
export const DzTriggerRegisterMouseWheelEventTrg: (trg: any) => void = eventApi.DzTriggerRegisterMouseWheelEventTrg;
export const DzTriggerRegisterWindowResizeEventTrg: (trg: any) => void = eventApi.DzTriggerRegisterWindowResizeEventTrg;
export const DzF2I: (i: number) => number = eventApi.DzF2I;
export const DzI2F: (i: number) => number = eventApi.DzI2F;
export const DzK2I: (i: number) => number = eventApi.DzK2I;
export const DzI2K: (i: number) => number = eventApi.DzI2K;
export const DzTriggerRegisterMallItemSyncData: (trig: any) => void = eventApi.DzTriggerRegisterMallItemSyncData;
export const DzGetTriggerMallItemPlayer: () => any = eventApi.DzGetTriggerMallItemPlayer;
export const DzGetTriggerMallItem: () => string = eventApi.DzGetTriggerMallItem;

export const DzGetColor2: (a: number, r: number, g: number, b: number) => number = utilApi.DzGetColor2;
export const DzOpenQQGroupUrl: (url: string) => boolean = utilApi.DzOpenQQGroupUrl;

function expose(name: string, fn: any): void {
  if (typeof fn !== "function") return;
  const g = globalThis as any;
  if (typeof g[name] === "function") return;
  g[name] = fn;
}

export function registerBridge(): void {
  expose("DzDoodadCreate", doodadApi.DzDoodadCreate);
  expose("DzDoodadGetTypeId", doodadApi.DzDoodadGetTypeId);
  expose("DzDoodadSetModel", doodadApi.DzDoodadSetModel);
  expose("DzDoodadSetTeamColor", doodadApi.DzDoodadSetTeamColor);
  expose("DzDoodadSetColor", doodadApi.DzDoodadSetColor);
  expose("DzDoodadGetX", doodadApi.DzDoodadGetX);
  expose("DzDoodadGetY", doodadApi.DzDoodadGetY);
  expose("DzDoodadGetZ", doodadApi.DzDoodadGetZ);
  expose("DzDoodadSetPosition", doodadApi.DzDoodadSetPosition);
  expose("DzDoodadSetOrientMatrixRotate", doodadApi.DzDoodadSetOrientMatrixRotate);
  expose("DzDoodadSetOrientMatrixScale", doodadApi.DzDoodadSetOrientMatrixScale);
  expose("DzDoodadSetOrientMatrixResize", doodadApi.DzDoodadSetOrientMatrixResize);
  expose("DzDoodadSetVisible", doodadApi.DzDoodadSetVisible);
  expose("DzDoodadSetAnimation", doodadApi.DzDoodadSetAnimation);
  expose("DzDoodadSetTimeScale", doodadApi.DzDoodadSetTimeScale);
  expose("DzDoodadGetTimeScale", doodadApi.DzDoodadGetTimeScale);
  expose("DzDoodadGetCurrentAnimationIndex", doodadApi.DzDoodadGetCurrentAnimationIndex);
  expose("DzDoodadGetAnimationCount", doodadApi.DzDoodadGetAnimationCount);
  expose("DzDoodadGetAnimationName", doodadApi.DzDoodadGetAnimationName);
  expose("DzDoodadGetAnimationTime", doodadApi.DzDoodadGetAnimationTime);

  expose("DzBindEffect", effectApi.DzBindEffect);
  expose("DzUnbindEffect", effectApi.DzUnbindEffect);
  expose("DzSetEffectScale", effectApi.DzSetEffectScale);

  expose("DzTriggerRegisterMouseEventTrg", eventApi.DzTriggerRegisterMouseEventTrg);
  expose("DzTriggerRegisterKeyEventTrg", eventApi.DzTriggerRegisterKeyEventTrg);
  expose("DzTriggerRegisterMouseMoveEventTrg", eventApi.DzTriggerRegisterMouseMoveEventTrg);
  expose("DzTriggerRegisterMouseWheelEventTrg", eventApi.DzTriggerRegisterMouseWheelEventTrg);
  expose("DzTriggerRegisterWindowResizeEventTrg", eventApi.DzTriggerRegisterWindowResizeEventTrg);
  expose("DzF2I", eventApi.DzF2I);
  expose("DzI2F", eventApi.DzI2F);
  expose("DzK2I", eventApi.DzK2I);
  expose("DzI2K", eventApi.DzI2K);
  expose("DzTriggerRegisterMallItemSyncData", eventApi.DzTriggerRegisterMallItemSyncData);
  expose("DzGetTriggerMallItemPlayer", eventApi.DzGetTriggerMallItemPlayer);
  expose("DzGetTriggerMallItem", eventApi.DzGetTriggerMallItem);

  expose("DzGetColor2", utilApi.DzGetColor2);
  expose("DzOpenQQGroupUrl", utilApi.DzOpenQQGroupUrl);
}
