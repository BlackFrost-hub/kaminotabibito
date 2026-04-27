--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local ENTRY_X = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_X
local ENTRY_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_Y
local ENTRY_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_W
local ENTRY_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_H
local ENTRY_TITLE_TEXT_BOX_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_TITLE_TEXT_BOX_W
local ENTRY_TITLE_TEXT_BOX_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_TITLE_TEXT_BOX_H
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
function ____exports.buildTaskEntryIcon(self, opts)
    local ____opts_0 = opts
    local japi = ____opts_0.japi
    local parent = ____opts_0.parent
    local FrameType = ____opts_0.FrameType
    local FramePoint = ____opts_0.FramePoint
    local createFrame = ____opts_0.createFrame
    local createTextLabel = ____opts_0.createTextLabel
    local setFramePosition = ____opts_0.setFramePosition
    local setFrameSize = ____opts_0.setFrameSize
    local setFramePointRelative = ____opts_0.setFramePointRelative
    local setFrameClickEvent = ____opts_0.setFrameClickEvent
    local applyDzTextFontAndCenterAlignment = ____opts_0.applyDzTextFontAndCenterAlignment
    local onTogglePanel = ____opts_0.onTogglePanel
    local slotId = ____opts_0.slotId
    local contextId = ____opts_0.contextId
    local nameSuffix = "_s" .. tostring(slotId)
    local entryFrame = tryCreateFromFdfOnly(nil, "TaskEntryIcon", parent, contextId)
    if not entryFrame then
        return {entryFrame = nil, entryText = nil}
    end
    setFramePosition(nil, entryFrame, {point = FramePoint.TOPLEFT, x = ENTRY_X, y = ENTRY_Y})
    setFrameSize(nil, entryFrame, {width = ENTRY_W, height = ENTRY_H})
    local tw = ENTRY_W * ENTRY_TITLE_TEXT_BOX_W
    local th = ENTRY_H * ENTRY_TITLE_TEXT_BOX_H
    local titleRel = {
        relativeTo = entryFrame,
        point = FramePoint.CENTER,
        relativePoint = FramePoint.CENTER,
        x = 0,
        y = 0
    }
    local entryText = nil
    local ____createFrame_result_1 = createFrame(nil, {
        type = FrameType.TEXT,
        name = "TaskEntryText" .. nameSuffix,
        parent = entryFrame,
        template = "template",
        visible = true
    })
    if ____createFrame_result_1 == nil then
        ____createFrame_result_1 = 0
    end
    local textFrame = ____createFrame_result_1
    if textFrame ~= nil and textFrame ~= 0 then
        entryText = textFrame
        setFramePointRelative(
            nil,
            textFrame,
            titleRel.point,
            titleRel.relativeTo,
            titleRel.relativePoint,
            titleRel.x,
            titleRel.y
        )
        setFrameSize(nil, textFrame, {width = tw, height = th})
    else
        entryText = createTextLabel(
            nil,
            "TaskEntryText" .. nameSuffix,
            entryFrame,
            "",
            titleRel,
            {width = tw, height = th}
        )
    end
    if entryText ~= nil and entryText ~= 0 then
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(entryText, "|cffffcc00任务(J)|r")
        end
        applyDzTextFontAndCenterAlignment(nil, entryText)
    end
    local ____createFrame_result_2 = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = "TaskEntryBtn" .. nameSuffix,
        parent = entryFrame,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if ____createFrame_result_2 == nil then
        ____createFrame_result_2 = 0
    end
    local btn = ____createFrame_result_2
    if btn then
        if type(japi.DzFrameSetAllPoints) == "function" then
            japi.DzFrameSetAllPoints(btn, entryFrame)
        end
        setFrameClickEvent(nil, btn, onTogglePanel, true)
    end
    return {entryFrame = entryFrame, entryText = entryText}
end
return ____exports
