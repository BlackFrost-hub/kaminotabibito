local ____lualib = require("lualib_bundle")
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local ____exports = {}
local japi
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local EMPTY_TEXTS = ____02_FF0E_4EFB_52A1UI_8F85_52A9.EMPTY_TEXTS
local getQuestsForUI = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getQuestsForUI
local getStatusText = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getStatusText
local isQuestWithRowIconLayout = ____02_FF0E_4EFB_52A1UI_8F85_52A9.isQuestWithRowIconLayout
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
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
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local QUEST_ROW_ICON_PAD_LEFT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_PAD_LEFT
local QUEST_ROW_ICON_Y_OFFSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_Y_OFFSET
local BG_TEX = ____01_FF0E_4EFB_52A1UI_5E38_91CF.BG_TEX
local ____03_FF0EUI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local DZ_TEXT_ALIGN_LEFT = ____03_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_LEFT
function ____exports.handleTaskRowClick(self)
    local ____temp_2
    if type(japi.DzGetTriggerUIEventFrame) == "function" then
        ____temp_2 = japi.DzGetTriggerUIEventFrame()
    else
        ____temp_2 = 0
    end
    local frame = ____temp_2
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
    local ____opt_3 = ____exports.currentTaskRowClickSound
    if ____opt_3 ~= nil then
        ____exports.currentTaskRowClickSound(nil)
    end
    local ____opt_5 = ____exports.currentTaskRowExpandHandler
    if ____opt_5 ~= nil then
        ____exports.currentTaskRowExpandHandler(nil, questId)
    end
end
japi = require("jass.japi")
____exports.currentTaskRowExpandHandler = nil
____exports.currentTaskRowClickSound = nil
____exports.taskRowBindingByFrameId = {}
local ROWS_PER_PAGE = 7
--- 相邻页在任务列表上错开的行数（原 3，改为 1 则每次翻页少滑一行）
local ROWS_PER_SCROLL_STEP = 1
local PAGE_VARIANT_COUNT = ROWS_PER_PAGE + 1
local TITLE_HEIGHT = LIST_ITEM_H * 0.38
local OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25
local FAIL_HEIGHT = LIST_ITEM_H * 0.2
local DETAIL_HEIGHT = LIST_ITEM_H * 0.22
local OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35
local PAGE_ROOT_HEIGHT = LIST_VIEW_H
local QUEST_ROW_GAP = 0.01
local VIEW_BOTTOM_REL = LIST_CONTENT_TOP_INSET - LIST_VIEW_H
local VIEW_EPS = 0.002
local ROOT_LEVEL = 40
local BACKDROP_LEVEL = 41
local TEXT_LEVEL = 43
local BUTTON_LEVEL = 46
local ICON_LEVEL = 45
local function setText(self, frame, text)
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
local function hideFrames(self, frames)
    for ____, frame in ipairs(frames) do
        ____exports.setVisible(nil, frame, false)
    end
end
local function questTypes(self)
    return {QuestType.MAIN, QuestType.SIDE, QuestType.DAILY}
