local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local resolveNpcDialogName, openDialogForConfiguredNpc, onPlayerSelectedUnit, jass, debugLogForce, openNpcDialog, DIALOG_PLAYER_SLOTS
local ____03_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.03．任务状态")
local _____786E_4FDD_4EFB_52A1_914D_7F6E_5DF2_6CE8_518C = ____03_FF0E_4EFB_52A1_72B6_6001["确保任务配置已注册"]
local hasPlayerAcceptedQuest = ____03_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
local hasPlayerCompletedQuest = ____03_FF0E_4EFB_52A1_72B6_6001.hasPlayerCompletedQuest
local ____03_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.03．任务状态")
local findAcceptedQuestBySubmitNpc = ____03_FF0E_4EFB_52A1_72B6_6001.findAcceptedQuestBySubmitNpc
local findAvailableQuestByNpc = ____03_FF0E_4EFB_52A1_72B6_6001.findAvailableQuestByNpc
local findEnabledNpcConfigBySelectedUnit = ____03_FF0E_4EFB_52A1_72B6_6001.findEnabledNpcConfigBySelectedUnit
local findQuestById = ____03_FF0E_4EFB_52A1_72B6_6001.findQuestById
local ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统.08．任务奖励执行")
local getPlayerFirstHero = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local ____04_FF0ENPC_751F_6210_5668 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
local _____6309_5355_4F4D_67E5_627ENPC_914D_7F6E = ____04_FF0ENPC_751F_6210_5668["按单位查找NPC配置"]
local ____01_FF0EFourCC_8F6C_6362 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local fourCCToString = ____01_FF0EFourCC_8F6C_6362.fourCCToString
local ____04_FF0E_5BF9_8BDD_6784_5EFA = require("系统.09．表现系统.02．对话框系统.04．对话构建")
local buildDialogData = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildDialogData
local buildQuestCompletedDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestCompletedDialog
local buildQuestInProgressDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestInProgressDialog
local buildQuestOfferDialog = ____04_FF0E_5BF9_8BDD_6784_5EFA.buildQuestOfferDialog
function resolveNpcDialogName(npcConfig)
    if npcConfig["NPC名称"] ~= nil and npcConfig["NPC名称"] ~= "" then
        return npcConfig["NPC名称"]
    end
    return npcConfig["NPC配置名"] or ""
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
    local _____5BF9_8BDDNPC_4E0A_4E0B_6587 = {npcUnit = npcUnit, ["对话目标单位"] = hero, ["NPC配置朝向"] = npcConfig["朝向"]}
    local npcQuestId = npcConfig["任务ID"]
    local acceptedQuest = findAcceptedQuestBySubmitNpc(
        nil,
        npcName,
        playerId,
        npcQuestId,
        npcConfig["NPC配置名"]
    )
    if acceptedQuest and acceptedQuest["任务ID"] then
        local acceptedDialog = buildQuestInProgressDialog(
            nil,
            acceptedQuest,
            npcName,
            playerId,
            npcUnit,
            hero,
            npcConfig["朝向"]
        )
        openNpcDialog(
            nil,
            triggerPlayer,
            __TS__ObjectAssign({}, acceptedDialog, _____5BF9_8BDDNPC_4E0A_4E0B_6587)
        )
        return
    end
    local availableQuest = findAvailableQuestByNpc(npcName, playerId, npcQuestId, npcConfig["NPC配置名"])
    if availableQuest and availableQuest["任务ID"] then
        local dialogData = buildQuestOfferDialog(
            nil,
            availableQuest,
            npcName,
            playerId,
            npcUnit,
            hero,
            npcConfig["朝向"]
        )
        openNpcDialog(
            nil,
            triggerPlayer,
            __TS__ObjectAssign({}, dialogData, _____5BF9_8BDDNPC_4E0A_4E0B_6587)
        )
        return
    end
    local quest = findQuestById(nil, npcQuestId)
    if quest and quest["任务ID"] then
        local questIdStr = tostring(quest["任务ID"])
        if hasPlayerCompletedQuest(nil, playerId, questIdStr) and not quest["可重复"] then
            local dialogData = buildQuestCompletedDialog(nil, quest, npcName)
            openNpcDialog(
                nil,
                triggerPlayer,
                __TS__ObjectAssign({}, dialogData, _____5BF9_8BDDNPC_4E0A_4E0B_6587)
            )
            return
        end
        if hasPlayerAcceptedQuest(nil, playerId, questIdStr) then
            local dialogData = buildQuestInProgressDialog(
                nil,
                quest,
                npcName,
                playerId,
                npcUnit,
                hero,
                npcConfig["朝向"]
            )
            openNpcDialog(
                nil,
                triggerPlayer,
                __TS__ObjectAssign({}, dialogData, _____5BF9_8BDDNPC_4E0A_4E0B_6587)
            )
            return
        end
    end
    local heroName = jass:GetUnitName(hero)
    local dialogData = buildDialogData(nil, npcName, heroName)
    if dialogData then
        openNpcDialog(
            nil,
            triggerPlayer,
            __TS__ObjectAssign({}, dialogData, _____5BF9_8BDDNPC_4E0A_4E0B_6587)
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
    local registeredNpcConfig = _____6309_5355_4F4D_67E5_627ENPC_914D_7F6E(selectedUnit)
    local selectedOwner = jass:GetOwningPlayer(selectedUnit)
    local isRegisteredNpc = registeredNpcConfig ~= nil and registeredNpcConfig["启用"] == true
    local unitName = jass:GetUnitName(selectedUnit)
    local isTargetNpc = unitName == "人类农民" or registeredNpcConfig ~= nil and registeredNpcConfig["任务ID"] == 1000
    if isTargetNpc then
        local ____debugLogForce_3 = debugLogForce
        local ____array_2 = __TS__SparseArrayNew(
            "任务对话入口",
            "选中目标NPC",
            "触发玩家",
            playerId + 1,
            "句柄",
            jass:GetHandleId(selectedUnit),
            "名称",
            unitName,
            "单位ID",
            fourCCToString(jass:GetUnitTypeId(selectedUnit)),
            "所有者"
        )
        local ____selectedOwner_1
        if selectedOwner then
            ____selectedOwner_1 = jass:GetPlayerId(selectedOwner) + 1
        else
            ____selectedOwner_1 = 0
        end
        __TS__SparseArrayPush(____array_2, ____selectedOwner_1, "已登记", isRegisteredNpc)
        ____debugLogForce_3(__TS__SparseArraySpread(____array_2))
    end
    if not isRegisteredNpc and (not selectedOwner or selectedOwner ~= jass:Player(15)) then
        if isTargetNpc then
            debugLogForce("任务对话入口", "入口拒绝", "原因", "未登记且不是中立被动")
        end
        return
    end
    local npcConfig = isRegisteredNpc and registeredNpcConfig or findEnabledNpcConfigBySelectedUnit(nil, selectedUnit, unitName)
    if not npcConfig or npcConfig["任务ID"] == nil then
        if isTargetNpc then
            debugLogForce("任务对话入口", "入口拒绝", "原因", "未找到有效NPC配置")
        end
        return
    end
    local hero = getPlayerFirstHero(nil, triggerPlayer)
    if not hero then
        if isTargetNpc then
            debugLogForce("任务对话入口", "入口拒绝", "原因", "未找到玩家注册英雄")
        end
        return
    end
    local isHeroInRange = jass:IsUnitInRange(hero, selectedUnit, 350) == true
    if isTargetNpc then
        debugLogForce(
            "任务对话入口",
            "英雄范围检查",
            "英雄",
            jass:GetUnitName(hero),
            "英雄X",
            jass:GetUnitX(hero),
            "英雄Y",
            jass:GetUnitY(hero),
            "NPC X",
            jass:GetUnitX(selectedUnit),
            "NPC Y",
            jass:GetUnitY(selectedUnit),
            "350码内",
            isHeroInRange,
            "任务ID",
            npcConfig["任务ID"]
        )
    end
    if not isHeroInRange then
        return
    end
    if isTargetNpc then
        debugLogForce("任务对话入口", "条件通过，调用openNpcDialog")
    end
    openDialogForConfiguredNpc(triggerPlayer, npcConfig, selectedUnit)
end
jass = require("jass.common")
local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local ____selectionCenter = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
debugLogForce = ____require_result_0.debugLogForce
openNpcDialog = ____UI_51FD_6570.openNpcDialog
DIALOG_PLAYER_SLOTS = 4
local dialogSelectionListenerRegistered = false
local function registerDialogSelectionListener()
    local cb = ____selectionCenter.addSelectionListener
    if type(cb) ~= "function" then
        debugLogForce("任务对话入口", "选中事件中心接口缺失")
        return
    end
    cb(nil, onPlayerSelectedUnit)
    debugLogForce("任务对话入口", "选中监听已注册")
end
function ____exports.initDialogEntrySelectionTrigger()
    _____786E_4FDD_4EFB_52A1_914D_7F6E_5DF2_6CE8_518C(nil)
    if dialogSelectionListenerRegistered then
        return
    end
    dialogSelectionListenerRegistered = true
    registerDialogSelectionListener()
end
return ____exports
