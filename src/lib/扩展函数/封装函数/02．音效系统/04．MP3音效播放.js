/** @noSelfInFile */
/**
 * MP3音效播放
 * 播放MP3音效（可指定玩家）
 */
const jass = require("jass.common");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
import { createSoundInternal, getSoundInternal, getDefaultSoundModel, KEY_COUNT, KEY_ENABLED_SLOT_BASE, POOL_MAX, hash } from "./02．音效池";
const { debugLog, setDebug } = require("lib.扩展函数.自定义扩展函数.index");
setDebug("Sound3DII", false);
// 导入最后播放的音效变量
import { lastPlayedSound } from "./03．3D音效播放";
const soundDestroyFallbackByTimerHid = {};
function onSoundDestroyFallbackTimerExpire() {
    const expired = jass.GetExpiredTimer();
    const hid = jass.GetHandleId(expired);
    const sound = soundDestroyFallbackByTimerHid[hid];
    delete soundDestroyFallbackByTimerHid[hid];
    jass.DestroySound(sound);
    const Leak = require("lib.扩展函数.封装函数.05．泄露审计.index");
    if (Leak && Leak.LeakWatcher && typeof Leak.LeakWatcher.destroyTimer === "function") {
        Leak.LeakWatcher.destroyTimer(expired);
    }
    else {
        safeDestroyTimer(expired);
    }
}
/**
 * 无 KillSoundWhenDone 时的兜底：定时 DestroySound，避免 CreateSound 句柄堆积
 */
function scheduleDestroySoundIfNeeded(sound) {
    if (!sound)
        return;
    const Leak = require("lib.扩展函数.封装函数.05．泄露审计.index");
    const LW = Leak && Leak.LeakWatcher ? Leak.LeakWatcher : undefined;
    const t = LW && typeof LW.createTimer === "function"
        ? LW.createTimer("sound_ui_fallback_destroy")
        : jass.CreateTimer();
    if (!t)
        return;
    soundDestroyFallbackByTimerHid[jass.GetHandleId(t)] = sound;
    safeTimerStart(t, 0.55, false, onSoundDestroyFallbackTimerExpire);
}
/**
 * 播放MP3音效（可指定玩家）
 * @param path 音效路径
 * @param player 指定玩家（为null时所有玩家都能听到）
 * @param model 声音模型（可选）
 */
export function Sound3DII_Mp3Play(path, player = null, model = getDefaultSoundModel()) {
    // 1.27 下 UI 音效频繁播放容易触发"池/通道限制"。这里改为：每次新建 sound，并 KillSoundWhenDone
    {
        const Leak = require("lib.扩展函数.封装函数.05．泄露审计.index");
        const LW = Leak && Leak.LeakWatcher ? Leak.LeakWatcher : undefined;
        let trackedByLeak = false;
        let s = null;
        if (LW && typeof LW.createSound === "function") {
            s = LW.createSound("sound_mp3", path, false, false, false, model.fadeInRate, model.fadeOutRate, model.soundType);
            if (s)
                trackedByLeak = true;
        }
        else {
            s = jass.CreateSound(path, false, false, false, model.fadeInRate, model.fadeOutRate, model.soundType);
        }
        if (s) {
            jass.SetSoundChannel(s, model.channel);
            jass.SetSoundVolume(s, model.volume);
            jass.SetSoundPitch(s, model.pitch);
            const shouldPlay = !player ||
                jass.GetLocalPlayer() === player;
            if (shouldPlay)
                jass.StartSound(s);
            if (LW && typeof LW.killSoundWhenDone === "function") {
                LW.killSoundWhenDone(s);
            }
            else {
                jass.KillSoundWhenDone(s);
                if (trackedByLeak && LW && typeof LW.releaseSound === "function") {
                    LW.releaseSound(s);
                }
            }
            lastPlayedSound = s;
            debugLog("Sound3DII", "new sound, localPlay=", shouldPlay);
            return s;
        }
    }
    const pathHash = jass.StringHash(path);
    let count = jass.LoadInteger(hash, pathHash, KEY_COUNT) || 0;
    if (count > POOL_MAX)
        count = POOL_MAX;
    let availableIndex = -1;
    for (let i = 0; i < count; i++) {
        if (jass.LoadBoolean(hash, pathHash, i + KEY_ENABLED_SLOT_BASE)) {
            availableIndex = i;
            break;
        }
    }
    let sound;
    if (availableIndex === -1) {
        if (count >= POOL_MAX)
            return null;
        sound = createSoundInternal(path, 4000, count, 0, 0, 0, false, model);
        if (sound)
            jass.SaveInteger(hash, pathHash, KEY_COUNT, count + 1);
    }
    else {
        sound = getSoundInternal(path, 4000, availableIndex, 0, 0, 0, model);
    }
    if (sound) {
        if (player) {
            if (jass.GetLocalPlayer() === player)
                jass.StartSound(sound);
        }
        else {
            jass.StartSound(sound);
        }
        lastPlayedSound = sound;
    }
    return sound;
}
