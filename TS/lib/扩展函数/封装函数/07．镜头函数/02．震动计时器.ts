/** @noSelfInFile */
/**
 * 镜头震动计时器封装
 */

const jass = require("jass.common") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};
import { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } from "./01．镜头震动";

// 震动时长封装（内部使用计时器）
const cameraTimers: Map<number, any> = new Map();
const cameraShakeCtxByTimerHid: Record<number, { whichPlayer: any; playerId: number }> = {};

function onCameraShakeTimerExpire(this: void): void {
  const t = (jass as any).GetExpiredTimer();
  if (!t) return;
  const hid = (jass as any).GetHandleId(t) as number;
  const ctx = cameraShakeCtxByTimerHid[hid];
  delete cameraShakeCtxByTimerHid[hid];
  if (ctx !== undefined) {
    CameraClearNoiseForPlayer(ctx.whichPlayer);
    cameraTimers.delete(ctx.playerId);
  }
  safeDestroyTimer(t);
}

export function CameraShakeForPlayer(
  whichPlayer: any,
  magnitude: number,
  duration: number
): void {
  CameraSetEQNoiseForPlayer(whichPlayer, magnitude);
  const playerId = (jass as any).GetPlayerId(whichPlayer);
  const existing = cameraTimers.get(playerId);
  if (existing) {
    safeDestroyTimer(existing);
  }
  const t = (jass as any).CreateTimer();
  cameraTimers.set(playerId, t);
  cameraShakeCtxByTimerHid[(jass as any).GetHandleId(t) as number] = { whichPlayer, playerId };
  safeTimerStart(t, duration, false, onCameraShakeTimerExpire);
}
