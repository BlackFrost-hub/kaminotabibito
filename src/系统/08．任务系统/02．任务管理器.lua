local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local onQuestTimeLimitTimerExpire, jass, safeDestroyTimer
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
function onQuestTimeLimitTimerExpire()
    local expired = jass.GetExpiredTimer()
    local ____opt_13 = _G.__questTimers
    if ____opt_13 ~= nil then
        ____opt_13 = ____opt_13:get(expired)
    end
    local data = ____opt_13
    if data then
        ____exports.questManager:onQuestFailed(data.playerId, data.questId)
        _G.__questTimers:delete(expired)
    end
    jass.PauseTimer(expired)
    safeDestroyTimer(nil, expired)
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
safeDestroyTimer = ____require_result_0.safeDestroyTimer
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
    local timer = jass.CreateTimer()
    if not timer then
        return
    end
    local ____G___questTimers_4 = _G.__questTimers
    if not ____G___questTimers_4 then
        local ____TS__New_result_3 = __TS__New(Map)
        _G.__questTimers = ____TS__New_result_3
        ____G___questTimers_4 = ____TS__New_result_3
    end
    local timerData = ____G___questTimers_4
    timerData:set(timer, {playerId = playerId, questId = questId})
    safeTimerStart(
        nil,
        timer,
        quest.timeLimit,
        false,
        onQuestTimeLimitTimerExpire
    )
end
function QuestManager.prototype.onQuestFailed(self, playerId, questId)
    local success = questDB:failQuest(playerId, questId)
    if success then
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
        self:triggerUIRefresh(playerId, questId)
    end
    return success
end
function QuestManager.prototype.onQuestCompleted(self, playerId, questId)
    local success = questDB:completeQuest(playerId, questId)
    if success then
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
____exports.questManager = QuestManager:getInstance()
function ____exports.init()
    ____exports.questManager:initialize()
end
return ____exports
