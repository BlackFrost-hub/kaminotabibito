import { QuestType } from "../01．任务数据";

let currentHotkeyOpts: RegisterTaskUIHotkeysOpts | null = null;
/** 防止 `registerTaskUIHotkeys` 被调用多次时重复挂 J/K1–K3 触发器（会导致一次按键两次 toggle） */
let taskUIKeybindsInstalled = false;

export interface RegisterTaskUIHotkeysOpts {
  registerKeyUpLocal: any;
  KEY: any;
  KEY_NUM: any;
  onTogglePanelLocal: () => void;
  onSwitchCategoryLocal: (type: QuestType) => void;
}

function handleTogglePanelHotkey(_player: any): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
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

function handleCategoryHotkey(_player: any, category: QuestType): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
  opts.onSwitchCategoryLocal(category);
}

export function registerTaskUIHotkeys(opts: RegisterTaskUIHotkeysOpts): void {
  const { registerKeyUpLocal, KEY, KEY_NUM } = opts;
  if (typeof registerKeyUpLocal !== "function") return;
  currentHotkeyOpts = opts;
  if (taskUIKeybindsInstalled) return;
  taskUIKeybindsInstalled = true;
  registerKeyUpLocal(KEY.J, handleTogglePanelHotkey);
  registerKeyUpLocal(KEY_NUM.K1, handleMainCategoryHotkey);
  registerKeyUpLocal(KEY_NUM.K2, handleSideCategoryHotkey);
  registerKeyUpLocal(KEY_NUM.K3, handleDailyCategoryHotkey);
}
