/**
 * 镜头震动函数封装
 *
 * - CameraSetEQNoiseForPlayer  : 设置镜头震动（地震效果）
 * - CameraClearNoiseForPlayer  : 清除镜头震动
 */
const jass = require("jass.common");
// 设置玩家镜头震动（地震效果）
// magnitude 震动幅度，建议范围 2-5
export function CameraSetEQNoiseForPlayer(whichPlayer, magnitude) {
    let richter = magnitude;
    if (richter > 5.0) {
        richter = 5.0;
    }
    if (richter < 2.0) {
        richter = 2.0;
    }
    const localPlayer = jass.GetLocalPlayer();
    if (localPlayer === whichPlayer) {
        const pow10richter = Math.pow(10, richter);
        jass.CameraSetTargetNoiseEx(magnitude * 2.0, magnitude * pow10richter, true);
        jass.CameraSetSourceNoiseEx(magnitude * 2.0, magnitude * pow10richter, true);
    }
}
// 清除玩家镜头震动
export function CameraClearNoiseForPlayer(whichPlayer) {
    const localPlayer = jass.GetLocalPlayer();
    if (localPlayer === whichPlayer) {
        jass.CameraSetSourceNoise(0, 0);
        jass.CameraSetTargetNoise(0, 0);
    }
}
// 震动时长封装（内部使用计时器）
const cameraTimers = new Map();
export function CameraShakeForPlayer(whichPlayer, magnitude, duration) {
    CameraSetEQNoiseForPlayer(whichPlayer, magnitude);
    const existing = cameraTimers.get(whichPlayer);
    if (existing) {
        jass.DestroyTimer(existing);
    }
    const t = jass.CreateTimer();
    cameraTimers.set(whichPlayer, t);
    jass.TimerStart(t, duration, false, () => {
        CameraClearNoiseForPlayer(whichPlayer);
        cameraTimers.delete(whichPlayer);
        if (typeof jass.DestroyTimer === "function") {
            jass.DestroyTimer(t);
        }
    });
}
