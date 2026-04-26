--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local ENABLE_TASK_UI_CLIENT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_TASK_UI_CLIENT
local manager = require("系统.08．任务系统.04．任务UI拆分.12．任务UI管理器")
____exports.taskUI = manager.taskUI
function ____exports.init(self)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    manager:init()
end
function ____exports.registerHotkey(self)
    if not ENABLE_TASK_UI_CLIENT then
        return
    end
    manager:registerHotkey()
end
return ____exports
