local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local ____exports = {}
local ____01_FF0E_5BF9_8BDD_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.01．对话配置表")
local DIALOG_NPC_CONFIGS = ____01_FF0E_5BF9_8BDD_914D_7F6E_8868.DIALOG_NPC_CONFIGS
local ____03_FF0ENPC_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.03．NPC配置表")
local NPC_CONFIGS = ____03_FF0ENPC_914D_7F6E_8868.NPC_CONFIGS
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local QUEST_CONFIGS = ____02_FF0E_4EFB_52A1_914D_7F6E_8868.QUEST_CONFIGS
local ____02_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统入口.02．任务状态")
local hasPlayerAcceptedQuest = ____02_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
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
function ____exports.findAcceptedQuestBySubmitNpc(self, npcName)
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
            if not hasPlayerAcceptedQuest(nil, 0, questId) then
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
function ____exports.findNpcConfigByUnitName(self, unitName)
    for ____, npc in ipairs(NPC_CONFIGS) do
        if npc.NPCrequireName == unitName or npc.NpcNameID == unitName then
            return npc
        end
    end
    return nil
end
return ____exports
