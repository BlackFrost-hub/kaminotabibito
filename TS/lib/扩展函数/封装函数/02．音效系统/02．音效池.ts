/** @noSelfInFile */
/**
 * 音效池管理
 * 同一音效路径最多4个同时播放
 */

const jass = require("jass.common") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};
const hash = (jass as any).InitHashtable();

// 哈希表键值常量
const KEY_COUNT = 1000;
const KEY_INDEX = 1001;
const KEY_TIMER = 1002;
const KEY_SOUND = 1003;
const KEY_PATH = 1004;
const KEY_ENABLED = 1005;
const KEY_ENABLED_SLOT_BASE = 2000;

const POOL_MAX = 4;

import { SoundModel } from "./01．声音模型";

function onSoundPoolTimerExpire(this: void): void {
  const expiredTimer = (jass as any).GetExpiredTimer();
  const s = (jass as any).LoadSoundHandle(hash, (jass as any).GetHandleId(expiredTimer), KEY_SOUND);
  if (s) {
    const idx = (jass as any).LoadInteger(hash, (jass as any).GetHandleId(s), KEY_INDEX);
    const p = (jass as any).LoadStr(hash, (jass as any).GetHandleId(s), KEY_PATH);
    const ph = (jass as any).StringHash(p);
    (jass as any).SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true);
  }
  safeDestroyTimer(expiredTimer);
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
  const timer = (jass as any).CreateTimer();
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
  (jass as any).SaveTimerHandle(hash, (jass as any).GetHandleId(sound), KEY_TIMER, timer);
  (jass as any).SaveSoundHandle(hash, (jass as any).GetHandleId(timer), KEY_SOUND, sound);
  (jass as any).SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false);
  (jass as any).SaveInteger(hash, (jass as any).GetHandleId(sound), KEY_INDEX, index);
  (jass as any).SaveStr(hash, (jass as any).GetHandleId(sound), KEY_PATH, path);

  let duration = (jass as any).GetSoundFileDuration(path) * 0.001;
  if (duration <= 0 || duration > 3600) duration = 1;
  safeTimerStart(timer, duration, false, onSoundPoolTimerExpire);

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

  const timer = (jass as any).LoadTimerHandle(hash, (jass as any).GetHandleId(sound), KEY_TIMER);

  model.applyToSound(sound, x, y, z, cutoff);

  if (timer) {
    safeDestroyTimer(timer);
    const newTimer = (jass as any).CreateTimer();
    (jass as any).SaveTimerHandle(hash, (jass as any).GetHandleId(sound), KEY_TIMER, newTimer);
    (jass as any).SaveSoundHandle(hash, (jass as any).GetHandleId(newTimer), KEY_SOUND, sound);

    let duration = (jass as any).GetSoundFileDuration(path) * 0.001;
    if (duration <= 0 || duration > 3600) duration = 1;
    safeTimerStart(newTimer, duration, false, onSoundPoolTimerExpire);
  }

  (jass as any).SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false);

  return sound;
}

// 导出常量供其他模块使用
export { hash, KEY_COUNT, KEY_INDEX, KEY_ENABLED_SLOT_BASE, POOL_MAX };
