--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236 = require("系统.08．任务系统.04．任务UI拆分.09．任务UI列表控制")
local setVisible = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.setVisible
local handleTaskRowClick = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.handleTaskRowClick
local taskRowBindingByFrameId = ____09_FF0E_4EFB_52A1UI_5217_8868_63A7_5236.taskRowBindingByFrameId
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local MAX_PAGES_PER_CATEGORY = ____01_FF0E_4EFB_52A1UI_5E38_91CF.MAX_PAGES_PER_CATEGORY
local BG_TEX = ____01_FF0E_4EFB_52A1UI_5E38_91CF.BG_TEX
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
--- 13．任务UI预设构建
-- 职责：初始化阶段一次性创建所有 page/variant/row 帧。
-- 不在交互时创建或销毁帧。
local japi = require("jass.japi")
local ROWS_PER_PAGE = 7
local PAGE_VARIANT_COUNT = ROWS_PER_PAGE + 1
local PAGE_ROOT_HEIGHT = LIST_VIEW_H
local LIST_ITEM_H = LIST_VIEW_H * 0.14
local TITLE_HEIGHT = LIST_ITEM_H * 0.38
local OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25
local FAIL_HEIGHT = LIST_ITEM_H * 0.2
local DETAIL_HEIGHT = LIST_ITEM_H * 0.22
local ROOT_LEVEL = 40
local BACKDROP_LEVEL = 41
local TEXT_LEVEL = 43
local BUTTON_LEVEL = 46
local ICON_LEVEL = 45
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
    setVisible(nil, frame, false)
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
                handleTaskRowClick
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
    if emptyText then
        ctx:applyDzTextFontAndCenterAlignment(emptyText)
        setVisible(nil, emptyText, false)
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
