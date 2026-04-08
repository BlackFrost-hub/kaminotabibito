local ____lualib = require("lualib_bundle")
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local Set = ____lualib.Set
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.03．任务UI拆分.01．任务UI常量")
local LIST_ITEM_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_ITEM_H
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local LIST_CONTENT_TOP_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTENT_TOP_INSET
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.03．任务UI拆分.02．任务UI辅助")
local EMPTY_TEXTS = ____02_FF0E_4EFB_52A1UI_8F85_52A9.EMPTY_TEXTS
local getQuestsForUI = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getQuestsForUI
function ____exports.getQuestItemHeight(self, quest, expanded)
    if not expanded then
        return LIST_ITEM_H * 0.4
    end
    local h = LIST_ITEM_H + #quest.objectives * 0.03 + (quest.timeLimit and quest.timeLimit > 0 and 0.02 or 0)
    if quest.description and quest.description ~= "" then
        h = h + 0.025
    end
    local rewardDesc = quest.rewards and #quest.rewards > 0 and table.concat(
        __TS__ArrayFilter(
            __TS__ArrayMap(
                quest.rewards,
                function(____, r) return r.description end
            ),
            function(____, d) return d and d ~= "" end
        ),
        "、"
    ) or ""
    if rewardDesc ~= "" then
        h = h + 0.025
    end
    if quest.accepterName or quest.completerName then
        h = h + 0.025
    end
    return h
end
function ____exports.calcTotalContentHeight(self, quests, isExpanded)
    local totalH = 0
    do
        local i = 0
        while i < #quests do
            do
                local __continue11
                repeat
                    local q = quests[i + 1]
                    if not q then
                        __continue11 = true
                        break
                    end
                    totalH = totalH + (____exports.getQuestItemHeight(
                        nil,
                        q,
                        isExpanded(nil, q.id)
                    ) + 0.01)
                    __continue11 = true
                until true
                if not __continue11 then
                    break
                end
            end
            i = i + 1
        end
    end
    return totalH
end
function ____exports.getMaxScroll(self, totalContentHeight)
    return math.max(0, totalContentHeight - LIST_VIEW_H)
end
function ____exports.clampScrollOffset(self, scrollOffset, maxScroll)
    return math.min(
        maxScroll,
        math.max(0, scrollOffset)
    )
end
function ____exports.isQuestRowFullyInsideView(self, rowTopRel, itemHeight, visibleTopRel, visibleBottomRel, eps)
    local itemTopRel = rowTopRel
    local itemBottomRel = rowTopRel - itemHeight
    return itemTopRel <= visibleTopRel + eps and itemBottomRel >= visibleBottomRel - eps
end
function ____exports.isDescendantOf(self, japi, frame, ancestor)
    if not frame or frame == 0 or not ancestor or ancestor == 0 then
        return false
    end
    local cur = frame
    do
        local i = 0
        while i < 64 do
            if cur == ancestor then
                return true
            end
            local ____temp_0
            if type(japi.DzFrameGetParent) == "function" then
                ____temp_0 = japi.DzFrameGetParent(cur)
            else
                ____temp_0 = 0
            end
            local p = ____temp_0
            if not p or p == 0 then
                return false
            end
            cur = p
            i = i + 1
        end
    end
    return false
end
function ____exports.isWheelTargetForTaskList(self, japi, getMouseFocus, listContainer, scrollBarFrame, scrollThumbFrame, scrollThumbHitBtn)
    local f = type(getMouseFocus) == "function" and getMouseFocus(nil) or 0
    if not f or f == 0 then
        return false
    end
    if listContainer and (f == listContainer or ____exports.isDescendantOf(nil, japi, f, listContainer)) then
        return true
    end
    if scrollBarFrame and (f == scrollBarFrame or ____exports.isDescendantOf(nil, japi, f, scrollBarFrame)) then
        return true
    end
    if scrollThumbFrame and (f == scrollThumbFrame or ____exports.isDescendantOf(nil, japi, f, scrollThumbFrame)) then
        return true
    end
    if scrollThumbHitBtn and f == scrollThumbHitBtn then
        return true
    end
    return false
end
function ____exports.computeNextScrollOffsetByWheel(self, getWheelDelta, currentOffset, totalContentHeight, listViewHeight)
    local delta = type(getWheelDelta) == "function" and getWheelDelta(nil) or 0
    if delta == 0 then
        return currentOffset
    end
    local step = LIST_ITEM_H + 0.01
    local maxScroll = math.max(0, totalContentHeight - listViewHeight)
    if delta > 0 then
        return math.max(0, currentOffset - step)
    end
    if delta < 0 then
        return math.min(maxScroll, currentOffset + step)
    end
    return currentOffset
