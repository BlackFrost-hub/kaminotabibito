import { frameSetScriptByCode, registerKeyEventByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { KEY_STATE } from "../../../lib/扩展函数/封装函数/04．硬件输入/01．常量定义";
import { applyPortraitFrames } from "./03．对话框立绘系统";
import { resolveQuestButtonTexts, setQuestButtonTexts, showQuestButtons } from "./04．任务对话框";
import { Frame, PlayerDialogState, onDialogFinished, resetDialogActiveFlagsKeepOnFinish } from "./05．对话框业务逻辑";
import { getActivePlayerId, resetActivePlayerIdIfMatch } from "./16．对话框同步状态";
import { setDialogPanelHitBinder } from "./18．对话框渲染-创建帧";
import {
  DEFAULT_BODY_FONT_SIZE,
  DEFAULT_FONT,
  DEFAULT_TITLE_FONT_SIZE,
  dzGetLocalPlayer,
  dzGetPlayerId,
  dzPlayer,
  dzSetFont,
  dzSetText,
  dzSetTexture,
  dzShow,
  dzTimerPause,
  findFirstQuestEntryIndex,
  g_questCallbacksByPlayer,
  g_states,
  japi,
  KEY_SKIP_DIALOG,
  MAX_PLAYERS,
} from "./17．对话框渲染-Dz与状态";
import { advanceDialog, showDialogFrames, skipTyping, playEntry } from "./19．对话框渲染-播放与状态管理";

function resolveQuestCallbackByTriggerPlayer(): { state: PlayerDialogState; questIdx: number; onAccept: () => void; onReject: () => void } | undefined {
  /**
   * sync=true 全房执行：扫描整个队列（不只看队首）找第一个任务行。
   * ~ 键改为 sync=false 纯本地 UI 快进，队列不被修改，任务行可能不在队首。
   */
  const questPids: number[] = [];
  for (let i = 0; i < MAX_PLAYERS; i++) {
    const st = g_states[i];
    if (!st || st.queue.length === 0) continue;
    if (findFirstQuestEntryIndex(st) >= 0) questPids.push(i);
  }
  if (questPids.length === 0) return undefined;

  let pid = -1;
  if (questPids.length === 1) {
    pid = questPids[0];
  } else {
    const aid = getActivePlayerId();
    if (aid >= 0 && questPids.indexOf(aid) >= 0) {
      pid = aid;
    } else if (typeof japi.DzGetTriggerUIEventPlayer === "function") {
      const triggerPlayer = japi.DzGetTriggerUIEventPlayer();
      const tpid = dzGetPlayerId(triggerPlayer);
      if (tpid >= 0 && questPids.indexOf(tpid) >= 0) pid = tpid;
    }
    if (pid < 0) {
      let minPid = questPids[0]!;
      for (let k = 1; k < questPids.length; k++) {
        if (questPids[k]! < minPid) minPid = questPids[k]!;
      }
      pid = minPid;
    }
  }

  if (pid < 0 || pid >= MAX_PLAYERS) return undefined;
  const state = g_states[pid];
  if (!state) return undefined;
  const questIdx = findFirstQuestEntryIndex(state);
  if (questIdx < 0) return undefined;
  const entry = state.queue[questIdx];
  const cb = entry.questCallbacks!;
  return { state, questIdx, onAccept: cb.onAccept, onReject: cb.onReject };
}

function questAcceptCallback(): void {
  const ctx = resolveQuestCallbackByTriggerPlayer();
  if (!ctx) return;
  const { state, questIdx, onAccept } = ctx;
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  // 移除任务行及其之前所有普通行（~ 本地快进不改队列，任务行不一定在队首）
  state.queue.splice(0, questIdx + 1);
  resetDialogActiveFlagsKeepOnFinish(state);
  onAccept();
  if (state.queue.length === 0) {
    onDialogFinished(state);
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer === targetPlayer) {
      showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
      showDialogFrames(state, false);
    }
  } else {
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer === targetPlayer) {
      showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
    }
    playEntry(state);
  }
}

function questRejectCallback(): void {
  const ctx = resolveQuestCallbackByTriggerPlayer();
  if (!ctx) return;
  const { state, questIdx, onReject } = ctx;
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue.splice(0, questIdx + 1);
  resetDialogActiveFlagsKeepOnFinish(state);
  onReject();
  if (state.queue.length === 0) {
    onDialogFinished(state);
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer === targetPlayer) {
      showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
      showDialogFrames(state, false);
    }
  } else {
    const localPlayer = dzGetLocalPlayer();
    const targetPlayer = dzPlayer(state.playerId);
    if (localPlayer === targetPlayer) {
      showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
    }
    playEntry(state);
  }
}

(globalThis as any).QuestAcceptCallback = questAcceptCallback;
(globalThis as any).QuestRejectCallback = questRejectCallback;

/** 正文/标题等 TEXT 叠在背景上会抢走点击，需与背景按钮共用同一套逻辑 */
function handleDialogPanelClick(state: PlayerDialogState): void {
  /** 打字机未打完：允许随时点击跳过；skipTyping 会清 clickCooldown，避免 playEntry 首帧计时器未到时 ~/点击与「等点击」状态打架 */
  if (state.strNow < state.strLen) {
    skipTyping(state);
    return;
  }
  if (state.clickCooldown) return;
  if (state.waitingClick && state.queue.length > 0 && !state.queue[0].isQuest) {
    state.waitingClick = false;
    advanceDialog(state);
  }
}

