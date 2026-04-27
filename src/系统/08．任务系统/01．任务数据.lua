local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local Set = ____lualib.Set
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
--- 获取当前时间戳（War3 Lua 环境下替代 Date.now）
local function now(self)
    return os:time()
end
____exports.QuestType = QuestType or ({})
____exports.QuestType.MAIN = "主线"
____exports.QuestType.SIDE = "支线"
____exports.QuestType.DAILY = "小任务"
--- 任务状态枚举（与War3原生状态对应）
-- 参考：bj_QUESTTYPE_REQ_DISCOVERED, bj_QUESTTYPE_REQ_UNDISCOVERED
____exports.QuestStatus = QuestStatus or ({})
____exports.QuestStatus.UNDISCOVERED = "未发现"
____exports.QuestStatus.DISCOVERED = "已发现"
____exports.QuestStatus.IN_PROGRESS = "进行中"
____exports.QuestStatus.COMPLETED = "已完成"
____exports.QuestStatus.FAILED = "已失败"
--- 任务数据库类
____exports.QuestDatabase = __TS__Class()
local QuestDatabase = ____exports.QuestDatabase
QuestDatabase.name = "QuestDatabase"
function QuestDatabase.prototype.____constructor(self)
    self.questDefinitions = __TS__New(Map)
    self.globalData = {
        quests = __TS__New(Map),
        completedQuests = __TS__New(Set),
        failedQuests = __TS__New(Set)
    }
end
function QuestDatabase.getInstance(self)
    if not ____exports.QuestDatabase.instance then
        ____exports.QuestDatabase.instance = __TS__New(____exports.QuestDatabase)
    end
    return ____exports.QuestDatabase.instance
end
function QuestDatabase.prototype.registerQuest(self, quest)
    quest.createdAt = quest.createdAt or now(nil)
    quest.updatedAt = quest.updatedAt or now(nil)
    self.questDefinitions:set(quest.id, quest)
end
function QuestDatabase.prototype.getQuest(self, id)
    return self.questDefinitions:get(id)
end
function QuestDatabase.prototype.getAllQuests(self)
    return __TS__ArrayFrom(self.questDefinitions:values())
end
function QuestDatabase.prototype.getQuestsByType(self, ____type)
    return __TS__ArrayFilter(
        __TS__ArrayFrom(self.questDefinitions:values()),
        function(____, quest) return quest.type == ____type end
    )
end
function QuestDatabase.prototype.getAvailableQuests(self, playerId, ____type)
    local source = ____type and self:getQuestsByType(____type) or self:getAllQuests()
    return __TS__ArrayFilter(
        source,
        function(____, quest)
            if quest.uiReserved then
                return false
            end
            if self.globalData.quests:has(quest.id) or self.globalData.completedQuests:has(quest.id) or self.globalData.failedQuests:has(quest.id) then
                return false
            end
            if quest.requiredQuests and #quest.requiredQuests > 0 then
                for ____, rid in ipairs(quest.requiredQuests) do
                    if not self.globalData.completedQuests:has(rid) then
                        return false
                    end
                end
            end
            return true
        end
    )
end
function QuestDatabase.prototype.initPlayerData(self, playerId)
end
function QuestDatabase.prototype.acceptQuest(self, playerId, questId)
    local quest = self:getQuest(questId)
    if not quest or quest.uiReserved then
        return false
    end
    if self.globalData.quests:has(questId) or self.globalData.completedQuests:has(questId) or self.globalData.failedQuests:has(questId) then
        return false
    end
    if quest.requiredQuests and #quest.requiredQuests > 0 then
        for ____, requiredId in ipairs(quest.requiredQuests) do
            if not self.globalData.completedQuests:has(requiredId) then
                return false
            end
        end
    end
    local acceptedQuest = __TS__ObjectAssign(
        {},
        quest,
        {
            status = ____exports.QuestStatus.IN_PROGRESS,
            createdAt = now(nil),
            updatedAt = now(nil),
            startTime = now(nil)
        }
    )
    self.globalData.quests:set(questId, acceptedQuest)
    return true
end
function QuestDatabase.prototype.completeQuest(self, playerId, questId)
    local quest = self.globalData.quests:get(questId)
    if not quest then
        return false
    end
    local allObjectivesCompleted = true
    do
        local i = 0
        while i < #quest.objectives do
            if not quest.objectives[i + 1].completed then
                allObjectivesCompleted = false
                break
            end
            i = i + 1
        end
    end
    if not allObjectivesCompleted then
        return false
    end
    quest.status = ____exports.QuestStatus.COMPLETED
    quest.updatedAt = now(nil)
    self.globalData.quests:delete(questId)
    self.globalData.completedQuests:add(questId)
    return true
end
function QuestDatabase.prototype.abandonQuest(self, playerId, questId)
    local quest = self.globalData.quests:get(questId)
    if not quest then
        return false
    end
    if quest.status ~= ____exports.QuestStatus.IN_PROGRESS then
        return false
    end
    quest.status = ____exports.QuestStatus.UNDISCOVERED
    self.globalData.quests:delete(questId)
    return true
end
function QuestDatabase.prototype.failQuest(self, playerId, questId)
    local quest = self.globalData.quests:get(questId)
    if not quest then
        return false
    end
    if quest.status ~= ____exports.QuestStatus.IN_PROGRESS then
        return false
    end
    quest.status = ____exports.QuestStatus.FAILED
    quest.updatedAt = now(nil)
    self.globalData.quests:delete(questId)
    self.globalData.failedQuests:add(questId)
    return true
end
function QuestDatabase.prototype.updateObjective(self, playerId, questId, objectiveId, progress)
    local quest = self.globalData.quests:get(questId)
    if not quest then
        return false
    end
    local objective = __TS__ArrayFind(
        quest.objectives,
        function(____, obj) return obj.id == objectiveId end
    )
    if not objective then
        return false
    end
    objective.current = math.min(progress, objective.required)
    objective.completed = objective.current >= objective.required
    quest.updatedAt = now(nil)
    return true
end
function QuestDatabase.prototype.getPlayerActiveQuests(self, playerId)
    return __TS__ArrayFilter(
        __TS__ArrayFrom(self.globalData.quests:values()),
        function(____, quest) return quest.status == ____exports.QuestStatus.IN_PROGRESS end
    )
end
function QuestDatabase.prototype.getPlayerCompletedQuests(self, playerId)
    return __TS__ArrayFrom(self.globalData.completedQuests)
end
function QuestDatabase.prototype.getPlayerQuestStatus(self, playerId, questId)
    local quest = self.globalData.quests:get(questId)
    if quest then
        return quest.status
    end
    if self.globalData.completedQuests:has(questId) then
        return ____exports.QuestStatus.COMPLETED
    end
    if self.globalData.failedQuests:has(questId) then
        return ____exports.QuestStatus.FAILED
    end
    return ____exports.QuestStatus.UNDISCOVERED
end
function QuestDatabase.prototype.resetPlayerData(self, playerId)
    self.globalData.quests:clear()
    self.globalData.completedQuests:clear()
    self.globalData.failedQuests:clear()
end
function QuestDatabase.prototype.clearAll(self)
    self.questDefinitions:clear()
    self.globalData.quests:clear()
    self.globalData.completedQuests:clear()
    self.globalData.failedQuests:clear()
end
____exports.questDB = ____exports.QuestDatabase:getInstance()
return ____exports
