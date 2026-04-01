/**
 * 任务系统 - 全新任务 UI（魔兽原生风格）
 * 层级：GameUI → TaskEntryIcon（绝对 ENTRY_X/Y）→ 点击；TaskMainPanel（TOPLEFT 相对入口 TOPLEFT：PANEL_REL_TO_ENTRY_*）→ 标签/滚动条/listContainer；
 * listContainer 内：任务行/标题/目标/空列表（全部相对 listContainer，与装饰框对齐）。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

function dzGetLocalPlayer(): any {
  return typeof jass.GetLocalPlayer === "function" ? jass.GetLocalPlayer() : null;
}

function dzPlayer(index: number): any {
  return typeof jass.Player === "function" ? jass.Player(index) : null;
}

import {
  getGameUI,
  registerKeyDown,
  KEY_LETTER,
  KEY_NUM,
  getWheelDelta,
  getMouseFocus,
  registerMouseWheel,
} from "../00．核心系统/04．硬件函数";
import {
  createFrame,
  setFramePosition,
  setFrameSize,
  setFrameTexture,
  setButtonText,
  setFrameClickEvent,
  setFramePointRelative,
  setFrameHoverEvents,
  createTextLabel,
  loadTocOnce,
  FrameType,
  FramePoint,
  type RelativePositionConfig,
  hideFrame,
  showFrame,
} from "../09．表现系统/01．UI工具";
import { VerticalScrollbarTrack } from "../09．表现系统/02．垂直滚动条轨道";
import { questManager } from "./02．任务管理器";
import { questDB, QuestType, QuestStatus, QuestData } from "./01．任务数据";
import { SoundUI_ClickPlay } from "../00．核心系统/02．音效函数";
import {
  DZ_TEXT_ALIGN_CENTER,
  DZ_TEXT_ALIGN_LEFT,
  applyDzTextFontAndAlignment,
  applyDzTextFontAndCenterAlignment,
  createTabLabelTextOnBackdrop,
  setupTransparentGlueHitLayer,
} from "../00．核心系统/06．UI函数";

const TASK_UI_TOC_PATHS = ["UI\\TaskUI.toc"];
const TASK_UI_TOC_LOAD_KEY = "TaskUI";
const ENABLE_FDF_A = true;
const ENABLE_FDF_B = true;
// 轨道/滑块改为从 FDF 创建：由 FDF 提供正确的 BackdropCornerSize/Insets，避免 slider-border 出现重复竖线/纹理错位
const ENABLE_FDF_SCROLLBAR = true;
const ENABLE_FDF_SCROLLBAR_BORDER = false;
const ENABLE_FDF_SCROLLBAR_THUMB = false;
const ENABLE_MOUSE_WHEEL_SCROLL = true;
/** 主任务口尺寸与 TOPLEFT 绝对坐标（左下原点，y 向上） */
const ENTRY_W = 0.059 * 1.3;
const ENTRY_H = 0.0156 * 1.4;
const ENTRY_X = 0.005;
const ENTRY_Y = 0.60;
const ENTRY_TITLE_TEXT_BOX_W = 0.82;
const ENTRY_TITLE_TEXT_BOX_H = 0.46;
const PANEL_W = 0.35;
const PANEL_H = 0.5;
/** Tab 背景与 GLUETEXTBUTTON 同宽同高（与背景框对齐，避免字偏） */
const TAB_FRAME_W = 0.04;
const TAB_FRAME_H = 0.035;
/** 顶部 Tab「主线/支线/小任务」：`DzFrameSetFont` 第三参（配合与 BACKDROP 同大的 `TEXT`） */
const TAB_CATEGORY_FONT_SCALE = 0.012;
const LIST_ITEM_H = 0.12;
const BG_TEX = "UI\\Widgets\\EscMenu\\Human\\human-options-menu-background.blp";

