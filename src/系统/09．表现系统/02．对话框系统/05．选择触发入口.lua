local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local resolveNpcDialogName, openDialogForConfiguredNpc, onPlayerSelectedUnit, jass, openNpcDialog, DIALOG_PLAYER_SLOTS
local ____03_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.03．任务状态")
local ensureQuestConfigsRegistered = ____03_FF0E_4EFB_52A1_72B6_6001.ensureQuestConfigsRegistered
local hasPlayerAcceptedQuest = ____03_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
local hasPlayerCompletedQuest = ____03_FF0E_4EFB_52A1_72B6_6001.hasPlayerCompletedQuest
local ____03_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.03．任务状态")
local findAcceptedQuestBySubmitNpc = ____03_FF0E_4EFB_52A1_72B6_6001.findAcceptedQuestBySubmitNpc
local findEnabledNpcConfigBySelectedUnit = ____03_FF0E_4EFB_52A1_72B6_6001.findEnabledNpcConfigBySelectedUnit
local findQuestByNpc = ____03_FF0E_4EFB_52A1_72B6_6001.findQuestByNpc
local ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统.08．任务奖励执行")
local getPlayerFirstHero = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local ____04_FF0E_5BF9_8BDD_6784_5EFA = require("系统.09．表现系统.02．对话框系统.04．对话构建")
local buildDialogData = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildDialogData
local buildQuestCompletedDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestCompletedDialog
local buildQuestInProgressDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestInProgressDialog
local buildQuestOfferDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestOfferDialog
function resolveNpcDialogName(npcConfig)
    if npcConfig.NPCrequireName ~= nil and npcConfig.NPCrequireName ~= "" then
        return npcConfig.NPCrequireName
    end
    return npcConfig.NpcNameID or ""
end
function openDialogForConfiguredNpc(triggerPlayer, npcConfig, npcUnit)
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
function onPlayerSelectedUnit(triggerPlayer, playerId, selectedUnit, isSelected)
    if not isSelected then
        return
    end
    if playerId < 0 or playerId >= DIALOG_PLAYER_SLOTS then
        return
    end
    if not selectedUnit or selectedUnit == 0 then
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
jass = require("jass.common")
local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local ____selectionCenter = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
openNpcDialog = ____UI_51FD_6570.openNpcDialog
DIALOG_PLAYER_SLOTS = 4
local dialogSelectionListenerRegistered = false
local function registerDialogSelectionListener()
    local cb = ____selectionCenter.addSelectionListener
    if type(cb) ~= "function" then
        return
    end
    cb(nil, onPlayerSelectedUnit)
end
function ____exports.initDialogEntrySelectionTrigger()
    ensureQuestConfigsRegistered(nil)
    if dialogSelectionListenerRegistered then
        return
    end
    dialogSelectionListenerRegistered = true
    registerDialogSelectionListener()
end
return ____exports
