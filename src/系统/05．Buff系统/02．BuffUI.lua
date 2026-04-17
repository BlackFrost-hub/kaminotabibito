local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local __TS__NumberToFixed = ____lualib.__TS__NumberToFixed
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local _____786C_4EF6_51FD_6570 = require("lib.扩展函数.封装函数.04．硬件输入.index")
local ____UI_5DE5_5177 = require("系统.09．表现系统.01．UI工具.index")
local buffPoolMod = require("系统.05．Buff系统.00．Buff系统")
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
local BUFF_BAR_X0 = 0.204
local BUFF_BAR_Y = 0.1655
local ICON_W = 0.02
local ICON_H = 16 / 600
local ICON_GAP = 0.0005
local MAX_SLOTS = 20
local BUFF_BAR_REFRESH_SEC = 0.1
local TIP_BOX_TEX = "UI\\wenbenkuang.blp"
local TIP_W = 0.22
local TIP_H = 0.056
local TIP_PAD = 0.005
local TIP_OFFSET_Y_FROM_ICON_TOP = 0.07
local TIP_COLOR_BODY = "|cfffff2d9"
local TIP_COLOR_SOURCE = "|cffffd700"
local function tooltipIntStr(self, n)
    if type(n) ~= "number" or not __TS__NumberIsFinite(__TS__Number(n)) then
        return "0"
    end
    return tostring(math.floor(math.max(0, n)))
end
local function formatBuffRemainOneDecimal(self, rem)
    if type(rem) ~= "number" or not __TS__NumberIsFinite(__TS__Number(rem)) then
        return "0.0"
    end
    return __TS__NumberToFixed(
        math.max(0, rem),
        1
    )
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
    if type(japi.DzFrameSetTooltip) ~= "function" then
        return
    end
    pcall(function ()
            local ____temp_0
            if type(japi.DzF2I) == "function" then
                ____temp_0 = japi.DzF2I(tooltipFrame)
            else
                ____temp_0 = tooltipFrame
            end
            local tipId = ____temp_0
            japi.DzFrameSetTooltip(hostFrame, tipId)
        end
    )
end
local slots = {}
local lastTipStrBySlot = {}
local lastRemainStrBySlot = {}
local slotHovering = {}
local refreshTimer = nil
local buffUiInitialized = false
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
            local u = jass.FirstOfGroup(g)
            if not u or u == 0 then
                break
            end
            jass.GroupRemoveUnit(g, u)
            if not useSelectedNative and not jass.IsUnitSelected(u, p) then
                goto __continue20
            end
            n = n + 1
            if sole == nil then
                sole = u
            end
        end
        ::__continue20::
    end
    jass.DestroyGroup(g)
    return {n = n, sole = sole}
end
local function getSoleSelectedUnitForPlayer(self, p)
    local ____countSelectedForPlayer_result_1 = countSelectedForPlayer(nil, p)
    local n = ____countSelectedForPlayer_result_1.n
    local sole = ____countSelectedForPlayer_result_1.sole
    if n ~= 1 then
        return nil
    end
    return sole
