--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local setText, hideFrames, renderQuestRowSlot, renderVariant, japi, OBJECTIVE_HEIGHT, FAIL_HEIGHT, DETAIL_HEIGHT, TITLE_HEIGHT, OBJECTIVE_START_OFFSET, QUEST_ROW_GAP, VIEW_BOTTOM_REL, VIEW_EPS
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.02．任务UI拆分.02．任务UI辅助")
local EMPTY_TEXTS = ____02_FF0E_4EFB_52A1UI_8F85_52A9.EMPTY_TEXTS
local getQuestsForUI = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getQuestsForUI
local getStatusText = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getStatusText
local isQuestWithRowIconLayout = ____02_FF0E_4EFB_52A1UI_8F85_52A9.isQuestWithRowIconLayout
local ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8 = require("系统.08．任务系统.02．任务UI拆分.03．任务UI列表与滚动")
local getQuestItemHeight = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.getQuestItemHeight
local isQuestRowFullyInsideView = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isQuestRowFullyInsideView
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.02．任务UI拆分.01．任务UI常量")
local LIST_ITEM_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_ITEM_H
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local LIST_CONTENT_TOP_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTENT_TOP_INSET
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local LIST_CONTENT_LEFT_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTENT_LEFT_INSET
local QUEST_ROW_ICON_PAD_LEFT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_PAD_LEFT
local QUEST_ROW_ICON_Y_OFFSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_Y_OFFSET
local QUEST_ROW_ICON_HEIGHT_FACTOR = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_HEIGHT_FACTOR
local QUEST_ROW_TEXT_GAP_AFTER_ICON = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_TEXT_GAP_AFTER_ICON
local ____03_FF0EUI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local DZ_TEXT_ALIGN_LEFT = ____03_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_LEFT
local DZ_TEXT_ALIGN_CENTER = ____03_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_CENTER
local ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9 = require("系统.08．任务系统.02．任务UI拆分.10．任务UI列表控制辅助")
local ROWS_PER_PAGE = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.ROWS_PER_PAGE
local questTypes = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.questTypes
local createEmptyQuestIdList = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.createEmptyQuestIdList
local buildObjectiveText = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.buildObjectiveText
local buildRewardText = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.buildRewardText
local buildInfoText = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.buildInfoText
local chunkQuests = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.chunkQuests
local findExpandedVariantIndex = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.findExpandedVariantIndex
local hideAllCategoryPages = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.hideAllCategoryPages
local showOnlyPageAndVariant = ____10_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.showOnlyPageAndVariant
local ____14_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA = require("系统.08．任务系统.02．任务UI拆分.14．任务UI列表帧构建")
local clearVariant = ____14_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.clearVariant
local clearPage = ____14_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.clearPage
local hideRowSlot = ____14_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.hideRowSlot
function ____exports.calcTaskListItemLayout(self, showMainRowIcon)
    local rowWidth = LIST_CONTAINER_W * 0.9
    local rowLeftRel = LIST_CONTENT_LEFT_INSET
    local collapsedMainRowH = LIST_ITEM_H * 0.4
    local iconHLayout = showMainRowIcon and collapsedMainRowH * QUEST_ROW_ICON_HEIGHT_FACTOR or 0
    local textXRel = showMainRowIcon and rowLeftRel + QUEST_ROW_ICON_PAD_LEFT + iconHLayout + QUEST_ROW_TEXT_GAP_AFTER_ICON or rowLeftRel + 0.03
    local listTextAlign = showMainRowIcon and DZ_TEXT_ALIGN_LEFT or DZ_TEXT_ALIGN_CENTER
    local rowTitleRightInset = 0.01
    local textW = rowWidth - (textXRel - rowLeftRel) - rowTitleRightInset
    return {
        rowWidth = rowWidth,
        rowLeftRel = rowLeftRel,
        iconHLayout = iconHLayout,
        textXRel = textXRel,
        listTextAlign = listTextAlign,
        textW = textW
    }
end
function ____exports.resolveQuestRowIconPath(self, icon)
    if icon and icon ~= "" then
        return icon
    end
    return "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp"
