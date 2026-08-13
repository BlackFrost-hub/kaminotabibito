local ____lualib = require("lualib_bundle")
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____01_FF0E_5BF9_8BDD_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.01．对话配置表")
local _____5BF9_8BDDNPC_914D_7F6E_5217_8868 = ____01_FF0E_5BF9_8BDD_914D_7F6E_8868["对话NPC配置列表"]
local ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868 = require("系统.11．剧情系统.02．支线任务.01．支线NPC配置表")
local _____652F_7EBFNPC_914D_7F6E_5217_8868 = ____01_FF0E_652F_7EBFNPC_914D_7F6E_8868["支线NPC配置列表"]
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local _____4EFB_52A1_914D_7F6E_5217_8868 = ____02_FF0E_4EFB_52A1_914D_7F6E_8868["任务配置列表"]
local ____05_FF0E_4EFB_52A1_914D_7F6E_6CE8_518C = require("系统.08．任务系统.00．配置表.05．任务配置注册")
local _____6CE8_518C_5355_4E2A_4EFB_52A1_914D_7F6E_5230_4EFB_52A1_5E93 = ____05_FF0E_4EFB_52A1_914D_7F6E_6CE8_518C["注册单个任务配置到任务库"]
local resolveRewardDisplayText = ____05_FF0E_4EFB_52A1_914D_7F6E_6CE8_518C.resolveRewardDisplayText
local ____04_FF0ENPC_751F_6210_5668 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
local _____6309_5355_4F4D_67E5_627ENPC_914D_7F6E = ____04_FF0ENPC_751F_6210_5668["按单位查找NPC配置"]
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.questManager
local ____01_FF0EFourCC_8F6C_6362 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local fourCCToString = ____01_FF0EFourCC_8F6C_6362.fourCCToString
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
____exports.resolveRewardDisplayText = resolveRewardDisplayText
____exports["确保任务配置已注册"] = function(self)
    local g = _G
    if g.__questConfigsRegistered then
        return
    end
    g.__questConfigsRegistered = true
    for ____, cfg in ipairs(_____4EFB_52A1_914D_7F6E_5217_8868) do
        do
            if cfg["启用"] ~= true then
                goto __continue4
            end
            if not cfg["任务ID"] then
                goto __continue4
            end
            local npcCfg = nil
            if cfg["开始NPC"] then
                for ____, _____914D_7F6E in ipairs(_____652F_7EBFNPC_914D_7F6E_5217_8868) do
                    if _____914D_7F6E["NPC名称"] == cfg["开始NPC"] or _____914D_7F6E["NPC配置名"] == cfg["开始NPC"] then
                        npcCfg = _____914D_7F6E
                        break
                    end
                end
            end
            _____6CE8_518C_5355_4E2A_4EFB_52A1_914D_7F6E_5230_4EFB_52A1_5E93(cfg, npcCfg)
        end
        ::__continue4::
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
        questManager:onQuestAccepted(playerId, questId)
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
        questManager:onQuestCompleted(playerId, questId)
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
____exports["读取任务目标进度"] = function(playerId, questId)
    local globalData = questDB.globalData
    local ____temp_3
    if globalData ~= nil then
        ____temp_3 = globalData.quests:get(questId)
    else
        ____temp_3 = nil
    end
    local activeQuest = ____temp_3
    if activeQuest == nil or activeQuest.objectives == nil or activeQuest.objectives.length == 0 then
        return nil
    end
    local objective = activeQuest.objectives[0]
    if objective == nil then
        return nil
    end
    return {["当前"] = objective.current, ["需求"] = objective.required}
end
____exports["任务目标是否完成"] = function(playerId, questId)
    local _____8FDB_5EA6 = ____exports["读取任务目标进度"](playerId, questId)
    return _____8FDB_5EA6 ~= nil and _____8FDB_5EA6["当前"] >= _____8FDB_5EA6["需求"]
end
function ____exports.findQuestByNpc(self, npcName)
    return __TS__ArrayFind(
        _____4EFB_52A1_914D_7F6E_5217_8868,
        function(____, quest) return quest["启用"] == true and quest["开始NPC"] == npcName and quest["任务ID"] end
    )
end
function ____exports.findQuestById(self, _____4EFB_52A1ID)
    for ____, _____4EFB_52A1 in ipairs(_____4EFB_52A1_914D_7F6E_5217_8868) do
        if _____4EFB_52A1["启用"] == true and _____4EFB_52A1["任务ID"] == _____4EFB_52A1ID then
            return _____4EFB_52A1
        end
    end
    return nil
