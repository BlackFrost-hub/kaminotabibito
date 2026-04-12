local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local createTestQuests = ____01_FF0E_4EFB_52A1_6570_636E.createTestQuests
--- 任务系统 - 任务管理器和事件处理
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local findHeroOfPlayer = ____require_result_0.findHeroOfPlayer
local function debugPrint(self, msg)
end
--- 任务管理器类
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
    debugPrint(nil, "初始化任务系统...")
    createTestQuests(nil)
    do
        local i = 0
        while i < 12 do
            questDB:initPlayerData(i)
            i = i + 1
        end
    end
    questDB:acceptQuest(0, "side_002")
    self:setupWar3QuestSync()
    self.isInitialized = true
    debugPrint(nil, "任务系统初始化完成")
end
function QuestManager.prototype.getPlayerHero(self, playerId)
    return findHeroOfPlayer(nil, playerId)
end
function QuestManager.prototype.setupWar3QuestSync(self)
    debugPrint(nil, "War3原生任务同步已就绪")
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
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" or type(jass.GetExpiredTimer) ~= "function" then
        debugPrint(nil, "计时器API不可用，无法设置时间限制")
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
    jass.TimerStart(
        timer,
        quest.timeLimit,
        false,
        function()
            local expired = jass.GetExpiredTimer()
            local ____opt_5 = _G.__questTimers
            if ____opt_5 ~= nil then
                ____opt_5 = ____opt_5:get(expired)
            end
            local data = ____opt_5
            if data then
                debugPrint(
                    nil,
                    ("任务 " .. tostring(data.questId)) .. " 时间到期"
                )
                ____exports.questManager:onQuestFailed(data.playerId, data.questId)
                _G.__questTimers:delete(expired)
            end
            if type(jass.PauseTimer) == "function" then
                jass.PauseTimer(expired)
            end
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(expired)
            end
        end
    )
    debugPrint(
        nil,
        ((("已为任务 " .. questId) .. " 设置 ") .. tostring(quest.timeLimit)) .. " 秒时间限制"
    )
end
function QuestManager.prototype.onQuestFailed(self, playerId, questId)
    debugPrint(
        nil,
        ((("玩家 " .. tostring(playerId)) .. " 任务 ") .. questId) .. " 失败"
    )
    local success = questDB:failQuest(playerId, questId)
    if success then
        self:triggerUIRefresh(playerId, questId)
        self:showQuestFailedMessage(playerId, questId)
    else
        debugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 任务 ") .. questId) .. " 失败处理失败"
        )
    end
    return success
end
function QuestManager.prototype.onQuestAbandoned(self, playerId, questId)
    debugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 放弃任务 ") .. questId
    )
    local ____opt_9 = questDB.globalData
    if ____opt_9 ~= nil then
        ____opt_9 = ____opt_9.quests:get(questId)
    end
    local ____opt_result_11
    if ____opt_9 ~= nil then
        ____opt_result_11 = ____opt_9.nativeHandle
    end
    local nativeHandle = ____opt_result_11
    local success = questDB:abandonQuest(playerId, questId)
    if success then
        if nativeHandle and type(jass.DestroyQuest) == "function" then
            jass.DestroyQuest(nativeHandle)
        end
        self:triggerUIRefresh(playerId, questId)
        if type(jass.DisplayTimedTextToPlayer) == "function" then
            local player = jass.Player(playerId)
            if player then
                jass.DisplayTimedTextToPlayer(
                    player,
                    0,
                    0,
                    8,
                    "已放弃任务: " .. questId
                )
            end
        end
    else
        debugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 放弃任务 ") .. questId) .. " 失败"
        )
    end
    return success
end
function QuestManager.prototype.toggleQuestTracking(self, playerId, questId)
    local ____opt_12 = questDB.globalData
    if ____opt_12 ~= nil then
        ____opt_12 = ____opt_12.quests:get(questId)
    end
    local questData = ____opt_12
    if not questData then
        return false
    end
    debugPrint(nil, "已追踪任务 " .. questId)
    local player = jass.Player(playerId)
    if player and type(jass.DisplayTimedTextToPlayer) == "function" then
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            6,
            "正在追踪: " .. tostring(questData.title)
        )
    end
    self:triggerUIRefresh(playerId, questId)
    return true
end
function QuestManager.prototype.showQuestFailedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        local message = "任务失败: " .. quest.title
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            10,
            message
        )
    end
