local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_ITEM_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_ITEM_H
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local LIST_CONTENT_TOP_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTENT_TOP_INSET
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local EMPTY_TEXTS = ____02_FF0E_4EFB_52A1UI_8F85_52A9.EMPTY_TEXTS
local getQuestsForUI = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getQuestsForUI
local pcallDzFrameShow = ____02_FF0E_4EFB_52A1UI_8F85_52A9.pcallDzFrameShow
function ____exports.getQuestItemHeight(self, quest, expanded)
    if not expanded then
        return LIST_ITEM_H * 0.4
    end
    local h = LIST_ITEM_H + #quest.objectives * 0.03 + (quest.timeLimit and quest.timeLimit > 0 and 0.02 or 0)
    if quest.description and quest.description ~= "" then
        h = h + 0.025
    end
    local rewardDesc = ""
    if quest.rewards and #quest.rewards > 0 then
        local descs = {}
        for ____, r in ipairs(quest.rewards) do
            if r.description and r.description ~= "" then
                descs[#descs + 1] = r.description
            end
        end
        if #descs > 0 then
            rewardDesc = descs[1]
            do
                local i = 1
                while i < #descs do
                    rewardDesc = rewardDesc .. "、" .. descs[i + 1]
                    i = i + 1
                end
            end
        end
    end
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
                local q = quests[i + 1]
                if not q then
                    goto __continue16
                end
                totalH = totalH + (____exports.getQuestItemHeight(
                    nil,
                    q,
                    isExpanded(nil, q.id)
                ) + 0.01)
            end
            ::__continue16::
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
    if scrollThumbHitBtn and (f == scrollThumbHitBtn or ____exports.isDescendantOf(nil, japi, f, scrollThumbHitBtn)) then
        return true
    end
    return false
end
--- 分页滑块 thumb / 透明命中键（及子帧）：供全局鼠标拖拽判定（不含整条轨道）
function ____exports.isTaskScrollThumbDragHit(self, japi, getMouseFocus, scrollThumbFrame, scrollThumbHitBtn)
    local f = type(getMouseFocus) == "function" and getMouseFocus(nil) or 0
    if not f or f == 0 then
        return false
    end
    if scrollThumbHitBtn and (f == scrollThumbHitBtn or ____exports.isDescendantOf(nil, japi, f, scrollThumbHitBtn)) then
        return true
    end
    if scrollThumbFrame and (f == scrollThumbFrame or ____exports.isDescendantOf(nil, japi, f, scrollThumbFrame)) then
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
--- 滚动条显隐：内容不足一屏时 maxScroll 为 0，但仍应显示轨道与滑块（滑块贴顶/不可用），否则用户以为滚动条坏了。
-- 仅当当前分类下没有任何任务行（空列表占位）时隐藏。
function ____exports.updateScrollBarVisibility(self, japi, maxScroll, frames, hasQuestRows)
    local vis = hasQuestRows
    for ____, f in ipairs(frames) do
        if f and f ~= 0 then
            pcallDzFrameShow(nil, japi, f, vis)
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
                local q = quests[i + 1]
                if not q then
                    goto __continue47
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
            end
            ::__continue47::
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
        updateScrollBarVis(nil, 0, false)
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
    updateScrollBarVis(nil, maxScroll, true)
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
                local row = visibleRows[i + 1]
                if not row then
                    goto __continue56
                end
                createListItem(nil, row.quest, row.rowTopRel, row.expanded)
            end
            ::__continue56::
            i = i + 1
        end
    end
end
return ____exports
