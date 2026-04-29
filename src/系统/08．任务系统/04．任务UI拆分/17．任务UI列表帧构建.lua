--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local LIST_ITEM_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_ITEM_H
local BG_TEX = ____01_FF0E_4EFB_52A1UI_5E38_91CF.BG_TEX
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local EMPTY_TEXTS = ____02_FF0E_4EFB_52A1UI_8F85_52A9.EMPTY_TEXTS
local ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.11．任务UI列表控制辅助")
local createEmptyQuestIdList = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.createEmptyQuestIdList
local PAGE_VARIANT_COUNT = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.PAGE_VARIANT_COUNT
local ROWS_PER_PAGE = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.ROWS_PER_PAGE
local japi = require("jass.japi")
local PAGE_ROOT_HEIGHT = LIST_VIEW_H
local TITLE_HEIGHT = LIST_ITEM_H * 0.38
local OBJECTIVE_HEIGHT = LIST_ITEM_H * 0.25
local FAIL_HEIGHT = LIST_ITEM_H * 0.2
local DETAIL_HEIGHT = LIST_ITEM_H * 0.22
function ____exports.createHiddenRoot(self, ctx, name, parent, width, height)
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
        visible = false,
        id = ctx.contextId
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
    return frame
end
function ____exports.createHiddenText(self, ctx, name, parent, width, height)
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
    japi.DzFrameShow(frame, false)
    return frame
end
function ____exports.createHiddenBackdrop(self, ctx, templateName, frameName, parent, texture, contextId)
    local frame = tryCreateFromFdfOnly(nil, templateName, parent, contextId or ctx.contextId) or 0
    if not frame then
        frame = ctx:createFrame({
            type = ctx.FrameType.BACKDROP,
            name = frameName,
            parent = parent,
            template = "template",
            visible = false,
            id = ctx.contextId
        }) or 0
        if frame and texture then
            ctx:setFrameTexture(frame, texture)
        end
    end
    return frame or nil
end
function ____exports.createPlainHiddenBackdrop(self, ctx, name, parent)
    local frame = ctx:createFrame({
        type = ctx.FrameType.BACKDROP,
        name = name,
        parent = parent,
        template = "template",
        visible = false,
        id = ctx.contextId
    }) or 0
    return frame or nil
end
function ____exports.createHiddenButton(self, ctx, name, parent, onClick)
    local frame = ctx:createFrame({
        type = ctx.FrameType.GLUETEXTBUTTON,
        name = name,
        parent = parent,
        template = "template",
        visible = false,
        enable = true,
        alpha = 0,
        id = ctx.contextId
    }) or 0
    if not frame then
        return nil
    end
    ctx:setFrameClickEvent(frame, onClick, true)
    return frame
end
local function hideFrames(self, frames, setVisible)
    for ____, frame in ipairs(frames) do
        setVisible(nil, frame, false)
    end
end
function ____exports.hideRowSlot(self, slot, setVisible)
    hideFrames(nil, {
        slot.backdrop,
        slot.title,
        slot.clickBtn,
        slot.icon,
        slot.failFrame
    }, setVisible)
    hideFrames(nil, slot.objectiveFrames, setVisible)
    hideFrames(nil, slot.detailFrames, setVisible)
end
function ____exports.clearVariant(self, variant, setVisible)
    for ____, slot in ipairs(variant.rowSlots) do
        ____exports.hideRowSlot(nil, slot, setVisible)
    end
end
function ____exports.clearPage(self, page, setVisible)
    page.questIds = createEmptyQuestIdList(nil)
    for ____, variant in ipairs(page.variants) do
        ____exports.clearVariant(nil, variant, setVisible)
        setVisible(nil, variant.root, false)
    end
    setVisible(nil, page.root, false)
end
function ____exports.createRowSlot(self, ctx, parent, prefix, rowIndex, onClick)
    local objectiveFrames = {}
    local detailFrames = {}
    local backdrop = ____exports.createHiddenBackdrop(
        nil,
        ctx,
        "TaskButtonBackdrop",
        (prefix .. "_Backdrop_") .. tostring(rowIndex),
        parent,
        BG_TEX,
        rowIndex + 1
    )
    local title = ____exports.createHiddenText(
        nil,
        ctx,
        (prefix .. "_Title_") .. tostring(rowIndex),
        parent,
        LIST_CONTAINER_W * 0.9,
        TITLE_HEIGHT
    )
    local clickBtn = ____exports.createHiddenButton(
        nil,
        ctx,
        (prefix .. "_Click_") .. tostring(rowIndex),
        parent,
        onClick
    )
    local icon = ____exports.createPlainHiddenBackdrop(
        nil,
        ctx,
        (prefix .. "_Icon_") .. tostring(rowIndex),
        parent
    )
    do
        local i = 0
        while i < 4 do
            local frame = ____exports.createHiddenText(
                nil,
                ctx,
                (((prefix .. "_Obj_") .. tostring(rowIndex)) .. "_") .. tostring(i),
                parent,
                LIST_CONTAINER_W * 0.9,
                OBJECTIVE_HEIGHT
            )
            objectiveFrames[#objectiveFrames + 1] = frame or 0
            i = i + 1
        end
    end
    local failFrame = ____exports.createHiddenText(
        nil,
        ctx,
        (prefix .. "_Fail_") .. tostring(rowIndex),
        parent,
        LIST_CONTAINER_W * 0.9,
        FAIL_HEIGHT
    )
    do
        local i = 0
        while i < 3 do
            local frame = ____exports.createHiddenText(
                nil,
                ctx,
                (((prefix .. "_Detail_") .. tostring(rowIndex)) .. "_") .. tostring(i),
                parent,
                LIST_CONTAINER_W * 0.9,
                DETAIL_HEIGHT
            )
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
function ____exports.createVariant(self, ctx, page, category, pageIndex, variantIndex, rowClickHandlers)
    local root = ____exports.createHiddenRoot(
        nil,
        ctx,
        (((("TaskVariant_" .. category) .. "_") .. tostring(pageIndex)) .. "_") .. tostring(variantIndex),
        page.root
    )
    local rowSlots = {}
    do
        local rowIndex = 0
        while rowIndex < ROWS_PER_PAGE do
            rowSlots[#rowSlots + 1] = ____exports.createRowSlot(
                nil,
                ctx,
                root,
                (((("TaskVar_" .. category) .. "_") .. tostring(pageIndex)) .. "_") .. tostring(variantIndex),
                rowIndex,
                rowClickHandlers[rowIndex + 1] or (function()
                end)
            )
            rowIndex = rowIndex + 1
        end
    end
    return {root = root, rowSlots = rowSlots}
end
function ____exports.createPage(self, ctx, categoryRoot, category, pageIndex, rowClickHandlers)
    local page = {
        root = ____exports.createHiddenRoot(
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
            ____page_variants_0[#____page_variants_0 + 1] = ____exports.createVariant(
                nil,
                ctx,
                page,
                category,
                pageIndex,
                variantIndex,
                rowClickHandlers
            )
            variantIndex = variantIndex + 1
        end
    end
    return page
end
function ____exports.createCategory(self, ctx, category, setVisible, rowClickHandlers)
    local root = ____exports.createHiddenRoot(nil, ctx, "TaskCategory_" .. category, ctx.listContainer)
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
        setVisible(nil, emptyText, false)
    end
    return {root = root, emptyText = emptyText or nil, pageCount = 0, pages = {}}
end
return ____exports
