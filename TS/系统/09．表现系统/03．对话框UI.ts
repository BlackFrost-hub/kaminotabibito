/**
 * 对话框UI系统（StarGameDialog TS版）
 *
 * 特性：
 * - 每个玩家独立的对话队列 + 独立计时器，互不干扰
 * - 所有 UI 操作通过 GetLocalPlayer() 本地判断，防止 desync
 * - 支持打字机逐字效果、左/中/右三位立绘、自定义背景/标题贴图
 * - 与 TSTL 兼容（无 class 私有成员 #、无 Symbol、无 WeakMap）
 *
 * 帧索引规范：
 *   [0]   背景 BACKDROP
 *   [1]   标题栏背景（GameUI）
 *   [2]   名字文字（GameText）
 *   [3]   正文文字（GameTextpxL）
 *   [4]   背景透明点击层（GLUETEXTBUTTON，铺满[0]）
 *   [5]   接受按钮底图（BACKDROP，任务模式）
 *   [6]   接受按钮命中层（GLUETEXTBUTTON，铺满[5]）
 *   [7]   拒绝按钮底图（BACKDROP，任务模式）
 *   [8]   拒绝按钮命中层（GLUETEXTBUTTON，铺满[7]）
 *   [9]   接受按钮文字标签（TEXT，叠在[5]上）
 *   [10]  拒绝按钮文字标签（TEXT，叠在[7]上）
 *   [11]  "点击以继续 ▼" 提示标签（TEXT，背景右下角，打字完成后显示）
 *   [101] 左立绘（GameUI）
 *   [102] 中立绘（GameUI）
 *   [103] 右立绘（GameUI）
 */

const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;

import { createFrame, FrameType } from "../09．表现系统/01．UI工具";
import { frameSetScriptByCode } from "../00．核心系统/04．硬件函数";
import { Sound3DII_Mp3PlayReuse } from "../00．核心系统/02．音效函数";

/** 对话框首次展开时的提示音效 */
const DIALOG_OPEN_SOUND = "Sound\\Interface\\SecretFound.wav";

// ────────────────────────────────────────────────
// 类型别名
// ────────────────────────────────────────────────

/** WC3 player 句柄（Lua 下为 userdata，TS 侧用 any） */
type Player = any;
/** WC3 timer 句柄 */
type Timer = any;
/** Dz 帧句柄（整数） */
type Frame = number;

// ────────────────────────────────────────────────
// 常量
// ────────────────────────────────────────────────

/** 最大支持玩家数 */
const MAX_PLAYERS = 28;

/** 打字机每帧步进（字符数）*/
const STEP_LEN = 2;

/** 打字机帧间隔（秒）*/
const TICK = 0.03;

/** TOC 加载路径 */
const TOC_PATH = "ui\\StarGameUI.toc";

/** 对话框帧标签起始 ID（原版对应 tag=1024）*/
const TAG_BASE_MAIN = 1024;
const TAG_BASE_PORTRAIT = 1125;

// ────────────────────────────────────────────────
// 默认资源路径（未指定时使用）
// ────────────────────────────────────────────────

/** 默认字体路径 */
const DEFAULT_FONT = "UI\\uizt.ttf";
/** 默认标题字体大小 */
const DEFAULT_TITLE_FONT_SIZE = 0.018;
/** 默认正文字体大小 */
const DEFAULT_BODY_FONT_SIZE = 0.012;
/** 默认背景贴图（文本框框架） */
const DEFAULT_BG_TEX = "UI\\wenbenkuang.blp";
/** 默认标题栏贴图 */
const DEFAULT_TITLE_TEX = "UI\\wenbenkuang.blp";

// ────────────────────────────────────────────────
// 每条对话条目
// ────────────────────────────────────────────────

interface DialogEntry {
  title: string;
  text: string;
  waitTime: number;
  leftTex: string;
  midTex: string;
  rightTex: string;
  titleFontSize: number;
  bodyFontSize: number;
  /** 是否为任务对话（显示接受/拒绝按钮，不自动推进） */
  isQuest: boolean;
  /** 任务回调（isQuest=true 时有效） */
  questCallbacks?: {
    onAccept: () => void;
    onReject: () => void;
  };
}

// ────────────────────────────────────────────────
// 每个玩家独立的对话框状态
// ────────────────────────────────────────────────

