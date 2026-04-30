--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
local ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.11．任务UI列表控制辅助")
local createEmptyQuestIdList = ____11_FF0E_4EFB_52A1UI_5217_8868_63A7_5236_8F85_52A9.createEmptyQuestIdList
local japi = require("jass.japi")
local PAGE_ROOT_HEIGHT = LIST_VIEW_H
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
return ____exports
