/**
 * 镜头震动计时器封装
 */

const jass = require("jass.common") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};
import { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } from "./01．镜头震动";

// 震动时长封装（内部使用计时器）
const cameraTimers: Map<any, any> = new Map();

export function CameraShakeForPlayer(whichPlayer: any, magnitude: number, duration: number): void {
  CameraSetEQNoiseForPlayer(whichPlayer, magnitude);
  const existing = cameraTimers.get(whichPlayer);
  if (existing) {
    safeDestroyTimer(existing);
  }
  const t = (jass as any).CreateTimer();
  cameraTimers.set(whichPlayer, t);
  safeTimerStart(t, duration, false, () => {
    CameraClearNoiseForPlayer(whichPlayer);
    cameraTimers.delete(whichPlayer);
    safeDestroyTimer(t);
  });
}
