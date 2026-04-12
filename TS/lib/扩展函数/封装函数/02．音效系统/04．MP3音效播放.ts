/**
 * MP3音效播放
 * 播放MP3音效（可指定玩家）
 */

const jass = require("jass.common") as any;

import { SoundModel } from "./01．声音模型";
import { createSoundInternal, getSoundInternal, getDefaultSoundModel, KEY_COUNT, KEY_ENABLED_SLOT_BASE, POOL_MAX, hash } from "./02．音效池";

const DEBUG_SOUND = false;

// 导入最后播放的音效变量
import { lastPlayedSound } from "./03．3D音效播放";

/**
 * 无 KillSoundWhenDone 时的兜底：定时 DestroySound，避免 CreateSound 句柄堆积
 */
function scheduleDestroySoundIfNeeded(sound: any): void {
  if (!sound) return;
  if (typeof (jass as any).DestroySound !== "function" || typeof (jass as any).TimerStart !== "function") return;
  const Leak = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher?: any };
  const LW = Leak && Leak.LeakWatcher ? Leak.LeakWatcher : undefined;
  const t =
    LW && typeof LW.createTimer === "function"
      ? LW.createTimer("sound_ui_fallback_destroy")
      : typeof (jass as any).CreateTimer === "function"
        ? (jass as any).CreateTimer()
        : null;
  if (!t) return;
  (jass as any).TimerStart(t, 0.55, false, () => {
    const expired = (jass as any).GetExpiredTimer();
    (jass as any).DestroySound(sound);
    if (LW && typeof LW.destroyTimer === "function") {
      LW.destroyTimer(expired);
    } else if (typeof (jass as any).DestroyTimer === "function") {
      (jass as any).DestroyTimer(expired);
    }
  });
}

/**
 * 播放MP3音效（可指定玩家）
 * @param path 音效路径
 * @param player 指定玩家（为null时所有玩家都能听到）
 * @param model 声音模型（可选）
 */
export function Sound3DII_Mp3Play(
  path: string,
  player: any = null,
  model: SoundModel = getDefaultSoundModel()
): any {
  // 1.27 下 UI 音效频繁播放容易触发"池/通道限制"。这里改为：每次新建 sound，并 KillSoundWhenDone
  if (typeof (jass as any).CreateSound === "function" && typeof (jass as any).StartSound === "function") {
    const Leak = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher?: any };
    const LW = Leak && Leak.LeakWatcher ? Leak.LeakWatcher : undefined;
    let trackedByLeak = false;
    let s: any = null;
    if (LW && typeof LW.createSound === "function") {
      s = LW.createSound(
        "sound_mp3",
        path,
        false,
        false,
        false,
        model.fadeInRate,
        model.fadeOutRate,
        model.soundType
      );
      if (s) trackedByLeak = true;
    } else {
      s = (jass as any).CreateSound(
        path,
        false,
        false,
        false,
        model.fadeInRate,
        model.fadeOutRate,
        model.soundType
      );
    }
    if (s) {
      if (typeof (jass as any).SetSoundChannel === "function") (jass as any).SetSoundChannel(s, model.channel);
      if (typeof (jass as any).SetSoundVolume === "function") (jass as any).SetSoundVolume(s, model.volume);
      if (typeof (jass as any).SetSoundPitch === "function") (jass as any).SetSoundPitch(s, model.pitch);

      const shouldPlay =
        !player ||
        (typeof (jass as any).GetLocalPlayer === "function" && (jass as any).GetLocalPlayer() === player);
      if (shouldPlay) (jass as any).StartSound(s);

      if (LW && typeof LW.killSoundWhenDone === "function") {
        LW.killSoundWhenDone(s);
      } else if (typeof (jass as any).KillSoundWhenDone === "function") {
        (jass as any).KillSoundWhenDone(s);
        if (trackedByLeak && LW && typeof LW.releaseSound === "function") {
          LW.releaseSound(s);
        }
      } else {
        scheduleDestroySoundIfNeeded(s);
        if (trackedByLeak && LW && typeof LW.releaseSound === "function") {
          LW.releaseSound(s);
        }
      }

      (lastPlayedSound as any) = s;
      if (DEBUG_SOUND && (globalThis as any).print) (globalThis as any).print("[Sound3DII_Mp3Play] new sound, localPlay=", shouldPlay);
      return s;
    }
  }

  const pathHash = (jass as any).StringHash(path);
  let count = (jass as any).LoadInteger(hash, pathHash, KEY_COUNT) || 0;
  if (count > POOL_MAX) count = POOL_MAX;

  let availableIndex = -1;
  for (let i = 0; i < count; i++) {
    if ((jass as any).LoadBoolean(hash, pathHash, i + KEY_ENABLED_SLOT_BASE)) {
      availableIndex = i;
      break;
    }
  }

  let sound: any;
  if (availableIndex === -1) {
    if (count >= POOL_MAX) return null;
    sound = createSoundInternal(path, 4000, count, 0, 0, 0, false, model);
    if (sound) (jass as any).SaveInteger(hash, pathHash, KEY_COUNT, count + 1);
  } else {
    sound = getSoundInternal(path, 4000, availableIndex, 0, 0, 0, model);
  }

  if (sound) {
    if (player) {
      if ((jass as any).GetLocalPlayer() === player) (jass as any).StartSound(sound);
    } else {
      (jass as any).StartSound(sound);
    }
    (lastPlayedSound as any) = sound;
  }

  return sound;
}
