const japi = require("jass.japi");
const jass = require("jass.common");
import { safeTimerStart } from "../../../系统/00．核心系统/07．联机安全工具";
export const DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav";
/** 对话框系统固定为 4 个玩家槽位：P1~P4。 */
export const MAX_PLAYERS = 4;
// ========== 虚拟分区：活跃玩家标志管理 ==========
const g_activePlayerFlags = [];
export function setActivePlayerId(playerId) {
    if (playerId < 0 || playerId >= MAX_PLAYERS)
        return;
    g_activePlayerFlags[playerId] = true;
}
export function resetActivePlayerIdIfMatch(playerId) {
    if (playerId < 0 || playerId >= MAX_PLAYERS)
        return;
    g_activePlayerFlags[playerId] = false;
}
export const TOC_PATH = "ui\\StarGameUI.toc";
export const TAG_BASE_MAIN = 1024;
export const TAG_BASE_PORTRAIT = 1125;
export const DEFAULT_FONT = "UI\\uizt.ttf";
export const DEFAULT_TITLE_FONT_SIZE = 0.018;
export const DEFAULT_BODY_FONT_SIZE = 0.012;
export const DEFAULT_BG_TEX = "UI\\wenbenkuang.blp";
export const DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp";
/** ~ 键 VK_OEM_3（192）；注册须走数字 VK，见 `封装函数/04．硬件输入/04．键盘函数` 中 registerKeyBindToTrigger */
export const KEY_SKIP_DIALOG = 192;
// ========== 虚拟分区：4 槽位玩家运行时状态表 ==========
export const g_states = [];
export const g_questCallbacksByPlayer = [];
// ========== 虚拟分区：pcall 具名体槽位 ==========
let __dzPcallFrame = 0;
let __dzPcallPriority = 0;
function __dzSetPriorityPcallBody() { japi.DzFrameSetPriority(__dzPcallFrame, __dzPcallPriority); }
// ========== 虚拟分区：Dz/JASS API 安全封装 ==========
export function dzShow(f, b) { if (f && f !== 0)
    japi.DzFrameShow(f, b); }
export function dzSetText(f, s) { if (f && f !== 0)
    japi.DzFrameSetText(f, s); }
export function dzSetTexture(f, path) { if (f && f !== 0)
    japi.DzFrameSetTexture(f, path, 0); }
export function dzSetAlpha(f, a) { if (f && f !== 0)
    japi.DzFrameSetAlpha(f, a); }
export function dzSetPriority(f, p) { if (f && f !== 0) {
    __dzPcallFrame = f;
    __dzPcallPriority = p;
    pcall(__dzSetPriorityPcallBody);
} }
export function dzSetAbsPoint(f, point, x, y) { if (f && f !== 0)
    japi.DzFrameSetAbsolutePoint(f, point, x, y); }
export function dzSetSize(f, w, h) { if (f && f !== 0)
    japi.DzFrameSetSize(f, w, h); }
export function dzClearPoints(f) { if (f && f !== 0)
    japi.DzFrameClearAllPoints(f); }
export function dzSetEnable(f, b) { if (f && f !== 0)
    japi.DzFrameSetEnable(f, b); }
export function dzSetFont(f, font, size) { if (f && f !== 0)
    japi.DzFrameSetFont(f, font, size, 0); }
export function dzCreate(template, tag) {
    const gameUI = japi.DzGetGameUI();
    if (!gameUI || gameUI === 0)
        return 0;
    return japi.DzCreateFrame(template, gameUI, tag);
}
export function dzGetLocalPlayer() { return jass.GetLocalPlayer(); }
export function dzGetPlayerId(p) { return jass.GetPlayerId(p); }
export function dzPlayer(index) { return jass.Player(index); }
export function dzTimerCreate() { return jass.CreateTimer(); }
export function dzTimerStart(t, timeout, periodic, cb) { if (t)
    safeTimerStart(t, timeout, periodic, cb); }
export function dzTimerPause(t) { if (t)
    jass.PauseTimer(t); }
export function dzLoadToc() { japi.DzLoadToc(TOC_PATH); }
let g_tocLoaded = false;
export function dzLoadTocOnce() { if (g_tocLoaded)
    return; g_tocLoaded = true; dzLoadToc(); }
/** 联机：~ / DzSync 交错时保证 g_questCallbacksByPlayer 与 queue 中任务条目同源；否则接受/拒绝 resolve 不对称 → 掉线 */
export function syncQuestCallbacksTableFromQueueHead(state) {
    if (state.queue.length === 0)
        return;
    const questIdx = findFirstQuestEntryIndex(state);
    if (questIdx < 0)
        return;
    const e = state.queue[questIdx];
    if (!e.isQuest || !e.questCallbacks)
        return;
    g_questCallbacksByPlayer[state.playerId] = {
        onAccept: e.questCallbacks.onAccept,
        onReject: e.questCallbacks.onReject,
    };
    setActivePlayerId(state.playerId);
}
/**
 * 从当前页往后找第一个任务行。
 * 不再从 queue 头开始，避免 ~ 跳回前面已经看过的任务页。
 */
export function findFirstQuestEntryIndex(state) {
    for (let i = state.currentIndex; i < state.queue.length; i++) {
        if (state.queue[i].isQuest && state.queue[i].questCallbacks)
            return i;
    }
    return -1;
}
export { japi, jass };
