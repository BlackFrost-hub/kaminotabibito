--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236 = require("系统.08．任务系统.04．任务UI拆分.09．任务UI列表控制")
local taskRowClickHandlersByIndex = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.taskRowClickHandlersByIndex
local taskRowBindingByFrameId = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.taskRowBindingByFrameId
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local MAX_PAGES_PER_CATEGORY = ____01_FF0E_4EFB_52A1UI_5E38_91CF.MAX_PAGES_PER_CATEGORY
local BG_TEX = ____01_FF0E_4EFB_52A1UI_5E38_91CF.BG_TEX
local ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA = require("系统.08．任务系统.04．任务UI拆分.17．任务UI列表帧构建")
local createHiddenRoot = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.createHiddenRoot
local createHiddenText = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.createHiddenText
local createHiddenBackdrop = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.createHiddenBackdrop
local createPlainHiddenBackdrop = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.createPlainHiddenBackdrop
local createHiddenButton = ____17_FF0E_4EFB_52A1UI_5217_8868_5E27_6784_5EFA.createHiddenButton
local ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.11．任务UI列表控制辅助")
local ROWS_PER_PAGE = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.ROWS_PER_PAGE
local PAGE_VARIANT_COUNT = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.PAGE_VARIANT_COUNT
local createEmptyQuestIdList = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.createEmptyQuestIdList
local PAGE_ROOT_HEIGHT = LIST_VIEW_H
local LIST_ITEM_H = LIST_VIEW_H * 0.14
local TITLE_HEIGHT = LIST_ITEM_H * 0.38
local OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25
local FAIL_HEIGHT = LIST_ITEM_H * 0.2
local DETAIL_HEIGHT = LIST_ITEM_H * 0.22
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
    ) or 0
    local icon = createPlainHiddenBackdrop(
        nil,
        ctx,
        (prefix .. "_Icon_") .. tostring(rowIndex),
        parent
    ) or 0
    local title = createHiddenText(
        nil,
        ctx,
        (prefix .. "_Title_") .. tostring(rowIndex),
        parent,
        LIST_CONTAINER_W * 0.9,
        TITLE_HEIGHT
    ) or 0
    local clickBtn = createHiddenButton(
        nil,
        ctx,
        (prefix .. "_Click_") .. tostring(rowIndex),
        parent,
        onClick
    ) or 0
    do
        local i = 0
        while i < 4 do
            objectiveFrames[#objectiveFrames + 1] = createHiddenText(
                nil,
                ctx,
                (prefix .. "_Obj") .. tostring(i),
                parent,
                LIST_CONTAINER_W * 0.9,
                OBJECTIVE_HEIGHT
            ) or 0
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
    ) or 0
    do
        local i = 0
        while i < 6 do
            detailFrames[#detailFrames + 1] = createHiddenText(
                nil,
                ctx,
                (prefix .. "_Det") .. tostring(i),
                parent,
                LIST_CONTAINER_W * 0.9,
                DETAIL_HEIGHT
            ) or 0
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
        page.root,
        LIST_CONTAINER_W,
        PAGE_ROOT_HEIGHT
    )
    local rowSlots = {}
    local prefix = (((("TV" .. category) .. "_") .. tostring(pageIndex)) .. "_") .. tostring(variantIndex)
    do
        local rowIndex = 0
        while rowIndex < ROWS_PER_PAGE do
            local slot = createRowSlot(
                nil,
                ctx,
                root,
                (prefix .. "_R") .. tostring(rowIndex),
                rowIndex,
                taskRowClickHandlersByIndex[rowIndex + 1]
            )
            if slot.clickBtn then
                taskRowBindingByFrameId[slot.clickBtn] = {page = page, rowIndex = rowIndex}
            end
            rowSlots[#rowSlots + 1] = slot
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
            local ____page_variants_0 = page.variants
            ____page_variants_0[#____page_variants_0 + 1] = createVariant(
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
    local emptyText = createHiddenText(
        nil,
        ctx,
        "TaskEmpty_" .. category,
        root,
        LIST_CONTAINER_W * 0.85,
        0.08
    ) or 0
    if emptyText ~= 0 then
        ctx:applyDzTextFontAndCenterAlignment(emptyText)
    end
    local pages = {}
    do
        local pageIndex = 0
        while pageIndex < MAX_PAGES_PER_CATEGORY do
            pages[#pages + 1] = createPage(
                nil,
                ctx,
                root,
                category,
                pageIndex
            )
            pageIndex = pageIndex + 1
        end
    end
    return {root = root, emptyText = emptyText or nil, pageCount = 0, pages = pages}
end
function ____exports.createTaskUIPrecreatedListPool(self, ctx)
    if not ctx.listContainer then
        return nil
    end
    return {categories = {
        [QuestType.MAIN] = createCategory(nil, ctx, QuestType.MAIN),
        [QuestType.SIDE] = createCategory(nil, ctx, QuestType.SIDE),
        [QuestType.DAILY] = createCategory(nil, ctx, QuestType.DAILY)
    }}
end
return ____exports
