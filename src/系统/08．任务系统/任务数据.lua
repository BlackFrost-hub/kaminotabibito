local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__ArrayFrom = ____lualib.__TS__ArrayFrom
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local Set = ____lualib.Set
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayEvery = ____lualib.__TS__ArrayEvery
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
--- 获取当前时间戳（War3 Lua 环境下替代 Date.now）
local function now(self)
    return os.time()
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
    self.quests = __TS__New(Map)
    self.playerData = __TS__New(Map)
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
    self.quests:set(quest.id, quest)
end
function QuestDatabase.prototype.getQuest(self, id)
    return self.quests:get(id)
end
function QuestDatabase.prototype.getAllQuests(self)
    return __TS__ArrayFrom(self.quests:values())
end
function QuestDatabase.prototype.getQuestsByType(self, ____type)
    return __TS__ArrayFilter(
        __TS__ArrayFrom(self.quests:values()),
        function(____, quest) return quest.type == ____type end
    )
end
function QuestDatabase.prototype.getAvailableQuests(self, playerId, ____type)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return {}
    end
    local source = ____type and self:getQuestsByType(____type) or self:getAllQuests()
    return __TS__ArrayFilter(
        source,
        function(____, quest)
            if playerData.quests:has(quest.id) or playerData.completedQuests:has(quest.id) or playerData.failedQuests:has(quest.id) then
                return false
            end
            if quest.requiredQuests and #quest.requiredQuests > 0 then
                for ____, rid in ipairs(quest.requiredQuests) do
                    if not playerData.completedQuests:has(rid) then
                        return false
                    end
                end
            end
            return true
        end
    )
end
function QuestDatabase.prototype.initPlayerData(self, playerId)
    if not self.playerData:has(playerId) then
        self.playerData:set(
            playerId,
            {
                playerId = playerId,
                quests = __TS__New(Map),
                completedQuests = __TS__New(Set),
                failedQuests = __TS__New(Set)
            }
        )
    end
end
function QuestDatabase.prototype.getPlayerData(self, playerId)
    return self.playerData:get(playerId)
end
function QuestDatabase.prototype.acceptQuest(self, playerId, questId)
    local quest = self:getQuest(questId)
    if not quest then
        return false
    end
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    if playerData.quests:has(questId) or playerData.completedQuests:has(questId) or playerData.failedQuests:has(questId) then
        return false
    end
    if quest.requiredQuests and #quest.requiredQuests > 0 then
        for ____, requiredId in ipairs(quest.requiredQuests) do
            if not playerData.completedQuests:has(requiredId) then
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
    playerData.quests:set(questId, acceptedQuest)
    return true
