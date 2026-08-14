local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__StringStartsWith = ____lualib.__TS__StringStartsWith
local ____exports = {}
local ____00_FF0EYDWE_51FD_6570 = require("lib.扩展函数.YDWE函数.00．YDWE函数")
local getItemName = ____00_FF0EYDWE_51FD_6570.getItemName
local _____7269_54C1_5224_65AD_51FD_6570 = require("lib.扩展函数.物品相关函数.物品判断函数")
local ConsumeItemTypeCountByChargesBJ = _____7269_54C1_5224_65AD_51FD_6570.ConsumeItemTypeCountByChargesBJ
local GetItemOfTypeFromUnitBJ = _____7269_54C1_5224_65AD_51FD_6570.GetItemOfTypeFromUnitBJ
local GetItemTypeTotalCountByChargesBJ = _____7269_54C1_5224_65AD_51FD_6570.GetItemTypeTotalCountByChargesBJ
local UnitHasItemOfTypeBJ = _____7269_54C1_5224_65AD_51FD_6570.UnitHasItemOfTypeBJ
local ____01_FF0E_88C5_5907_6570_636E = require("系统.02．物品系统.01．装备数据")
local itemsData = ____01_FF0E_88C5_5907_6570_636E.default
local _____88C5_5907_6570_636E_67E5_8BE2 = require("lib.扩展函数.物品相关函数.装备数据查询")
local findStatKey = _____88C5_5907_6570_636E_67E5_8BE2.findStatKey
local getItemDataEntry = _____88C5_5907_6570_636E_67E5_8BE2.getItemDataEntry
local getItemDataEntryByIdStr = _____88C5_5907_6570_636E_67E5_8BE2.getItemDataEntryByIdStr
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C = require("系统.09．表现系统.02．对话框系统.08．任务奖励执行")
local applyRewardWithContext = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.applyRewardWithContext
local getPlayerFirstHero = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.getPlayerFirstHero
local previewRewardMatchWithContext = ____08_FF0E_4EFB_52A1_5956_52B1_6267_884C.previewRewardMatchWithContext
local ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91 = require("系统.09．表现系统.02．对话框系统.02．对话框业务逻辑")
local showLocalHint = ____02_FF0E_5BF9_8BDD_6846_4E1A_52A1_903B_8F91.showLocalHint
local ____03_FF0E_4EFB_52A1_72B6_6001 = require("系统.09．表现系统.02．对话框系统.03．任务状态")
local findAvailableQuestByNpc = ____03_FF0E_4EFB_52A1_72B6_6001.findAvailableQuestByNpc
local resolveRewardDisplayText = ____03_FF0E_4EFB_52A1_72B6_6001.resolveRewardDisplayText
local setQuestState = ____03_FF0E_4EFB_52A1_72B6_6001.setQuestState
local _____4EFB_52A1_76EE_6807_662F_5426_5B8C_6210 = ____03_FF0E_4EFB_52A1_72B6_6001["任务目标是否完成"]
local ____09_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548 = require("系统.09．表现系统.02．对话框系统.09．NPC头顶与气泡特效")
local removeQuestMarkerAfterNpcTriggered = ____09_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.removeQuestMarkerAfterNpcTriggered
local scheduleYellowQuestMarkerAfterBubbleFade = ____09_FF0ENPC_5934_9876_4E0E_6C14_6CE1_7279_6548.scheduleYellowQuestMarkerAfterBubbleFade
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitRemoveItem = jass.UnitRemoveItem
local RemoveItem = jass.RemoveItem
local UnitAddItem = jass.UnitAddItem
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local fourCCToString = ____require_result_0.fourCCToString
local ____require_result_1 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
local _____6E05_7406_4EFB_52A1_7ED3_675FNPC = ____require_result_1["清理任务结束NPC"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_2.stringToFourCC
local ____require_result_3 = require("lib.扩展函数.物品相关函数.index")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_3["创建物品并注册排泄监听"]
local ____require_result_4 = require("系统.09．表现系统.02．对话框系统.14．任务物品发放")
local _____53D1_653E_4EFB_52A1_7269_54C1 = ____require_result_4["发放任务物品"]
local GetRandomInt = jass.GetRandomInt
local ____require_result_5 = require("系统.08．任务系统.02．任务管理器")
local _____4EFB_52A1_5185_90E8_9650_65F6_662F_5426_6709_6548 = ____require_result_5["任务内部限时是否有效"]
local ____G_6 = _G
local addDelayedCallback = ____G_6.addDelayedCallback
local function normalizeRequireCount(self, count)
    return count ~= nil and count > 1 and count or 1
end
local function _____67E5_627E_9996_4E2A_4EFB_52A1_7269_54C1_5347_7EA7(_____82F1_96C4, _____5347_7EA7_914D_7F6E)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or not _____5347_7EA7_914D_7F6E or _____5347_7EA7_914D_7F6E == "" then
        return nil
    end
    local _____5347_7EA7_89C4_5219_5217_8868 = __TS__StringSplit(_____5347_7EA7_914D_7F6E, "|")
    do
        local i = 0
        while i < #_____5347_7EA7_89C4_5219_5217_8868 do
            do
                local _____5347_7EA7_89C4_5219 = __TS__StringTrim(_____5347_7EA7_89C4_5219_5217_8868[i + 1])
                local _____5206_9694_4F4D_7F6E = (string.find(_____5347_7EA7_89C4_5219, ">", nil, true) or 0) - 1
                if _____5206_9694_4F4D_7F6E <= 0 then
                    goto __continue6
                end
                local _____539F_7269_54C1_7C7B_578BID = stringToFourCC(__TS__StringTrim(__TS__StringSubstring(_____5347_7EA7_89C4_5219, 0, _____5206_9694_4F4D_7F6E)))
                local _____65B0_7269_54C1_7C7B_578BID = stringToFourCC(__TS__StringTrim(__TS__StringSubstring(_____5347_7EA7_89C4_5219, _____5206_9694_4F4D_7F6E + 1)))
                if _____539F_7269_54C1_7C7B_578BID == 0 or _____65B0_7269_54C1_7C7B_578BID == 0 then
                    goto __continue6
                end
                local _____539F_7269_54C1 = GetItemOfTypeFromUnitBJ(_____82F1_96C4, _____539F_7269_54C1_7C7B_578BID)
                if _____539F_7269_54C1 ~= nil and _____539F_7269_54C1 ~= 0 then
                    return {["原物品"] = _____539F_7269_54C1, ["新物品类型ID"] = _____65B0_7269_54C1_7C7B_578BID}
                end
            end
            ::__continue6::
            i = i + 1
        end
    end
    return nil
end
local function _____6267_884C_4EFB_52A1_7269_54C1_5347_7EA7(_____82F1_96C4, _____5339_914D)
    local x = GetUnitX(_____82F1_96C4)
    local y = GetUnitY(_____82F1_96C4)
    local _____65B0_7269_54C1 = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(_____5339_914D["新物品类型ID"], x, y)
    if _____65B0_7269_54C1 == nil or _____65B0_7269_54C1 == 0 then
        return false
    end
    UnitRemoveItem(_____82F1_96C4, _____5339_914D["原物品"])
    RemoveItem(_____5339_914D["原物品"])
    UnitAddItem(_____82F1_96C4, _____65B0_7269_54C1)
    return true
end
local function tryConsumeRequiredResources(self, player, requiredResources, requireCount)
    if not requiredResources or requiredResources == "" then
        return true
    end
    local cost = normalizeRequireCount(nil, requireCount)
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
            if not q or q.id ~= questId then
                goto __continue19
            end
            if not q.objectives or #q.objectives == 0 then
                return false
            end
            local current = 0
            local required = 0
            for ____, obj in ipairs(q.objectives) do
                do
                    if not obj then
                        goto __continue22
                    end
                    current = current + (obj.current or 0)
                    required = required + (obj.required or 0)
                end
                ::__continue22::
            end
            if required <= 0 then
                required = requireCount > 0 and requireCount or 1
            end
            return current >= required
        end
        ::__continue19::
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
local function parseRequiredEquipStatKey(requireItem)
    local marker = "装备属性:"
    if (string.find(requireItem, marker, nil, true) or 0) - 1 ~= 0 then
        return ""
    end
    return findStatKey(__TS__StringTrim(__TS__StringSubstring(requireItem, #marker)))
end
local function resolveSubmitItem(self, hero, requireItem)
    if not hero or not requireItem then
        return {itemId = 0, itemCode = "", itemLevel = ""}
    end
    local requiredStatKey = parseRequiredEquipStatKey(requireItem)
    if requiredStatKey ~= "" then
        do
            local slot = 0
            while slot < 6 do
                do
                    local item = jass.UnitItemInSlot(hero, slot)
                    if not item then
                        goto __continue38
                    end
                    local data = getItemDataEntry(item)
                    if not data or type(data[requiredStatKey]) ~= "number" or data[requiredStatKey] <= 0 then
                        goto __continue38
                    end
                    local itemId = GetItemTypeId(item)
                    return {
                        itemId = itemId,
                        itemCode = fourCCToString(itemId),
                        itemLevel = data.level or ""
                    }
                end
                ::__continue38::
                slot = slot + 1
            end
        end
        return {itemId = 0, itemCode = "", itemLevel = ""}
    end
    if (string.find(requireItem, "装备等级:", nil, true) or 0) - 1 == 0 then
        do
            local slot = 0
            while slot < 6 do
                do
                    local item = jass.UnitItemInSlot(hero, slot)
                    if not item then
                        goto __continue43
                    end
                    local itemId = GetItemTypeId(item)
                    local itemCode = fourCCToString(itemId)
                    local data = itemsData[itemCode]
                    if not data then
                        goto __continue43
                    end
                    if (data.type or "") ~= "道具/戒指/饰品" then
                        goto __continue43
                    end
                    local level = data.level or ""
                    return {itemId = itemId, itemCode = itemCode, itemLevel = level}
                end
                ::__continue43::
                slot = slot + 1
            end
        end
        return {itemId = 0, itemCode = "", itemLevel = ""}
    end
    if #requireItem == 4 then
        local itemId = stringToFourCC(requireItem)
        local data = itemsData[requireItem]
        local itemLevel = data ~= nil and (data.level or "") or ""
        return {itemId = itemId, itemCode = requireItem, itemLevel = itemLevel}
    end
    if (string.find(requireItem, "|", nil, true) or 0) - 1 >= 0 then
        local parts = __TS__StringSplit(requireItem, "|")
        for ____, code in ipairs(parts) do
            do
                local c = __TS__StringTrim(code)
                if #c ~= 4 then
                    goto __continue49
                end
                local testId = stringToFourCC(c)
                if UnitHasItemOfTypeBJ(hero, testId) then
                    local data = itemsData[c]
                    local itemLevel = data ~= nil and (data.level or "") or ""
                    return {itemId = testId, itemCode = c, itemLevel = itemLevel}
                end
            end
            ::__continue49::
        end
    end
    return {itemId = 0, itemCode = "", itemLevel = ""}
end
local function isSubmitItemMatchedRequire(self, submitInfo, requireItem)
    if not requireItem or submitInfo.itemId == 0 then
        return false
    end
    local requiredStatKey = parseRequiredEquipStatKey(requireItem)
    if requiredStatKey ~= "" then
        local data = getItemDataEntryByIdStr(submitInfo.itemCode)
        return data ~= nil and type(data[requiredStatKey]) == "number" and data[requiredStatKey] > 0
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
local function _____89E3_6790_5206_522B_63D0_4EA4_7269_54C1_7C7B_578B(_____9700_6C42_7269_54C1)
    local _____7269_54C1_7C7B_578B_5217_8868 = {}
    local _____7269_54C1_4EE3_7801_5217_8868 = __TS__StringSplit(_____9700_6C42_7269_54C1, "|")
    do
        local i = 0
        while i < #_____7269_54C1_4EE3_7801_5217_8868 do
            do
                local _____7269_54C1_4EE3_7801 = __TS__StringTrim(_____7269_54C1_4EE3_7801_5217_8868[i + 1])
                if #_____7269_54C1_4EE3_7801 ~= 4 then
                    goto __continue64
                end
                local _____7269_54C1_7C7B_578BID = stringToFourCC(_____7269_54C1_4EE3_7801)
                if _____7269_54C1_7C7B_578BID ~= 0 then
                    _____7269_54C1_7C7B_578B_5217_8868[#_____7269_54C1_7C7B_578B_5217_8868 + 1] = _____7269_54C1_7C7B_578BID
                end
            end
            ::__continue64::
            i = i + 1
        end
    end
    return _____7269_54C1_7C7B_578B_5217_8868
end
local function _____67E5_627E_7F3A_5C11_7684_5206_522B_63D0_4EA4_7269_54C1(_____82F1_96C4, _____9700_6C42_7269_54C1)
    local _____7F3A_5C11_7269_54C1_540D_79F0_5217_8868 = {}
    local _____7269_54C1_4EE3_7801_5217_8868 = __TS__StringSplit(_____9700_6C42_7269_54C1, "|")
    do
        local i = 0
        while i < #_____7269_54C1_4EE3_7801_5217_8868 do
            do
                local _____7269_54C1_4EE3_7801 = __TS__StringTrim(_____7269_54C1_4EE3_7801_5217_8868[i + 1])
                if #_____7269_54C1_4EE3_7801 ~= 4 then
                    goto __continue69
                end
                local _____7269_54C1_7C7B_578BID = stringToFourCC(_____7269_54C1_4EE3_7801)
                if _____7269_54C1_7C7B_578BID == 0 or GetItemTypeTotalCountByChargesBJ(_____82F1_96C4, _____7269_54C1_7C7B_578BID) <= 0 then
                    _____7F3A_5C11_7269_54C1_540D_79F0_5217_8868[#_____7F3A_5C11_7269_54C1_540D_79F0_5217_8868 + 1] = getItemName(nil, _____7269_54C1_4EE3_7801) or "指定药剂"
                end
            end
            ::__continue69::
            i = i + 1
        end
    end
    return _____7F3A_5C11_7269_54C1_540D_79F0_5217_8868
end
local function _____6D88_8017_5206_522B_63D0_4EA4_7269_54C1_6B21_6570(_____82F1_96C4, _____9700_6C42_7269_54C1)
    local _____7269_54C1_7C7B_578B_5217_8868 = _____89E3_6790_5206_522B_63D0_4EA4_7269_54C1_7C7B_578B(_____9700_6C42_7269_54C1)
    if #_____7269_54C1_7C7B_578B_5217_8868 == 0 then
        return false
    end
    do
        local i = 0
        while i < #_____7269_54C1_7C7B_578B_5217_8868 do
            if GetItemTypeTotalCountByChargesBJ(_____82F1_96C4, _____7269_54C1_7C7B_578B_5217_8868[i + 1]) <= 0 then
                return false
            end
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #_____7269_54C1_7C7B_578B_5217_8868 do
            if not ConsumeItemTypeCountByChargesBJ(_____82F1_96C4, _____7269_54C1_7C7B_578B_5217_8868[i + 1], 1) then
                return false
            end
            i = i + 1
        end
    end
    return true
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
    if quest["类型"] ~= "给予" then
        return false
    end
    if quest["奖励显示"] and quest["奖励显示"] ~= "" then
        return true
    end
    local reward = quest["奖励"] or ""
    return (string.find(reward, ":", nil, true) or 0) - 1 >= 0
end
function ____exports.handleQuestSubmit(self, params)
    local ____params_7 = params
    local quest = ____params_7.quest
    local npcName = ____params_7.npcName
    local heroName = ____params_7.heroName
    local dialogOwnerId = ____params_7.dialogOwnerId
    local npcUnit = ____params_7.npcUnit
    local _____5BF9_8BDD_76EE_6807_5355_4F4D = ____params_7["对话目标单位"]
    local ____NPC_914D_7F6E_671D_5411 = ____params_7["NPC配置朝向"]
    local parseDialogText = ____params_7.parseDialogText
    local openDialog = ____params_7.openDialog
    local refreshTaskUIForAllClientsSoon = ____params_7.refreshTaskUIForAllClientsSoon
    local callbackOwner = jass.Player(dialogOwnerId)
    local ____callbackOwner_8
    if callbackOwner then
        ____callbackOwner_8 = getPlayerFirstHero(nil, callbackOwner)
    else
        ____callbackOwner_8 = nil
    end
    local hero = ____callbackOwner_8
    local requireItem = quest["需求物品"]
    local requiredResources = quest["需求资源"]
    local requireCount = normalizeRequireCount(nil, quest["需求数量"])
    local questId = quest["任务ID"] ~= nil and tostring(quest["任务ID"]) or ""
    local playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) or "冒险者"
    local _____5728_5185_90E8_9650_65F6_5185_5B8C_6210 = questId ~= "" and _____4EFB_52A1_5185_90E8_9650_65F6_662F_5426_6709_6548(questId)
    local rewardBranchIndex = -1
    local useGenericGiveFailHint = shouldUseGenericGiveFailHint(nil, quest)
    local _____5F85_6267_884C_7269_54C1_5347_7EA7 = nil
    local _____5F85_6D88_8017_63D0_4EA4_7269_54C1ID = 0
    local function _____53D1_653E_968F_673A_5956_52B1_7269_54C1()
        if not quest["随机奖励物品"] or quest["随机奖励物品"] == "" then
            return true
        end
        local _____5956_52B1_6C60 = __TS__StringSplit(quest["随机奖励物品"], "|")
        if #_____5956_52B1_6C60 == 0 then
            return true
        end
        local _____968F_673A_7269_54C1 = _____5956_52B1_6C60[GetRandomInt(0, #_____5956_52B1_6C60 - 1) + 1]
        return _____53D1_653E_4EFB_52A1_7269_54C1(hero, _____968F_673A_7269_54C1) > 0
    end
    local function _____6267_884C_5185_90E8_9650_65F6_989D_5916_5956_52B1()
        if not _____5728_5185_90E8_9650_65F6_5185_5B8C_6210 or not quest["限时完成奖励"] then
            return
        end
        applyRewardWithContext(nil, quest["限时完成奖励"], {triggerPlayerId = dialogOwnerId})
    end
    if quest["类型"] == "击杀" or quest["类型"] == "目标击杀" then
        local done = isKillQuestObjectiveCompleted(nil, dialogOwnerId, questId, requireCount)
        if not done then
            showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r任务目标尚未完成，无法提交。")
            return
        end
        if quest["提交物品升级"] then
            _____5F85_6267_884C_7269_54C1_5347_7EA7 = _____67E5_627E_9996_4E2A_4EFB_52A1_7269_54C1_5347_7EA7(hero, quest["提交物品升级"])
            if _____5F85_6267_884C_7269_54C1_5347_7EA7 == nil then
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r请携带任务要求的初级德鲁伊指引灯笼后再提交。")
                return
            end
        end
    end
    if quest["提交消耗物品"] then
        local _____63D0_4EA4_7269_54C1 = resolveSubmitItem(nil, hero, quest["提交消耗物品"])
        if _____63D0_4EA4_7269_54C1.itemId == 0 then
            local _____63D0_4EA4_7269_54C1_540D_79F0 = getItemName(nil, quest["提交消耗物品"]) or "任务要求的物品"
            showLocalHint(nil, dialogOwnerId, ("|cffffff00『系统提示』：|r请携带 |cffffcc00" .. _____63D0_4EA4_7269_54C1_540D_79F0) .. "|r 后再提交。")
            return
        end
        _____5F85_6D88_8017_63D0_4EA4_7269_54C1ID = _____63D0_4EA4_7269_54C1.itemId
    end
    local function broadcastQuestComplete(self)
        local rewardStr = resolveRewardDisplayText(quest)
        local rewardRule = quest["奖励"] or ""
        local isAll = not rewardRule or (string.find(rewardRule, "所有玩家", nil, true) or 0) - 1 ~= -1 or (string.find(rewardRule, "all", nil, true) or 0) - 1 ~= -1 or (string.find(rewardRule, "完成任务的玩家", nil, true) or 0) - 1 == -1 and (string.find(rewardRule, "Player", nil, true) or 0) - 1 == -1
        local targetLabel = isAll and "|cffffcc00所有玩家|r" or ("|cff00ccff" .. tostring(playerName)) .. "|r"
        local TARGET_PREFIXES = {"所有玩家", "完成任务的玩家", "Player"}
        local cleanReward = table.concat(
            __TS__ArrayFilter(
                __TS__ArrayMap(
                    __TS__StringSplit(
                        table.concat(
                            __TS__StringSplit(rewardStr, "\n"),
                            "；"
                        ),
                        ";"
                    ),
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
        local msg = (("|cffffff00『系统提示』：|r" .. ("|cff00ff66" .. tostring(playerName)) .. "|r") .. (" 完成了 |cffffcc00『" .. tostring(quest["名称"])) .. "』|r，") .. ((targetLabel .. " 获得了奖励：|cffff9900") .. cleanReward) .. "|r"
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
        if npcUnit then
            removeQuestMarkerAfterNpcTriggered(nil, npcUnit)
        end
        broadcastQuestComplete(nil)
        refreshTaskUIForAllClientsSoon(nil, dialogOwnerId, questId)
        local function _____6267_884C_4EFB_52A1_5B8C_6210_540E_52A8_4F5C()
            if quest["完成后动作"] then
                quest["完成后动作"](quest, dialogOwnerId)
            end
            _____6E05_7406_4EFB_52A1_7ED3_675FNPC(quest)
            if npcUnit and findAvailableQuestByNpc(npcName, dialogOwnerId) ~= nil then
                scheduleYellowQuestMarkerAfterBubbleFade(nil, npcUnit)
            end
        end
        if quest["NPC完成对白"] then
            local completeRaw = _____5728_5185_90E8_9650_65F6_5185_5B8C_6210 and quest["限时完成对白"] and quest["限时完成对白"] or pickNpcCompleteTextByBranch(nil, quest["NPC完成对白"], rewardBranchIndex)
            local completeLines = parseDialogText(nil, completeRaw, npcName, heroName)
            addDelayedCallback(
                10,
                function()
                    openDialog(
                        nil,
                        jass.Player(dialogOwnerId),
                        npcUnit and ({
                            lines = completeLines,
                            npcUnit = npcUnit,
                            ["对话目标单位"] = _____5BF9_8BDD_76EE_6807_5355_4F4D,
                            ["NPC配置朝向"] = ____NPC_914D_7F6E_671D_5411,
                            onFinish = _____6267_884C_4EFB_52A1_5B8C_6210_540E_52A8_4F5C
                        }) or ({lines = completeLines, onFinish = _____6267_884C_4EFB_52A1_5B8C_6210_540E_52A8_4F5C})
                    )
                end
            )
        else
            _____6267_884C_4EFB_52A1_5B8C_6210_540E_52A8_4F5C()
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
        setQuestState(
            nil,
            dialogOwnerId,
            questId,
            2,
            playerName
        )
        local rewardResult = applyRewardWithContext(nil, quest["奖励"] or "", {triggerPlayerId = dialogOwnerId})
        rewardBranchIndex = rewardResult.matchedRuleIndex
        _____6267_884C_5185_90E8_9650_65F6_989D_5916_5956_52B1()
        onComplete(nil)
        return
    end
    if requireItem then
        if not hero then
            showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444你没有英雄单位！|r")
            return
        end
        local sourceUnit = hero
        if quest["需求物品分别提交"] == true then
            local _____7F3A_5C11_7269_54C1_540D_79F0_5217_8868 = _____67E5_627E_7F3A_5C11_7684_5206_522B_63D0_4EA4_7269_54C1(sourceUnit, requireItem)
            if #_____7F3A_5C11_7269_54C1_540D_79F0_5217_8868 > 0 then
                showLocalHint(
                    nil,
                    dialogOwnerId,
                    ("|cffffff00『系统提示』：|r还缺少：|cffff9900" .. table.concat(_____7F3A_5C11_7269_54C1_540D_79F0_5217_8868, "、")) .. "|r"
                )
                return
            end
            if not _____6D88_8017_5206_522B_63D0_4EA4_7269_54C1_6B21_6570(sourceUnit, requireItem) then
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444药剂次数扣除失败，请重试|r")
                return
            end
            setQuestState(
                nil,
                dialogOwnerId,
                questId,
                2,
                playerName
            )
            local rewardResult = applyRewardWithContext(nil, quest["奖励"] or "", {triggerPlayerId = dialogOwnerId})
            rewardBranchIndex = rewardResult.matchedRuleIndex
            _____6267_884C_5185_90E8_9650_65F6_989D_5916_5956_52B1()
            onComplete(nil)
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
        if quest["类型"] == "给予" and not isSubmitItemMatchedRequire(nil, submitInfo, requireItem) then
            if useGenericGiveFailHint then
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。")
            else
                showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交物品不符合条件。")
            end
            return
        end
        local itemCount = GetItemTypeTotalCountByChargesBJ(sourceUnit, itemId)
        if itemCount >= requireCount then
            if quest["类型"] == "给予" then
                local preview = previewRewardMatchWithContext(nil, quest["奖励"] or "", {triggerPlayerId = dialogOwnerId, submittedItemId = submitInfo.itemCode, submittedItemLevel = submitInfo.itemLevel})
                if preview.matchedRuleIndex < 0 and (string.find(quest["奖励"] or "", ":", nil, true) or 0) - 1 >= 0 then
                    if useGenericGiveFailHint then
                        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。")
                    else
                        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r该物品不符合任务奖励条件。")
                    end
                    return
                end
            end
            local consumed = ConsumeItemTypeCountByChargesBJ(sourceUnit, itemId, requireCount)
            if consumed then
                setQuestState(
                    nil,
                    dialogOwnerId,
                    questId,
                    2,
                    playerName
                )
                local rewardResult = applyRewardWithContext(nil, quest["奖励"] or "", {triggerPlayerId = dialogOwnerId, submittedItemId = submitInfo.itemCode, submittedItemLevel = submitInfo.itemLevel})
                rewardBranchIndex = rewardResult.matchedRuleIndex
                _____6267_884C_5185_90E8_9650_65F6_989D_5916_5956_52B1()
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
    if quest["类型"] == "调查" and not _____4EFB_52A1_76EE_6807_662F_5426_5B8C_6210(dialogOwnerId, questId) then
        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r调查线索尚未全部确认，暂时无法提交任务。\n请继续在目标地点附近使用环境互动。")
        return
    end
    if quest["类型"] == "防守" and not _____4EFB_52A1_76EE_6807_662F_5426_5B8C_6210(dialogOwnerId, questId) then
        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r花灵守护尚未完成，暂时无法提交任务。")
        return
    end
    if _____5F85_6267_884C_7269_54C1_5347_7EA7 ~= nil and not _____6267_884C_4EFB_52A1_7269_54C1_5347_7EA7(hero, _____5F85_6267_884C_7269_54C1_5347_7EA7) then
        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r灯笼升级失败，请重试。")
        return
    end
    if _____5F85_6D88_8017_63D0_4EA4_7269_54C1ID ~= 0 and not ConsumeItemTypeCountByChargesBJ(hero, _____5F85_6D88_8017_63D0_4EA4_7269_54C1ID, 1) then
        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r任务物品删除失败，请重试。")
        return
    end
    if quest["奖励物品"] and _____53D1_653E_4EFB_52A1_7269_54C1(hero, quest["奖励物品"]) <= 0 then
        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r任务奖励物品发放失败，请重试。")
        return
    end
    if not _____53D1_653E_968F_673A_5956_52B1_7269_54C1() then
        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r随机任务奖励物品发放失败，请重试。")
        return
    end
    if _____5728_5185_90E8_9650_65F6_5185_5B8C_6210 and quest["限时完成奖励物品"] and _____53D1_653E_4EFB_52A1_7269_54C1(hero, quest["限时完成奖励物品"]) <= 0 then
        showLocalHint(nil, dialogOwnerId, "|cffffff00『系统提示』：|r限时奖励物品发放失败，请重试。")
        return
    end
    setQuestState(
        nil,
        dialogOwnerId,
        questId,
        2,
        playerName
    )
    local rewardResult = applyRewardWithContext(nil, quest["奖励"] or "", {triggerPlayerId = dialogOwnerId})
    rewardBranchIndex = rewardResult.matchedRuleIndex
    _____6267_884C_5185_90E8_9650_65F6_989D_5916_5956_52B1()
    onComplete(nil)
end
return ____exports