end
function QuestManager.prototype.registerUIRefreshCallback(self, callback)
    local ____self_uiRefreshCallbacks_14 = self.uiRefreshCallbacks
    ____self_uiRefreshCallbacks_14[#____self_uiRefreshCallbacks_14 + 1] = callback
end
function QuestManager.prototype.triggerUIRefresh(self, playerId, questId)
    for ____, callback in ipairs(self.uiRefreshCallbacks) do
        do
            local function ____catch(____error)
                debugPrint(
                    nil,
                    "UI刷新回调错误: " .. tostring(____error)
                )
            end
            local ____try, ____hasReturned = pcall(function()
                callback(nil, playerId, questId)
            end)
            if not ____try then
                ____catch(____hasReturned)
            end
        end
    end
end
function QuestManager.prototype.onQuestAccepted(self, playerId, questId)
    debugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 接受任务 ") .. questId
    )
    local success = questDB:acceptQuest(playerId, questId)
    if success then
        self:setupTimeLimit(playerId, questId)
        self:triggerUIRefresh(playerId, questId)
        self:showQuestAcceptedMessage(playerId, questId)
    else
        debugPrint(
            nil,
            ((("玩家 " .. tostring(playerId)) .. " 接受任务 ") .. questId) .. " 失败"
        )
    end
    return success
end
function QuestManager.prototype.onQuestCompleted(self, playerId, questId)
    debugPrint(
        nil,
        (("玩家 " .. tostring(playerId)) .. " 完成任务 ") .. questId
    )
    local success = questDB:completeQuest(playerId, questId)
    if success then
        self:giveQuestRewards(playerId, questId)
        self:triggerUIRefresh(playerId, questId)
        self:showQuestCompletedMessage(playerId, questId)
    else
        debugPrint(
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
        local ____opt_15 = questDB.globalData
        if ____opt_15 ~= nil then
            ____opt_15 = ____opt_15.quests:get(questId)
        end
        local quest = ____opt_15
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
function QuestManager.prototype.syncToWar3Quest(self, playerId, questId)
    if type(jass.CreateQuest) ~= "function" then
        return
    end
    local ____opt_17 = questDB.globalData
    if ____opt_17 ~= nil then
        ____opt_17 = ____opt_17.quests:get(questId)
    end
    local questData = ____opt_17
    if not questData then
        return
    end
    if questData.nativeHandle and type(jass.DestroyQuest) == "function" then
        jass.DestroyQuest(questData.nativeHandle)
    end
    local nativeQuest = jass.CreateQuest()
    questData.nativeHandle = nativeQuest
    if not nativeQuest then
        return
    end
    if type(jass.QuestSetTitle) == "function" then
        jass.QuestSetTitle(nativeQuest, questData.title)
    end
    if type(jass.QuestSetDescription) == "function" then
        jass.QuestSetDescription(nativeQuest, questData.description)
    end
    if questData.icon and type(jass.QuestSetIconPath) == "function" then
        jass.QuestSetIconPath(nativeQuest, questData.icon)
    end
    if type(jass.QuestSetRequired) == "function" then
        jass.QuestSetRequired(nativeQuest, questData.type == QuestType.MAIN)
    end
    repeat
        local ____switch70 = questData.status
        local ____cond70 = ____switch70 == QuestStatus.IN_PROGRESS
        if ____cond70 then
            if type(jass.QuestSetDiscovered) == "function" then
                jass.QuestSetDiscovered(nativeQuest, true)
            end
            break
        end
        ____cond70 = ____cond70 or ____switch70 == QuestStatus.COMPLETED
        if ____cond70 then
            if type(jass.QuestSetCompleted) == "function" then
                jass.QuestSetCompleted(nativeQuest, true)
            end
            break
        end
        ____cond70 = ____cond70 or ____switch70 == QuestStatus.FAILED
        if ____cond70 then
            if type(jass.QuestSetFailed) == "function" then
                jass.QuestSetFailed(nativeQuest, true)
            end
            break
        end
    until true
    debugPrint(nil, ("已同步任务 " .. questId) .. " 到War3原生任务系统")
end
function QuestManager.prototype.giveQuestRewards(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    local hero = self:getPlayerHero(playerId)
    for ____, reward in ipairs(quest.rewards) do
        repeat
            local ____switch78 = reward.type
            local ____cond78 = ____switch78 == "experience"
            if ____cond78 then
                if hero and type(jass.AddHeroXP) == "function" then
                    jass.AddHeroXP(hero, reward.value, true)
                    debugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 经验"
                    )
                else
                    debugPrint(nil, "无法给予经验：未找到英雄或API不可用")
                end
                break
            end
            ____cond78 = ____cond78 or ____switch78 == "gold"
            if ____cond78 then
                if type(jass.SetPlayerState) == "function" and type(jass.GetPlayerState) == "function" then
                    local currentGold = jass.GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD) or 0
                    jass.SetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD, currentGold + reward.value)
                    debugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 金币"
                    )
                end
                break
            end
            ____cond78 = ____cond78 or ____switch78 == "item"
            if ____cond78 then
                if hero and type(jass.CreateItem) == "function" and type(jass.UnitAddItemById) == "function" and reward.itemId then
                    local itemTypeId = jass.FourCC(reward.itemId)
                    jass.UnitAddItemById(hero, itemTypeId)
                    debugPrint(
                        nil,
                        (("给予玩家 " .. tostring(playerId)) .. " 物品 ") .. reward.description
                    )
                else
                    debugPrint(nil, "无法给予物品：未找到英雄或API不可用")
                end
                break
            end
            ____cond78 = ____cond78 or ____switch78 == "attribute"
            if ____cond78 then
                if hero and type(jass.SetHeroStr) == "function" and type(jass.SetHeroAgi) == "function" and type(jass.SetHeroInt) == "function" then
                    jass.SetHeroStr(
                        hero,
                        jass.GetHeroStr(hero, false) + reward.value,
                        true
                    )
                    jass.SetHeroAgi(
                        hero,
                        jass.GetHeroAgi(hero, false) + reward.value,
                        true
                    )
                    jass.SetHeroInt(
                        hero,
                        jass.GetHeroInt(hero, false) + reward.value,
                        true
                    )
                    debugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 全属性"
                    )
                end
                break
            end
            do
                debugPrint(nil, "未知奖励类型: " .. reward.type)
            end
        until true
    end
