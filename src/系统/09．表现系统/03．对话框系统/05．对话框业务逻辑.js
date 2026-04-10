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
export function onDialogFinished(state) {
    state.isActive = false;
    state.waitingClick = false;
    state.clickCooldown = false;
    const cb = state.onFinish;
    state.onFinish = undefined;
    if (cb)
        cb();
}