end
function setText(self, frame, text)
    if not frame or frame == 0 then
        return
    end
    japi:DzFrameSetText(frame, text)
end
function ____exports.setVisible(self, frame, visible)
    if not frame or frame == 0 then
        return
    end
    japi:DzFrameShow(frame, visible)
end
function hideFrames(self, frames)
    for ____, frame in ipairs(frames) do
        ____exports.setVisible(nil, frame, false)
    end
end
function renderQuestRowSlot(self, ctx, slot, quest, rowTopRel, expanded, parent)
    local itemH = getQuestItemHeight(nil, quest, expanded)
    local statusText = getStatusText(nil, quest.status)
    local showIcon = isQuestWithRowIconLayout(nil, quest)
    local ____exports_calcTaskListItemLayout_result_11 = ____exports.calcTaskListItemLayout(nil, showIcon)
    local rowWidth = ____exports_calcTaskListItemLayout_result_11.rowWidth
    local rowLeftRel = ____exports_calcTaskListItemLayout_result_11.rowLeftRel
    local iconHLayout = ____exports_calcTaskListItemLayout_result_11.iconHLayout
    local textXRel = ____exports_calcTaskListItemLayout_result_11.textXRel
    local listTextAlign = ____exports_calcTaskListItemLayout_result_11.listTextAlign
    local textW = ____exports_calcTaskListItemLayout_result_11.textW
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
            ____exports.resolveQuestRowIconPath(nil, quest.icon)
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
                    goto __continue68
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
            ::__continue68::
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
                    goto __continue72
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
            ::__continue72::
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
                    goto __continue82
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
            ::__continue82::
            rowIndex = rowIndex + 1
        end
    end
    ____exports.setVisible(nil, variant.root, false)
end
local jass = require("jass.common")
japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local clampRange = ____require_result_0.clampRange
____exports.currentTaskRowExpandHandler = nil
____exports.currentTaskRowClickSound = nil
____exports.taskRowBindingByFrameId = {}
--- `pcall` 单次槽位：任务 UI 列表控制内不会嵌套这些导出
local pcallTaskUIListCtx = nil
local function findTaskRowBindingFrame(self, frame)
    local cur = frame
    do
        local i = 0
        while i < 16 do
            if not cur or cur == 0 then
                return 0
            end
            if ____exports.taskRowBindingByFrameId[cur] ~= nil then
                return cur
            end
            cur = japi:DzFrameGetParent(cur)
            i = i + 1
        end
    end
    return 0
