local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____02_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统入口.02．任务状态")
local ensureQuestConfigsRegistered = ____02_FF0E_4EFB_52A1_72B6_6001.ensureQuestConfigsRegistered
local hasPlayerAcceptedQuest = ____02_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
local hasPlayerCompletedQuest = ____02_FF0E_4EFB_52A1_72B6_6001.hasPlayerCompletedQuest
local ____03_FF0E_914D_7F6E_67E5_8BE2 = require("系统.09．表现系统.02．对话框系统入口.03．配置查询")
local findAcceptedQuestBySubmitNpc = ____03_FF0E_914D_7F6E_67E5_8BE2.findAcceptedQuestBySubmitNpc
local findNpcConfigByUnitName = ____03_FF0E_914D_7F6E_67E5_8BE2.findNpcConfigByUnitName
local findQuestByNpc = ____03_FF0E_914D_7F6E_67E5_8BE2.findQuestByNpc
local ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统入口.08．任务奖励执行")
local getPlayerFirstHero = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local ____04_FF0E_5BF9_8BDD_6784_5EFA = require("系统.09．表现系统.02．对话框系统入口.04．对话构建")
local buildDialogData = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildDialogData
local buildQuestCompletedDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestCompletedDialog
local buildQuestInProgressDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestInProgressDialog
local buildQuestOfferDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestOfferDialog
local jass = require("jass.common")
local ____UI_51FD_6570 = require("系统.00．核心系统.06．UI函数")
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
            local triggerPlayer = jass.GetTriggerPlayer()
            local playerId = jass.GetPlayerId(triggerPlayer)
            local hero = getPlayerFirstHero(nil, triggerPlayer)
            if not hero then
                return
            end
            if not jass.IsUnitInRange(hero, u, 350) then
                return
            end
            local unitName = jass.GetUnitName(u)
            local npcConfig = findNpcConfigByUnitName(nil, unitName)
            local npcName = npcConfig and npcConfig.NPCrequireName or npcConfig and npcConfig.NpcNameID
            if npcConfig and npcName then
                local acceptedQuest = findAcceptedQuestBySubmitNpc(nil, npcName)
                if acceptedQuest and acceptedQuest.requireID then
                    local acceptedDialog = buildQuestInProgressDialog(
                        nil,
                        acceptedQuest,
                        npcName,
                        playerId,
                        u
                    )
                    openNpcDialog(
                        nil,
                        triggerPlayer,
                        __TS__ObjectAssign({}, acceptedDialog, {npcUnit = u})
                    )
                    return
                end
                local quest = findQuestByNpc(nil, npcName)
                if quest and quest.requireID then
                    local questIdStr = tostring(quest.requireID)
                    if hasPlayerCompletedQuest(nil, playerId, questIdStr) and not quest.repeatable then
                        local dialogData = buildQuestCompletedDialog(nil, quest, npcName)
                        openNpcDialog(
                            nil,
                            triggerPlayer,
                            __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                        )
                        return
                    end
                    if hasPlayerAcceptedQuest(nil, playerId, questIdStr) then
                        local dialogData = buildQuestInProgressDialog(
                            nil,
                            quest,
                            npcName,
                            playerId,
                            u
                        )
                        openNpcDialog(
                            nil,
                            triggerPlayer,
                            __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                        )
                        return
                    end
                    local dialogData = buildQuestOfferDialog(nil, quest, npcName, playerId)
                    openNpcDialog(
                        nil,
                        triggerPlayer,
                        __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                    )
                    return
                end
                local heroName = jass.GetUnitName(hero)
                local dialogData = buildDialogData(nil, npcName, heroName)
                if dialogData then
                    openNpcDialog(
                        nil,
                        triggerPlayer,
                        __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                    )
                    return
                end
            end
        end
    )
end
return ____exports
