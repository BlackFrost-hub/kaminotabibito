/**
 * 镜头震动函数封装
 *
 * - CameraSetEQNoiseForPlayer  : 设置镜头震动（地震效果）
 * - CameraClearNoiseForPlayer  : 清除镜头震动
 */

const jass = require("jass.common") as any;

// 设置玩家镜头震动（地震效果）
// magnitude 震动幅度，建议范围 2-5
export function CameraSetEQNoiseForPlayer(whichPlayer: any, magnitude: number): void {
  let richter = magnitude;
  if (richter > 5.0) {
    richter = 5.0;
  }
  if (richter < 2.0) {
    richter = 2.0;
  }
  const localPlayer = (jass as any).GetLocalPlayer();
  if (localPlayer === whichPlayer) {
    const pow10richter = Math.pow(10, richter);
    (jass as any).CameraSetTargetNoiseEx(magnitude * 2.0, magnitude * pow10richter, true);
    (jass as any).CameraSetSourceNoiseEx(magnitude * 2.0, magnitude * pow10richter, true);
  }
}

// 清除玩家镜头震动
export function CameraClearNoiseForPlayer(whichPlayer: any): void {
  const localPlayer = (jass as any).GetLocalPlayer();
  if (localPlayer === whichPlayer) {
    (jass as any).CameraSetSourceNoise(0, 0);
    (jass as any).CameraSetTargetNoise(0, 0);
  }
}

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

export {};