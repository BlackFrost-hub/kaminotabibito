--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_ITEM_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_ITEM_H
local LIST_CONTAINER_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTAINER_W
local LIST_CONTENT_LEFT_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_CONTENT_LEFT_INSET
local QUEST_ROW_ICON_HEIGHT_FACTOR = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_HEIGHT_FACTOR
local QUEST_ROW_ICON_PAD_LEFT = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_PAD_LEFT
local QUEST_ROW_TEXT_GAP_AFTER_ICON = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_TEXT_GAP_AFTER_ICON
local QUEST_ROW_ICON_Y_OFFSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.QUEST_ROW_ICON_Y_OFFSET
local BG_TEX = ____01_FF0E_4EFB_52A1UI_5E38_91CF.BG_TEX
local ____03_FF0EUI_51FD_6570 = require("系统.00．核心系统.03．UI函数")
local DZ_TEXT_ALIGN_CENTER = ____03_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_CENTER
local DZ_TEXT_ALIGN_LEFT = ____03_FF0EUI_51FD_6570.DZ_TEXT_ALIGN_LEFT
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
local getStatusText = ____02_FF0E_4EFB_52A1UI_8F85_52A9.getStatusText
local isQuestWithRowIconLayout = ____02_FF0E_4EFB_52A1UI_8F85_52A9.isQuestWithRowIconLayout
local tryCreateFromFdfOnly = ____02_FF0E_4EFB_52A1UI_8F85_52A9.tryCreateFromFdfOnly
local ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8 = require("系统.08．任务系统.04．任务UI拆分.03．任务UI列表与滚动")
local getQuestItemHeight = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.getQuestItemHeight
--- questId -> 处理器（字符串 key，无 Map 迭代）
local questRowClickHandlers = {}
--- frameId -> questId（数字 key，无 Map）
local frameToQuestIdMap = {}
local function onQuestRowClick(self)
    local japi = require("jass.japi")
    local ____temp_0
    if type(japi.DzGetTriggerUIEventFrame) == "function" then
        ____temp_0 = japi.DzGetTriggerUIEventFrame()
    else
        ____temp_0 = 0
    end
    local frame = ____temp_0
    if not frame then
        return
    end
    local questId = frameToQuestIdMap[frame]
    if questId == nil or questId == "" then
        return
    end
    local handler = questRowClickHandlers[questId]
    if not handler then
        return
    end
    local onClickSound = handler.onClickSound
    local onToggleExpand = handler.onToggleExpand
    onClickSound()
    onToggleExpand(questId)
