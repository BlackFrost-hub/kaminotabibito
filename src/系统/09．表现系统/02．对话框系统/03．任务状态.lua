local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____00_FF0EYDWE_51FD_6570 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local getObjectProperty = ____00_FF0EYDWE_51FD_6570.getObjectProperty
local ObjectType = ____00_FF0EYDWE_51FD_6570.ObjectType
local ____01_FF0E_5BF9_8BDD_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.01．对话配置表")
local _____5BF9_8BDDNPC_914D_7F6E_5217_8868 = ____01_FF0E_5BF9_8BDD_914D_7F6E_8868["对话NPC配置列表"]
local ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868 = require("系统.11．剧情系统.02．支线任务.01．支线NPC配置表")
local _____652F_7EBFNPC_914D_7F6E_5217_8868 = ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868["支线NPC配置列表"]
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local _____4EFB_52A1_914D_7F6E_5217_8868 = ____02_FF0E_4EFB_52A1_914D_7F6E_8868["任务配置列表"]
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
    if quest["奖励显示"] and quest["奖励显示"] ~= "" then
        return quest["奖励显示"]
    end
    local ____type = quest["类型"] or ""
    local reward = quest["奖励"] or ""
    if ____type == "给予" and (string.find(reward, ":", nil, true) or 0) - 1 >= 0 then
        return "给予未知奖励"
    end
    return reward ~= "" and reward or "无"
end
local function normalizeRequireCount(self, count)
    return count ~= nil and count > 1 and count or 1
end
____exports["确保任务配置已注册"] = function(self)
    local g = _G
    if g.__questConfigsRegistered then
        return
    end
    g.__questConfigsRegistered = true
    for ____, cfg in ipairs(_____4EFB_52A1_914D_7F6E_5217_8868) do
        do
            if cfg["启用"] ~= true then
                goto __continue9
            end
            if not cfg["任务ID"] then
                goto __continue9
            end
            local questId = tostring(cfg["任务ID"])
            if questDB:getQuest(questId) then
                goto __continue9
            end
            local iconPath = ""
            if cfg["开始NPC"] then
                local npcCfg = __TS__ArrayFind(
                    _____652F_7EBFNPC_914D_7F6E_5217_8868,
                    function(____, n) return n["NPC名称"] == cfg["开始NPC"] or n["NPC配置名"] == cfg["开始NPC"] end
                )
                if npcCfg and npcCfg["单位ID"] then
                    iconPath = getObjectProperty(nil, ObjectType.UNIT, npcCfg["单位ID"], "Art")
                end
            end
            questDB:registerQuest({
                id = questId,
                type = QuestType.DAILY,
                title = cfg["名称"] or questId,
                description = cfg["描述"] or cfg["名称"] or "",
                objectives = (cfg["需求物品"] or cfg["目标单位"]) and ({{
                    id = "obj1",
                    description = cfg["描述"] or cfg["名称"] or "",
                    current = 0,
                    required = normalizeRequireCount(nil, cfg["需求数量"]),
                    completed = false
                }}) or ({}),
                rewards = {{
                    type = "gold",
                    value = 0,
                    description = ____exports.resolveRewardDisplayText(nil, cfg)
                }},
                status = QuestStatus.UNDISCOVERED,
                startNpc = cfg["开始NPC"],
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
        _____4EFB_52A1_914D_7F6E_5217_8868,
        function(____, quest) return quest["启用"] == true and quest["开始NPC"] == npcName and quest["任务ID"] end
    )
end
function ____exports.resolveQuestEndNpc(self, quest)
    local endNpc = quest["结束NPC"]
    if not endNpc or endNpc == "没有" then
        return quest["开始NPC"] or ""
    end
    return endNpc
end
function ____exports.findAcceptedQuestBySubmitNpc(self, npcName, playerId)
    return __TS__ArrayFind(
        _____4EFB_52A1_914D_7F6E_5217_8868,
        function(____, quest)
            if quest["启用"] ~= true then
                return false
            end
            if not quest["任务ID"] then
                return false
            end
            local questId = tostring(quest["任务ID"])
            if not ____exports.hasPlayerAcceptedQuest(nil, playerId, questId) then
                return false
            end
            return ____exports.resolveQuestEndNpc(nil, quest) == npcName
        end
    )
end
function ____exports.findDialogConfig(self, npcName)
    return __TS__ArrayFind(
        _____5BF9_8BDDNPC_914D_7F6E_5217_8868,
        function(____, config) return config["NPC名称"] == npcName end
    )
end
function ____exports.findEnabledNpcConfigBySelectedUnit(self, unit, unitName)
    if not unit or not unitName then
        return nil
    end
    local selectedUnitCode = fourCCToString(GetUnitTypeId(unit))
    for ____, npc in ipairs(_____652F_7EBFNPC_914D_7F6E_5217_8868) do
        do
            if npc["启用"] ~= true then
                goto __continue48
            end
            if npc["单位ID"] and npc["单位ID"] ~= selectedUnitCode then
                goto __continue48
            end
            if npc["NPC名称"] == unitName or npc["NPC配置名"] == unitName then
                return npc
            end
        end
        ::__continue48::
    end
    return nil
end
return ____exports
