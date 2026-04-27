--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local handleCategoryHotkey, currentHotkeyOpts
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
function handleCategoryHotkey(self, player, category)
    local opts = currentHotkeyOpts
    if not opts then
        return
    end
    local onSwitchCategorySync = opts.onSwitchCategorySync
    onSwitchCategorySync(player, category)
end
local jass = require("jass.common")
currentHotkeyOpts = nil
--- 防止 `registerTaskUIHotkeys` 被调用多次时重复挂 J/K1–K3 触发器（会导致一次按键两次 toggle）
local taskUIKeybindsInstalled = false
local function handleTogglePanelHotkey(self, player)
    local opts = currentHotkeyOpts
    if not opts then
        return
    end
    local onTogglePanelSync = opts.onTogglePanelSync
    onTogglePanelSync(player)
end
local function handleMainCategoryHotkey(self, player)
    handleCategoryHotkey(nil, player, QuestType.MAIN)
end
local function handleSideCategoryHotkey(self, player)
    handleCategoryHotkey(nil, player, QuestType.SIDE)
end
local function handleDailyCategoryHotkey(self, player)
    handleCategoryHotkey(nil, player, QuestType.DAILY)
end
function ____exports.registerTaskUIHotkeys(self, opts)
    local ____opts_0 = opts
    local registerKeyUpSync = ____opts_0.registerKeyUpSync
    local KEY = ____opts_0.KEY
    local KEY_NUM = ____opts_0.KEY_NUM
    if type(registerKeyUpSync) ~= "function" then
        return
    end
    currentHotkeyOpts = opts
    if taskUIKeybindsInstalled then
        return
    end
    taskUIKeybindsInstalled = true
    registerKeyUpSync(nil, KEY.J, handleTogglePanelHotkey)
    registerKeyUpSync(nil, KEY_NUM.K1, handleMainCategoryHotkey)
    registerKeyUpSync(nil, KEY_NUM.K2, handleSideCategoryHotkey)
    registerKeyUpSync(nil, KEY_NUM.K3, handleDailyCategoryHotkey)
end
return ____exports
