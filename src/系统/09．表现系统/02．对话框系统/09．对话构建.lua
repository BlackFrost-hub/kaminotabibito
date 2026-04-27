local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____06_FF0E_5E38_91CF_4E0E_5DE5_5177 = require("系统.09．表现系统.02．对话框系统.06．常量与工具")
local DEFAULT_AFTER_COMPLETE_MSG = ____06_FF0E_5E38_91CF_4E0E_5DE5_5177.DEFAULT_AFTER_COMPLETE_MSG
local DEFAULT_QUEST_ACCEPTED_MSG = ____06_FF0E_5E38_91CF_4E0E_5DE5_5177.DEFAULT_QUEST_ACCEPTED_MSG
local showLocalHint = ____06_FF0E_5E38_91CF_4E0E_5DE5_5177.showLocalHint
local ____08_FF0E_914D_7F6E_67E5_8BE2 = require("系统.09．表现系统.02．对话框系统.08．配置查询")
local findDialogConfig = ____08_FF0E_914D_7F6E_67E5_8BE2.findDialogConfig
local ____07_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.07．任务状态")
local hasPlayerAcceptedQuest = ____07_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
local hasPlayerCompletedQuest = ____07_FF0E_4EFB_52A1_72B6_6001.hasPlayerCompletedQuest
local setQuestState = ____07_FF0E_4EFB_52A1_72B6_6001.setQuestState
local ____13_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统.13．任务奖励执行")
local getPlayerFirstHero = ____13_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local ____12_FF0E_4EFB_52A1_63D0_4EA4_6D41_7A0B = require("系统.09．表现系统.02．对话框系统.12．任务提交流程")
local handleQuestSubmit = ____12_FF0E_4EFB_52A1_63D0_4EA4_6D41_7A0B.handleQuestSubmit
local ____14_FF0E_4EFB_52A1_5C55_793A_6587_6848 = require("系统.09．表现系统.02．对话框系统.14．任务展示文案")
local resolveRewardDisplayText = ____14_FF0E_4EFB_52A1_5C55_793A_6587_6848.resolveRewardDisplayText
local ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548 = require("系统.09．表现系统.02．对话框系统.15．NPC头顶与气泡特效")
local scheduleGrayQuestMarkerAfterBubbleFade = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.scheduleGrayQuestMarkerAfterBubbleFade
local scheduleYellowQuestMarkerAfterBubbleFade = ____15_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.scheduleYellowQuestMarkerAfterBubbleFade
local jass = require("jass.common")
local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local openNpcDialog = ____UI_51FD_6570.openNpcDialog
local ____G_1 = _G
local addDelayedCallback = ____G_1.addDelayedCallback
local function scheduleOpenDialogLater(self, player, data)
    addDelayedCallback(
        nil,
        10,
        function()
            openNpcDialog(nil, player, data)
        end
    )
end
local function normalizeRequireCount(self, count)
    return count ~= nil and count > 1 and count or 1
end
local function refreshTaskUIForAllClientsSoon(self)
end
local function grantQuestItems(self, hero, questItems)
    if not hero or not questItems or questItems == "" then
        return
    end
    local items = __TS__StringSplit(questItems, "|")
    for ____, raw in ipairs(items) do
        do
            local itemCode = __TS__StringTrim(raw)
            if #itemCode ~= 4 then
                goto __continue8
            end
            local itemId = stringToFourCC(nil, itemCode)
            if itemId == 0 then
                goto __continue8
            end
            jass:UnitAddItemById(hero, itemId)
        end
        ::__continue8::
    end
end
local function canAcceptQuestByRequirements(self, quest, hero)
    local req = quest.requirements
    if not req or req == "" then
        return true
    end
    local markerA = "英雄等级<"
    local markerB = "英雄等级＜"
    local pos = (string.find(req, markerA, nil, true) or 0) - 1
    local offset = #markerA
    if pos < 0 then
        pos = (string.find(req, markerB, nil, true) or 0) - 1
        offset = #markerB
    end
    if pos < 0 then
        return true
    end
    local raw = __TS__StringTrim(__TS__StringSubstring(req, pos + offset))
    local digits = ""
    do
        local i = 0
        while i < #raw do
            local ch = __TS__StringCharAt(raw, i)
            if ch >= "0" and ch <= "9" then
                digits = digits .. ch
            else
                break
            end
            i = i + 1
        end
    end
    if digits == "" then
        return true
    end
    local limit = __TS__Number(digits)
    if not hero then
        return false
    end
    local level = jass:GetHeroLevel(hero)
    return level < limit
