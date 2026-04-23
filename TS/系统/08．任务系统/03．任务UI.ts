/**
 * 任务系统 - 多槽位任务 UI（魔兽原生风格）
 *
 * 架构（与属性 UI 对齐的"4 槽位"模型）：
 * - 所有客户端对称创建 `MAX_TASK_UI_SLOTS` 套完整任务 UI（入口图标 + 主面板 + 列表 + 滚动条），
 *   槽位 i 绑定玩家 Player(i)；默认所有主面板都隐藏。
 * - 每客户端只"显示/交互"本机本地玩家对应的槽位（slotPid === GetPlayerId(GetLocalPlayer())），
 *   其余 3 个槽位的入口图标/主面板永远保持隐藏，不接受 J/1/2/3 输入、不刷新。
 * - 这样全端的帧创建、refresh/wheel 回调注册在数量与顺序上保持对称，降低同步风险；
 *   "只本地显示"通过 DzFrameShow 在本机完成，不引入同步点。
 *
 * 层级（单个槽位）：
 *   GameUI → TaskEntryIcon(s) → 点击 → TaskMainPanel(s) → 标签/滚动条/listContainer → 任务行
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import {
  refreshTaskUIFacadeList,
  createTaskUIListItem,
  clearTaskUIList,
} from "./04．任务UI拆分/09．任务UI列表控制";
import {
  registerTaskUIListWheel,
  handleTaskUIListWheel,
  syncTaskUIScrollThumb,
  updateTaskUIScrollBarVisibility,
} from "./04．任务UI拆分/10．任务UI滚动与滚轮";
import {
  registerTaskUIRefreshCallback,
  showTaskUITabTooltip,
  switchTaskUICategory,
  toggleTaskUIPanel,
  showTaskUIPanel,
  hideTaskUIPanel,
} from "./04．任务UI拆分/11．任务UI面板控制";
import { registerTaskUIHotkeys } from "./04．任务UI拆分/05．任务UI热键";
import { buildTaskEntryIcon } from "./04．任务UI拆分/06．任务UI入口图标";
import { buildTaskMainPanel } from "./04．任务UI拆分/08．任务UI主面板与滚动";

import {
  getGameUI,
  registerKeyDown,
  KEY,
  KEY_NUM,
  getWheelDelta,
  getMouseFocus,
  registerMouseWheel,
} from "../../lib/扩展函数/封装函数/04．硬件输入/index";
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
  FrameType,
  FramePoint,
  hideFrame,
  showFrame,
} from "../09．表现系统/01．UI工具/index";
import { VerticalScrollbarTrack } from "../09．表现系统/03．垂直滚动条轨道";
import { questManager } from "./02．任务管理器/index";
import { QuestType, QuestData } from "./01．任务数据";
import { SoundUI_ClickPlay } from "../../lib/扩展函数/封装函数/02．音效系统/index";
import {
  applyDzTextFontAndAlignment,
  applyDzTextFontAndCenterAlignment,
  createTabLabelTextOnBackdrop,
  setupTransparentGlueHitLayer,
} from "../00．核心系统/03．UI函数";
import { ENABLE_TASK_UI_CLIENT } from "./04．任务UI拆分/01．任务UI常量";

/** 多槽位数量：4 个玩家槽位。超出 4 的玩家将不创建任务 UI（理论上当前地图也只有 4 位活跃玩家）。 */
const MAX_TASK_UI_SLOTS = 4;

/** 单个槽位的任务 UI；所有槽位在所有客户端上被对称创建，只有 `isForLocalPlayer()` 的那个会响应交互。 */
class TaskUI {
  /** 本槽位绑定的玩家 id（即 GetPlayerId(Player(i))）。 */
  public readonly slotPid: number;

  private entryFrame: number | null = null;
  private entryText: number | null = null;
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

  constructor(slotPid: number) {
    this.slotPid = slotPid;
    this.currentPlayerId = slotPid;
  }

