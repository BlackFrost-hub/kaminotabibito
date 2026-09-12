import { QuestType } from "../01．任务数据";
import { registerKeyUpSync } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";

// ========== 虚拟分区：J/数字键 热键注册与分发 ==========
let currentHotkeyOpts: RegisterTaskUIHotkeysOpts | null = null;
/** 防止 `registerTaskUIHotkeys` 被调用多次时重复挂 J/K1–K3 触发器（会导致一次按键两次 toggle） */
let taskUIKeybindsInstalled = false;

export interface RegisterTaskUIHotkeysOpts {
  KEY: any;
  KEY_NUM: any;
  onTogglePanelSync: (this: void, player: any) => void;
  onSwitchCategorySync: (this: void, player: any, type: QuestType) => void;
}

function handleTogglePanelHotkey(this: any, player: any, _key: number): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
  const onTogglePanelSync = opts.onTogglePanelSync;
  onTogglePanelSync(player);
}

function handleMainCategoryHotkey(this: any, player: any, _key: number): void {
  handleCategoryHotkey(player, QuestType.MAIN);
}

function handleSideCategoryHotkey(this: any, player: any, _key: number): void {
  handleCategoryHotkey(player, QuestType.SIDE);
}

function handleDailyCategoryHotkey(this: any, player: any, _key: number): void {
  handleCategoryHotkey(player, QuestType.DAILY);
}

function handleCategoryHotkey(player: any, category: QuestType): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
  const onSwitchCategorySync = opts.onSwitchCategorySync;
  onSwitchCategorySync(player, category);
}

export function registerTaskUIHotkeys(opts: RegisterTaskUIHotkeysOpts): void {
  const KEY = opts.KEY;
  const KEY_NUM = opts.KEY_NUM;
  currentHotkeyOpts = opts;
  if (taskUIKeybindsInstalled) return;
  taskUIKeybindsInstalled = true;
  // 本机过滤聊天输入后才广播有效键码；回调参数来自同步发送者，不再读取键盘事件上下文。
  registerKeyUpSync(KEY.J, handleTogglePanelHotkey);
  registerKeyUpSync(KEY_NUM.K1, handleMainCategoryHotkey);
  registerKeyUpSync(KEY_NUM.K2, handleSideCategoryHotkey);
  registerKeyUpSync(KEY_NUM.K3, handleDailyCategoryHotkey);
}
