local ____lualib = require("lualib_bundle")
local __TS__ArrayFind = ____lualib.__TS__ArrayFind
local __TS__Iterator = ____lualib.__TS__Iterator
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
local calculateFourCC, giveQuestReward
local ____03_FF0EBJ_51FD_6570 = require("lib.扩展函数.03．BJ函数")
local GetItemTypeCountInUnitBJ = ____03_FF0EBJ_51FD_6570.GetItemTypeCountInUnitBJ
local RemoveItemTypeFromUnitBJ = ____03_FF0EBJ_51FD_6570.RemoveItemTypeFromUnitBJ
local ____02_FF0EYDWE_51FD_6570 = require("lib.扩展函数.02．YDWE函数")
local getItemName = ____02_FF0EYDWE_51FD_6570.getItemName
local getObjectProperty = ____02_FF0EYDWE_51FD_6570.getObjectProperty
local ObjectType = ____02_FF0EYDWE_51FD_6570.ObjectType
local ____01_FF0E_5BF9_8BDD_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.01．对话配置表")
local DIALOG_NPC_CONFIGS = ____01_FF0E_5BF9_8BDD_914D_7F6E_8868.DIALOG_NPC_CONFIGS
local ____03_FF0ENPC_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.03．NPC配置表")
local NPC_CONFIGS = ____03_FF0ENPC_914D_7F6E_8868.NPC_CONFIGS
local ____02_FF0E_4EFB_52A1_914D_7F6E_8868 = require("系统.08．任务系统.00．配置表.02．任务配置表")
local QUEST_CONFIGS = ____02_FF0E_4EFB_52A1_914D_7F6E_8868.QUEST_CONFIGS
local ____11_FF0E_4FBF_6377_51FD_6570_FF08_5076_5C14_7528_FF09 = require("系统.00．核心系统.11．便捷函数（偶尔用）")
local giveRewardToPlayers = ____11_FF0E_4FBF_6377_51FD_6570_FF08_5076_5C14_7528_FF09.giveRewardToPlayers
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local ____03_FF0E_4EFB_52A1UI = require("系统.08．任务系统.03．任务UI")
local taskUI = ____03_FF0E_4EFB_52A1UI.taskUI
function calculateFourCC(self, code)
    if #code ~= 4 then
        return 0
    end
    local bytes = {
        string.byte(code, 1) or 0 / 0,
        string.byte(code, 2) or 0 / 0,
        string.byte(code, 3) or 0 / 0,
        string.byte(code, 4) or 0 / 0
    }
    return bytes[1] * 16777216 + bytes[2] * 65536 + bytes[3] * 256 + bytes[4]
end
function giveQuestReward(self, reward, triggerPlayerId)
    giveRewardToPlayers(nil, reward, triggerPlayerId)
end
--- 测试：红色玩家（Player 0）选择指定单位时触发对话框
-- 
-- 文本数据来自配置表：配置表/对话配置表.ts 和 配置表/NPC配置表.ts
local jass = require("jass.common")
local japi = require("jass.japi")
local ____UI_51FD_6570 = require("系统.00．核心系统.06．UI函数")
local _____4FBF_6377_51FD_6570 = require("系统.00．核心系统.11．便捷函数（偶尔用）")
local openNpcDialog = ____UI_51FD_6570.openNpcDialog
local UNIT_ID_NGME = 110 * 16777216 + 103 * 65536 + 109 * 256 + 101
local DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的"
local function ensureQuestConfigsRegistered(self)
    local g = _G
    if g.__questConfigsRegistered then
        return
    end
    g.__questConfigsRegistered = true
    for ____, cfg in ipairs(QUEST_CONFIGS) do
        do
            local __continue4
            repeat
                if not cfg.requireID then
                    __continue4 = true
                    break
                end
                local questId = tostring(cfg.requireID)
                if questDB:getQuest(questId) then
                    __continue4 = true
                    break
                end
                local iconPath = ""
                if cfg.startNpc then
                    local npcCfg = __TS__ArrayFind(
                        NPC_CONFIGS,
                        function(____, n) return n.NpcName == cfg.startNpc end
                    )
                    if npcCfg and npcCfg.unitCode then
                        iconPath = getObjectProperty(nil, ObjectType.UNIT, npcCfg.unitCode, "Art")
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
                        required = cfg.requireCount or 1,
                        completed = false
                    }}) or ({}),
                    rewards = {{type = "gold", value = 0, description = cfg.reward or ""}},
                    status = QuestStatus.UNDISCOVERED,
                    startNpc = cfg.startNpc,
                    icon = iconPath or nil,
                    createdAt = 0,
                    updatedAt = 0
                })
                __continue4 = true
            until true
            if not __continue4 then
                break
            end
        end
    end
