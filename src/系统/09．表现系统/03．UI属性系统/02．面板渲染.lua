local ____lualib = require("lualib_bundle")
local Set = ____lualib.Set
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local japi, _____5E38_91CF, buildDetailTexts, formatInteger, getDamageValues, damageRows, detailSlots
--- 刷新伤害统计面板（仅三列数值文本）。
-- 与 `属性查看.j` 周期回调一致：头像 `DzFrameSetTexture` 只在创建时设一次，定时器里不刷头像。
function ____exports.updateDamagePanel()
    do
        local i = 0
        while i < #damageRows do
            local row = damageRows[i + 1]
            local values = getDamageValues(row.player)
            do
                local col = 0
                while col < #row.values do
                    do
                        local frame = row.values[col + 1]
                        if frame == 0 then
                            goto __continue58
                        end
                        japi.DzFrameSetText(
                            frame,
                            (_____5E38_91CF.DAMAGE_COLORS[col + 1] .. formatInteger(values[col + 1])) .. "|r"
                        )
                    end
                    ::__continue58::
                    col = col + 1
                end
            end
            i = i + 1
        end
    end
end
--- 刷新顶部头像对应的属性详情文本。
-- 文本内容完全由属性工具层统一生成，这里只负责回写到 DzFrame。
function ____exports.updateDetailPanels()
    do
        local i = 0
        while i < #detailSlots do
            local slot = detailSlots[i + 1]
            local texts = buildDetailTexts(slot.player)
            local lineIdx = 0
            do
                local textIndex = 0
                while textIndex < #texts do
                    local isSeparatorCol = textIndex % 5 == 1 or textIndex % 5 == 3
                    if not isSeparatorCol then
                        local frame = slot.lines[lineIdx + 1]
                        if frame ~= 0 then
                            japi.DzFrameSetText(frame, texts[textIndex + 1] or "")
                        end
                        lineIdx = lineIdx + 1
                    end
                    textIndex = textIndex + 1
                end
            end
            i = i + 1
        end
    end
end
japi = require("jass.japi")
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.04．硬件输入.index")
local frameSetScriptByCode = ____require_result_0.frameSetScriptByCode
_____5E38_91CF = require("系统.09．表现系统.03．UI属性系统.00．常量定义")
local ____require_result_1 = require("系统.09．表现系统.03．UI属性系统.01．属性工具")
buildDetailTexts = ____require_result_1.buildDetailTexts
formatInteger = ____require_result_1.formatInteger
getDamageValues = ____require_result_1.getDamageValues
local getHeroIcon = ____require_result_1.getHeroIcon
local getPlayerHero = ____require_result_1.getPlayerHero
local damagePanel = 0
local damagePanelCreated = false
damageRows = {}
detailSlots = {}
local registeredPlayers = __TS__New(Set)
local detailHoverSlotByFrameId = {}
local function createFrame(tagName, name, parent)
    return japi.DzCreateFrameByTagName(
        tagName,
        name,
        parent,
        "template",
        0
    )
end
local function setAbsolute(frame, x, y)
    if frame == 0 then
        return
    end
    japi.DzFrameSetAbsolutePoint(frame, _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT, x, y)
end
local function show(frame, visible)
    if frame == 0 then
        return
    end
    japi.DzFrameShow(frame, visible)
end
local function createText(parent, name, x, y, size, text)
    local frame = createFrame("TEXT", name, parent)
    if frame == 0 then
        return 0
    end
    setAbsolute(frame, x, y)
    japi.DzFrameSetText(frame, text)
    japi.DzFrameSetFont(frame, "UI\\uizt.ttf", size, 0)
    return frame
end
local function showDetailSlot(index, visible)
    local slot = detailSlots[index + 1]
    if slot == nil then
        return
    end
    show(slot.box, visible)
    do
        local i = 0
        while i < #slot.lines do
            show(slot.lines[i + 1], visible)
            i = i + 1
        end
    end
    do
        local i = 0
        while i < #slot.separators do
            show(slot.separators[i + 1], visible)
            i = i + 1
        end
    end
