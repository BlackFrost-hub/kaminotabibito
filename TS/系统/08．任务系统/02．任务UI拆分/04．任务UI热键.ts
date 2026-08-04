const jass = require("jass.common") as any;

import { QuestType } from "../01．任务数据";

// ========== 虚拟分区：J/数字键 热键注册与分发 ==========
let currentHotkeyOpts: RegisterTaskUIHotkeysOpts | null = null;
/** 防止 `registerTaskUIHotkeys` 被调用多次时重复挂 J/K1–K3 触发器（会导致一次按键两次 toggle） */
let taskUIKeybindsInstalled = false;

export interface RegisterTaskUIHotkeysOpts {
  /** 用 `registerKeyUpSync`：sync=true 全房触发，回调内用 DzGetTriggerKeyPlayer 区分按键者 */
  registerKeyUpSync: any;
  KEY: any;
  KEY_NUM: any;
  onTogglePanelSync: (this: void, player: any) => void;
  onSwitchCategorySync: (this: void, player: any, type: QuestType) => void;
}

function handleTogglePanelHotkey(player: any): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
  const onTogglePanelSync = opts.onTogglePanelSync;
  onTogglePanelSync(player);
}

function handleMainCategoryHotkey(player: any): void {
  handleCategoryHotkey(player, QuestType.MAIN);
}

function handleSideCategoryHotkey(player: any): void {
  handleCategoryHotkey(player, QuestType.SIDE);
}

function handleDailyCategoryHotkey(player: any): void {
  handleCategoryHotkey(player, QuestType.DAILY);
}

function handleCategoryHotkey(player: any, category: QuestType): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
  const onSwitchCategorySync = opts.onSwitchCategorySync;
  onSwitchCategorySync(player, category);
}

export function registerTaskUIHotkeys(opts: RegisterTaskUIHotkeysOpts): void {
  const { registerKeyUpSync, KEY, KEY_NUM } = opts;
  if (typeof registerKeyUpSync !== "function") return;
  currentHotkeyOpts = opts;
  if (taskUIKeybindsInstalled) return;
  taskUIKeybindsInstalled = true;
  // 暂停 J 键打开任务面板；保留任务系统与其他 UI 入口正常初始化。
  // registerKeyUpSync(KEY.J, handleTogglePanelHotkey);
  registerKeyUpSync(KEY_NUM.K1, handleMainCategoryHotkey);
  registerKeyUpSync(KEY_NUM.K2, handleSideCategoryHotkey);
  registerKeyUpSync(KEY_NUM.K3, handleDailyCategoryHotkey);
}
