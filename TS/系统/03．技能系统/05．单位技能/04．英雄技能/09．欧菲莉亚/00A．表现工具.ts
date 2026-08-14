/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

export function 播放欧菲莉亚单位音效(this: void, unit: any, soundKey: string): void {
  if (unit == null || unit === 0 || soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  jass.AttachSoundToUnit(sound, unit);
  jass.SetSoundVolume(sound, 127);
  jass.StartSound(sound);
}

export function 播放欧菲莉亚配置动作(this: void, unit: any, animationIndex: number, timeScale: number): void {
  if (unit == null || unit === 0 || animationIndex < 0) return;
  jass.SetUnitTimeScale(unit, timeScale);
  jass.SetUnitAnimationByIndex(unit, animationIndex);
}

export {};
