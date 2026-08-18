/** @noSelfInFile */

/**
 * 铃仙 - 表现工具
 *
 * 音效走 Sound3DII 单句柄复用；地图预载全局音效（gg_snd_LX_*）走 StartSound；
 * 动作走 SetUnitAnimationByIndex + SetUnitTimeScale。
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
};
const { AttachSoundToUnit } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  AttachSoundToUnit: (this: void, soundHandle: any, whichUnit: any) => void;
};

/** 播放单位绑定音效（音量百分比，对应 JASS PlaySoundOnUnitBJ） */
export function 播放铃仙单位绑定音效(this: void, 单位: any, soundKey: string, volumePercent: number): void {
  if (单位 == null || 单位 === 0 || soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  PlaySoundOnUnitBJ(sound, volumePercent, 单位);
}

/** 播放坐标 3D 音效（单句柄复用，不扩池） */
export function 播放铃仙坐标音效(this: void, path: string, x: number, y: number, cutoff: number): void {
  if (path === "") return;
  Sound3DII_CooPlayReuse(path, x, y, 0, cutoff);
}

/** 播放单位坐标 3D 音效 */
export function 播放铃仙单位音效(this: void, unit: any, path: string, cutoff: number): void {
  if (unit == null || unit === 0 || path === "") return;
  Sound3DII_CooPlayReuse(path, jass.GetUnitX(unit), jass.GetUnitY(unit), 0, cutoff);
}

/** 播放地图预载全局音效（如 gg_snd_LX_Q2 等）；键不存在则静默跳过 */
export function 播放铃仙全局音效(this: void, soundKey: string): void {
  if (soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  jass.StartSound(sound);
}

/** 按序号播放动作并设置时间缩放（timeScale <= 0 表示不修改时间缩放） */
export function 播放铃仙配置动作(this: void, unit: any, animationIndex: number, timeScale: number): void {
  if (unit == null || unit === 0) return;
  if (animationIndex >= 0) jass.SetUnitAnimationByIndex(unit, animationIndex);
  if (timeScale > 0) jass.SetUnitTimeScale(unit, timeScale);
}

export {};