end
function QuestDatabase.prototype.completeQuest(self, playerId, questId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    local quest = playerData.quests:get(questId)
    if not quest then
        return false
    end
    local allObjectivesCompleted = __TS__ArrayEvery(
        quest.objectives,
        function(____, obj) return obj.completed end
    )
    if not allObjectivesCompleted then
        return false
    end
    quest.status = ____exports.QuestStatus.COMPLETED
    quest.updatedAt = now(nil)
    playerData.quests:delete(questId)
    playerData.completedQuests:add(questId)
    return true
end
function QuestDatabase.prototype.abandonQuest(self, playerId, questId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    local quest = playerData.quests:get(questId)
    if not quest then
        return false
    end
    if quest.status ~= ____exports.QuestStatus.IN_PROGRESS then
        return false
    end
    quest.status = ____exports.QuestStatus.UNDISCOVERED
    playerData.quests:delete(questId)
    return true
end
function QuestDatabase.prototype.failQuest(self, playerId, questId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    local quest = playerData.quests:get(questId)
    if not quest then
        return false
    end
    if quest.status ~= ____exports.QuestStatus.IN_PROGRESS then
        return false
    end
    quest.status = ____exports.QuestStatus.FAILED
    quest.updatedAt = now(nil)
    playerData.quests:delete(questId)
    playerData.failedQuests:add(questId)
    return true
end
function QuestDatabase.prototype.updateObjective(self, playerId, questId, objectiveId, progress)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return false
    end
    local quest = playerData.quests:get(questId)
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
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return {}
    end
    return __TS__ArrayFilter(
        __TS__ArrayFrom(playerData.quests:values()),
        function(____, quest) return quest.status == ____exports.QuestStatus.IN_PROGRESS end
    )
end
function QuestDatabase.prototype.getPlayerCompletedQuests(self, playerId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return {}
    end
    return __TS__ArrayFrom(playerData.completedQuests)
end
function QuestDatabase.prototype.getPlayerQuestStatus(self, playerId, questId)
    local playerData = self:getPlayerData(playerId)
    if not playerData then
        return nil
    end
    local quest = playerData.quests:get(questId)
    if quest then
        return quest.status
    end
    if playerData.completedQuests:has(questId) then
        return ____exports.QuestStatus.COMPLETED
    end
    if playerData.failedQuests:has(questId) then
        return ____exports.QuestStatus.FAILED
    end
    return ____exports.QuestStatus.UNDISCOVERED
end
function QuestDatabase.prototype.resetPlayerData(self, playerId)
    self.playerData:delete(playerId)
    self:initPlayerData(playerId)
end
function QuestDatabase.prototype.clearAll(self)
    self.quests:clear()
    self.playerData:clear()
end
____exports.questDB = ____exports.QuestDatabase:getInstance()
function ____exports.createTestQuests(self)
    local db = ____exports.QuestDatabase:getInstance()
    do
        local i = 1
        while i <= 99 do
            local id = "main_" .. (i < 10 and "00" .. tostring(i) or (i < 100 and "0" .. tostring(i) or "" .. tostring(i)))
            local title = "主线任务" .. (i < 10 and "00" .. tostring(i) or (i < 100 and "0" .. tostring(i) or "" .. tostring(i)))
            db:registerQuest({
                id = id,
                type = ____exports.QuestType.MAIN,
                title = title,
                description = "完成基础训练，了解游戏操作",
                objectives = {{
                    id = "obj1",
                    description = "击败训练假人",
                    current = 0,
                    required = 5,
                    completed = false
                }, {
                    id = "obj2",
                    description = "学习技能",
                    current = 0,
                    required = 1,
                    completed = false
                }},
                rewards = {{type = "experience", value = 100, description = "100经验"}, {type = "gold", value = 50, description = "50金币"}},
                status = ____exports.QuestStatus.UNDISCOVERED,
                requiredLevel = 1,
                zone = "新手村",
                icon = i == 2 and "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp" or "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp",
                createdAt = now(nil),
                updatedAt = now(nil)
            })
            i = i + 1
        end
    end
    db:registerQuest({
        id = "side_002",
        type = ____exports.QuestType.SIDE,
        title = "击杀步兵",
        description = "击杀1个步兵，任务奖励：200金币",
        objectives = {{
            id = "obj1",
            description = "击杀1个步兵",
            current = 0,
            required = 1,
            completed = false
        }},
        rewards = {{type = "gold", value = 200, description = "200金币"}},
        status = ____exports.QuestStatus.UNDISCOVERED,
        requiredLevel = 1,
        zone = "战场",
        icon = "ReplaceableTextures\\CommandButtons\\BTNFootman.blp",
        createdAt = now(nil),
        updatedAt = now(nil)
    })
    db:registerQuest({
        id = "side_001",
        type = ____exports.QuestType.SIDE,
        title = "收集材料",
        description = "为铁匠收集10个铁矿",
        objectives = {{
            id = "obj1",
            description = "收集铁矿",
            current = 0,
            required = 10,
            completed = false
        }},
        rewards = {{type = "item", value = 0, itemId = "item_iron_sword", description = "铁剑"}, {type = "gold", value = 30, description = "30金币"}},
        status = ____exports.QuestStatus.UNDISCOVERED,
        requiredLevel = 3,
        requiredQuests = {"main_001"},
        zone = "矿山",
        icon = "ReplaceableTextures\\CommandButtons\\BTNIronForge.blp",
        createdAt = now(nil),
        updatedAt = now(nil)
    })
    db:registerQuest({
        id = "daily_001",
        type = ____exports.QuestType.DAILY,
        title = "日常巡逻",
        description = "巡逻村庄周边，确保安全",
        objectives = {{
            id = "obj1",
            description = "巡逻指定区域",
            current = 0,
            required = 3,
            completed = false
        }},
        rewards = {{type = "experience", value = 50, description = "50经验"}, {type = "gold", value = 20, description = "20金币"}},
        status = ____exports.QuestStatus.UNDISCOVERED,
        requiredLevel = 2,
        zone = "村庄",
        icon = "ReplaceableTextures\\CommandButtons\\BTNPeon.blp",
        timeLimit = 3600,
        createdAt = now(nil),
        updatedAt = now(nil)
    })
end
return ____exports
