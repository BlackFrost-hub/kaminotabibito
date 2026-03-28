local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local _____786C_4EF6_51FD_6570 = require("系统.00．核心系统.硬件函数")
local getGameUI = _____786C_4EF6_51FD_6570.getGameUI
local ____UI_5DE5_5177 = require("系统.09．表现系统.UI工具")
local createFrame = ____UI_5DE5_5177.createFrame
local setFramePosition = ____UI_5DE5_5177.setFramePosition
local setFrameSize = ____UI_5DE5_5177.setFrameSize
local setFrameTexture = ____UI_5DE5_5177.setFrameTexture
local setFrameHoverEvents = ____UI_5DE5_5177.setFrameHoverEvents
local setFramePointRelative = ____UI_5DE5_5177.setFramePointRelative
local createTextLabel = ____UI_5DE5_5177.createTextLabel
local FrameType = ____UI_5DE5_5177.FrameType
local FramePoint = ____UI_5DE5_5177.FramePoint
local hideFrame = ____UI_5DE5_5177.hideFrame
local showFrame = ____UI_5DE5_5177.showFrame
--- 类原生 Buff 条：单选单位时，在屏幕固定区域横向展示 Debuff 图标（与 Buff 表 priority 排序）。
-- 依赖 dot伤害 已施加的反恢复/燃烧；英雄带「树枝」等装备攻击即可叠 DOT，选中目标后显示。
local jass = require("jass.common")
local japi = require("jass.japi")
local ____temp_0
if jass.EVENT_PLAYER_UNIT_SELECTED ~= nil then
    ____temp_0 = jass.EVENT_PLAYER_UNIT_SELECTED
else
    ____temp_0 = 58
end
local EV_UNIT_SELECTED = ____temp_0
local ____temp_2
if jass.EVENT_PLAYER_UNIT_DESELECTED ~= nil then
    ____temp_2 = jass.EVENT_PLAYER_UNIT_DESELECTED
else
    local ____temp_1
    if jass.EVENT_PLAYER_UNIT_DESELECT_ALL ~= nil then
        ____temp_1 = jass.EVENT_PLAYER_UNIT_DESELECT_ALL
    else
        ____temp_1 = 59
    end
    ____temp_2 = ____temp_1
end
local EV_UNIT_DESELECTED = ____temp_2
local dotMod = require("系统.04．伤害系统.dot伤害")
local buffPoolMod = require("系统.05．Buff系统.Buff系统")
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
--- 原生 Buff 区：左下肖像上方偏右，横向排列（归一化坐标，相对 GameUI）
local BUFF_BAR_X0 = 0.204
--- 相对初始 0.128 再上移 0.03（本坐标系 y 增大为往上）
local BUFF_BAR_Y = 0.1655
local ICON_W = 0.02
local ICON_H = 16 / 600
local ICON_GAP = 0.0005
local MAX_SLOTS = 20
local TIP_BOX_TEX = "war3mapImported\\wenbenkuang.blp"
local TIP_W = 0.22
--- 两行说明（表文案 + 来源行）略增高
local TIP_H = 0.056
local TIP_PAD = 0.005
--- 提示框相对 Buff 图标顶边的纵向偏移（本坐标系 y 增大为往上）
local TIP_OFFSET_Y_FROM_ICON_TOP = 0.07
--- 提示第一行：偏暖的浅米色，在棕色底上易读
local TIP_COLOR_BODY = "|cfffff2d9"
--- 提示第二行（来源）：金色，与正文区分且更醒目
local TIP_COLOR_SOURCE = "|cffffd700"
--- 提示文案内数值一律去小数，向下取整为整数显示
local function tooltipIntStr(self, n)
    if type(n) ~= "number" or not __TS__NumberIsFinite(__TS__Number(n)) then
        return "0"
    end
    return tostring(math.floor(math.max(0, n)))
