local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5E38_91CF_4E0E_5DE5_5177 = require("系统.09．表现系统.02．对话框系统入口.01．常量与工具")
local UNIT_ID_NGME = ____01_FF0E_5E38_91CF_4E0E_5DE5_5177.UNIT_ID_NGME
local ____02_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统入口.02．任务状态")
local ensureQuestConfigsRegistered = ____02_FF0E_4EFB_52A1_72B6_6001.ensureQuestConfigsRegistered
local hasPlayerAcceptedQuest = ____02_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
local hasPlayerCompletedQuest = ____02_FF0E_4EFB_52A1_72B6_6001.hasPlayerCompletedQuest
local ____03_FF0E_914D_7F6E_67E5_8BE2 = require("系统.09．表现系统.02．对话框系统入口.03．配置查询")
local findNpcConfigByUnitName = ____03_FF0E_914D_7F6E_67E5_8BE2.findNpcConfigByUnitName
local findQuestByNpc = ____03_FF0E_914D_7F6E_67E5_8BE2.findQuestByNpc
local ____04_FF0E_5BF9_8BDD_6784_5EFA = require("系统.09．表现系统.02．对话框系统入口.04．对话构建")
local buildDialogData = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildDialogData
local buildQuestCompletedDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestCompletedDialog
local buildQuestInProgressDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestInProgressDialog
local buildQuestOfferDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestOfferDialog
local getVillageChiefDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.getVillageChiefDialog
local jass = require("jass.common")
local ____UI_51FD_6570 = require("系统.00．核心系统.06．UI函数")
local _____4FBF_6377_51FD_6570 = require("系统.00．核心系统.11．便捷函数（偶尔用）")
local openNpcDialog = ____UI_51FD_6570.openNpcDialog
function ____exports.initDialogEntrySelectionTrigger(self)
    ensureQuestConfigsRegistered(nil)
    local trg = jass.CreateTrigger()
    do
        local i = 0
        while i < 4 do
            jass.TriggerRegisterPlayerUnitEvent(
                trg,
                jass.Player(i),
                jass.EVENT_PLAYER_UNIT_SELECTED,
                nil
            )
            i = i + 1
        end
    end
    jass.TriggerAddAction(
        trg,
        function()
            local u = jass.GetTriggerUnit()
            if not u then
                return
            end
            local unitTypeId = jass.GetUnitTypeId(u)
            local triggerPlayer = jass.GetTriggerPlayer()
            local playerId = jass.GetPlayerId(triggerPlayer)
            local hero = _____4FBF_6377_51FD_6570:getPlayerFirstHero(triggerPlayer)
            if not hero then
                return
            end
            if not jass.IsUnitInRange(hero, u, 350) then
                return
            end
            local unitName = jass.GetUnitName(u)
            local npcConfig = findNpcConfigByUnitName(nil, unitName)
            if npcConfig and npcConfig.NpcName then
                local quest = findQuestByNpc(nil, npcConfig.NpcName)
                if quest and quest.requireID then
                    local questIdStr = tostring(quest.requireID)
                    if hasPlayerCompletedQuest(nil, playerId, questIdStr) and not quest.repeatable then
                        local dialogData = buildQuestCompletedDialog(nil, quest, npcConfig.NpcName)
                        openNpcDialog(
                            nil,
                            triggerPlayer,
                            __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                        )
                        return
                    end
                    if hasPlayerAcceptedQuest(nil, playerId, questIdStr) then
                        local dialogData = buildQuestInProgressDialog(nil, quest, npcConfig.NpcName, playerId)
                        openNpcDialog(
                            nil,
                            triggerPlayer,
                            __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                        )
                        return
                    end
                    local dialogData = buildQuestOfferDialog(nil, quest, npcConfig.NpcName, playerId)
                    openNpcDialog(
                        nil,
                        triggerPlayer,
                        __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                    )
                    return
                end
                local heroName = jass.GetUnitName(hero)
                local dialogData = buildDialogData(nil, npcConfig.NpcName, heroName)
                if dialogData then
                    openNpcDialog(
                        nil,
                        triggerPlayer,
                        __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                    )
                    return
                end
            end
            if unitTypeId ~= UNIT_ID_NGME then
                return
            end
            openNpcDialog(
                nil,
                triggerPlayer,
                __TS__ObjectAssign(
                    {},
                    getVillageChiefDialog(nil),
                    {npcUnit = u}
                )
            )
        end
    )
end
return ____exports
