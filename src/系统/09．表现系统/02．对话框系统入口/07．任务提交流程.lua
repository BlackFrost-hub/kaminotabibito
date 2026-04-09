local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local ____exports = {}
local ____02_FF0EYDWE_51FD_6570 = require("lib.扩展函数.02．YDWE函数")
local getItemName = ____02_FF0EYDWE_51FD_6570.getItemName
local _____7269_54C1_5224_65AD_51FD_6570 = require("lib.扩展函数.物品相关函数.物品判断函数")
local ConsumeItemTypeCountByChargesBJ = _____7269_54C1_5224_65AD_51FD_6570.ConsumeItemTypeCountByChargesBJ
local GetItemTypeTotalCountByChargesBJ = _____7269_54C1_5224_65AD_51FD_6570.GetItemTypeTotalCountByChargesBJ
local ReturnItemToHeroOrDropBJ = _____7269_54C1_5224_65AD_51FD_6570.ReturnItemToHeroOrDropBJ
local UnitGetItemByTypeId = _____7269_54C1_5224_65AD_51FD_6570.UnitGetItemByTypeId
local UnitHasItemOfTypeBJ = _____7269_54C1_5224_65AD_51FD_6570.UnitHasItemOfTypeBJ
local ____01_FF0E_88C5_5907_6570_636E = require("系统.02．物品系统.01．装备数据")
local itemsData = ____01_FF0E_88C5_5907_6570_636E.default
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统入口.08．任务奖励执行")
local applyRewardWithContext = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.applyRewardWithContext
local getPlayerFirstHero = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local previewRewardMatchWithContext = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.previewRewardMatchWithContext
local ____01_FF0E_5E38_91CF_4E0E_5DE5_5177 = require("系统.09．表现系统.02．对话框系统入口.01．常量与工具")
local calculateFourCC = ____01_FF0E_5E38_91CF_4E0E_5DE5_5177.calculateFourCC
local showLocalHint = ____01_FF0E_5E38_91CF_4E0E_5DE5_5177.showLocalHint
local ____02_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统入口.02．任务状态")
local setQuestState = ____02_FF0E_4EFB_52A1_72B6_6001.setQuestState
local jass = require("jass.common")
local _____5C01_88C5_51FD_6570 = require("系统.00．核心系统.01．封装函数")
local function normalizeRequireCount(self, count)
    return count ~= nil and count > 1 and count or 1
end
local function tryConsumeRequiredResources(self, player, requiredResources, requireCount)
    if not requiredResources or requiredResources == "" then
        return true
    end
    local cost = normalizeRequireCount(nil, requireCount)
    if type(jass.GetPlayerState) ~= "function" or type(jass.SetPlayerState) ~= "function" then
        return false
    end
    local key = string.lower(requiredResources)
    if key == "wood" or key == "lumber" or requiredResources == "能量碎片" then
        local state = jass.PLAYER_STATE_RESOURCE_LUMBER
        local current = jass.GetPlayerState(player, state) or 0
        if current < cost then
            return false
        end
        jass.SetPlayerState(player, state, current - cost)
        return true
    end
    if key == "gold" then
        local state = jass.PLAYER_STATE_RESOURCE_GOLD
        local current = jass.GetPlayerState(player, state) or 0
        if current < cost then
            return false
        end
        jass.SetPlayerState(player, state, current - cost)
        return true
    end
    return false
end
local function isKillQuestObjectiveCompleted(self, playerId, questId, requireCount)
    local active = questDB:getPlayerActiveQuests(playerId)
    for ____, q in ipairs(active) do
        do
            local __continue11
            repeat
                if not q or q.id ~= questId then
                    __continue11 = true
                    break
                end
                if not q.objectives or #q.objectives == 0 then
                    return false
                end
                local current = 0
                local required = 0
                for ____, obj in ipairs(q.objectives) do
                    do
                        local __continue14
                        repeat
                            if not obj then
                                __continue14 = true
                                break
                            end
                            current = current + (obj.current or 0)
                            required = required + (obj.required or 0)
                            __continue14 = true
                        until true
                        if not __continue14 then
                            break
                        end
                    end
                end
                if required <= 0 then
                    required = requireCount > 0 and requireCount or 1
                end
                return current >= required
            until true
            if not __continue11 then
                break
            end
        end
    end
    return false