end
local function formatDotTooltip(self, template, durationForDisplay, dps, sourceName, intervalSec)
    local rem = type(durationForDisplay) == "number" and __TS__NumberIsFinite(__TS__Number(durationForDisplay)) and math.max(0, durationForDisplay) or 0
    local dpsN = type(dps) == "number" and __TS__NumberIsFinite(__TS__Number(dps)) and dps or 0
    local intv = type(intervalSec) == "number" and __TS__NumberIsFinite(__TS__Number(intervalSec)) and intervalSec > 0 and intervalSec or 1
    local rStr = tooltipIntStr(nil, rem)
    local dStr = tooltipIntStr(nil, dpsN)
    local iStr = tooltipIntStr(nil, intv)
    local s = template
    s = table.concat(
        __TS__StringSplit(s, "持续时间"),
        rStr or ","
    )
    s = table.concat(
        __TS__StringSplit(s, "interval"),
        iStr or ","
    )
    s = table.concat(
        __TS__StringSplit(s, "damage"),
        dStr or ","
    )
    local src = sourceName ~= nil and sourceName ~= "" and sourceName or "未知"
    return (((((TIP_COLOR_BODY .. s) .. "|r\n") .. TIP_COLOR_SOURCE) .. "buff来源为「") .. src) .. "」|r"
end
local function tryDzFrameSetTooltipF2i(self, hostFrame, tooltipFrame)
    if not hostFrame or hostFrame == 0 or not tooltipFrame or tooltipFrame == 0 then
        return
    end
    local setTip = japi.DzFrameSetTooltip
    if type(setTip) ~= "function" then
        return
    end
    local f2i = japi.DzF2I
    pcall(function ()
            local ____temp_3
            if type(f2i) == "function" then
                ____temp_3 = f2i(nil, tooltipFrame)
            else
                ____temp_3 = tooltipFrame
            end
            local tipId = ____temp_3
            setTip(nil, hostFrame, tipId)
        end
    )
end
local slots = {}
--- 与槽位一一对应，仅当提示文案变化时才 DzFrameSetText，避免 0.5s 定时器无意义刷新
local lastTipStrBySlot = {}
--- 鼠标是否仍悬停在该槽 hit 上；定时 syncBuffBar 不可强行 hideFrame 提示，否则会误关 tooltip
local slotHovering = {}
local refreshTimer = nil
--- 为 true 时向本地玩家刷诊断文字（选中数量、handleId、Buff 池、DOT 读数）。
____exports.BUFF_UI_DEBUG = false
local lastBuffUiDbgKey = ""
local function debugBuffUi(self, msg)
    if not ____exports.BUFF_UI_DEBUG then
        return
    end
    if type(jass.GetLocalPlayer) ~= "function" or type(jass.DisplayTextToPlayer) ~= "function" then
        return
    end
    local p = jass.GetLocalPlayer()
    jass.DisplayTextToPlayer(p, 0, 0, "[BuffUI] " .. msg)
end
--- 当前玩家选中单位数量 + 第一个选中（含敌方）。勿用 GroupEnumUnitsOfPlayer。
-- 优先 GroupEnumUnitsSelected；无则全图矩形枚举 + IsUnitSelected。
local function countSelectedForPlayer(self, p)
    if not p or p == 0 then
        return {n = 0, sole = nil}
    end
    if type(jass.CreateGroup) ~= "function" then
        return {n = 0, sole = nil}
    end
    local g = jass.CreateGroup()
    local useSelectedNative = type(jass.GroupEnumUnitsSelected) == "function"
    if useSelectedNative then
        jass.GroupEnumUnitsSelected(g, p, nil)
    else
        if type(jass.IsUnitSelected) ~= "function" or type(jass.GetWorldBounds) ~= "function" or type(jass.GroupEnumUnitsInRect) ~= "function" then
            jass.DestroyGroup(g)
            return {n = 0, sole = nil}
        end
        jass.GroupEnumUnitsInRect(
            g,
            jass.GetWorldBounds(),
            nil
        )
    end
    local n = 0
    local sole = nil
    while true do
        do
            local __continue18
            repeat
                local u = jass.FirstOfGroup(g)
                if not u or u == 0 then
                    break
                end
                jass.GroupRemoveUnit(g, u)
                if not useSelectedNative and not jass.IsUnitSelected(u, p) then
                    __continue18 = true
                    break
                end
                n = n + 1
                if sole == nil then
                    sole = u
                end
                __continue18 = true
            until true
            if not __continue18 then
                break
            end
        end
    end
    jass.DestroyGroup(g)
    return {n = n, sole = sole}
