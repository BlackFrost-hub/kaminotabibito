/**
 * 3D音效播放
 * 在坐标、单位、点位置播放3D音效
 */
const jass = require("jass.common");
import { createSoundInternal, getSoundInternal, getDefaultSoundModel, KEY_COUNT, KEY_INDEX, POOL_MAX, hash } from "./02．音效池";
// 最后播放的音效
export let lastPlayedSound = null;
/**
 * 在坐标处播放3D音效
 * @param path 音效路径
 * @param x X坐标
 * @param y Y坐标
 * @param z Z坐标
 * @param cutoff 裁断距离
 * @param model 声音模型（可选）
 * @returns 播放的音效句柄
 */
export function Sound3DII_CooPlay(path, x, y, z, cutoff, model = getDefaultSoundModel()) {
    const pathHash = jass.StringHash(path);
    let count = jass.LoadInteger(hash, pathHash, KEY_COUNT) || 0;
    let index = jass.LoadInteger(hash, pathHash, KEY_INDEX) || 0;
    if (count > POOL_MAX)
        count = POOL_MAX;
    const slot = index % POOL_MAX;
    let sound;
    if (slot >= count) {
        sound = createSoundInternal(path, cutoff, slot, x, y, z, true, model);
        if (sound) {
            jass.SaveInteger(hash, pathHash, KEY_COUNT, count + 1 > POOL_MAX ? POOL_MAX : count + 1);
            jass.SaveInteger(hash, pathHash, KEY_INDEX, index + 1);
        }
    }
    else {
        sound = getSoundInternal(path, cutoff, slot, x, y, z, model);
        if (sound)
            jass.SaveInteger(hash, pathHash, KEY_INDEX, index + 1);
    }
    if (sound) {
        jass.StartSound(sound);
        lastPlayedSound = sound;
    }
    return sound;
}
/**
 * 在单位位置播放3D音效
 * @param path 音效路径
 * @param unit 目标单位
 * @param cutoff 裁断距离
 * @param model 声音模型（可选）
 */
export function Sound3DII_UnitPlay(path, unit, cutoff, model) {
    const x = jass.GetUnitX(unit);
    const y = jass.GetUnitY(unit);
    const z = jass.GetUnitFlyHeight(unit);
    return Sound3DII_CooPlay(path, x, y, z, cutoff, model);
}
/**
 * 在点位置播放3D音效
 * @param path 音效路径
 * @param loc 位置
 * @param cutoff 裁断距离
 * @param model 声音模型（可选）
 */
export function Sound3DII_LocPlay(path, loc, cutoff, model) {
    const x = jass.GetLocationX(loc);
    const y = jass.GetLocationY(loc);
    const z = jass.GetLocationZ(loc);
    return Sound3DII_CooPlay(path, x, y, z, cutoff, model);
}
