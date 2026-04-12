const jass = require("jass.common") as any;

/**
 * 平移玩家镜头到单位
 * @param whichPlayer 目标玩家
 * @param u 目标单位
 * @param duration 平移时间
 */
export function StarOther_PanCameraToTimedUnitForPlayer(
  whichPlayer: any,
  u: any,
  duration: number
): void {
  if (typeof jass.GetLocalPlayer !== "function") return;
  if (typeof jass.GetUnitX !== "function" || typeof jass.GetUnitY !== "function") return;
  if (typeof jass.PanCameraToTimed !== "function") return;

  if (jass.GetLocalPlayer() === whichPlayer) {
    jass.PanCameraToTimed(jass.GetUnitX(u), jass.GetUnitY(u), duration);
  }
}

export {};