end
local function getSoleSelectedUnitForPlayer(self, p)
    local ____countSelectedForPlayer_result_4 = countSelectedForPlayer(nil, p)
    local n = ____countSelectedForPlayer_result_4.n
    local sole = ____countSelectedForPlayer_result_4.sole
    if n ~= 1 then
        return nil
    end
    return sole
end
local function collectBuffRows(self, unit)
    local rows = {}
    if not buffPoolMod:isUnitInBuffPool(unit) then
        return rows
    end
    local ids = buffPoolMod:getBuffIdsOnUnit(unit)
    do
        local i = 0
        while i < #ids do
            local bid = ids[i + 1]
            if bid == "D001" then
                local ah = dotMod:getUnitAntiHeal(unit)
                if ah ~= nil then
                    rows[#rows + 1] = {id = "D001", state = {effect = ah.effect, remaining = ah.remaining, sourceName = ah.sourceName, _dotParsedDuration = ah._dotParsedDuration}}
                end
            elseif bid == "D002" then
                local br = dotMod:getUnitBurn(unit)
                if br ~= nil then
                    rows[#rows + 1] = {id = "D002", state = {effect = br.effect, remaining = br.remaining, sourceName = br.sourceName, _dotParsedDuration = br._dotParsedDuration}}
                end
            else
                local rt = buffPoolMod:getBuffRuntime(unit, bid)
                if rt ~= nil then
                    rows[#rows + 1] = {id = bid, state = {effect = rt.effect, remaining = rt.remaining}}
                end
            end
            i = i + 1
        end
    end
    local buffs = buffTableMod.buffs
    __TS__ArraySort(
        rows,
        function(____, a, b)
            local pa = buffs[a.id] ~= nil and buffs[a.id].priority or 0
            local pb = buffs[b.id] ~= nil and buffs[b.id].priority or 0
            if pa ~= pb then
                return pb - pa
            end
            return a.id < b.id and -1 or 1
        end
    )
    return rows
end
local function hideSlot(self, i)
    local s = slots[i + 1]
    if s == nil then
        return
    end
    slotHovering[i + 1] = false
    lastTipStrBySlot[i + 1] = ""
    if s.tipText ~= 0 then
        hideFrame(nil, s.tipText)
    end
    if s.tipBox ~= 0 then
        hideFrame(nil, s.tipBox)
    end
    if s.hit ~= 0 then
        hideFrame(nil, s.hit)
    end
    if s.root ~= 0 then
        hideFrame(nil, s.root)
    end
end
local function hideAllSlots(self)
    do
        local i = 0
        while i < MAX_SLOTS do
            hideSlot(nil, i)
            i = i + 1
        end
    end
end
local function syncBuffBar(self)
    if type(jass.GetLocalPlayer) ~= "function" then
        hideAllSlots(nil)
        return
    end
    local lp = jass.GetLocalPlayer()
    local ____countSelectedForPlayer_result_5 = countSelectedForPlayer(nil, lp)
    local selN = ____countSelectedForPlayer_result_5.n
    local sole = ____countSelectedForPlayer_result_5.sole
    local hid = sole ~= nil and sole ~= 0 and type(jass.GetHandleId) == "function" and jass.GetHandleId(sole) or 0
    local inPool = sole ~= nil and sole ~= 0 and buffPoolMod:isUnitInBuffPool(sole)
    local ____temp_6
    if sole ~= nil and sole ~= 0 then
        ____temp_6 = dotMod:getUnitAntiHeal(sole)
    else
        ____temp_6 = nil
    end
    local ah = ____temp_6
    local ____temp_7
    if sole ~= nil and sole ~= 0 then
        ____temp_7 = dotMod:getUnitBurn(sole)
    else
        ____temp_7 = nil
    end
    local br = ____temp_7
    if ____exports.BUFF_UI_DEBUG then
        local rowsProbe = sole ~= nil and sole ~= 0 and selN == 1 and collectBuffRows(nil, sole) or ({})
        local key = (((((((((tostring(selN) .. "|") .. tostring(hid)) .. "|") .. tostring(inPool)) .. "|") .. tostring(ah ~= nil)) .. "|") .. tostring(br ~= nil)) .. "|") .. tostring(#rowsProbe)
        if key ~= lastBuffUiDbgKey then
            lastBuffUiDbgKey = key
            debugBuffUi(
                nil,
                (((((((((("sel=" .. tostring(selN)) .. " hid=") .. tostring(hid)) .. " pool=") .. tostring(inPool and 1 or 0)) .. " dotAH=") .. tostring(ah ~= nil and 1 or 0)) .. " dotBr=") .. tostring(br ~= nil and 1 or 0)) .. " rows=") .. tostring(#rowsProbe)
            )
        end
    end
    if not sole or selN ~= 1 then
        hideAllSlots(nil)
        return
    end
    local rows = collectBuffRows(nil, sole)
    local buffs = buffTableMod.buffs
    do
        local i = 0
        while i < MAX_SLOTS do
            do
                local __continue51
                repeat
                    if i >= #rows then
                        hideSlot(nil, i)
                        __continue51 = true
                        break
                    end
                    local row = rows[i + 1]
                    local meta = buffs[row.id]
                    local slot = slots[i + 1]
                    if not meta or not slot then
                        __continue51 = true
                        break
                    end
                    local pd = row.state._dotParsedDuration
                    local durationForTip = type(pd) == "number" and __TS__NumberIsFinite(__TS__Number(pd)) and pd > 0 and pd or row.state.remaining
                    local tipStr = formatDotTooltip(
                        nil,
                        meta.tooltip,
                        durationForTip,
                        row.state.effect,
                        row.state.sourceName,
                        meta.interval
                    )
                    setFrameTexture(nil, slot.root, meta.icon)
                    if slot.tipText and slot.tipText ~= 0 and type(japi.DzFrameSetText) == "function" then
                        if lastTipStrBySlot[i + 1] ~= tipStr then
                            lastTipStrBySlot[i + 1] = tipStr
                            japi.DzFrameSetText(slot.tipText, tipStr)
                        end
                    end
                    showFrame(nil, slot.root)
                    if slot.hit ~= 0 then
                        showFrame(nil, slot.hit)
                    end
                    if not slotHovering[i + 1] then
                        if slot.tipBox ~= 0 then
                            hideFrame(nil, slot.tipBox)
                        end
                        if slot.tipText ~= 0 then
                            hideFrame(nil, slot.tipText)
                        end
                    end
                    __continue51 = true
                until true
                if not __continue51 then
                    break
                end
            end
            i = i + 1
        end
    end
end
local function onSelectionChanged(self)
    if type(jass.GetLocalPlayer) ~= "function" or type(jass.GetTriggerPlayer) ~= "function" then
        return
    end
    if jass.GetLocalPlayer() ~= jass.GetTriggerPlayer() then
        return
    end
    syncBuffBar(nil)
end
local function createOneSlot(self, index, parent)
    local x = BUFF_BAR_X0 + index * (ICON_W + ICON_GAP)
    local bd = createFrame(
        nil,
        {
            type = FrameType.BACKDROP,
            name = "BuffUIBarIcon" .. tostring(index),
            parent = parent,
            template = "template",
            visible = false
        }
    ) or 0
    if not bd or bd == 0 then
        return nil
    end
    setFramePosition(nil, bd, {point = FramePoint.TOPLEFT, x = x, y = BUFF_BAR_Y})
    setFrameSize(nil, bd, {width = ICON_W, height = ICON_H})
    setFrameTexture(nil, bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp")
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(bd, 180)
    end
    local hit = createFrame(
        nil,
        {
            type = FrameType.GLUETEXTBUTTON,
            name = "BuffUIBarHit" .. tostring(index),
            parent = bd,
            template = "template",
            visible = false,
            enable = true,
            alpha = 0
        }
    ) or 0
    if hit and hit ~= 0 and type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(hit, bd)
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(hit, 181)
        end
        setFrameHoverEvents(
            nil,
            hit,
            function()
                slotHovering[index + 1] = true
                local s = slots[index + 1]
                if s ~= nil and s.tipBox ~= 0 then
                    showFrame(nil, s.tipBox)
                end
                if s ~= nil and s.tipText ~= 0 then
                    showFrame(nil, s.tipText)
                end
            end,
            function()
                slotHovering[index + 1] = false
                local s = slots[index + 1]
                if s ~= nil and s.tipText ~= 0 then
                    hideFrame(nil, s.tipText)
                end
                if s ~= nil and s.tipBox ~= 0 then
                    hideFrame(nil, s.tipBox)
                end
            end,
            false
        )
    end
    local boxW = TIP_W + TIP_PAD * 2
    local boxH = TIP_H + TIP_PAD * 2
    --- 挂在 GameUI 上并提高 Level，避免被右侧相邻图标挡住
    local tipBox = createFrame(
        nil,
        {
            type = FrameType.BACKDROP,
            name = "BuffUIBarTip" .. tostring(index),
            parent = parent,
            template = "template",
            visible = false
        }
    ) or 0
    if tipBox and tipBox ~= 0 then
        setFramePointRelative(
            nil,
            tipBox,
            FramePoint.TOPLEFT,
            bd,
            FramePoint.TOPRIGHT,
            0.002,
            TIP_OFFSET_Y_FROM_ICON_TOP
        )
        setFrameSize(nil, tipBox, {width = boxW, height = boxH})
        setFrameTexture(nil, tipBox, TIP_BOX_TEX)
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(tipBox, 0)
        end
        hideFrame(nil, tipBox)
    end
    local tipText = createTextLabel(
        nil,
        "BuffUIBarTipTxt" .. tostring(index),
        tipBox and tipBox ~= 0 and tipBox or bd,
        "",
        tipBox and tipBox ~= 0 and ({
            relativeTo = tipBox,
            point = FramePoint.CENTER,
            relativePoint = FramePoint.CENTER,
            x = 0,
            y = 0
        }) or ({
            relativeTo = bd,
            point = FramePoint.TOPLEFT,
            relativePoint = FramePoint.TOPRIGHT,
            x = 0.002,
            y = TIP_OFFSET_Y_FROM_ICON_TOP
        }),
        {width = boxW * 0.92, height = boxH * 0.88}
    ) or 0
    if tipText and tipText ~= 0 then
        if type(japi.DzFrameSetTextAlignment) == "function" then
            pcall(function ()
                    japi.DzFrameSetTextAlignment(tipText, 0)
                end
            )
        end
        if type(japi.DzFrameSetLevel) == "function" then
            japi.DzFrameSetLevel(tipText, 0)
        end
        hideFrame(nil, tipText)
    end
    if hit ~= 0 and tipBox ~= 0 then
        tryDzFrameSetTooltipF2i(nil, hit, tipBox)
    end
    hideFrame(nil, bd)
    return {root = bd, hit = hit or 0, tipBox = tipBox or 0, tipText = tipText or 0}
end
local function createUi(self)
    local parent = getGameUI(nil)
    if parent == 0 or parent == nil then
        return
    end
    do
        local j = 0
        while j < MAX_SLOTS do
            lastTipStrBySlot[j + 1] = ""
            slotHovering[j + 1] = false
            j = j + 1
        end
    end
    do
        local i = 0
        while i < MAX_SLOTS do
            local s = createOneSlot(nil, i, parent)
            if s ~= nil then
                slots[i + 1] = s
            end
            i = i + 1
        end
    end
end
local function registerTriggers(self)
    local ____temp_8
    if type(jass.CreateTrigger) == "function" then
        ____temp_8 = jass.CreateTrigger()
    else
        ____temp_8 = nil
    end
    local trig = ____temp_8
    if not trig then
        return
    end
    do
        local i = 0
        while i < 16 do
            if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
                jass.TriggerRegisterPlayerUnitEvent(
                    trig,
                    jass.Player(i),
                    EV_UNIT_SELECTED,
                    nil
                )
                jass.TriggerRegisterPlayerUnitEvent(
                    trig,
                    jass.Player(i),
                    EV_UNIT_DESELECTED,
                    nil
                )
            end
            i = i + 1
        end
    end
    if type(jass.TriggerAddAction) == "function" then
        jass.TriggerAddAction(trig, onSelectionChanged)
    end
end
local function startRefreshTimer(self)
    if refreshTimer ~= nil then
        return
    end
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
        return
    end
    refreshTimer = jass.CreateTimer()
    jass.TimerStart(
        refreshTimer,
        0.5,
        true,
        function()
            syncBuffBar(nil)
        end
    )
end
function ____exports.init(self)
    createUi(nil)
    registerTriggers(nil)
    startRefreshTimer(nil)
end
return ____exports
