--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local handleQuestAccepted = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.handleQuestAccepted
local handleQuestCompleted = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.handleQuestCompleted
local ____05_FF0E_4EFB_52A1STES_6865_63A5 = require("系统.08．任务系统.05．任务STES桥接")
local registerSimpleSTESBridgeEvent = ____05_FF0E_4EFB_52A1STES_6865_63A5.registerSimpleSTESBridgeEvent
local function init(self)
    registerSimpleSTESBridgeEvent(nil, "任务接受事件", handleQuestAccepted, "任务接受")
    registerSimpleSTESBridgeEvent(nil, "任务完成事件", handleQuestCompleted, "任务完成")
end
init(nil)
return ____exports
