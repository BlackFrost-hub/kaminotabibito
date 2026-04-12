/**
 * UI音效
 * 按钮点击、键盘等UI音效
 */

const jass = require("jass.common") as any;

import { SoundModel } from "./01．声音模型";
import { getDefaultSoundModel } from "./02．音效池";
import { lastPlayedSound } from "./03．3D音效播放";

// 默认按钮点击音效
export const DEFAULT_UI_CLICK_SOUND = "Sound\\Interface\\BigButtonClick.wav";

/** 每 path 一个常驻句柄 */
const soundReuseByPath: Record<string, any> = {};
/** 该 path 是否已成功 StartSound 过 */
const soundReuseHadStartedByPath: Record<string, boolean> = {};

function getOrCreateReuseSound(path: string): any {
  const cache = soundReuseByPath as any;
  const hit = cache[path];
  if (hit) return hit;
  if (typeof (jass as any).CreateSound !== "function") return null;
  const m = getDefaultSoundModel();
  const s = (jass as any).CreateSound(
    path,
    false,
    false,
    false,
    m.fadeInRate,
    m.fadeOutRate,
    m.soundType
  );
  if (s) cache[path] = s;
  return s;
}

/**
 * 地图加载时预创建默认 UI 点击句柄
 */
export function prewarmUiClickSound(path: string = DEFAULT_UI_CLICK_SOUND): void {
  getOrCreateReuseSound(path);
}

/**
 * 同一路径重复播放（UI 点击、1 秒内多连同一 wav）
 */
export function Sound3DII_Mp3PlayReuse(
  path: string,
  player: any = null,
  model: SoundModel = getDefaultSoundModel()
): void {
  const p = player === 0 ? null : player;
  const s = getOrCreateReuseSound(path);
  if (!s) return;
  if (typeof (jass as any).SetSoundChannel === "function") (jass as any).SetSoundChannel(s, model.channel);
  if (typeof (jass as any).SetSoundVolume === "function") (jass as any).SetSoundVolume(s, model.volume);
  if (typeof (jass as any).SetSoundPitch === "function") (jass as any).SetSoundPitch(s, model.pitch);
  const shouldPlay =
    !p ||
    (typeof (jass as any).GetLocalPlayer === "function" && (jass as any).GetLocalPlayer() === p);
  if (shouldPlay) {
    const started = soundReuseHadStartedByPath as any;
    if (started[path]) {
      if (typeof (jass as any).StopSound === "function") {
        (jass as any).StopSound(s, false, false);
      }
    } else {
      started[path] = true;
    }
    (jass as any).StartSound(s);
  }
  (lastPlayedSound as any) = s;
}

/**
 * UI 键盘/点击的统一音效入口
 */
export function SoundUI_ClickPlay(soundPath: string = DEFAULT_UI_CLICK_SOUND, whichPlayer: any = null): void {
  const p = whichPlayer === 0 ? null : whichPlayer;
  Sound3DII_Mp3PlayReuse(soundPath, p);
}
