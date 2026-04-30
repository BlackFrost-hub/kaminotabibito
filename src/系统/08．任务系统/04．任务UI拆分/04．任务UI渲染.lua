--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_ITEM_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_ITEM_H
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local LIST_CONTENT_LEFT_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTENT_LEFT_INSET
local QUEST_ROW_ICON_HEIGHT_FACTOR = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_HEIGHT_FACTOR
local QUEST_ROW_ICON_PAD_LEFT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_PAD_LEFT
local QUEST_ROW_TEXT_GAP_AFTER_ICON = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_TEXT_GAP_AFTER_ICON
local ____03_FF0EUI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local DZ_TEXT_ALIGN_CENTER = ____03_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_CENTER
local DZ_TEXT_ALIGN_LEFT = ____03_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_LEFT
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
return ____exports