/**
 * sync=true：全房同一次 `advanceDialog`；匿名闭包 + sync=false 会导致仅点击端推进队列，后续点「接受任务」时各端队列不一致 → 接受回调解析失败/掉线。
 * 非点击端 `DzGetTriggerUIEventFrame` 可能为 0：用与「等点击」一致的 `setActivePlayerId` 回退（勿扫全表，易与各端 waiting 状态漂移冲突 → 误 advance）。
 */
function dialogPanelHitCallback(): void {
  let hitFrame: Frame = 0;
  if (typeof (japi as any).DzGetTriggerUIEventFrame === "function") {
    hitFrame = (japi as any).DzGetTriggerUIEventFrame() as Frame;
  }
  if (hitFrame && hitFrame !== 0) {
    for (let i = 0; i < MAX_PLAYERS; i++) {
      const s = g_states[i];
      if (!s) continue;
      if (s.frames[4] !== hitFrame && s.frames[3] !== hitFrame && s.frames[2] !== hitFrame && s.frames[11] !== hitFrame && s.frames[12] !== hitFrame) continue;
      handleDialogPanelClick(s);
      return;
    }
  }
  const aid = getActivePlayerId();
  if (aid >= 0 && aid < MAX_PLAYERS) {
    const s = g_states[aid];
    if (!s || s.queue.length === 0) return;
    /** 非点击端无 TriggerFrame：与 setActivePlayerId(playEntry) 对齐，同步「跳过打字机」与「点继续」 */
    if (s.strNow < s.strLen) {
      handleDialogPanelClick(s);
      return;
    }
    if (s.waitingClick && !s.queue[0].isQuest) {
      handleDialogPanelClick(s);
    }
  }
}

(globalThis as any).DialogPanelHitCallback = dialogPanelHitCallback;

export function bindDialogPanelHitFrame(hitFrame: Frame): void {
  if (!hitFrame || hitFrame === 0) return;
  frameSetScriptByCode(hitFrame, 1, dialogPanelHitCallback, true);
}

// ========== 虚拟分区：~ 键跳过对话 ==========
/**
 * ~ 键：sync=false，仅在按键玩家端执行，用 dzGetLocalPlayer() 定位本地状态。
 *
 * - 有任务行：本地快进到任务页（不改队列，接受/拒绝走 sync=true）。
 * - 仅普通行：
 *     打字未完 → skipTyping 补全、进入"等点击"。
 *     已等点击 → 用 DzClickFrame 模拟点击对话框背景帧，触发 dialogPanelHitCallback
 *               （注册时 sync=true），让全房同步推进队列。连续模拟点击直到队列清空。
 */
function skipDialogLocal(): void {
  const localPlayer = dzGetLocalPlayer();
  let state: PlayerDialogState | undefined;
  for (let i = 0; i < MAX_PLAYERS; i++) {
    const st = g_states[i];
    if (!st || st.queue.length === 0) continue;
    if (dzPlayer(i) === localPlayer) { state = st; break; }
  }
  if (!state) return;

  dzTimerPause(state.tickTimer);

  const questIdx = findFirstQuestEntryIndex(state);
  if (questIdx >= 0) {
    // 有任务行：本地快进到任务页（不改队列）
    if (state.strNow < state.strLen) {
      state.strNow = state.strLen;
      const head = state.queue[0];
      if (head !== undefined) dzSetText(state.frames[3], head.text);
    }
    const questEntry = state.queue[questIdx];
    dzSetFont(state.frames[2], DEFAULT_FONT, questEntry.titleFontSize);
    dzSetFont(state.frames[3], DEFAULT_FONT, questEntry.bodyFontSize);
    dzSetText(state.frames[2], questEntry.title);
    dzSetText(state.frames[3], questEntry.text);
    showDialogFrames(state, true);
    applyPortraitFrames(questEntry, state.frames, dzSetTexture, dzShow);
    const buttonTexts = resolveQuestButtonTexts(questEntry.acceptText, questEntry.rejectText);
    setQuestButtonTexts(state, buttonTexts.accept, buttonTexts.reject, dzGetLocalPlayer, dzPlayer);
    showQuestButtons(state, true, dzGetLocalPlayer, dzPlayer, dzShow);
    return;
  }

  // 仅普通行：先补全当前句打字
  if (state.strNow < state.strLen) {
    skipTyping(state);
    // 补全后进入等点击状态，再继续往下用 DzClickFrame 推进
  }

  // 用 DzClickFrame 模拟点击背景帧（frames[4]），触发 sync=true 的 dialogPanelHitCallback
  // 连续点击直到队列全部清空（每次 DzClickFrame 相当于玩家点击一次面板）
  const hitFrame = state.frames[4];
  if (hitFrame && hitFrame !== 0 && typeof (japi as any).DzClickFrame === "function") {
    let guard = 0;
    while (state.queue.length > 0 && !state.queue[0].isQuest && guard < 256) {
      guard++;
      (japi as any).DzClickFrame(hitFrame);
    }
  }
}

// 初始化跳过键监听（sync=false：只在按键玩家端触发）
let g_skipKeyInitialized = false;
export function initSkipKeyListener(): void {
  if (g_skipKeyInitialized) return;
  g_skipKeyInitialized = true;
  registerKeyEventByCode(KEY_SKIP_DIALOG, KEY_STATE.DOWN, false, () => {
    skipDialogLocal();
  });
}

export function bindQuestSyncHandlersImpl(state: PlayerDialogState): void {
  if (state.questSyncHandlersBound || !state.frames || state.frames.length === 0) return;
  frameSetScriptByCode(state.frames[6], 1, questAcceptCallback, true);
  frameSetScriptByCode(state.frames[8], 1, questRejectCallback, true);
  state.questSyncHandlersBound = true;
}

setDialogPanelHitBinder(bindDialogPanelHitFrame);
