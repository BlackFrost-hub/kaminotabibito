/** @noSelfInFile */

const { Sound3DII_CooPlay } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_CooPlay: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

export function 播放Boss坐标音效(this: void, path: string, x: number, y: number, cutoff: number): void {
  if (path === "") return;
  Sound3DII_CooPlay(path, x, y, 0, cutoff);
}

export function 延迟播放Boss坐标音效(this: void, path: string, x: number, y: number, delayMs: number, cutoff: number): void {
  if (path === "") return;
  addDelayedCallback(delayMs, function Boss延迟坐标音效(this: void): void {
    播放Boss坐标音效(path, x, y, cutoff);
  });
}
