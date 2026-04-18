/** @noSelfInFile */
/**
 * UI属性系统 - 生命周期入口
 */

const jass = require("jass.common") as any;
const 硬件函数 = require("系统.00．核心系统.02．硬件函数") as {
  registerKeyEventRawStatus: (keyCode: number, status: number, sync: boolean, action: () => void) => any;
  getTriggerKeyPlayer: () => any;
};
const 中心计时器 = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (callback: () => void) => void;
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

/**
 * 统一刷新整套 UI 的动态内容。
 */
function refreshAllUi(): void {
  updateDamagePanel();
  updateDetailPanels();
}

/**
 * 包一层按键注册，保持和原 JASS 的 Tab/F2-F6 热键行为一致。
 */
function registerKey(status: number, keyCode: number, action: () => void): void {
  硬件函数.registerKeyEventRawStatus(keyCode, status, false, action);
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
      const player = 硬件函数.getTriggerKeyPlayer();
      if (player !== jass.GetLocalPlayer()) return;
      const hero = focusHeroByFunctionKey(functionKey);
      if (hero == null) return;
      Star扩展库.StarOther_PanCameraToTimedForPlayer(player, jass.GetUnitX(hero), jass.GetUnitY(hero), 0.05);
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
  中心计时器.onTick10ms(() => {
    if (initialized) return;
    startupAccumulator = startupAccumulator + 0.01;
    if (startupAccumulator + 0.0001 < 常量.INIT_DELAY_SECONDS) return;
    initUiAttributeSystem();
  });
}

/**
 * UI属性系统总入口。
 */
export function initUiAttributeSystem(): void {
  if (!常量.UI_ATTRIBUTE_SYSTEM_ENABLED) return;
  if (initialized) return;
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