end
local function getQuestRewardDisplayText(self, quest)
    return resolveRewardDisplayText(nil, quest)
end
function ____exports.parseDialogText(self, raw, npcName, heroName)
    local lines = {}
    local parts = __TS__StringSplit(raw, "\n")
    local function trimOrderedPrefix(self, s)
        local i = 0
        while i < #s do
            local ch = __TS__StringCharAt(s, i)
            if ch < "0" or ch > "9" then
                break
            end
            i = i + 1
        end
        if i > 0 and i < #s and __TS__StringCharAt(s, i) == "." then
            return __TS__StringTrim(__TS__StringSubstring(s, i + 1))
        end
        return s
    end
    local function tryParseSpeakerLine(self, s)
        local colonIdx = (string.find(s, "：", nil, true) or 0) - 1 >= 0 and (string.find(s, "：", nil, true) or 0) - 1 or (string.find(s, ":", nil, true) or 0) - 1
        if colonIdx <= 0 then
            return nil
        end
        local speakerRaw = __TS__StringTrim(__TS__StringSubstring(s, 0, colonIdx))
        local textRaw = __TS__StringTrim(__TS__StringSubstring(s, colonIdx + 1))
        if textRaw == "" then
            return nil
        end
        if speakerRaw == "NPC" then
            return {title = npcName, text = textRaw}
        end
        if speakerRaw == "Player" then
            return {title = heroName, text = textRaw}
        end
        return {title = speakerRaw, text = textRaw}
    end
    for ____, part in ipairs(parts) do
        do
            local trimmed = __TS__StringTrim(part)
            if not trimmed then
                goto __continue33
            end
            local withoutOrder = trimOrderedPrefix(nil, trimmed)
            local parsed = tryParseSpeakerLine(nil, withoutOrder)
            if parsed then
                lines[#lines + 1] = {title = parsed.title, text = parsed.text, duration = 4}
                goto __continue33
            end
            lines[#lines + 1] = {title = npcName, text = trimmed, duration = 4}
        end
        ::__continue33::
    end
    return #lines > 0 and lines or ({{title = npcName, text = raw, duration = 4}})
end
function ____exports.buildDialogData(self, npcName, heroName)
    local dialogConfig = findDialogConfig(nil, npcName)
    if not dialogConfig then
        return {lines = {{title = npcName, text = "你好，有什么可以帮你的吗？", duration = 3}}, removeOverheadMarkerOnOpen = true}
    end
    return {
        lines = ____exports.parseDialogText(nil, dialogConfig.Text or "", npcName, heroName),
        removeOverheadMarkerOnOpen = true
    }
end
function ____exports.buildQuestCompletedDialog(self, quest, npcName)
    local msg = quest.afterCompleteDialog or quest.NpcCompleteText or DEFAULT_AFTER_COMPLETE_MSG
    if msg == "默认" then
        msg = DEFAULT_AFTER_COMPLETE_MSG
    end
    return {lines = {{title = npcName, text = msg, duration = 4}}, removeOverheadMarkerOnOpen = true}
end
function ____exports.buildQuestOfferDialog(self, quest, npcName, dialogOwnerId, npcUnit)
    local dialogOwner = jass:Player(dialogOwnerId)
    local ____dialogOwner_2
    if dialogOwner then
        ____dialogOwner_2 = getPlayerFirstHero(nil, dialogOwner)
    else
        ____dialogOwner_2 = nil
    end
    local ownerHero = ____dialogOwner_2
    local ____ownerHero_3
    if ownerHero then
        ____ownerHero_3 = jass:GetUnitName(ownerHero)
    else
        ____ownerHero_3 = "你"
    end
    local heroName = ____ownerHero_3
    local questDesc = quest.desc or quest.name or "未知任务"
    local rewardText = getQuestRewardDisplayText(nil, quest)
    local startLines = quest.NpcStartText and ____exports.parseDialogText(nil, quest.NpcStartText, npcName, heroName) or ({{
        title = npcName,
        text = "我有任务要交给你：" .. tostring(quest.name),
        duration = 4
    }})
    return {
        lines = startLines,
        removeOverheadMarkerOnOpen = true,
        quest = {
            title = npcName,
            text = (((("【" .. tostring(quest.name)) .. "】\n\n") .. questDesc) .. "\n\n奖励：") .. rewardText,
            onAccept = function()
                local questId = quest.requireID ~= nil and tostring(quest.requireID) or ""
                local playerObj = jass:Player(dialogOwnerId)
                local ____playerObj_4
                if playerObj then
                    ____playerObj_4 = getPlayerFirstHero(nil, playerObj)
                else
                    ____playerObj_4 = nil
                end
                local hero = ____playerObj_4
                if not canAcceptQuestByRequirements(nil, quest, hero) then
                    local failRaw = quest.AcceptFailedText or "当前条件不满足，无法接受该任务。"
                    scheduleOpenDialogLater(
                        nil,
                        playerObj,
                        {
                            lines = ____exports.parseDialogText(nil, failRaw, npcName, heroName),
                            npcUnit = npcUnit,
                            removeOverheadMarkerOnOpen = false,
                            restoreYellowQuestMarkerAfterDialog = true
                        }
                    )
                    return
                end
                if not hasPlayerAcceptedQuest(nil, dialogOwnerId, questId) then
                    local playerName = jass:GetPlayerName(playerObj) or "冒险者"
                    setQuestState(
                        nil,
                        dialogOwnerId,
                        questId,
                        1,
                        playerName
                    )
                    grantQuestItems(nil, hero, quest.questItems)
                    refreshTaskUIForAllClientsSoon(nil)
                end
                local acceptedRaw = quest.QuestAcceptedMsg or DEFAULT_QUEST_ACCEPTED_MSG
                local acceptedLines = ____exports.parseDialogText(nil, acceptedRaw, npcName, heroName)
                scheduleOpenDialogLater(
                    nil,
                    jass:Player(dialogOwnerId),
                    {lines = acceptedLines, npcUnit = npcUnit, removeOverheadMarkerOnOpen = false, applyGrayQuestMarkerAfterDialog = true}
                )
                if hasPlayerAcceptedQuest(nil, dialogOwnerId, questId) then
                    showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r该任务已经接受过了")
                end
            end,
            onReject = function()
                showLocalHint(
                    nil,
                    dialogOwnerId,
                    ("|cffffff00『系统提示』：|r|cffff4444已拒绝任务 『" .. tostring(quest.name)) .. "』|r"
                )
                if npcUnit then
                    scheduleYellowQuestMarkerAfterBubbleFade(nil, npcUnit)
                end
            end
        }
    }
end
function ____exports.buildQuestInProgressDialog(self, quest, npcName, dialogOwnerId, npcUnit)
    local dialogOwner = jass:Player(dialogOwnerId)
    local ____dialogOwner_5
    if dialogOwner then
        ____dialogOwner_5 = getPlayerFirstHero(nil, dialogOwner)
    else
        ____dialogOwner_5 = nil
    end
    local ownerHero = ____dialogOwner_5
    local ____ownerHero_6
    if ownerHero then
        ____ownerHero_6 = jass:GetUnitName(ownerHero)
    else
        ____ownerHero_6 = "你"
    end
    local heroName = ____ownerHero_6
    local questDesc = quest.desc or quest.name or ""
    local rewardText = getQuestRewardDisplayText(nil, quest)
    local requireCount = normalizeRequireCount(nil, quest.requireCount)
    return {
        lines = {},
        quest = {
            title = npcName,
            text = (((((("【" .. tostring(quest.name)) .. "】进行中...\n\n任务目标：") .. questDesc) .. "\n进度：0/") .. tostring(requireCount)) .. "\n\n奖励：") .. rewardText,
            acceptText = "提交任务",
            rejectText = "暂时忽略",
            onAccept = function()
                local questIdStr = quest.requireID ~= nil and tostring(quest.requireID) or ""
                handleQuestSubmit(nil, {
                    quest = quest,
                    npcName = npcName,
                    heroName = heroName,
                    dialogOwnerId = dialogOwnerId,
                    npcUnit = npcUnit,
                    parseDialogText = ____exports.parseDialogText,
                    openDialog = openNpcDialog,
                    refreshTaskUIForAllClientsSoon = refreshTaskUIForAllClientsSoon
                })
                if npcUnit and questIdStr ~= "" and hasPlayerAcceptedQuest(nil, dialogOwnerId, questIdStr) and not hasPlayerCompletedQuest(nil, dialogOwnerId, questIdStr) then
                    scheduleGrayQuestMarkerAfterBubbleFade(nil, npcUnit)
                end
            end,
            onReject = function()
                if npcUnit then
                    scheduleGrayQuestMarkerAfterBubbleFade(nil, npcUnit)
                end
            end
        }
    }
end
return ____exports
