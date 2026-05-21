import { Sound3DII_Mp3PlayReuse } from "../../../lib/扩展函数/封装函数/02．音效系统/index";
import { resetActivePlayerIdIfMatch, setActivePlayerId } from "./10．对话框渲染-Dz与状态";
import { resolveQuestButtonTexts, setQuestButtonTexts, showQuestButtons } from "./01．任务对话框";
import { onDialogFinished } from "./02．对话框业务逻辑";
const jass = require("jass.common");
// ========== 虚拟分区：打字机步进长度与刷新间隔常量 ==========
export const STEP_LEN = 2;
export const TICK = 0.03;
// ========== 虚拟分区：打字机逐字推进计算 ==========
export function nextTypingProgress(current, step = STEP_LEN) {
    return current + step;
}
// ========== 虚拟分区：JASS 字符串截取/长度兼容封装 ==========
export function substringCompat(text, start, end) {
    return jass.SubString(text, start, end);
}
export function stringLengthCompat(text) {
    return jass.StringLength(text);
}
// ========== 虚拟分区：立绘帧索引常量（左/中/右） ==========
export const LEFT_PORTRAIT_INDEX = 101;
export const MID_PORTRAIT_INDEX = 102;
export const RIGHT_PORTRAIT_INDEX = 103;
// ========== 虚拟分区：立绘帧显隐与贴图切换渲染 ==========
export function applyPortraitFrames(entry, state, getLocalPlayer, getPlayerById, dzSetTexture, dzShow) {
    const frames = state.frames;
    const isLocalSlot = getLocalPlayer() === getPlayerById(state.playerId);
    if (entry.leftTex !== "") {
        dzSetTexture(frames[LEFT_PORTRAIT_INDEX], entry.leftTex);
        if (isLocalSlot)
            dzShow(frames[LEFT_PORTRAIT_INDEX], true);
    }
    else {
        if (isLocalSlot)
            dzShow(frames[LEFT_PORTRAIT_INDEX], false);
    }
    if (entry.midTex !== "") {
        dzSetTexture(frames[MID_PORTRAIT_INDEX], entry.midTex);
        if (isLocalSlot)
            dzShow(frames[MID_PORTRAIT_INDEX], true);
    }
    else {
        if (isLocalSlot)
            dzShow(frames[MID_PORTRAIT_INDEX], false);
    }
    if (entry.rightTex !== "") {
        dzSetTexture(frames[RIGHT_PORTRAIT_INDEX], entry.rightTex);
        if (isLocalSlot)
            dzShow(frames[RIGHT_PORTRAIT_INDEX], true);
    }
    else {
        if (isLocalSlot)
            dzShow(frames[RIGHT_PORTRAIT_INDEX], false);
    }
}
import { createDialogFrames } from "./11．对话框渲染-创建帧";
import { DEFAULT_FONT, DIALOG_OPEN_SOUND, dzGetLocalPlayer, dzPlayer, dzSetAlpha, dzSetFont, dzSetText, dzSetTexture, dzShow, dzTimerCreate, dzTimerPause, dzTimerStart, dzLoadTocOnce, g_questCallbacksByPlayer, g_states, syncQuestCallbacksTableFromQueueHead, } from "./10．对话框渲染-Dz与状态";
let g_bindQuestSyncHandlers;
export function setQuestSyncHandlersBinder(fn) {
    g_bindQuestSyncHandlers = fn;
}
function bindQuestSyncHandlers(state) {
    if (g_bindQuestSyncHandlers)
        g_bindQuestSyncHandlers(state);
}
function showContinueHint(state, visible) {
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer !== targetPlayer)
        return;
    dzShow(state.frames[11], visible);
}
// ========== 虚拟分区：状态保障/帧显隐/清除/入队 ==========
export function ensureState(playerId) {
    if (g_states[playerId])
        return g_states[playerId];
    const state = {
        playerId,
        queue: [],
        currentIndex: 0,
        tickTimer: dzTimerCreate(),
        frames: [],
        strNow: 0,
        strLen: 0,
        canShow: true,
        initialized: false,
        questSyncHandlersBound: false,
        isActive: false,
        clickCooldown: false,
        waitingClick: false,
    };
    g_states[playerId] = state;
    return state;
}
export function showDialogFrames(state, visible) {
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer !== targetPlayer)
        return;
    if (!state.canShow) {
        for (let i = 0; i < 9; i++)
            dzShow(state.frames[i], false);
        for (let i = 101; i < 104; i++)
            dzShow(state.frames[i], false);
        return;
    }
    for (let i = 0; i < 5; i++)
        dzShow(state.frames[i], visible);
    if (!visible) {
        dzShow(state.frames[5], false);
        dzShow(state.frames[6], false);
        dzShow(state.frames[7], false);
        dzShow(state.frames[8], false);
        dzShow(state.frames[9], false);
        dzShow(state.frames[10], false);
        dzShow(state.frames[11], false);
        dzShow(state.frames[12], false);
    }
    if (visible) {
        dzSetAlpha(state.frames[0], 155);
        dzShow(state.frames[12], true);
    }
    for (let i = 101; i < 104; i++)
        dzShow(state.frames[i], visible);
}
export function clearState(state) {
    dzTimerPause(state.tickTimer);
    resetActivePlayerIdIfMatch(state.playerId);
    g_questCallbacksByPlayer[state.playerId] = undefined;
    state.queue = [];
    state.currentIndex = 0;
    onDialogFinished(state);
    showDialogFrames(state, false);
}
export function playEntry(state) {
    if (state.queue.length === 0)
        return;
    const isFirstOpen = !state.isActive;
    state.isActive = true;
    state.waitingClick = false;
    state.clickCooldown = true;
    if (!state.initialized) {
        dzLoadTocOnce();
        state.frames = createDialogFrames(state.playerId);
        state.initialized = true;
        bindQuestSyncHandlers(state);
    }
    showDialogFrames(state, true);
    if (isFirstOpen)
        Sound3DII_Mp3PlayReuse(DIALOG_OPEN_SOUND, dzPlayer(state.playerId));
    const entry = state.queue[state.currentIndex];
    setActivePlayerId(state.playerId);
    if (entry.isQuest && entry.questCallbacks) {
        syncQuestCallbacksTableFromQueueHead(state);
        const buttonTexts = resolveQuestButtonTexts(entry.acceptText, entry.rejectText);
        setQuestButtonTexts(state, buttonTexts.accept, buttonTexts.reject);
    }
    dzSetFont(state.frames[2], DEFAULT_FONT, entry.titleFontSize);
    dzSetFont(state.frames[3], DEFAULT_FONT, entry.bodyFontSize);
    dzSetText(state.frames[2], entry.title);
    dzSetText(state.frames[3], "");
    applyPortraitFrames(entry, state, dzGetLocalPlayer, dzPlayer, dzSetTexture, dzShow);
    state.strNow = 0;
    state.strLen = stringLengthCompat(entry.text);
    startTyping(state);
}
export function skipTyping(state) {
    if (state.queue.length === 0)
        return;
    const entry = state.queue[state.currentIndex];
    if (state.strNow < state.strLen) {
        dzTimerPause(state.tickTimer);
        state.strNow = state.strLen;
        dzSetText(state.frames[3], entry.text);
    }
    if (entry.isQuest) {
        syncQuestCallbacksTableFromQueueHead(state);
        showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
    }
    else {
        state.waitingClick = true;
        setActivePlayerId(state.playerId);
        showContinueHint(state, true);
    }
    state.clickCooldown = false;
}
function runTypingTickForPlayer(playerId) {
    const state = g_states[playerId];
    if (!state)
        return;
    onTypingTick(state);
}
function typingTickCallbackP0() { runTypingTickForPlayer(0); }
function typingTickCallbackP1() { runTypingTickForPlayer(1); }
function typingTickCallbackP2() { runTypingTickForPlayer(2); }
function typingTickCallbackP3() { runTypingTickForPlayer(3); }
function startTyping(state) {
    switch (state.playerId) {
        case 0:
            dzTimerStart(state.tickTimer, TICK, true, typingTickCallbackP0);
            return;
        case 1:
            dzTimerStart(state.tickTimer, TICK, true, typingTickCallbackP1);
            return;
        case 2:
            dzTimerStart(state.tickTimer, TICK, true, typingTickCallbackP2);
            return;
        case 3:
            dzTimerStart(state.tickTimer, TICK, true, typingTickCallbackP3);
            return;
        default:
            return;
    }
}
function onTypingTick(state) {
    if (state.queue.length === 0) {
        dzTimerPause(state.tickTimer);
        return;
    }
    state.strNow = nextTypingProgress(state.strNow, STEP_LEN);
    state.clickCooldown = false;
    const entry = state.queue[state.currentIndex];
    if (!entry) {
        dzTimerPause(state.tickTimer);
        return;
    }
    if (state.strNow >= state.strLen) {
        dzSetText(state.frames[3], entry.text);
        dzTimerPause(state.tickTimer);
        if (entry.isQuest) {
            syncQuestCallbacksTableFromQueueHead(state);
            showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
        }
        else {
            state.waitingClick = true;
            setActivePlayerId(state.playerId);
            showContinueHint(state, true);
        }
    }
    else {
        dzSetText(state.frames[3], substringCompat(entry.text, 0, state.strNow));
    }
}
export function advanceDialog(state) {
    showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
    showContinueHint(state, false);
    state.currentIndex++;
    if (state.currentIndex >= state.queue.length) {
        resetActivePlayerIdIfMatch(state.playerId);
        onDialogFinished(state);
        showDialogFrames(state, false);
    }
    else {
        playEntry(state);
    }
}
export function enqueue(state, entry) {
    const wasEmpty = state.queue.length === 0;
    state.queue.push(entry);
    if (wasEmpty) {
        state.currentIndex = 0;
        playEntry(state);
    }
}
