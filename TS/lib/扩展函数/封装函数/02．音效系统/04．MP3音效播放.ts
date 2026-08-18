/** @noSelfInFile */
/**
 * MP3音效播放
 * 播放MP3音效（可指定玩家）
 */

const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

import { SoundModel } from "./01．声音模型";
import { createSoundInternal, getSoundInternal, getDefaultSoundModel, KEY_COUNT, KEY_INDEX, KEY_ENABLED_SLOT_BASE, POOL_MAX, hash } from "./02．音效池";

const { debugLog, setDebug } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
  setDebug: (module: string, on: boolean) => void;
};
setDebug("Sound3DII", false);

// 导入最后播放的音效变量
import { lastPlayedSound } from "./03．3D音效播放";

const soundDestroyFallbackIntervalMs = 10;
const soundDestroyFallbackSounds: any[] = [];
const soundDestroyFallbackDueMs: number[] = [];
let soundDestroyFallbackCallbackId = 0;

function stopSoundDestroyFallbackCheck(this: void): void {
  if (soundDestroyFallbackCallbackId <= 0) return;
  removePeriodicCallback(soundDestroyFallbackCallbackId);
  soundDestroyFallbackCallbackId = 0;
}

function ensureSoundDestroyFallbackCheck(this: void): void {
  if (soundDestroyFallbackCallbackId > 0) return;
  soundDestroyFallbackCallbackId = addPeriodicCallback(soundDestroyFallbackIntervalMs, onSoundDestroyFallbackCheck);
}

function onSoundDestroyFallbackCheck(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < soundDestroyFallbackSounds.length; i++) {
    const sound = soundDestroyFallbackSounds[i];
    if (now >= soundDestroyFallbackDueMs[i]) {
      (jass as any).DestroySound(sound);
    } else {
      soundDestroyFallbackSounds[writeIndex] = sound;
      soundDestroyFallbackDueMs[writeIndex] = soundDestroyFallbackDueMs[i];
      writeIndex += 1;
    }
  }
  for (let i = soundDestroyFallbackSounds.length - 1; i >= writeIndex; i--) {
    soundDestroyFallbackSounds.pop();
    soundDestroyFallbackDueMs.pop();
  }
  if (soundDestroyFallbackSounds.length <= 0) {
    stopSoundDestroyFallbackCheck();
  }
}

/**
 * 无 KillSoundWhenDone 时的兜底：定时 DestroySound，避免 CreateSound 句柄堆积
 */
function scheduleDestroySoundIfNeeded(sound: any): void {
  if (!sound) return;
  soundDestroyFallbackSounds.push(sound);
  soundDestroyFallbackDueMs.push(getServerTime() + 550);
  ensureSoundDestroyFallbackCheck();
}

/**
 * 播放MP3音效（可指定玩家）
 *
 * 多实例叠放入口：严格使用音效池最多 4 个句柄轮转（同路径同时刻最多 4 声叠放）。
 * 句柄只在首次占槽时 CreateSound，之后一律复用，绝不每次播放新建句柄（防泄漏）；
 * 4 槽全占满时轮转复用最早的槽（Stop 后重播），不会创建第 5 个。
 * 不需要叠放的高频同路径音效请用 Sound3DII_Mp3PlayReuse（单句柄）。
 *
 * @param path 音效路径
 * @param player 指定玩家（为null时所有玩家都能听到）
 * @param model 声音模型（可选）
 */
export function Sound3DII_Mp3Play(
  path: string,
  player: any = null,
  model: SoundModel = getDefaultSoundModel()
): any {
  // 严格 4 槽池：slot = 轮转下标 % POOL_MAX；槽未建则 CreateSound（每路径每槽终生一次），已建则复用
  const pathHash = (jass as any).StringHash(path);
  let count = (jass as any).LoadInteger(hash, pathHash, KEY_COUNT) || 0;
  if (count > POOL_MAX) count = POOL_MAX;
  let index = (jass as any).LoadInteger(hash, pathHash, KEY_INDEX) || 0;
  const slot = index % POOL_MAX;

  let sound: any = null;
  if (slot >= count) {
    // 首次占槽：新建并登记（每路径最多 4 次）
    sound = createSoundInternal(path, 4000, slot, 0, 0, 0, false, model);
    if (sound) {
      (jass as any).SaveInteger(hash, pathHash, KEY_COUNT, count + 1);
      (jass as any).SaveInteger(hash, pathHash, KEY_INDEX, index + 1);
    }
  } else {
    // 复用已有句柄（含 4 槽全占满时的轮转，绝不新建第 5 个）
    sound = getSoundInternal(path, 4000, slot, 0, 0, 0, model);
    if (sound) {
      (jass as any).SaveInteger(hash, pathHash, KEY_INDEX, index + 1);
      (jass as any).StopSound(sound, false, false); // 打断该槽上一声再重播
    }
  }

  if (sound) {
    (jass as any).SetSoundChannel(sound, model.channel);
    (jass as any).SetSoundVolume(sound, model.volume);
    (jass as any).SetSoundPitch(sound, model.pitch);
    const shouldPlay =
      !player ||
      (jass as any).GetLocalPlayer() === player;
    if (shouldPlay) (jass as any).StartSound(sound);
    (lastPlayedSound as any) = sound;
    debugLog("Sound3DII", "pool slot=", slot, "count=", count, "localPlay=", shouldPlay);
  }

  return sound;
}
