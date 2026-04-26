--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local setText, hideFrames, renderQuestRowSlot, renderVariant, japi, OBJECTIVE_HEIGHT, FAIL_HEIGHT, DETAIL_HEIGHT, TITLE_HEIGHT, OBJECTIVE_START_OFFSET, QUEST_ROW_GAP, VIEW_BOTTOM_REL, VIEW_EPS
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local EMPTY_TEXTS = ____02_FF0E_4EFB_52A1UI_8F85_52A9.EMPTY_TEXTS
local getQuestsForUI = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getQuestsForUI
local getStatusText = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getStatusText
local isQuestWithRowIconLayout = ____02_FF0E_4EFB_52A1UI_8F85_52A9.isQuestWithRowIconLayout
local ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8 = require("系统.08．任务系统.04．任务UI拆分.03．任务UI列表与滚动")
local getQuestItemHeight = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.getQuestItemHeight
local isQuestRowFullyInsideView = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isQuestRowFullyInsideView
local ____04_FF0E_4EFB_52A1UI_6E32_67D3 = require("系统.08．任务系统.04．任务UI拆分.04．任务UI渲染")
local calcTaskListItemLayout = ____04_FF0E_4EFB_52A1UI_6E32_67D3.calcTaskListItemLayout
local resolveQuestRowIconPath = ____04_FF0E_4EFB_52A1UI_6E32_67D3.resolveQuestRowIconPath
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_ITEM_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_ITEM_H
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local LIST_CONTENT_TOP_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTENT_TOP_INSET
local QUEST_ROW_ICON_PAD_LEFT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_PAD_LEFT
local QUEST_ROW_ICON_Y_OFFSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_Y_OFFSET
local ____03_FF0EUI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local DZ_TEXT_ALIGN_LEFT = ____03_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_LEFT
local ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.11．任务UI列表控制辅助")
local ROWS_PER_PAGE = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.ROWS_PER_PAGE
local questTypes = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.questTypes
local createEmptyQuestIdList = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.createEmptyQuestIdList
local buildObjectiveText = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.buildObjectiveText
local buildRewardText = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.buildRewardText
local buildInfoText = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.buildInfoText
local chunkQuests = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.chunkQuests
local findExpandedVariantIndex = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.findExpandedVariantIndex
local hideAllCategoryPages = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.hideAllCategoryPages
local showOnlyPageAndVariant = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.showOnlyPageAndVariant
local ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA = require("系统.08．任务系统.04．任务UI拆分.17．任务UI列表帧构建")
local createCategory = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.createCategory
local ensurePage = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.ensurePage
local clearVariant = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.clearVariant
local clearPage = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.clearPage
local hideRowSlot = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.hideRowSlot
function setText(self, frame, text)
    if not frame or frame == 0 then
        return
    end
    if type(japi.DzFrameSetText) == "function" then
        japi.DzFrameSetText(frame, text)
    end
end
function ____exports.setVisible(self, frame, visible)
    if not frame or frame == 0 then
        return
    end
    if type(japi.DzFrameShow) == "function" then
        japi.DzFrameShow(frame, visible)
    end
end
function hideFrames(self, frames)
    for ____, frame in ipairs(frames) do
        ____exports.setVisible(nil, frame, false)
    end
end
function ____exports.handleTaskRowClick(self)
    local ____temp_0
    if type(japi.DzGetTriggerUIEventFrame) == "function" then
        ____temp_0 = japi.DzGetTriggerUIEventFrame()
    else
        ____temp_0 = 0
    end
    local frame = ____temp_0
    if not frame then
        return
    end
    local binding = ____exports.taskRowBindingByFrameId[frame]
    if not binding then
        return
    end
    local questId = binding.page.questIds[binding.rowIndex + 1]
    if not questId then
        return
    end
    local ____opt_1 = ____exports.currentTaskRowClickSound
    if ____opt_1 ~= nil then
        ____exports.currentTaskRowClickSound(nil)
    end
    local ____opt_3 = ____exports.currentTaskRowExpandHandler
    if ____opt_3 ~= nil then
        ____exports.currentTaskRowExpandHandler(nil, questId)
    end
