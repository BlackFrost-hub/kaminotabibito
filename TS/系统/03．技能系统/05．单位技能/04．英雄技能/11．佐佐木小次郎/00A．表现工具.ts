/** @noSelfInFile */

/**
 * 佐佐木小次郎 - 表现工具
 *
 * 音效走 Sound3DII 单句柄复用（同路径最多 4 实例，符合项目音效池约束）；
 * 动作走 SetUnitAnimationByIndex + SetUnitTimeScale。
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { Sound3DII_CooPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};

/** 播放坐标 3D 音效（单句柄复用，不扩池） */
export function 播放佐佐木坐标音效(this: void, path: string, x: number, y: number, cutoff: number): void {
  if (path === "") return;
  Sound3DII_CooPlayReuse(path, x, y, 0, cutoff);
}

/** 播放单位坐标 3D 音效 */
export function 播放佐佐木单位音效(this: void, unit: any, path: string, cutoff: number): void {
  if (unit == null || unit === 0 || path === "") return;
  Sound3DII_CooPlayReuse(path, jass.GetUnitX(unit), jass.GetUnitY(unit), 0, cutoff);
}

/** 播放地图预载全局音效（如 gg_snd_ZZMR1/R2） */
export function 播放佐佐木全局音效(this: void, soundKey: string): void {
  if (soundKey === "") return;
  const sound = jglobals[soundKey];
  if (sound == null || sound === 0) return;
  jass.StartSound(sound);
}

/** 按序号播放动作并设置时间缩放（-1 表示不换动作） */
export function 播放佐佐木配置动作(this: void, unit: any, animationIndex: number, timeScale: number): void {
  if (unit == null || unit === 0) return;
  if (animationIndex >= 0) jass.SetUnitAnimationByIndex(unit, animationIndex);
  if (timeScale > 0) jass.SetUnitTimeScale(unit, timeScale);
}

export {};
