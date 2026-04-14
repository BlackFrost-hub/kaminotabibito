--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____index = require("系统.08．任务系统.02．任务管理器.index")
local handleQuestAccepted = ____index.handleQuestAccepted
local handleQuestCompleted = ____index.handleQuestCompleted
local ____06_FF0E_4EFB_52A1STES_6865_63A5 = require("系统.08．任务系统.06．任务STES桥接")
local registerSimpleSTESBridgeEvent = ____06_FF0E_4EFB_52A1STES_6865_63A5.registerSimpleSTESBridgeEvent
local function init(self)
    registerSimpleSTESBridgeEvent(nil, "任务接受事件", handleQuestAccepted, "任务接受")
    registerSimpleSTESBridgeEvent(nil, "任务完成事件", handleQuestCompleted, "任务完成")
end
init(nil)
return ____exports
