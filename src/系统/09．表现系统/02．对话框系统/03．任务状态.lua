local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____00_FF0EYDWE_51FD_6570 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local getObjectProperty = ____00_FF0EYDWE_51FD_6570.getObjectProperty
local ObjectType = ____00_FF0EYDWE_51FD_6570.ObjectType
local ____01_FF0E_5BF9_8BDD_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.01．对话配置表")
local DIALOG_NPC_CONFIGS = ____01_FF0E_5BF9_8BDD_914D_7F6E_8868.DIALOG_NPC_CONFIGS
local ____03_FF0ENPC_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.03．NPC配置表")
local NPC_CONFIGS = ____03_FF0ENPC_914D_7F6E_8868.NPC_CONFIGS
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local QUEST_CONFIGS = ____02_FF0E_4EFB_52A1_914D_7F6E_8868.QUEST_CONFIGS
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local ____01_FF0EFourCC_8F6C_6362 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local fourCCToString = ____01_FF0EFourCC_8F6C_6362.fourCCToString
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
function ____exports.resolveRewardDisplayText(self, quest)
    if not quest then
        return "无"
    end
    if quest.rewardDisplay and quest.rewardDisplay ~= "" then
        return quest.rewardDisplay
    end
    local ____type = quest.type or ""
    local reward = quest.reward or ""
    if ____type == "给予" and (string.find(reward, ":", nil, true) or 0) - 1 >= 0 then
        return "给予未知奖励"
    end
    return reward ~= "" and reward or "无"
end
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
            if cfg.enabled ~= true then
                goto __continue9
            end
            if not cfg.requireID then
                goto __continue9
            end
            local questId = tostring(cfg.requireID)
            if questDB:getQuest(questId) then
                goto __continue9
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
                    description = ____exports.resolveRewardDisplayText(nil, cfg)
                }},
                status = QuestStatus.UNDISCOVERED,
                startNpc = cfg.startNpc,
                icon = iconPath or nil,
                createdAt = 0,
                updatedAt = 0
            })
        end
        ::__continue9::
    end
end
function ____exports.getQuestState(self, playerId, questId)
    local status = questDB:getPlayerQuestStatus(playerId, questId)
    if status == QuestStatus.COMPLETED then
        return 2
    end
    if status == QuestStatus.IN_PROGRESS then
        return 1
    end
    return 0
end
function ____exports.setQuestState(self, playerId, questId, state, playerName)
    if state == 1 then
        questDB:acceptQuest(playerId, questId)
        if playerName then
            local def = questDB:getQuest(questId)
            if def then
                def.accepterName = playerName
            end
            local globalData = questDB.globalData
            local ____temp_0
            if globalData ~= nil then
                ____temp_0 = globalData.quests:get(questId)
            else
                ____temp_0 = nil
            end
            local active = ____temp_0
            if active then
                active.accepterName = playerName
            end
        end
        return
    end
    if state == 2 then
        local globalData = questDB.globalData
        local ____temp_1
        if globalData ~= nil then
            ____temp_1 = globalData.quests:get(questId)
        else
            ____temp_1 = nil
        end
        local active = ____temp_1
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
        local ____temp_2
        if active ~= nil then
            ____temp_2 = active.accepterName
        else
            ____temp_2 = nil
        end
        local savedAccepterName = ____temp_2
        questDB:completeQuest(playerId, questId)
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
function ____exports.hasPlayerAcceptedQuest(self, playerId, questId)
    return ____exports.getQuestState(nil, playerId, questId) == 1
end
function ____exports.hasPlayerCompletedQuest(self, playerId, questId)
    return ____exports.getQuestState(nil, playerId, questId) == 2
end
function ____exports.findQuestByNpc(self, npcName)
    return __TS__ArrayFind(
        QUEST_CONFIGS,
        function(____, quest) return quest.enabled == true and quest.startNpc == npcName and quest.requireID end
    )
end
function ____exports.resolveQuestEndNpc(self, quest)
    local endNpc = quest.endNpc
    if not endNpc or endNpc == "没有" then
        return quest.startNpc or ""
    end
    return endNpc
end
function ____exports.findAcceptedQuestBySubmitNpc(self, npcName, playerId)
    return __TS__ArrayFind(
        QUEST_CONFIGS,
        function(____, quest)
            if quest.enabled ~= true then
                return false
            end
            if not quest.requireID then
                return false
            end
            local questId = tostring(quest.requireID)
            if not ____exports.hasPlayerAcceptedQuest(nil, playerId, questId) then
                return false
            end
            return ____exports.resolveQuestEndNpc(nil, quest) == npcName
        end
    )
end
function ____exports.findDialogConfig(self, npcName)
    return __TS__ArrayFind(
        DIALOG_NPC_CONFIGS,
        function(____, config) return config.NPC == npcName end
    )
end
function ____exports.findEnabledNpcConfigBySelectedUnit(self, unit, unitName)
    if not unit or not unitName then
        return nil
    end
    local selectedUnitCode = fourCCToString(GetUnitTypeId(unit))
    for ____, npc in ipairs(NPC_CONFIGS) do
        do
            if npc.enabled ~= true then
                goto __continue48
            end
            if npc.unitcode and npc.unitcode ~= selectedUnitCode then
                goto __continue48
            end
            if npc.NPCrequireName == unitName or npc.NpcNameID == unitName then
                return npc
            end
        end
        ::__continue48::
    end
    return nil
end
return ____exports