end
local function getQuestState(self, questId)
    local status = questDB:getPlayerQuestStatus(0, questId)
    if status == QuestStatus.COMPLETED then
        return 2
    end
    if status == QuestStatus.IN_PROGRESS then
        return 1
    end
    return 0
end
local function setQuestState(self, questId, state, playerName)
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
    elseif state == 2 then
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
local function hasPlayerAcceptedQuest(self, _playerId, questId)
    return getQuestState(nil, questId) == 1
end
local function hasPlayerCompletedQuest(self, _playerId, questId)
    return getQuestState(nil, questId) == 2
end
local DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者"
local function buildQuestCompletedDialog(self, quest, npcName)
    local msg = quest.afterCompleteDialog or quest.NpcCompleteText or DEFAULT_AFTER_COMPLETE_MSG
    if msg == "默认" then
        msg = DEFAULT_AFTER_COMPLETE_MSG
    end
    return {lines = {{title = npcName, text = msg, duration = 4}}}
end
local UNIT_CODE_MAP = {}
for ____, npc in ipairs(NPC_CONFIGS) do
    if npc.unitCode ~= nil and npc.unitCode ~= "" then
        UNIT_CODE_MAP[npc.unitCode] = calculateFourCC(nil, npc.unitCode)
    end
end
local function findQuestByNpc(self, npcName)
    return __TS__ArrayFind(
        QUEST_CONFIGS,
        function(____, quest) return quest.startNpc == npcName and quest.requireID end
    )
end
local function findDialogConfig(self, npcName)
    return __TS__ArrayFind(
        DIALOG_NPC_CONFIGS,
        function(____, config) return config.npc == npcName end
    )
