/**
 * 泄露审计 - 音效
 */
const jass = require("jass.common");
import { track, untrack } from "./01．核心统计";
/** 创建音效：建议搭配 killSoundWhenDone 或 stopSoundAndKill 使用 */
export function createSound(tag, fileName, looping, is3D, stopwhenoutofrange, fadeInRate, fadeOutRate, eaxSetting) {
    const s = jass.CreateSound(fileName, looping, is3D, stopwhenoutofrange, fadeInRate, fadeOutRate, eaxSetting);
    track("sound", s, tag);
    return s;
}
/** 标记音效播放完成后销毁，并在本审计中释放引用 */
export function killSoundWhenDone(s) {
    if (!s)
        return;
    jass.KillSoundWhenDone(s);
    // 引擎会在播放完后真正释放；审计层面在这里就算"已回收"，避免 -leak 中 sound 一直堆
    untrack("sound", s);
}
/**
 * 仅取消 sound 的审计计数（句柄已由 KillSoundWhenDone/DestroySound 等处理时使用）。
 * 用于 `音效函数` 中「createSound + 非 killSoundWhenDone 分支」避免漏 untrack。
 */
export function releaseSound(s) {
    untrack("sound", s);
}
/** 立刻停止并销毁（更激进，适合需要马上释放时） */
export function stopSoundAndKill(s, killWhenDone = true, fadeOut = false) {
    if (!s)
        return;
    jass.StopSound(s, killWhenDone, fadeOut);
    untrack("sound", s);
}