end
function QuestManager.prototype.showQuestAcceptedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        local message = (("已接受任务: " .. quest.title) .. "\n") .. quest.description
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            10,
            message
        )
    end
end
function QuestManager.prototype.showQuestCompletedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    if type(jass.DisplayTimedTextToPlayer) == "function" then
        local message = ("任务完成: " .. quest.title) .. "\n已获得奖励！"
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            10,
            message
        )
    end
end
function QuestManager.prototype.resetPlayerQuests(self, playerId)
    questDB:resetPlayerData(playerId)
    debugPrint(
        nil,
        ("已重置玩家 " .. tostring(playerId)) .. " 的任务数据"
    )
end
function QuestManager.prototype.getStatus(self)
    local allQuests = questDB:getAllQuests()
    return {initialized = self.isInitialized, questCount = #allQuests}
end
____exports.questManager = ____exports.QuestManager:getInstance()
--- 处理任务接受事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串（或数字转换为字符串）
function ____exports.handleQuestAccepted(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        debugPrint(nil, "任务接受事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    ____exports.questManager:onQuestAccepted(playerId, questId)
end
--- 处理任务完成事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
function ____exports.handleQuestCompleted(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        debugPrint(nil, "任务完成事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    ____exports.questManager:onQuestCompleted(playerId, questId)
end
--- 处理任务目标更新事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
-- - udg_ObjectiveId: 目标ID字符串
-- - udg_Progress: 进度值
function ____exports.handleObjectiveUpdated(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    local objectiveId = g.udg_ObjectiveId
    local progress = g.udg_Progress
    if playerId == nil or questId == nil or objectiveId == nil or progress == nil then
        debugPrint(nil, "任务目标更新事件缺少参数")
        return
    end
    ____exports.questManager:updateQuestObjective(playerId, questId, objectiveId, progress)
end
--- 处理任务失败事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
function ____exports.handleQuestFailed(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        debugPrint(nil, "任务失败事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    ____exports.questManager:onQuestFailed(playerId, questId)
end
--- 处理任务放弃事件
-- JASS端应该在触发事件前设置全局变量：
-- - udg_QuestPlayerId: 玩家ID
-- - udg_QuestId: 任务ID字符串
function ____exports.handleQuestAbandoned(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        debugPrint(nil, "任务放弃事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    ____exports.questManager:onQuestAbandoned(playerId, questId)
end
function ____exports.init(self)
    ____exports.questManager:initialize()
end
return ____exports
