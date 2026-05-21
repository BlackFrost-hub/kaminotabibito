/**
 * 3D音效系统 - 组合入口；实现在 01–06 子模块。
 * 对应 JASS 的 Sound3DII 库，不使用任何 BJ 函数。
 */
export * from "./01．声音模型";
export * from "./03．3D音效播放";
export * from "./04．MP3音效播放";
export * from "./05．UI音效";
export * from "./06．参数设置";
import { SoundModel } from "./01．声音模型";
import { setDefaultSoundModel } from "./02．音效池";
import { DEFAULT_UI_CLICK_SOUND, prewarmUiClickSound } from "./05．UI音效";
export function initSound3DII() {
    setDefaultSoundModel(SoundModel.create());
    prewarmUiClickSound(DEFAULT_UI_CLICK_SOUND);
}
initSound3DII();
