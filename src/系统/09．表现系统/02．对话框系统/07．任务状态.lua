local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____00_FF0EYDWE_51FD_6570 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local getObjectProperty = ____00_FF0EYDWE_51FD_6570.getObjectProperty
local ObjectType = ____00_FF0EYDWE_51FD_6570.ObjectType
local ____03_FF0ENPC_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.03．NPC配置表")
local NPC_CONFIGS = ____03_FF0ENPC_914D_7F6E_8868.NPC_CONFIGS
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local QUEST_CONFIGS = ____02_FF0E_4EFB_52A1_914D_7F6E_8868.QUEST_CONFIGS
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local ____14_FF0E_4EFB_52A1_5C55_793A_6587_6848 = require("系统.09．表现系统.02．对话框系统.14．任务展示文案")
local resolveRewardDisplayText = ____14_FF0E_4EFB_52A1_5C55_793A_6587_6848.resolveRewardDisplayText
local function normalizeRequireCount(self, count)
    return count ~= nil and count > 1 and count or 1
end
function ____exports.ensureQuestConfigsRegistered(self)
    local g = _G
    if g.__questConfigsRegistered then
        return
    end
    g.__questConfigsRegistered = true
    for ____, cfg in ipairs(QUEST_CONFIGS) do
        do
            local __continue5
            repeat
                if cfg.enabled ~= true then
                    __continue5 = true
                    break
                end
                if not cfg.requireID then
                    __continue5 = true
                    break
                end
                local questId = tostring(cfg.requireID)
                if questDB:getQuest(questId) then
                    __continue5 = true
                    break
                end
                local iconPath = ""
                if cfg.startNpc then
                    local npcCfg = __TS__ArrayFind(
                        NPC_CONFIGS,
                        function(____, n) return n.NPCrequireName == cfg.startNpc or n.NpcNameID == cfg.startNpc end
                    )
                    if npcCfg and npcCfg.unitcode then
                        iconPath = getObjectProperty(nil, ObjectType.UNIT, npcCfg.unitcode, "Art")
                    end
                end
                questDB:registerQuest({
                    id = questId,
                    type = QuestType.DAILY,
                    title = cfg.name or questId,
                    description = cfg.desc or cfg.name or "",
                    objectives = (cfg.requireItem or cfg.targetUnit) and ({{
                        id = "obj1",
                        description = cfg.desc or cfg.name or "",
                        current = 0,
                        required = normalizeRequireCount(nil, cfg.requireCount),
                        completed = false
                    }}) or ({}),
                    rewards = {{
                        type = "gold",
                        value = 0,
                        description = resolveRewardDisplayText(nil, cfg)
                    }},
                    status = QuestStatus.UNDISCOVERED,
                    startNpc = cfg.startNpc,
                    icon = iconPath or nil,
                    createdAt = 0,
                    updatedAt = 0
                })
                __continue5 = true
            until true
            if not __continue5 then
                break
            end
        end
    end
end
function ____exports.getQuestState(self, questId)
    local status = questDB:getPlayerQuestStatus(0, questId)
    if status == QuestStatus.COMPLETED then
        return 2
    end
    if status == QuestStatus.IN_PROGRESS then
        return 1
    end
    return 0
end
function ____exports.setQuestState(self, questId, state, playerName)
    if state == 1 then
        questDB:acceptQuest(0, questId)
        if playerName then
            local def = questDB:getQuest(questId)
            if def then
                def.accepterName = playerName
            end
            local ____opt_0 = questDB.globalData
            if ____opt_0 ~= nil then
                ____opt_0 = ____opt_0.quests:get(questId)
            end
            local active = ____opt_0
            if active then
                active.accepterName = playerName
            end
        end
        return
    end
    if state == 2 then
        local ____opt_2 = questDB.globalData
        if ____opt_2 ~= nil then
            ____opt_2 = ____opt_2.quests:get(questId)
        end
        local active = ____opt_2
        if active then
            for ____, obj in __TS__Iterator(active.objectives) do
                obj.current = obj.required
                obj.completed = true
            end
            active.updatedAt = 0
            if playerName then
                active.completerName = playerName
            end
        end
        local ____opt_result_6
        if active ~= nil then
            ____opt_result_6 = active.accepterName
        end
        local savedAccepterName = ____opt_result_6
        questDB:completeQuest(0, questId)
        if playerName then
            local def = questDB:getQuest(questId)
            if def then
                def.completerName = playerName
                if savedAccepterName then
                    def.accepterName = savedAccepterName
                end
            end
        end
    end
end
function ____exports.hasPlayerAcceptedQuest(self, _playerId, questId)
    return ____exports.getQuestState(nil, questId) == 1
end
function ____exports.hasPlayerCompletedQuest(self, _playerId, questId)
    return ____exports.getQuestState(nil, questId) == 2
end
return ____exports