end
local function parseAllowedEquipLevels(self, requireItem)
    local out = __TS__New(Set)
    local marker = "装备等级:"
    local idx = (string.find(requireItem, marker, nil, true) or 0) - 1
    if idx < 0 then
        return out
    end
    local raw = __TS__StringTrim(__TS__StringSubstring(requireItem, idx + #marker))
    local parts = __TS__StringSplit(raw, ",")
    for ____, p in ipairs(parts) do
        local lv = __TS__StringTrim(p)
        if lv ~= "" then
            out:add(lv)
        end
    end
    return out
end
local function resolveSubmitItem(self, hero, requireItem)
    if not hero or not requireItem then
        return {itemId = 0, itemCode = "", itemLevel = ""}
    end
    if (string.find(requireItem, "装备等级:", nil, true) or 0) - 1 == 0 then
        do
            local slot = 0
            while slot < 6 do
                do
                    local __continue28
                    repeat
                        local ____temp_0
                        if type(jass.UnitItemInSlot) == "function" then
                            ____temp_0 = jass.UnitItemInSlot(hero, slot)
                        else
                            ____temp_0 = nil
                        end
                        local item = ____temp_0
                        if not item or type(jass.GetItemTypeId) ~= "function" then
                            __continue28 = true
                            break
                        end
                        local itemId = jass.GetItemTypeId(item)
                        local itemCode = _____5C01_88C5_51FD_6570:fourCCToString(itemId)
                        local data = itemsData[itemCode]
                        if not data then
                            __continue28 = true
                            break
                        end
                        if (data.type or "") ~= "道具/戒指/饰品" then
                            __continue28 = true
                            break
                        end
                        local level = data.level or ""
                        return {itemId = itemId, itemCode = itemCode, itemLevel = level}
                    until true
                    if not __continue28 then
                        break
                    end
                end
                slot = slot + 1
            end
        end
        return {itemId = 0, itemCode = "", itemLevel = ""}
    end
    if #requireItem == 4 then
        local itemId = calculateFourCC(nil, requireItem)
        local data = itemsData[requireItem]
        local ____itemId_4 = itemId
        local ____requireItem_5 = requireItem
        local ____opt_result_3
        if data ~= nil then
            ____opt_result_3 = data.level
        end
        return {itemId = ____itemId_4, itemCode = ____requireItem_5, itemLevel = ____opt_result_3 or ""}
    end
    if (string.find(requireItem, "|", nil, true) or 0) - 1 >= 0 then
        local parts = __TS__StringSplit(requireItem, "|")
        for ____, code in ipairs(parts) do
            do
                local __continue34
                repeat
                    local c = __TS__StringTrim(code)
                    if #c ~= 4 then
                        __continue34 = true
                        break
                    end
                    local testId = calculateFourCC(nil, c)
                    if UnitHasItemOfTypeBJ(nil, hero, testId) then
                        local data = itemsData[c]
                        local ____opt_result_8
                        if data ~= nil then
                            ____opt_result_8 = data.level
                        end
                        return {itemId = testId, itemCode = c, itemLevel = ____opt_result_8 or ""}
                    end
                    __continue34 = true
                until true
                if not __continue34 then
                    break
                end
            end
        end
    end
    return {itemId = 0, itemCode = "", itemLevel = ""}
end
local function isSubmitItemMatchedRequire(self, submitInfo, requireItem)
    if not requireItem or submitInfo.itemId == 0 then
        return false
    end
    if (string.find(requireItem, "装备等级:", nil, true) or 0) - 1 == 0 then
        local allowLevels = parseAllowedEquipLevels(nil, requireItem)
        return submitInfo.itemLevel ~= "" and allowLevels:has(submitInfo.itemLevel)
    end
    if #requireItem == 4 then
        return submitInfo.itemCode == requireItem
    end
    if (string.find(requireItem, "|", nil, true) or 0) - 1 >= 0 then
        local parts = __TS__StringSplit(requireItem, "|")
        for ____, p in ipairs(parts) do
            if __TS__StringTrim(p) == submitInfo.itemCode then
                return true
            end
        end
        return false
    end
    return false
end
local function pickNpcCompleteTextByBranch(self, raw, branchIndex)
    if not raw or raw == "" then
        return raw
    end
    if branchIndex < 0 then
        return raw
    end
    local lines = __TS__ArrayFilter(
        __TS__ArrayMap(
            __TS__StringSplit(raw, "\n"),
            function(____, s) return __TS__StringTrim(s) end
        ),
        function(____, s) return s ~= "" end
    )
    if branchIndex >= #lines then
        return raw
    end
    return lines[branchIndex + 1]
end
local function shouldUseGenericGiveFailHint(self, quest)
    if quest.type ~= "给予" then
        return false
    end
    if quest.rewardDisplay and quest.rewardDisplay ~= "" then
        return true
    end
    local reward = quest.reward or ""
    return (string.find(reward, ":", nil, true) or 0) - 1 >= 0
end
function ____exports.handleQuestSubmit(self, params)
    local ____params_9 = params
    local quest = ____params_9.quest
    local npcName = ____params_9.npcName
    local heroName = ____params_9.heroName
    local dialogOwnerId = ____params_9.dialogOwnerId
    local npcUnit = ____params_9.npcUnit
    local parseDialogText = ____params_9.parseDialogText
    local openDialog = ____params_9.openDialog
    local refreshTaskUIForAllClientsSoon = ____params_9.refreshTaskUIForAllClientsSoon
    local callbackOwner = jass.Player(dialogOwnerId)
    local ____callbackOwner_10
    if callbackOwner then
        ____callbackOwner_10 = getPlayerFirstHero(nil, callbackOwner)
    else
        ____callbackOwner_10 = nil
    end
    local hero = ____callbackOwner_10
    local requireItem = quest.requireItem
    local requiredResources = quest.requiredResources
    local requireCount = normalizeRequireCount(nil, quest.requireCount)
    local ____opt_11 = quest.requireID
    local questId = ____opt_11 and tostring(quest.requireID) or ""
    local playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) or "冒险者"
    local rewardBranchIndex = -1
    local useGenericGiveFailHint = shouldUseGenericGiveFailHint(nil, quest)
    if quest.type == "击杀" or quest.type == "目标击杀" then
        local done = isKillQuestObjectiveCompleted(nil, dialogOwnerId, questId, requireCount)
        if not done then
            showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r任务目标尚未完成，无法提交。")
            return
        end
    end
    local function broadcastQuestComplete(self)
        local rewardStr = quest.rewardDisplay or quest.reward or "无"
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
            local completeRaw = pickNpcCompleteTextByBranch(nil, quest.NpcCompleteText, rewardBranchIndex)
            local completeLines = parseDialogText(nil, completeRaw, npcName, heroName)
            openDialog(
                nil,
                jass.Player(dialogOwnerId),
                {lines = completeLines}
            )
        end
    end
    if requiredResources then
        local ok = tryConsumeRequiredResources(nil, callbackOwner, requiredResources, requireCount)
        if not ok then
            showLocalHint(
                nil,
                dialogOwnerId,
                (("|cffffff00『系统提示』：|r资源不足，提交需要 " .. requiredResources) .. " x ") .. tostring(requireCount)
            )
            return
        end
        setQuestState(nil, questId, 2, playerName)
        local rewardResult = applyRewardWithContext(nil, quest.reward or "", {triggerPlayerId = dialogOwnerId})
        rewardBranchIndex = rewardResult.matchedRuleIndex
        onComplete(nil)
        return
    end
    if requireItem then
        if not hero then
            showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444你没有英雄单位！|r")
            return
        end
        local ____temp_13
        if quest.type == "给予" then
            ____temp_13 = npcUnit
        else
            ____temp_13 = hero
        end
        local sourceUnit = ____temp_13
        if not sourceUnit then
            if useGenericGiveFailHint then
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。")
            else
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444未找到任务NPC单位，无法提交给予任务。|r")
            end
            return
        end
        local submitInfo = resolveSubmitItem(nil, sourceUnit, requireItem)
        local itemId = submitInfo.itemId
        if itemId == 0 then
            if useGenericGiveFailHint then
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。")
            else
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r没有检测到可提交的任务物品。")
            end
            return
        end
        if quest.type == "给予" and not isSubmitItemMatchedRequire(nil, submitInfo, requireItem) then
            local wrongItem = UnitGetItemByTypeId(nil, sourceUnit, itemId)
            if wrongItem then
                local back = ReturnItemToHeroOrDropBJ(nil, wrongItem, sourceUnit, hero)
                if useGenericGiveFailHint then
                    showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。")
                else
                    if back == "dropped" then
                        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交物品不符合条件，已返还并掉落在英雄脚下。")
                    else
                        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交物品不符合条件，已返还给你。")
                    end
                end
            else
                if useGenericGiveFailHint then
                    showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。")
                else
                    showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交物品不符合条件。")
                end
            end
            return
        end
        local itemCount = GetItemTypeTotalCountByChargesBJ(nil, sourceUnit, itemId)
        if itemCount >= requireCount then
            if quest.type == "给予" then
                local preview = previewRewardMatchWithContext(nil, quest.reward or "", {triggerPlayerId = dialogOwnerId, submittedItemId = submitInfo.itemCode, submittedItemLevel = submitInfo.itemLevel})
                if preview.matchedRuleIndex < 0 and (string.find(quest.reward or "", ":", nil, true) or 0) - 1 >= 0 then
                    local backItem = UnitGetItemByTypeId(nil, sourceUnit, itemId)
                    if backItem then
                        local back = ReturnItemToHeroOrDropBJ(nil, backItem, sourceUnit, hero)
                        if useGenericGiveFailHint then
                            showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。")
                        else
                            if back == "dropped" then
                                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r该物品不符合任务奖励条件，已返还并掉落在英雄脚下。")
                            else
                                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r该物品不符合任务奖励条件，已返还给你。")
                            end
                        end
                    else
                        if useGenericGiveFailHint then
                            showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。")
                        else
                            showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r该物品不符合任务奖励条件。")
                        end
                    end
                    return
                end
            end
            local consumed = ConsumeItemTypeCountByChargesBJ(nil, sourceUnit, itemId, requireCount)
            if consumed then
                setQuestState(nil, questId, 2, playerName)
                local rewardResult = applyRewardWithContext(nil, quest.reward or "", {triggerPlayerId = dialogOwnerId, submittedItemId = submitInfo.itemCode, submittedItemLevel = submitInfo.itemLevel})
                rewardBranchIndex = rewardResult.matchedRuleIndex
                onComplete(nil)
            else
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444物品次数扣除失败，请重试|r")
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
    local rewardResult = applyRewardWithContext(nil, quest.reward or "", {triggerPlayerId = dialogOwnerId})
    rewardBranchIndex = rewardResult.matchedRuleIndex
    onComplete(nil)
end
return ____exports
