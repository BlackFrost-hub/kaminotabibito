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

/**
 * 对指定玩家在指定时间内平移镜头到 (x, y)。
 * 仅在被移动镜头的玩家本地执行 PanCameraToTimed，其他玩家不受影响。
 * @param whichPlayer 要移动镜头的玩家（jhandle_t）
 * @param x 目标 X 坐标
 * @param y 目标 Y 坐标
 * @param duration 平移耗时（秒）
 */
export function StarOther_PanCameraToTimedForPlayer(
  whichPlayer: any,
  x: number,
  y: number,
  duration: number
): void {
  if (typeof jass.GetLocalPlayer !== "function") return;
  const localPlayer = jass.GetLocalPlayer();
  if (localPlayer !== whichPlayer) return;
  if (typeof jass.PanCameraToTimed !== "function") return;
  jass.PanCameraToTimed(x, y, duration);
}

export {};
