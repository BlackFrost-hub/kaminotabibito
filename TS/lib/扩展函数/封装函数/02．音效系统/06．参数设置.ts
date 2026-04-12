/**
 * 音效参数设置
 * 设置默认声音模型的各项参数
 */

import { SoundModel, getSoundTypeByID } from "./01．声音模型";
import { getDefaultSoundModel } from "./02．音效池";

/**
 * 设置声音效果类型
 * @param id 1=战斗,2=战鼓,3=魔法,4=投射物,5=英雄语音,6=装饰物
 */
export function Sound3DII_SetSoundTypeByID(id: number): void {
  getDefaultSoundModel().soundType = getSoundTypeByID(id);
}

/**
 * 设置声音通道 (0-14)
 */
export function Sound3DII_SetChannel(channel: number): void {
  if (channel > 14) channel = 0;
  getDefaultSoundModel().channel = channel;
}

/**
 * 设置音量 (0-127)
 */
export function Sound3DII_SetVolume(volume: number): void {
  if (volume > 127) volume = 127;
  if (volume < 0) volume = 0;
  getDefaultSoundModel().volume = volume;
}

/**
 * 设置声音衰减距离
 */
export function Sound3DII_SetDistances(min: number, max: number): void {
  getDefaultSoundModel().sd.set(min, max);
}

/**
 * 设置声音方向
 */
export function Sound3DII_SetConeOrientation(x: number, y: number, z: number): void {
  getDefaultSoundModel().sco.set(x, y, z);
}

/**
 * 设置声音速度
 */
export function Sound3DII_SetVelocity(x: number, y: number, z: number): void {
  getDefaultSoundModel().sv.set(x, y, z);
}

/**
 * 设置声音锥形角度
 */
export function Sound3DII_SetConeAngle(inside: number, outside: number, volume: number): void {
  getDefaultSoundModel().ca.set(inside, outside, volume);
}

/**
 * 设置淡入速率
 */
export function Sound3DII_SetFadeInRate(rate: number): void {
  getDefaultSoundModel().fadeInRate = rate;
}

/**
 * 设置淡出速率
 */
export function Sound3DII_SetFadeOutRate(rate: number): void {
  getDefaultSoundModel().fadeOutRate = rate;
}

/**
 * 获取最后播放的音效
 */
export function Sound3DII_GetLastPlayedSound(): any {
  const { lastPlayedSound } = require("./03．3D音效播放") as { lastPlayedSound: any };
  return lastPlayedSound;
}
