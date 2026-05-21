/**
 * UI音效
 * 按钮点击、键盘等UI音效
 */
const jass = require("jass.common");
import { getDefaultSoundModel } from "./02．音效池";
import { lastPlayedSound } from "./03．3D音效播放";
// 默认按钮点击音效
export const DEFAULT_UI_CLICK_SOUND = "Sound\\Interface\\BigButtonClick.wav";
/** 每 path 一个常驻句柄 */
const soundReuseByPath = {};
/** 该 path 是否已成功 StartSound 过 */
const soundReuseHadStartedByPath = {};
function getOrCreateReuseSound(path) {
    const cache = soundReuseByPath;
    const hit = cache[path];
    if (hit)
        return hit;
    const m = getDefaultSoundModel();
    const s = jass.CreateSound(path, false, false, false, m.fadeInRate, m.fadeOutRate, m.soundType);
    if (s)
        cache[path] = s;
    return s;
}
/**
 * 地图加载时预创建默认 UI 点击句柄
 */
export function prewarmUiClickSound(path = DEFAULT_UI_CLICK_SOUND) {
    getOrCreateReuseSound(path);
}
/**
 * 同一路径重复播放（UI 点击、1 秒内多连同一 wav）
 */
export function Sound3DII_Mp3PlayReuse(path, player = null, model = getDefaultSoundModel()) {
    const p = player === 0 ? null : player;
    const s = getOrCreateReuseSound(path);
    if (!s)
        return;
    jass.SetSoundChannel(s, model.channel);
    jass.SetSoundVolume(s, model.volume);
    jass.SetSoundPitch(s, model.pitch);
    const shouldPlay = !p ||
        jass.GetLocalPlayer() === p;
    if (shouldPlay) {
        const started = soundReuseHadStartedByPath;
        if (started[path]) {
            jass.StopSound(s, false, false);
        }
        else {
            started[path] = true;
        }
        jass.StartSound(s);
    }
    lastPlayedSound = s;
}
/**
 * UI 键盘/点击的统一音效入口
 */
export function SoundUI_ClickPlay(soundPath = DEFAULT_UI_CLICK_SOUND, whichPlayer = null) {
    const p = whichPlayer === 0 ? null : whichPlayer;
    Sound3DII_Mp3PlayReuse(soundPath, p);
}
