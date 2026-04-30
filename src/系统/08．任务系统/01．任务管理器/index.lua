--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____04_FF0EQuestManager = require("系统.08．任务系统.01．任务管理器.04．QuestManager")
    ____exports.QuestManager = ____04_FF0EQuestManager.QuestManager
    ____exports.questManager = ____04_FF0EQuestManager.questManager
end
do
    local ____05_FF0E_4E8B_4EF6_6865_63A5 = require("系统.08．任务系统.01．任务管理器.05．事件桥接")
    ____exports.handleQuestAccepted = ____05_FF0E_4E8B_4EF6_6865_63A5.handleQuestAccepted
    ____exports.handleQuestCompleted = ____05_FF0E_4E8B_4EF6_6865_63A5.handleQuestCompleted
    ____exports.handleObjectiveUpdated = ____05_FF0E_4E8B_4EF6_6865_63A5.handleObjectiveUpdated
    ____exports.handleQuestFailed = ____05_FF0E_4E8B_4EF6_6865_63A5.handleQuestFailed
    ____exports.handleQuestAbandoned = ____05_FF0E_4E8B_4EF6_6865_63A5.handleQuestAbandoned
    ____exports.init = ____05_FF0E_4E8B_4EF6_6865_63A5.init
end
return ____exports