  /** 判断"本机本地玩家 === 本槽位绑定玩家"，是所有交互/显示动作的唯一门控。 */
  private isForLocalPlayer(): boolean {
    const lp = jass.GetLocalPlayer();
    if (lp == null) return false;
    const getPid = (jass as any).GetPlayerId as ((p: any) => number) | undefined;
    if (typeof getPid !== "function") return false;
    return getPid(lp) === this.slotPid;
  }

  public init(): void {
    if (!ENABLE_TASK_UI_CLIENT) return;
    (pcall as any)(() => {
      const gameUI = getGameUI();
      if (!gameUI) return;

      // 注意：这里不做 GetLocalPlayer 门控——所有客户端对所有槽位同样创建帧，
      // 以保证帧/回调注册的端间对称；显示隔离在后续 hide/showFrame 里完成。
      this.createEntryIcon(gameUI);
      this.createMainPanel(gameUI);
      this.registerTaskListWheel();
      this.registerRefreshCallback();
      this.hide();

      // 非本地槽位：连入口图标也隐藏，避免 4 个"任务(J)"按钮叠在屏幕同一位置。
      // 本地槽位：hide() 只会隐藏 mainPanel，入口图标默认仍显示。
      if (!this.isForLocalPlayer() && this.entryFrame != null) {
        (pcall as any)(() => hideFrame(this.entryFrame as number));
      }
    });
  }

  private registerRefreshCallback(): void {
    // 4 个槽位都会向 questManager 注册 refresh 回调，触发时各自判断自己是否为本地可见再刷新。
    registerTaskUIRefreshCallback(this.getPanelControlContext(), () => this.refreshList());
  }

  private registerTaskListWheel(): void {
    this.taskListWheelTrig = registerTaskUIListWheel(this.getScrollContext(), () => this.refreshList());
  }

  private createEntryIcon(parent: number): void {
    const res = buildTaskEntryIcon({
      japi,
      parent,
      FrameType,
      FramePoint,
      createFrame,
      createTextLabel,
      setFramePosition,
      setFrameSize,
      setFramePointRelative,
      setFrameClickEvent,
      applyDzTextFontAndCenterAlignment,
      onClickSound: () => SoundUI_ClickPlay(),
      onTogglePanel: () => this.togglePanel(),
      slotPid: this.slotPid,
    });
    this.entryFrame = res.entryFrame;
    this.entryText = res.entryText;
  }

  private createMainPanel(parent: number): void {
    const res = buildTaskMainPanel({
      japi,
      parent,
      entryFrame: this.entryFrame,
      FrameType,
      FramePoint,
      createFrame,
      setFramePosition,
      setFrameSize,
      setFramePointRelative,
      setFrameTexture,
      setFrameHoverEvents,
      setFrameClickEvent,
      setButtonText,
      createTabLabelTextOnBackdrop,
      setupTransparentGlueHitLayer,
      onClickSound: () => SoundUI_ClickPlay(),
      onSwitchCategory: (type: QuestType) => this.switchCategory(type),
      onShowTabTooltip: (msg: string) => this.showTabTooltip(msg),
      getTotalContentHeight: () => this.totalContentHeight,
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v: number) => {
        this.scrollOffset = v;
      },
      isVisible: () => this.isVisible,
      onScrollChanged: () => this.refreshList(),
      slotPid: this.slotPid,
    });

