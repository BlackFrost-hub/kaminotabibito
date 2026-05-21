/** @noSelfInFile */
/**
 * 音效池管理
 * 同一音效路径最多4个同时播放
 */
const jass = require("jass.common");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
const hash = jass.InitHashtable();
// 哈希表键值常量
const KEY_COUNT = 1000;
const KEY_INDEX = 1001;
const KEY_TIMER = 1002;
const KEY_SOUND = 1003;
const KEY_PATH = 1004;
const KEY_ENABLED = 1005;
const KEY_ENABLED_SLOT_BASE = 2000;
const POOL_MAX = 4;
function onSoundPoolTimerExpire() {
    const expiredTimer = jass.GetExpiredTimer();
    const s = jass.LoadSoundHandle(hash, jass.GetHandleId(expiredTimer), KEY_SOUND);
    if (s) {
        const idx = jass.LoadInteger(hash, jass.GetHandleId(s), KEY_INDEX);
        const p = jass.LoadStr(hash, jass.GetHandleId(s), KEY_PATH);
        const ph = jass.StringHash(p);
        jass.SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true);
    }
    safeDestroyTimer(expiredTimer);
}
// 默认音效模型
let defaultSoundModel;
export function setDefaultSoundModel(model) {
    defaultSoundModel = model;
}
export function getDefaultSoundModel() {
    return defaultSoundModel;
}
/**
 * 创建新音效（内部使用）
 */
export function createSoundInternal(path, cutoff, index, x, y, z, is3d, model = defaultSoundModel) {
    const timer = jass.CreateTimer();
    const sound = jass.CreateSound(path, false, is3d, false, model.fadeInRate, model.fadeOutRate, model.soundType);
    if (!sound)
        return null;
    model.applyToSound(sound, x, y, z, cutoff);
    const pathHash = jass.StringHash(path);
    jass.SaveSoundHandle(hash, pathHash, index, sound);
    jass.SaveTimerHandle(hash, jass.GetHandleId(sound), KEY_TIMER, timer);
    jass.SaveSoundHandle(hash, jass.GetHandleId(timer), KEY_SOUND, sound);
    jass.SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false);
    jass.SaveInteger(hash, jass.GetHandleId(sound), KEY_INDEX, index);
    jass.SaveStr(hash, jass.GetHandleId(sound), KEY_PATH, path);
    let duration = jass.GetSoundFileDuration(path) * 0.001;
    if (duration <= 0 || duration > 3600)
        duration = 1;
    safeTimerStart(timer, duration, false, onSoundPoolTimerExpire);
    return sound;
}
/**
 * 获取已存在的音效（内部使用）
 */
export function getSoundInternal(path, cutoff, index, x, y, z, model = defaultSoundModel) {
    const pathHash = jass.StringHash(path);
    const sound = jass.LoadSoundHandle(hash, pathHash, index);
    if (!sound)
        return null;
    const timer = jass.LoadTimerHandle(hash, jass.GetHandleId(sound), KEY_TIMER);
    model.applyToSound(sound, x, y, z, cutoff);
    if (timer) {
        safeDestroyTimer(timer);
        const newTimer = jass.CreateTimer();
        jass.SaveTimerHandle(hash, jass.GetHandleId(sound), KEY_TIMER, newTimer);
        jass.SaveSoundHandle(hash, jass.GetHandleId(newTimer), KEY_SOUND, sound);
        let duration = jass.GetSoundFileDuration(path) * 0.001;
        if (duration <= 0 || duration > 3600)
            duration = 1;
        safeTimerStart(newTimer, duration, false, onSoundPoolTimerExpire);
    }
    jass.SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false);
    return sound;
}
// 导出常量供其他模块使用
export { hash, KEY_COUNT, KEY_INDEX, KEY_ENABLED_SLOT_BASE, POOL_MAX };
