const jass = require("jass.common");
import { QuestType } from "../01．任务数据";
// ========== 虚拟分区：J/数字键 热键注册与分发 ==========
let currentHotkeyOpts = null;
/** 防止 `registerTaskUIHotkeys` 被调用多次时重复挂 J/K1–K3 触发器（会导致一次按键两次 toggle） */
let taskUIKeybindsInstalled = false;
function handleTogglePanelHotkey(player) {
    const opts = currentHotkeyOpts;
    if (!opts)
        return;
    const onTogglePanelSync = opts.onTogglePanelSync;
    onTogglePanelSync(player);
}
function handleMainCategoryHotkey(player) {
    handleCategoryHotkey(player, QuestType.MAIN);
}
function handleSideCategoryHotkey(player) {
    handleCategoryHotkey(player, QuestType.SIDE);
}
function handleDailyCategoryHotkey(player) {
    handleCategoryHotkey(player, QuestType.DAILY);
}
function handleCategoryHotkey(player, category) {
    const opts = currentHotkeyOpts;
    if (!opts)
        return;
    const onSwitchCategorySync = opts.onSwitchCategorySync;
    onSwitchCategorySync(player, category);
}
export function registerTaskUIHotkeys(opts) {
    const { registerKeyUpSync, KEY, KEY_NUM } = opts;
    if (typeof registerKeyUpSync !== "function")
        return;
    currentHotkeyOpts = opts;
    if (taskUIKeybindsInstalled)
        return;
    taskUIKeybindsInstalled = true;
    registerKeyUpSync(KEY.J, handleTogglePanelHotkey);
    registerKeyUpSync(KEY_NUM.K1, handleMainCategoryHotkey);
    registerKeyUpSync(KEY_NUM.K2, handleSideCategoryHotkey);
    registerKeyUpSync(KEY_NUM.K3, handleDailyCategoryHotkey);
}
