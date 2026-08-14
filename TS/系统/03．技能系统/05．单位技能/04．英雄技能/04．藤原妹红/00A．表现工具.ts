/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const japi = require("jass.japi") as any;
const { 创建点特效, 销毁点特效, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  销毁点特效: (this: void, effect: any) => void;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};

const AttachSoundToUnit = jass.AttachSoundToUnit as (this: void, sound: any, unit: any) => void;
const SetSoundVolume = jass.SetSoundVolume as (this: void, sound: any, volume: number) => void;
const StartSound = jass.StartSound as (this: void, sound: any) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const EXSetEffectXY = (japi as any).EXSetEffectXY as ((this: void, effect: any, x: number, y: number) => void) | undefined;

export interface 藤原妹红特效资源 {
  模型路径: string;
  Z?: number;
  缩放?: number;
  持续秒?: number;
  动画速度?: number;
  动画索引?: number;
}

export interface 藤原妹红移动特效 {
  句柄: any;
}

export function 播放藤原妹红单位音效(this: void, unit: any, soundKey: string): void {
  if (unit == null || unit === 0 || soundKey == null || soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  AttachSoundToUnit(sound, unit);
  SetSoundVolume(sound, 127);
  StartSound(sound);
}

export function 播放藤原妹红配置动作(this: void, unit: any, animationIndex: number, timeScale: number): void {
  if (unit == null || unit === 0 || animationIndex < 0) return;
  SetUnitTimeScale(unit, timeScale > 0 ? timeScale : 1);
  SetUnitAnimationByIndex(unit, animationIndex);
}

export function 创建藤原妹红点特效(
  this: void,
  resource: 藤原妹红特效资源,
  x: number,
  y: number,
  facing?: number,
): any {
  if (resource == null || resource.模型路径 == null || resource.模型路径 === "") return null;
  return 创建点特效({
    模型路径: resource.模型路径,
    X: x,
    Y: y,
    Z: resource.Z,
    面向角度: facing,
    缩放: resource.缩放,
    动画速度: resource.动画速度,
    动画索引: resource.动画索引,
    持续秒: resource.持续秒,
  });
}

export function 创建藤原妹红单位特效(
  this: void,
  unit: any,
  resource: 藤原妹红特效资源,
  attachPoint: string = "origin",
): any {
  if (unit == null || unit === 0 || resource == null || resource.模型路径 === "") return null;
  return createTimedUnitEffect(unit, attachPoint, resource.模型路径, resource.持续秒 ?? 0.1);
}

export function 创建藤原妹红移动特效(
  this: void,
  resource: 藤原妹红特效资源,
  x: number,
  y: number,
  facing?: number,
): 藤原妹红移动特效 | undefined {
  const effect = 创建藤原妹红点特效(resource, x, y, facing);
  if (effect == null || effect === 0) return undefined;
  return { 句柄: effect };
}

export function 更新藤原妹红移动特效(this: void, movingEffect: 藤原妹红移动特效 | undefined, x: number, y: number): void {
  if (movingEffect == null || movingEffect.句柄 == null || movingEffect.句柄 === 0) return;
  if (EXSetEffectXY != null) EXSetEffectXY(movingEffect.句柄, x, y);
}

export function 销毁藤原妹红移动特效(this: void, movingEffect: 藤原妹红移动特效 | undefined): void {
  if (movingEffect == null || movingEffect.句柄 == null || movingEffect.句柄 === 0) return;
  销毁点特效(movingEffect.句柄);
  movingEffect.句柄 = undefined;
}

export {};