end
--- 行按钮在 `ensurePage` 之后绑定，避免 `createHiddenButton` 注册期携带工厂闭包
function ____exports.bindTaskRowClickButtonsForPage(self, page)
    do
        local vi = 0
        while vi < #page.variants do
            local variant = page.variants[vi + 1]
            do
                local ri = 0
                while ri < #variant.rowSlots do
                    local ____opt_5 = variant.rowSlots[ri + 1]
                    local btn = ____opt_5 and ____opt_5.clickBtn or nil
                    if btn then
                        ____exports.taskRowBindingByFrameId[btn] = {page = page, rowIndex = ri}
                    end
                    ri = ri + 1
                end
            end
            vi = vi + 1
        end
    end
end
function renderQuestRowSlot(self, ctx, slot, quest, rowTopRel, expanded, parent)
    local itemH = getQuestItemHeight(nil, quest, expanded)
    local statusText = getStatusText(nil, quest.status)
    local showIcon = isQuestWithRowIconLayout(nil, quest)
    local ____calcTaskListItemLayout_result_7 = calcTaskListItemLayout(nil, showIcon)
    local rowWidth = ____calcTaskListItemLayout_result_7.rowWidth
    local rowLeftRel = ____calcTaskListItemLayout_result_7.rowLeftRel
    local iconHLayout = ____calcTaskListItemLayout_result_7.iconHLayout
    local textXRel = ____calcTaskListItemLayout_result_7.textXRel
    local listTextAlign = ____calcTaskListItemLayout_result_7.listTextAlign
    local textW = ____calcTaskListItemLayout_result_7.textW
    local titleText = ((((("|cffffff00【" .. quest.title) .. "】|r→发布NPC:|cff00ccff【") .. (quest.startNpc or "未知")) .. "】|r [") .. statusText) .. "]"
    ctx:setFramePointRelative(
        slot.backdrop,
        ctx.FramePoint.TOPLEFT,
        parent,
        ctx.FramePoint.TOPLEFT,
        rowLeftRel,
        rowTopRel
    )
    ctx:setFrameSize(slot.backdrop, {width = rowWidth, height = itemH})
    ____exports.setVisible(nil, slot.backdrop, true)
    ctx:setFramePointRelative(
        slot.title,
        ctx.FramePoint.TOPLEFT,
        parent,
        ctx.FramePoint.TOPLEFT,
        textXRel,
        rowTopRel - 0.005
    )
    ctx:setFrameSize(slot.title, {width = textW, height = TITLE_HEIGHT})
    setText(nil, slot.title, titleText)
    ctx:applyDzTextFontAndAlignment(slot.title, listTextAlign)
    ____exports.setVisible(nil, slot.title, true)
    ctx:setFramePointRelative(
        slot.clickBtn,
        ctx.FramePoint.TOPLEFT,
        parent,
        ctx.FramePoint.TOPLEFT,
        rowLeftRel,
        rowTopRel
    )
    ctx:setFrameSize(slot.clickBtn, {width = rowWidth, height = itemH})
    if slot.backdrop and ctx.setupTransparentGlueHitLayer then
        ctx:setupTransparentGlueHitLayer(slot.backdrop, slot.clickBtn)
    end
    ____exports.setVisible(nil, slot.clickBtn, true)
    if showIcon then
        ctx:setFramePointRelative(
            slot.icon,
            ctx.FramePoint.TOPLEFT,
            parent,
            ctx.FramePoint.TOPLEFT,
            rowLeftRel + QUEST_ROW_ICON_PAD_LEFT,
            rowTopRel - QUEST_ROW_ICON_Y_OFFSET
        )
        ctx:setFrameSize(slot.icon, {width = iconHLayout, height = iconHLayout})
        ctx:setFrameTexture(
            slot.icon,
            resolveQuestRowIconPath(nil, quest.icon)
        )
        ____exports.setVisible(nil, slot.icon, true)
    else
        ____exports.setVisible(nil, slot.icon, false)
    end
    hideFrames(nil, slot.objectiveFrames)
    ____exports.setVisible(nil, slot.failFrame, false)
    hideFrames(nil, slot.detailFrames)
    if not expanded then
        return
    end
    local y = rowTopRel - OBJECTIVE_START_OFFSET
    do
        local i = 0
        while i < #slot.objectiveFrames do
            do
                local frame = slot.objectiveFrames[i + 1] or 0
                local text = buildObjectiveText(nil, quest, i)
                if not frame or text == "" then
                    goto __continue65
                end
                ctx:setFramePointRelative(
                    frame,
                    ctx.FramePoint.TOPLEFT,
                    parent,
                    ctx.FramePoint.TOPLEFT,
                    textXRel,
                    y
                )
                ctx:setFrameSize(frame, {width = textW, height = OBJECTIVE_HEIGHT})
                setText(nil, frame, text)
                ctx:applyDzTextFontAndAlignment(frame, listTextAlign)
                ____exports.setVisible(nil, frame, true)
                y = y - OBJECTIVE_HEIGHT
            end
            ::__continue65::
            i = i + 1
        end
    end
    if quest.timeLimit and quest.timeLimit > 0 and slot.failFrame then
        ctx:setFramePointRelative(
            slot.failFrame,
            ctx.FramePoint.TOPLEFT,
            parent,
            ctx.FramePoint.TOPLEFT,
            textXRel,
            y
        )
        ctx:setFrameSize(slot.failFrame, {width = textW, height = FAIL_HEIGHT})
        setText(
            nil,
            slot.failFrame,
            ("|cffff4444失败:|r 时间限制 " .. tostring(quest.timeLimit)) .. "秒"
        )
        ctx:applyDzTextFontAndAlignment(slot.failFrame, listTextAlign)
        ____exports.setVisible(nil, slot.failFrame, true)
        y = y - FAIL_HEIGHT
    end
    local details = {
        quest.description and quest.description ~= "" and "|cffcccccc任务详情：|r" .. quest.description or "",
        buildRewardText(nil, quest),
        buildInfoText(nil, quest)
    }
    do
        local i = 0
        while i < #slot.detailFrames do
            do
                local frame = slot.detailFrames[i + 1] or 0
                local text = details[i + 1] or ""
                if not frame or text == "" then
                    goto __continue69
                end
                ctx:setFramePointRelative(
                    frame,
                    ctx.FramePoint.TOPLEFT,
                    parent,
                    ctx.FramePoint.TOPLEFT,
                    textXRel,
                    y
                )
                ctx:setFrameSize(frame, {width = textW, height = DETAIL_HEIGHT})
                setText(nil, frame, text)
                ctx:applyDzTextFontAndAlignment(frame, DZ_TEXT_ALIGN_LEFT)
                ____exports.setVisible(nil, frame, true)
                y = y - DETAIL_HEIGHT
            end
            ::__continue69::
            i = i + 1
        end
    end
