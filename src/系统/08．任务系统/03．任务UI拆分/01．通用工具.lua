local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local __TS__ArraySlice = ____lualib.__TS__ArraySlice
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local __TS__ArrayMap = ____lualib.__TS__ArrayMap
local ____exports = {}
local ____00_FF0E_914D_7F6E_5E38_91CF = require("系统.08．任务系统.03．任务UI拆分.00．配置常量")
local TASK_UI_TOC_LOAD_KEY = ____00_FF0E_914D_7F6E_5E38_91CF.TASK_UI_TOC_LOAD_KEY
local TASK_UI_TOC_PATHS = ____00_FF0E_914D_7F6E_5E38_91CF.TASK_UI_TOC_PATHS
local ENABLE_FDF_A = ____00_FF0E_914D_7F6E_5E38_91CF.ENABLE_FDF_A
local ENABLE_FDF_B = ____00_FF0E_914D_7F6E_5E38_91CF.ENABLE_FDF_B
local ENABLE_FDF_SCROLLBAR = ____00_FF0E_914D_7F6E_5E38_91CF.ENABLE_FDF_SCROLLBAR
local ENABLE_FDF_SCROLLBAR_BORDER = ____00_FF0E_914D_7F6E_5E38_91CF.ENABLE_FDF_SCROLLBAR_BORDER
local ENABLE_FDF_SCROLLBAR_THUMB = ____00_FF0E_914D_7F6E_5E38_91CF.ENABLE_FDF_SCROLLBAR_THUMB
local LIST_ITEM_H = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_ITEM_H
local LIST_VIEW_H = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_VIEW_H
local LIST_CONTENT_TOP_INSET = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_CONTENT_TOP_INSET
local LIST_CONTAINER_W = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_CONTAINER_W
local LIST_CONTENT_LEFT_INSET = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_CONTENT_LEFT_INSET
local QUEST_ROW_ICON_HEIGHT_FACTOR = ____00_FF0E_914D_7F6E_5E38_91CF.QUEST_ROW_ICON_HEIGHT_FACTOR
local QUEST_ROW_ICON_PAD_LEFT = ____00_FF0E_914D_7F6E_5E38_91CF.QUEST_ROW_ICON_PAD_LEFT
local QUEST_ROW_TEXT_GAP_AFTER_ICON = ____00_FF0E_914D_7F6E_5E38_91CF.QUEST_ROW_TEXT_GAP_AFTER_ICON
local ____01_FF0EUI_5DE5_5177 = require("系统.09．表现系统.01．UI工具")
local loadTocOnce = ____01_FF0EUI_5DE5_5177.loadTocOnce
local ____02_FF0E_4EFB_52A1_7BA1_7406_5668 = require("系统.08．任务系统.02．任务管理器")
local questManager = ____02_FF0E_4EFB_52A1_7BA1_7406_5668.questManager
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local ____06_FF0EUI_51FD_6570 = require("系统.00．核心系统.06．UI函数")
local DZ_TEXT_ALIGN_CENTER = ____06_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_CENTER
local DZ_TEXT_ALIGN_LEFT = ____06_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_LEFT
local jass = require("jass.common")
local japi = require("jass.japi")
function ____exports.dzGetLocalPlayer(self)
    local ____temp_0
    if type(jass.GetLocalPlayer) == "function" then
        ____temp_0 = jass.GetLocalPlayer()
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
function ____exports.dzPlayer(self, index)
    local ____temp_1
    if type(jass.Player) == "function" then
        ____temp_1 = jass.Player(index)
    else
        ____temp_1 = nil
    end
    return ____temp_1
