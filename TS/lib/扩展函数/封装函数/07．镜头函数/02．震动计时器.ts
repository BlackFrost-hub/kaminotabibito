/**
 * 镜头震动计时器封装
 */

const jass = require("jass.common") as any;
import { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } from "./01．镜头震动";

// 震动时长封装（内部使用计时器）
const cameraTimers: Map<any, any> = new Map();

export function CameraShakeForPlayer(whichPlayer: any, magnitude: number, duration: number): void {
  CameraSetEQNoiseForPlayer(whichPlayer, magnitude);
  const existing = cameraTimers.get(whichPlayer);
  if (existing) {
    (jass as any).DestroyTimer(existing);
  }
  const t = (jass as any).CreateTimer();
  cameraTimers.set(whichPlayer, t);
  (jass as any).TimerStart(t, duration, false, () => {
    CameraClearNoiseForPlayer(whichPlayer);
    cameraTimers.delete(whichPlayer);
    if (typeof (jass as any).DestroyTimer === "function") {
      (jass as any).DestroyTimer(t);
    }
  });
}