end
local function createEmptyQuestIdList(self)
    local questIds = {}
    do
        local i = 0
        while i < ROWS_PER_PAGE do
            questIds[#questIds + 1] = ""
            i = i + 1
        end
    end
    return questIds
end
local function createHiddenRoot(self, ctx, name, parent, width, height)
    if width == nil then
        width = LIST_CONTAINER_W
    end
    if height == nil then
        height = PAGE_ROOT_HEIGHT
    end
    local frame = ctx:createFrame({
        type = "FRAME",
        name = name,
        parent = parent,
        template = "template",
        visible = false
    }) or 0
    if not frame then
        return nil
    end
    ctx:setFramePointRelative(
        frame,
        ctx.FramePoint.TOPLEFT,
        parent,
        ctx.FramePoint.TOPLEFT,
        0,
        0
    )
    ctx:setFrameSize(frame, {width = width, height = height})
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(frame, ROOT_LEVEL)
    end
    return frame
end
local function createHiddenText(self, ctx, name, parent, width, height)
    local frame = ctx:createTextLabel(
        name,
        parent,
        "",
        {
            relativeTo = parent,
            point = ctx.FramePoint.TOPLEFT,
            relativePoint = ctx.FramePoint.TOPLEFT,
            x = 0,
            y = 0
        },
        {width = width, height = height}
    ) or 0
    if not frame then
        return nil
    end
    ____exports.setVisible(nil, frame, false)
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(frame, TEXT_LEVEL)
    end
    return frame
end
local function createHiddenBackdrop(self, ctx, templateName, frameName, parent, texture, contextId)
    local frame = tryCreateFromFdfOnly(nil, templateName, parent, contextId or 0) or 0
    if not frame then
        frame = ctx:createFrame({
            type = ctx.FrameType.BACKDROP,
            name = frameName,
            parent = parent,
            template = "template",
            visible = false
        }) or 0
        if frame and texture then
            ctx:setFrameTexture(frame, texture)
        end
    end
    if frame and type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(frame, BACKDROP_LEVEL)
    end
    return frame or nil
end
local function createPlainHiddenBackdrop(self, ctx, name, parent)
    local frame = ctx:createFrame({
        type = ctx.FrameType.BACKDROP,
        name = name,
        parent = parent,
        template = "template",
        visible = false
    }) or 0
    if frame and type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(frame, ICON_LEVEL)
    end
    return frame or nil
end
local function createHiddenButton(self, ctx, name, parent, onClick)
    local frame = ctx:createFrame({
        type = ctx.FrameType.GLUETEXTBUTTON,
        name = name,
        parent = parent,
        template = "template",
        visible = false,
        enable = true,
        alpha = 0
    }) or 0
    if not frame then
        return nil
    end
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(frame, BUTTON_LEVEL)
    end
    ctx:setFrameClickEvent(frame, onClick, false)
    return frame
end
local function hideRowSlot(self, slot)
    hideFrames(nil, {
        slot.backdrop,
        slot.title,
        slot.clickBtn,
        slot.icon,
        slot.failFrame
    })
    hideFrames(nil, slot.objectiveFrames)
    hideFrames(nil, slot.detailFrames)
end
local function createRowSlot(self, ctx, parent, prefix, rowIndex, onClick)
    local objectiveFrames = {}
    local detailFrames = {}
    local backdrop = createHiddenBackdrop(
        nil,
        ctx,
        "TaskButtonBackdrop",
        (prefix .. "_Backdrop_") .. tostring(rowIndex),
        parent,
        BG_TEX,
        rowIndex + 1
    )
    local title = createHiddenText(
        nil,
        ctx,
        (prefix .. "_Title_") .. tostring(rowIndex),
        parent,
        LIST_CONTAINER_W * 0.9,
        TITLE_HEIGHT
    )
    local clickBtn = createHiddenButton(
        nil,
        ctx,
        (prefix .. "_Click_") .. tostring(rowIndex),
        parent,
        onClick
    )
    local icon = createPlainHiddenBackdrop(
        nil,
        ctx,
        (prefix .. "_Icon_") .. tostring(rowIndex),
        parent
    )
    if backdrop and type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(backdrop, BACKDROP_LEVEL)
    end
    if title and type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(title, TEXT_LEVEL)
    end
    if clickBtn and type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(clickBtn, BUTTON_LEVEL)
    end
    if icon and type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(icon, ICON_LEVEL)
    end
    do
        local i = 0
        while i < 4 do
            local frame = createHiddenText(
                nil,
                ctx,
                (((prefix .. "_Obj_") .. tostring(rowIndex)) .. "_") .. tostring(i),
                parent,
                LIST_CONTAINER_W * 0.9,
                OBJECTIVE_HEIGHT
            )
            if frame and type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(frame, TEXT_LEVEL)
            end
            objectiveFrames[#objectiveFrames + 1] = frame or 0
            i = i + 1
        end
    end
    local failFrame = createHiddenText(
        nil,
        ctx,
        (prefix .. "_Fail_") .. tostring(rowIndex),
        parent,
        LIST_CONTAINER_W * 0.9,
        FAIL_HEIGHT
    )
    if failFrame and type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(failFrame, TEXT_LEVEL)
    end
    do
        local i = 0
        while i < 3 do
            local frame = createHiddenText(
                nil,
                ctx,
                (((prefix .. "_Detail_") .. tostring(rowIndex)) .. "_") .. tostring(i),
                parent,
                LIST_CONTAINER_W * 0.9,
                DETAIL_HEIGHT
            )
            if frame and type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(frame, TEXT_LEVEL)
            end
            detailFrames[#detailFrames + 1] = frame or 0
            i = i + 1
        end
    end
    return {
        backdrop = backdrop,
        title = title,
        clickBtn = clickBtn,
        icon = icon,
        objectiveFrames = objectiveFrames,
        failFrame = failFrame,
        detailFrames = detailFrames
    }
end
local function createVariant(self, ctx, page, category, pageIndex, variantIndex)
    local root = createHiddenRoot(
        nil,
        ctx,
        (((("TaskVariant_" .. category) .. "_") .. tostring(pageIndex)) .. "_") .. tostring(variantIndex),
        page.root
    )
    local rowSlots = {}
    do
        local rowIndex = 0
        while rowIndex < ROWS_PER_PAGE do
            local slotRowIndex = rowIndex
            rowSlots[#rowSlots + 1] = createRowSlot(
                nil,
                ctx,
                root,
                (((("TaskVar_" .. category) .. "_") .. tostring(pageIndex)) .. "_") .. tostring(variantIndex),
                slotRowIndex,
                ____exports.handleTaskRowClick
            )
            local ____opt_0 = rowSlots[#rowSlots]
            local clickBtn = ____opt_0 and ____opt_0.clickBtn
            if clickBtn then
                ____exports.taskRowBindingByFrameId[clickBtn] = {page = page, rowIndex = slotRowIndex}
            end
            rowIndex = rowIndex + 1
        end
    end
    return {root = root, rowSlots = rowSlots}
end
local function createPage(self, ctx, categoryRoot, category, pageIndex)
    local page = {
        root = createHiddenRoot(
            nil,
            ctx,
            (("TaskPage_" .. category) .. "_") .. tostring(pageIndex),
            categoryRoot
        ),
        questIds = createEmptyQuestIdList(nil),
        variants = {}
    }
    do
        local variantIndex = 0
        while variantIndex < PAGE_VARIANT_COUNT do
            local ____page_variants_7 = page.variants
            ____page_variants_7[#____page_variants_7 + 1] = createVariant(
                nil,
                ctx,
                page,
                category,
                pageIndex,
                variantIndex
            )
            variantIndex = variantIndex + 1
        end
    end
    return page
end
local function createCategory(self, ctx, category)
    local root = createHiddenRoot(nil, ctx, "TaskCategory_" .. category, ctx.listContainer)
    local emptyText = ctx:createTextLabel(
        "TaskEmpty_" .. category,
        root,
        EMPTY_TEXTS[category],
        {
            relativeTo = root,
            point = ctx.FramePoint.TOPLEFT,
            relativePoint = ctx.FramePoint.TOPLEFT,
            x = 0,
            y = -(LIST_VIEW_H * 0.5)
        },
        {width = LIST_CONTAINER_W * 0.85, height = 0.08}
    ) or 0
    if emptyText then
        ctx:applyDzTextFontAndCenterAlignment(emptyText)
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(emptyText, TEXT_LEVEL)
        end
        ____exports.setVisible(nil, emptyText, false)
    end
    return {root = root, emptyText = emptyText or nil, pageCount = 0, pages = {}}
end
function ____exports.createTaskUIPrecreatedListPool(self, ctx)
    if not ctx.listContainer then
        return nil
    end
    ____exports.currentTaskRowExpandHandler = ctx.toggleExpand
    ____exports.currentTaskRowClickSound = ctx.playClickSound
    return {categories = {
        [QuestType.MAIN] = createCategory(nil, ctx, QuestType.MAIN),
        [QuestType.SIDE] = createCategory(nil, ctx, QuestType.SIDE),
        [QuestType.DAILY] = createCategory(nil, ctx, QuestType.DAILY)
    }}
end
local function ensurePage(self, ctx, categoryView, category, pageIndex)
    while #categoryView.pages <= pageIndex do
        local ____categoryView_pages_8 = categoryView.pages
        ____categoryView_pages_8[#____categoryView_pages_8 + 1] = createPage(
            nil,
            ctx,
            categoryView.root,
            category,
            #categoryView.pages
        )
    end
    return categoryView.pages[pageIndex + 1]
end
local function clearVariant(self, variant)
    for ____, slot in ipairs(variant.rowSlots) do
        hideRowSlot(nil, slot)
    end
end
local function clearPage(self, page)
    page.questIds = createEmptyQuestIdList(nil)
    for ____, variant in ipairs(page.variants) do
        clearVariant(nil, variant)
        ____exports.setVisible(nil, variant.root, false)
    end
    ____exports.setVisible(nil, page.root, false)
end
local function buildObjectiveText(self, quest, index)
    local obj = quest.objectives[index + 1]
    if not obj then
        return ""
    end
    local mark = obj.completed and "|cffffcc00鈭�|r" or "|cffffcc00脳|r"
    return ((((((mark .. " ") .. obj.description) .. " (") .. tostring(obj.current)) .. "/") .. tostring(obj.required)) .. ")"
end
local function buildRewardText(self, quest)
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
local function buildInfoText(self, quest)
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
local function renderQuestRowSlot(self, ctx, slot, quest, rowTopRel, expanded, parent)
    local itemH = getQuestItemHeight(nil, quest, expanded)
    local statusText = getStatusText(nil, quest.status)
    local showIcon = isQuestWithRowIconLayout(nil, quest)
    local ____calcTaskListItemLayout_result_9 = calcTaskListItemLayout(nil, showIcon)
    local rowWidth = ____calcTaskListItemLayout_result_9.rowWidth
    local rowLeftRel = ____calcTaskListItemLayout_result_9.rowLeftRel
    local iconHLayout = ____calcTaskListItemLayout_result_9.iconHLayout
    local textXRel = ____calcTaskListItemLayout_result_9.textXRel
    local listTextAlign = ____calcTaskListItemLayout_result_9.listTextAlign
    local textW = ____calcTaskListItemLayout_result_9.textW
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
                    goto __continue88
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
            ::__continue88::
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
                    goto __continue92
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
            ::__continue92::
            i = i + 1
        end
    end
end
local function renderVariant(self, ctx, variant, pageQuests, expandedRowIndex)
    clearVariant(nil, variant)
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
                    hideRowSlot(nil, slot)
                    goto __continue102
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
                    hideRowSlot(nil, slot)
                end
                rowTopRel = rowTopRel - (itemH + QUEST_ROW_GAP)
            end
            ::__continue102::
            rowIndex = rowIndex + 1
        end
    end
    ____exports.setVisible(nil, variant.root, false)
end
local function chunkQuests(self, quests)
    local pages = {}
    if #quests <= ROWS_PER_PAGE then
        if #quests > 0 then
            pages[#pages + 1] = __TS__ArraySlice(quests, 0, ROWS_PER_PAGE)
        end
        return pages
    end
    do
        local i = 0
        while i < #quests do
            local ____end = i + ROWS_PER_PAGE
            if ____end >= #quests then
                pages[#pages + 1] = __TS__ArraySlice(
                    quests,
                    math.max(0, #quests - ROWS_PER_PAGE),
                    #quests
                )
                break
            end
            pages[#pages + 1] = __TS__ArraySlice(quests, i, ____end)
            i = i + ROWS_PER_SCROLL_STEP
        end
    end
    return pages
end
function ____exports.rebuildTaskUIFacadeListPool(self, ctx)
    pcall(function ()
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
                            pageIndex
                        )
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
                        clearPage(nil, categoryView.pages[pageIndex + 1])
                        pageIndex = pageIndex + 1
                    end
                end
                ____exports.setVisible(nil, categoryView.root, false)
            end
        end
    )
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
    local ____opt_10 = pool.categories[category]
    return ____opt_10 and ____opt_10.pageCount or 0
end
function ____exports.applyTaskUIFacadeVisibleState(self, ctx)
    pcall(function ()
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
                        goto __continue132
                    end
                    local pageCount = categoryView.pageCount
                    if pageCount <= 0 then
                        ____exports.setVisible(nil, categoryView.emptyText, true)
                        for ____, page in ipairs(categoryView.pages) do
                            for ____, variant in ipairs(page.variants) do
                                ____exports.setVisible(nil, variant.root, false)
                            end
                            ____exports.setVisible(nil, page.root, false)
                        end
                        ctx:updateScrollBarVisibility(0, false)
                        goto __continue132
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
                    local variantIndex = 0
                    if expandedQuestId then
                        local rowIndex = -1
                        do
                            local i = 0
                            while i < #currentPage.questIds do
                                if currentPage.questIds[i + 1] == expandedQuestId then
                                    rowIndex = i
                                    break
                                end
                                i = i + 1
                            end
                        end
                        if rowIndex >= 0 then
                            variantIndex = rowIndex + 1
                        end
                    end
                    do
                        local pageIndex = 0
                        while pageIndex < #categoryView.pages do
                            do
                                local page = categoryView.pages[pageIndex + 1]
                                local isCurrentPage = pageIndex == clampedPage
                                ____exports.setVisible(nil, page.root, isCurrentPage)
                                if not isCurrentPage then
                                    goto __continue145
                                end
                                do
                                    local i = 0
                                    while i < #page.variants do
                                        ____exports.setVisible(nil, page.variants[i + 1].root, i == variantIndex)
                                        i = i + 1
                                    end
                                end
                            end
                            ::__continue145::
                            pageIndex = pageIndex + 1
                        end
                    end
                    ctx:updateScrollBarVisibility(pageCount, true)
                end
                ::__continue132::
            end
        end
    )
end
function ____exports.applyTaskUICategorySwitchVisibleState(self, ctx)
    pcall(function ()
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
                        ____exports.setVisible(nil, categoryView.emptyText, false)
                        for ____, page in ipairs(categoryView.pages) do
                            for ____, variant in ipairs(page.variants) do
                                ____exports.setVisible(nil, variant.root, false)
                            end
                            ____exports.setVisible(nil, page.root, false)
                        end
                        goto __continue153
                    end
                    local pageCount = categoryView.pageCount
                    if pageCount <= 0 then
                        ____exports.setVisible(nil, categoryView.emptyText, true)
                        for ____, page in ipairs(categoryView.pages) do
                            for ____, variant in ipairs(page.variants) do
                                ____exports.setVisible(nil, variant.root, false)
                            end
                            ____exports.setVisible(nil, page.root, false)
                        end
                        ctx:updateScrollBarVisibility(0, false)
                        goto __continue153
                    end
                    ____exports.setVisible(nil, categoryView.emptyText, false)
                    do
                        local pageIndex = 0
                        while pageIndex < #categoryView.pages do
                            local page = categoryView.pages[pageIndex + 1]
                            local isCurrentPage = pageIndex == 0
                            ____exports.setVisible(nil, page.root, isCurrentPage)
                            do
                                local variantIndex = 0
                                while variantIndex < #page.variants do
                                    ____exports.setVisible(nil, page.variants[variantIndex + 1].root, isCurrentPage and variantIndex == 0)
                                    variantIndex = variantIndex + 1
                                end
                            end
                            pageIndex = pageIndex + 1
                        end
                    end
                    ctx:updateScrollBarVisibility(pageCount, true)
                end
                ::__continue153::
            end
        end
    )
end
function ____exports.applyTaskUIExpandVisibleState(self, ctx)
    pcall(function ()
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
            local variantIndex = 0
            if expandedQuestId then
                local rowIndex = -1
                do
                    local i = 0
                    while i < #currentPage.questIds do
                        if currentPage.questIds[i + 1] == expandedQuestId then
                            rowIndex = i
                            break
                        end
                        i = i + 1
                    end
                end
                if rowIndex >= 0 then
                    variantIndex = rowIndex + 1
                end
            end
            do
                local i = 0
                while i < #currentPage.variants do
                    ____exports.setVisible(nil, currentPage.variants[i + 1].root, i == variantIndex)
                    i = i + 1
                end
            end
        end
    )
end
function ____exports.applyTaskUIPageSwitchVisibleState(self, ctx)
    pcall(function ()
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
                ____exports.setVisible(nil, categoryView.emptyText, true)
                for ____, page in ipairs(categoryView.pages) do
                    for ____, variant in ipairs(page.variants) do
                        ____exports.setVisible(nil, variant.root, false)
                    end
                    ____exports.setVisible(nil, page.root, false)
                end
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
            do
                local pageIndex = 0
                while pageIndex < #categoryView.pages do
                    local page = categoryView.pages[pageIndex + 1]
                    local isCurrentPage = pageIndex == clampedPage
                    ____exports.setVisible(nil, page.root, isCurrentPage)
                    do
                        local variantIndex = 0
                        while variantIndex < #page.variants do
                            ____exports.setVisible(nil, page.variants[variantIndex + 1].root, isCurrentPage and variantIndex == 0)
                            variantIndex = variantIndex + 1
                        end
                    end
                    pageIndex = pageIndex + 1
                end
            end
            ctx:updateScrollBarVisibility(pageCount, true)
        end
    )
end
return ____exports
