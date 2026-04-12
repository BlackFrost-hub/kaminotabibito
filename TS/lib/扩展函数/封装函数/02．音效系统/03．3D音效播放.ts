/**
 * 3D音效播放
 * 在坐标、单位、点位置播放3D音效
 */

const jass = require("jass.common") as any;

import { SoundModel } from "./01．声音模型";
import { createSoundInternal, getSoundInternal, getDefaultSoundModel, KEY_COUNT, KEY_INDEX, KEY_ENABLED_SLOT_BASE, POOL_MAX, hash } from "./02．音效池";

// 最后播放的音效
export let lastPlayedSound: any = null;

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
export function Sound3DII_CooPlay(
  path: string,
  x: number,
  y: number,
  z: number,
  cutoff: number,
  model: SoundModel = getDefaultSoundModel()
): any {
  const pathHash = (jass as any).StringHash(path);
  let count = (jass as any).LoadInteger(hash, pathHash, KEY_COUNT) || 0;
  let index = (jass as any).LoadInteger(hash, pathHash, KEY_INDEX) || 0;
  if (count > POOL_MAX) count = POOL_MAX;
  const slot = index % POOL_MAX;

  let sound: any;
  if (slot >= count) {
    sound = createSoundInternal(path, cutoff, slot, x, y, z, true, model);
    if (sound) {
      (jass as any).SaveInteger(hash, pathHash, KEY_COUNT, count + 1 > POOL_MAX ? POOL_MAX : count + 1);
      (jass as any).SaveInteger(hash, pathHash, KEY_INDEX, index + 1);
    }
  } else {
    sound = getSoundInternal(path, cutoff, slot, x, y, z, model);
    if (sound) (jass as any).SaveInteger(hash, pathHash, KEY_INDEX, index + 1);
  }

  if (sound) {
    (jass as any).StartSound(sound);
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
export function Sound3DII_UnitPlay(
  path: string,
  unit: any,
  cutoff: number,
  model?: SoundModel
): any {
  const x = (jass as any).GetUnitX(unit);
  const y = (jass as any).GetUnitY(unit);
  const z = (jass as any).GetUnitFlyHeight(unit);
  return Sound3DII_CooPlay(path, x, y, z, cutoff, model);
}

/**
 * 在点位置播放3D音效
 * @param path 音效路径
 * @param loc 位置
 * @param cutoff 裁断距离
 * @param model 声音模型（可选）
 */
export function Sound3DII_LocPlay(
  path: string,
  loc: any,
  cutoff: number,
  model?: SoundModel
): any {
  const x = (jass as any).GetLocationX(loc);
  const y = (jass as any).GetLocationY(loc);
  const z = (jass as any).GetLocationZ(loc);
  return Sound3DII_CooPlay(path, x, y, z, cutoff, model);
}
