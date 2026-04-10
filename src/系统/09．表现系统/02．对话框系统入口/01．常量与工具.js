const jass = require("jass.common");
import { giveRewardToPlayers } from "./08．任务奖励执行";
// ========== 虚拟分区：常量 ==========
export const UNIT_ID_NGME = 110 * 16777216 + 103 * 65536 + 109 * 256 + 101; // "ngme"
export const DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的";
export const DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者";
// ========== 虚拟分区：工具 ==========
export function calculateFourCC(code) {
    if (code.length !== 4)
        return 0;
    const bytes = [code.charCodeAt(0), code.charCodeAt(1), code.charCodeAt(2), code.charCodeAt(3)];
    return bytes[0] * 16777216 + bytes[1] * 65536 + bytes[2] * 256 + bytes[3];
}
export function showLocalHint(playerId, msg, duration = 5) {
    const localPlayer = jass.GetLocalPlayer();
    if (localPlayer === jass.Player(playerId)) {
        jass.DisplayTimedTextToPlayer(localPlayer, 0, 0, duration, msg);
    }
}
export function giveQuestReward(reward, triggerPlayerId) {
    giveRewardToPlayers(reward, triggerPlayerId);
}
