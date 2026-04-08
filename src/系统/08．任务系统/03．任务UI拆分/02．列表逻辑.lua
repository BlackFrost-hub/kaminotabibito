local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local Set = ____lualib.Set
local ____exports = {}
local ____00_FF0E_914D_7F6E_5E38_91CF = require("系统.08．任务系统.03．任务UI拆分.00．配置常量")
local LIST_ITEM_H = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_ITEM_H
local QUEST_ROW_ICON_PAD_LEFT = ____00_FF0E_914D_7F6E_5E38_91CF.QUEST_ROW_ICON_PAD_LEFT
local QUEST_ROW_ICON_Y_OFFSET = ____00_FF0E_914D_7F6E_5E38_91CF.QUEST_ROW_ICON_Y_OFFSET
local BG_TEX = ____00_FF0E_914D_7F6E_5E38_91CF.BG_TEX
local LIST_CONTAINER_W = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_CONTAINER_W
local ____01_FF0E_901A_7528_5DE5_5177 = require("系统.08．任务系统.03．任务UI拆分.01．通用工具")
local getStatusText = ____01_FF0E_901A_7528_5DE5_5177.getStatusText
local isQuestWithRowIconLayout = ____01_FF0E_901A_7528_5DE5_5177.isQuestWithRowIconLayout
local tryCreateFromFdfOnly = ____01_FF0E_901A_7528_5DE5_5177.tryCreateFromFdfOnly
local getQuestItemHeight = ____01_FF0E_901A_7528_5DE5_5177.getQuestItemHeight
local calcTaskListItemLayout = ____01_FF0E_901A_7528_5DE5_5177.calcTaskListItemLayout
local resolveQuestRowIconPath = ____01_FF0E_901A_7528_5DE5_5177.resolveQuestRowIconPath
local getQuestsForUI = ____01_FF0E_901A_7528_5DE5_5177.getQuestsForUI
local EMPTY_TEXTS = ____01_FF0E_901A_7528_5DE5_5177.EMPTY_TEXTS
local calcTotalContentHeight = ____01_FF0E_901A_7528_5DE5_5177.calcTotalContentHeight
local getMaxScroll = ____01_FF0E_901A_7528_5DE5_5177.getMaxScroll
local clampScrollOffset = ____01_FF0E_901A_7528_5DE5_5177.clampScrollOffset
local calcVisibleQuestRows = ____01_FF0E_901A_7528_5DE5_5177.calcVisibleQuestRows
local EXPANDED_OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35
local EXPANDED_OBJECTIVE_ROW_HEIGHT = LIST_ITEM_H * 0.25
local EXPANDED_FAIL_ROW_HEIGHT = LIST_ITEM_H * 0.2
local function buildObjectiveText(self, completed, description, current, required)
    return ((((((completed and "[v] " or "[ ] ") .. description) .. " (") .. tostring(current)) .. "/") .. tostring(required)) .. ")"
end
local function buildFailText(self, timeLimit)
    return ("失败: 时间限制 " .. tostring(timeLimit)) .. "秒"
