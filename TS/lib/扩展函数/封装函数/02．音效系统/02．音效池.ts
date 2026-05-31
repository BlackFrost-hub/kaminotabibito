/** @noSelfInFile */
/**
 * 音效池管理
 * 同一音效路径最多4个同时播放
 */

const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const hash = (jass as any).InitHashtable();

// 哈希表键值常量
const KEY_COUNT = 1000;
const KEY_INDEX = 1001;
const KEY_PATH = 1004;
const KEY_ENABLED = 1005;
const KEY_ENABLED_SLOT_BASE = 2000;

const POOL_MAX = 4;

import { SoundModel } from "./01．声音模型";

const soundPoolReleaseTaskIds: number[] = [];
const soundPoolReleaseSounds: any[] = [];
const soundPoolReleaseDueMs: number[] = [];
const soundPoolReleaseTaskBySoundHid: Record<number, number> = {};
let soundPoolReleaseTaskSeq = 0;
let soundPoolReleaseCallbackId = 0;

function stopSoundPoolReleaseCheck(this: void): void {
  if (soundPoolReleaseCallbackId <= 0) return;
  removePeriodicCallback(soundPoolReleaseCallbackId);
  soundPoolReleaseCallbackId = 0;
}

function ensureSoundPoolReleaseCheck(this: void): void {
  if (soundPoolReleaseCallbackId > 0) return;
  soundPoolReleaseCallbackId = addPeriodicCallback(10, onSoundPoolReleaseCheck);
}

function cancelSoundPoolReleaseTask(this: void, taskId: number): void {
  if (!(taskId > 0)) return;
  for (let i = 0; i < soundPoolReleaseTaskIds.length; i++) {
    if (soundPoolReleaseTaskIds[i] === taskId) {
      soundPoolReleaseTaskIds[i] = 0;
      return;
    }
  }
}

function releaseSoundPoolSlot(this: void, sound: any, taskId: number): void {
  if (!sound) return;
  const soundHid = (jass as any).GetHandleId(sound);
  if (soundPoolReleaseTaskBySoundHid[soundHid] !== taskId) return;
  delete soundPoolReleaseTaskBySoundHid[soundHid];
  const idx = (jass as any).LoadInteger(hash, soundHid, KEY_INDEX);
  const p = (jass as any).LoadStr(hash, soundHid, KEY_PATH);
  const ph = (jass as any).StringHash(p);
  (jass as any).SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true);
}

function onSoundPoolReleaseCheck(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < soundPoolReleaseTaskIds.length; i++) {
    const taskId = soundPoolReleaseTaskIds[i];
    if (!(taskId > 0)) {
      continue;
    }
    if (now >= soundPoolReleaseDueMs[i]) {
      releaseSoundPoolSlot(soundPoolReleaseSounds[i], taskId);
    } else {
      soundPoolReleaseTaskIds[writeIndex] = taskId;
      soundPoolReleaseSounds[writeIndex] = soundPoolReleaseSounds[i];
      soundPoolReleaseDueMs[writeIndex] = soundPoolReleaseDueMs[i];
      writeIndex += 1;
    }
  }

  for (let i = soundPoolReleaseTaskIds.length - 1; i >= writeIndex; i--) {
    soundPoolReleaseTaskIds.pop();
    soundPoolReleaseSounds.pop();
    soundPoolReleaseDueMs.pop();
  }

  if (soundPoolReleaseTaskIds.length <= 0) {
    stopSoundPoolReleaseCheck();
  }
}

function scheduleSoundPoolRelease(this: void, sound: any, duration: number): void {
  if (!sound) return;
  const soundHid = (jass as any).GetHandleId(sound);
  const oldTaskId = soundPoolReleaseTaskBySoundHid[soundHid] ?? 0;
  if (oldTaskId > 0) cancelSoundPoolReleaseTask(oldTaskId);
  soundPoolReleaseTaskSeq += 1;
  soundPoolReleaseTaskBySoundHid[soundHid] = soundPoolReleaseTaskSeq;
  soundPoolReleaseTaskIds.push(soundPoolReleaseTaskSeq);
  soundPoolReleaseSounds.push(sound);
  soundPoolReleaseDueMs.push(getServerTime() + duration * 1000);
  ensureSoundPoolReleaseCheck();
}

// 默认音效模型
let defaultSoundModel: SoundModel;

export function setDefaultSoundModel(model: SoundModel): void {
  defaultSoundModel = model;
}

export function getDefaultSoundModel(): SoundModel {
  return defaultSoundModel;
}

/**
 * 创建新音效（内部使用）
 */
export function createSoundInternal(
  path: string,
  cutoff: number,
  index: number,
  x: number,
  y: number,
  z: number,
  is3d: boolean,
  model: SoundModel = defaultSoundModel
): any {
  const sound = (jass as any).CreateSound(
    path,
    false,
    is3d,
    false,
    model.fadeInRate,
    model.fadeOutRate,
    model.soundType
  );

  if (!sound) return null;

  model.applyToSound(sound, x, y, z, cutoff);

  const pathHash = (jass as any).StringHash(path);
  (jass as any).SaveSoundHandle(hash, pathHash, index, sound);
  (jass as any).SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false);
  (jass as any).SaveInteger(hash, (jass as any).GetHandleId(sound), KEY_INDEX, index);
  (jass as any).SaveStr(hash, (jass as any).GetHandleId(sound), KEY_PATH, path);

  let duration = (jass as any).GetSoundFileDuration(path) * 0.001;
  if (duration <= 0 || duration > 3600) duration = 1;
  scheduleSoundPoolRelease(sound, duration);

  return sound;
}

/**
 * 获取已存在的音效（内部使用）
 */
export function getSoundInternal(
  path: string,
  cutoff: number,
  index: number,
  x: number,
  y: number,
  z: number,
  model: SoundModel = defaultSoundModel
): any {
  const pathHash = (jass as any).StringHash(path);
  const sound = (jass as any).LoadSoundHandle(hash, pathHash, index);

  if (!sound) return null;

  model.applyToSound(sound, x, y, z, cutoff);

  let duration = (jass as any).GetSoundFileDuration(path) * 0.001;
  if (duration <= 0 || duration > 3600) duration = 1;
  scheduleSoundPoolRelease(sound, duration);

  (jass as any).SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false);

  return sound;
}

// 导出常量供其他模块使用
export { hash, KEY_COUNT, KEY_INDEX, KEY_ENABLED_SLOT_BASE, POOL_MAX };
