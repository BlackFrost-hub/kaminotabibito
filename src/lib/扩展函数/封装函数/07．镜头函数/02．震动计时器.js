/** @noSelfInFile */
/**
 * 镜头震动计时器封装
 */
const jass = require("jass.common");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
import { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } from "./01．镜头震动";
// 震动时长封装（内部使用计时器）
const cameraTimers = new Map();
const cameraShakeCtxByTimerHid = {};
function onCameraShakeTimerExpire() {
    const t = jass.GetExpiredTimer();
    if (!t)
        return;
    const hid = jass.GetHandleId(t);
    const ctx = cameraShakeCtxByTimerHid[hid];
    delete cameraShakeCtxByTimerHid[hid];
    if (ctx !== undefined) {
        CameraClearNoiseForPlayer(ctx.whichPlayer);
        cameraTimers.delete(ctx.playerId);
    }
    safeDestroyTimer(t);
}
export function CameraShakeForPlayer(whichPlayerOrSelf, magnitudeOrPlayer, durationOrMagnitude, maybeDuration) {
    const whichPlayer = maybeDuration !== undefined ? magnitudeOrPlayer : whichPlayerOrSelf;
    const magnitude = maybeDuration !== undefined ? durationOrMagnitude : magnitudeOrPlayer;
    const duration = maybeDuration !== undefined ? maybeDuration : durationOrMagnitude;
    CameraSetEQNoiseForPlayer(whichPlayer, magnitude);
    const playerId = jass.GetPlayerId(whichPlayer);
    const existing = cameraTimers.get(playerId);
    if (existing) {
        safeDestroyTimer(existing);
    }
    const t = jass.CreateTimer();
    cameraTimers.set(playerId, t);
    cameraShakeCtxByTimerHid[jass.GetHandleId(t)] = { whichPlayer, playerId };
    safeTimerStart(t, duration, false, onCameraShakeTimerExpire);
}
