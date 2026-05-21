import { createNormalDialogEntry, createQuestDialogEntry } from "./02．对话框业务逻辑";
import { DEFAULT_BODY_FONT_SIZE, DEFAULT_TITLE_FONT_SIZE, dzGetLocalPlayer, dzGetPlayerId, dzLoadTocOnce, dzSetTexture, dzShow, g_states, MAX_PLAYERS, } from "./10．对话框渲染-Dz与状态";
import { createDialogFrames } from "./11．对话框渲染-创建帧";
import { clearState, enqueue, ensureState, setQuestSyncHandlersBinder } from "./12．对话框渲染-播放与状态管理";
import { bindQuestSyncHandlersImpl, initSkipKeyListener } from "./13．对话框渲染-任务回调与命中";
/** 播放模块在首帧 createDialogFrames 前需能绑定接受/拒绝 sync 脚本（避免与回调模块循环依赖） */
setQuestSyncHandlersBinder(bindQuestSyncHandlersImpl);
// ========== 虚拟分区：对话框系统对外 API（显示文本/任务/清理/纹理设置） ==========
export function initDialogSystem() {
    dzLoadTocOnce();
    initSkipKeyListener();
}
/**
 * 玩家英雄注册回调。
 * 为注册英雄的玩家创建对话框UI。
 */
export function onPlayerHeroRegistered(whichPlayer, whichHero) {
    const jass = require("jass.common");
    const playerId = jass.GetPlayerId(whichPlayer);
    if (playerId < 0 || playerId >= MAX_PLAYERS)
        return;
    const state = ensureState(playerId);
    if (!state.initialized) {
        state.frames = createDialogFrames(playerId);
        state.initialized = true;
    }
    bindQuestSyncHandlersImpl(state);
}
export function displayText(p, title, text, duration, titleFontSize, bodyFontSize) {
    if (duration <= 0)
        duration = 1;
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = ensureState(pid);
    enqueue(state, createNormalDialogEntry(title, text, duration, "", "", "", titleFontSize ?? DEFAULT_TITLE_FONT_SIZE, bodyFontSize ?? DEFAULT_BODY_FONT_SIZE));
}
export function displayTextEx(p, title, text, duration, leftPortrait, midPortrait, rightPortrait, titleFontSize, bodyFontSize) {
    if (duration <= 0)
        duration = 1;
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = ensureState(pid);
    enqueue(state, createNormalDialogEntry(title, text, duration, leftPortrait, midPortrait, rightPortrait, titleFontSize ?? DEFAULT_TITLE_FONT_SIZE, bodyFontSize ?? DEFAULT_BODY_FONT_SIZE));
}
export function clearDialog(p) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = g_states[pid];
    if (!state)
        return;
    clearState(state);
}
export function setDialogShowable(p, visible) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = ensureState(pid);
    state.canShow = visible;
    const localPlayer = dzGetLocalPlayer();
    if (localPlayer !== p)
        return;
    if (!visible && state.initialized) {
        for (let i = 0; i < 9; i++)
            dzShow(state.frames[i], false);
        dzShow(state.frames[11], false);
        dzShow(state.frames[12], false);
        for (let i = 101; i < 104; i++)
            dzShow(state.frames[i], false);
    }
}
export function setDialogBGTexture(p, path) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = g_states[pid];
    if (!state || !state.initialized)
        return;
    dzSetTexture(state.frames[0], path);
}
export function setDialogTitleTexture(p, path) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = g_states[pid];
    if (!state || !state.initialized)
        return;
    dzSetTexture(state.frames[1], path);
}
export function isDialogActive(p) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return false;
    const state = g_states[pid];
    return !!state && state.isActive;
}
export function setDialogFinishCallback(p, callback) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = ensureState(pid);
    state.onFinish = callback;
}
export function displayQuest(p, title, text, onAccept, onReject, acceptText, rejectText) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = ensureState(pid);
    enqueue(state, createQuestDialogEntry(title, text, DEFAULT_TITLE_FONT_SIZE, DEFAULT_BODY_FONT_SIZE, { onAccept, onReject }, acceptText, rejectText));
}
