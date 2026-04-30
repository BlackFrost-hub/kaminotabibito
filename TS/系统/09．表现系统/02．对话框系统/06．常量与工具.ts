const jass = require("jass.common") as any;

// ========== 虚拟分区：任务默认提示文案常量 ==========
export const DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的";
export const DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者";

// ========== 虚拟分区：本地玩家提示消息工具 ==========

export function showLocalHint(playerId: number, msg: string, duration: number = 5): void {
  jass.DisplayTimedTextToPlayer(jass.Player(playerId), 0, 0, duration, msg);
}
