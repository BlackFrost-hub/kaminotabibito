local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local onQuestTimeLimitTimerExpire, jass, safeDestroyTimer
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local ____01_FF0E_8C03_8BD5 = require("系统.08．任务系统.02．任务管理器.01．调试")
local questDebugPrint = ____01_FF0E_8C03_8BD5.questDebugPrint
local ____02_FF0E_4EFB_52A1_63D0_793A_4E0E_5956_52B1 = require("系统.08．任务系统.02．任务管理器.02．任务提示与奖励")
local giveQuestRewards = ____02_FF0E_4EFB_52A1_63D0_793A_4E0E_5956_52B1.giveQuestRewards
local showAbandonedQuestNotice = ____02_FF0E_4EFB_52A1_63D0_793A_4E0E_5956_52B1.showAbandonedQuestNotice
local showQuestAcceptedMessage = ____02_FF0E_4EFB_52A1_63D0_793A_4E0E_5956_52B1.showQuestAcceptedMessage
local showQuestCompletedMessage = ____02_FF0E_4EFB_52A1_63D0_793A_4E0E_5956_52B1.showQuestCompletedMessage
local showQuestFailedMessage = ____02_FF0E_4EFB_52A1_63D0_793A_4E0E_5956_52B1.showQuestFailedMessage
local showQuestTrackingNotice = ____02_FF0E_4EFB_52A1_63D0_793A_4E0E_5956_52B1.showQuestTrackingNotice
function onQuestTimeLimitTimerExpire()
    local expired = jass.GetExpiredTimer()
    local ____opt_15 = _G.__questTimers
    if ____opt_15 ~= nil then
        ____opt_15 = ____opt_15:get(expired)
    end
    local data = ____opt_15
    if data then
        questDebugPrint(
            nil,
            ("任务 " .. tostring(data.questId)) .. " 时间到期"
        )
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
--- 单例类。计时器到期回调里必须用 `QuestManager.getInstance()`，
-- 避免在模块顶层 `questManager` 尚未完成初始化时闭包引用未定义。
____exports.QuestManager = __TS__Class()
local QuestManager = ____exports.QuestManager
QuestManager.name = "QuestManager"
function QuestManager.prototype.____constructor(self)
    self.isInitialized = false
    self.uiRefreshCallbacks = {}
end
function QuestManager.getInstance(self)
    if not ____exports.QuestManager.instance then
        ____exports.QuestManager.instance = __TS__New(____exports.QuestManager)
    end
    return ____exports.QuestManager.instance
end
function QuestManager.prototype.initialize(self)
    if self.isInitialized then
        return
    end
    questDebugPrint(nil, "初始化任务系统...")
    do
        local i = 0
        while i < 12 do
            questDB:initPlayerData(i)
            i = i + 1
        end
    end
    self:setupWar3QuestSync()
    self.isInitialized = true
end
function QuestManager.prototype.setupWar3QuestSync(self)
    questDebugPrint(nil, "War3原生任务同步已就绪")
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
    questDebugPrint(
        nil,
        ((("已为任务 " .. questId) .. " 设置 ") .. tostring(quest.timeLimit)) .. " 秒时间限制"
    )
end
function QuestManager.prototype.onQuestFailed(self, playerId, questId)
    questDebugPrint(
        nil,
        ((("玩家 " .. tostring(playerId)) .. " 任务 ") .. questId) .. " 失败"
    )
    local success = questDB:failQuest(playerId, questId)
    if success then
        self:triggerUIRefresh(playerId, questId)
        showQuestFailedMessage(nil, playerId, questId)
    else
        questDebugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 任务 ") .. questId) .. " 失败处理失败"
        )
    end
    return success
end
function QuestManager.prototype.onQuestAbandoned(self, playerId, questId)
    questDebugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 放弃任务 ") .. questId
    )
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
        showAbandonedQuestNotice(nil, playerId, questId)
    else
        questDebugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 放弃任务 ") .. questId) .. " 失败"
        )
    end
    return success
