const japi = require("jass.japi") as any;

/**
 * KK扩展API - 特效相关函数
 */

/**
 * 绑定特效到单位/物体挂点
 */
export function DzBindEffect(parent: any, attachPoint: string, whichEffect: any): boolean {
  if (typeof japi.DzBindEffect === "function") {
    japi.DzBindEffect(parent, attachPoint, whichEffect);
    return true;
  }
  if (typeof (globalThis as any).DzBindEffect === "function") {
    (globalThis as any).DzBindEffect(parent, attachPoint, whichEffect);
    return true;
  }
  return false;
}

/**
 * 解除特效绑定
 */
export function DzUnbindEffect(whichEffect: any): boolean {
  if (typeof japi.DzUnbindEffect === "function") {
    japi.DzUnbindEffect(whichEffect);
    return true;
  }
  if (typeof (globalThis as any).DzUnbindEffect === "function") {
    (globalThis as any).DzUnbindEffect(whichEffect);
    return true;
  }
  return false;
}

/**
 * 设置特效缩放比例
 * @param whichEffect 特效句柄
 * @param scale 缩放比例
 */
export function DzSetEffectScale(whichEffect: any, scale: number): boolean {
  if (typeof japi.DzSetEffectScale === "function") {
    japi.DzSetEffectScale(whichEffect, scale);
    return true;
  }
  if (typeof (globalThis as any).DzSetEffectScale === "function") {
    (globalThis as any).DzSetEffectScale(whichEffect, scale);
    return true;
  }
  return false;
}

export {};
