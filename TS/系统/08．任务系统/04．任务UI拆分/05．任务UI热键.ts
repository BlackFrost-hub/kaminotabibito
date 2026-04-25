import { QuestType } from "../01．任务数据";

let currentHotkeyOpts: RegisterTaskUIHotkeysOpts | null = null;

export interface RegisterTaskUIHotkeysOpts {
  registerKeyUpLocal: any;
  KEY: any;
  KEY_NUM: any;
  onClickSound: () => void;
  onTogglePanelLocal: () => void;
  onSwitchCategoryLocal: (type: QuestType) => void;
}

function handleTogglePanelHotkey(_player: any): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
  (pcall as any)(() => {
    opts.onTogglePanelLocal();
    opts.onClickSound();
  });
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
  (pcall as any)(() => {
    opts.onSwitchCategoryLocal(category);
    opts.onClickSound();
  });
}

export function registerTaskUIHotkeys(opts: RegisterTaskUIHotkeysOpts): void {
  const { registerKeyUpLocal, KEY, KEY_NUM } = opts;
  if (typeof registerKeyUpLocal !== "function") return;
  currentHotkeyOpts = opts;

  registerKeyUpLocal(KEY.J, handleTogglePanelHotkey);
  registerKeyUpLocal(KEY_NUM.K1, handleMainCategoryHotkey);
  registerKeyUpLocal(KEY_NUM.K2, handleSideCategoryHotkey);
  registerKeyUpLocal(KEY_NUM.K3, handleDailyCategoryHotkey);
}
