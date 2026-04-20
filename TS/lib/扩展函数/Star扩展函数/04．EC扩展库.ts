const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (duration: number, effect: any) => void;
};

let starLocation: any = null;

/**
 * 获取坐标点地形高度（对齐 EC_GetPointZ）
 */
export function EC_GetPointZ(x: number, y: number): number {
  if (starLocation == null) {
    starLocation = jass.Location(x, y);
  } else {
    jass.MoveLocation(starLocation, x, y);
  }
  return (jass.GetLocationZ(starLocation) as number) || 0;
}

/**
 * 创建特效（对齐 EC_CreateEffect）
 * time:
 * - >= 0: 到时销毁
 * - == -1: 不自动处理
 * - 其它负数: 立即销毁
 */
export function EC_CreateEffect(
  path: string,
  x: number,
  y: number,
  z: number,
  fac: number,
  size: number,
  s: number,
  time: number
): any {
  const g = globalThis as any;
  const eff = jass.AddSpecialEffect(path, x, y);
  g.bj_lastCreatedEffect = eff;
  if (!eff) return null;

  japi.EXSetEffectSize(eff, size);
  japi.EXSetEffectZ(eff, EC_GetPointZ(x, y) + z);

  if (time >= 0) {
    YDWETimerDestroyEffect(time, eff);
  } else if (time !== -1) {
    jass.DestroyEffect(eff);
  }

  japi.EXEffectMatRotateZ(eff, fac);
  japi.EXSetEffectSpeed(eff, s);

  return eff;
}

export {};