end
function renderVariant(self, ctx, variant, pageQuests, expandedRowIndex)
    clearVariant(nil, variant, ____exports.setVisible)
    local parent = variant.root
    local rowTopRel = LIST_CONTENT_TOP_INSET
    if expandedRowIndex >= 0 then
        local probeTopRel = LIST_CONTENT_TOP_INSET
        do
            local rowIndex = 0
            while rowIndex <= expandedRowIndex do
                local quest = pageQuests[rowIndex + 1]
                if not quest then
                    break
                end
                local expanded = rowIndex == expandedRowIndex
                local itemH = getQuestItemHeight(nil, quest, expanded)
                if expanded then
                    local itemBottomRel = probeTopRel - itemH
                    if itemBottomRel < VIEW_BOTTOM_REL then
                        rowTopRel = rowTopRel + (VIEW_BOTTOM_REL - itemBottomRel)
                    end
                    break
                end
                probeTopRel = probeTopRel - (itemH + QUEST_ROW_GAP)
                rowIndex = rowIndex + 1
            end
        end
    end
    do
        local rowIndex = 0
        while rowIndex < ROWS_PER_PAGE do
            do
                local quest = pageQuests[rowIndex + 1]
                local slot = variant.rowSlots[rowIndex + 1]
                if not quest then
                    hideRowSlot(nil, slot, ____exports.setVisible)
                    goto __continue79
                end
                local expanded = rowIndex == expandedRowIndex
                local itemH = getQuestItemHeight(nil, quest, expanded)
                local fullyInside = isQuestRowFullyInsideView(
                    nil,
                    rowTopRel,
                    itemH,
                    LIST_CONTENT_TOP_INSET,
                    VIEW_BOTTOM_REL,
                    VIEW_EPS
                )
                if fullyInside then
                    renderQuestRowSlot(
                        nil,
                        ctx,
                        slot,
                        quest,
                        rowTopRel,
                        expanded,
                        parent
                    )
                else
                    hideRowSlot(nil, slot, ____exports.setVisible)
                end
                rowTopRel = rowTopRel - (itemH + QUEST_ROW_GAP)
            end
            ::__continue79::
            rowIndex = rowIndex + 1
        end
    end
    ____exports.setVisible(nil, variant.root, false)
