const japi = require("jass.japi") as any;

/**
 * KK扩展API - 装饰物相关函数
 */

/**
 * 创建装饰物
 */
export function DzDoodadCreate(
  id: number,
  varId: number,
  x: number,
  y: number,
  z: number,
  rotate: number,
  scale: number
): number {
  if (typeof japi.DzDoodadCreate !== "function") return 0;
  return (japi.DzDoodadCreate(id, varId, x, y, z, rotate, scale) as number) || 0;
}

/**
 * 获取装饰物类型ID
 */
export function DzDoodadGetTypeId(doodad: number): number {
  if (typeof japi.DzDoodadGetTypeId !== "function") return 0;
  return (japi.DzDoodadGetTypeId(doodad) as number) || 0;
}

/**
 * 设置装饰物模型
 */
export function DzDoodadSetModel(doodad: number, modelFile: string): void {
  if (typeof japi.DzDoodadSetModel !== "function") return;
  japi.DzDoodadSetModel(doodad, modelFile);
}

/**
 * 设置装饰物队伍颜色
 */
export function DzDoodadSetTeamColor(doodad: number, color: number): void {
  if (typeof japi.DzDoodadSetTeamColor !== "function") return;
  japi.DzDoodadSetTeamColor(doodad, color);
}

/**
 * 设置装饰物颜色
 */
export function DzDoodadSetColor(doodad: number, color: number): void {
  if (typeof japi.DzDoodadSetColor !== "function") return;
  japi.DzDoodadSetColor(doodad, color);
}

/**
 * 获取装饰物X坐标
 */
export function DzDoodadGetX(doodad: number): number {
  if (typeof japi.DzDoodadGetX !== "function") return 0;
  return (japi.DzDoodadGetX(doodad) as number) || 0;
}

/**
 * 获取装饰物Y坐标
 */
export function DzDoodadGetY(doodad: number): number {
  if (typeof japi.DzDoodadGetY !== "function") return 0;
  return (japi.DzDoodadGetY(doodad) as number) || 0;
}

/**
 * 获取装饰物Z坐标
 */
export function DzDoodadGetZ(doodad: number): number {
  if (typeof japi.DzDoodadGetZ !== "function") return 0;
  return (japi.DzDoodadGetZ(doodad) as number) || 0;
}

/**
 * 设置装饰物位置
 */
export function DzDoodadSetPosition(doodad: number, x: number, y: number, z: number): void {
  if (typeof japi.DzDoodadSetPosition !== "function") return;
  japi.DzDoodadSetPosition(doodad, x, y, z);
}

/**
 * 设置装饰物方向矩阵旋转
 */
export function DzDoodadSetOrientMatrixRotate(
  doodad: number,
  angle: number,
  axisX: number,
  axisY: number,
  axisZ: number
): void {
  if (typeof japi.DzDoodadSetOrientMatrixRotate !== "function") return;
  japi.DzDoodadSetOrientMatrixRotate(doodad, angle, axisX, axisY, axisZ);
}

/**
 * 设置装饰物方向矩阵缩放
 */
export function DzDoodadSetOrientMatrixScale(
  doodad: number,
  x: number,
  y: number,
  z: number
): void {
  if (typeof japi.DzDoodadSetOrientMatrixScale !== "function") return;
  japi.DzDoodadSetOrientMatrixScale(doodad, x, y, z);
}

/**
 * 设置装饰物方向矩阵重置大小
 */
export function DzDoodadSetOrientMatrixResize(doodad: number): void {
  if (typeof japi.DzDoodadSetOrientMatrixResize !== "function") return;
  japi.DzDoodadSetOrientMatrixResize(doodad);
}

/**
 * 设置装饰物可见性
 */
export function DzDoodadSetVisible(doodad: number, enable: boolean): void {
  if (typeof japi.DzDoodadSetVisible !== "function") return;
  japi.DzDoodadSetVisible(doodad, enable);
}

/**
 * 设置装饰物动画
 */
export function DzDoodadSetAnimation(doodad: number, animName: string, animRandom: boolean): void {
  if (typeof japi.DzDoodadSetAnimation !== "function") return;
  japi.DzDoodadSetAnimation(doodad, animName, animRandom);
}

/**
 * 设置装饰物时间缩放
 */
export function DzDoodadSetTimeScale(doodad: number, scale: number): void {
  if (typeof japi.DzDoodadSetTimeScale !== "function") return;
  japi.DzDoodadSetTimeScale(doodad, scale);
}

/**
 * 获取装饰物时间缩放
 */
export function DzDoodadGetTimeScale(doodad: number): number {
  if (typeof japi.DzDoodadGetTimeScale !== "function") return 0;
  return (japi.DzDoodadGetTimeScale(doodad) as number) || 0;
}

/**
 * 获取装饰物当前动画索引
 */
export function DzDoodadGetCurrentAnimationIndex(doodad: number): number {
  if (typeof japi.DzDoodadGetCurrentAnimationIndex !== "function") return 0;
  return (japi.DzDoodadGetCurrentAnimationIndex(doodad) as number) || 0;
}

/**
 * 获取装饰物动画数量
 */
export function DzDoodadGetAnimationCount(doodad: number): number {
  if (typeof japi.DzDoodadGetAnimationCount !== "function") return 0;
  return (japi.DzDoodadGetAnimationCount(doodad) as number) || 0;
}

/**
 * 获取装饰物动画名称
 */
export function DzDoodadGetAnimationName(doodad: number, index: number): string {
  if (typeof japi.DzDoodadGetAnimationName !== "function") return "";
  return (japi.DzDoodadGetAnimationName(doodad, index) as string) || "";
}

/**
 * 获取装饰物动画时间
 */
export function DzDoodadGetAnimationTime(doodad: number, index: number): number {
  if (typeof japi.DzDoodadGetAnimationTime !== "function") return 0;
  return (japi.DzDoodadGetAnimationTime(doodad, index) as number) || 0;
}

export {};
