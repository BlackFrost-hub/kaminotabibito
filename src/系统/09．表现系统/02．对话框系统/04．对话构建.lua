local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringCharAt = ____lualib.__TS__StringCharAt
local __TS__Number = ____lualib.__TS__Number
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
local ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91 = require("系统.09．表现系统.02．对话框系统.02．对话框业务逻辑")
local DEFAULT_AFTER_COMPLETE_MSG = ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.DEFAULT_AFTER_COMPLETE_MSG
local DEFAULT_QUEST_ACCEPTED_MSG = ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.DEFAULT_QUEST_ACCEPTED_MSG
local showLocalHint = ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.showLocalHint
local ____03_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.03．任务状态")
local findDialogConfig = ____03_FF0E_4EFB_52A1_72B6_6001.findDialogConfig
local ____03_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.03．任务状态")
local hasPlayerAcceptedQuest = ____03_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
local hasPlayerCompletedQuest = ____03_FF0E_4EFB_52A1_72B6_6001.hasPlayerCompletedQuest
local setQuestState = ____03_FF0E_4EFB_52A1_72B6_6001.setQuestState
local ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统.08．任务奖励执行")
local getPlayerFirstHero = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local ____07_FF0E_4EFB_52A1_63D0_4EA4_6D41_7A0B = require("系统.09．表现系统.02．对话框系统.07．任务提交流程")
local handleQuestSubmit = ____07_FF0E_4EFB_52A1_63D0_4EA4_6D41_7A0B.handleQuestSubmit
local ____03_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.03．任务状态")
local resolveRewardDisplayText = ____03_FF0E_4EFB_52A1_72B6_6001.resolveRewardDisplayText
local ____09_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548 = require("系统.09．表现系统.02．对话框系统.09．NPC头顶与气泡特效")
local scheduleGrayQuestMarkerAfterBubbleFade = ____09_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.scheduleGrayQuestMarkerAfterBubbleFade
local scheduleYellowQuestMarkerAfterBubbleFade = ____09_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.scheduleYellowQuestMarkerAfterBubbleFade
local jass = require("jass.common")
local ____UI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local ____npcEffect = require("系统.09．表现系统.02．对话框系统.09．NPC头顶与气泡特效")
local function getDialogNpcUnit(playerId)
    return ____npcEffect.getNpcUnit(playerId)
end
local ____require_result_0 = require("系统.09．表现系统.02．对话框系统.14．任务物品发放")
local _____53D1_653E_4EFB_52A1_7269_54C1 = ____require_result_0["发放任务物品"]
local openNpcDialog = ____UI_51FD_6570.openNpcDialog
local ____G_1 = _G
local addDelayedCallback = ____G_1.addDelayedCallback
local ____require_result_2 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____require_result_2.questManager
local function scheduleOpenDialogLater(self, player, data)
    addDelayedCallback(
        10,
        function()
            openNpcDialog(nil, player, data)
        end
    )
end
local function normalizeRequireCount(self, count)
    return count ~= nil and count > 1 and count or 1
end
local function refreshTaskUIForAllClientsSoon(self, playerId, questId)
    questManager:triggerUIRefresh(playerId, questId)
end
local function canAcceptQuestByRequirements(self, quest, hero)
    local req = quest["接取条件"]
    if not req or req == "" then
        return true
    end
    local lessMarkerA = "英雄等级<"
    local lessMarkerB = "英雄等级＜"
    local greaterMarkerA = "英雄等级>"
    local greaterMarkerB = "英雄等级＞"
    local isGreaterThan = false
    local pos = (string.find(req, lessMarkerA, nil, true) or 0) - 1
    local offset = #lessMarkerA
    if pos < 0 then
        pos = (string.find(req, lessMarkerB, nil, true) or 0) - 1
        offset = #lessMarkerB
    end
    if pos < 0 then
        pos = (string.find(req, greaterMarkerA, nil, true) or 0) - 1
        offset = #greaterMarkerA
        isGreaterThan = pos >= 0
    end
    if pos < 0 then
        pos = (string.find(req, greaterMarkerB, nil, true) or 0) - 1
        offset = #greaterMarkerB
        isGreaterThan = pos >= 0
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
    local level = jass.GetHeroLevel(hero)
    local ____isGreaterThan_3
    if isGreaterThan then
        ____isGreaterThan_3 = level > limit
    else
        ____isGreaterThan_3 = level < limit
    end
    return ____isGreaterThan_3
