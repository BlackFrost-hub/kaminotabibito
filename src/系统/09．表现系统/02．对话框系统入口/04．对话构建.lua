local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local ____03_FF0EBJ_51FD_6570 = require("lib.扩展函数.03．BJ函数")
local GetItemTypeCountInUnitBJ = ____03_FF0EBJ_51FD_6570.GetItemTypeCountInUnitBJ
local RemoveItemTypeFromUnitBJ = ____03_FF0EBJ_51FD_6570.RemoveItemTypeFromUnitBJ
local ____02_FF0EYDWE_51FD_6570 = require("lib.扩展函数.02．YDWE函数")
local getItemName = ____02_FF0EYDWE_51FD_6570.getItemName
local ____03_FF0E_4EFB_52A1UI = require("系统.08．任务系统.03．任务UI")
local taskUI = ____03_FF0E_4EFB_52A1UI.taskUI
local ____01_FF0E_5E38_91CF_4E0E_5DE5_5177 = require("系统.09．表现系统.02．对话框系统入口.01．常量与工具")
local DEFAULT_AFTER_COMPLETE_MSG = ____01_FF0E_5E38_91CF_4E0E_5DE5_5177.DEFAULT_AFTER_COMPLETE_MSG
local DEFAULT_QUEST_ACCEPTED_MSG = ____01_FF0E_5E38_91CF_4E0E_5DE5_5177.DEFAULT_QUEST_ACCEPTED_MSG
local calculateFourCC = ____01_FF0E_5E38_91CF_4E0E_5DE5_5177.calculateFourCC
local giveQuestReward = ____01_FF0E_5E38_91CF_4E0E_5DE5_5177.giveQuestReward
local showLocalHint = ____01_FF0E_5E38_91CF_4E0E_5DE5_5177.showLocalHint
local ____03_FF0E_914D_7F6E_67E5_8BE2 = require("系统.09．表现系统.02．对话框系统入口.03．配置查询")
local findDialogConfig = ____03_FF0E_914D_7F6E_67E5_8BE2.findDialogConfig
local ____02_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统入口.02．任务状态")
local hasPlayerAcceptedQuest = ____02_FF0E_4EFB_52A1_72B6_6001.hasPlayerAcceptedQuest
local setQuestState = ____02_FF0E_4EFB_52A1_72B6_6001.setQuestState
local jass = require("jass.common")
local ____UI_51FD_6570 = require("系统.00．核心系统.06．UI函数")
local _____4FBF_6377_51FD_6570 = require("系统.00．核心系统.11．便捷函数（偶尔用）")
local openNpcDialog = ____UI_51FD_6570.openNpcDialog
local function refreshTaskUIForAllClientsSoon(self)
    local t = jass.CreateTimer()
    jass.TimerStart(
        t,
        0.03,
        false,
        function()
            pcall(function () return taskUI:refreshList() end
            )
            jass.PauseTimer(t)
            jass.DestroyTimer(t)
        end
    )
