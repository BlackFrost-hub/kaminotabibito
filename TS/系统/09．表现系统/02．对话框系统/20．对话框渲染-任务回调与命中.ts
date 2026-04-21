const jass = require("jass.common") as any;

import { frameSetScriptByCode, registerKeyEventByCode } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { KEY_STATE } from "../../../lib/扩展函数/封装函数/04．硬件输入/01．常量定义";
import { applyPortraitFrames } from "./03．对话框立绘系统";
import { resolveQuestButtonTexts, setQuestButtonTexts, showQuestButtons } from "./04．任务对话框";
import { Frame, PlayerDialogState, onDialogFinished, resetDialogActiveFlagsKeepOnFinish } from "./05．对话框业务逻辑";
import { getActivePlayerId, resetActivePlayerIdIfMatch, setActivePlayerId } from "./16．对话框同步状态";
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
import { stringLengthCompat } from "./02．打字机效果";
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
    } else {
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
  hitFrame = (japi as any).DzGetTriggerUIEventFrame() as Frame;
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
 * ~ 键：**实测走 sync=true**（registerKeyEventByCode 内部最终调用 DzTriggerRegisterKeyEventTrg，
 * 硬编码 sync=true，传入的 sync 参数被忽略，详见 jass-pitfalls 规则）。
 *
 * 因此此回调全房所有客户端都会触发，**严禁用 dzGetLocalPlayer() 去定位 state**
 * （各端 localPlayer 不同，会导致 P1 端写 state.strNow/PauseTimer、P2 端提前 return，
 * 共享 Lua 状态与引擎定时器在两端分歧 → 在后续大量引擎调用（如提交成功链）处踩爆 desync）。
 *
 * 改为用 DzGetTriggerKeyPlayer()（全房一致）定位 trigger 玩家的 state，所有客户端执行相同分支。
 * 唯一必须局部化的是 DzClickFrame：它会触发 sync=true 的 dialogPanelHitCallback 在全房推进队列，
 * 如果每客户端都 Click 一次，队列会被乘以客户端数倍速推进 → 所以只在按键玩家本地执行。
 *
 * - 有任务行：快进到任务页（不改队列，接受/拒绝走 sync=true）。
 * - 仅普通行：
 *     多句 → 一次 ~ 裁剪队列到**最后一句**并全文显示（纯 Lua，无连点 DzClickFrame）。
 *     单句打字中 → skipTyping 补全；单句已读完 → 触发玩家端单次 DzClickFrame 关面板/推进。
 */
/**
 * 每玩家独立 ~ 键冷却：防止疯狂连按导致提交/日后谈对白链上引擎调用堆叠 → 即便已修 desync，
 * 也能避免"对话框都还没渲染完就又被 ~ 推进下一步"的 UI 紊乱。
 * 数组长度 MAX_PLAYERS，sync=true 回调里对称读写，所有客户端状态一致。
 */
const SKIP_KEY_COOLDOWN_SECONDS = 0.08;
const g_skipKeyCooldown: boolean[] = [];

function startSkipKeyCooldown(pid: number): void {
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  g_skipKeyCooldown[pid] = true;
  const t = jass.CreateTimer();
  jass.TimerStart(t, SKIP_KEY_COOLDOWN_SECONDS, false, () => {
    g_skipKeyCooldown[pid] = false;
    jass.PauseTimer(t);
    jass.DestroyTimer(t);
  });
}

/**
 * 多句纯对白：一次 ~ 将队列裁剪为**只保留最后一句**（全房对称 Lua），并显示全文 +「点击继续」。
 * 不使用 DzClickFrame 连点，避免单帧 sync 堆叠；**关闭本段对话**仍需再按 ~ 或点背景（单次 DzClickFrame）。
 */
function fastForwardQueueToLastNormalLine(state: PlayerDialogState): void {
  if (state.queue.length <= 1) return;
  const last = state.queue[state.queue.length - 1];
  if (!last || last.isQuest) return;
  state.queue = [last];

  showQuestButtons(state, false, dzGetLocalPlayer, dzPlayer, dzShow);
  dzShow(state.frames[11], false);
  dzTimerPause(state.tickTimer);

  const entry = state.queue[0]!;
  state.strLen = stringLengthCompat(entry.text);
  state.strNow = state.strLen;
  state.waitingClick = true;
  state.clickCooldown = false;
  setActivePlayerId(state.playerId);

  dzSetFont(state.frames[2], DEFAULT_FONT, entry.titleFontSize);
  dzSetFont(state.frames[3], DEFAULT_FONT, entry.bodyFontSize);
  dzSetText(state.frames[2], entry.title);
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer === targetPlayer) {
    dzSetText(state.frames[3], entry.text);
  }
  /**
   * 顺序必须与 `playEntry` 一致：`showDialogFrames(true)` 会把 101–103 立绘槽一律 Show，
   * 再由 `applyPortraitFrames` 按是否有贴图关掉空槽。若先 apply 再 showDialogFrames，
   * 会再次把三槽全开 + 空贴图 → 引擎典型 **整屏竖绿条** 占位。
   */
  showDialogFrames(state, true);
  applyPortraitFrames(entry, state.frames, dzSetTexture, dzShow);
  if (localPlayer === targetPlayer) {
    dzShow(state.frames[11], true);
  }
}

function skipDialogLocal(): void {
  const triggerPlayer = (japi as any).DzGetTriggerKeyPlayer();
  if (!triggerPlayer) return;
  const triggerPid = dzGetPlayerId(triggerPlayer);
  if (triggerPid == null || triggerPid < 0 || triggerPid >= MAX_PLAYERS) return;
  if (g_skipKeyCooldown[triggerPid]) return;
  const state = g_states[triggerPid];
  if (!state || state.queue.length === 0) return;

  /** CD 写入必须在任何"本次按键已生效"的分支前，且只在确认会真正处理时计 */
  startSkipKeyCooldown(triggerPid);

  dzTimerPause(state.tickTimer);

  const questIdx = findFirstQuestEntryIndex(state);
  if (questIdx >= 0) {
    // 有任务行：快进到任务页（不改队列）。所有客户端对称写 state.strNow。
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

  /**
   * 多句纯对白（队首到队尾皆普通行，无任务行）：一次 ~ 直接「到最后一句」全文 + 等点击，
   * 不触发 DzClickFrame 连点；结束本句/本段仍靠再按 ~ 或点背景（下方单次 DzClickFrame）。
   */
  if (state.queue.length > 1) {
    fastForwardQueueToLastNormalLine(state);
    return;
  }

  /**
   * 单句普通行两段式：
   *   第一次按 ~：打字机未完 → 只 skipTyping 补完当前句，return。
   *   第二次按 ~：strNow == strLen → 走 DzClickFrame 关闭/推进。
   *
   * 不能在同一次按键里"补打字 + DzClickFrame"：全房同一 sync=true tick 内叠加过重。
   */
  if (state.strNow < state.strLen) {
    skipTyping(state);
    return;
  }

  /**
   * DzClickFrame：sync=true 帧脚本，全房对称 → `advanceDialog`。
   * **每次 ~ 至多一次**（等同鼠标点一下背景），避免单 tick 内连点 N 次。
   */
  const lp = dzGetLocalPlayer();
  if (lp === triggerPlayer) {
    const hitFrame = state.frames[4];
    if (hitFrame && hitFrame !== 0 && state.queue.length > 0 && !state.queue[0].isQuest) {
      (japi as any).DzClickFrame(hitFrame);
    }
  }
}

// 初始化跳过键监听（registerKeyEventByCode 实际仍走 sync=true 全房触发，见文件头注释）
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