end
japi = require("jass.japi")
____exports.currentTaskRowExpandHandler = nil
____exports.currentTaskRowClickSound = nil
____exports.taskRowBindingByFrameId = {}
--- `pcall` 单次槽位：任务 UI 列表控制内不会嵌套这些导出
local pcallTaskUIListCtx = nil
local function pcallRebuildTaskUIFacadeListPoolBody(self)
    local ctx = pcallTaskUIListCtx
    if not ctx.listContainer or not ctx.precreatedListPool then
        return
    end
    for ____, category in ipairs(questTypes(nil)) do
        local categoryView = ctx.precreatedListPool.categories[category]
        local quests = getQuestsForUI(nil, ctx.currentPlayerId, category)
        local pages = chunkQuests(nil, quests)
        categoryView.pageCount = #pages
        setText(nil, categoryView.emptyText, EMPTY_TEXTS[category])
        ____exports.setVisible(nil, categoryView.emptyText, false)
        do
            local pageIndex = 0
            while pageIndex < #pages do
                local page = ensurePage(
                    nil,
                    ctx,
                    categoryView,
                    category,
                    pageIndex,
                    ____exports.handleTaskRowClick
                )
                ____exports.bindTaskRowClickButtonsForPage(nil, page)
                local pageQuests = pages[pageIndex + 1] or ({})
                page.questIds = createEmptyQuestIdList(nil)
                do
                    local rowIndex = 0
                    while rowIndex < ROWS_PER_PAGE do
                        local quest = pageQuests[rowIndex + 1]
                        if quest ~= nil then
                            page.questIds[rowIndex + 1] = quest.id
                        end
                        rowIndex = rowIndex + 1
                    end
                end
                do
                    local variantIndex = 0
                    while variantIndex < #page.variants do
                        renderVariant(
                            nil,
                            ctx,
                            page.variants[variantIndex + 1],
                            pageQuests,
                            variantIndex - 1
                        )
                        ____exports.setVisible(nil, page.variants[variantIndex + 1].root, false)
                        variantIndex = variantIndex + 1
                    end
                end
                ____exports.setVisible(nil, page.root, false)
                pageIndex = pageIndex + 1
            end
        end
        do
            local pageIndex = #pages
            while pageIndex < #categoryView.pages do
                clearPage(nil, categoryView.pages[pageIndex + 1], ____exports.setVisible)
                pageIndex = pageIndex + 1
            end
        end
        ____exports.setVisible(nil, categoryView.root, false)
    end