interface PlayerDialogState {
  /** 玩家索引 0-based */
  playerId: number;
  /** 对话队列（先进先出） */
  queue: DialogEntry[];
  /** 打字机计时器（逐字） */
  tickTimer: Timer;
  /** 7个帧句柄：[0..10] 主体按钮, [101..103] 立绘 */
  frames: Frame[];
  /** 当前正文已显示字符数 */
  strNow: number;
  /** 当前正文总字符数 */
  strLen: number;
  /** 是否允许显示（本地玩家开关） */
  canShow: boolean;
  /** 系统是否已初始化帧 */
  initialized: boolean;
  /** 对话框是否正在活跃播放（用于拒绝重复触发） */
  isActive: boolean;
  /** 对话框刚弹出的点击冷却（防止点NPC同时命中背景层） */
  clickCooldown: boolean;
  /** 文字已全部显示，等待玩家点击才推进（而非自动计时） */
  waitingClick: boolean;
  /** 对话队列全部播完后的回调（调用方用来重置自身状态锁） */
  onFinish?: () => void;
}

// ────────────────────────────────────────────────
// 全局状态表（按玩家 ID 索引）
// ────────────────────────────────────────────────

const g_states: PlayerDialogState[] = [];

// ────────────────────────────────────────────────
// Dz API 安全调用封装
// ────────────────────────────────────────────────

function dzShow(f: Frame, b: boolean): void {
  if (f && f !== 0 && typeof japi.DzFrameShow === "function") {
    japi.DzFrameShow(f, b);
  }
}

function dzSetText(f: Frame, s: string): void {
  if (f && f !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(f, s);
  }
}

function dzSetTexture(f: Frame, path: string): void {
  if (f && f !== 0 && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(f, path, 0);
  }
}

function dzSetAlpha(f: Frame, a: number): void {
  if (f && f !== 0 && typeof japi.DzFrameSetAlpha === "function") {
    japi.DzFrameSetAlpha(f, a);
  }
}

function dzSetAbsPoint(f: Frame, point: number, x: number, y: number): void {
  if (f && f !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") {
    japi.DzFrameSetAbsolutePoint(f, point, x, y);
  }
}

function dzSetSize(f: Frame, w: number, h: number): void {
  if (f && f !== 0 && typeof japi.DzFrameSetSize === "function") {
    japi.DzFrameSetSize(f, w, h);
  }
}

function dzClearPoints(f: Frame): void {
  if (f && f !== 0 && typeof japi.DzFrameClearAllPoints === "function") {
    japi.DzFrameClearAllPoints(f);
  }
}

function dzSetEnable(f: Frame, b: boolean): void {
  if (f && f !== 0 && typeof japi.DzFrameSetEnable === "function") {
    japi.DzFrameSetEnable(f, b);
  }
}

function dzSetFont(f: Frame, font: string, size: number): void {
  if (f && f !== 0 && typeof japi.DzFrameSetFont === "function") {
    japi.DzFrameSetFont(f, font, size, 0);
  }
}

function dzCreate(template: string, tag: number): Frame {
  const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;
  if (!gameUI || gameUI === 0) return 0;
  if (typeof japi.DzCreateFrame !== "function") return 0;
  return japi.DzCreateFrame(template, gameUI, tag) as Frame;
}


function dzSubString(s: string, start: number, end: number): string {
  if (typeof jass.SubString === "function") return jass.SubString(s, start, end) as string;
  // fallback：Lua string.sub（1-based，转换）
  return (s as any).sub(start + 1, end) as string;
}

function dzStringLength(s: string): number {
  if (typeof jass.StringLength === "function") return jass.StringLength(s) as number;
  return s.length;
}

function dzGetLocalPlayer(): Player {
  return typeof jass.GetLocalPlayer === "function" ? jass.GetLocalPlayer() : null;
}

function dzGetPlayerId(p: Player): number {
  return typeof jass.GetPlayerId === "function" ? (jass.GetPlayerId(p) as number) : -1;
}

function dzPlayer(index: number): Player {
  return typeof jass.Player === "function" ? jass.Player(index) : null;
}

function dzTimerCreate(): Timer {
  return typeof jass.CreateTimer === "function" ? jass.CreateTimer() : null;
}

function dzTimerStart(t: Timer, timeout: number, periodic: boolean, cb: () => void): void {
  if (t && typeof jass.TimerStart === "function") {
    jass.TimerStart(t, timeout, periodic, cb);
  }
}

function dzTimerPause(t: Timer): void {
  if (t && typeof jass.PauseTimer === "function") {
    jass.PauseTimer(t);
  }
}

function dzLoadToc(): void {
  if (typeof japi.DzLoadToc === "function") {
    japi.DzLoadToc(TOC_PATH);
  }
}

/** TOC 是否已加载过（全局只需一次） */
let g_tocLoaded = false;

function dzLoadTocOnce(): void {
  if (g_tocLoaded) return;
  g_tocLoaded = true;
  dzLoadToc();
}

