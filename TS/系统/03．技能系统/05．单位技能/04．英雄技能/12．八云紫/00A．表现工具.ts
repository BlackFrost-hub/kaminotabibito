/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

export function 播放八云紫单位音效(this: void, unit: any, soundKey: string, restart: boolean = false): void {
  if (unit == null || unit === 0 || soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  if (restart) jass.StopSound(sound, false, false);
  jass.AttachSoundToUnit(sound, unit);
  jass.SetSoundVolume(sound, 127);
  jass.StartSound(sound);
}

export function 播放八云紫随机单位音效(this: void, unit: any, soundKeys: readonly string[]): void {
  if (soundKeys.length <= 0) return;
  const randomIndex = jass.GetRandomInt(1, soundKeys.length);
  播放八云紫单位音效(unit, soundKeys[randomIndex - 1]);
}

export {};