end
local function parseDialogText(self, raw, npcName, heroName)
    local lines = {}
    local parts = __TS__StringSplit(raw, "\n")
    for ____, part in ipairs(parts) do
        do
            local __continue41
            repeat
                local trimmed = __TS__StringTrim(part)
                if not trimmed then
                    __continue41 = true
                    break
                end
                local dotIndex = (string.find(trimmed, ".", nil, true) or 0) - 1
                if dotIndex > 0 then
                    local rest = __TS__StringSubstring(trimmed, dotIndex + 1)
                    local colonIndex = (string.find(rest, "：", nil, true) or 0) - 1
                    if colonIndex > 0 then
                        local speaker = __TS__StringSubstring(rest, 0, colonIndex)
                        local text = __TS__StringSubstring(rest, colonIndex + 1)
                        local title = speaker == "NPC" and npcName or (speaker == "Player" and heroName or speaker)
                        lines[#lines + 1] = {title = title, text = text, duration = 4}
                        __continue41 = true
                        break
                    end
                end
                lines[#lines + 1] = {title = npcName, text = trimmed, duration = 4}
                __continue41 = true
            until true
            if not __continue41 then
                break
            end
        end
    end
    return #lines > 0 and lines or ({{title = npcName, text = raw, duration = 4}})
end
local function buildQuestOfferDialog(self, quest, npcName, dialogOwnerId)
    local dialogOwner = jass.Player(dialogOwnerId)
    local ____dialogOwner_7
    if dialogOwner then
        ____dialogOwner_7 = _____4FBF_6377_51FD_6570:getPlayerFirstHero(dialogOwner)
    else
        ____dialogOwner_7 = nil
    end
    local ownerHero = ____dialogOwner_7
    local ____ownerHero_8
    if ownerHero then
        ____ownerHero_8 = jass.GetUnitName(ownerHero)
    else
        ____ownerHero_8 = "你"
    end
    local heroName = ____ownerHero_8
    local questDesc = quest.desc or quest.name or "未知任务"
    local rewardText = quest.reward or "无"
    local startLines = quest.NpcStartText and parseDialogText(nil, quest.NpcStartText, npcName, heroName) or ({{
        title = npcName,
        text = "我有任务要交给你：" .. tostring(quest.name),
        duration = 4
    }})
    return {
        lines = startLines,
        quest = {
            title = npcName,
            text = (((("【" .. tostring(quest.name)) .. "】\n\n") .. questDesc) .. "\n\n奖励：") .. rewardText,
            onAccept = function()
                local ____opt_9 = quest.requireID
                local questId = ____opt_9 and tostring(quest.requireID) or ""
                if not hasPlayerAcceptedQuest(nil, 0, questId) then
                    local playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) or "冒险者"
                    setQuestState(nil, questId, 1, playerName)
                end
                local dialogOwner = jass.Player(dialogOwnerId)
                local acceptedRaw = quest.QuestAcceptedMsg or DEFAULT_QUEST_ACCEPTED_MSG
                local acceptedLines = parseDialogText(nil, acceptedRaw, npcName, heroName)
                openNpcDialog(nil, dialogOwner, {lines = acceptedLines})
                local localPlayer = jass.GetLocalPlayer()
                if localPlayer == jass.Player(dialogOwnerId) and hasPlayerAcceptedQuest(
                    nil,
                    jass.GetPlayerId(localPlayer),
                    questId
                ) then
                    jass.DisplayTimedTextToPlayer(
                        localPlayer,
                        0,
                        0,
                        5,
                        "|cffffff00『系统提示』：|r该任务已经接受过了"
                    )
                end
            end,
            onReject = function()
                local localPlayer = jass.GetLocalPlayer()
                if localPlayer == jass.Player(dialogOwnerId) then
                    jass.DisplayTimedTextToPlayer(
                        localPlayer,
                        0,
                        0,
                        5,
                        ("|cffffff00『系统提示』：|r|cffff4444已拒绝任务 『" .. tostring(quest.name)) .. "』|r"
                    )
                end
            end
        }
    }
end
local function buildQuestInProgressDialog(self, quest, npcName, dialogOwnerId)
    local dialogOwner = jass.Player(dialogOwnerId)
    local ____dialogOwner_11
    if dialogOwner then
        ____dialogOwner_11 = _____4FBF_6377_51FD_6570:getPlayerFirstHero(dialogOwner)
    else
        ____dialogOwner_11 = nil
    end
    local ownerHero = ____dialogOwner_11
    local ____ownerHero_12
    if ownerHero then
        ____ownerHero_12 = jass.GetUnitName(ownerHero)
    else
        ____ownerHero_12 = "你"
    end
    local heroName = ____ownerHero_12
    local msg = quest.QuestAcceptedMsg or DEFAULT_QUEST_ACCEPTED_MSG
    local ____dialogOwner_13
    if dialogOwner then
        ____dialogOwner_13 = jass.GetPlayerId(dialogOwner)
    else
        ____dialogOwner_13 = dialogOwnerId
    end
    local playerId = ____dialogOwner_13
    local ____opt_14 = quest.requireID
    local questId = ____opt_14 and tostring(quest.requireID) or ""
    local questDesc = quest.desc or quest.name or ""
    local rewardText = quest.reward or "无"
    return {
        lines = {},
        quest = {
            title = npcName,
            text = (((((("【" .. tostring(quest.name)) .. "】进行中...\n\n任务目标：") .. questDesc) .. "\n进度：0/") .. tostring(quest.requireCount or 1)) .. "\n\n奖励：") .. rewardText,
            acceptText = "提交任务",
            rejectText = "暂时忽略",
            onAccept = function()
                local callbackOwner = jass.Player(dialogOwnerId)
                local ____callbackOwner_16
                if callbackOwner then
                    ____callbackOwner_16 = _____4FBF_6377_51FD_6570:getPlayerFirstHero(callbackOwner)
                else
                    ____callbackOwner_16 = nil
                end
                local hero = ____callbackOwner_16
                local requireItem = quest.requireItem
                local requireCount = quest.requireCount or 1
                local playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) or "冒险者"
                local function broadcastQuestComplete(self)
                    local rewardStr = quest.reward or "无"
                    local isAll = not rewardStr or (string.find(rewardStr, "所有玩家", nil, true) or 0) - 1 ~= -1 or (string.find(rewardStr, "all", nil, true) or 0) - 1 ~= -1 or (string.find(rewardStr, "完成任务的玩家", nil, true) or 0) - 1 == -1 and (string.find(rewardStr, "Player", nil, true) or 0) - 1 == -1
                    local targetLabel = isAll and "|cffffcc00所有玩家|r" or ("|cff00ccff" .. tostring(playerName)) .. "|r"
                    local TARGET_PREFIXES = {"所有玩家", "完成任务的玩家", "Player"}
                    local cleanReward = table.concat(
                        __TS__ArrayFilter(
                            __TS__ArrayMap(
                                __TS__StringSplit(rewardStr, ";"),
                                function(____, seg)
                                    local s = __TS__StringTrim(seg)
                                    for ____, prefix in ipairs(TARGET_PREFIXES) do
                                        if __TS__StringStartsWith(s, prefix) then
                                            s = __TS__StringSubstring(s, #prefix)
                                            while string.sub(s, 1, 1) == "+" or string.sub(s, 1, 1) == "＋" do
                                                s = __TS__StringSubstring(s, 1)
                                            end
                                            s = __TS__StringTrim(s)
                                            break
                                        end
                                    end
                                    return s
                                end
                            ),
                            function(____, s) return #s > 0 end
                        ),
                        "、"
                    )
                    local msg = (("|cffffff00『系统提示』：|r" .. ("|cff00ff66" .. tostring(playerName)) .. "|r") .. (" 完成了 |cffffcc00『" .. tostring(quest.name)) .. "』|r，") .. ((targetLabel .. " 获得了奖励：|cffff9900") .. cleanReward) .. "|r"
                    do
                        local i = 0
                        while i < 4 do
                            local p = jass.Player(i)
                            if p ~= nil and jass.GetPlayerController(p) == jass.MAP_CONTROL_USER then
                                jass.DisplayTimedTextToPlayer(
                                    p,
                                    0,
                                    0,
                                    10,
                                    msg
                                )
                            end
                            i = i + 1
                        end
                    end
                end
                local function onComplete(self)
                    broadcastQuestComplete(nil)
                    local t = jass.CreateTimer()
                    jass.TimerStart(
                        t,
                        0.1,
                        false,
                        function()
                            local lp = jass.GetLocalPlayer()
                            if lp ~= nil then
                                pcall(function () return taskUI:refreshList() end
                                )
                            end
                            jass.PauseTimer(t)
                            jass.DestroyTimer(t)
                        end
                    )
                    if quest.NpcCompleteText then
                        local dialogOwner = jass.Player(dialogOwnerId)
                        local completeLines = parseDialogText(nil, quest.NpcCompleteText, npcName, heroName)
                        openNpcDialog(nil, dialogOwner, {lines = completeLines})
                    end
                end
                if requireItem then
                    if not hero then
                        local localPlayer = jass.GetLocalPlayer()
                        if localPlayer == jass.Player(dialogOwnerId) then
                            jass.DisplayTimedTextToPlayer(
                                localPlayer,
                                0,
                                0,
                                5,
                                "|cffffff00『系统提示』：|r|cffff4444你没有英雄单位！|r"
                            )
                        end
                        return
                    end
                    local itemId = calculateFourCC(nil, requireItem)
                    local itemCount = GetItemTypeCountInUnitBJ(nil, hero, itemId)
                    if itemCount >= requireCount then
                        local removed = RemoveItemTypeFromUnitBJ(nil, hero, itemId, requireCount)
                        if removed >= requireCount then
                            setQuestState(nil, questId, 2, playerName)
                            giveQuestReward(nil, quest.reward or "", dialogOwnerId)
                            onComplete(nil)
                        else
                            local localPlayer = jass.GetLocalPlayer()
                            if localPlayer == jass.Player(dialogOwnerId) then
                                jass.DisplayTimedTextToPlayer(
                                    localPlayer,
                                    0,
                                    0,
                                    5,
                                    "|cffffff00『系统提示』：|r|cffff4444物品扣除失败，请重试|r"
                                )
                            end
                        end
                    else
                        local localPlayer = jass.GetLocalPlayer()
                        if localPlayer == jass.Player(dialogOwnerId) then
                            local itemDisplayName = getItemName(nil, requireItem) or requireItem
                            jass.DisplayTimedTextToPlayer(
                                localPlayer,
                                0,
                                0,
                                5,
                                (((("|cffffff00『系统提示』：|r你只有 |cffff9900" .. tostring(itemCount)) .. "|r 个 |cffffcc00") .. itemDisplayName) .. "|r，") .. ("还需要 |cffff4444" .. tostring(requireCount - itemCount)) .. "|r 个"
                            )
                        end
                    end
                else
                    setQuestState(nil, questId, 2, playerName)
                    giveQuestReward(nil, quest.reward or "", dialogOwnerId)
                    onComplete(nil)
                end
            end,
            onReject = function()
            end
        }
    }
end
local function findNpcConfigByUnitCode(self, unitCode)
    for ____, ____value in ipairs(__TS__ObjectEntries(NPC_CONFIGS)) do
        local id = ____value[1]
        local npc = ____value[2]
        if npc.unitCode == unitCode then
            return __TS__ObjectAssign({id = id}, npc)
        end
    end
    return nil
end
local function buildDialogData(self, npcName, heroName)
    local dialogConfig = findDialogConfig(nil, npcName)
    if not dialogConfig then
        return {lines = {{title = npcName, text = "你好，有什么可以帮你的吗？", duration = 3}}}
    end
    return {lines = parseDialogText(nil, dialogConfig.text or "", npcName, heroName)}
end
local function getVillageChiefDialog(self)
    local config = findDialogConfig(nil, "村长")
    if not config then
        config = findDialogConfig(nil, "精灵村NPC001")
    end
    if config then
        local npcName = config.npc or "NPC"
        return {lines = parseDialogText(nil, config.text or "", npcName, "你")}
    end
    return {
        lines = {{title = "村长", text = "年轻人，我们村子最近遭到了哥布林的袭击……", duration = 4}, {title = "村长", text = "听说你武艺高强，能否帮我们解决这个麻烦？", duration = 3}},
        quest = {
            title = "村长",
            text = "【讨伐哥布林】\n\n哥布林巢穴就在村子东边的森林里。\n\n奖励：金币 500 + 经验 1000",
            onAccept = function()
                jass.DisplayTimedTextToPlayer(
                    jass.Player(0),
                    0,
                    0,
                    5,
                    "|cffffff00『系统提示』：|r|cff00ff66已接受任务 『讨伐哥布林』|r"
                )
            end,
            onReject = function()
                jass.DisplayTimedTextToPlayer(
                    jass.Player(0),
                    0,
                    0,
                    5,
                    "|cffffff00『系统提示』：|r|cffff4444已拒绝任务 『讨伐哥布林』|r"
                )
            end
        }
    }
end
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
        local npcConfig = nil
        for ____, npc in ipairs(NPC_CONFIGS) do
            if npc.NpcName == unitName then
                npcConfig = npc
                break
            end
        end
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
                else
                    local dialogData = buildQuestOfferDialog(nil, quest, npcConfig.NpcName, playerId)
                    openNpcDialog(
                        nil,
                        triggerPlayer,
                        __TS__ObjectAssign({}, dialogData, {npcUnit = u})
                    )
                    return
                end
            end
            local ____hero_17
            if hero then
                ____hero_17 = jass.GetUnitName(hero)
            else
                ____hero_17 = "你"
            end
            local heroName = ____hero_17
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
return ____exports
