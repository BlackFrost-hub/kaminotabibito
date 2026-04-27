/**
 * 镜头震动函数
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
    const pow10richter = jass.Pow(10, richter);
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
