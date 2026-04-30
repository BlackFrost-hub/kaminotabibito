--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.02．任务UI拆分.01．任务UI常量")
local LIST_ITEM_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_ITEM_H
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local LIST_CONTENT_TOP_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTENT_TOP_INSET
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.02．任务UI拆分.02．任务UI辅助")
local pcallDzFrameShow = ____02_FF0E_4EFB_52A1UI_8F85_52A9.pcallDzFrameShow
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local clampMin = ____require_result_0.clampMin
local clampRange = ____require_result_0.clampRange
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
    return clampMin(nil, totalContentHeight - LIST_VIEW_H, 0)
end
function ____exports.clampScrollOffset(self, scrollOffset, maxScroll)
    return clampRange(nil, scrollOffset, 0, maxScroll)
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
            local p = japi.DzFrameGetParent(cur)
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
function ____exports.isTaskScrollBarTrackHit(self, japi, getMouseFocus, scrollBarFrame, scrollThumbFrame, scrollThumbHitBtn)
    local f = type(getMouseFocus) == "function" and getMouseFocus(nil) or 0
    if not f or f == 0 then
        return false
    end
    if not scrollBarFrame or scrollBarFrame == 0 then
        return false
    end
    if not (f == scrollBarFrame or ____exports.isDescendantOf(nil, japi, f, scrollBarFrame)) then
        return false
    end
    if scrollThumbHitBtn and (f == scrollThumbHitBtn or ____exports.isDescendantOf(nil, japi, f, scrollThumbHitBtn)) then
        return false
    end
    if scrollThumbFrame and (f == scrollThumbFrame or ____exports.isDescendantOf(nil, japi, f, scrollThumbFrame)) then
        return false
    end
    return true
end
--- 滚动条显隐：内容不足一屏时 maxScroll 为 0，但仍应显示轨道与滑块（滑块贴顶/不可用），否则用户以为滚动条坏了。
-- 仅当当前分类下没有任何任务行（空列表占位）时隐藏。
function ____exports.updateScrollBarVisibility(self, japi, maxScroll, frames, hasQuestRows)
    local vis = hasQuestRows
    for ____, f in ipairs(frames) do
        if f and f ~= 0 then
            pcallDzFrameShow(nil, f, vis)
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
                    goto __continue49
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
            ::__continue49::
            i = i + 1
        end
    end
    return visibleRows
end
return ____exports