end
function QuestManager.prototype.toggleQuestTracking(self, playerId, questId)
    local ____opt_10 = questDB.globalData
    if ____opt_10 ~= nil then
        ____opt_10 = ____opt_10.quests:get(questId)
    end
    local questData = ____opt_10
    if not questData then
        return false
    end
    questDebugPrint(nil, "已追踪任务 " .. questId)
    showQuestTrackingNotice(nil, playerId, questData.title)
    self:triggerUIRefresh(playerId, questId)
    return true
end
function QuestManager.prototype.registerUIRefreshCallback(self, callback)
    local ____self_uiRefreshCallbacks_12 = self.uiRefreshCallbacks
    ____self_uiRefreshCallbacks_12[#____self_uiRefreshCallbacks_12 + 1] = callback
end
function QuestManager.prototype.triggerUIRefresh(self, playerId, questId)
    for ____, callback in ipairs(self.uiRefreshCallbacks) do
        do
            local function ____catch(____error)
                questDebugPrint(
                    nil,
                    "UI刷新回调错误: " .. tostring(____error)
                )
            end
            local ____try, ____hasReturned = pcall(function()
                callback(playerId, questId)
            end)
            if not ____try then
                ____catch(____hasReturned)
            end
        end
    end
end
function QuestManager.prototype.onQuestAccepted(self, playerId, questId)
    questDebugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 接受任务 ") .. questId
    )
    local success = questDB:acceptQuest(playerId, questId)
    if success then
        self:setupTimeLimit(playerId, questId)
        self:triggerUIRefresh(playerId, questId)
        showQuestAcceptedMessage(nil, playerId, questId)
    else
        questDebugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 接受任务 ") .. questId) .. " 失败"
        )
    end
    return success
end
function QuestManager.prototype.onQuestCompleted(self, playerId, questId)
    questDebugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 完成任务 ") .. questId
    )
    local success = questDB:completeQuest(playerId, questId)
    if success then
        giveQuestRewards(nil, playerId, questId)
        self:triggerUIRefresh(playerId, questId)
        showQuestCompletedMessage(nil, playerId, questId)
    else
        questDebugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 完成任务 ") .. questId) .. " 失败"
        )
    end
    return success
end
function QuestManager.prototype.updateQuestObjective(self, playerId, questId, objectiveId, progress)
    local success = questDB:updateObjective(playerId, questId, objectiveId, progress)
    if success then
        self:triggerUIRefresh(playerId, questId)
        local ____opt_13 = questDB.globalData
        if ____opt_13 ~= nil then
            ____opt_13 = ____opt_13.quests:get(questId)
        end
        local quest = ____opt_13
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
function QuestManager.prototype.getPlayerQuests(self, playerId, ____type)
    local activeQuests = questDB:getPlayerActiveQuests(playerId)
    if not ____type then
        return activeQuests
    end
    return __TS__ArrayFilter(
        activeQuests,
        function(____, quest) return quest.type == ____type end
    )
end
function QuestManager.prototype.getAvailableQuests(self, playerId, ____type)
    return questDB:getAvailableQuests(playerId, ____type)
end
function QuestManager.prototype.getQuestData(self, questId)
    return questDB:getQuest(questId)
end
function QuestManager.prototype.getPlayerQuestStatus(self, playerId, questId)
    return questDB:getPlayerQuestStatus(playerId, questId)
end
function QuestManager.prototype.resetPlayerQuests(self, playerId)
    questDB:resetPlayerData(playerId)
    questDebugPrint(
        nil,
        ("已重置玩家 " .. tostring(playerId)) .. " 的任务数据"
    )
end
function QuestManager.prototype.getStatus(self)
    local allQuests = questDB:getAllQuests()
    return {initialized = self.isInitialized, questCount = #allQuests}
end
--- 模块加载后即存在的单例引用；`05．事件桥接` 与其它系统统一使用此变量
____exports.questManager = ____exports.QuestManager:getInstance()
return ____exports