// ────────────────────────────────────────────────
// 内部：创建某个玩家的帧组
// ────────────────────────────────────────────────

/**
 * 为指定玩家创建对话框帧（只有本地玩家才真正执行创建）
 * 返回帧数组（非本地玩家返回全0数组，避免 desync）
 */
function createDialogFrames(): Frame[] {
  // 只初始化实际使用的槽位：[0..11] 主体，[101..103] 立绘
  const frames: Frame[] = [];
  for (let i = 0; i <= 11; i++) frames[i] = 0;
  frames[101] = 0; frames[102] = 0; frames[103] = 0;

  // 立绘帧 [101] [102] [103]
  const portraits = [
    { idx: 101, tag: TAG_BASE_PORTRAIT,     x: 0.24,                    y: 0.1421 + 0.2 },
    { idx: 102, tag: TAG_BASE_PORTRAIT + 1, x: 0.24 + 0.377 / 3,        y: 0.1421 + 0.2 },
    { idx: 103, tag: TAG_BASE_PORTRAIT + 2, x: 0.24 + 0.377 / 1.5,      y: 0.1421 + 0.2 },
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

  // [0] 背景 BACKDROP
  const gameUI = typeof japi.DzGetGameUI === "function" ? japi.DzGetGameUI() : 0;
  const bg = createFrame({ type: FrameType.BACKDROP, name: "DialogBG", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[0] = bg;
  dzClearPoints(bg);
  dzSetAbsPoint(bg, 3, 0.23, 0.2421);
  dzSetSize(bg, 0.377, 0.131);
  dzSetAlpha(bg, 255);
  dzSetTexture(bg, DEFAULT_BG_TEX);

  // [4] 透明 GLUETEXTBUTTON 铺满背景，作为点击命中层
  const bgBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogBGBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[4] = bgBtn;
  // 内联 setupTransparentGlueHitLayer：把 bgBtn 挂到 bg 下并铺满，文字清空，alpha=0
  if (bgBtn !== 0) {
    if (typeof japi.DzFrameSetParent === "function") {
      (pcall as any)(() => japi.DzFrameSetParent(bgBtn, bg));
    }
    if (typeof japi.DzFrameClearAllPoints === "function") {
      (pcall as any)(() => japi.DzFrameClearAllPoints(bgBtn));
    }
    if (typeof japi.DzFrameSetAllPoints === "function") {
      (pcall as any)(() => japi.DzFrameSetAllPoints(bgBtn, bg));
    }
    if (typeof japi.DzFrameSetText === "function") {
      japi.DzFrameSetText(bgBtn, "");
    }
    if (typeof japi.DzFrameSetAlpha === "function") {
      (pcall as any)(() => japi.DzFrameSetAlpha(bgBtn, 0));
    }
  }
  // 点击：打字中→跳过打字机；完整文本且非任务→推进队列
  frameSetScriptByCode(bgBtn, 1, () => {
    let found = false;
    for (let i = 0; i < MAX_PLAYERS; i++) {
      const s = g_states[i];
      if (s && s.frames[0] === bg) {
        // 冷却中（对话框刚弹出），忽略本次点击，防止点NPC穿透到背景层
        if (s.clickCooldown) {
          // 什么都不做
        } else if (s.strNow < s.strLen) {
          // 打字机还在跑：跳过打字机，显示完整文本，然后等待再次点击
          skipTyping(s);
        } else if (s.waitingClick && s.queue.length > 0 && !s.queue[0].isQuest) {
          // 文字已全部显示，玩家点击推进到下一条或结束
          s.waitingClick = false;
          advanceDialog(s);
        }
        // 任务模式且文字已完整：点击背景无效，必须点按钮
        found = true;
        break;
      }
    }
  }, false);

  // [1] 标题栏背景
  const titleBg = dzCreate("GameUI", TAG_BASE_MAIN + 2);
  frames[1] = titleBg;
  dzShow(titleBg, false);
  dzClearPoints(titleBg);
  dzSetAbsPoint(titleBg, 3, 0.24, 0.3083);
  dzSetSize(titleBg, 0.107, 0.0328);
  dzSetAlpha(titleBg, 255);
  dzSetTexture(titleBg, DEFAULT_TITLE_TEX);

  // [2] 名字文字
  const nameText = dzCreate("GameText", TAG_BASE_MAIN + 3);
  frames[2] = nameText;
  dzShow(nameText, false);
  dzClearPoints(nameText);
  if (nameText !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    (pcall as any)(() => japi.DzFrameSetAllPoints(nameText, titleBg));
  }
  dzSetText(nameText, "");
  dzSetFont(nameText, DEFAULT_FONT, DEFAULT_TITLE_FONT_SIZE);
  dzSetEnable(nameText, false);
  if (nameText !== 0 && typeof japi.DzFrameSetTextAlignment === "function") {
    (pcall as any)(() => {
      japi.DzFrameSetTextAlignment(nameText, -1);
      japi.DzFrameSetTextAlignment(nameText, 18);
    });
  }

  // [3] 正文文字
  const bodyText = dzCreate("GameTextpxL", TAG_BASE_MAIN + 4);
  frames[3] = bodyText;
  dzShow(bodyText, false);
  dzClearPoints(bodyText);
  dzSetAbsPoint(bodyText, 0, 0.24, 0.28);
  dzSetSize(bodyText, 0.35, 0.22);
  dzSetText(bodyText, "");
  dzSetFont(bodyText, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE);
  dzSetEnable(bodyText, false);

  // [5] 接受按钮底图 BACKDROP（承载贴图）
  const acceptBg = createFrame({ type: FrameType.BACKDROP, name: "DialogAcceptBg", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[5] = acceptBg;
  if (acceptBg !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") {
    japi.DzFrameSetAbsolutePoint(acceptBg, 4, 0.311, 0.1800);
  }
  if (acceptBg !== 0 && typeof japi.DzFrameSetSize === "function") {
    japi.DzFrameSetSize(acceptBg, 0.08, 0.022);
  }
  if (acceptBg !== 0 && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(acceptBg, "UI\\renwu\\jieshourenwuanniu.tga", 0);
  }
  // 接受按钮文字（叠在底图上，白色）存入 frames[9] 供 showQuestButtons 控制可见性
  const acceptLabel = createFrame({ type: FrameType.TEXT, name: "DialogAcceptLabel", parent: acceptBg, template: "template", visible: false }) ?? 0;
  frames[9] = acceptLabel;
  if (acceptLabel !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(acceptLabel, acceptBg);
  }
  if (acceptLabel !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(acceptLabel, "接受任务");
  }
  if (acceptLabel !== 0 && typeof japi.DzFrameSetTextColor === "function") {
    japi.DzFrameSetTextColor(acceptLabel, 255, 255, 255, 255);
  }
  if (acceptLabel !== 0 && typeof japi.DzFrameSetFont === "function") {
    japi.DzFrameSetFont(acceptLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0);
  }
  if (acceptLabel !== 0 && typeof japi.DzFrameSetTextAlignment === "function") {
    japi.DzFrameSetTextAlignment(acceptLabel, 18); // 居中
  }

  // [6] 接受按钮命中层 GLUETEXTBUTTON（铺满[5]，接收点击，alpha=0 透明）
  const acceptBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogAcceptBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[6] = acceptBtn;
  if (acceptBtn !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(acceptBtn, acceptBg);
  }
  if (acceptBtn !== 0 && typeof japi.DzFrameSetAlpha === "function") {
    japi.DzFrameSetAlpha(acceptBtn, 0);
  }
  if (acceptBtn !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(acceptBtn, "");
  }

  // [7] 拒绝按钮底图 BACKDROP（承载贴图）
  const rejectBg = createFrame({ type: FrameType.BACKDROP, name: "DialogRejectBg", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[7] = rejectBg;
  if (rejectBg !== 0 && typeof japi.DzFrameSetAbsolutePoint === "function") {
    japi.DzFrameSetAbsolutePoint(rejectBg, 4, 0.406, 0.1800);
  }
  if (rejectBg !== 0 && typeof japi.DzFrameSetSize === "function") {
    japi.DzFrameSetSize(rejectBg, 0.08, 0.022);
  }
  if (rejectBg !== 0 && typeof japi.DzFrameSetTexture === "function") {
    japi.DzFrameSetTexture(rejectBg, "UI\\renwu\\jieshourenwuanniu.tga", 0);
  }
  // 拒绝按钮文字（叠在底图上，白色）存入 frames[10] 供 showQuestButtons 控制可见性
  const rejectLabel = createFrame({ type: FrameType.TEXT, name: "DialogRejectLabel", parent: rejectBg, template: "template", visible: false }) ?? 0;
  frames[10] = rejectLabel;
  if (rejectLabel !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(rejectLabel, rejectBg);
  }
  if (rejectLabel !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(rejectLabel, "拒绝任务");
  }
  if (rejectLabel !== 0 && typeof japi.DzFrameSetTextColor === "function") {
    japi.DzFrameSetTextColor(rejectLabel, 255, 255, 255, 255);
  }
  if (rejectLabel !== 0 && typeof japi.DzFrameSetFont === "function") {
    japi.DzFrameSetFont(rejectLabel, DEFAULT_FONT, DEFAULT_BODY_FONT_SIZE, 0);
  }
  if (rejectLabel !== 0 && typeof japi.DzFrameSetTextAlignment === "function") {
    japi.DzFrameSetTextAlignment(rejectLabel, 18); // 居中
  }

  // [8] 拒绝按钮命中层 GLUETEXTBUTTON（铺满[7]，接收点击，alpha=0 透明）
  const rejectBtn = createFrame({ type: FrameType.GLUETEXTBUTTON, name: "DialogRejectBtn", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[8] = rejectBtn;
  if (rejectBtn !== 0 && typeof japi.DzFrameSetAllPoints === "function") {
    japi.DzFrameSetAllPoints(rejectBtn, rejectBg);
  }
  if (rejectBtn !== 0 && typeof japi.DzFrameSetAlpha === "function") {
    japi.DzFrameSetAlpha(rejectBtn, 0);
  }
  if (rejectBtn !== 0 && typeof japi.DzFrameSetText === "function") {
    japi.DzFrameSetText(rejectBtn, "");
  }

  // [11] "点击以继续 ▼" 提示文字，锚定在背景右下角，打字完成后显示
  const hintLabel = createFrame({ type: FrameType.TEXT, name: "DialogHintLabel", parent: gameUI, template: "template", visible: false }) ?? 0;
  frames[11] = hintLabel;
  if (hintLabel !== 0) {
    // 右下角：point=8(BOTTOMRIGHT), bg 右下角内缩一点点
    if (typeof japi.DzFrameSetPoint === "function") {
      // 相对 bg 的 BOTTOMRIGHT，向左偏移 0.008，向上偏移 0.008
      (pcall as any)(() => japi.DzFrameSetPoint(hintLabel, 8, bg, 8, -0.008, 0.008));
    }
    if (typeof japi.DzFrameSetSize === "function") {
      japi.DzFrameSetSize(hintLabel, 0.12, 0.018);
    }
    if (typeof japi.DzFrameSetText === "function") {
      japi.DzFrameSetText(hintLabel, "|cff333333[点击以继续] ↓|r");
    }
    if (typeof japi.DzFrameSetFont === "function") {
      japi.DzFrameSetFont(hintLabel, DEFAULT_FONT, 0.016, 0);
    }
    if (typeof japi.DzFrameSetTextAlignment === "function") {
      // 右对齐
      japi.DzFrameSetTextAlignment(hintLabel, -1);
      japi.DzFrameSetTextAlignment(hintLabel, 5);
    }
  }

  return frames;
}

// ────────────────────────────────────────────────
// 内部：初始化单个玩家的状态
// ────────────────────────────────────────────────

function ensureState(playerId: number): PlayerDialogState {
  if (g_states[playerId]) return g_states[playerId];

  const state: PlayerDialogState = {
    playerId,
    queue: [],
    tickTimer: dzTimerCreate(),
    frames: [],
    strNow: 0,
    strLen: 0,
    canShow: true,
    initialized: false,
    isActive: false,
    clickCooldown: false,
    waitingClick: false,
  };
  g_states[playerId] = state;
  return state;
}

// ────────────────────────────────────────────────
// 内部：显示/隐藏帧组（本地判断）
// ────────────────────────────────────────────────

function showDialogFrames(state: PlayerDialogState, visible: boolean): void {
  // 非本地玩家：完全不操作 UI，防止 desync
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  if (!state.canShow) {
    // canShow=false 时强制隐藏
    for (let i = 0; i < 9; i++) {
      dzShow(state.frames[i], false);
    }
    for (let i = 101; i < 104; i++) {
      dzShow(state.frames[i], false);
    }
    return;
  }

  // [5]~[8] 任务按钮由 showQuestButtons 单独控制，这里只控制主体帧
  for (let i = 0; i < 5; i++) {
    dzShow(state.frames[i], visible);
  }
  if (!visible) {
    dzShow(state.frames[5], false);
    dzShow(state.frames[6], false);
    dzShow(state.frames[7], false);
    dzShow(state.frames[8], false);
    dzShow(state.frames[9], false);
    dzShow(state.frames[10], false);
    dzShow(state.frames[11], false); // "点击以继续 ▼" 提示
  }
  if (visible) {
    dzSetAlpha(state.frames[0], 155);
  }
  for (let i = 101; i < 104; i++) {
    dzShow(state.frames[i], visible);
  }
}

// ────────────────────────────────────────────────
// 内部：清空队列并隐藏
// ────────────────────────────────────────────────

function clearState(state: PlayerDialogState): void {
  dzTimerPause(state.tickTimer);
  state.queue = [];
  state.isActive = false;
  state.waitingClick = false;
  state.clickCooldown = false;
  showDialogFrames(state, false);
  // 通知调用方对话已结束（强制清除时也触发）
  const cb = state.onFinish;
  state.onFinish = undefined;
  if (cb) cb();
}

// ────────────────────────────────────────────────
// 内部：开始显示队列第一条
// ────────────────────────────────────────────────

function playEntry(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;

  // 首次展开检测：对话框从关闭状态变为激活状态时才播放音效
  const isFirstOpen = !state.isActive;

  state.isActive = true;
  state.waitingClick = false;
  state.clickCooldown = true; // 对话框刚弹出，屏蔽第一次点击（防止点NPC穿透到背景层）

  // 确保帧已创建（本地判断在 createDialogFrames 外层做）
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  const isLocal = localPlayer === targetPlayer;

  if (isLocal && !state.initialized) {
    dzLoadTocOnce();
    state.frames = createDialogFrames();
    state.initialized = true;
  }

  showDialogFrames(state, true);

  // 首次展开时播放提示音效（仅对目标玩家，Sound3DII_Mp3PlayReuse 内部处理本地判断，不会异步）
  if (isFirstOpen) {
    Sound3DII_Mp3PlayReuse(DIALOG_OPEN_SOUND, targetPlayer);
  }

  if (!isLocal) {
    // 非本地：跳过所有 UI 操作，只走定时器逻辑让队列推进
    // 打字机跑完后直接 advanceDialog（本地玩家靠点击推进，非本地无点击事件）
    const entry = state.queue[0];
    state.strLen = dzStringLength(entry.text);
    state.strNow = 0;
    dzTimerStart(state.tickTimer, TICK, true, () => {
      if (state.queue.length === 0) { dzTimerPause(state.tickTimer); return; }
      state.strNow += STEP_LEN;
      state.clickCooldown = false;
      if (state.strNow >= state.strLen) {
        dzTimerPause(state.tickTimer);
        if (!state.queue[0].isQuest) {
          // 普通对白：自动推进（非本地没有点击）
          advanceDialog(state);
        }
        // 任务对话：非本地玩家不处理，等待本地玩家点击按钮触发回调
      }
    });
    return;
  }

  const entry = state.queue[0];

  // 设置标题与清空正文
  dzSetFont(state.frames[2], DEFAULT_FONT, entry.titleFontSize);
  dzSetFont(state.frames[3], DEFAULT_FONT, entry.bodyFontSize);
  dzSetText(state.frames[2], entry.title);
  dzSetText(state.frames[3], "");

  // 立绘：左
  if (entry.leftTex !== "") {
    dzSetTexture(state.frames[101], entry.leftTex);
    dzShow(state.frames[101], true);
  } else {
    dzShow(state.frames[101], false);
  }
  // 立绘：中
  if (entry.midTex !== "") {
    dzSetTexture(state.frames[102], entry.midTex);
    dzShow(state.frames[102], true);
  } else {
    dzShow(state.frames[102], false);
  }
  // 立绘：右
  if (entry.rightTex !== "") {
    dzSetTexture(state.frames[103], entry.rightTex);
    dzShow(state.frames[103], true);
  } else {
    dzShow(state.frames[103], false);
  }

  state.strNow = 0;
  state.strLen = dzStringLength(entry.text);

  // 任务模式：预注册接受/拒绝按钮回调
  if (entry.isQuest && entry.questCallbacks) {
    const cb = entry.questCallbacks;
    frameSetScriptByCode(state.frames[6], 1, () => {
      showQuestButtons(state, false);
      showDialogFrames(state, false);
      state.queue.shift();
      state.isActive = false;
      cb.onAccept();
    }, false);
    frameSetScriptByCode(state.frames[8], 1, () => {
      showQuestButtons(state, false);
      showDialogFrames(state, false);
      state.queue.shift();
      state.isActive = false;
      cb.onReject();
    }, false);
  }

  startTyping(state);
}

// ────────────────────────────────────────────────
// 内部：跳过打字机，直接显示完整文本
// ────────────────────────────────────────────────

function skipTyping(state: PlayerDialogState): void {
  if (state.queue.length === 0) return;
  // 只有打字机还在跑时才跳过（strNow < strLen）
  if (state.strNow >= state.strLen) return;
  dzTimerPause(state.tickTimer);
  state.strNow = state.strLen;
  const entry = state.queue[0];
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer === targetPlayer) {
    dzSetText(state.frames[3], entry.text);
  }
  if (entry.isQuest) {
    // 任务模式：显示接受/拒绝按钮，不显示"点击以继续"提示
    showQuestButtons(state, true);
  } else {
    // 文字已全部显示，等待玩家点击背景才推进
    state.waitingClick = true;
    dzShow(state.frames[11], true); // 显示"点击以继续 ▼"
  }
}

// ────────────────────────────────────────────────
// 内部：打字机逐字显示
// ────────────────────────────────────────────────

function startTyping(state: PlayerDialogState): void {
  dzTimerStart(state.tickTimer, TICK, true, () => {
    onTypingTick(state);
  });
}

function onTypingTick(state: PlayerDialogState): void {
  if (state.queue.length === 0) {
    dzTimerPause(state.tickTimer);
    return;
  }

  state.strNow += STEP_LEN;
  state.clickCooldown = false; // 打字机已跑起来，解除点击冷却
  const entry = state.queue[0];
  if (!entry) { dzTimerPause(state.tickTimer); return; }

  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  const isLocal = localPlayer === targetPlayer;

  if (state.strNow >= state.strLen) {
    // 文字已全部显示
    if (isLocal) {
      dzSetText(state.frames[3], entry.text);
    }
    dzTimerPause(state.tickTimer);

    if (entry.isQuest) {
      // 任务模式：显示接受/拒绝按钮，不显示"点击以继续"提示
      showQuestButtons(state, true);
    } else {
      // 文字已全部显示，等待玩家点击背景才推进
      state.waitingClick = true;
      dzShow(state.frames[11], true); // 显示"点击以继续 ▼"
    }
  } else {
    // 仍在打字中
    if (isLocal) {
      const partial = dzSubString(entry.text, 0, state.strNow);
      dzSetText(state.frames[3], partial);
    }
  }
}

function advanceDialog(state: PlayerDialogState): void {
  // 隐藏任务按钮和"点击以继续"提示
  showQuestButtons(state, false);
  dzShow(state.frames[11], false);
  // 出队
  state.queue.shift();

  if (state.queue.length === 0) {
    state.isActive = false;
    state.waitingClick = false;
    state.clickCooldown = false;
    showDialogFrames(state, false);
    // 通知调用方对话已全部结束，让其重置自身状态锁
    const cb = state.onFinish;
    state.onFinish = undefined;
    if (cb) cb();
  } else {
    playEntry(state);
  }
}

/** 显示/隐藏任务接受拒绝按钮（底图 + 命中层 + 文字标签） */
function showQuestButtons(state: PlayerDialogState, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;
  dzShow(state.frames[5], visible);  // 接受底图
  dzShow(state.frames[6], visible);  // 接受命中层
  dzShow(state.frames[9], visible);  // 接受文字标签
  dzShow(state.frames[7], visible);  // 拒绝底图
  dzShow(state.frames[8], visible);  // 拒绝命中层
  dzShow(state.frames[10], visible); // 拒绝文字标签
}

// ────────────────────────────────────────────────
// 内部：入队并在首次入队时触发播放
// ────────────────────────────────────────────────

function enqueue(
  state: PlayerDialogState,
  title: string,
  text: string,
  waitTime: number,
  leftTex: string,
  midTex: string,
  rightTex: string,
  titleFontSize: number,
  bodyFontSize: number,
): void {
  const entry: DialogEntry = { title, text, waitTime, leftTex, midTex, rightTex, titleFontSize, bodyFontSize, isQuest: false };
  const wasEmpty = state.queue.length === 0;
  state.queue.push(entry);
  if (wasEmpty) {
    playEntry(state);
  }
}

// ────────────────────────────────────────────────
// 公共 API
// ────────────────────────────────────────────────

/**
 * 初始化对话框系统（为全部玩家预创建状态，不创建帧）
 * 可在地图初始化时调用，也可以不调用（首次 display 时懒初始化）
 */
export function initDialogSystem(): void {
  for (let i = 0; i < MAX_PLAYERS; i++) {
    ensureState(i);
  }
}

/**
 * 为指定玩家添加一条对话（无立绘）
 * @param p              目标玩家
 * @param title          标题（说话人名字）
 * @param text           正文
 * @param duration       正文打完后停留时间（秒），最小 1
 * @param titleFontSize  标题字体大小（默认 DEFAULT_TITLE_FONT_SIZE）
 * @param bodyFontSize   正文字体大小（默认 DEFAULT_BODY_FONT_SIZE）
 */
export function displayText(
  p: Player,
  title: string,
  text: string,
  duration: number,
  titleFontSize?: number,
  bodyFontSize?: number,
): void {
  if (duration <= 0) duration = 1;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  enqueue(state, title, text, duration, "", "", "",
    titleFontSize ?? DEFAULT_TITLE_FONT_SIZE,
    bodyFontSize ?? DEFAULT_BODY_FONT_SIZE,
  );
}

/**
 * 为指定玩家添加一条对话（带立绘）
 * @param p              目标玩家
 * @param title          标题
 * @param text           正文
 * @param duration       停留时间（秒）
 * @param leftPortrait   左侧立绘路径（""=不显示）
 * @param midPortrait    中间立绘路径
 * @param rightPortrait  右侧立绘路径
 * @param titleFontSize  标题字体大小（默认 DEFAULT_TITLE_FONT_SIZE）
 * @param bodyFontSize   正文字体大小（默认 DEFAULT_BODY_FONT_SIZE）
 */
export function displayTextEx(
  p: Player,
  title: string,
  text: string,
  duration: number,
  leftPortrait: string,
  midPortrait: string,
  rightPortrait: string,
  titleFontSize?: number,
  bodyFontSize?: number,
): void {
  if (duration <= 0) duration = 1;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  enqueue(state, title, text, duration, leftPortrait, midPortrait, rightPortrait,
    titleFontSize ?? DEFAULT_TITLE_FONT_SIZE,
    bodyFontSize ?? DEFAULT_BODY_FONT_SIZE,
  );
}

/**
 * 清除指定玩家的全部对话队列并立即隐藏对话框
 */
export function clearDialog(p: Player): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = g_states[pid];
  if (!state) return;
  clearState(state);
}

/**
 * 设置指定玩家是否显示对话框
 * 用本地判断：仅本地玩家生效，不触发 desync
 */
export function setDialogShowable(p: Player, visible: boolean): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return; // 本地判断，只改自己
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  state.canShow = visible;
  if (!visible && state.initialized) {
    // 立即隐藏帧（已是本地玩家，直接操作不会 desync）
    for (let i = 0; i < 9; i++) dzShow(state.frames[i], false);
    for (let i = 101; i < 104; i++) dzShow(state.frames[i], false);
  }
}

/**
 * 设置指定玩家的对话框背景贴图
 * 必须在本地判断内调用，防止 desync
 */
export function setDialogBGTexture(p: Player, path: string): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = g_states[pid];
  if (!state || !state.initialized) return;
  dzSetTexture(state.frames[0], path);
}

/**
 * 设置指定玩家的对话框标题栏贴图
 * 必须在本地判断内调用，防止 desync
 */
export function setDialogTitleTexture(p: Player, path: string): void {
  const localPlayer = dzGetLocalPlayer();
  if (localPlayer !== p) return;
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = g_states[pid];
  if (!state || !state.initialized) return;
  dzSetTexture(state.frames[1], path);
}

/**
 * 查询指定玩家的对话框是否正在显示
 * 调用方可用此函数决定是否允许再次触发对话（防止重复点击NPC）
 */
export function isDialogActive(p: Player): boolean {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return false;
  const state = g_states[pid];
  if (!state) return false;
  return state.isActive;
}

/**
 * 注册对话队列全部播完后的回调
 * 用于NPC交互逻辑在对话结束后重置自身的"对话中"状态锁
 * 每次对话结束后回调会自动清除，下次需要重新注册
 * @param p        目标玩家
 * @param callback 对话全部结束时调用
 */
export function setDialogFinishCallback(p: Player, callback: () => void): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  state.onFinish = callback;
}

/**
 * 为指定玩家显示任务对话框
 * 打字完成后显示【接受任务】【拒绝任务】按钮，等待玩家选择
 * @param p         目标玩家
 * @param title     说话人名字
 * @param text      任务描述文本
 * @param onAccept  点击接受任务的回调
 * @param onReject  点击拒绝任务的回调
 */
export function displayQuest(
  p: Player,
  title: string,
  text: string,
  onAccept: () => void,
  onReject: () => void,
): void {
  const pid = dzGetPlayerId(p);
  if (pid < 0 || pid >= MAX_PLAYERS) return;
  const state = ensureState(pid);
  const entry: DialogEntry = {
    title,
    text,
    waitTime: 0,
    leftTex: "",
    midTex: "",
    rightTex: "",
    titleFontSize: DEFAULT_TITLE_FONT_SIZE,
    bodyFontSize: DEFAULT_BODY_FONT_SIZE,
    isQuest: true,
    questCallbacks: { onAccept, onReject },
  };
  const wasEmpty = state.queue.length === 0;
  state.queue.push(entry);
  if (wasEmpty) {
    playEntry(state);
  }
}
