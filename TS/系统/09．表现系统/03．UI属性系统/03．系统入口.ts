/** @noSelfInFile */
/**
 * UI属性系统 - 生命周期入口
 *
 * 功能：
 * - Tab显示伤害统计
 * - F2-F6跳镜头到对应英雄
 * - 英雄头像悬浮显示属性框
 *
 * 初始化：延迟INIT_DELAY_SECONDS秒启动
 * 刷新：每 REFRESH_INTERVAL_SECONDS 无条件刷新（与 `属性查看.j` 一致：两处 CreateTimer 3.00 周期也是全局一直跑；本 TS 间隔见常量，非按 Tab 门控）
 *
 * 联机：键盘走 `sync=true`，全端对称进回调；**仅** Tab 控制的伤害面板显隐在回调内用
 * `getTriggerKeyPlayer() === GetLocalPlayer()` 隔离。F2–F6、中心计时器刷新等为同步路径（镜头平移仍只在触发键玩家本机生效，见 Star 镜头封装）。
 */

const jass = require("jass.common") as any;
const 硬件函数 = require("系统.00．核心系统.02．硬件函数") as {
  registerKeyEventRawStatus: (keyCode: number, status: number, sync: boolean, action: () => void) => any;
  getTriggerKeyPlayer: () => any;
};
const 中心计时器 = globalThis as unknown as {
  onTick10ms: (callback: () => void) => void;
  offTick10ms: (callback: () => void) => void;
};

const 常量 = require("系统.09．表现系统.03．UI属性系统.00．常量定义") as {
  INIT_DELAY_SECONDS: number;
  KEY_EVENT_DOWN: number;
  KEY_EVENT_UP: number;
  KEY_F: readonly number[];
  KEY_TAB: number;
  REFRESH_INTERVAL_SECONDS: number;
  UI_ATTRIBUTE_SYSTEM_ENABLED: boolean;
};
const {
  createUiFrames,
  focusHeroByFunctionKey,
  showDamagePanel,
  updateDamagePanel,
  updateDetailPanels,
} = require("系统.09．表现系统.03．UI属性系统.02．面板渲染") as {
  createUiFrames: (this: void) => void;
  focusHeroByFunctionKey: (this: void, functionKey: number) => any;
  showDamagePanel: (this: void, visible: boolean) => void;
  updateDamagePanel: (this: void) => void;
  updateDetailPanels: (this: void) => void;
};
const Star扩展库 = require("lib.扩展函数.Star扩展函数.Star扩展库.index") as {
  StarOther_PanCameraToTimedForPlayer: (player: any, x: number, y: number, duration: number) => void;
};

let initialized = false;
let startupScheduled = false;
let startupAccumulator = 0;
let refreshAccumulator = 0;
/** 延迟启动用 tick，init 后注销，避免每 10ms 空转 */
let startupTickHandler: (() => void) | null = null;

/**
 * 统一刷新整套 UI 的动态内容。
 */
function refreshAllUi(): void {
   updateDamagePanel();
   updateDetailPanels();
}

/**
 * 包一层按键注册：sync=true 全房对称；Tab 显隐在 action 内自行做本地玩家门控。
 */
function registerKey(status: number, keyCode: number, action: () => void): void {
  硬件函数.registerKeyEventRawStatus(keyCode, status, true, action);
}

/**
 * 注册 Tab 显示/隐藏伤害统计。
 */
function registerDamagePanelHotkeys(): void {
  registerKey(常量.KEY_EVENT_DOWN, 常量.KEY_TAB, () => {
    if (硬件函数.getTriggerKeyPlayer() !== jass.GetLocalPlayer()) return;
    showDamagePanel(true);
  });
  registerKey(常量.KEY_EVENT_UP, 常量.KEY_TAB, () => {
    if (硬件函数.getTriggerKeyPlayer() !== jass.GetLocalPlayer()) return;
    showDamagePanel(false);
  });
}

/**
 * 注册 F2-F6 跳镜头。
 */
function registerFocusHotkeys(): void {
  for (let i = 0; i < 常量.KEY_F.length; i++) {
    const functionKey = 常量.KEY_F[i];
    registerKey(常量.KEY_EVENT_UP, functionKey, () => {
      const p = 硬件函数.getTriggerKeyPlayer();
      if (p == null) return;
      const hero = focusHeroByFunctionKey(functionKey);
      if (hero == null) return;
      // 与 `属性查看.j` 一致：只按 DzGetTriggerKeyPlayer 平移镜头，勿用 GetLocalPlayer 兜底（会偏离按键所属玩家）。
      Star扩展库.StarOther_PanCameraToTimedForPlayer(p, jass.GetUnitX(hero), jass.GetUnitY(hero), 0.05);
    });
  }
}

function startRefreshLoop(): void {
  中心计时器.onTick10ms(() => {
    refreshAccumulator = refreshAccumulator + 0.01;
    if (refreshAccumulator + 0.0001 < 常量.REFRESH_INTERVAL_SECONDS) return;
    refreshAccumulator = 0;
    refreshAllUi();
  });
}

/**
 * 独立安排 UI 启动时机。
 */
function scheduleUiStartup(): void {
  if (startupScheduled) return;
  startupScheduled = true;
  startupTickHandler = () => {
    if (initialized) return;
    startupAccumulator = startupAccumulator + 0.01;
    if (startupAccumulator + 0.0001 < 常量.INIT_DELAY_SECONDS) return;
    initUiAttributeSystem();
  };
  中心计时器.onTick10ms(startupTickHandler);
}

/**
 * UI属性系统总入口。
 */
export function initUiAttributeSystem(): void {
  if (!常量.UI_ATTRIBUTE_SYSTEM_ENABLED) return;
  if (initialized) return;

  if (startupTickHandler != null) {
    中心计时器.offTick10ms(startupTickHandler);
    startupTickHandler = null;
  }

  initialized = true;

  createUiFrames();
  refreshAllUi();
  registerDamagePanelHotkeys();
  registerFocusHotkeys();
  startRefreshLoop();
}

export function isUiAttributeSystemEnabled(): boolean {
  return 常量.UI_ATTRIBUTE_SYSTEM_ENABLED;
}

if (常量.UI_ATTRIBUTE_SYSTEM_ENABLED) {
  scheduleUiStartup();
}