end
local function pcallApplyTaskUIFacadeVisibleStateBody(self)
    local ctx = pcallTaskUIListCtx
    local pool = ctx.precreatedListPool
    if not pool then
        return
    end
    for ____, category in ipairs(questTypes(nil)) do
        do
            local categoryView = pool.categories[category]
            local isCurrentCategory = category == ctx.currentCategory
            ____exports.setVisible(nil, categoryView.root, isCurrentCategory)
            if not isCurrentCategory then
                goto __continue17
            end
            local pageCount = categoryView.pageCount
            if pageCount <= 0 then
                hideAllCategoryPages(nil, categoryView, ____exports.setVisible)
                ____exports.setVisible(nil, categoryView.emptyText, true)
                ctx:updateScrollBarVisibility(0, false)
                goto __continue17
            end
            ____exports.setVisible(nil, categoryView.emptyText, false)
            local clampedPage = math.max(
                0,
                math.min(
                    pageCount - 1,
                    ctx:getCurrentPage(category)
                )
            )
            local currentPage = categoryView.pages[clampedPage + 1]
            local expandedQuestId = ctx:getExpandedQuestId(category)
            local variantIndex = findExpandedVariantIndex(nil, currentPage, expandedQuestId)
            showOnlyPageAndVariant(
                nil,
                categoryView,
                clampedPage,
                variantIndex,
                ____exports.setVisible
            )
            ctx:updateScrollBarVisibility(pageCount, true)
        end
        ::__continue17::
    end
end
local function pcallApplyTaskUICategorySwitchVisibleStateBody(self)
    local ctx = pcallTaskUIListCtx
    local pool = ctx.precreatedListPool
    if not pool then
        return
    end
    for ____, category in ipairs(questTypes(nil)) do
        do
            local categoryView = pool.categories[category]
            local isCurrentCategory = category == ctx.currentCategory
            ____exports.setVisible(nil, categoryView.root, isCurrentCategory)
            if not isCurrentCategory then
                hideAllCategoryPages(nil, categoryView, ____exports.setVisible)
                goto __continue23
            end
            local pageCount = categoryView.pageCount
            if pageCount <= 0 then
                hideAllCategoryPages(nil, categoryView, ____exports.setVisible)
                ____exports.setVisible(nil, categoryView.emptyText, true)
                ctx:updateScrollBarVisibility(0, false)
                goto __continue23
            end
            ____exports.setVisible(nil, categoryView.emptyText, false)
            showOnlyPageAndVariant(
                nil,
                categoryView,
                0,
                0,
                ____exports.setVisible
            )
            ctx:updateScrollBarVisibility(pageCount, true)
        end
        ::__continue23::
    end
end
local function pcallApplyTaskUIExpandVisibleStateBody(self)
    local ctx = pcallTaskUIListCtx
    local pool = ctx.precreatedListPool
    if not pool then
        return
    end
    local categoryView = pool.categories[ctx.currentCategory]
    if not categoryView then
        return
    end
    local pageCount = categoryView.pageCount
    if pageCount <= 0 then
        ctx:updateScrollBarVisibility(0, false)
        return
    end
    local clampedPage = math.max(
        0,
        math.min(
            pageCount - 1,
            ctx:getCurrentPage(ctx.currentCategory)
        )
    )
    local currentPage = categoryView.pages[clampedPage + 1]
    if not currentPage then
        return
    end
    local expandedQuestId = ctx:getExpandedQuestId(ctx.currentCategory)
    local variantIndex = findExpandedVariantIndex(nil, currentPage, expandedQuestId)
    do
        local i = 0
        while i < #currentPage.variants do
            ____exports.setVisible(nil, currentPage.variants[i + 1].root, i == variantIndex)
            i = i + 1
        end
    end