// 布局基准（改 ENTRY_* 时与 PANEL_REL_* 联动）
const PANEL_TOP = 0.46;
const PANEL_TOP_UP = 0.015;
const LEGACY_ENTRY_X_REF = 0.06;
const LEGACY_ENTRY_Y_REF = 0.51;
const LEGACY_PANEL_TOP_Y = PANEL_TOP + PANEL_TOP_UP;
const LEGACY_LIST_TOP = 0.41 + PANEL_TOP_UP - 0.04;
/** 主面板 TOPLEFT 相对任务口 TOPLEFT（y 为负表示面板顶在入口顶下方，与旧版一致） */
const PANEL_TOPLEFT_OFF_X = 0;
const PANEL_TOPLEFT_OFF_Y = LEGACY_PANEL_TOP_Y - LEGACY_ENTRY_Y_REF;
/** 展开区相对「PANEL_TOPLEFT_OFF 基准」再上移（并入 PANEL_REL_TO_ENTRY_Y，y 向上为正） */
const PANEL_EXPANDED_UP = 0.015;
/** 主面板 TOPLEFT 相对任务入口 TOPLEFT（DzFrameSetPoint）；改 ENTRY_* 只动入口即可，面板随锚点跟动 */
const PANEL_REL_TO_ENTRY_X = PANEL_TOPLEFT_OFF_X;
const PANEL_REL_TO_ENTRY_Y = PANEL_TOPLEFT_OFF_Y + PANEL_EXPANDED_UP;
/** 列表第一行顶相对主面板 TOPLEFT */
const LIST_FIRST_ROW_REL_Y = LEGACY_LIST_TOP - LEGACY_PANEL_TOP_Y;
/** 任务行左边相对主面板 TOPLEFT（旧 rowLeft − 面板左，面板左与入口左对齐） */
const LIST_ROW_LEFT_REL_X = 0.09 - LEGACY_ENTRY_X_REF - 0.01;
const TAB_Y = 0.44;
const TAB_REL_Y = TAB_Y - PANEL_TOP;
/** 折叠行纵向步进（行高 + 间距），与 refreshList 一致 */
const COLLAPSED_ROW_PITCH = LIST_ITEM_H * 0.4 + 0.01;
/** 列表可视高度：目标约 7 条折叠任务（原 ~0.335 只能约 5 条） */
const LIST_VIEW_TARGET_ROWS = 7;
const LIST_VIEW_H = COLLAPSED_ROW_PITCH * LIST_VIEW_TARGET_ROWS + 0.012;
/** 轨道与列表可视等高：主面板右缘用双锚点拉出，高度 = PANEL_H - 顶留白 - 底留白 */
const SCROLLBAR_BOTTOM_INSET = 0.03;
const SCROLLBAR_TOP_INSET = PANEL_H - LIST_VIEW_H - SCROLLBAR_BOTTOM_INSET;
/** listContainer 相对主面板 TOPLEFT（与 createMainPanel 一致） */
const LIST_CONTAINER_REL_TO_PANEL_X = 0.015;
const LIST_CONTAINER_REL_TO_PANEL_Y = -0.1;
/** 列表内容相对 listContainer TOPLEFT；相对主面板的行/框左缘与容器锚点之差，+0.025 上移对齐装饰框 */
const LIST_CONTENT_LEFT_INSET = LIST_ROW_LEFT_REL_X - LIST_CONTAINER_REL_TO_PANEL_X;
const LIST_CONTENT_TOP_INSET = LIST_FIRST_ROW_REL_Y - LIST_CONTAINER_REL_TO_PANEL_Y + 0.025;
const LIST_CONTAINER_W = 0.32;
const SCROLLBAR_W = 0.015;
/** 轨道相对主面板右缘横向偏移（负数向左）；原 -0.006，再左移 0.005 + 0.004 */
const SCROLLBAR_REL_X = -0.006 - 0.005 - 0.004;
const SCROLL_THUMB_SIZE = 0.02; // 与 TaskUI.fdf 里的 TaskScrollThumb 尺寸保持一致
/** 行程按「轨道实际高度 − 滑块」计算；非 0 会在顶/底留空 */
const SCROLL_THUMB_TOP_COMPENSATION = 0;
const SCROLL_THUMB_BOTTOM_COMPENSATION = 0;
/** 滑块拖拽：定时器间隔（秒） */
const THUMB_DRAG_TICK = 0.03;
/** 微调：1=与轨道像素行程 1:1（原先误用 wh*0.35 与 UI 0.6 坐标系不一致导致“跟手”差） */
const THUMB_DRAG_SENSITIVITY = 1;
/** 主线任务 001/002 左侧图标（正方形 w=h）：相对「未展开」行高 LIST_ITEM_H*0.4，0.90=比该行高小10% */
const QUEST_ROW_ICON_HEIGHT_FACTOR = 0.84;
const QUEST_ROW_ICON_PAD_LEFT = 0.003;
/** 图标右缘与标题文字之间的空隙 */
const QUEST_ROW_TEXT_GAP_AFTER_ICON = 0.006;
/** 带行图标时左侧图标相对行顶 TOPLEFT 的纵向偏移（越大越往下，避免顶到行上边框） */
const QUEST_ROW_ICON_Y_OFFSET = 0.004;

/** `main_`/`side_`/`daily_` + 三位序号 001–020：左侧任务图标 + 文本左对齐（与主线一致） */
function questIdTailInRange01to20(id: string, prefix: string): boolean {
  if (id.length !== prefix.length + 3) return false;
  if (id.substring(0, prefix.length) !== prefix) return false;
  const tail = id.substring(prefix.length);
  if (tail.length !== 3) return false;
  return tail >= "001" && tail <= "020";
}

function isQuestWithRowIconLayout(quest: QuestData): boolean {
  const id = quest.id;
  if (quest.type === QuestType.MAIN) return questIdTailInRange01to20(id, "main_");
  if (quest.type === QuestType.SIDE) return questIdTailInRange01to20(id, "side_");
  if (quest.type === QuestType.DAILY) return questIdTailInRange01to20(id, "daily_");
  return false;
}

function isFdfFrameEnabled(frameName: string): boolean {
  const isA = frameName === "TaskEntryIcon" || frameName === "TaskMainPanel" || frameName === "TaskListContainer";
  const isB =
    frameName === "TaskTabMain" ||
    frameName === "TaskTabSide" ||
    frameName === "TaskTabDaily" ||
    frameName === "TaskButtonBackdrop" ||
    frameName === "TaskTabMainBg" ||
    frameName === "TaskTabSideBg" ||
    frameName === "TaskTabDailyBg";
  if (frameName === "TaskScrollBar") return ENABLE_FDF_SCROLLBAR;
  if (frameName === "TaskScrollBarBorder") return ENABLE_FDF_SCROLLBAR_BORDER;
  if (frameName === "TaskScrollThumb") return ENABLE_FDF_SCROLLBAR_THUMB;
  if (isA) return ENABLE_FDF_A;
  if (isB) return ENABLE_FDF_B;
  return false;
}

