const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index") as {
  DzTriggerRegisterKeyEventTrg: (this: void, trigger: any, status: number, key: number) => void;
};

import { QuestType } from "../01．任务数据";
import { KEY_STATE } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";

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

function handleTogglePanelHotkey(this: void): void {
  const opts = currentHotkeyOpts;
  if (!opts) return;
  const onTogglePanelSync = opts.onTogglePanelSync;
  onTogglePanelSync(japi.DzGetTriggerKeyPlayer());
}

function handleMainCategoryHotkey(this: void): void {
  handleCategoryHotkey(japi.DzGetTriggerKeyPlayer(), QuestType.MAIN);
}

function handleSideCategoryHotkey(this: void): void {
  handleCategoryHotkey(japi.DzGetTriggerKeyPlayer(), QuestType.SIDE);
}

function handleDailyCategoryHotkey(this: void): void {
  handleCategoryHotkey(japi.DzGetTriggerKeyPlayer(), QuestType.DAILY);
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
  registerTaskSyncKey(KEY.J, handleTogglePanelHotkey);
  registerTaskSyncKey(KEY_NUM.K1, handleMainCategoryHotkey);
  registerTaskSyncKey(KEY_NUM.K2, handleSideCategoryHotkey);
  registerTaskSyncKey(KEY_NUM.K3, handleDailyCategoryHotkey);
}

function registerTaskSyncKey(key: number, callback: (this: void) => void): void {
  // Trg封装内部固定sync=true；每键独立触发器，通过TriggerAddAction执行回调。
  const trigger = jass.CreateTrigger();
  DzTriggerRegisterKeyEventTrg(trigger, KEY_STATE.UP, key);
  jass.TriggerAddAction(trigger, callback);
}
