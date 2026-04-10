const japi = require("jass.japi");
// ========== 虚拟分区：按钮文案 ==========
export function resolveQuestButtonTexts(acceptText, rejectText) {
    return {
        accept: acceptText && acceptText !== "" ? acceptText : "接受任务",
        reject: rejectText && rejectText !== "" ? rejectText : "拒绝任务",
    };
}
// ========== 虚拟分区：按钮显示控制 ==========
export function showQuestButtons(state, visible, getLocalPlayer, getPlayerById, dzShow) {
    const localPlayer = getLocalPlayer();
    const targetPlayer = getPlayerById(state.playerId);
    if (localPlayer !== targetPlayer)
        return;
    dzShow(state.frames[5], visible);
    dzShow(state.frames[6], visible);
    dzShow(state.frames[9], visible);
    dzShow(state.frames[7], visible);
    dzShow(state.frames[8], visible);
    dzShow(state.frames[10], visible);
}
// ========== 虚拟分区：按钮文本设置 ==========
export function setQuestButtonTexts(state, acceptText, rejectText, getLocalPlayer, getPlayerById) {
    const localPlayer = getLocalPlayer();
    const targetPlayer = getPlayerById(state.playerId);
    if (localPlayer !== targetPlayer)
        return;
    if (state.frames[9] && state.frames[9] !== 0 && typeof japi.DzFrameSetText === "function") {
        japi.DzFrameSetText(state.frames[9], acceptText);
    }
    if (state.frames[10] && state.frames[10] !== 0 && typeof japi.DzFrameSetText === "function") {
        japi.DzFrameSetText(state.frames[10], rejectText);
    }
}