end
function ____exports.questIdTailInRange01to20(self, id, prefix)
    if #id ~= #prefix + 3 then
        return false
    end
    if __TS__StringSubstring(id, 0, #prefix) ~= prefix then
        return false
    end
    local tail = __TS__StringSubstring(id, #prefix)
    if #tail ~= 3 then
        return false
    end
    return tail >= "001" and tail <= "020"
end
function ____exports.isQuestWithRowIconLayout(self, quest)
    local id = quest.id
    if quest.type == QuestType.MAIN then
        return ____exports.questIdTailInRange01to20(nil, id, "main_")
    end
    if quest.type == QuestType.SIDE then
        return ____exports.questIdTailInRange01to20(nil, id, "side_")
    end
    if quest.type == QuestType.DAILY then
        return ____exports.questIdTailInRange01to20(nil, id, "daily_")
    end
    return false
end
function ____exports.isFdfFrameEnabled(self, frameName)
    local isA = frameName == "TaskEntryIcon" or frameName == "TaskMainPanel" or frameName == "TaskListContainer"
    local isB = frameName == "TaskTabMain" or frameName == "TaskTabSide" or frameName == "TaskTabDaily" or frameName == "TaskButtonBackdrop" or frameName == "TaskTabMainBg" or frameName == "TaskTabSideBg" or frameName == "TaskTabDailyBg"
    if frameName == "TaskScrollBar" then
        return ENABLE_FDF_SCROLLBAR
    end
    if frameName == "TaskScrollBarBorder" then
        return ENABLE_FDF_SCROLLBAR_BORDER
    end
    if frameName == "TaskScrollThumb" then
        return ENABLE_FDF_SCROLLBAR_THUMB
    end
    if isA then
        return ENABLE_FDF_A
    end
    if isB then
        return ENABLE_FDF_B
    end
    return false
end
function ____exports.tryCreateFromFdfWithSource(self, name, parent, fallback)
    if not ____exports.isFdfFrameEnabled(nil, name) then
        return {
            frame = fallback(nil),
            fromFdf = false
        }
    end
    loadTocOnce(nil, TASK_UI_TOC_LOAD_KEY, TASK_UI_TOC_PATHS, "TaskUI")
    if type(japi.DzCreateFrame) ~= "function" then
        return {
            frame = fallback(nil),
            fromFdf = false
        }
    end
    local f = 0
    local ok = pcall(function ()
            f = japi.DzCreateFrame(name, parent, 0)
        end
    )
    if ok and f ~= nil and f ~= 0 then
        return {frame = f, fromFdf = true}
    end
    return {
        frame = fallback(nil),
        fromFdf = false
    }
end
function ____exports.tryCreateFromFdfOnly(self, name, parent)
    local res = ____exports.tryCreateFromFdfWithSource(
        nil,
        name,
        parent,
        function() return nil end
    )
    if res.fromFdf and res.frame and res.frame ~= 0 then
        return res.frame
    end
    return nil
end
function ____exports.getStatusText(self, status)
    local m = {
        [QuestStatus.IN_PROGRESS] = "|cff00ff66进行中|r",
        [QuestStatus.COMPLETED] = "|cffc0c0c0已完成|r",
        [QuestStatus.FAILED] = "|cffff5555已失败|r",
        [QuestStatus.DISCOVERED] = "|cff66ccff已发现|r",
        [QuestStatus.UNDISCOVERED] = "|cff888888未发现|r"
    }
    return m[status] or status
end
function ____exports.getQuestsForUI(self, playerId, ____type)
    local active = __TS__ArrayFilter(
        questManager:getPlayerQuests(playerId, ____type),
        function(____, q) return not q.uiReserved end
    )
    local completedIds = questDB:getPlayerCompletedQuests(playerId)
    local result = __TS__ArraySlice(active)
    for ____, id in ipairs(completedIds) do
        do
            local __continue29
            repeat
                local template = questDB:getQuest(id)
                if not template or template.type ~= ____type or template.uiReserved then
                    __continue29 = true
                    break
                end
                if __TS__ArraySome(
                    active,
                    function(____, q) return q.id == id end
                ) then
                    __continue29 = true
                    break
                end
                result[#result + 1] = __TS__ObjectAssign(
                    {},
                    template,
                    {
                        status = QuestStatus.COMPLETED,
                        objectives = __TS__ArrayMap(
                            template.objectives,
                            function(____, o) return __TS__ObjectAssign({}, o, {completed = true, current = o.required}) end
                        )
                    }
                )
                __continue29 = true
            until true
            if not __continue29 then
                break
            end
        end
    end
    return result
end
____exports.EMPTY_TEXTS = {[QuestType.MAIN] = "暂无主线任务", [QuestType.SIDE] = "暂无支线任务", [QuestType.DAILY] = "暂无小任务"}
function ____exports.getQuestItemHeight(self, quest, expanded)
    if not expanded then
        return LIST_ITEM_H * 0.4
    end
    return LIST_ITEM_H + #quest.objectives * 0.03 + (quest.timeLimit and quest.timeLimit > 0 and 0.02 or 0)
end
function ____exports.calcTotalContentHeight(self, quests, isExpanded)
    local totalH = 0
    do
        local i = 0
        while i < #quests do
            do
                local __continue39
                repeat
                    local q = quests[i + 1]
                    if not q then
                        __continue39 = true
                        break
                    end
                    totalH = totalH + (____exports.getQuestItemHeight(
                        nil,
                        q,
                        isExpanded(nil, q.id)
                    ) + 0.01)
                    __continue39 = true
                until true
                if not __continue39 then
                    break
                end
            end
            i = i + 1
        end
    end
    return totalH
end
function ____exports.getMaxScroll(self, totalContentHeight)
    return math.max(0, totalContentHeight - LIST_VIEW_H)
end
function ____exports.clampScrollOffset(self, scrollOffset, maxScroll)
    return math.min(
        maxScroll,
        math.max(0, scrollOffset)
    )
end
function ____exports.isQuestRowFullyInsideView(self, rowTopRel, itemHeight, visibleTopRel, visibleBottomRel, eps)
    local itemTopRel = rowTopRel
    local itemBottomRel = rowTopRel - itemHeight
    return itemTopRel <= visibleTopRel + eps and itemBottomRel >= visibleBottomRel - eps
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
                local __continue46
                repeat
                    local q = quests[i + 1]
                    if not q then
                        __continue46 = true
                        break
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
                    __continue46 = true
                until true
                if not __continue46 then
                    break
                end
            end
            i = i + 1
        end
    end
    return visibleRows
end
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