end
local function getTriggerUiEventFrame()
    return japi.DzGetTriggerUIEventFrame()
end
local function onDetailHoverEnter()
    local frame = getTriggerUiEventFrame()
    if frame == 0 then
        return
    end
    local index = detailHoverSlotByFrameId[frame]
    if index == nil then
        return
    end
    showDetailSlot(index, true)
end
local function onDetailHoverLeave()
    local frame = getTriggerUiEventFrame()
    if frame == 0 then
        return
    end
    local index = detailHoverSlotByFrameId[frame]
    if index == nil then
        return
    end
    showDetailSlot(index, false)
end
--- 创建左侧伤害统计面板（只创建一次）。
-- 结构直接对应原 JASS：标题行 + 每名玩家一行头像和三列数值。
local function createDamagePanel(gameUI)
    if damagePanelCreated then
        return
    end
    damagePanelCreated = true
    damagePanel = createFrame("BACKDROP", "UI属性系统伤害统计", gameUI)
    if damagePanel == 0 then
        return
    end
    japi.DzFrameSetTexture(damagePanel, _____5E38_91CF.PANEL_TEXTURE, 0)
    setAbsolute(damagePanel, _____5E38_91CF.DAMAGE_PANEL_X, _____5E38_91CF.DAMAGE_PANEL_Y)
    japi.DzFrameSetSize(damagePanel, _____5E38_91CF.DAMAGE_PANEL_WIDTH, _____5E38_91CF.DAMAGE_PANEL_HEIGHT)
    japi.DzFrameSetAlpha(damagePanel, _____5E38_91CF.DAMAGE_PANEL_ALPHA)
    show(damagePanel, false)
    do
        local i = 0
        while i < #_____5E38_91CF.DAMAGE_LABELS do
            createText(
                damagePanel,
                "UI属性系统伤害标题" .. tostring(i),
                _____5E38_91CF.DAMAGE_VALUE_X[i + 1],
                _____5E38_91CF.DAMAGE_TITLE_Y,
                0.012,
                _____5E38_91CF.DAMAGE_LABELS[i + 1]
            )
            i = i + 1
        end
    end
