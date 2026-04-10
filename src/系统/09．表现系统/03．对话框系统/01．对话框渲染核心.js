const japi = require("jass.japi");
const jass = require("jass.common");
import { createFrame, FrameType } from "../01．UI工具/index";
import { frameSetScriptByCode } from "../../00．核心系统/04．硬件函数";
import { Sound3DII_Mp3PlayReuse } from "../../00．核心系统/02．音效函数";
import { getActivePlayerId, resetActivePlayerIdIfMatch, setActivePlayerId } from "../04．NPC对话状态池";
import { STEP_LEN, TICK, nextTypingProgress, stringLengthCompat, substringCompat } from "./02．打字机效果";
import { applyPortraitFrames } from "./03．对话框立绘系统";
import { resolveQuestButtonTexts, setQuestButtonTexts, showQuestButtons } from "./04．任务对话框";
import { createNormalDialogEntry, createQuestDialogEntry, onDialogFinished } from "./05．对话框业务逻辑";
const DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav";
const MAX_PLAYERS = 28;
const TOC_PATH = "ui\\StarGameUI.toc";
const TAG_BASE_MAIN = 1024;
const TAG_BASE_PORTRAIT = 1125;
const DEFAULT_FONT = "UI\\uizt.ttf";
const DEFAULT_TITLE_FONT_SIZE = 0.018;
const DEFAULT_BODY_FONT_SIZE = 0.012;
const DEFAULT_BG_TEX = "UI\\wenbenkuang.blp";
const DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp";
// ========== 虚拟分区：运行时状态 ==========
const g_states = [];
const g_questCallbacksByPlayer = [];
// ========== 虚拟分区：工具 ==========
function dzShow(f, b) { if (f && f !== 0 && typeof japi.DzFrameShow === "function")
    japi.DzFrameShow(f, b); }
function dzSetText(f, s) { if (f && f !== 0 && typeof japi.DzFrameSetText === "function")
    japi.DzFrameSetText(f, s); }
function dzSetTexture(f, path) { if (f && f !== 0 && typeof japi.DzFrameSetTexture === "function")
    japi.DzFrameSetTexture(f, path, 0); }
function dzSetAlpha(f, a) { if (f && f !== 0 && typeof japi.DzFrameSetAlpha === "function")
    japi.DzFrameSetAlpha(f, a); }
function dzSetPriority(f, p) { if (f && f !== 0 && typeof japi.DzFrameSetPriority === "function")
    pcall(() => japi.DzFrameSetPriority(f, p)); }