end
local function isUnitRefLikelyValid(self, u)
    if u == nil or u == 0 then
        return false
    end
    if type(jass.GetUnitTypeId) ~= "function" then
        return true
    end
    local tid = jass.GetUnitTypeId(u)
    return tid ~= nil and tid ~= 0
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
            local rt = buffPoolMod:getBuffRuntime(unit, bid)
            if rt ~= nil then
                local real = rt.remaining
                local iconRem = type(buffPoolMod.getDotIconDisplayRemaining) == "function" and buffPoolMod:getDotIconDisplayRemaining(unit, bid, real) or real
                local row = {id = bid, state = {effect = rt.effect, remaining = real, iconRemaining = iconRem, sourceName = rt.sourceName}, iconOverride = rt.iconOverride}
                if bid == "D001" or bid == "D002" or bid == "D003" or bid == "D004" then
                    row.state._dotParsedDuration = rt._dotParsedDuration
                end
                rows[#rows + 1] = row
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
    lastRemainStrBySlot[i + 1] = ""
    if s.tipText ~= 0 then
        pcall(function () return ____UI_5DE5_5177:hideFrame(s.tipText) end
        )
    end
    if s.tipBox ~= 0 then
        pcall(function () return ____UI_5DE5_5177:hideFrame(s.tipBox) end
        )
    end
    if s.hit ~= 0 then
        pcall(function () return ____UI_5DE5_5177:hideFrame(s.hit) end
        )
    end
    if s.root ~= 0 then
        pcall(function () return ____UI_5DE5_5177:hideFrame(s.root) end
        )
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
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                hideAllSlots(nil)
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil or lp == 0 then
                return
            end
            local ____countSelectedForPlayer_result_2 = countSelectedForPlayer(nil, lp)
            local selN = ____countSelectedForPlayer_result_2.n
            local sole = ____countSelectedForPlayer_result_2.sole
            local hid = sole ~= nil and sole ~= 0 and type(jass.GetHandleId) == "function" and jass.GetHandleId(sole) or 0
            local soleOk = sole ~= nil and sole ~= 0 and isUnitRefLikelyValid(nil, sole)
            local inPool = soleOk and buffPoolMod:isUnitInBuffPool(sole)
            local ____soleOk_3
            if soleOk then
                ____soleOk_3 = buffPoolMod:getBuffRuntime(sole, "D001")
            else
                ____soleOk_3 = nil
            end
            local rtD001 = ____soleOk_3
            local ____soleOk_4
            if soleOk then
                ____soleOk_4 = buffPoolMod:getBuffRuntime(sole, "D002")
            else
                ____soleOk_4 = nil
            end
            local rtD002 = ____soleOk_4
            local ____soleOk_5
            if soleOk then
                ____soleOk_5 = buffPoolMod:getBuffRuntime(sole, "D003")
            else
                ____soleOk_5 = nil
            end
            local rtD003 = ____soleOk_5
            if ____exports.BUFF_UI_DEBUG then
                local rowsProbe = soleOk and selN == 1 and collectBuffRows(nil, sole) or ({})
                local key = (((((((((((tostring(selN) .. "|") .. tostring(hid)) .. "|") .. tostring(inPool)) .. "|") .. tostring(rtD001 ~= nil)) .. "|") .. tostring(rtD002 ~= nil)) .. "|") .. tostring(rtD003 ~= nil)) .. "|") .. tostring(#rowsProbe)
                if key ~= lastBuffUiDbgKey then
                    lastBuffUiDbgKey = key
                    debugBuffUi(
                        nil,
                        (((((((((((("sel=" .. tostring(selN)) .. " hid=") .. tostring(hid)) .. " pool=") .. tostring(inPool and 1 or 0)) .. " D001=") .. tostring(rtD001 ~= nil and 1 or 0)) .. " D002=") .. tostring(rtD002 ~= nil and 1 or 0)) .. " D003=") .. tostring(rtD003 ~= nil and 1 or 0)) .. " rows=") .. tostring(#rowsProbe)
                    )
                end
            end
            if not soleOk or selN ~= 1 then
                hideAllSlots(nil)
                return
            end
            local rows = collectBuffRows(nil, sole)
            local buffs = buffTableMod.buffs
            do
                local i = 0
                while i < MAX_SLOTS do
                    do
                        if i >= #rows then
                            hideSlot(nil, i)
                            goto __continue58
                        end
                        local row = rows[i + 1]
                        local meta = buffs[row.id]
                        local slot = slots[i + 1]
                        if not slot then
                            goto __continue58
                        end
                        local iconTex = row.iconOverride ~= nil and row.iconOverride ~= "" and row.iconOverride or (meta ~= nil and meta.icon or "")
                        if iconTex == "" then
                            goto __continue58
                        end
                        local pd = row.state._dotParsedDuration
                        local durationForTip = type(pd) == "number" and __TS__NumberIsFinite(__TS__Number(pd)) and pd > 0 and pd or row.state.remaining
                        local tipStr = meta ~= nil and formatDotTooltip(
                            nil,
                            meta.tooltip,
                            durationForTip,
                            row.state.effect,
                            row.state.sourceName,
                            meta.interval
                        ) or (((((((((TIP_COLOR_BODY .. row.id) .. " 剩余 ") .. tooltipIntStr(nil, row.state.remaining)) .. " 秒，伤害/秒 ") .. tooltipIntStr(nil, row.state.effect)) .. "|r\n") .. TIP_COLOR_SOURCE) .. "buff来源为「") .. (row.state.sourceName ~= nil and row.state.sourceName ~= "" and row.state.sourceName or "未知")) .. "」|r"
                        pcall(function () return ____UI_5DE5_5177:setFrameTexture(slot.root, iconTex) end
                        )
                        local remStr = formatBuffRemainOneDecimal(nil, row.state.iconRemaining)
                        if slot.remainText and slot.remainText ~= 0 and type(japi.DzFrameSetText) == "function" then
                            if lastRemainStrBySlot[i + 1] ~= remStr then
                                lastRemainStrBySlot[i + 1] = remStr
                                pcall(function () return japi.DzFrameSetText(slot.remainText, ("|cffffffff" .. remStr) .. "|r") end
                                )
                            end
                        end
                        if slot.tipText and slot.tipText ~= 0 and type(japi.DzFrameSetText) == "function" then
                            if lastTipStrBySlot[i + 1] ~= tipStr then
                                lastTipStrBySlot[i + 1] = tipStr
                                pcall(function () return japi.DzFrameSetText(slot.tipText, tipStr) end
                                )
                            end
                        end
                        pcall(function () return ____UI_5DE5_5177:showFrame(slot.root) end
                        )
                        if slot.hit ~= 0 then
                            pcall(function () return ____UI_5DE5_5177:showFrame(slot.hit) end
                            )
                        end
                        if not slotHovering[i + 1] then
                            if slot.tipBox ~= 0 then
                                pcall(function () return ____UI_5DE5_5177:hideFrame(slot.tipBox) end
                                )
                            end
                            if slot.tipText ~= 0 then
                                pcall(function () return ____UI_5DE5_5177:hideFrame(slot.tipText) end
                                )
                            end
                        end
                    end
                    ::__continue58::
                    i = i + 1
                end
            end
        end
    )
end
local function createOneSlot(self, index, parent)
    do
        local function ____catch(e)
            return true, nil
        end
        local ____try, ____hasReturned, ____returnValue = pcall(function()
            local x = BUFF_BAR_X0 + index * (ICON_W + ICON_GAP)
            local bd = ____UI_5DE5_5177:createFrame({
                type = ____UI_5DE5_5177.FrameType.BACKDROP,
                name = "BuffUIBarIcon" .. tostring(index),
                parent = parent,
                template = "template",
                visible = false
            }) or 0
            if not bd or bd == 0 then
                return true, nil
            end
            pcall(function () return ____UI_5DE5_5177:setFramePosition(bd, {point = ____UI_5DE5_5177.FramePoint.TOPLEFT, x = x, y = BUFF_BAR_Y}) end
            )
            pcall(function () return ____UI_5DE5_5177:setFrameSize(bd, {width = ICON_W, height = ICON_H}) end
            )
            pcall(function () return ____UI_5DE5_5177:setFrameTexture(bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp") end
            )
            if type(japi.DzFrameSetLevel) == "function" then
                pcall(function () return japi.DzFrameSetLevel(bd, 180) end
                )
            end
            local remainText = ____UI_5DE5_5177:createTextLabel(
                "BuffUIBarRemain" .. tostring(index),
                bd,
                "|cffffffff0.0|r",
                {
                    relativeTo = bd,
                    point = ____UI_5DE5_5177.FramePoint.BOTTOM,
                    relativePoint = ____UI_5DE5_5177.FramePoint.BOTTOM,
                    x = 0,
                    y = 0.001
                },
                {width = ICON_W, height = 0.014}
            ) or 0
            if remainText and remainText ~= 0 then
                if type(japi.DzFrameSetTextAlignment) == "function" then
                    pcall(function ()
                            japi.DzFrameSetTextAlignment(remainText, ____UI_5DE5_5177.FramePoint.CENTER)
                        end
                    )
                end
                if type(japi.DzFrameSetLevel) == "function" then
                    pcall(function () return japi.DzFrameSetLevel(remainText, 182) end
                    )
                end
            end
            local hit = ____UI_5DE5_5177:createFrame({
                type = ____UI_5DE5_5177.FrameType.GLUETEXTBUTTON,
                name = "BuffUIBarHit" .. tostring(index),
                parent = bd,
                template = "template",
                visible = false,
                enable = true,
                alpha = 0
            }) or 0
            if hit and hit ~= 0 and type(japi.DzFrameSetAllPoints) == "function" then
                pcall(function () return japi.DzFrameSetAllPoints(hit, bd) end
                )
                if type(japi.DzFrameSetLevel) == "function" then
                    pcall(function () return japi.DzFrameSetLevel(hit, 181) end
                    )
                end
                pcall(function () return ____UI_5DE5_5177:setFrameHoverEvents(
                        hit,
                        function()
                            slotHovering[index + 1] = true
                            local s = slots[index + 1]
                            if s ~= nil and s.tipBox ~= 0 then
                                pcall(function () return ____UI_5DE5_5177:showFrame(s.tipBox) end
                                )
                            end
                            if s ~= nil and s.tipText ~= 0 then
                                pcall(function () return ____UI_5DE5_5177:showFrame(s.tipText) end
                                )
                            end
                        end,
                        function()
                            slotHovering[index + 1] = false
                            local s = slots[index + 1]
                            if s ~= nil and s.tipText ~= 0 then
                                pcall(function () return ____UI_5DE5_5177:hideFrame(s.tipText) end
                                )
                            end
                            if s ~= nil and s.tipBox ~= 0 then
                                pcall(function () return ____UI_5DE5_5177:hideFrame(s.tipBox) end
                                )
                            end
                        end,
                        false
                    ) end
                )
            end
            local boxW = TIP_W + TIP_PAD * 2
            local boxH = TIP_H + TIP_PAD * 2
            local tipBox = ____UI_5DE5_5177:createFrame({
                type = ____UI_5DE5_5177.FrameType.BACKDROP,
                name = "BuffUIBarTip" .. tostring(index),
                parent = parent,
                template = "template",
                visible = false
            }) or 0
            if tipBox and tipBox ~= 0 then
                pcall(function () return ____UI_5DE5_5177:setFramePointRelative(
                        tipBox,
                        ____UI_5DE5_5177.FramePoint.TOPLEFT,
                        bd,
                        ____UI_5DE5_5177.FramePoint.TOPRIGHT,
                        0.002,
                        TIP_OFFSET_Y_FROM_ICON_TOP
                    ) end
                )
                pcall(function () return ____UI_5DE5_5177:setFrameSize(tipBox, {width = boxW, height = boxH}) end
                )
                pcall(function () return ____UI_5DE5_5177:setFrameTexture(tipBox, TIP_BOX_TEX) end
                )
                if type(japi.DzFrameSetLevel) == "function" then
                    pcall(function () return japi.DzFrameSetLevel(tipBox, 0) end
                    )
                end
                pcall(function () return ____UI_5DE5_5177:hideFrame(tipBox) end
                )
            end
            local tipText = ____UI_5DE5_5177:createTextLabel(
                "BuffUIBarTipTxt" .. tostring(index),
                tipBox and tipBox ~= 0 and tipBox or bd,
                "",
                tipBox and tipBox ~= 0 and ({
                    relativeTo = tipBox,
                    point = ____UI_5DE5_5177.FramePoint.CENTER,
                    relativePoint = ____UI_5DE5_5177.FramePoint.CENTER,
                    x = 0,
                    y = 0
                }) or ({
                    relativeTo = bd,
                    point = ____UI_5DE5_5177.FramePoint.TOPLEFT,
                    relativePoint = ____UI_5DE5_5177.FramePoint.TOPRIGHT,
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
                    pcall(function () return japi.DzFrameSetLevel(tipText, 0) end
                    )
                end
                pcall(function () return ____UI_5DE5_5177:hideFrame(tipText) end
                )
            end
            if hit ~= 0 and tipBox ~= 0 then
                tryDzFrameSetTooltipF2i(nil, hit, tipBox)
            end
            pcall(function () return ____UI_5DE5_5177:hideFrame(bd) end
            )
            return true, {
                root = bd,
                remainText = remainText or 0,
                hit = hit or 0,
                tipBox = tipBox or 0,
                tipText = tipText or 0
            }
        end)
        if not ____try then
            ____hasReturned, ____returnValue = ____catch(____hasReturned)
        end
        if ____hasReturned then
            return ____returnValue
        end
    end
end
local function createUi(self)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil or lp == 0 then
                return
            end
            local parent = _____786C_4EF6_51FD_6570:getGameUI()
            if parent == 0 or parent == nil then
                return
            end
            do
                local j = 0
                while j < MAX_SLOTS do
                    lastTipStrBySlot[j + 1] = ""
                    lastRemainStrBySlot[j + 1] = ""
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
    )
end
--- 刷新计数器（每10个10毫秒=0.1秒刷新一次）
local _refreshCounter = 0
--- 是否已注册到中心计时器
local _registeredToCenterTimer = false
local function startRefreshTimer(self)
    pcall(function ()
            if _registeredToCenterTimer then
                return
            end
            _registeredToCenterTimer = true
            local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
            local onTick10ms = ____require_result_6.onTick10ms
            onTick10ms(
                nil,
                function()
                    _refreshCounter = _refreshCounter + 1
                    if _refreshCounter >= 10 then
                        _refreshCounter = 0
                        pcall(function ()
                                if type(jass.GetLocalPlayer) ~= "function" then
                                    return
                                end
                                local lp = jass.GetLocalPlayer()
                                if lp == nil or lp == 0 then
                                    return
                                end
                                syncBuffBar(nil)
                            end
                        )
                    end
                end
            )
        end
    )
end
function ____exports.init(self)
    if buffUiInitialized then
        return
    end
    buffUiInitialized = true
    pcall(function ()
            if type(jass.CreateTimer) == "function" and type(jass.TimerStart) == "function" then
                local delayTimer = jass.CreateTimer()
                jass.TimerStart(
                    delayTimer,
                    1,
                    false,
                    function()
                        pcall(function ()
                                if type(jass.GetLocalPlayer) ~= "function" then
                                    if type(jass.DestroyTimer) == "function" then
                                        jass.DestroyTimer(delayTimer)
                                    end
                                    return
                                end
                                local lp = jass.GetLocalPlayer()
                                if lp ~= nil and lp ~= 0 then
                                    createUi(nil)
                                end
                                startRefreshTimer(nil)
                                if type(jass.DestroyTimer) == "function" then
                                    jass.DestroyTimer(delayTimer)
                                end
                            end
                        )
                    end
                )
            end
        end
    )
end
return ____exports