end
function ____exports.parseDialogText(self, raw, npcName, heroName)
    local lines = {}
    local parts = __TS__StringSplit(raw, "\n")
    for ____, part in ipairs(parts) do
        do
            local __continue6
            repeat
                local trimmed = __TS__StringTrim(part)
                if not trimmed then
                    __continue6 = true
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
                        __continue6 = true
                        break
                    end
                end
                lines[#lines + 1] = {title = npcName, text = trimmed, duration = 4}
                __continue6 = true
            until true
            if not __continue6 then
                break
            end
        end
    end
    return #lines > 0 and lines or ({{title = npcName, text = raw, duration = 4}})
end
function ____exports.buildDialogData(self, npcName, heroName)
    local dialogConfig = findDialogConfig(nil, npcName)
    if not dialogConfig then
        return {lines = {{title = npcName, text = "你好，有什么可以帮你的吗？", duration = 3}}}
    end
    return {lines = ____exports.parseDialogText(nil, dialogConfig.text or "", npcName, heroName)}
end
function ____exports.buildQuestCompletedDialog(self, quest, npcName)
    local msg = quest.afterCompleteDialog or quest.NpcCompleteText or DEFAULT_AFTER_COMPLETE_MSG
    if msg == "默认" then
        msg = DEFAULT_AFTER_COMPLETE_MSG
    end
    return {lines = {{title = npcName, text = msg, duration = 4}}}
end
function ____exports.buildQuestOfferDialog(self, quest, npcName, dialogOwnerId)
    local dialogOwner = jass.Player(dialogOwnerId)
    local ____dialogOwner_0
    if dialogOwner then
        ____dialogOwner_0 = _____4FBF_6377_51FD_6570:getPlayerFirstHero(dialogOwner)
    else
        ____dialogOwner_0 = nil
    end
    local ownerHero = ____dialogOwner_0
    local ____ownerHero_1
    if ownerHero then
        ____ownerHero_1 = jass.GetUnitName(ownerHero)
    else
        ____ownerHero_1 = "你"
    end
    local heroName = ____ownerHero_1
    local questDesc = quest.desc or quest.name or "未知任务"
    local rewardText = quest.reward or "无"
    local startLines = quest.NpcStartText and ____exports.parseDialogText(nil, quest.NpcStartText, npcName, heroName) or ({{
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
                local ____opt_2 = quest.requireID
                local questId = ____opt_2 and tostring(quest.requireID) or ""
                if not hasPlayerAcceptedQuest(nil, 0, questId) then
                    local playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) or "冒险者"
                    setQuestState(nil, questId, 1, playerName)
                    refreshTaskUIForAllClientsSoon(nil)
                end
                local acceptedRaw = quest.QuestAcceptedMsg or DEFAULT_QUEST_ACCEPTED_MSG
                local acceptedLines = ____exports.parseDialogText(nil, acceptedRaw, npcName, heroName)
                openNpcDialog(
                    nil,
                    jass.Player(dialogOwnerId),
                    {lines = acceptedLines}
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
            end
        }
    }
end
function ____exports.buildQuestInProgressDialog(self, quest, npcName, dialogOwnerId)
    local dialogOwner = jass.Player(dialogOwnerId)
    local ____dialogOwner_4
    if dialogOwner then
        ____dialogOwner_4 = _____4FBF_6377_51FD_6570:getPlayerFirstHero(dialogOwner)
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
    local ____opt_6 = quest.requireID
    local questId = ____opt_6 and tostring(quest.requireID) or ""
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
                local ____callbackOwner_8
                if callbackOwner then
                    ____callbackOwner_8 = _____4FBF_6377_51FD_6570:getPlayerFirstHero(callbackOwner)
                else
                    ____callbackOwner_8 = nil
                end
                local hero = ____callbackOwner_8
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
                    refreshTaskUIForAllClientsSoon(nil)
                    if quest.NpcCompleteText then
                        local completeLines = ____exports.parseDialogText(nil, quest.NpcCompleteText, npcName, heroName)
                        openNpcDialog(
                            nil,
                            jass.Player(dialogOwnerId),
                            {lines = completeLines}
                        )
                    end
                end
                if requireItem then
                    if not hero then
                        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444你没有英雄单位！|r")
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
                            showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444物品扣除失败，请重试|r")
                        end
                    else
                        local itemDisplayName = getItemName(nil, requireItem) or requireItem
                        showLocalHint(
                            nil,
                            dialogOwnerId,
                            ((((("|cffffff00『系统提示』：|r你只有 |cffff9900" .. tostring(itemCount)) .. "|r 个 |cffffcc00") .. itemDisplayName) .. "|r，还需要 |cffff4444") .. tostring(requireCount - itemCount)) .. "|r 个"
                        )
                    end
                    return
                end
                setQuestState(nil, questId, 2, playerName)
                giveQuestReward(nil, quest.reward or "", dialogOwnerId)
                onComplete(nil)
            end,
            onReject = function()
            end
        }
    }
end
function ____exports.getVillageChiefDialog(self)
    local config = findDialogConfig(nil, "村长")
    if not config then
        config = findDialogConfig(nil, "精灵村NPC001")
    end
    if config then
        local npcName = config.npc or "NPC"
        return {lines = ____exports.parseDialogText(nil, config.text or "", npcName, "你")}
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
return ____exports