    this.mainPanel = res.mainPanel;
    this.listContainer = res.listContainer;
    this.tabMainBg = res.tabMainBg;
    this.tabMain = res.tabMain;
    this.tabSideBg = res.tabSideBg;
    this.tabSide = res.tabSide;
    this.tabDailyBg = res.tabDailyBg;
    this.tabDaily = res.tabDaily;
    this.scrollBarFrame = res.scrollBarFrame;
    this.scrollThumbFrame = res.scrollThumbFrame;
    this.scrollThumbHitBtn = res.scrollThumbHitBtn;
    this.vScrollTrack?.destroy();
    this.vScrollTrack = res.vScrollTrack;
  }

  private syncScrollThumb(maxScroll: number): void {
    syncTaskUIScrollThumb(this.getScrollContext(), maxScroll);
  }

  /** 无任务时隐藏轨道；有任务时始终显示轨道与滑块（内容不满一屏时滑块贴顶） */
  private updateScrollBarVisibility(maxScroll: number, hasQuestRows: boolean): void {
    updateTaskUIScrollBarVisibility(this.getScrollContext(), maxScroll, hasQuestRows);
  }

  private clearList(): void {
    clearTaskUIList(this.getListControlContext());
  }

  private showTabTooltip(msg: string): void {
    showTaskUITabTooltip(msg);
  }

  public switchCategory(type: QuestType): void {
    if (!this.isForLocalPlayer()) return;
    switchTaskUICategory(this.getPanelControlContext(), type, () => this.refreshList());
  }

  private toggleExpand(questId: string): void {
    const ctx = this.getListControlContext();
    if (ctx.expandedQuestIds.has(questId)) {
      ctx.expandedQuestIds.delete(questId);
    } else {
      ctx.expandedQuestIds.add(questId);
    }
    this.refreshList();
  }

  refreshList(): void {
    if (!this.isForLocalPlayer()) return;
    refreshTaskUIFacadeList(this.getListControlContext(), () => this.refreshList());
  }

  private createListItem(quest: QuestData, rowTopRel: number, expanded: boolean): number | null {
    return createTaskUIListItem(this.getListControlContext(), quest, rowTopRel, expanded, () => this.refreshList());
  }

  public togglePanel(): void {
    if (!this.isForLocalPlayer()) return;
    toggleTaskUIPanel(this.getPanelControlContext(), (playerId: number) => this.show(playerId), () => this.hide());
  }

  public show(playerId: number): void {
    if (!this.isForLocalPlayer()) return;
    showTaskUIPanel(this.getPanelControlContext(), playerId, () => this.refreshList());
  }

  public hide(): void {
    // init 路径允许非本地槽位也隐藏自身（静默下落为 no-op 即可，mainPanel 默认已隐藏）。
    hideTaskUIPanel(this.getPanelControlContext());
  }

  public getIsVisible(): boolean {
    return this.isVisible;
  }

  /** 把门面类的字段包装成"列表控制模块"可消费的上下文，避免拆分文件直接持有 `this`。 */
  private getListControlContext() {
    return {
      mainPanel: this.mainPanel,
      listContainer: this.listContainer,
      currentPlayerId: this.currentPlayerId,
      currentCategory: this.currentCategory,
      expandedQuestIds: this.expandedQuestIds,
      listItemFrames: this.listItemFrames,
      rowBackdropByQuestId: this.rowBackdropByQuestId,
      titleByQuestId: this.titleByQuestId,
      clickBtnByQuestId: this.clickBtnByQuestId,
      objFrameByKey: this.objFrameByKey,
      failFrameByQuestId: this.failFrameByQuestId,
      rowIconByQuestId: this.rowIconByQuestId,
      createTextLabel,
      FramePoint,
      FrameType,
      createFrame,
      setFrameTexture,
      setFramePointRelative,
      setFrameSize,
      setFrameClickEvent,
      showFrame,
      applyDzTextFontAndCenterAlignment,
      applyDzTextFontAndAlignment,
      syncScrollThumb: (maxScroll: number) => this.syncScrollThumb(maxScroll),
      updateScrollBarVisibility: (maxScroll: number, hasQuestRows: boolean) =>
        this.updateScrollBarVisibility(maxScroll, hasQuestRows),
      toggleExpand: (questId: string) => this.toggleExpand(questId),
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v: number) => {
        this.scrollOffset = v;
      },
      getTotalContentHeight: () => this.totalContentHeight,
      setTotalContentHeight: (v: number) => {
        this.totalContentHeight = v;
      },
    };
  }

  /** 滚动模块只拿它真正关心的滚动状态与输入函数，降低耦合面。 */
  private getScrollContext() {
    return {
      mainPanel: this.mainPanel,
      listContainer: this.listContainer,
      scrollBarFrame: this.scrollBarFrame,
      scrollThumbFrame: this.scrollThumbFrame,
      scrollThumbHitBtn: this.scrollThumbHitBtn,
      taskListWheelTrig: this.taskListWheelTrig,
      getMouseFocus: typeof getMouseFocus === "function" ? getMouseFocus : undefined,
      getWheelDelta: typeof getWheelDelta === "function" ? getWheelDelta : undefined,
      registerMouseWheel,
      vScrollTrack: this.vScrollTrack,
      isVisible: () => this.isVisible,
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v: number) => {
        this.scrollOffset = v;
      },
      getTotalContentHeight: () => this.totalContentHeight,
    };
  }

  /** 面板控制模块通过显式 getter/setter 读写状态，兼容 typescript-to-lua。 */
  private getPanelControlContext() {
    return {
      mainPanel: this.mainPanel,
      expandedQuestIds: this.expandedQuestIds,
      vScrollTrack: this.vScrollTrack,
      showFrame,
      hideFrame,
      questManager,
      getCurrentCategory: () => this.currentCategory,
      setCurrentCategory: (type: QuestType) => {
        this.currentCategory = type;
      },
      getScrollOffset: () => this.scrollOffset,
      setScrollOffset: (v: number) => {
        this.scrollOffset = v;
      },
      isVisible: () => this.isVisible,
      setVisible: (v: boolean) => {
        this.isVisible = v;
      },
      getCurrentPlayerId: () => this.currentPlayerId,
      setCurrentPlayerId: (v: number) => {
        this.currentPlayerId = v;
      },
    };
  }
}

