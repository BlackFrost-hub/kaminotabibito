local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_89E6_53D1_4E0E_4E8B_4EF6 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterPlayerSelectionEventBJ = ____01_FF0E_89E6_53D1_4E0E_4E8B_4EF6.TriggerRegisterPlayerSelectionEventBJ
local ____07_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.07．任务状态")
local ensureQuestConfigsRegistered = ____07_FF0E_4EFB_52A1_72B6_6001.ensureQuestConfigsRegistered
local hasPlayerAcceptedQuest = ____07_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
local hasPlayerCompletedQuest = ____07_FF0E_4EFB_52A1_72B6_6001.hasPlayerCompletedQuest
local ____08_FF0E_914D_7F6E_67E5_8BE2 = require("系统.09．表现系统.02．对话框系统.08．配置查询")
local findAcceptedQuestBySubmitNpc = ____08_FF0E_914D_7F6E_67E5_8BE2.findAcceptedQuestBySubmitNpc
local findEnabledNpcConfigBySelectedUnit = ____08_FF0E_914D_7F6E_67E5_8BE2.findEnabledNpcConfigBySelectedUnit
local findQuestByNpc = ____08_FF0E_914D_7F6E_67E5_8BE2.findQuestByNpc
local ____13_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统.13．任务奖励执行")
local getPlayerFirstHero = ____13_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local ____09_FF0E_5BF9_8BDD_6784_5EFA = require("系统.09．表现系统.02．对话框系统.09．对话构建")
local buildDialogData = ____09_FF0E_5BF9_8BDD_6784_5EFA.buildDialogData
local buildQuestCompletedDialog = ____09_FF0E_5BF9_8BDD_6784_5EFA.buildQuestCompletedDialog
local buildQuestInProgressDialog = ____09_FF0E_5BF9_8BDD_6784_5EFA.buildQuestInProgressDialog
local buildQuestOfferDialog = ____09_FF0E_5BF9_8BDD_6784_5EFA.buildQuestOfferDialog
---
-- @noSelfInFile
local jass = require("jass.common")
local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local openNpcDialog = ____UI_51FD_6570.openNpcDialog
local DIALOG_PLAYER_SLOTS = 4
local g_dialogSelectionTriggerRegistered = false
local function resolveNpcDialogName(npcConfig)
    if npcConfig.NPCrequireName ~= nil and npcConfig.NPCrequireName ~= "" then
        return npcConfig.NPCrequireName
    end
    return npcConfig.NpcNameID or ""
end
local function openDialogForConfiguredNpc(triggerPlayer, npcConfig, npcUnit)
    if not triggerPlayer or not npcConfig or not npcUnit then
        return
    end
    local playerId = jass:GetPlayerId(triggerPlayer)
    if playerId < 0 or playerId >= DIALOG_PLAYER_SLOTS then
        return
    end
    local hero = getPlayerFirstHero(nil, triggerPlayer)
    if not hero then
        return
    end
    if not jass:IsUnitInRange(hero, npcUnit, 350) then
        return
    end
    local npcName = resolveNpcDialogName(npcConfig)
    if npcName == "" then
        return
    end
    local acceptedQuest = findAcceptedQuestBySubmitNpc(nil, npcName, playerId)
    if acceptedQuest and acceptedQuest.requireID then
        local acceptedDialog = buildQuestInProgressDialog(
            nil,
            acceptedQuest,
            npcName,
            playerId,
            npcUnit
        )
        openNpcDialog(
            nil,
            triggerPlayer,
            __TS__ObjectAssign({}, acceptedDialog, {npcUnit = npcUnit})
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
                __TS__ObjectAssign({}, dialogData, {npcUnit = npcUnit})
            )
            return
        end
        if hasPlayerAcceptedQuest(nil, playerId, questIdStr) then
            local dialogData = buildQuestInProgressDialog(
                nil,
                quest,
                npcName,
                playerId,
                npcUnit
            )
            openNpcDialog(
                nil,
                triggerPlayer,
                __TS__ObjectAssign({}, dialogData, {npcUnit = npcUnit})
            )
            return
        end
        local dialogData = buildQuestOfferDialog(
            nil,
            quest,
            npcName,
            playerId,
            npcUnit
        )
        openNpcDialog(
            nil,
            triggerPlayer,
            __TS__ObjectAssign({}, dialogData, {npcUnit = npcUnit})
        )
        return
    end
    local heroName = jass:GetUnitName(hero)
    local dialogData = buildDialogData(nil, npcName, heroName)
    if dialogData then
        openNpcDialog(
            nil,
            triggerPlayer,
            __TS__ObjectAssign({}, dialogData, {npcUnit = npcUnit})
        )
    end
end
local function onPlayerSelectedUnit()
    local triggerPlayer = jass:GetTriggerPlayer()
    local playerId = jass:GetPlayerId(triggerPlayer)
    if playerId < 0 or playerId >= DIALOG_PLAYER_SLOTS then
        return
    end
    local selectedUnit = jass:GetTriggerUnit()
    if not selectedUnit then
        return
    end
    local selectedOwner = jass:GetOwningPlayer(selectedUnit)
    if not selectedOwner or selectedOwner ~= jass:Player(15) then
        return
    end
    local unitName = jass:GetUnitName(selectedUnit)
    local npcConfig = findEnabledNpcConfigBySelectedUnit(nil, selectedUnit, unitName)
    if not npcConfig or npcConfig.requireID == nil then
        return
    end
    local hero = getPlayerFirstHero(nil, triggerPlayer)
    if not hero then
        return
    end
    if not jass:IsUnitInRange(hero, selectedUnit, 350) then
        return
    end
    openDialogForConfiguredNpc(triggerPlayer, npcConfig, selectedUnit)
end
function ____exports.initDialogEntrySelectionTrigger()
    ensureQuestConfigsRegistered(nil)
    if g_dialogSelectionTriggerRegistered then
        return
    end
    g_dialogSelectionTriggerRegistered = true
    local trig = jass:CreateTrigger()
    jass:TriggerAddAction(trig, onPlayerSelectedUnit)
    do
        local i = 0
        while i < DIALOG_PLAYER_SLOTS do
            TriggerRegisterPlayerSelectionEventBJ(
                trig,
                jass:Player(i),
                true
            )
            i = i + 1
        end
    end
end
return ____exports