function tryCreateFromFdfWithSource(
  name: string,
  parent: number,
  fallback: () => number | null,
): { frame: number | null; fromFdf: boolean } {
  if (!isFdfFrameEnabled(name)) return { frame: fallback(), fromFdf: false };
  loadTocOnce(TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI");
  if (typeof (japi as any).DzCreateFrame !== "function") return { frame: fallback(), fromFdf: false };
  let f: number = 0;
  const ok = (pcall as any)(() => {
    f = (japi as any).DzCreateFrame(name, parent, 0);
  });
  if (ok && f != null && f !== 0) return { frame: f, fromFdf: true };
  return { frame: fallback(), fromFdf: false };
}

function tryCreateFromFdfOnly(name: string, parent: number): number | null {
  const res = tryCreateFromFdfWithSource(name, parent, () => null);
  if (res.fromFdf && res.frame && res.frame !== 0) return res.frame;
  return null;
}

function getStatusText(status: QuestStatus): string {
  const m: Record<string, string> = {
    // 颜色以“更靠近原生 UI 的亮度/对比”为目标
    [QuestStatus.IN_PROGRESS]: "|cff00ff66进行中|r",
    [QuestStatus.COMPLETED]: "|cffc0c0c0已完成|r",
    [QuestStatus.FAILED]: "|cffff5555已失败|r",
    [QuestStatus.DISCOVERED]: "|cff66ccff已发现|r",
    [QuestStatus.UNDISCOVERED]: "|cff888888未发现|r",
  };
  return m[status] || status;
}

/** 获取任务列表（进行中 + 已完成，保留历史） */
function getQuestsForUI(playerId: number, type: QuestType): QuestData[] {
  const active = questManager.getPlayerQuests(playerId, type).filter(q => !q.uiReserved);
  const completedIds = questDB.getPlayerCompletedQuests(playerId);
  const result: QuestData[] = active.slice();

  for (const id of completedIds) {
    const template = questDB.getQuest(id);
    if (!template || template.type !== type || template.uiReserved) continue;
    if (active.some(q => q.id === id)) continue;
    result.push({
      ...template,
      status: QuestStatus.COMPLETED,
      objectives: template.objectives.map(o => ({ ...o, completed: true, current: o.required })),
    });
  }

  return result;
}

const EMPTY_TEXTS: Record<QuestType, string> = {
  [QuestType.MAIN]: "暂无主线任务",
  [QuestType.SIDE]: "暂无支线任务",
  [QuestType.DAILY]: "暂无小任务",
};

class TaskUI {
  private entryFrame: number | null = null;
  private entryText: number | null = null;
  private entryHint: number | null = null;
  private mainPanel: number | null = null;
  private listContainer: number | null = null;
  private tabMain: number | null = null;
  private tabSide: number | null = null;
  private tabDaily: number | null = null;
  private tabMainBg: number | null = null;
  private tabSideBg: number | null = null;
  private tabDailyBg: number | null = null;
  private currentCategory: QuestType = QuestType.MAIN;
  private listItemFrames: number[] = [];
  private scrollBarFrame: number | null = null;
  private scrollThumbFrame: number | null = null;
  /** 叠在滑块上的透明按钮，用于接收按下/拖拽（BACKDROP 本身不响应点击） */
  private scrollThumbHitBtn: number | null = null;
  /** 封装：全局鼠标 + focus 判定 + thumb 同步（见 `垂直滚动条轨道.ts`） */
  private vScrollTrack: VerticalScrollbarTrack | null = null;
  /** 列表区域滚轮：用全局滚轮 + 父链判定，避免只绑在行 clickBtn 上时 TEXT/子帧抢焦点导致滚轮无效 */
  private taskListWheelTrig: unknown = null;
  private scrollOffset = 0;
  private totalContentHeight = 0;
  private expandedQuestIds = new Set<string>();
  private isVisible = false;
  private currentPlayerId = 0;

  // 复用动态创建的帧，避免每次刷新都创建同名帧（以及由此带来的溢出/性能问题）
  private rowBackdropByQuestId = new Map<string, number>();
  private titleByQuestId = new Map<string, number>();
  private clickBtnByQuestId = new Map<string, number>();
  private objFrameByKey = new Map<string, number>();   // questId|objectiveId
  private failFrameByQuestId = new Map<string, number>();
  private rowIconByQuestId = new Map<string, number>();

  public init(): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      const gameUI = getGameUI();
      if (!gameUI) return;

      this.createEntryIcon(gameUI);
      this.createMainPanel(gameUI);
      this.registerTaskListWheel();
      this.hide();
    });
  }

  /** 从 frame 沿父链向上，是否落在 ancestor 子树内 */
  private isDescendantOf(frame: number, ancestor: number): boolean {
    if (!frame || frame === 0 || !ancestor || ancestor === 0) return false;
    let cur: number = frame;
    for (let i = 0; i < 64; i++) {
      if (cur === ancestor) return true;
      const p =
        typeof (japi as any).DzFrameGetParent === "function" ? (japi as any).DzFrameGetParent(cur) : 0;
      if (!p || p === 0) return false;
      cur = p;
    }
    return false;
  }

  /** 滚轮是否应作用在任务列表（列表容器、滚动条轨道、滑块及其子帧） */
  private isWheelTargetForTaskList(): boolean {
    if (!this.mainPanel) return false;
    const f = typeof getMouseFocus === "function" ? getMouseFocus() : 0;
    if (!f || f === 0) return false;
    if (this.listContainer && (f === this.listContainer || this.isDescendantOf(f, this.listContainer))) return true;
    if (this.scrollBarFrame && (f === this.scrollBarFrame || this.isDescendantOf(f, this.scrollBarFrame))) return true;
    if (this.scrollThumbFrame && (f === this.scrollThumbFrame || this.isDescendantOf(f, this.scrollThumbFrame))) return true;
    if (this.scrollThumbHitBtn && f === this.scrollThumbHitBtn) return true;
    return false;
  }

  private registerTaskListWheel(): void {
    if (!ENABLE_MOUSE_WHEEL_SCROLL) return;
    if (this.taskListWheelTrig) return;
    this.taskListWheelTrig = registerMouseWheel(false, () => {
      (pcall as any)(() => {
        if (typeof jass.GetLocalPlayer !== "function") return;
        const lp = jass.GetLocalPlayer();
        if (lp == null) return;

        if (!this.isVisible) return;
        if (!this.isWheelTargetForTaskList()) return;
        this.onListWheel();
      });
    });
  }

  private createEntryIcon(parent: number): void {
    this.entryFrame = tryCreateFromFdfOnly("TaskEntryIcon", parent);
    if (!this.entryFrame) return;

    setFramePosition(this.entryFrame, { point: FramePoint.TOPLEFT, x: ENTRY_X, y: ENTRY_Y });
    setFrameSize(this.entryFrame, { width: ENTRY_W, height: ENTRY_H });
    const tw = ENTRY_W * ENTRY_TITLE_TEXT_BOX_W;
    const th = ENTRY_H * ENTRY_TITLE_TEXT_BOX_H;
    const titleRel: RelativePositionConfig = {
      relativeTo: this.entryFrame,
      point: FramePoint.CENTER,
      relativePoint: FramePoint.CENTER,
      x: 0,
      y: 0,
    };
    /** 强制 TEXT：`DzFrameSetFont` 主要对 TEXT 生效；`createTextLabel` 失败时会退回 GLUETEXTBUTTON，字体 native 常无效 */
    const textFrame = createFrame({
      type: FrameType.TEXT,
      name: "TaskEntryText",
      parent: this.entryFrame,
      template: "template",
      visible: true,
    });
    if (textFrame != null && textFrame !== 0) {
      this.entryText = textFrame;
      setFramePointRelative(textFrame, titleRel.point, titleRel.relativeTo, titleRel.relativePoint, titleRel.x, titleRel.y);
      setFrameSize(textFrame, { width: tw, height: th });
    } else {
      this.entryText = createTextLabel("TaskEntryText", this.entryFrame, "", titleRel, { width: tw, height: th });
    }
    if (this.entryText != null && this.entryText !== 0) {
      if (typeof (japi as any).DzFrameSetText === "function") {
        (japi as any).DzFrameSetText(this.entryText, "|cffffcc00任务(J)|r");
      }
      applyDzTextFontAndCenterAlignment(this.entryText);
    }
    this.entryHint = createTextLabel("TaskEntryHint", this.entryFrame, "|cff888888按J打开|r",
      { relativeTo: this.entryFrame, point: FramePoint.TOP, relativePoint: FramePoint.BOTTOM, x: 0, y: -0.005 },
      { width: ENTRY_W, height: 0.014 }
    );

    const btn = createFrame({
      type: FrameType.GLUETEXTBUTTON,
      name: "TaskEntryBtn",
      parent: this.entryFrame,
      template: "template",
      visible: true,
      enable: true,
      alpha: 0,
    });
    if (btn && typeof (japi as any).DzFrameSetAllPoints === "function") {
      (japi as any).DzFrameSetAllPoints(btn, this.entryFrame);
      setFrameClickEvent(
        btn,
        () => {
          SoundUI_ClickPlay();
          this.togglePanel();
        },
        false
      );
    }
  }

  private createMainPanel(parent: number): void {
    this.mainPanel = tryCreateFromFdfOnly("TaskMainPanel", parent);
    if (!this.mainPanel) return;

    if (typeof (japi as any).DzFrameClearAllPoints === "function") {
      (japi as any).DzFrameClearAllPoints(this.mainPanel);
    }
    if (this.entryFrame) {
      setFramePointRelative(
        this.mainPanel,
        FramePoint.TOPLEFT,
        this.entryFrame,
        FramePoint.TOPLEFT,
        PANEL_REL_TO_ENTRY_X,
        PANEL_REL_TO_ENTRY_Y
      );
    } else {
      setFramePosition(this.mainPanel, {
        point: FramePoint.TOPLEFT,
        x: ENTRY_X + PANEL_REL_TO_ENTRY_X,
        y: ENTRY_Y + PANEL_REL_TO_ENTRY_Y,
      });
    }
    setFrameSize(this.mainPanel, { width: PANEL_W, height: PANEL_H });
    
    this.listContainer = tryCreateFromFdfOnly("TaskListContainer", this.mainPanel);
    if (this.listContainer) {
      if (typeof (japi as any).DzFrameClearAllPoints === "function") {
        (japi as any).DzFrameClearAllPoints(this.listContainer);
      }
      setFramePointRelative(
        this.listContainer,
        FramePoint.TOPLEFT,
        this.mainPanel,
        FramePoint.TOPLEFT,
        LIST_CONTAINER_REL_TO_PANEL_X,
        LIST_CONTAINER_REL_TO_PANEL_Y
      );
    }
    if (this.listContainer && typeof (japi as any).DzFrameShow === "function") {
      (pcall as any)(() => (japi as any).DzFrameShow(this.listContainer, true));
    }

    const tabParent = this.mainPanel!;
    this.tabMainBg = tryCreateFromFdfOnly("TaskTabMainBg", tabParent);
    if (this.tabMainBg) {
      if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(this.tabMainBg);
      setFramePointRelative(this.tabMainBg, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, 0.02, TAB_REL_Y);
      setFrameSize(this.tabMainBg, { width: TAB_FRAME_W, height: TAB_FRAME_H });
      if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(this.tabMainBg, true));
      if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(this.tabMainBg, 7);
    }

    if (this.tabMainBg) {
      const tabLabel = createTabLabelTextOnBackdrop(this.tabMainBg, "TaskTabMainLabel", "|cffffcc00主线(1)|r", TAB_CATEGORY_FONT_SCALE);
      if (tabLabel && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(tabLabel, 8);
    }

    this.tabMain = tryCreateFromFdfOnly("TaskTabMain", tabParent);
    if (this.tabMain) {
      if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(this.tabMain);
      if (this.tabMainBg) {
        setupTransparentGlueHitLayer(this.tabMainBg, this.tabMain);
      } else {
        setFramePointRelative(this.tabMain, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, 0.02, TAB_REL_Y);
        setFrameSize(this.tabMain, { width: TAB_FRAME_W, height: TAB_FRAME_H });
      }
      if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(this.tabMain, true));
      if (!this.tabMainBg) {
        setButtonText(this.tabMain, "");
        if (typeof (japi as any).DzFrameSetAlpha === "function") {
          (pcall as any)(() => (japi as any).DzFrameSetAlpha(this.tabMain, 0));
        }
      }
      if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(this.tabMain, 9);
      setFrameClickEvent(this.tabMain, () => {
        SoundUI_ClickPlay();
        this.switchCategory(QuestType.MAIN);
      }, false);
      setFrameHoverEvents(this.tabMain, () => this.showTabTooltip("按 1 切换主线任务"), () => { }, false);
    }

    this.tabSideBg = tryCreateFromFdfOnly("TaskTabSideBg", tabParent);
    if (this.tabSideBg) {
      if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(this.tabSideBg);
      setFramePointRelative(this.tabSideBg, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, 0.135, TAB_REL_Y);
      setFrameSize(this.tabSideBg, { width: TAB_FRAME_W, height: TAB_FRAME_H });
      if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(this.tabSideBg, true));
      if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(this.tabSideBg, 7);
    }

    if (this.tabSideBg) {
      const tabLabel = createTabLabelTextOnBackdrop(this.tabSideBg, "TaskTabSideLabel", "|cffffcc00支线(2)|r", TAB_CATEGORY_FONT_SCALE);
      if (tabLabel && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(tabLabel, 8);
    }

    this.tabSide = tryCreateFromFdfOnly("TaskTabSide", tabParent);
    if (this.tabSide) {
      if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(this.tabSide);
      if (this.tabSideBg) {
        setupTransparentGlueHitLayer(this.tabSideBg, this.tabSide);
      } else {
        setFramePointRelative(this.tabSide, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, 0.135, TAB_REL_Y);
        setFrameSize(this.tabSide, { width: TAB_FRAME_W, height: TAB_FRAME_H });
      }
      if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(this.tabSide, true));
      if (!this.tabSideBg) {
        setButtonText(this.tabSide, "");
        if (typeof (japi as any).DzFrameSetAlpha === "function") {
          (pcall as any)(() => (japi as any).DzFrameSetAlpha(this.tabSide, 0));
        }
      }
      if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(this.tabSide, 9);
      setFrameClickEvent(this.tabSide, () => {
        SoundUI_ClickPlay();
        this.switchCategory(QuestType.SIDE);
      }, false);
      setFrameHoverEvents(this.tabSide, () => this.showTabTooltip("按 2 切换支线任务"), () => { }, false);
    }

    this.tabDailyBg = tryCreateFromFdfOnly("TaskTabDailyBg", tabParent);
    if (this.tabDailyBg) {
      if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(this.tabDailyBg);
      setFramePointRelative(this.tabDailyBg, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, 0.25, TAB_REL_Y);
      setFrameSize(this.tabDailyBg, { width: TAB_FRAME_W, height: TAB_FRAME_H });
      if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(this.tabDailyBg, true));
      if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(this.tabDailyBg, 7);
    }

    if (this.tabDailyBg) {
      const tabLabel = createTabLabelTextOnBackdrop(this.tabDailyBg, "TaskTabDailyLabel", "|cffffcc00小任务(3)|r", TAB_CATEGORY_FONT_SCALE);
      if (tabLabel && typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(tabLabel, 8);
    }

    this.tabDaily = tryCreateFromFdfOnly("TaskTabDaily", tabParent);
    if (this.tabDaily) {
      if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(this.tabDaily);
      if (this.tabDailyBg) {
        setupTransparentGlueHitLayer(this.tabDailyBg, this.tabDaily);
      } else {
        setFramePointRelative(this.tabDaily, FramePoint.TOPLEFT, tabParent, FramePoint.TOPLEFT, 0.25, TAB_REL_Y);
        setFrameSize(this.tabDaily, { width: TAB_FRAME_W, height: TAB_FRAME_H });
      }
      if (typeof (japi as any).DzFrameShow === "function") (pcall as any)(() => (japi as any).DzFrameShow(this.tabDaily, true));
      if (!this.tabDailyBg) {
        setButtonText(this.tabDaily, "");
        if (typeof (japi as any).DzFrameSetAlpha === "function") {
          (pcall as any)(() => (japi as any).DzFrameSetAlpha(this.tabDaily, 0));
        }
      }
      if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(this.tabDaily, 9);
      setFrameClickEvent(this.tabDaily, () => {
        SoundUI_ClickPlay();
        this.switchCategory(QuestType.DAILY);
      }, false);
      setFrameHoverEvents(this.tabDaily, () => this.showTabTooltip("按 3 切换小任务"), () => { }, false);
    }

    if (this.mainPanel !== null) {
      const sbSrc = tryCreateFromFdfWithSource("TaskScrollBar", this.mainPanel, () => {
        const f = createFrame({ type: FrameType.BACKDROP, name: "TaskScrollBarBtn", parent: this.mainPanel!, template: "template", visible: true });
        return f ?? 0;
      });
      this.scrollBarFrame = sbSrc.frame;
      if (this.scrollBarFrame && this.scrollBarFrame !== 0 && this.mainPanel) {
        if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(this.scrollBarFrame, true);
        if (typeof (japi as any).DzFrameClearAllPoints === "function") (japi as any).DzFrameClearAllPoints(this.scrollBarFrame);
        setFramePointRelative(this.scrollBarFrame, FramePoint.TOPRIGHT, this.mainPanel, FramePoint.TOPRIGHT, SCROLLBAR_REL_X, -SCROLLBAR_TOP_INSET);
        setFramePointRelative(this.scrollBarFrame, FramePoint.BOTTOMRIGHT, this.mainPanel, FramePoint.BOTTOMRIGHT, SCROLLBAR_REL_X, SCROLLBAR_BOTTOM_INSET);
        setFrameSize(this.scrollBarFrame, { width: SCROLLBAR_W, height: LIST_VIEW_H });
        if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(this.scrollBarFrame, 30);
      }

      this.scrollThumbFrame = createFrame({
        type: FrameType.BACKDROP,
        name: "TaskScrollThumbDyn",
        parent: this.mainPanel,
        template: "template",
        visible: true,
      });
      if (this.scrollThumbFrame && this.scrollThumbFrame !== 0) {
        setFrameTexture(this.scrollThumbFrame, "UI\\Widgets\\EscMenu\\Human\\slider-knob.blp");
        setFrameSize(this.scrollThumbFrame, { width: SCROLL_THUMB_SIZE, height: SCROLL_THUMB_SIZE });
        if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(this.scrollThumbFrame, 120);
        if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(this.scrollThumbFrame, true);
      }
      if (this.scrollThumbFrame && this.scrollThumbFrame !== 0 && this.scrollBarFrame && this.scrollBarFrame !== 0) {
        this.vScrollTrack?.destroy();
        this.vScrollTrack = new VerticalScrollbarTrack({
          trackFrame: this.scrollBarFrame,
          thumbFrame: this.scrollThumbFrame,
          hitButtonName: "TaskScrollThumbHit",
          listViewHeightNorm: LIST_VIEW_H,
          trackHeightNorm: LIST_VIEW_H,
          thumbSizeNorm: SCROLL_THUMB_SIZE,
          topCompensation: SCROLL_THUMB_TOP_COMPENSATION,
          bottomCompensation: SCROLL_THUMB_BOTTOM_COMPENSATION,
          dragTick: THUMB_DRAG_TICK,
          sensitivity: THUMB_DRAG_SENSITIVITY,
          getTotalContentHeight: () => this.totalContentHeight,
          getScrollOffset: () => this.scrollOffset,
          setScrollOffset: (v) => {
            this.scrollOffset = v;
          },
          isInteractionEnabled: () => this.isVisible,
          onScrollChanged: () => {
            this.refreshList();
          },
          skipManualThumbSync: () => false,
        });
        this.vScrollTrack.attach();
        this.scrollThumbHitBtn = this.vScrollTrack.getHitButtonFrame();
      }
    }
  }

  private onListWheel(): void {
    const delta = typeof getWheelDelta === "function" ? getWheelDelta() : 0;
    if (delta === 0) return;
    const step = LIST_ITEM_H + 0.01;
    const maxScroll = Math.max(0, this.totalContentHeight - LIST_VIEW_H);
    if (delta > 0) {
      this.scrollOffset = Math.max(0, this.scrollOffset - step);
    } else if (delta < 0) {
      this.scrollOffset = Math.min(maxScroll, this.scrollOffset + step);
    }
    this.refreshList();
  }

  /** 手动同步圆形 thumb + 全局鼠标拖拽（逻辑在 `垂直滚动条轨道.ts`） */
  private setupThumbDrag(): void {
    if (!this.scrollThumbFrame || this.scrollThumbFrame === 0 || !this.mainPanel || !this.scrollBarFrame) return;
    this.vScrollTrack?.destroy();
    this.vScrollTrack = new VerticalScrollbarTrack({
      trackFrame: this.scrollBarFrame,
      thumbFrame: this.scrollThumbFrame,
      hitButtonName: "TaskScrollThumbHit",
      listViewHeightNorm: LIST_VIEW_H,
      trackHeightNorm: LIST_VIEW_H,
      thumbSizeNorm: SCROLL_THUMB_SIZE,
      topCompensation: SCROLL_THUMB_TOP_COMPENSATION,
      bottomCompensation: SCROLL_THUMB_BOTTOM_COMPENSATION,
      dragTick: THUMB_DRAG_TICK,
      sensitivity: THUMB_DRAG_SENSITIVITY,
      getTotalContentHeight: () => this.totalContentHeight,
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v) => {
        this.scrollOffset = v;
      },
      isInteractionEnabled: () => this.isVisible,
      onScrollChanged: () => {
        this.refreshList();
      },
      skipManualThumbSync: () => false,
    });
    this.vScrollTrack.attach();
    this.scrollThumbHitBtn = this.vScrollTrack.getHitButtonFrame();
  }

  private syncScrollThumb(maxScroll: number): void {
    if (!this.vScrollTrack) return;
    this.vScrollTrack.syncThumbVisual(maxScroll);
  }

  /** 内容不足一屏时隐藏轨道与滑块，避免多余滚动条 */
  private updateScrollBarVisibility(maxScroll: number): void {
    const vis = maxScroll > 0;
    const fn = (japi as any).DzFrameShow;
    if (typeof fn !== "function") return;
    const setVis = (f: number | null) => {
      if (f && f !== 0) (pcall as any)(() => fn(f, vis));
    };
    setVis(this.scrollBarFrame);
    setVis(this.scrollThumbFrame);
    setVis(this.scrollThumbHitBtn);
  }

  private clearList(): void {
    for (const f of this.listItemFrames) {
      if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(f, false);
    }
    if (typeof (japi as any).DzFrameShow === "function") {
      for (const f of this.rowBackdropByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.titleByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.clickBtnByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.objFrameByKey.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.failFrameByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
      for (const f of this.rowIconByQuestId.values()) {
        if (f !== 0) (japi as any).DzFrameShow(f, false);
      }
    }
    this.listItemFrames = [];
  }

  private showTabTooltip(msg: string): void {
    if (typeof (japi as any).DzGetTriggerUIEventPlayer !== "function" || typeof (jass as any).DisplayTextToPlayer !== "function") return;
    const p = (japi as any).DzGetTriggerUIEventPlayer();
    if (p) (jass as any).DisplayTextToPlayer(p, 0, 0, msg);
  }

  private switchCategory(type: QuestType): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      this.currentCategory = type;
      this.expandedQuestIds.clear();
      this.scrollOffset = 0;
      this.refreshList();
    });
  }

  private toggleExpand(questId: string): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (this.expandedQuestIds.has(questId)) {
        this.expandedQuestIds.delete(questId);
      } else {
        this.expandedQuestIds.add(questId);
      }
      this.refreshList();
    });
  }

  private refreshList(): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.mainPanel || !this.listContainer) return;
      this.clearList();

      const quests = getQuestsForUI(this.currentPlayerId, this.currentCategory);
      if (quests.length === 0) {
        this.totalContentHeight = 0;
        this.scrollOffset = 0;
        const empty = createTextLabel("TaskEmpty", this.listContainer, EMPTY_TEXTS[this.currentCategory],
          {
            relativeTo: this.listContainer,
            point: FramePoint.CENTER,
            relativePoint: FramePoint.CENTER,
            x: 0,
            y: 0,
          },
          { width: LIST_CONTAINER_W * 0.85, height: 0.08 }
        );
        if (empty) {
          this.listItemFrames.push(empty);
          applyDzTextFontAndCenterAlignment(empty);
        }
        this.syncScrollThumb(0);
        this.updateScrollBarVisibility(0);
        return;
      }

    let totalH = 0;
    for (let i = 0; i < quests.length; i++) {
      const q = quests[i];
      if (!q) continue;
      const expanded = this.expandedQuestIds.has(q.id);
      const itemH = expanded
        ? LIST_ITEM_H + q.objectives.length * 0.03 + (q.timeLimit && q.timeLimit > 0 ? 0.02 : 0)
        : LIST_ITEM_H * 0.4;
      totalH += itemH + 0.01;
    }
    this.totalContentHeight = totalH;
    const maxScroll = Math.max(0, totalH - LIST_VIEW_H);
    this.scrollOffset = Math.min(maxScroll, this.scrollOffset);
    this.syncScrollThumb(maxScroll);
    this.updateScrollBarVisibility(maxScroll);
    // 列表可视区域：相对 listContainer TOPLEFT（与行坐标同一空间）
    const visibleTopRel = LIST_CONTENT_TOP_INSET;
    const visibleBottomRel = LIST_CONTENT_TOP_INSET - LIST_VIEW_H;
    const EPS = 0.002;

    let rowTopRel = LIST_CONTENT_TOP_INSET + this.scrollOffset;
    for (let i = 0; i < quests.length; i++) {
      const q = quests[i];
      if (!q) continue;
      const expanded = this.expandedQuestIds.has(q.id);
      const itemH = expanded
        ? LIST_ITEM_H + q.objectives.length * 0.03 + (q.timeLimit && q.timeLimit > 0 ? 0.02 : 0)
        : LIST_ITEM_H * 0.4;

      const itemTopRel = rowTopRel;
      const itemBottomRel = rowTopRel - itemH;
      const fullyInside = itemTopRel <= visibleTopRel + EPS && itemBottomRel >= visibleBottomRel - EPS;
      if (fullyInside) {
        this.createListItem(q, rowTopRel, expanded);
      }
      rowTopRel -= itemH + 0.01;
    }
    });
  }

  private createListItem(quest: QuestData, rowTopRel: number, expanded: boolean): number | null {
    const listParent = this.listContainer;
    if (!this.mainPanel || !listParent) return null;

    const itemH = expanded
      ? LIST_ITEM_H + quest.objectives.length * 0.03 + (quest.timeLimit && quest.timeLimit > 0 ? 0.02 : 0)
      : LIST_ITEM_H * 0.4;

    const statusText = getStatusText(quest.status);

    const rowWidth = LIST_CONTAINER_W * 0.9;
    const rowLeftRel = LIST_CONTENT_LEFT_INSET;
    const showMainRowIcon = isQuestWithRowIconLayout(quest);
    /** 与未展开主线行同高（或小 2%），展开后行变高也不放大图标 */
    const collapsedMainRowH = LIST_ITEM_H * 0.4;
    const iconHLayout = showMainRowIcon
      ? collapsedMainRowH * QUEST_ROW_ICON_HEIGHT_FACTOR
      : 0;
    // 有图标时：标题/子行整体右移，避免与图标重叠
    const textXRel = showMainRowIcon
      ? rowLeftRel + QUEST_ROW_ICON_PAD_LEFT + iconHLayout + QUEST_ROW_TEXT_GAP_AFTER_ICON
      : rowLeftRel + 0.03;
    const listTextAlign = showMainRowIcon ? DZ_TEXT_ALIGN_LEFT : DZ_TEXT_ALIGN_CENTER;
    const rowTitleRightInset = 0.01;
    const textW = rowWidth - (textXRel - rowLeftRel) - rowTitleRightInset;

    // 复用动态帧：避免刷新时不断创建同名帧
    let rowBackdrop = this.rowBackdropByQuestId.get(quest.id) || 0;
    if (rowBackdrop === 0) {
      // 每条任务行的“框体”必须直接复用 FDF 的 BACKDROP（TaskButtonBackdrop），
      // 这样 edgefile 的绘制尺寸才会随 setFrameSize 同步到你的红框大小。
      rowBackdrop = tryCreateFromFdfOnly("TaskButtonBackdrop", listParent) || 0;
      if (rowBackdrop === 0) {
        // fallback：退化为仅背景（严格边框效果可能不同，但避免完全丢帧）
        const bgFrame = createFrame({
          type: FrameType.BACKDROP,
          name: "TaskItemBg_" + quest.id,
          parent: listParent,
          template: "template",
          visible: true,
        });
        rowBackdrop = bgFrame || 0;
        if (rowBackdrop !== 0) setFrameTexture(rowBackdrop, BG_TEX);
      }
      if (rowBackdrop !== 0) this.rowBackdropByQuestId.set(quest.id, rowBackdrop);
    }
    if (rowBackdrop === 0) return null;
    setFramePointRelative(rowBackdrop, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, rowLeftRel, rowTopRel);
    setFrameSize(rowBackdrop, { width: rowWidth, height: itemH });
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(rowBackdrop, 1);
    showFrame(rowBackdrop);
    this.listItemFrames.push(rowBackdrop);

    // 标题文字（TEXT）：复用 titleFrame，更新位置/尺寸/文本
    const titleText = quest.title + " [" + statusText + "]";
    let titleFrame = this.titleByQuestId.get(quest.id) || 0;
    if (titleFrame === 0) {
      titleFrame = createTextLabel(
        "TaskItem_" + quest.id,
        listParent,
        titleText,
        {
          relativeTo: listParent,
          point: FramePoint.TOPLEFT,
          relativePoint: FramePoint.TOPLEFT,
          x: textXRel,
          y: rowTopRel - 0.005,
        },
        // 放粗：略增大 TEXT 区域高度，使字体呈现更“粗”的视觉效果
        { width: textW, height: LIST_ITEM_H * 0.38 }
      ) || 0;
      if (titleFrame === 0) return null;
      this.titleByQuestId.set(quest.id, titleFrame);
    } else {
      setFramePointRelative(titleFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, rowTopRel - 0.005);
      setFrameSize(titleFrame, { width: textW, height: LIST_ITEM_H * 0.38 });
      if (typeof (japi as any).DzFrameSetText === "function") (japi as any).DzFrameSetText(titleFrame, titleText);
    }
    applyDzTextFontAndAlignment(titleFrame, listTextAlign);
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(titleFrame, 3);
    showFrame(titleFrame);
    this.listItemFrames.push(titleFrame);

    // 交互层：复用 clickBtn，更新点击与滚轮行为
    let clickBtn = this.clickBtnByQuestId.get(quest.id) || 0;
    if (clickBtn === 0) {
      clickBtn = createFrame({
        type: FrameType.GLUETEXTBUTTON,
        name: "TaskItemClick_" + quest.id,
        parent: listParent,
        template: "template",
        visible: true,
        enable: true,
        alpha: 0,
      }) || 0;
      if (clickBtn === 0) return null;
      this.clickBtnByQuestId.set(quest.id, clickBtn);
    }
    setFramePointRelative(clickBtn, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, rowLeftRel, rowTopRel);
    setFrameSize(clickBtn, { width: rowWidth, height: itemH });
    setFrameClickEvent(clickBtn, () => {
      SoundUI_ClickPlay();
      this.toggleExpand(quest.id);
    }, false);
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(clickBtn, 4);
    showFrame(clickBtn);
    this.listItemFrames.push(clickBtn);

    // 主线 01–20：行左侧任务图标（textX 已在上方为图标让位；标题/目标左对齐）
    if (showMainRowIcon) {
      const iconPath =
        quest.icon && quest.icon !== ""
          ? quest.icon
          : "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp";
      let iconFr = this.rowIconByQuestId.get(quest.id) || 0;
      if (iconFr === 0) {
        iconFr =
          createFrame({
            type: FrameType.BACKDROP,
            name: "TaskQuestRowIcon_" + quest.id,
            parent: listParent,
            template: "template",
            visible: true,
          }) || 0;
        if (iconFr !== 0) {
          setFrameTexture(iconFr, iconPath);
          this.rowIconByQuestId.set(quest.id, iconFr);
        }
      } else {
        setFrameTexture(iconFr, iconPath);
      }
      if (iconFr !== 0) {
        const iconH = iconHLayout;
        const iconW = iconH;
        setFramePointRelative(
          iconFr,
          FramePoint.TOPLEFT,
          listParent,
          FramePoint.TOPLEFT,
          rowLeftRel + QUEST_ROW_ICON_PAD_LEFT,
          rowTopRel - QUEST_ROW_ICON_Y_OFFSET
        );
        setFrameSize(iconFr, { width: iconW, height: iconH });
        if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(iconFr, 5);
        showFrame(iconFr);
        this.listItemFrames.push(iconFr);
      }
    }

    if (expanded) {
      let objYRel = rowTopRel - LIST_ITEM_H * 0.35;
      for (const obj of quest.objectives) {
        const txt = (obj.completed ? "[v] " : "[ ] ") + obj.description + " (" + obj.current + "/" + obj.required + ")";
        const objKey = quest.id + "|" + obj.id;
        let objFrame = this.objFrameByKey.get(objKey) || 0;
        if (objFrame === 0) {
          objFrame = createTextLabel("TaskObj_" + quest.id + "_" + obj.id, listParent, txt,
            {
              relativeTo: listParent,
              point: FramePoint.TOPLEFT,
              relativePoint: FramePoint.TOPLEFT,
              x: textXRel,
              y: objYRel,
            },
            { width: textW, height: LIST_ITEM_H * 0.25 }
          ) || 0;
          if (objFrame === 0) continue;
          this.objFrameByKey.set(objKey, objFrame);
        } else {
          setFramePointRelative(objFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, objYRel);
          setFrameSize(objFrame, { width: textW, height: LIST_ITEM_H * 0.25 });
          if (typeof (japi as any).DzFrameSetText === "function") (japi as any).DzFrameSetText(objFrame, txt);
        }
        applyDzTextFontAndAlignment(objFrame, listTextAlign);
        if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(objFrame, 3);
        showFrame(objFrame);
        this.listItemFrames.push(objFrame);
        objYRel -= LIST_ITEM_H * 0.25;
      }
      if (quest.timeLimit && quest.timeLimit > 0) {
        let failFrame = this.failFrameByQuestId.get(quest.id) || 0;
        const failText = "失败: 时间限制 " + quest.timeLimit + "秒";
        if (failFrame === 0) {
          failFrame = createTextLabel("TaskFail_" + quest.id, listParent,
            failText,
            {
              relativeTo: listParent,
              point: FramePoint.TOPLEFT,
              relativePoint: FramePoint.TOPLEFT,
              x: textXRel,
              y: objYRel,
            },
            { width: textW, height: LIST_ITEM_H * 0.2 }
          ) || 0;
          if (failFrame === 0) return null;
          this.failFrameByQuestId.set(quest.id, failFrame);
        } else {
          setFramePointRelative(failFrame, FramePoint.TOPLEFT, listParent, FramePoint.TOPLEFT, textXRel, objYRel);
          setFrameSize(failFrame, { width: textW, height: LIST_ITEM_H * 0.2 });
          if (typeof (japi as any).DzFrameSetText === "function") (japi as any).DzFrameSetText(failFrame, failText);
        }
        applyDzTextFontAndAlignment(failFrame, listTextAlign);
        if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(failFrame, 3);
        showFrame(failFrame);
        this.listItemFrames.push(failFrame);
      }
    }

    return null;
  }

  private togglePanel(): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      this.isVisible = !this.isVisible;
      if (this.isVisible) this.show(this.currentPlayerId);
      else this.hide();
    });
  }

  public show(playerId: number): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.mainPanel) return;
      this.currentPlayerId = playerId;
      this.isVisible = true;
      showFrame(this.mainPanel);
      this.refreshList();
    });
  }

  public hide(): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.mainPanel) return;
      this.vScrollTrack?.cancelDrag();
      this.isVisible = false;
      hideFrame(this.mainPanel);
    });
  }

  public registerHotkey(): void {
    if (typeof registerKeyDown !== "function") return;
    // 关键：J 切换时要基于“触发按键的玩家”更新 currentPlayerId
    // 否则如果按了 Y 运行测试（内部会调用 taskUI.show(0)），会把 currentPlayerId 污染成 0，
    // 导致后续按 J 显示错误玩家的数据。
    registerKeyDown(KEY_LETTER.J, (player: any) => {
      (pcall as any)(() => {
        if (typeof jass.GetLocalPlayer !== "function") return;
        const lp = jass.GetLocalPlayer();
        if (lp == null) return;

        const getPid = typeof (jass as any).GetPlayerId === "function" ? (jass as any).GetPlayerId : null;
        if (getPid && player) this.currentPlayerId = getPid(player);
        // 键盘热键也播放与原生 UI 相同的按钮点击音效
        SoundUI_ClickPlay();
        this.togglePanel();
      });
    });
    registerKeyDown(KEY_NUM.K1, (player: any) => {
      (pcall as any)(() => {
        if (typeof jass.GetLocalPlayer !== "function") return;
        const lp = jass.GetLocalPlayer();
        if (lp == null) return;

        if (!this.isVisible) return;
        SoundUI_ClickPlay();
        this.switchCategory(QuestType.MAIN);
      });
    });
    registerKeyDown(KEY_NUM.K2, (player: any) => {
      (pcall as any)(() => {
        if (typeof jass.GetLocalPlayer !== "function") return;
        const lp = jass.GetLocalPlayer();
        if (lp == null) return;

        if (!this.isVisible) return;
        SoundUI_ClickPlay();
        this.switchCategory(QuestType.SIDE);
      });
    });
    registerKeyDown(KEY_NUM.K3, (player: any) => {
      (pcall as any)(() => {
        if (typeof jass.GetLocalPlayer !== "function") return;
        const lp = jass.GetLocalPlayer();
        if (lp == null) return;

        if (!this.isVisible) return;
        SoundUI_ClickPlay();
        this.switchCategory(QuestType.DAILY);
      });
    });
  }
}

export const taskUI = new TaskUI();

export function init(): void {
  taskUI.init();
}

export function registerHotkey(): void {
  taskUI.registerHotkey();
}
