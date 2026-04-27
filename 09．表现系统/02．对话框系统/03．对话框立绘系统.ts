import type { DialogEntry, PlayerDialogState, Frame } from "./05．对话框业务逻辑";

// ========== 虚拟分区：常量 ==========
export const LEFT_PORTRAIT_INDEX = 101;
export const MID_PORTRAIT_INDEX = 102;
export const RIGHT_PORTRAIT_INDEX = 103;

// ========== 虚拟分区：立绘渲染 ==========
export function applyPortraitFrames(
  entry: DialogEntry,
  state: PlayerDialogState,
  getLocalPlayer: () => any,
  getPlayerById: (id: number) => any,
  dzSetTexture: (f: Frame, path: string) => void,
  dzShow: (f: Frame, visible: boolean) => void,
): void {
  const frames = state.frames;
  const isLocalSlot = getLocalPlayer() === getPlayerById(state.playerId);
  if (entry.leftTex !== "") {
    dzSetTexture(frames[LEFT_PORTRAIT_INDEX], entry.leftTex);
    if (isLocalSlot) dzShow(frames[LEFT_PORTRAIT_INDEX], true);
  } else {
    if (isLocalSlot) dzShow(frames[LEFT_PORTRAIT_INDEX], false);
  }
  if (entry.midTex !== "") {
    dzSetTexture(frames[MID_PORTRAIT_INDEX], entry.midTex);
    if (isLocalSlot) dzShow(frames[MID_PORTRAIT_INDEX], true);
  } else {
    if (isLocalSlot) dzShow(frames[MID_PORTRAIT_INDEX], false);
  }
  if (entry.rightTex !== "") {
    dzSetTexture(frames[RIGHT_PORTRAIT_INDEX], entry.rightTex);
    if (isLocalSlot) dzShow(frames[RIGHT_PORTRAIT_INDEX], true);
  } else {
    if (isLocalSlot) dzShow(frames[RIGHT_PORTRAIT_INDEX], false);
  }
}