end
function ____exports.renderExpandedQuestDetails(self, opts)
    local ____opts_0 = opts
    local japi = ____opts_0.japi
    local quest = ____opts_0.quest
    local listParent = ____opts_0.listParent
    local rowTopRel = ____opts_0.rowTopRel
    local textXRel = ____opts_0.textXRel
    local textW = ____opts_0.textW
    local listTextAlign = ____opts_0.listTextAlign
    local FramePoint = ____opts_0.FramePoint
    local createTextLabel = ____opts_0.createTextLabel
    local setFramePointRelative = ____opts_0.setFramePointRelative
    local setFrameSize = ____opts_0.setFrameSize
    local applyDzTextFontAndAlignment = ____opts_0.applyDzTextFontAndAlignment
    local showFrame = ____opts_0.showFrame
    local objFrameByKey = ____opts_0.objFrameByKey
    local failFrameByQuestId = ____opts_0.failFrameByQuestId
    local listItemFrames = ____opts_0.listItemFrames
    local objYRel = rowTopRel - EXPANDED_OBJECTIVE_START_OFFSET
    for ____, obj in ipairs(quest.objectives) do
        do
            local __continue5
            repeat
                local txt = buildObjectiveText(
                    nil,
                    obj.completed,
                    obj.description,
                    obj.current,
                    obj.required
                )
                local objKey = (quest.id .. "|") .. obj.id
                local objFrame = objFrameByKey:get(objKey) or 0
                if objFrame == 0 then
                    objFrame = createTextLabel(
                        nil,
                        (("TaskObj_" .. quest.id) .. "_") .. obj.id,
                        listParent,
                        txt,
                        {
                            relativeTo = listParent,
                            point = FramePoint.TOPLEFT,
                            relativePoint = FramePoint.TOPLEFT,
                            x = textXRel,
                            y = objYRel
                        },
                        {width = textW, height = EXPANDED_OBJECTIVE_ROW_HEIGHT}
                    ) or 0
                    if objFrame == 0 then
                        objYRel = objYRel - EXPANDED_OBJECTIVE_ROW_HEIGHT
                        __continue5 = true
                        break
                    end
                    objFrameByKey:set(objKey, objFrame)
                else
                    setFramePointRelative(
                        nil,
                        objFrame,
                        FramePoint.TOPLEFT,
                        listParent,
                        FramePoint.TOPLEFT,
                        textXRel,
                        objYRel
                    )
                    setFrameSize(nil, objFrame, {width = textW, height = EXPANDED_OBJECTIVE_ROW_HEIGHT})
                    if type(japi.DzFrameSetText) == "function" then
                        japi.DzFrameSetText(objFrame, txt)
                    end
                end
                applyDzTextFontAndAlignment(nil, objFrame, listTextAlign)
                if type(japi.DzFrameSetLevel) == "function" then
                    japi.DzFrameSetLevel(objFrame, 3)
                end
                showFrame(nil, objFrame)
                listItemFrames[#listItemFrames + 1] = objFrame
                objYRel = objYRel - EXPANDED_OBJECTIVE_ROW_HEIGHT
                __continue5 = true
            until true
            if not __continue5 then
                break
            end
        end
    end
    if quest.timeLimit and quest.timeLimit > 0 then
        local failFrame = failFrameByQuestId:get(quest.id) or 0
        local failText = buildFailText(nil, quest.timeLimit)
        if failFrame == 0 then
            failFrame = createTextLabel(
                nil,
                "TaskFail_" .. quest.id,
                listParent,
                failText,
                {
                    relativeTo = listParent,
                    point = FramePoint.TOPLEFT,
                    relativePoint = FramePoint.TOPLEFT,
                    x = textXRel,
                    y = objYRel
                },
                {width = textW, height = EXPANDED_FAIL_ROW_HEIGHT}
            ) or 0
            if failFrame == 0 then
                return false
            end
            failFrameByQuestId:set(quest.id, failFrame)
        else
            setFramePointRelative(
                nil,
                failFrame,
                FramePoint.TOPLEFT,
                listParent,
                FramePoint.TOPLEFT,
                textXRel,
                objYRel
            )
            setFrameSize(nil, failFrame, {width = textW, height = EXPANDED_FAIL_ROW_HEIGHT})
            if type(japi.DzFrameSetText) == "function" then
                japi.DzFrameSetText(failFrame, failText)
            end
        end
        applyDzTextFontAndAlignment(nil, failFrame, listTextAlign)
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(failFrame, 3)
        end
        showFrame(nil, failFrame)
        listItemFrames[#listItemFrames + 1] = failFrame
    end
    return true
end
function ____exports.renderQuestRow(self, opts)
    local ____opts_1 = opts
    local japi = ____opts_1.japi
    local quest = ____opts_1.quest
    local rowTopRel = ____opts_1.rowTopRel
    local expanded = ____opts_1.expanded
    local listParent = ____opts_1.listParent
    local FrameType = ____opts_1.FrameType
    local FramePoint = ____opts_1.FramePoint
    local createFrame = ____opts_1.createFrame
    local createTextLabel = ____opts_1.createTextLabel
    local setFrameTexture = ____opts_1.setFrameTexture
    local setFramePointRelative = ____opts_1.setFramePointRelative
    local setFrameSize = ____opts_1.setFrameSize
    local setFrameClickEvent = ____opts_1.setFrameClickEvent
    local showFrame = ____opts_1.showFrame
    local applyDzTextFontAndAlignment = ____opts_1.applyDzTextFontAndAlignment
    local onToggleExpand = ____opts_1.onToggleExpand
    local onClickSound = ____opts_1.onClickSound
    local rowBackdropByQuestId = ____opts_1.rowBackdropByQuestId
    local titleByQuestId = ____opts_1.titleByQuestId
    local clickBtnByQuestId = ____opts_1.clickBtnByQuestId
    local objFrameByKey = ____opts_1.objFrameByKey
    local failFrameByQuestId = ____opts_1.failFrameByQuestId
    local rowIconByQuestId = ____opts_1.rowIconByQuestId
    local listItemFrames = ____opts_1.listItemFrames
    local itemH = getQuestItemHeight(nil, quest, expanded)
    local statusText = getStatusText(nil, quest.status)
    local showMainRowIcon = isQuestWithRowIconLayout(nil, quest)
    local ____calcTaskListItemLayout_result_2 = calcTaskListItemLayout(nil, showMainRowIcon)
    local rowWidth = ____calcTaskListItemLayout_result_2.rowWidth
    local rowLeftRel = ____calcTaskListItemLayout_result_2.rowLeftRel
    local iconHLayout = ____calcTaskListItemLayout_result_2.iconHLayout
    local textXRel = ____calcTaskListItemLayout_result_2.textXRel
    local listTextAlign = ____calcTaskListItemLayout_result_2.listTextAlign
    local textW = ____calcTaskListItemLayout_result_2.textW
    local rowBackdrop = rowBackdropByQuestId:get(quest.id) or 0
    if rowBackdrop == 0 then
        rowBackdrop = tryCreateFromFdfOnly(nil, "TaskButtonBackdrop", listParent) or 0
        if rowBackdrop == 0 then
            local bgFrame = createFrame(nil, {
                type = FrameType.BACKDROP,
                name = "TaskItemBg_" .. quest.id,
                parent = listParent,
                template = "template",
                visible = true
            }) or 0
            rowBackdrop = bgFrame or 0
            if rowBackdrop ~= 0 then
                setFrameTexture(nil, rowBackdrop, BG_TEX)
            end
        end
        if rowBackdrop ~= 0 then
            rowBackdropByQuestId:set(quest.id, rowBackdrop)
        end
    end
    if rowBackdrop == 0 then
        return false
    end
    setFramePointRelative(
        nil,
        rowBackdrop,
        FramePoint.TOPLEFT,
        listParent,
        FramePoint.TOPLEFT,
        rowLeftRel,
        rowTopRel
    )
    setFrameSize(nil, rowBackdrop, {width = rowWidth, height = itemH})
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(rowBackdrop, 1)
    end
    showFrame(nil, rowBackdrop)
    listItemFrames[#listItemFrames + 1] = rowBackdrop
    local titleText = ((quest.title .. " [") .. statusText) .. "]"
    local titleFrame = titleByQuestId:get(quest.id) or 0
    if titleFrame == 0 then
        titleFrame = createTextLabel(
            nil,
            "TaskItem_" .. quest.id,
            listParent,
            titleText,
            {
                relativeTo = listParent,
                point = FramePoint.TOPLEFT,
                relativePoint = FramePoint.TOPLEFT,
                x = textXRel,
                y = rowTopRel - 0.005
            },
            {width = textW, height = LIST_ITEM_H * 0.38}
        ) or 0
        if titleFrame == 0 then
            return false
        end
        titleByQuestId:set(quest.id, titleFrame)
    else
        setFramePointRelative(
            nil,
            titleFrame,
            FramePoint.TOPLEFT,
            listParent,
            FramePoint.TOPLEFT,
            textXRel,
            rowTopRel - 0.005
        )
        setFrameSize(nil, titleFrame, {width = textW, height = LIST_ITEM_H * 0.38})
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(titleFrame, titleText)
        end
    end
    applyDzTextFontAndAlignment(nil, titleFrame, listTextAlign)
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(titleFrame, 3)
    end
    showFrame(nil, titleFrame)
    listItemFrames[#listItemFrames + 1] = titleFrame
    local clickBtn = clickBtnByQuestId:get(quest.id) or 0
    if clickBtn == 0 then
        clickBtn = createFrame(nil, {
            type = FrameType.GLUETEXTBUTTON,
            name = "TaskItemClick_" .. quest.id,
            parent = listParent,
            template = "template",
            visible = true,
            enable = true,
            alpha = 0
        }) or 0
        if clickBtn == 0 then
            return false
        end
        clickBtnByQuestId:set(quest.id, clickBtn)
    end
    setFramePointRelative(
        nil,
        clickBtn,
        FramePoint.TOPLEFT,
        listParent,
        FramePoint.TOPLEFT,
        rowLeftRel,
        rowTopRel
    )
    setFrameSize(nil, clickBtn, {width = rowWidth, height = itemH})
    setFrameClickEvent(
        nil,
        clickBtn,
        function()
            onClickSound(nil)
            onToggleExpand(nil, quest.id)
        end,
        false
    )
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(clickBtn, 4)
    end
    showFrame(nil, clickBtn)
    listItemFrames[#listItemFrames + 1] = clickBtn
    if showMainRowIcon then
        local iconPath = resolveQuestRowIconPath(nil, quest.icon)
        local iconFr = rowIconByQuestId:get(quest.id) or 0
        if iconFr == 0 then
            iconFr = createFrame(nil, {
                type = FrameType.BACKDROP,
                name = "TaskQuestRowIcon_" .. quest.id,
                parent = listParent,
                template = "template",
                visible = true
            }) or 0
            if iconFr ~= 0 then
                setFrameTexture(nil, iconFr, iconPath)
                rowIconByQuestId:set(quest.id, iconFr)
            end
        else
            setFrameTexture(nil, iconFr, iconPath)
        end
        if iconFr ~= 0 then
            local iconH = iconHLayout
            local iconW = iconH
            setFramePointRelative(
                nil,
                iconFr,
                FramePoint.TOPLEFT,
                listParent,
                FramePoint.TOPLEFT,
                rowLeftRel + QUEST_ROW_ICON_PAD_LEFT,
                rowTopRel - QUEST_ROW_ICON_Y_OFFSET
            )
            setFrameSize(nil, iconFr, {width = iconW, height = iconH})
            if type(japi.DzFrameSetLevel) == "function" then
                japi.DzFrameSetLevel(iconFr, 5)
            end
            showFrame(nil, iconFr)
            listItemFrames[#listItemFrames + 1] = iconFr
        end
    end
    if expanded then
        local ok = ____exports.renderExpandedQuestDetails(nil, {
            japi = japi,
            quest = quest,
            listParent = listParent,
            rowTopRel = rowTopRel,
            textXRel = textXRel,
            textW = textW,
            listTextAlign = listTextAlign,
            FramePoint = FramePoint,
            createTextLabel = createTextLabel,
            setFramePointRelative = setFramePointRelative,
            setFrameSize = setFrameSize,
            applyDzTextFontAndAlignment = applyDzTextFontAndAlignment,
            showFrame = showFrame,
            objFrameByKey = objFrameByKey,
            failFrameByQuestId = failFrameByQuestId,
            listItemFrames = listItemFrames
        })
        if not ok then
            return false
        end
    end
    return true
end
function ____exports.refreshTaskUIList(self, opts)
    local ____opts_3 = opts
    local currentPlayerId = ____opts_3.currentPlayerId
    local currentCategory = ____opts_3.currentCategory
    local scrollOffset = ____opts_3.scrollOffset
    local setScrollOffset = ____opts_3.setScrollOffset
    local setTotalContentHeight = ____opts_3.setTotalContentHeight
    local listContainer = ____opts_3.listContainer
    local expandedQuestIds = ____opts_3.expandedQuestIds
    local createTextLabel = ____opts_3.createTextLabel
    local FramePoint = ____opts_3.FramePoint
    local applyDzTextFontAndCenterAlignment = ____opts_3.applyDzTextFontAndCenterAlignment
    local pushListItemFrame = ____opts_3.pushListItemFrame
    local syncScrollThumb = ____opts_3.syncScrollThumb
    local updateScrollBarVisibility = ____opts_3.updateScrollBarVisibility
    local createListItem = ____opts_3.createListItem
    local quests = getQuestsForUI(nil, currentPlayerId, currentCategory)
    if #quests == 0 then
        setTotalContentHeight(nil, 0)
        setScrollOffset(nil, 0)
        local empty = createTextLabel(
            nil,
            "TaskEmpty",
            listContainer,
            EMPTY_TEXTS[currentCategory],
            {
                relativeTo = listContainer,
                point = FramePoint.CENTER,
                relativePoint = FramePoint.CENTER,
                x = 0,
                y = 0
            },
            {width = LIST_CONTAINER_W * 0.85, height = 0.08}
        )
        if empty then
            pushListItemFrame(nil, empty)
            applyDzTextFontAndCenterAlignment(nil, empty)
        end
        syncScrollThumb(nil, 0)
        updateScrollBarVisibility(nil, 0)
        return
    end
    local totalH = calcTotalContentHeight(
        nil,
        quests,
        function(____, questId) return expandedQuestIds:has(questId) end
    )
    setTotalContentHeight(nil, totalH)
    local maxScroll = getMaxScroll(nil, totalH)
    local clamped = clampScrollOffset(nil, scrollOffset, maxScroll)
    setScrollOffset(nil, clamped)
    syncScrollThumb(nil, maxScroll)
    updateScrollBarVisibility(nil, maxScroll)
    local visibleRows = calcVisibleQuestRows(
        nil,
        quests,
        clamped,
        function(____, questId) return expandedQuestIds:has(questId) end
    )
    do
        local i = 0
        while i < #visibleRows do
            do
                local __continue48
                repeat
                    local row = visibleRows[i + 1]
                    if not row then
                        __continue48 = true
                        break
                    end
                    createListItem(nil, row.quest, row.rowTopRel, row.expanded)
                    __continue48 = true
                until true
                if not __continue48 then
                    break
                end
            end
            i = i + 1
        end
    end
end
return ____exports
