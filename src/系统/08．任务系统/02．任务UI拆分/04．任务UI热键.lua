--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local handleCategoryHotkey, registerTaskSyncKey, jass, DzTriggerRegisterKeyEventTrg, currentHotkeyOpts
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local KEY_STATE = ____index.KEY_STATE
function handleCategoryHotkey(self, player, category)
    local opts = currentHotkeyOpts
    if not opts then
        return
    end
    local onSwitchCategorySync = opts.onSwitchCategorySync
    onSwitchCategorySync(player, category)
end
function registerTaskSyncKey(self, key, callback)
    local trigger = jass.CreateTrigger()
    DzTriggerRegisterKeyEventTrg(trigger, KEY_STATE.UP, key)
    jass.TriggerAddAction(trigger, callback)
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
DzTriggerRegisterKeyEventTrg = ____require_result_0.DzTriggerRegisterKeyEventTrg
currentHotkeyOpts = nil
--- 防止 `registerTaskUIHotkeys` 被调用多次时重复挂 J/K1–K3 触发器（会导致一次按键两次 toggle）
local taskUIKeybindsInstalled = false
local function handleTogglePanelHotkey()
    local opts = currentHotkeyOpts
    if not opts then
        return
    end
    local onTogglePanelSync = opts.onTogglePanelSync
    onTogglePanelSync(japi.DzGetTriggerKeyPlayer())
end
local function handleMainCategoryHotkey()
    handleCategoryHotkey(
        nil,
        japi.DzGetTriggerKeyPlayer(),
        QuestType.MAIN
    )
end
local function handleSideCategoryHotkey()
    handleCategoryHotkey(
        nil,
        japi.DzGetTriggerKeyPlayer(),
        QuestType.SIDE
    )
end
local function handleDailyCategoryHotkey()
    handleCategoryHotkey(
        nil,
        japi.DzGetTriggerKeyPlayer(),
        QuestType.DAILY
    )
end
function ____exports.registerTaskUIHotkeys(self, opts)
    local KEY = opts.KEY
    local KEY_NUM = opts.KEY_NUM
    currentHotkeyOpts = opts
    if taskUIKeybindsInstalled then
        return
    end
    taskUIKeybindsInstalled = true
    registerTaskSyncKey(nil, KEY.J, handleTogglePanelHotkey)
    registerTaskSyncKey(nil, KEY_NUM.K1, handleMainCategoryHotkey)
    registerTaskSyncKey(nil, KEY_NUM.K2, handleSideCategoryHotkey)
    registerTaskSyncKey(nil, KEY_NUM.K3, handleDailyCategoryHotkey)
end
return ____exports
