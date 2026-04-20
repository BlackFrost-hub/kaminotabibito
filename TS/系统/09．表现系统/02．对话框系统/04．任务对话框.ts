import type { PlayerDialogState } from "./05．对话框业务逻辑";

const japi = require("jass.japi") as any;

// ========== 虚拟分区：任务回调类型 ==========
export interface QuestCallbacks {
  onAccept: () => void;
  onReject: () => void;
}

// ========== 虚拟分区：按钮文案 ==========
export function resolveQuestButtonTexts(acceptText?: string, rejectText?: string): { accept: string; reject: string } {
  return {
    accept: acceptText && acceptText !== "" ? acceptText : "接受任务",
    reject: rejectText && rejectText !== "" ? rejectText : "拒绝任务",
  };
}

// ========== 虚拟分区：按钮显示控制 ==========
export function showQuestButtons(
  state: PlayerDialogState,
  visible: boolean,
  getLocalPlayer: () => any,
  getPlayerById: (id: number) => any,
  dzShow: (f: number, b: boolean) => void,
): void {
  const localPlayer = getLocalPlayer();
  const targetPlayer = getPlayerById(state.playerId);
  if (localPlayer !== targetPlayer) return;
  dzShow(state.frames[5], visible);
  dzShow(state.frames[6], visible);
  dzShow(state.frames[9], visible);
  dzShow(state.frames[7], visible);
  dzShow(state.frames[8], visible);
  dzShow(state.frames[10], visible);
}

// ========== 虚拟分区：按钮文本设置 ==========
export function setQuestButtonTexts(
  state: PlayerDialogState,
  acceptText: string,
  rejectText: string,
  getLocalPlayer: () => any,
  getPlayerById: (id: number) => any,
): void {
  const localPlayer = getLocalPlayer();
  const targetPlayer = getPlayerById(state.playerId);
  if (localPlayer !== targetPlayer) return;
  if (state.frames[9] && state.frames[9] !== 0) {
    japi.DzFrameSetText(state.frames[9], acceptText);
  }
  if (state.frames[10] && state.frames[10] !== 0) {
    japi.DzFrameSetText(state.frames[10], rejectText);
  }
}
