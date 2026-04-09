import type { DialogEntry, Frame } from "./05．对话框业务逻辑";

// ========== 虚拟分区：索引常量 ==========
export const LEFT_PORTRAIT_INDEX = 101;
export const MID_PORTRAIT_INDEX = 102;
export const RIGHT_PORTRAIT_INDEX = 103;

// ========== 虚拟分区：立绘渲染 ==========
export function applyPortraitFrames(
  entry: DialogEntry,
  frames: Frame[],
  dzSetTexture: (f: Frame, path: string) => void,
  dzShow: (f: Frame, visible: boolean) => void,
): void {
  if (entry.leftTex !== "") {
    dzSetTexture(frames[LEFT_PORTRAIT_INDEX], entry.leftTex);
    dzShow(frames[LEFT_PORTRAIT_INDEX], true);
  } else {
    dzShow(frames[LEFT_PORTRAIT_INDEX], false);
  }
  if (entry.midTex !== "") {
    dzSetTexture(frames[MID_PORTRAIT_INDEX], entry.midTex);
    dzShow(frames[MID_PORTRAIT_INDEX], true);
  } else {
    dzShow(frames[MID_PORTRAIT_INDEX], false);
  }
  if (entry.rightTex !== "") {
    dzSetTexture(frames[RIGHT_PORTRAIT_INDEX], entry.rightTex);
    dzShow(frames[RIGHT_PORTRAIT_INDEX], true);
  } else {
    dzShow(frames[RIGHT_PORTRAIT_INDEX], false);
  }
}
