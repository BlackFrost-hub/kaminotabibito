/**
 * 全图通用 UI 辅助（DzAPI / Frame）。
 *
 * **联机与 desync**
 * - 本文件内均为 **本地帧操作**（`DzFrameSetFont` / `DzFrameSetTextAlignment` / `DzFrameSetParent` 等），**不**经网络同步。
 * - 需要注册 **点击/滚轮** 时，**强烈建议都用 `sync=true`**，但必须严格遵守以下规则：
 *   - ✅ **按钮帧必须在所有玩家上创建**（不能在本地玩家判断内创建）
 *   - ✅ **回调必须在所有玩家上注册**（不能在本地玩家判断内注册）
 *   - ✅ **回调必须是全局函数**（不能是匿名闭包，闭包会导致 desync！）
 *   - ✅ **回调内部严格区分操作类型**：
 *     - 全局同步操作（游戏状态修改等）：必须在本地玩家判断之外执行
 *     - 异步操作（UI 操作、音效等）：必须在本地玩家判断之内执行
 *     - ⚠️ 不可以互相混淆！非常严格！
 * - 勿用会走 `ExecuteFunc` 的 `DzFrameSetScript` 同步字符串去驱动 Lua 逻辑。
 * - 若 UI 回调里要 **发同步数据**，应走项目既有 **Sync** 封装，勿在帧回调里直接改游戏状态而不同步。
 *
 * 详细避坑经验见 `.cursor/rules/dzapi-ui-frame-types.mdc`。
 */

const japi = require("jass.japi") as any;

import { createFrame, setButtonText, FrameType } from "../09．表现系统/01．UI工具/index";
import { displayText, displayQuest, isDialogActive } from "../09．表现系统/03．对话框系统/00．对话框UI入口";
import { isNpcOccupied, setDialogNpcUnit, tryOccupyNpc } from "../09．表现系统/04．NPC对话状态池";

// ─────────────────────────────────────────────────────────────────────────────
// 对话框入口封装
// 使用方式：任何触发（NPC点击 / 拾取物品 / 使用物品）统一调用此函数。
// 内部先判断该玩家是否 isDialogActive；true → 直接返回，false → 展开对话框。
// 每个玩家状态独立，玩家1对话中不影响玩家2。
// ─────────────────────────────────────────────────────────────────────────────

/** 普通对白条目（标题 + 正文 + 停留时长） */
export interface NpcDialogLine {
  title: string;
  text: string;
  duration: number;
}

/** 任务对话条目 */
export interface NpcDialogQuest {
  title: string;
  text: string;
  onAccept: () => void;
  onReject: () => void;
  /** 任务按钮文案（可选） */
  acceptText?: string;
  rejectText?: string;
}

/** 传给 openNpcDialog 的完整数据 */
export interface NpcDialogData {
  /** 普通对白列表（按顺序播放） */
  lines: NpcDialogLine[];
  /** 末尾的任务对话（可选，没有则纯对白结束） */
  quest?: NpcDialogQuest;
  /** NPC单位（用于显示气泡特效） */
  npcUnit?: any;
}

/**
 * 通用 NPC 对话框入口。
 * - 若该玩家对话框正在播放（`isDialogActive(p) === true`），直接返回，不重复展开。
 * - 若该玩家对话框空闲（`isDialogActive(p) === false`），按 data 顺序入队播放。
 * - 文本数据由调用方传入，函数本身不硬编码任何内容。
 * - 每个玩家状态独立，互不影响。
 * - 如果NPC已被其他玩家占用，直接返回 false。
 * @returns 成功开始对话返回 true，否则返回 false
 */
export function openNpcDialog(p: any, data: NpcDialogData): boolean {
  if (isDialogActive(p)) return false; // 该玩家对话框正在播放 → 忽略

  // 尝试占用NPC，如果已被其他玩家占用则返回 false
  if (data.npcUnit) {
    if (!tryOccupyNpc(p, data.npcUnit)) {
      return false; // NPC已被其他玩家占用
    }
    setDialogNpcUnit(p, data.npcUnit);
  }

  for (const line of data.lines) {
    displayText(p, line.title, line.text, line.duration);
  }

  if (data.quest) {
    const q = data.quest;
    displayQuest(p, q.title, q.text, q.onAccept, q.onReject, q.acceptText, q.rejectText);
  }

  return true;
}

/** `DzFrameSetTextAlignment`：改对齐前重置，避免叠加 */
export const DZ_TEXT_ALIGN_RESET = -1;
/** 居中 */
export const DZ_TEXT_ALIGN_CENTER = 18;
/** 左对齐 */
export const DZ_TEXT_ALIGN_LEFT = 2;