end
function ____exports.updateScrollBarVisibility(self, japi, maxScroll, frames)
    local vis = maxScroll > 0
    local fn = japi.DzFrameShow
    if type(fn) ~= "function" then
        return
    end
    for ____, f in ipairs(frames) do
        if f and f ~= 0 then
            pcall(function () return fn(nil, f, vis) end
            )
        end
    end
end
function ____exports.calcVisibleQuestRows(self, quests, scrollOffset, isExpanded)
    local visibleRows = {}
    local visibleTopRel = LIST_CONTENT_TOP_INSET
    local visibleBottomRel = LIST_CONTENT_TOP_INSET - LIST_VIEW_H
    local EPS = 0.002
    local rowTopRel = LIST_CONTENT_TOP_INSET + scrollOffset
    do
        local i = 0
        while i < #quests do
            do
                local __continue40
                repeat
                    local q = quests[i + 1]
                    if not q then
                        __continue40 = true
                        break
                    end
                    local expanded = isExpanded(nil, q.id)
                    local itemHeight = ____exports.getQuestItemHeight(nil, q, expanded)
                    local fullyInside = ____exports.isQuestRowFullyInsideView(
                        nil,
                        rowTopRel,
                        itemHeight,
                        visibleTopRel,
                        visibleBottomRel,
                        EPS
                    )
                    if fullyInside then
                        visibleRows[#visibleRows + 1] = {quest = q, expanded = expanded, rowTopRel = rowTopRel, itemHeight = itemHeight}
                    end
                    rowTopRel = rowTopRel - (itemHeight + 0.01)
                    __continue40 = true
                until true
                if not __continue40 then
                    break
                end
            end
            i = i + 1
        end
    end
    return visibleRows
end
function ____exports.refreshTaskUIList(self, opts)
    local ____opts_1 = opts
    local currentPlayerId = ____opts_1.currentPlayerId
    local currentCategory = ____opts_1.currentCategory
    local scrollOffset = ____opts_1.scrollOffset
    local setScrollOffset = ____opts_1.setScrollOffset
    local setTotalContentHeight = ____opts_1.setTotalContentHeight
    local listContainer = ____opts_1.listContainer
    local expandedQuestIds = ____opts_1.expandedQuestIds
    local createTextLabel = ____opts_1.createTextLabel
    local FramePoint = ____opts_1.FramePoint
    local applyDzTextFontAndCenterAlignment = ____opts_1.applyDzTextFontAndCenterAlignment
    local pushListItemFrame = ____opts_1.pushListItemFrame
    local syncScrollThumb = ____opts_1.syncScrollThumb
    local updateScrollBarVis = ____opts_1.updateScrollBarVisibility
    local createListItem = ____opts_1.createListItem
    local quests = getQuestsForUI(nil, currentPlayerId, currentCategory)
    if #quests == 0 then
        setTotalContentHeight(nil, 0)
        setScrollOffset(nil, 0)
        local empty = createTextLabel(
            nil,
            "TaskEmpty",
            listContainer,
            EMPTY_TEXTS[currentCategory],
            {
                relativeTo = listContainer,
                point = FramePoint.CENTER,
                relativePoint = FramePoint.CENTER,
                x = 0,
                y = 0
            },
            {width = LIST_CONTAINER_W * 0.85, height = 0.08}
        )
        if empty then
            pushListItemFrame(nil, empty)
            applyDzTextFontAndCenterAlignment(nil, empty)
        end
        syncScrollThumb(nil, 0)
        updateScrollBarVis(nil, 0)
        return
    end
    local totalH = ____exports.calcTotalContentHeight(
        nil,
        quests,
        function(____, questId) return expandedQuestIds:has(questId) end
    )
    setTotalContentHeight(nil, totalH)
    local maxScroll = ____exports.getMaxScroll(nil, totalH)
    local clamped = ____exports.clampScrollOffset(nil, scrollOffset, maxScroll)
    setScrollOffset(nil, clamped)
    syncScrollThumb(nil, maxScroll)
    updateScrollBarVis(nil, maxScroll)
    local visibleRows = ____exports.calcVisibleQuestRows(
        nil,
        quests,
        clamped,
        function(____, questId) return expandedQuestIds:has(questId) end
    )
    do
        local i = 0
        while i < #visibleRows do
            do
                local __continue49
                repeat
                    local row = visibleRows[i + 1]
                    if not row then
                        __continue49 = true
                        break
                    end
                    createListItem(nil, row.quest, row.rowTopRel, row.expanded)
                    __continue49 = true
                until true
                if not __continue49 then
                    break
                end
            end
            i = i + 1
        end
    end
end
return ____exports