// ------------------------------------------------------------
// 多槽位实例 & 模块级调度
// ------------------------------------------------------------

/** 4 个槽位：Player(0)..Player(3)，每客户端全端对称创建。 */
const taskUISlots: TaskUI[] = [];
for (let pid = 0; pid < MAX_TASK_UI_SLOTS; pid++) {
  taskUISlots.push(new TaskUI(pid));
}

/** 对外兜底导出：某些老代码可能通过 `taskUI` 访问。这里返回 slot 0 对应的实例；
 *  需要按本地玩家操作时用 `getLocalTaskUI()`。 */
export const taskUI = taskUISlots[0];

export function getLocalTaskUI(): TaskUI | null {
  const lp = jass.GetLocalPlayer();
  if (lp == null) return null;
  const getPid = (jass as any).GetPlayerId as ((p: any) => number) | undefined;
  if (typeof getPid !== "function") return null;
  const pid = getPid(lp);
  if (pid == null || pid < 0 || pid >= MAX_TASK_UI_SLOTS) return null;
  return taskUISlots[pid] ?? null;
}

export function init(): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  // 所有客户端顺序初始化 4 个槽位，保持帧创建/回调注册的端间对称。
  for (let i = 0; i < taskUISlots.length; i++) {
    taskUISlots[i].init();
  }
}

export function registerHotkey(): void {
  if (!ENABLE_TASK_UI_CLIENT) return;
  // 热键在模块级只注册一次，按"触发玩家 === 本地玩家"派发到本地槽位；
  // 避免 4 槽位各自注册 4 份造成每次按 J 有 4 份回调同时跑。
  registerTaskUIHotkeys({
    registerKeyDown,
    KEY,
    KEY_NUM,
    onClickSound: () => SoundUI_ClickPlay(),
    onTogglePanel: () => {
      const ui = getLocalTaskUI();
      if (ui) ui.togglePanel();
    },
    onSwitchCategory: (type: QuestType) => {
      const ui = getLocalTaskUI();
      if (ui) ui.switchCategory(type);
    },
    isVisible: () => {
      const ui = getLocalTaskUI();
      return ui ? ui.getIsVisible() : false;
    },
    setCurrentPlayerId: (_pid: number) => {
      // 槽位与玩家一一绑定，这里无需再动态设置，保留为 no-op 兼容既有接口。
    },
  });
}
