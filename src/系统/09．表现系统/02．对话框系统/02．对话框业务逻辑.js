// ========== 虚拟分区：条目工厂 ==========
export function createNormalDialogEntry(title, text, waitTime, leftTex, midTex, rightTex, titleFontSize, bodyFontSize) {
    return { title, text, waitTime, leftTex, midTex, rightTex, titleFontSize, bodyFontSize, isQuest: false };
}
export function createQuestDialogEntry(title, text, titleFontSize, bodyFontSize, callbacks, acceptText, rejectText) {
    return {
        title,
        text,
        waitTime: 0,
        leftTex: "",
        midTex: "",
        rightTex: "",
        titleFontSize,
        bodyFontSize,
        isQuest: true,
        questCallbacks: callbacks,
        acceptText,
        rejectText,
    };
}
// ========== 虚拟分区：状态收尾 ==========
/**
 * 仅清「进行中」标志，**不**触发 onFinish（用于任务接受/拒绝后立刻链式 openNpcDialog，避免先 onFinish 销毁 qipao）。
 */
export function resetDialogActiveFlagsKeepOnFinish(state) {
    state.isActive = false;
    state.waitingClick = false;
    state.clickCooldown = false;
}
export function onDialogFinished(state) {
    state.isActive = false;
    state.waitingClick = false;
    state.clickCooldown = false;
    const cb = state.onFinish;
    state.onFinish = undefined;
    if (cb)
        cb();
}
const jass = require("jass.common");
// ========== 虚拟分区：任务默认提示文案常量 ==========
export const DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的";
export const DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者";
// ========== 虚拟分区：本地玩家提示消息工具 ==========
export function showLocalHint(playerId, msg, duration = 5) {
    jass.DisplayTimedTextToPlayer(jass.Player(playerId), 0, 0, duration, msg);
}
