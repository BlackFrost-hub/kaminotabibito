const jass = require("jass.common") as any;

import { giveRewardToPlayers } from "../../00．核心系统/11．便捷函数（偶尔用）";

// ========== 虚拟分区：常量 ==========
export const UNIT_ID_NGME = 110 * 16777216 + 103 * 65536 + 109 * 256 + 101; // "ngme"
export const DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的";
export const DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者";

// ========== 虚拟分区：工具 ==========
export function calculateFourCC(code: string): number {
  if (code.length !== 4) return 0;
  const bytes = [code.charCodeAt(0), code.charCodeAt(1), code.charCodeAt(2), code.charCodeAt(3)];
  return bytes[0] * 16777216 + bytes[1] * 65536 + bytes[2] * 256 + bytes[3];
}

export function showLocalHint(playerId: number, msg: string, duration: number = 5): void {
  const localPlayer = jass.GetLocalPlayer();
  if (localPlayer === jass.Player(playerId)) {
    jass.DisplayTimedTextToPlayer(localPlayer, 0, 0, duration, msg);
  }
}

export function giveQuestReward(reward: string, triggerPlayerId?: number): void {
  giveRewardToPlayers(reward, triggerPlayerId);
}