end
--- 为单个玩家创建伤害统计行。
-- 在玩家英雄注册后调用。
local function createDamageRowForPlayer(gameUI, player, hero, index)
    if damagePanel == 0 then
        return
    end
    local rowY = _____5E38_91CF.DAMAGE_ICON_Y - _____5E38_91CF.DAMAGE_ROW_STEP * index
    local icon = createFrame(
        "BACKDROP",
        "UI属性系统伤害头像" .. tostring(index),
        damagePanel
    )
    if icon ~= 0 then
        setAbsolute(icon, _____5E38_91CF.DAMAGE_ICON_X, rowY)
        japi.DzFrameSetTexture(
            icon,
            getHeroIcon(hero),
            0
        )
        japi.DzFrameSetSize(icon, _____5E38_91CF.DAMAGE_ICON_WIDTH, _____5E38_91CF.DAMAGE_ICON_HEIGHT)
        show(icon, true)
    end
    local values = {}
    do
        local col = 0
        while col < #_____5E38_91CF.DAMAGE_VALUE_X do
            values[#values + 1] = createText(
                damagePanel,
                (("UI属性系统伤害值" .. tostring(index)) .. "_") .. tostring(col),
                _____5E38_91CF.DAMAGE_VALUE_X[col + 1],
                _____5E38_91CF.DAMAGE_TITLE_Y - _____5E38_91CF.DAMAGE_ROW_STEP * (index + 1),
                0.009,
                "0"
            )
            col = col + 1
        end
    end
    damageRows[#damageRows + 1] = {icon = icon, values = values, player = player}
end
--- 为单个玩家创建顶部英雄头像入口与悬浮属性框。
-- 在玩家英雄注册后调用。
local function createDetailSlotForPlayer(gameUI, player, hero, index)
    local iconX = _____5E38_91CF.HERO_ICON_START_X + _____5E38_91CF.HERO_ICON_STEP_X * index
    local icon = createFrame(
        "BACKDROP",
        "UI属性系统英雄头像" .. tostring(index),
        gameUI
    )
    if icon == 0 then
        detailSlots[#detailSlots + 1] = {
            player = player,
            hero = hero,
            functionKey = _____5E38_91CF.KEY_F[index + 1],
            icon = 0,
            box = 0,
            lines = {},
            separators = {}
        }
        return
    end
    setAbsolute(icon, iconX, _____5E38_91CF.HERO_ICON_Y)
    japi.DzFrameSetSize(icon, _____5E38_91CF.HERO_ICON_WIDTH, _____5E38_91CF.HERO_ICON_HEIGHT)
    local iconPath = getHeroIcon(hero)
    japi.DzFrameSetTexture(icon, iconPath, 0)
    show(icon, true)
    createText(
        icon,
        "UI属性系统快捷键" .. tostring(index),
        iconX,
        _____5E38_91CF.HERO_KEY_Y,
        0.009,
        ("|cffffff00F" .. tostring(index + 2)) .. "|r"
    )
    local box = createFrame(
        "BACKDROP",
        "UI属性系统文本框" .. tostring(index),
        icon
    )
    local lines = {}
    local separators = {}
    if box ~= 0 then
        setAbsolute(box, _____5E38_91CF.DETAIL_BOX_X, _____5E38_91CF.DETAIL_BOX_Y)
        japi.DzFrameSetTexture(box, _____5E38_91CF.PANEL_TEXTURE, 0)
        japi.DzFrameSetSize(box, _____5E38_91CF.DETAIL_BOX_WIDTH, _____5E38_91CF.DETAIL_BOX_HEIGHT)
        show(box, false)
        do
            local lineIndex = 0
            while lineIndex < #_____5E38_91CF.DETAIL_LINE_LAYOUTS do
                local pos = _____5E38_91CF.DETAIL_LINE_LAYOUTS[lineIndex + 1]
                local isSeparatorCol = lineIndex % 5 == 1 or lineIndex % 5 == 3
                if not isSeparatorCol then
                    local line = createFrame(
                        "TEXT",
                        (("UI属性系统属性行" .. tostring(index)) .. "_") .. tostring(lineIndex),
                        box
                    )
                    if line ~= 0 then
                        japi.DzFrameSetPoint(
                            line,
                            _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT,
                            box,
                            _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT,
                            pos.x,
                            pos.y
                        )
                        japi.DzFrameSetSize(line, _____5E38_91CF.DETAIL_LINE_WIDTH, _____5E38_91CF.DETAIL_LINE_HEIGHT)
                        japi.DzFrameSetFont(line, "UI\\uizt.ttf", _____5E38_91CF.DETAIL_FONT_SIZE, 0)
                        show(line, false)
                        lines[#lines + 1] = line
                    end
                end
                lineIndex = lineIndex + 1
            end
        end
        local sepStartY = _____5E38_91CF.DETAIL_START_Y - _____5E38_91CF.DETAIL_ROW_STEP * _____5E38_91CF.DETAIL_SEP_START_ROW
        local sepEndY = _____5E38_91CF.DETAIL_START_Y - _____5E38_91CF.DETAIL_ROW_STEP * _____5E38_91CF.DETAIL_SEP_END_ROW
        local sepTotalHeight = (sepStartY - sepEndY + _____5E38_91CF.DETAIL_LINE_HEIGHT) * _____5E38_91CF.DETAIL_SEPARATOR_HEIGHT_MULT
        local sepWidth = _____5E38_91CF.DETAIL_SEPARATOR_WIDTH
        local sepRelY = sepEndY + _____5E38_91CF.DETAIL_SEPARATOR_Y_OFFSET
        local sep1 = createFrame(
            "BACKDROP",
            "UI属性系统分隔符1_" .. tostring(index),
            box
        )
        if sep1 ~= 0 then
            japi.DzFrameSetPoint(
                sep1,
                _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT,
                box,
                _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT,
                _____5E38_91CF.DETAIL_SEP1_X + _____5E38_91CF.DETAIL_SEPARATOR_X_OFFSET,
                sepRelY
            )
            japi.DzFrameSetSize(sep1, sepWidth, sepTotalHeight)
            japi.DzFrameSetTexture(sep1, "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0)
            japi.DzFrameSetPriority(sep1, 0)
            show(sep1, false)
            separators[#separators + 1] = sep1
        end
        local sep2 = createFrame(
            "BACKDROP",
            "UI属性系统分隔符2_" .. tostring(index),
            box
        )
        if sep2 ~= 0 then
            japi.DzFrameSetPoint(
                sep2,
                _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT,
                box,
                _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT,
                _____5E38_91CF.DETAIL_SEP2_X + _____5E38_91CF.DETAIL_SEPARATOR_X_OFFSET,
                sepRelY
            )
            japi.DzFrameSetSize(sep2, sepWidth, sepTotalHeight)
            japi.DzFrameSetTexture(sep2, "UI\\Widgets\\ToolTips\\Human\\human-tooltip-background.blp", 0)
            japi.DzFrameSetPriority(sep2, 0)
            show(sep2, false)
            separators[#separators + 1] = sep2
        end
    end
    local button = createFrame(
        "GLUETEXTBUTTON",
        "UI属性系统按钮" .. tostring(index),
        icon
    )
    if button ~= 0 then
        japi.DzFrameSetPoint(
            button,
            _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT,
            icon,
            _____5E38_91CF.ABSOLUTE_POINT_BOTTOMLEFT,
            0,
            0
        )
        japi.DzFrameSetSize(button, _____5E38_91CF.HERO_BUTTON_SIZE, _____5E38_91CF.HERO_BUTTON_SIZE)
        local playerId = jass.GetPlayerId(player)
        detailHoverSlotByFrameId[button] = index
        frameSetScriptByCode(
            nil,
            button,
            _____5E38_91CF.FRAME_EVENT_MOUSE_ENTER,
            onDetailHoverEnter,
            false,
            playerId
        )
        frameSetScriptByCode(
            nil,
            button,
            _____5E38_91CF.FRAME_EVENT_MOUSE_LEAVE,
            onDetailHoverLeave,
            false,
            playerId
        )
    end
    detailSlots[#detailSlots + 1] = {
        player = player,
        hero = hero,
        functionKey = _____5E38_91CF.KEY_F[index + 1],
        icon = icon,
        box = box,
        lines = lines,
        separators = separators
    }
end
--- 玩家英雄注册回调。
-- 每注册一个玩家英雄就创建一个UI槽位。
-- `this: void`：TSTL 勿对导出函数注入首参 nil（见玩家英雄获取桥接）。
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    if whichPlayer == nil or whichPlayer == 0 then
        return
    end
    local playerId = jass.GetPlayerId(whichPlayer)
    if playerId < 0 or playerId >= _____5E38_91CF.MAX_DISPLAY_PLAYERS then
        return
    end
    if registeredPlayers:has(playerId) then
        return
    end
    registeredPlayers:add(playerId)
    local gameUI = japi.DzGetGameUI()
    if gameUI == nil or gameUI == 0 then
        return
    end
    createDamagePanel(gameUI)
    local index = #detailSlots
    createDamageRowForPlayer(gameUI, whichPlayer, whichHero, index)
    createDetailSlotForPlayer(gameUI, whichPlayer, whichHero, index)
    ____exports.updateDamagePanel()
    ____exports.updateDetailPanels()
end
--- 创建基础UI框架（伤害面板）。
-- 具体玩家槽位由 onPlayerHeroRegistered 按需创建。
function ____exports.createUiFrames()
    local gameUI = japi.DzGetGameUI()
    if gameUI == nil or gameUI == 0 then
        return
    end
    createDamagePanel(gameUI)
end
function ____exports.showDamagePanel(visible)
    show(damagePanel, visible)
end
function ____exports.focusHeroByFunctionKey(functionKey)
    do
        local i = 0
        while i < #detailSlots do
            do
                if detailSlots[i + 1].functionKey ~= functionKey then
                    goto __continue52
                end
                return getPlayerHero(detailSlots[i + 1].player)
            end
            ::__continue52::
            i = i + 1
        end
    end
    return nil
end
return ____exports
