const jass = require("jass.common") as any;

import { QuestType } from "../01．任务数据";

let currentHotkeyOpts: RegisterTaskUIHotkeysOpts | null = null;
/** 防止 `registerTaskUIHotkeys` 被调用多次时重复挂 J/K1–K3 触发器（会导致一次按键两次 toggle） */
let taskUIKeybindsInstalled = false;

export interface RegisterTaskUIHotkeysOpts {
  registerKeyUpSync: any;
  KEY: any;
  KEY_NUM: any;
  onTogglePanelLocal: () => void;
  onSwitchCategoryState: (type: QuestType) => void;
  onSwitchCategoryUI: (type: QuestType) => void;
}

function handleTogglePanelHotkey(player: any): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
  // 只有本地玩家按键时才处理UI显示
  const localPlayer = jass.GetLocalPlayer();
  if (player !== localPlayer) return;
  opts.onTogglePanelLocal();
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
  // 1. 先同步修改状态（所有客户端执行）
  opts.onSwitchCategoryState(category);
  // 2. 只有本地玩家才处理UI显示
  const localPlayer = jass.GetLocalPlayer();
  if (player !== localPlayer) return;
  opts.onSwitchCategoryUI(category);
}

export function registerTaskUIHotkeys(opts: RegisterTaskUIHotkeysOpts): void {
  const { registerKeyUpSync, KEY, KEY_NUM } = opts;
  if (typeof registerKeyUpSync !== "function") return;
  currentHotkeyOpts = opts;
  if (taskUIKeybindsInstalled) return;
  taskUIKeybindsInstalled = true;
  registerKeyUpSync(KEY.J, handleTogglePanelHotkey);
  registerKeyUpSync(KEY_NUM.K1, handleMainCategoryHotkey);
  registerKeyUpSync(KEY_NUM.K2, handleSideCategoryHotkey);
  registerKeyUpSync(KEY_NUM.K3, handleDailyCategoryHotkey);
}