end
local function registerQuestRowClickHandler(self, questId, onClickSound, onToggleExpand)
    questRowClickHandlers[questId] = {onClickSound = onClickSound, onToggleExpand = onToggleExpand}
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
local EXPANDED_OBJECTIVE_START_OFFSET = LIST_ITEM_H * 0.35
local EXPANDED_OBJECTIVE_ROW_HEIGHT = LIST_ITEM_H * 0.25
local EXPANDED_FAIL_ROW_HEIGHT = LIST_ITEM_H * 0.2
local EXPANDED_DETAIL_ROW_HEIGHT = LIST_ITEM_H * 0.22
local detailFrameByQuestId = {}
local function getOrCreateDetailFrame(self, questId, index, listParent, text, textXRel, yRel, textW, FramePoint, createTextLabel, setFramePointRelative, setFrameSize, applyDzTextFontAndAlignment, showFrame, japi, listItemFrames)
    local key = (questId .. "|") .. tostring(index)
    local frames = detailFrameByQuestId[questId]
    local fr = 0
    if frames and #frames > index then
        fr = frames[index + 1] or 0
    end
    if fr == 0 then
        fr = createTextLabel(
            nil,
            "TaskDetail_" .. key,
            listParent,
            text,
            {
                relativeTo = listParent,
                point = FramePoint.TOPLEFT,
                relativePoint = FramePoint.TOPLEFT,
                x = textXRel,
                y = yRel
            },
            {width = textW, height = EXPANDED_DETAIL_ROW_HEIGHT}
        ) or 0
        if fr ~= 0 then
            if not frames then
                frames = {}
                detailFrameByQuestId[questId] = frames
            end
            while #frames <= index do
                frames[#frames + 1] = 0
            end
            frames[index + 1] = fr
        end
    else
        setFramePointRelative(
            nil,
            fr,
            FramePoint.TOPLEFT,
            listParent,
            FramePoint.TOPLEFT,
            textXRel,
            yRel
        )
        setFrameSize(nil, fr, {width = textW, height = EXPANDED_DETAIL_ROW_HEIGHT})
        if type(japi.DzFrameSetText) == "function" then
            japi.DzFrameSetText(fr, text)
        end
    end
    if fr ~= 0 then
        applyDzTextFontAndAlignment(nil, fr, DZ_TEXT_ALIGN_LEFT)
        showFrame(nil, fr)
        listItemFrames[#listItemFrames + 1] = fr
    end
    return fr
end
local function buildObjectiveText(self, completed, description, current, required)
    local mark = completed and "|cffffcc00√|r" or "|cffffcc00×|r"
    return ((((((mark .. " ") .. description) .. " (") .. tostring(current)) .. "/") .. tostring(required)) .. ")"
end
local function buildFailText(self, timeLimit)
    return ("|cffff4444失败:|r 时间限制 " .. tostring(timeLimit)) .. "秒"
end
function ____exports.renderExpandedQuestDetails(self, opts)
    local ____opts_1 = opts
    local japi = ____opts_1.japi
    local quest = ____opts_1.quest
    local listParent = ____opts_1.listParent
    local rowTopRel = ____opts_1.rowTopRel
    local textXRel = ____opts_1.textXRel
    local textW = ____opts_1.textW
    local listTextAlign = ____opts_1.listTextAlign
    local FramePoint = ____opts_1.FramePoint
    local createTextLabel = ____opts_1.createTextLabel
    local setFramePointRelative = ____opts_1.setFramePointRelative
    local setFrameSize = ____opts_1.setFrameSize
    local applyDzTextFontAndAlignment = ____opts_1.applyDzTextFontAndAlignment
    local showFrame = ____opts_1.showFrame
    local objFrameByKey = ____opts_1.objFrameByKey
    local failFrameByQuestId = ____opts_1.failFrameByQuestId
    local listItemFrames = ____opts_1.listItemFrames
    local objYRel = rowTopRel - EXPANDED_OBJECTIVE_START_OFFSET
    for ____, obj in ipairs(quest.objectives) do
        do
            local txt = buildObjectiveText(
                nil,
                obj.completed,
                obj.description,
                obj.current,
                obj.required
            )
            local objKey = (quest.id .. "|") .. obj.id
            local objFrame = objFrameByKey[objKey] or 0
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
                    goto __continue22
                end
                objFrameByKey[objKey] = objFrame
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
            showFrame(nil, objFrame)
            listItemFrames[#listItemFrames + 1] = objFrame
            objYRel = objYRel - EXPANDED_OBJECTIVE_ROW_HEIGHT
        end
        ::__continue22::
    end
    if quest.timeLimit and quest.timeLimit > 0 then
        local failFrame = failFrameByQuestId[quest.id] or 0
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
            failFrameByQuestId[quest.id] = failFrame
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
        showFrame(nil, failFrame)
        listItemFrames[#listItemFrames + 1] = failFrame
        objYRel = objYRel - EXPANDED_FAIL_ROW_HEIGHT
    end
    local detailIdx = 0
    if quest.description and quest.description ~= "" then
        getOrCreateDetailFrame(
            nil,
            quest.id,
            detailIdx,
            listParent,
            "|cffcccccc任务详情：|r" .. quest.description,
            textXRel,
            objYRel,
            textW,
            FramePoint,
            createTextLabel,
            setFramePointRelative,
            setFrameSize,
            applyDzTextFontAndAlignment,
            showFrame,
            japi,
            listItemFrames
        )
        detailIdx = detailIdx + 1
        objYRel = objYRel - EXPANDED_DETAIL_ROW_HEIGHT
    end
    local rewardDesc = ""
    if quest.rewards and #quest.rewards > 0 then
        local descs = {}
        for ____, r in ipairs(quest.rewards) do
            if r.description and r.description ~= "" then
                descs[#descs + 1] = r.description
            end
        end
        if #descs > 0 then
            rewardDesc = descs[1]
            do
                local i = 1
                while i < #descs do
                    rewardDesc = rewardDesc .. "、" .. descs[i + 1]
                    i = i + 1
                end
            end
        end
    end
    if rewardDesc ~= "" then
        getOrCreateDetailFrame(
            nil,
            quest.id,
            detailIdx,
            listParent,
            ("|cffff9900任务奖励：|r|cffffcc00" .. rewardDesc) .. "|r",
            textXRel,
            objYRel,
            textW,
            FramePoint,
            createTextLabel,
            setFramePointRelative,
            setFrameSize,
            applyDzTextFontAndAlignment,
            showFrame,
            japi,
            listItemFrames
        )
        detailIdx = detailIdx + 1
        objYRel = objYRel - EXPANDED_DETAIL_ROW_HEIGHT
    end
    local accepter = quest.accepterName
    local completer = quest.completerName
    if accepter or completer then
        local infoLine = ""
        if accepter then
            infoLine = infoLine .. ("接受者:|cff00ccff『" .. accepter) .. "』|r"
        end
        if accepter and completer then
            infoLine = infoLine .. "|"
        end
        if completer then
            infoLine = infoLine .. ("完成者:|cff00ff66『" .. completer) .. "』|r"
        end
        getOrCreateDetailFrame(
            nil,
            quest.id,
            detailIdx,
            listParent,
            infoLine,
            textXRel,
            objYRel,
            textW,
            FramePoint,
            createTextLabel,
            setFramePointRelative,
            setFrameSize,
            applyDzTextFontAndAlignment,
            showFrame,
            japi,
            listItemFrames
        )
        detailIdx = detailIdx + 1
        objYRel = objYRel - EXPANDED_DETAIL_ROW_HEIGHT
    end
    return true
end
function ____exports.renderQuestRow(self, opts)
    local ____opts_2 = opts
    local japi = ____opts_2.japi
    local quest = ____opts_2.quest
    local rowTopRel = ____opts_2.rowTopRel
    local expanded = ____opts_2.expanded
    local listParent = ____opts_2.listParent
    local FrameType = ____opts_2.FrameType
    local FramePoint = ____opts_2.FramePoint
    local createFrame = ____opts_2.createFrame
    local createTextLabel = ____opts_2.createTextLabel
    local setFrameTexture = ____opts_2.setFrameTexture
    local setFramePointRelative = ____opts_2.setFramePointRelative
    local setFrameSize = ____opts_2.setFrameSize
    local setFrameClickEvent = ____opts_2.setFrameClickEvent
    local showFrame = ____opts_2.showFrame
    local applyDzTextFontAndAlignment = ____opts_2.applyDzTextFontAndAlignment
    local onToggleExpand = ____opts_2.onToggleExpand
    local onClickSound = ____opts_2.onClickSound
    local rowBackdropByQuestId = ____opts_2.rowBackdropByQuestId
    local titleByQuestId = ____opts_2.titleByQuestId
    local clickBtnByQuestId = ____opts_2.clickBtnByQuestId
    local objFrameByKey = ____opts_2.objFrameByKey
    local failFrameByQuestId = ____opts_2.failFrameByQuestId
    local rowIconByQuestId = ____opts_2.rowIconByQuestId
    local listItemFrames = ____opts_2.listItemFrames
    local itemH = getQuestItemHeight(nil, quest, expanded)
    local statusText = getStatusText(nil, quest.status)
    local showMainRowIcon = isQuestWithRowIconLayout(nil, quest)
    local ____exports_calcTaskListItemLayout_result_3 = ____exports.calcTaskListItemLayout(nil, showMainRowIcon)
    local rowWidth = ____exports_calcTaskListItemLayout_result_3.rowWidth
    local rowLeftRel = ____exports_calcTaskListItemLayout_result_3.rowLeftRel
    local iconHLayout = ____exports_calcTaskListItemLayout_result_3.iconHLayout
    local textXRel = ____exports_calcTaskListItemLayout_result_3.textXRel
    local listTextAlign = ____exports_calcTaskListItemLayout_result_3.listTextAlign
    local textW = ____exports_calcTaskListItemLayout_result_3.textW
    local rowBackdrop = rowBackdropByQuestId[quest.id] or 0
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
            rowBackdropByQuestId[quest.id] = rowBackdrop
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
    showFrame(nil, rowBackdrop)
    listItemFrames[#listItemFrames + 1] = rowBackdrop
    local npcName = quest.startNpc or "未知"
    local titleText = ((((("|cffffff00『" .. quest.title) .. "』|r→发布NPC:|cff00ccff『") .. npcName) .. "』|r [") .. statusText) .. "]"
    local titleFrame = titleByQuestId[quest.id] or 0
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
        titleByQuestId[quest.id] = titleFrame
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
    showFrame(nil, titleFrame)
    listItemFrames[#listItemFrames + 1] = titleFrame
    local clickBtn = clickBtnByQuestId[quest.id] or 0
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
        clickBtnByQuestId[quest.id] = clickBtn
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
    registerQuestRowClickHandler(nil, quest.id, onClickSound, onToggleExpand)
    frameToQuestIdMap[clickBtn] = quest.id
    setFrameClickEvent(nil, clickBtn, onQuestRowClick, true)
    showFrame(nil, clickBtn)
    listItemFrames[#listItemFrames + 1] = clickBtn
    if showMainRowIcon then
        local iconPath = ____exports.resolveQuestRowIconPath(nil, quest.icon)
        local iconFr = rowIconByQuestId[quest.id] or 0
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
                rowIconByQuestId[quest.id] = iconFr
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
return ____exports
