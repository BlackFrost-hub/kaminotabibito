local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local onQuestTimeLimitTick, removePeriodicCallback, getServerTime, questTimeLimitTasks, questInternalTimeLimitTasks, questTimeLimitScanId
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
function onQuestTimeLimitTick()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #questTimeLimitTasks do
            do
                local task = questTimeLimitTasks[i + 1]
                if now >= task.dueTime then
                    ____exports.questManager:onQuestFailed(task.playerId, task.questId)
                    goto __continue41
                end
                questTimeLimitTasks[writeIndex + 1] = task
                writeIndex = writeIndex + 1
            end
            ::__continue41::
            i = i + 1
        end
    end
    do
        local i = #questTimeLimitTasks - 1
        while i >= writeIndex do
            table.remove(questTimeLimitTasks)
            i = i - 1
        end
    end
    if #questTimeLimitTasks == 0 and questTimeLimitScanId ~= 0 then
        removePeriodicCallback(questTimeLimitScanId)
        questTimeLimitScanId = 0
    end
end
--- 任务管理器（单文件入口）
-- 职责概览：
-- - 与 `questDB` 打交道：接取、完成、失败、放弃、目标进度、查询
-- - 维护 `uiRefreshCallbacks`：任务状态变化时通知自定义 UI（如任务面板）
-- - 可选限时：`timeLimit` > 0 时挂中心调度任务，到期调用 `onQuestFailed`
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local QuestManager = __TS__Class()
QuestManager.name = "QuestManager"
function QuestManager.prototype.____constructor(self)
    self.isInitialized = false
    self.uiRefreshCallbacks = {}
end
function QuestManager.getInstance(self)
    if not QuestManager.instance then
        QuestManager.instance = __TS__New(QuestManager)
    end
    return QuestManager.instance
end
function QuestManager.prototype.initialize(self)
    if self.isInitialized then
        return
    end
    do
        local i = 0
        while i < 12 do
            questDB:initPlayerData(i)
            i = i + 1
        end
    end
    self.isInitialized = true
end
function QuestManager.prototype.setupTimeLimit(self, playerId, questId)
    local ____opt_1 = questDB.globalData
    if ____opt_1 ~= nil then
        ____opt_1 = ____opt_1.quests:get(questId)
    end
    local quest = ____opt_1
    if not quest or not quest.timeLimit or quest.timeLimit <= 0 then
        return
    end
    questTimeLimitTasks[#questTimeLimitTasks + 1] = {
        dueTime = getServerTime() + quest.timeLimit * 1000,
        playerId = playerId,
        questId = questId
    }
    if questTimeLimitScanId == 0 then
        questTimeLimitScanId = addPeriodicCallback(10, onQuestTimeLimitTick)
    end
end
function QuestManager.prototype.setupInternalTimeLimit(self, questId)
    local ____opt_3 = questDB.globalData
    if ____opt_3 ~= nil then
        ____opt_3 = ____opt_3.quests:get(questId)
    end
    local quest = ____opt_3
    if not quest or not quest["内部限时秒"] or quest["内部限时秒"] <= 0 then
        return
    end
    questInternalTimeLimitTasks:set(
        questId,
        getServerTime() + quest["内部限时秒"] * 1000
    )
end
QuestManager.prototype["任务内部限时是否有效"] = function(self, questId)
    local deadline = questInternalTimeLimitTasks:get(questId)
    if deadline == nil then
        return false
    end
    if getServerTime() <= deadline then
        return true
    end
    questInternalTimeLimitTasks:delete(questId)
    return false
end
QuestManager.prototype["清理任务内部限时"] = function(self, questId)
    questInternalTimeLimitTasks:delete(questId)
end
function QuestManager.prototype.onQuestFailed(self, playerId, questId)
    local success = questDB:failQuest(playerId, questId)
    if success then
        self["清理任务内部限时"](self, questId)
        self:triggerUIRefresh(playerId, questId)
    end
    return success
end
function QuestManager.prototype.onQuestAbandoned(self, playerId, questId)
    local ____opt_7 = questDB.globalData
    if ____opt_7 ~= nil then
        ____opt_7 = ____opt_7.quests:get(questId)
    end
    local ____opt_result_9
    if ____opt_7 ~= nil then
        ____opt_result_9 = ____opt_7.nativeHandle
    end
    local nativeHandle = ____opt_result_9
    local success = questDB:abandonQuest(playerId, questId)
    if success then
        self["清理任务内部限时"](self, questId)
        if nativeHandle then
            jass.DestroyQuest(nativeHandle)
        end
        self:triggerUIRefresh(playerId, questId)
    end
    return success
end
function QuestManager.prototype.registerUIRefreshCallback(self, callback)
    local ____self_uiRefreshCallbacks_10 = self.uiRefreshCallbacks
    ____self_uiRefreshCallbacks_10[#____self_uiRefreshCallbacks_10 + 1] = callback
end
function QuestManager.prototype.triggerUIRefresh(self, playerId, questId)
    for ____, callback in ipairs(self.uiRefreshCallbacks) do
        do
            pcall(function()
                callback(playerId, questId)
            end)
        end
    end
end
function QuestManager.prototype.onQuestAccepted(self, playerId, questId)
    local success = questDB:acceptQuest(playerId, questId)
    if success then
        self:setupTimeLimit(playerId, questId)
        self:setupInternalTimeLimit(questId)
        self:triggerUIRefresh(playerId, questId)
    end
    return success
end
function QuestManager.prototype.onQuestCompleted(self, playerId, questId)
    local success = questDB:completeQuest(playerId, questId)
    if success then
        self["清理任务内部限时"](self, questId)
        self:triggerUIRefresh(playerId, questId)
    end
    return success
end
function QuestManager.prototype.updateQuestObjective(self, playerId, questId, objectiveId, progress)
    local success = questDB:updateObjective(playerId, questId, objectiveId, progress)
    if success then
        self:triggerUIRefresh(playerId, questId)
        local ____opt_11 = questDB.globalData
        if ____opt_11 ~= nil then
            ____opt_11 = ____opt_11.quests:get(questId)
        end
        local quest = ____opt_11
        if quest and quest.objectives then
            local allCompleted = true
            for ____, obj in __TS__Iterator(quest.objectives) do
                if not obj or not obj.completed then
                    allCompleted = false
                    break
                end
            end
            if allCompleted then
                self:onQuestCompleted(playerId, questId)
            end
        end
    end
    return success
end
questTimeLimitTasks = {}
questInternalTimeLimitTasks = __TS__New(Map)
questTimeLimitScanId = 0
____exports.questManager = QuestManager:getInstance()
____exports["任务内部限时是否有效"] = function(questId)
    return ____exports.questManager["任务内部限时是否有效"](____exports.questManager, questId)
end
____exports["清理任务内部限时"] = function(questId)
    ____exports.questManager["清理任务内部限时"](____exports.questManager, questId)
end
____exports["触发任务UI刷新"] = function(playerId, questId)
    ____exports.questManager:triggerUIRefresh(playerId, questId)
end
function ____exports.init()
    ____exports.questManager:initialize()
end
return ____exports