export const DEFAULT_UI_FONT_FILE = "UI\\uizt.ttf";
export const DEFAULT_UI_FONT_FLAG = 0;
/** 列表/入口等默认字号（`DzFrameSetFont` 第三参） */
export const DEFAULT_UI_FONT_SCALE = 0.016;

/**
 * 设置字体与文本对齐；`fontScale` 省略则用 `DEFAULT_UI_FONT_SCALE`。
 */
export function applyDzTextFontAndAlignment(
  frame: number,
  textAlignment: number,
  fontScale?: number,
  fontFile: string = DEFAULT_UI_FONT_FILE,
  fontFlag: number = DEFAULT_UI_FONT_FLAG
): void {
  if (!frame || frame === 0) return;
  const scale = fontScale !== undefined && fontScale !== null ? fontScale : DEFAULT_UI_FONT_SCALE;
  if (typeof (japi as any).DzFrameSetFont === "function") {
    (pcall as any)(() => {
      (japi as any).DzFrameSetFont(frame, fontFile, scale, fontFlag);
    });
  }
  if (typeof (japi as any).DzFrameSetTextAlignment === "function") {
    (pcall as any)(() => {
      (japi as any).DzFrameSetTextAlignment(frame, DZ_TEXT_ALIGN_RESET);
      (japi as any).DzFrameSetTextAlignment(frame, textAlignment);
    });
  }
}

export function applyDzTextFontAndCenterAlignment(
  frame: number,
  fontScale?: number,
  fontFile: string = DEFAULT_UI_FONT_FILE,
  fontFlag: number = DEFAULT_UI_FONT_FLAG
): void {
  applyDzTextFontAndAlignment(frame, DZ_TEXT_ALIGN_CENTER, fontScale, fontFile, fontFlag);
}

/**
 * `TEXT` 子帧与 `BACKDROP` 同大（`SetAllPoints(text, backdrop)`），便于对齐相对整块底图。
 */
export function createTextFrameFillBackdrop(backdrop: number, name: string, text: string): number | null {
  if (!backdrop || backdrop === 0) return null;
  const tf = createFrame({
    type: FrameType.TEXT,
    name,
    parent: backdrop,
    template: "template",
    visible: true,
  });
  if (!tf || tf === 0) return null;
  if (typeof (japi as any).DzFrameClearAllPoints === "function") {
    (pcall as any)(() => (japi as any).DzFrameClearAllPoints(tf));
  }
  if (typeof (japi as any).DzFrameSetAllPoints === "function") {
    (pcall as any)(() => (japi as any).DzFrameSetAllPoints(tf, backdrop));
  }
  if (typeof (japi as any).DzFrameSetText === "function") {
    (japi as any).DzFrameSetText(tf, text);
  }
  return tf;
}

/**
 * Tab 标签：`TEXT` 铺满背景 + 居中 + 指定 Tab 字号。
 */
export function createTabLabelTextOnBackdrop(
  backdrop: number,
  name: string,
  text: string,
  tabLabelFontScale: number,
  fontFile: string = DEFAULT_UI_FONT_FILE,
  fontFlag: number = DEFAULT_UI_FONT_FLAG
): number | null {
  const tf = createTextFrameFillBackdrop(backdrop, name, text);
  if (!tf) return null;
  applyDzTextFontAndAlignment(tf, DZ_TEXT_ALIGN_CENTER, tabLabelFontScale, fontFile, fontFlag);
  return tf;
}

/**
 * `GLUETEXTBUTTON` 作点击层：挂到 `backdrop` 下、`SetAllPoints` 铺满。
 */
export function layoutGlueTextButtonOverBackdrop(backdrop: number, button: number): void {
  if (!backdrop || backdrop === 0 || !button || button === 0) return;
  if (typeof (japi as any).DzFrameSetParent === "function") {
    (pcall as any)(() => (japi as any).DzFrameSetParent(button, backdrop));
  }
  if (typeof (japi as any).DzFrameClearAllPoints === "function") {
    (pcall as any)(() => (japi as any).DzFrameClearAllPoints(button));
  }
  if (typeof (japi as any).DzFrameSetAllPoints === "function") {
    (pcall as any)(() => (japi as any).DzFrameSetAllPoints(button, backdrop));
  }
}

/**
 * 透明命中层：铺满背景后清空按钮字并 `alpha=0`（文案由同背景的 `TEXT` 负责）。
 */
export function setupTransparentGlueHitLayer(backdrop: number, button: number): void {
  layoutGlueTextButtonOverBackdrop(backdrop, button);
  setButtonText(button, "");
  if (typeof (japi as any).DzFrameSetAlpha === "function") {
    (pcall as any)(() => (japi as any).DzFrameSetAlpha(button, 0));
  }
}
