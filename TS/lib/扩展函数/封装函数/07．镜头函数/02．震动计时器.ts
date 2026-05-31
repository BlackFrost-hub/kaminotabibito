/** @noSelfInFile */
/**
 * 镜头震动计时器封装
 */

const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
import { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } from "./01．镜头震动";

// 震动时长封装（内部使用计时器）
const cameraTimers: Map<number, number> = new Map();
const cameraShakeTaskIds: number[] = [];
const cameraShakePlayers: any[] = [];
const cameraShakePlayerIds: number[] = [];
const cameraShakeDueMs: number[] = [];
let cameraShakeTaskSeq = 0;
let cameraShakeCallbackId = 0;

function stopCameraShakeCheck(this: void): void {
  if (cameraShakeCallbackId <= 0) return;
  removePeriodicCallback(cameraShakeCallbackId);
  cameraShakeCallbackId = 0;
}

function ensureCameraShakeCheck(this: void): void {
  if (cameraShakeCallbackId > 0) return;
  cameraShakeCallbackId = addPeriodicCallback(10, onCameraShakeCheck);
}

function cancelCameraShakeTask(this: void, taskId: number): void {
  if (!(taskId > 0)) return;
  for (let i = 0; i < cameraShakeTaskIds.length; i++) {
    if (cameraShakeTaskIds[i] === taskId) {
      cameraShakeTaskIds[i] = 0;
      return;
    }
  }
}

function onCameraShakeCheck(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < cameraShakeTaskIds.length; i++) {
    const taskId = cameraShakeTaskIds[i];
    if (!(taskId > 0)) {
      continue;
    }
    if (now >= cameraShakeDueMs[i]) {
      const playerId = cameraShakePlayerIds[i];
      if (cameraTimers.get(playerId) === taskId) {
        CameraClearNoiseForPlayer(cameraShakePlayers[i]);
        cameraTimers.delete(playerId);
      }
    } else {
      cameraShakeTaskIds[writeIndex] = taskId;
      cameraShakePlayers[writeIndex] = cameraShakePlayers[i];
      cameraShakePlayerIds[writeIndex] = cameraShakePlayerIds[i];
      cameraShakeDueMs[writeIndex] = cameraShakeDueMs[i];
      writeIndex += 1;
    }
  }

  for (let i = cameraShakeTaskIds.length - 1; i >= writeIndex; i--) {
    cameraShakeTaskIds.pop();
    cameraShakePlayers.pop();
    cameraShakePlayerIds.pop();
    cameraShakeDueMs.pop();
  }

  if (cameraShakeTaskIds.length <= 0) {
    stopCameraShakeCheck();
  }
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
    cancelCameraShakeTask(existing);
  }
  cameraShakeTaskSeq += 1;
  cameraShakeTaskIds.push(cameraShakeTaskSeq);
  cameraShakePlayers.push(whichPlayer);
  cameraShakePlayerIds.push(playerId);
  cameraShakeDueMs.push(getServerTime() + duration * 1000);
  cameraTimers.set(playerId, cameraShakeTaskSeq);
  ensureCameraShakeCheck();
}
