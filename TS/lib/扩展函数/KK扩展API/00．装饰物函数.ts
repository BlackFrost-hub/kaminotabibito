/** @noSelfInFile */

/**
 * KK扩展API - 装饰物相关函数
 *
 * 注意：这些函数只有KK平台才有，其他平台（如YDWE、WE）不支持
 */

const japi = require("jass.japi") as any;

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
  return (japi.DzDoodadCreate(id, varId, x, y, z, rotate, scale) as number) || 0;
}

/**
 * 获取装饰物类型ID
 */
export function DzDoodadGetTypeId(doodad: number): number {
  return (japi.DzDoodadGetTypeId(doodad) as number) || 0;
}

/**
 * 设置装饰物模型
 */
export function DzDoodadSetModel(doodad: number, modelFile: string): void {
  japi.DzDoodadSetModel(doodad, modelFile);
}

/**
 * 设置装饰物队伍颜色
 */
export function DzDoodadSetTeamColor(doodad: number, color: number): void {
  japi.DzDoodadSetTeamColor(doodad, color);
}

/**
 * 设置装饰物颜色
 */
export function DzDoodadSetColor(doodad: number, color: number): void {
  japi.DzDoodadSetColor(doodad, color);
}

/**
 * 获取装饰物X坐标
 */
export function DzDoodadGetX(doodad: number): number {
  return (japi.DzDoodadGetX(doodad) as number) || 0;
}

/**
 * 获取装饰物Y坐标
 */
export function DzDoodadGetY(doodad: number): number {
  return (japi.DzDoodadGetY(doodad) as number) || 0;
}

/**
 * 获取装饰物Z坐标
 */
export function DzDoodadGetZ(doodad: number): number {
  return (japi.DzDoodadGetZ(doodad) as number) || 0;
}

/**
 * 设置装饰物位置
 */
export function DzDoodadSetPosition(doodad: number, x: number, y: number, z: number): void {
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
  japi.DzDoodadSetOrientMatrixScale(doodad, x, y, z);
}

/**
 * 设置装饰物方向矩阵重置大小
 */
export function DzDoodadSetOrientMatrixResize(doodad: number): void {
  japi.DzDoodadSetOrientMatrixResize(doodad);
}

/**
 * 设置装饰物可见性
 */
export function DzDoodadSetVisible(doodad: number, enable: boolean): void {
  japi.DzDoodadSetVisible(doodad, enable);
}

/**
 * 删除装饰物
 */
export function DzDoodadRemove(doodad: number): void {
  japi.DzDoodadRemove(doodad);
}

/**
 * 设置装饰物动画
 */
export function DzDoodadSetAnimation(doodad: number, animName: string, animRandom: boolean): void {
  japi.DzDoodadSetAnimation(doodad, animName, animRandom);
}

/**
 * 设置装饰物时间缩放
 */
export function DzDoodadSetTimeScale(doodad: number, scale: number): void {
  japi.DzDoodadSetTimeScale(doodad, scale);
}

/**
 * 获取装饰物时间缩放
 */
export function DzDoodadGetTimeScale(doodad: number): number {
  return (japi.DzDoodadGetTimeScale(doodad) as number) || 0;
}

/**
 * 获取装饰物当前动画索引
 */
export function DzDoodadGetCurrentAnimationIndex(doodad: number): number {
  return (japi.DzDoodadGetCurrentAnimationIndex(doodad) as number) || 0;
}

/**
 * 获取装饰物动画数量
 */
export function DzDoodadGetAnimationCount(doodad: number): number {
  return (japi.DzDoodadGetAnimationCount(doodad) as number) || 0;
}

/**
 * 获取装饰物动画名称
 */
export function DzDoodadGetAnimationName(doodad: number, index: number): string {
  return (japi.DzDoodadGetAnimationName(doodad, index) as string) || "";
}

/**
 * 获取装饰物动画时间
 */
export function DzDoodadGetAnimationTime(doodad: number, index: number): number {
  return (japi.DzDoodadGetAnimationTime(doodad, index) as number) || 0;
}

export {};