function dzSetAbsPoint(f, point, x, y) { if (f && f !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function")
    japi.DzFrameSetAbsolutePoint(f, point, x, y); }
function dzSetSize(f, w, h) { if (f && f !== 0 && typeof japi.DzFrameSetSize === "function")
    japi.DzFrameSetSize(f, w, h); }
function dzClearPoints(f) { if (f && f !== 0 && typeof japi.DzFrameClearAllPoints === "function")
    japi.DzFrameClearAllPoints(f); }
function dzSetEnable(f, b) { if (f && f !== 0 && typeof japi.DzFrameSetEnable === "function")
    japi.DzFrameSetEnable(f, b); }
function dzSetFont(f, font, size) { if (f && f !== 0 && typeof japi.DzFrameSetFont === "function")
    japi.DzFrameSetFont(f, font, size, 0); }
function dzCreate(template, tag) {
    const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;
    if (!gameUI || gameUI === 0)
        return 0;
    if (typeof japi.DzCreateFrame !== "function")
        return 0;
    return japi.DzCreateFrame(template, gameUI, tag);
}
function dzGetLocalPlayer() { return typeof jass.GetLocalPlayer === "function" ? jass.GetLocalPlayer() : null; }
function dzGetPlayerId(p) { return typeof jass.GetPlayerId === "function" ? jass.GetPlayerId(p) : -1; }
function dzPlayer(index) { return typeof jass.Player === "function" ? jass.Player(index) : null; }
function dzTimerCreate() { return typeof jass.CreateTimer === "function" ? jass.CreateTimer() : null; }
function dzTimerStart(t, timeout, periodic, cb) { if (t && typeof jass.TimerStart === "function")
    jass.TimerStart(t, timeout, periodic, cb); }
function dzTimerPause(t) { if (t && typeof jass.PauseTimer === "function")
    jass.PauseTimer(t); }
function dzLoadToc() { if (typeof japi.DzLoadToc === "function")
    japi.DzLoadToc(TOC_PATH); }
let g_tocLoaded = false;
function dzLoadTocOnce() { if (g_tocLoaded)
    return; g_tocLoaded = true; dzLoadToc(); }
// ========== 虚拟分区：回调流程 ==========
function resolveQuestCallbackByTriggerPlayer() {
    let pid = getActivePlayerId();
    if (pid < 0 || pid >= MAX_PLAYERS) {
        if (typeof japi.DzGetTriggerUIEventPlayer !== "function")
            return undefined;
        const triggerPlayer = japi.DzGetTriggerUIEventPlayer();
        pid = dzGetPlayerId(triggerPlayer);
    }
    if (pid < 0 || pid >= MAX_PLAYERS)
        return undefined;
    const state = g_states[pid];
    if (!state)
        return undefined;
    const cb = g_questCallbacksByPlayer[pid];
    if (!cb)
        return undefined;
    return { state, onAccept: cb.onAccept, onReject: cb.onReject };
}
function questAcceptCallback() {
    const ctx = resolveQuestCallbackByTriggerPlayer();
    if (!ctx)
        return;
    const { state, onAccept } = ctx;
    resetActivePlayerIdIfMatch(state.playerId);
    g_questCallbacksByPlayer[state.playerId] = undefined;
    state.queue.shift();
    onDialogFinished(state);
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer === targetPlayer) {
        showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
        showDialogFrames(state, false);
    }
    onAccept();
}
function questRejectCallback() {
    const ctx = resolveQuestCallbackByTriggerPlayer();
    if (!ctx)
        return;
    const { state, onReject } = ctx;
    resetActivePlayerIdIfMatch(state.playerId);
    g_questCallbacksByPlayer[state.playerId] = undefined;
    state.queue.shift();
    onDialogFinished(state);
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer === targetPlayer) {
        showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
        showDialogFrames(state, false);
    }
    onReject();
}
globalThis.QuestAcceptCallback = questAcceptCallback;
globalThis.QuestRejectCallback = questRejectCallback;
// ========== 虚拟分区：初始化 ==========
function createDialogFrames() {
    const frames = [];
    for (let i = 0; i <= 11; i++)
        frames[i] = 0;
    frames[101] = 0;
    frames[102] = 0;
    frames[103] = 0;
    const portraits = [
        { idx: 101, tag: TAG_BASE_PORTRAIT, x: 0.24, y: 0.1421 + 0.2 },
        { idx: 102, tag: TAG_BASE_PORTRAIT + 1, x: 0.24 + 0.377 / 3, y: 0.1421 + 0.2 },
        { idx: 103, tag: TAG_BASE_PORTRAIT + 2, x: 0.24 + 0.377 / 1.5, y: 0.1421 + 0.2 },
    ];
    for (const p of portraits) {
        const f = dzCreate("GameUI", p.tag);
        frames[p.idx] = f;
        dzShow(f, false);
        dzClearPoints(f);
        dzSetAbsPoint(f, 3, p.x, p.y);
        dzSetSize(f, 0.367 / 3, 0.231);
        dzSetAlpha(f, 255);
        dzSetTexture(f, "");
    }
    const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;
    const bg = createFrame({ type: FrameType.BACKDROP, name: "DialogBG", parent: gameUI, template: "template", visible: false }) ?? 0;
    frames[0] = bg;
    dzClearPoints(bg);
    dzSetAbsPoint(bg, 3, 0.23, 0.2421);
    dzSetSize(bg, 0.377, 0.131);
    dzSetAlpha(bg, 255);
    dzSetTexture(bg, DEFAULT_BG_TEX);
    const bgBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogBGBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
    frames[4] = bgBtn;
    if (bgBtn !== 0) {
        if (typeof japi.DzFrameSetParent === "function")
            pcall(() => japi.DzFrameSetParent(bgBtn, bg));
        if (typeof japi.DzFrameClearAllPoints === "function")
            pcall(() => japi.DzFrameClearAllPoints(bgBtn));
        if (typeof japi.DzFrameSetAllPoints === "function")
            pcall(() => japi.DzFrameSetAllPoints(bgBtn, bg));
        if (typeof japi.DzFrameSetText === "function")
            japi.DzFrameSetText(bgBtn, "");
        if (typeof japi.DzFrameSetAlpha === "function")
            pcall(() => japi.DzFrameSetAlpha(bgBtn, 0));
    }
    frameSetScriptByCode(bgBtn, 1, () => {
        for (let i = 0; i < MAX_PLAYERS; i++) {
            const s = g_states[i];
            if (s && s.frames[0] === bg) {
                if (s.clickCooldown)
                    return;
                if (s.strNow < s.strLen)
                    skipTyping(s);
                else if (s.waitingClick && s.queue.length > 0 && !s.queue[0].isQuest) {
                    s.waitingClick = false;
                    advanceDialog(s);
                }
                return;
            }
        }
    }, false);
    const titleBg = dzCreate("GameUI", TAG_BASE_MAIN + 2);
    frames[1] = titleBg;
    dzShow(titleBg, false);
    dzClearPoints(titleBg);
    dzSetAbsPoint(titleBg, 3, 0.24, 0.3083);
    dzSetSize(titleBg, 0.107, 0.0328);
    dzSetAlpha(titleBg, 255);
    dzSetTexture(titleBg, DEFAULT_TITLE_TEX);
    const nameText = dzCreate("GameText", TAG_BASE_MAIN + 3);
    frames[2] = nameText;
    dzShow(nameText, false);
    dzClearPoints(nameText);
    if (nameText !== 0 && typeof japi.DzFrameSetAllPoints === "function")
        pcall(() => japi.DzFrameSetAllPoints(nameText, titleBg));
    dzSetText(nameText, "");
    dzSetFont(nameText, DEFAULT_FONT, DEFAULT_TITLE_FONT_SIZE);
    dzSetEnable(nameText, false);
    if (nameText !== 0 && typeof japi.DzFrameSetTextAlignment === "function")
        pcall(() => { japi.DzFrameSetTextAlignment(nameText, -1); japi.DzFrameSetTextAlignment(nameText, 18); });
    const bodyText = dzCreate("GameTextpxL", TAG_BASE_MAIN + 4);
    frames[3] = bodyText;
    dzShow(bodyText, false);
    dzClearPoints(bodyText);
    dzSetAbsPoint(bodyText, 0, 0.24, 0.28);
    dzSetSize(bodyText, 0.35, 0.22);
    dzSetText(bodyText, "");
    dzSetFont(bodyText, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE);
    dzSetEnable(bodyText, false);
    const acceptBg = createFrame({ type: FrameType.BACKDROP, name: "DialogAcceptBg", parent: gameUI, template: "template", visible: false }) ?? 0;
    frames[5] = acceptBg;
    if (acceptBg !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function")
        japi.DzFrameSetAbsolutePoint(acceptBg, 4, 0.311, 0.1800);
    if (acceptBg !== 0 && typeof japi.DzFrameSetSize === "function")
        japi.DzFrameSetSize(acceptBg, 0.08, 0.022);
    if (acceptBg !== 0 && typeof japi.DzFrameSetTexture === "function")
        japi.DzFrameSetTexture(acceptBg, "UI\\renwu\\jieshourenwuanniu.tga", 0);
    const acceptLabel = createFrame({ type: FrameType.TEXT, name: "DialogAcceptLabel", parent: acceptBg, template: "template", visible: false }) ?? 0;
    frames[9] = acceptLabel;
    if (acceptLabel !== 0 && typeof japi.DzFrameSetAllPoints === "function")
        japi.DzFrameSetAllPoints(acceptLabel, acceptBg);
    if (acceptLabel !== 0 && typeof japi.DzFrameSetText === "function")
        japi.DzFrameSetText(acceptLabel, "接受任务");
    if (acceptLabel !== 0 && typeof japi.DzFrameSetTextColor === "function")
        japi.DzFrameSetTextColor(acceptLabel, 255, 255, 255, 255);
    if (acceptLabel !== 0 && typeof japi.DzFrameSetFont === "function")
        japi.DzFrameSetFont(acceptLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0);
    if (acceptLabel !== 0 && typeof japi.DzFrameSetTextAlignment === "function")
        japi.DzFrameSetTextAlignment(acceptLabel, 18);
    const acceptBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogAcceptBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
    frames[6] = acceptBtn;
    if (acceptBtn !== 0 && typeof japi.DzFrameSetAllPoints === "function")
        japi.DzFrameSetAllPoints(acceptBtn, acceptBg);
    if (acceptBtn !== 0 && typeof japi.DzFrameSetAlpha === "function")
        japi.DzFrameSetAlpha(acceptBtn, 0);
    if (acceptBtn !== 0 && typeof japi.DzFrameSetText === "function")
        japi.DzFrameSetText(acceptBtn, "");
    const rejectBg = createFrame({ type: FrameType.BACKDROP, name: "DialogRejectBg", parent: gameUI, template: "template", visible: false }) ?? 0;
    frames[7] = rejectBg;
    if (rejectBg !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function")
        japi.DzFrameSetAbsolutePoint(rejectBg, 4, 0.406, 0.1800);
    if (rejectBg !== 0 && typeof japi.DzFrameSetSize === "function")
        japi.DzFrameSetSize(rejectBg, 0.08, 0.022);
    if (rejectBg !== 0 && typeof japi.DzFrameSetTexture === "function")
        japi.DzFrameSetTexture(rejectBg, "UI\\renwu\\jieshourenwuanniu.tga", 0);
    const rejectLabel = createFrame({ type: FrameType.TEXT, name: "DialogRejectLabel", parent: rejectBg, template: "template", visible: false }) ?? 0;
    frames[10] = rejectLabel;
    if (rejectLabel !== 0 && typeof japi.DzFrameSetAllPoints === "function")
        japi.DzFrameSetAllPoints(rejectLabel, rejectBg);
    if (rejectLabel !== 0 && typeof japi.DzFrameSetText === "function")
        japi.DzFrameSetText(rejectLabel, "拒绝任务");
    if (rejectLabel !== 0 && typeof japi.DzFrameSetTextColor === "function")
        japi.DzFrameSetTextColor(rejectLabel, 255, 255, 255, 255);
    if (rejectLabel !== 0 && typeof japi.DzFrameSetFont === "function")
        japi.DzFrameSetFont(rejectLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0);
    if (rejectLabel !== 0 && typeof japi.DzFrameSetTextAlignment === "function")
        japi.DzFrameSetTextAlignment(rejectLabel, 18);
    const rejectBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogRejectBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
    frames[8] = rejectBtn;
    if (rejectBtn !== 0 && typeof japi.DzFrameSetAllPoints === "function")
        japi.DzFrameSetAllPoints(rejectBtn, rejectBg);
    if (rejectBtn !== 0 && typeof japi.DzFrameSetAlpha === "function")
        japi.DzFrameSetAlpha(rejectBtn, 0);
    if (rejectBtn !== 0 && typeof japi.DzFrameSetText === "function")
        japi.DzFrameSetText(rejectBtn, "");
    const hintLabel = createFrame({ type: FrameType.TEXT, name: "DialogHintLabel", parent: gameUI, template: "template", visible: false }) ?? 0;
    frames[11] = hintLabel;
    if (hintLabel !== 0) {
        if (typeof japi.DzFrameSetPoint === "function")
            pcall(() => japi.DzFrameSetPoint(hintLabel, 8, bg, 8, -0.008, 0.008));
        if (typeof japi.DzFrameSetSize === "function")
            japi.DzFrameSetSize(hintLabel, 0.12, 0.018);
        if (typeof japi.DzFrameSetText === "function")
            japi.DzFrameSetText(hintLabel, "|cff333333[点击以继续] ↓|r");
        if (typeof japi.DzFrameSetFont === "function")
            japi.DzFrameSetFont(hintLabel, DEFAULT_FONT, 0.016, 0);
        if (typeof japi.DzFrameSetTextAlignment === "function") {
            japi.DzFrameSetTextAlignment(hintLabel, -1);
            japi.DzFrameSetTextAlignment(hintLabel, 5);
        }
    }
    const p = 180;
    dzSetPriority(frames[0], p);
    dzSetPriority(frames[1], p);
    dzSetPriority(frames[2], p);
    dzSetPriority(frames[3], p);
    dzSetPriority(frames[4], p);
    dzSetPriority(frames[5], p);
    dzSetPriority(frames[6], p);
    dzSetPriority(frames[7], p);
    dzSetPriority(frames[8], p);
    dzSetPriority(frames[9], p);
    dzSetPriority(frames[10], p);
    dzSetPriority(frames[11], p);
    dzSetPriority(frames[101], p);
    dzSetPriority(frames[102], p);
    dzSetPriority(frames[103], p);
    return frames;
}
// ========== 虚拟分区：状态管理 ==========
function ensureState(playerId) {
    if (g_states[playerId])
        return g_states[playerId];
    const state = { playerId, queue: [], tickTimer: dzTimerCreate(), frames: [], strNow: 0, strLen: 0, canShow: true, initialized: false, questSyncHandlersBound: false, isActive: false, clickCooldown: false, waitingClick: false };
    g_states[playerId] = state;
    return state;
}
function bindQuestSyncHandlers(state) {
    if (state.questSyncHandlersBound || !state.frames || state.frames.length === 0)
        return;
    frameSetScriptByCode(state.frames[6], 1, questAcceptCallback, true);
    frameSetScriptByCode(state.frames[8], 1, questRejectCallback, true);
    state.questSyncHandlersBound = true;
}
function showDialogFrames(state, visible) {
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
    }
    if (visible)
        dzSetAlpha(state.frames[0], 155);
    for (let i = 101; i < 104; i++)
        dzShow(state.frames[i], visible);
}
function clearState(state) {
    dzTimerPause(state.tickTimer);
    resetActivePlayerIdIfMatch(state.playerId);
    g_questCallbacksByPlayer[state.playerId] = undefined;
    state.queue = [];
    onDialogFinished(state);
    showDialogFrames(state, false);
}
// ========== 虚拟分区：播放流程 ==========
function playEntry(state) {
    if (state.queue.length === 0)
        return;
    const isFirstOpen = !state.isActive;
    state.isActive = true;
    state.waitingClick = false;
    state.clickCooldown = true;
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    const isLocal = localPlayer === targetPlayer;
    if (!state.initialized) {
        dzLoadTocOnce();
        state.frames = createDialogFrames();
        state.initialized = true;
        bindQuestSyncHandlers(state);
    }
    showDialogFrames(state, true);
    if (isFirstOpen)
        Sound3DII_Mp3PlayReuse(DIALOG_OPEN_SOUND, targetPlayer);
    const entry = state.queue[0];
    if (entry.isQuest && entry.questCallbacks) {
        setActivePlayerId(state.playerId);
        g_questCallbacksByPlayer[state.playerId] = { onAccept: entry.questCallbacks.onAccept, onReject: entry.questCallbacks.onReject };
        const buttonTexts = resolveQuestButtonTexts(entry.acceptText, entry.rejectText);
        setQuestButtonTexts(state, buttonTexts.accept, buttonTexts.reject, dzGetLocalPlayer, dzPlayer);
    }
    if (!isLocal) {
        state.strLen = stringLengthCompat(entry.text);
        state.strNow = 0;
        dzTimerStart(state.tickTimer, TICK, true, () => {
            if (state.queue.length === 0) {
                dzTimerPause(state.tickTimer);
                return;
            }
            state.strNow = nextTypingProgress(state.strNow, STEP_LEN);
            state.clickCooldown = false;
            if (state.strNow >= state.strLen) {
                dzTimerPause(state.tickTimer);
                if (!state.queue[0].isQuest)
                    advanceDialog(state);
            }
        });
        return;
    }
    dzSetFont(state.frames[2], DEFAULT_FONT, entry.titleFontSize);
    dzSetFont(state.frames[3], DEFAULT_FONT, entry.bodyFontSize);
    dzSetText(state.frames[2], entry.title);
    dzSetText(state.frames[3], "");
    applyPortraitFrames(entry, state.frames, dzSetTexture, dzShow);
    state.strNow = 0;
    state.strLen = stringLengthCompat(entry.text);
    startTyping(state);
}
function skipTyping(state) {
    if (state.queue.length === 0 || state.strNow >= state.strLen)
        return;
    dzTimerPause(state.tickTimer);
    state.strNow = state.strLen;
    const entry = state.queue[0];
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer === targetPlayer)
        dzSetText(state.frames[3], entry.text);
    if (entry.isQuest)
        showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
    else {
        state.waitingClick = true;
        dzShow(state.frames[11], true);
    }
}
function startTyping(state) {
    dzTimerStart(state.tickTimer, TICK, true, () => onTypingTick(state));
}
function onTypingTick(state) {
    if (state.queue.length === 0) {
        dzTimerPause(state.tickTimer);
        return;
    }
    state.strNow = nextTypingProgress(state.strNow, STEP_LEN);
    state.clickCooldown = false;
    const entry = state.queue[0];
    if (!entry) {
        dzTimerPause(state.tickTimer);
        return;
    }
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    const isLocal = localPlayer === targetPlayer;
    if (state.strNow >= state.strLen) {
        if (isLocal)
            dzSetText(state.frames[3], entry.text);
        dzTimerPause(state.tickTimer);
        if (entry.isQuest)
            showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
        else {
            state.waitingClick = true;
            dzShow(state.frames[11], true);
        }
    }
    else if (isLocal) {
        dzSetText(state.frames[3], substringCompat(entry.text, 0, state.strNow));
    }
}
function advanceDialog(state) {
    showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
    dzShow(state.frames[11], false);
    state.queue.shift();
    if (state.queue.length === 0) {
        onDialogFinished(state);
        showDialogFrames(state, false);
    }
    else
        playEntry(state);
}
function enqueue(state, entry) {
    const wasEmpty = state.queue.length === 0;
    state.queue.push(entry);
    if (wasEmpty)
        playEntry(state);
}
// ========== 虚拟分区：API ==========
export function initDialogSystem() {
    dzLoadTocOnce();
    for (let i = 0; i < MAX_PLAYERS; i++) {
        const state = ensureState(i);
        if (!state.initialized) {
            state.frames = createDialogFrames();
            state.initialized = true;
        }
        bindQuestSyncHandlers(state);
    }
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
    const localPlayer = dzGetLocalPlayer();
    if (localPlayer !== p)
        return;
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = ensureState(pid);
    state.canShow = visible;
    if (!visible && state.initialized) {
        for (let i = 0; i < 9; i++)
            dzShow(state.frames[i], false);
        for (let i = 101; i < 104; i++)
            dzShow(state.frames[i], false);
    }
}
export function setDialogBGTexture(p, path) {
    const localPlayer = dzGetLocalPlayer();
    if (localPlayer !== p)
        return;
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = g_states[pid];
    if (!state || !state.initialized)
        return;
    dzSetTexture(state.frames[0], path);
}
export function setDialogTitleTexture(p, path) {
    const localPlayer = dzGetLocalPlayer();
    if (localPlayer !== p)
        return;
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
    ensureState(pid).onFinish = callback;
}
export function displayQuest(p, title, text, onAccept, onReject, acceptText, rejectText) {
    const pid = dzGetPlayerId(p);
    if (pid < 0 || pid >= MAX_PLAYERS)
        return;
    const state = ensureState(pid);
    enqueue(state, createQuestDialogEntry(title, text, DEFAULT_TITLE_FONT_SIZE, DEFAULT_BODY_FONT_SIZE, { onAccept, onReject }, acceptText, rejectText));
}