end
local function pcallRebuildTaskUIFacadeListPoolBody(self)
    local ctx = pcallTaskUIListCtx
    if not ctx.listContainer or not ctx.precreatedListPool then
        return
    end
    for ____, category in ipairs(questTypes(nil)) do
        local categoryView = ctx.precreatedListPool.categories[category]
        local quests = getQuestsForUI(nil, ctx.currentPlayerId, category)
        local pages = chunkQuests(nil, quests)
        local renderedPageCount = #pages < #categoryView.pages and #pages or #categoryView.pages
        categoryView.pageCount = renderedPageCount
        setText(nil, categoryView.emptyText, EMPTY_TEXTS[category])
        ____exports.setVisible(nil, categoryView.emptyText, false)
        do
            local pageIndex = 0
            while pageIndex < renderedPageCount do
                local page = categoryView.pages[pageIndex + 1]
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
                goto __continue25
            end
            local pageCount = categoryView.pageCount
            if pageCount <= 0 then
                hideAllCategoryPages(nil, categoryView, ____exports.setVisible)
                ____exports.setVisible(nil, categoryView.emptyText, true)
                ctx:updateScrollBarVisibility(0, false)
                goto __continue25
            end
            ____exports.setVisible(nil, categoryView.emptyText, false)
            local clampedPage = clampRange(
                ctx:getCurrentPage(category),
                0,
                pageCount - 1
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
        ::__continue25::
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
                goto __continue31
            end
            local pageCount = categoryView.pageCount
            if pageCount <= 0 then
                hideAllCategoryPages(nil, categoryView, ____exports.setVisible)
                ____exports.setVisible(nil, categoryView.emptyText, true)
                ctx:updateScrollBarVisibility(0, false)
                goto __continue31
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
        ::__continue31::
    end
end
OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25
FAIL_HEIGHT = LIST_ITEM_H * 0.2
DETAIL_HEIGHT = LIST_ITEM_H * 0.22
TITLE_HEIGHT = LIST_ITEM_H * 0.38
OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35
QUEST_ROW_GAP = 0.01
VIEW_BOTTOM_REL = LIST_CONTENT_TOP_INSET - LIST_VIEW_H
VIEW_EPS = 0.002
function ____exports.handleTaskRowClick(self)
    local frame = japi:DzGetTriggerUIEventFrame()
    if not frame then
        frame = japi:DzGetMouseFocus()
    end
    local bindingFrame = findTaskRowBindingFrame(nil, frame)
    if not bindingFrame then
        return
    end
    local binding = ____exports.taskRowBindingByFrameId[bindingFrame]
    if not binding then
        return
    end
    local questId = binding.page.questIds[binding.rowIndex + 1]
    if not questId then
        return
    end
    local ____opt_1 = ____exports.currentTaskRowExpandHandler
    if ____opt_1 ~= nil then
        ____exports.currentTaskRowExpandHandler(binding.rowIndex)
    end
    local triggerPlayer = japi:DzGetTriggerKeyPlayer()
    if triggerPlayer == jass:GetLocalPlayer() then
        local ____opt_3 = ____exports.currentTaskRowClickSound
        if ____opt_3 ~= nil then
            ____exports.currentTaskRowClickSound()
        end
    end
end
local function handleTaskRowClickByRowIndex(self, rowIndex)
    local ____opt_5 = ____exports.currentTaskRowExpandHandler
    if ____opt_5 ~= nil then
        ____exports.currentTaskRowExpandHandler(rowIndex)
    end
    local triggerPlayer = japi:DzGetTriggerKeyPlayer()
    if triggerPlayer == jass:GetLocalPlayer() then
        local ____opt_7 = ____exports.currentTaskRowClickSound
        if ____opt_7 ~= nil then
            ____exports.currentTaskRowClickSound()
        end
    end
end
function ____exports.handleTaskRowClickRow0(self)
    handleTaskRowClickByRowIndex(nil, 0)
end
function ____exports.handleTaskRowClickRow1(self)
    handleTaskRowClickByRowIndex(nil, 1)
end
function ____exports.handleTaskRowClickRow2(self)
    handleTaskRowClickByRowIndex(nil, 2)
end
function ____exports.handleTaskRowClickRow3(self)
    handleTaskRowClickByRowIndex(nil, 3)
end
function ____exports.handleTaskRowClickRow4(self)
    handleTaskRowClickByRowIndex(nil, 4)
end
function ____exports.handleTaskRowClickRow5(self)
    handleTaskRowClickByRowIndex(nil, 5)
end
function ____exports.handleTaskRowClickRow6(self)
    handleTaskRowClickByRowIndex(nil, 6)
end
____exports.taskRowClickHandlersByIndex = {
    ____exports.handleTaskRowClickRow0,
    ____exports.handleTaskRowClickRow1,
    ____exports.handleTaskRowClickRow2,
    ____exports.handleTaskRowClickRow3,
    ____exports.handleTaskRowClickRow4,
    ____exports.handleTaskRowClickRow5,
    ____exports.handleTaskRowClickRow6
}
--- 行按钮在 `ensurePage` 之后绑定，避免 `createHiddenButton` 注册期携带工厂闭包
function ____exports.bindTaskRowClickButtonsForPage(self, page)
    do
        local vi = 0
        while vi < #page.variants do
            local variant = page.variants[vi + 1]
            do
                local ri = 0
                while ri < #variant.rowSlots do
                    local ____opt_9 = variant.rowSlots[ri + 1]
                    local btn = ____opt_9 and ____opt_9.clickBtn or nil
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
    local ____opt_12 = pool.categories[category]
    return ____opt_12 and ____opt_12.pageCount or 0
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
return ____exports