end
local function _____4EFB_52A1_5339_914D_5F53_524DNPC(_____4EFB_52A1, npcName, npcQuestId, npcConfigName)
    if _____4EFB_52A1["任务ID"] == npcQuestId then
        return true
    end
    if _____4EFB_52A1["开始NPC"] == npcName then
        return true
    end
    return npcConfigName ~= nil and npcConfigName ~= "" and _____4EFB_52A1["开始NPC"] == npcConfigName
end
local function _____4EFB_52A1_524D_7F6E_5747_5DF2_5B8C_6210(playerId, _____4EFB_52A1ID)
    local _____4EFB_52A1_5B9A_4E49 = questDB:getQuest(_____4EFB_52A1ID)
    if _____4EFB_52A1_5B9A_4E49 == nil or not _____4EFB_52A1_5B9A_4E49.requiredQuests or #_____4EFB_52A1_5B9A_4E49.requiredQuests == 0 then
        return true
    end
    for ____, _____524D_7F6E_4EFB_52A1ID in ipairs(_____4EFB_52A1_5B9A_4E49.requiredQuests) do
        if not ____exports.hasPlayerCompletedQuest(nil, playerId, _____524D_7F6E_4EFB_52A1ID) then
            return false
        end
    end
    return true
end
function ____exports.findAvailableQuestByNpc(npcName, playerId, npcQuestId, npcConfigName)
    for ____, _____4EFB_52A1 in ipairs(_____4EFB_52A1_914D_7F6E_5217_8868) do
        do
            if _____4EFB_52A1["启用"] ~= true or not _____4EFB_52A1["任务ID"] then
                goto __continue49
            end
            if not _____4EFB_52A1_5339_914D_5F53_524DNPC(_____4EFB_52A1, npcName, npcQuestId, npcConfigName) then
                goto __continue49
            end
            local _____4EFB_52A1ID = tostring(_____4EFB_52A1["任务ID"])
            if ____exports.hasPlayerAcceptedQuest(nil, playerId, _____4EFB_52A1ID) or ____exports.hasPlayerCompletedQuest(nil, playerId, _____4EFB_52A1ID) then
                goto __continue49
            end
            if not _____4EFB_52A1_524D_7F6E_5747_5DF2_5B8C_6210(playerId, _____4EFB_52A1ID) then
                goto __continue49
            end
            return _____4EFB_52A1
        end
        ::__continue49::
    end
    return nil
end
function ____exports.resolveQuestEndNpc(self, quest)
    local endNpc = quest["结束NPC"]
    if endNpc and endNpc ~= "没有" then
        return endNpc
    end
    local endNpcConfig = quest["结束NPC配置"]
    if endNpcConfig then
        return endNpcConfig["NPC配置名"] or endNpcConfig["NPC名称"]
    end
    return quest["开始NPC"] or ""
end
function ____exports.findAcceptedQuestBySubmitNpc(self, npcName, playerId, npcQuestId, npcConfigName)
    for ____, quest in ipairs(_____4EFB_52A1_914D_7F6E_5217_8868) do
        do
            if quest["启用"] ~= true then
                goto __continue59
            end
            if not quest["任务ID"] then
                goto __continue59
            end
            local questId = tostring(quest["任务ID"])
            if not ____exports.hasPlayerAcceptedQuest(nil, playerId, questId) then
                goto __continue59
            end
            local explicitEndNpc = quest["结束NPC"] or quest["结束NPC配置"] and (quest["结束NPC配置"]["NPC配置名"] or quest["结束NPC配置"]["NPC名称"])
            if explicitEndNpc and explicitEndNpc ~= "没有" then
                if explicitEndNpc == npcName or explicitEndNpc == npcConfigName then
                    return quest
                end
                goto __continue59
            end
            if npcQuestId ~= nil and quest["任务ID"] == npcQuestId then
                return quest
            end
        end
        ::__continue59::
    end
    return nil
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
    local registeredConfig = _____6309_5355_4F4D_67E5_627ENPC_914D_7F6E(unit)
    if registeredConfig and registeredConfig["启用"] == true then
        return registeredConfig
    end
    local selectedUnitCode = fourCCToString(GetUnitTypeId(unit))
    for ____, npc in ipairs(_____652F_7EBFNPC_914D_7F6E_5217_8868) do
        do
            if npc["启用"] ~= true then
                goto __continue72
            end
            if npc["单位ID"] and npc["单位ID"] ~= selectedUnitCode then
                goto __continue72
            end
            if npc["NPC名称"] == unitName or npc["NPC配置名"] == unitName then
                return npc
            end
        end
        ::__continue72::
    end
    return nil
end
return ____exports
