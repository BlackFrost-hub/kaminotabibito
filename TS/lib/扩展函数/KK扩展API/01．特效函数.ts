const japi = require("jass.japi") as any;

/**
 * KK扩展API - 特效相关函数
 */

/**
 * 绑定特效到单位/物体挂点
 */
export function DzBindEffect(parent: any, attachPoint: string, whichEffect: any): boolean {
  if (typeof japi.DzBindEffect !== "function") return false;
  japi.DzBindEffect(parent, attachPoint, whichEffect);
  return true;
}

/**
 * 解除特效绑定
 */
export function DzUnbindEffect(whichEffect: any): boolean {
  if (typeof japi.DzUnbindEffect !== "function") return false;
  japi.DzUnbindEffect(whichEffect);
  return true;
}

/**
 * 设置特效缩放比例
 * @param whichEffect 特效句柄
 * @param scale 缩放比例
 */
export function DzSetEffectScale(whichEffect: any, scale: number): boolean {
  if (typeof japi.DzSetEffectScale !== "function") return false;
  japi.DzSetEffectScale(whichEffect, scale);
  return true;
}

export {};
