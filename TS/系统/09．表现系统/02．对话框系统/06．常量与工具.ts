const jass = require("jass.common") as any;

import { giveRewardToPlayers } from "./13．任务奖励执行";

// ========== 虚拟分区：常量 ==========
export const UNIT_ID_NGME = 110 * 16777216 + 103 * 65536 + 109 * 256 + 101; // "ngme"
export const DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的";
export const DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者";

// ========== 虚拟分区：工具 ==========

export function showLocalHint(playerId: number, msg: string, duration: number = 5): void {
  const localPlayer = jass.GetLocalPlayer();
  if (localPlayer === jass.Player(playerId)) {
    jass.DisplayTimedTextToPlayer(localPlayer, 0, 0, duration, msg);
  }
}

export function giveQuestReward(reward: string, triggerPlayerId?: number): void {
  giveRewardToPlayers(reward, triggerPlayerId);
}

