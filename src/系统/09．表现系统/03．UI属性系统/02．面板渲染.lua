--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local japi, _____5E38_91CF, buildDetailTexts, formatInteger, getDamageValues, getHeroIcon, getPlayerHero, damageRows, detailSlots
--- 刷新伤害统计面板。
-- 这里既更新伤害数字，也顺手刷新头像，避免玩家英雄替换后 UI 继续显示旧图标。
function ____exports.updateDamagePanel()
    do
        local i = 0
        while i < #damageRows do
            local row = damageRows[i + 1]
            local hero = getPlayerHero(row.player)
            if row.icon ~= 0 then
                japi.DzFrameSetTexture(
                    row.icon,
                    getHeroIcon(hero),
                    0
                )
            end
            local values = getDamageValues(row.player)
            do
                local col = 0
                while col < #row.values do
                    do
                        local frame = row.values[col + 1]
                        if frame == 0 then
                            goto __continue52
                        end
                        japi.DzFrameSetText(
                            frame,
                            (_____5E38_91CF.DAMAGE_COLORS[col + 1] .. formatInteger(values[col + 1])) .. "|r"
                        )
                    end
                    ::__continue52::
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
            slot.hero = getPlayerHero(slot.player)
            if slot.icon ~= 0 then
                japi.DzFrameSetTexture(
                    slot.icon,
                    getHeroIcon(slot.hero),
                    0
                )
            end
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
_____5E38_91CF = require("系统.09．表现系统.03．UI属性系统.00．常量定义")
local ____require_result_0 = require("系统.09．表现系统.03．UI属性系统.01．属性工具")
buildDetailTexts = ____require_result_0.buildDetailTexts
formatInteger = ____require_result_0.formatInteger
getDamageValues = ____require_result_0.getDamageValues
local getDisplayPlayers = ____require_result_0.getDisplayPlayers
getHeroIcon = ____require_result_0.getHeroIcon
getPlayerHero = ____require_result_0.getPlayerHero
local damagePanel = 0
damageRows = {}
detailSlots = {}
local function createFrame(tagName, name, parent)
    if type(japi.DzCreateFrameByTagName) ~= "function" then
        return 0
    end
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
    if frame == 0 or type(japi.DzFrameShow) ~= "function" then
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
local function createDetailHoverAction(index, visible)
    return function()
        showDetailSlot(index, visible)
    end
end
--- 创建左侧伤害统计面板。
-- 结构直接对应原 JASS：标题行 + 每名玩家一行头像和三列数值。
local function createDamagePanel(gameUI, players)
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
    do
        local i = 0
        while i < #players do
            local player = players[i + 1]
            local hero = getPlayerHero(player)
            local rowY = _____5E38_91CF.DAMAGE_ICON_Y - _____5E38_91CF.DAMAGE_ROW_STEP * i
            local icon = createFrame(
                "BACKDROP",
                "UI属性系统伤害头像" .. tostring(i),
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
                        (("UI属性系统伤害值" .. tostring(i)) .. "_") .. tostring(col),
                        _____5E38_91CF.DAMAGE_VALUE_X[col + 1],
                        _____5E38_91CF.DAMAGE_TITLE_Y - _____5E38_91CF.DAMAGE_ROW_STEP * (i + 1),
                        0.009,
                        "0"
                    )
                    col = col + 1
                end
            end
            damageRows[#damageRows + 1] = {icon = icon, values = values, player = player}
            i = i + 1
        end
    end
end
--- 创建顶部英雄头像入口与悬浮属性框。
-- 每个槽位绑定一个玩家，后续刷新时只更新头像与文本，不重复建框。
local function createDetailSlots(gameUI, players)
    do
        local i = 0
        while i < #players do
            local player = players[i + 1]
            local hero = getPlayerHero(player)
            local iconX = _____5E38_91CF.HERO_ICON_START_X + _____5E38_91CF.HERO_ICON_STEP_X * i
            local icon = createFrame(
                "BACKDROP",
                "UI属性系统英雄头像" .. tostring(i),
                gameUI
            )
            if icon ~= 0 then
                setAbsolute(icon, iconX, _____5E38_91CF.HERO_ICON_Y)
                japi.DzFrameSetSize(icon, _____5E38_91CF.HERO_ICON_WIDTH, _____5E38_91CF.HERO_ICON_HEIGHT)
                japi.DzFrameSetTexture(
                    icon,
                    getHeroIcon(hero),
                    0
                )
                show(icon, true)
            end
            createText(
                icon,
                "UI属性系统快捷键" .. tostring(i),
                iconX,
                _____5E38_91CF.HERO_KEY_Y,
                0.009,
                ("|cffffff00F" .. tostring(i + 2)) .. "|r"
            )
            local box = createFrame(
                "BACKDROP",
                "UI属性系统文本框" .. tostring(i),
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
                                (("UI属性系统属性行" .. tostring(i)) .. "_") .. tostring(lineIndex),
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
                    "UI属性系统分隔符1_" .. tostring(i),
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
                    "UI属性系统分隔符2_" .. tostring(i),
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
                "UI属性系统按钮" .. tostring(i),
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
                japi.DzFrameSetScriptByCode(
                    button,
                    _____5E38_91CF.FRAME_EVENT_MOUSE_ENTER,
                    createDetailHoverAction(i, true),
                    false
                )
                japi.DzFrameSetScriptByCode(
                    button,
                    _____5E38_91CF.FRAME_EVENT_MOUSE_LEAVE,
                    createDetailHoverAction(i, false),
                    false
                )
            end
            detailSlots[#detailSlots + 1] = {
                player = player,
                hero = hero,
                functionKey = _____5E38_91CF.KEY_F[i + 1],
                icon = icon,
                box = box,
                lines = lines,
                separators = separators
            }
            i = i + 1
        end
    end
end
--- 一次性创建整套 UI 框体。
-- 这里只负责“搭骨架”，具体数值文本由后续刷新函数填充。
function ____exports.createUiFrames()
    if type(japi.DzGetGameUI) ~= "function" then
        return
    end
    local gameUI = japi.DzGetGameUI()
    if gameUI == nil or gameUI == 0 then
        return
    end
    local players = getDisplayPlayers()
    createDamagePanel(gameUI, players)
    createDetailSlots(gameUI, players)
    ____exports.updateDamagePanel()
    ____exports.updateDetailPanels()
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
                    goto __continue45
                end
                return detailSlots[i + 1].hero
            end
            ::__continue45::
            i = i + 1
        end
    end
    return nil
end
return ____exports