end
local function getQuestRewardDisplayText(self, quest)
    return resolveRewardDisplayText(quest)
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
                goto __continue30
            end
            local withoutOrder = trimOrderedPrefix(nil, trimmed)
            local parsed = tryParseSpeakerLine(nil, withoutOrder)
            if parsed then
                lines[#lines + 1] = {title = parsed.title, text = parsed.text, duration = 4}
                goto __continue30
            end
            lines[#lines + 1] = {title = npcName, text = trimmed, duration = 4}
        end
        ::__continue30::
    end
    return #lines > 0 and lines or ({{title = npcName, text = raw, duration = 4}})
end
function ____exports.buildDialogData(self, npcName, heroName)
    local dialogConfig = findDialogConfig(nil, npcName)
    if not dialogConfig then
        return {lines = {{title = npcName, text = "你好，有什么可以帮你的吗？", duration = 3}}, removeOverheadMarkerOnOpen = true}
    end
    return {
        lines = ____exports.parseDialogText(nil, dialogConfig["对话文本"] or "", npcName, heroName),
        removeOverheadMarkerOnOpen = true
    }
end
function ____exports.buildQuestCompletedDialog(self, quest, npcName)
    local msg = quest["完成后对白"] or quest["NPC完成对白"] or DEFAULT_AFTER_COMPLETE_MSG
    if msg == "默认" then
        msg = DEFAULT_AFTER_COMPLETE_MSG
    end
    return {lines = {{title = npcName, text = msg, duration = 4}}, removeOverheadMarkerOnOpen = true}
end
function ____exports.buildQuestOfferDialog(self, quest, npcName, dialogOwnerId, npcUnit, _____5BF9_8BDD_76EE_6807_5355_4F4D, ____NPC_914D_7F6E_671D_5411)
    local dialogOwner = jass.Player(dialogOwnerId)
    local ____dialogOwner_4
    if dialogOwner then
        ____dialogOwner_4 = getPlayerFirstHero(nil, dialogOwner)
    else
        ____dialogOwner_4 = nil
    end
    local ownerHero = ____dialogOwner_4
    local ____ownerHero_5
    if ownerHero then
        ____ownerHero_5 = jass.GetUnitName(ownerHero)
    else
        ____ownerHero_5 = "你"
    end
    local heroName = ____ownerHero_5
    local questDesc = quest["描述"] or quest["名称"] or "未知任务"
    local rewardText = getQuestRewardDisplayText(nil, quest)
    local startLines = quest["NPC开始对白"] and ____exports.parseDialogText(nil, quest["NPC开始对白"], npcName, heroName) or ({{
        title = npcName,
        text = "我有任务要交给你：" .. tostring(quest["名称"]),
        duration = 4
    }})
    return {
        lines = startLines,
        removeOverheadMarkerOnOpen = true,
        quest = {
            title = npcName,
            text = (((("【" .. tostring(quest["名称"])) .. "】\n\n") .. questDesc) .. "\n\n奖励：") .. rewardText,
            onAccept = function()
                local questId = quest["任务ID"] ~= nil and tostring(quest["任务ID"]) or ""
                local playerObj = jass.Player(dialogOwnerId)
                local ____playerObj_6
                if playerObj then
                    ____playerObj_6 = getPlayerFirstHero(nil, playerObj)
                else
                    ____playerObj_6 = nil
                end
                local hero = ____playerObj_6
                local currentNpcUnit = npcUnit or getDialogNpcUnit(dialogOwnerId)
                if not canAcceptQuestByRequirements(nil, quest, hero) then
                    local failRaw = quest["接取失败对白"] or "当前条件不满足，无法接受该任务。"
                    scheduleOpenDialogLater(
                        nil,
                        playerObj,
                        {
                            lines = ____exports.parseDialogText(nil, failRaw, npcName, heroName),
                            npcUnit = currentNpcUnit,
                            ["对话目标单位"] = _____5BF9_8BDD_76EE_6807_5355_4F4D,
                            ["NPC配置朝向"] = ____NPC_914D_7F6E_671D_5411,
                            removeOverheadMarkerOnOpen = false,
                            restoreYellowQuestMarkerAfterDialog = true
                        }
                    )
                    return
                end
                if not hasPlayerAcceptedQuest(nil, dialogOwnerId, questId) then
                    local playerName = jass.GetPlayerName(playerObj) or "冒险者"
                    setQuestState(
                        nil,
                        dialogOwnerId,
                        questId,
                        1,
                        playerName
                    )
                    _____53D1_653E_4EFB_52A1_7269_54C1(hero, quest["任务物品"])
                    if quest["接取后动作"] then
                        quest["接取后动作"](quest, dialogOwnerId)
                    end
                    refreshTaskUIForAllClientsSoon(nil, dialogOwnerId, questId)
                end
                local acceptedRaw = quest["任务接受对白"] or DEFAULT_QUEST_ACCEPTED_MSG
                local acceptedLines = ____exports.parseDialogText(nil, acceptedRaw, npcName, heroName)
                scheduleOpenDialogLater(
                    nil,
                    jass.Player(dialogOwnerId),
                    {
                        lines = acceptedLines,
                        npcUnit = currentNpcUnit,
                        ["对话目标单位"] = _____5BF9_8BDD_76EE_6807_5355_4F4D,
                        ["NPC配置朝向"] = ____NPC_914D_7F6E_671D_5411,
                        removeOverheadMarkerOnOpen = false,
                        applyGrayQuestMarkerAfterDialog = true
                    }
                )
                if hasPlayerAcceptedQuest(nil, dialogOwnerId, questId) then
                    showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r该任务已经接受过了")
                end
            end,
            onReject = function()
                local currentNpcUnit = npcUnit or getDialogNpcUnit(dialogOwnerId)
                showLocalHint(
                    nil,
                    dialogOwnerId,
                    ("|cffffff00『系统提示』：|r|cffff4444已拒绝任务 『" .. tostring(quest["名称"])) .. "』|r"
                )
                if currentNpcUnit then
                    scheduleYellowQuestMarkerAfterBubbleFade(nil, currentNpcUnit)
                end
            end
        }
    }
end
function ____exports.buildQuestInProgressDialog(self, quest, npcName, dialogOwnerId, npcUnit, _____5BF9_8BDD_76EE_6807_5355_4F4D, ____NPC_914D_7F6E_671D_5411)
    local dialogOwner = jass.Player(dialogOwnerId)
    local ____dialogOwner_7
    if dialogOwner then
        ____dialogOwner_7 = getPlayerFirstHero(nil, dialogOwner)
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
    local questDesc = quest["描述"] or quest["名称"] or ""
    local rewardText = getQuestRewardDisplayText(nil, quest)
    local requireCount = normalizeRequireCount(nil, quest["需求数量"])
    return {
        lines = {},
        quest = {
            title = npcName,
            text = (((((("【" .. tostring(quest["名称"])) .. "】进行中...\n\n任务目标：") .. questDesc) .. "\n进度：0/") .. tostring(requireCount)) .. "\n\n奖励：") .. rewardText,
            acceptText = "提交任务",
            rejectText = "暂时忽略",
            onAccept = function()
                local questIdStr = quest["任务ID"] ~= nil and tostring(quest["任务ID"]) or ""
                local currentNpcUnit = npcUnit or getDialogNpcUnit(dialogOwnerId)
                handleQuestSubmit(nil, {
                    quest = quest,
                    npcName = npcName,
                    heroName = heroName,
                    dialogOwnerId = dialogOwnerId,
                    npcUnit = currentNpcUnit,
                    ["对话目标单位"] = _____5BF9_8BDD_76EE_6807_5355_4F4D,
                    ["NPC配置朝向"] = ____NPC_914D_7F6E_671D_5411,
                    parseDialogText = ____exports.parseDialogText,
                    openDialog = openNpcDialog,
                    refreshTaskUIForAllClientsSoon = refreshTaskUIForAllClientsSoon
                })
                if currentNpcUnit and questIdStr ~= "" and hasPlayerAcceptedQuest(nil, dialogOwnerId, questIdStr) and not hasPlayerCompletedQuest(nil, dialogOwnerId, questIdStr) then
                    scheduleGrayQuestMarkerAfterBubbleFade(nil, currentNpcUnit)
                end
            end,
            onReject = function()
                local currentNpcUnit = npcUnit or getDialogNpcUnit(dialogOwnerId)
                if currentNpcUnit then
                    scheduleGrayQuestMarkerAfterBubbleFade(nil, currentNpcUnit)
                end
            end
        }
    }
end
return ____exports
