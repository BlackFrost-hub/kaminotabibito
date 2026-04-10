const jass = require("jass.common") as any;

let starLocation: any = null;

/**
 * 获取坐标点地形高度（对齐 EC_GetPointZ）
 */
export function EC_GetPointZ(x: number, y: number): number {
  if (typeof jass.Location !== "function") return 0;
  if (starLocation == null) {
    starLocation = jass.Location(x, y);
  } else if (typeof jass.MoveLocation === "function") {
    jass.MoveLocation(starLocation, x, y);
  } else {
    starLocation = jass.Location(x, y);
  }

  if (typeof jass.GetLocationZ === "function") {
    return (jass.GetLocationZ(starLocation) as number) || 0;
  }
  return 0;
}

/**
 * 创建特效（对齐 EC_CreateEffect）
 * time:
 * - >= 0: 到时销毁（优先 YDWETimerDestroyEffect）
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
  if (typeof jass.AddSpecialEffect !== "function") return null;

  const eff = jass.AddSpecialEffect(path, x, y);
  g.bj_lastCreatedEffect = eff;
  if (!eff) return null;

  if (typeof jass.EXSetEffectSize === "function") {
    jass.EXSetEffectSize(eff, size);
  }
  if (typeof jass.EXSetEffectZ === "function") {
    jass.EXSetEffectZ(eff, EC_GetPointZ(x, y) + z);
  }

  if (time >= 0) {
    if (typeof jass.YDWETimerDestroyEffect === "function") {
      jass.YDWETimerDestroyEffect(time, eff);
    }
  } else if (time !== -1) {
    if (typeof jass.DestroyEffect === "function") {
      jass.DestroyEffect(eff);
    }
  }

  if (typeof jass.EXEffectMatRotateZ === "function") {
    jass.EXEffectMatRotateZ(eff, fac);
  }
  if (typeof jass.EXSetEffectSpeed === "function") {
    jass.EXSetEffectSpeed(eff, s);
  }

  return eff;
}

export {};
