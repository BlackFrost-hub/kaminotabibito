local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
____exports.ROWS_PER_PAGE = 7
--- 相邻页在任务列表上错开的行数（原 3，改为 2 则每次翻页少滑一行）
____exports.ROWS_PER_SCROLL_STEP = 1
____exports.PAGE_VARIANT_COUNT = ____exports.ROWS_PER_PAGE + 1
function ____exports.questTypes(self)
    return {QuestType.MAIN, QuestType.SIDE, QuestType.DAILY}
end
function ____exports.createEmptyQuestIdList(self)
    local questIds = {}
    do
        local i = 0
        while i < ____exports.ROWS_PER_PAGE do
            questIds[#questIds + 1] = ""
            i = i + 1
        end
    end
    return questIds
end
function ____exports.buildObjectiveText(self, quest, index)
    local obj = quest.objectives[index + 1]
    if not obj then
        return ""
    end
    local mark = obj.completed and "|cffffcc00鈭�|r" or "|cffffcc00脳|r"
    local progressMarkerIndex = (string.find(obj.description, "N/", nil, true) or 0) - 1
    if progressMarkerIndex >= 0 then
        local progressText = (__TS__StringSubstring(obj.description, 0, progressMarkerIndex) .. tostring(obj.current)) .. __TS__StringSubstring(obj.description, progressMarkerIndex + 1)
        return (mark .. " ") .. progressText
    end
    return ((((((mark .. " ") .. obj.description) .. " (") .. tostring(obj.current)) .. "/") .. tostring(obj.required)) .. ")"
end
function ____exports.buildRewardText(self, quest)
    if not quest.rewards or #quest.rewards <= 0 then
        return ""
    end
    local descs = {}
    for ____, r in ipairs(quest.rewards) do
        if r.description and r.description ~= "" then
            descs[#descs + 1] = r.description
        end
    end
    if #descs == 0 then
        return ""
    end
    local rewardDesc = descs[1]
    do
        local i = 1
        while i < #descs do
            rewardDesc = rewardDesc .. "、" .. descs[i + 1]
            i = i + 1
        end
    end
    return ("|cffff9900任务奖励：|r|cffffcc00" .. rewardDesc) .. "|r"
end
function ____exports.buildInfoText(self, quest)
    local accepter = quest.accepterName
    local completer = quest.completerName
    if not accepter and not completer then
        return ""
    end
    local text = ""
    if accepter then
        text = text .. ("接受者：|cff00ccff【" .. accepter) .. "】|r"
    end
    if accepter and completer then
        text = text .. "|"
    end
    if completer then
        text = text .. ("完成者：|cff00ff66【" .. completer) .. "】|r"
    end
    return text
end
function ____exports.chunkQuests(self, quests)
    local pages = {}
    if #quests <= ____exports.ROWS_PER_PAGE then
        if #quests > 0 then
            pages[#pages + 1] = __TS__ArraySlice(quests, 0, ____exports.ROWS_PER_PAGE)
        end
        return pages
    end
    do
        local i = 0
        while i < #quests do
            local ____end = i + ____exports.ROWS_PER_PAGE
            if ____end >= #quests then
                local startIndex = #quests - ____exports.ROWS_PER_PAGE
                pages[#pages + 1] = __TS__ArraySlice(quests, startIndex > 0 and startIndex or 0, #quests)
                break
            end
            pages[#pages + 1] = __TS__ArraySlice(quests, i, ____end)
            i = i + ____exports.ROWS_PER_SCROLL_STEP
        end
    end
    return pages
end
function ____exports.findExpandedVariantIndex(self, page, expandedQuestId)
    if not expandedQuestId then
        return 0
    end
    do
        local i = 0
        while i < #page.questIds do
            if page.questIds[i + 1] == expandedQuestId then
                return i + 1
            end
            i = i + 1
        end
    end
    return 0
end
function ____exports.hideAllCategoryPages(self, categoryView, setVisible)
    setVisible(nil, categoryView.emptyText, false)
    for ____, page in ipairs(categoryView.pages) do
        for ____, variant in ipairs(page.variants) do
            setVisible(nil, variant.root, false)
        end
        setVisible(nil, page.root, false)
    end
end
function ____exports.showOnlyPageAndVariant(self, categoryView, pageIndex, variantIndex, setVisible)
    do
        local i = 0
        while i < #categoryView.pages do
            local page = categoryView.pages[i + 1]
            local isCurrentPage = i == pageIndex
            setVisible(nil, page.root, isCurrentPage)
            do
                local v = 0
                while v < #page.variants do
                    setVisible(nil, page.variants[v + 1].root, isCurrentPage and v == variantIndex)
                    v = v + 1
                end
            end
            i = i + 1
        end
    end
end
return ____exports