end
local function pcallApplyTaskUIPageSwitchVisibleStateBody(self)
    local ctx = pcallTaskUIListCtx
    local pool = ctx.precreatedListPool
    if not pool then
        return
    end
    local categoryView = pool.categories[ctx.currentCategory]
    if not categoryView then
        return
    end
    local pageCount = categoryView.pageCount
    if pageCount <= 0 then
        hideAllCategoryPages(nil, categoryView, ____exports.setVisible)
        ____exports.setVisible(nil, categoryView.emptyText, true)
        ctx:updateScrollBarVisibility(0, false)
        return
    end
    ____exports.setVisible(nil, categoryView.emptyText, false)
    local clampedPage = math.max(
        0,
        math.min(
            pageCount - 1,
            ctx:getCurrentPage(ctx.currentCategory)
        )
    )
    showOnlyPageAndVariant(
        nil,
        categoryView,
        clampedPage,
        0,
        ____exports.setVisible
    )
    ctx:updateScrollBarVisibility(pageCount, true)
end
OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25
FAIL_HEIGHT = LIST_ITEM_H * 0.2
DETAIL_HEIGHT = LIST_ITEM_H * 0.22
TITLE_HEIGHT = LIST_ITEM_H * 0.38
OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35
QUEST_ROW_GAP = 0.01
VIEW_BOTTOM_REL = LIST_CONTENT_TOP_INSET - LIST_VIEW_H
VIEW_EPS = 0.002
function ____exports.createTaskUIPrecreatedListPool(self, ctx)
    if not ctx.listContainer then
        return nil
    end
    ____exports.currentTaskRowExpandHandler = ctx.toggleExpand
    ____exports.currentTaskRowClickSound = ctx.playClickSound
    return {categories = {
        [QuestType.MAIN] = createCategory(nil, ctx, QuestType.MAIN, ____exports.setVisible),
        [QuestType.SIDE] = createCategory(nil, ctx, QuestType.SIDE, ____exports.setVisible),
        [QuestType.DAILY] = createCategory(nil, ctx, QuestType.DAILY, ____exports.setVisible)
    }}
end
function ____exports.rebuildTaskUIFacadeListPool(self, ctx)
    pcallTaskUIListCtx = ctx
    pcall(pcallRebuildTaskUIFacadeListPoolBody)
    pcallTaskUIListCtx = nil
end
--- 设置行点击的回调，由管理器在创建池时调用
function ____exports.setTaskRowHandlers(self, expand, sound)
    ____exports.currentTaskRowExpandHandler = expand
    ____exports.currentTaskRowClickSound = sound
end
function ____exports.getTaskUICategoryPageCount(self, pool, category)
    if not pool then
        return 0
    end
    local ____opt_8 = pool.categories[category]
    return ____opt_8 and ____opt_8.pageCount or 0
end
function ____exports.applyTaskUIFacadeVisibleState(self, ctx)
    pcallTaskUIListCtx = ctx
    pcall(pcallApplyTaskUIFacadeVisibleStateBody)
    pcallTaskUIListCtx = nil
end
function ____exports.applyTaskUICategorySwitchVisibleState(self, ctx)
    pcallTaskUIListCtx = ctx
    pcall(pcallApplyTaskUICategorySwitchVisibleStateBody)
    pcallTaskUIListCtx = nil
end
function ____exports.applyTaskUIExpandVisibleState(self, ctx)
    pcallTaskUIListCtx = ctx
    pcall(pcallApplyTaskUIExpandVisibleStateBody)
    pcallTaskUIListCtx = nil
end
function ____exports.applyTaskUIPageSwitchVisibleState(self, ctx)
    pcallTaskUIListCtx = ctx
    pcall(pcallApplyTaskUIPageSwitchVisibleStateBody)
    pcallTaskUIListCtx = nil
end
return ____exports
