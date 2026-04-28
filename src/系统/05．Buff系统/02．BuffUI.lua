local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local hideSlot, hideAllSlots, renderBuffBarLocal, rebuildAllBuffBarViewModels, syncBuffBar, onBuffUiRefreshTick, jass, japi, ____UI_5DE5_5177, getSoleSelectedUnitForPlayer, buildBuffBarViewModel, MAX_SLOTS, slots, buffBarViewModelByPlayerId
function hideSlot(i)
    local s = slots[i + 1]
    if not s then
        return
    end
    if s.tipText ~= 0 then
        ____UI_5DE5_5177:hideFrame(s.tipText)
    end
    if s.tipBox ~= 0 then
        ____UI_5DE5_5177:hideFrame(s.tipBox)
    end
    if s.hit ~= 0 then
        ____UI_5DE5_5177:hideFrame(s.hit)
    end
    if s.root ~= 0 then
        ____UI_5DE5_5177:hideFrame(s.root)
    end
end
function hideAllSlots()
    do
        local i = 0
        while i < MAX_SLOTS do
            hideSlot(i)
            i = i + 1
        end
    end
end
function renderBuffBarLocal(vm)
    do
        local i = 0
        while i < MAX_SLOTS do
            do
                local slotVM = vm.slots[i + 1]
                local slot = slots[i + 1]
                if not slot then
                    goto __continue35
                end
                if slotVM.visible then
                    if slot.root ~= 0 then
                        ____UI_5DE5_5177:setFrameTexture(slot.root, slotVM.iconPath)
                        ____UI_5DE5_5177:showFrame(slot.root)
                    end
                    if slot.remainText ~= 0 then
                        japi.DzFrameSetText(slot.remainText, slotVM.remainText)
                    end
                    if slot.tipText ~= 0 then
                        japi.DzFrameSetText(slot.tipText, slotVM.tooltipText)
                    end
                    if slot.hit ~= 0 then
                        ____UI_5DE5_5177:showFrame(slot.hit)
                    end
                else
                    hideSlot(i)
                end
            end
            ::__continue35::
            i = i + 1
        end
    end
end
function rebuildAllBuffBarViewModels()
    do
        local playerId = 0
        while playerId < 16 do
            local targetUnit = getSoleSelectedUnitForPlayer(playerId)
            buffBarViewModelByPlayerId[playerId] = buildBuffBarViewModel(targetUnit)
            playerId = playerId + 1
        end
    end
end
function syncBuffBar()
    local localPlayerId = jass.GetPlayerId(jass.GetLocalPlayer())
    rebuildAllBuffBarViewModels()
    local ____temp_1
    if localPlayerId >= 0 then
        ____temp_1 = buffBarViewModelByPlayerId[localPlayerId]
    else
        ____temp_1 = nil
    end
    local viewModel = ____temp_1
    local visCount = viewModel and #__TS__ArrayFilter(
        viewModel.slots,
        function(____, s) return s.visible end
    ) or 0
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        5,
        (((((("[BuffUI] pid=" .. tostring(localPlayerId)) .. " vm=") .. (viewModel and "yes" or "nil")) .. " vis=") .. tostring(visCount)) .. " slotsLen=") .. tostring(#slots)
    )
    if jass.GetLocalPlayer() == jass.Player(localPlayerId) and viewModel then
        renderBuffBarLocal(viewModel)
    elseif jass.GetLocalPlayer() == jass.Player(localPlayerId) then
        hideAllSlots()
    end
end
function onBuffUiRefreshTick()
    syncBuffBar()
end
jass = require("jass.common")
japi = require("jass.japi")
____UI_5DE5_5177 = require("系统.09．表现系统.01．UI工具.index")
local ____hwMod = require("lib.扩展函数.封装函数.04．硬件输入.index")
local getGameUI = ____hwMod.getGameUI
local ____safeUtils = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____safeUtils.safeTimerStart
local safeDestroyTimer = ____safeUtils.safeDestroyTimer
local ____selectionCenter = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
getSoleSelectedUnitForPlayer = ____selectionCenter.getSoleSelectedUnitForPlayer
local ____viewModelMod = require("系统.05．Buff系统.04．BuffUIViewModel")
buildBuffBarViewModel = ____viewModelMod.buildBuffBarViewModel
local getMaxSlots = ____viewModelMod.getMaxSlots
MAX_SLOTS = getMaxSlots()
local BUFF_BAR_X0 = 0.204
local BUFF_BAR_Y = 0.1655
local ICON_W = 0.02
local ICON_H = 16 / 600
local ICON_GAP = 0.0005
local TIP_BOX_TEX = "UI\\wenbenkuang.blp"
local TIP_W = 0.22
local TIP_H = 0.056
local TIP_PAD = 0.005
local TIP_OFFSET_Y_FROM_ICON_TOP = 0.07
slots = {}
local buffUiInitialized = false
local refreshTimer = nil
local pendingInitDelayTimer = nil
buffBarViewModelByPlayerId = {}
local hoverSlotIndexByFrameId = {}
local function getTriggerUiEventFrame()
    local ____temp_0
    if type(japi.DzGetTriggerUIEventFrame) == "function" then
        ____temp_0 = japi.DzGetTriggerUIEventFrame()
    else
        ____temp_0 = 0
    end
    return ____temp_0
end
local function setFrameLevelSafe(frame, level)
    if frame == 0 then
        return
    end
    japi.DzFrameSetPriority(frame, level)
end
local function showSlotTooltipByIndex(index)
    local s = slots[index + 1]
    if s and s.tipBox ~= 0 then
        ____UI_5DE5_5177:showFrame(s.tipBox)
    end
    if s and s.tipText ~= 0 then
        ____UI_5DE5_5177:showFrame(s.tipText)
    end
end
local function hideSlotTooltipByIndex(index)
    local s = slots[index + 1]
    if s and s.tipText ~= 0 then
        ____UI_5DE5_5177:hideFrame(s.tipText)
    end
    if s and s.tipBox ~= 0 then
        ____UI_5DE5_5177:hideFrame(s.tipBox)
    end
end
local function onSlotHoverEnter()
    local frame = getTriggerUiEventFrame()
    if frame == 0 then
        return
    end
    local index = hoverSlotIndexByFrameId[frame]
    if index == nil then
        return
    end
    showSlotTooltipByIndex(index)
end
local function onSlotHoverLeave()
    local frame = getTriggerUiEventFrame()
    if frame == 0 then
        return
    end
    local index = hoverSlotIndexByFrameId[frame]
    if index == nil then
        return
    end
    hideSlotTooltipByIndex(index)
end
local function createOneSlot(index, parent)
    local x = BUFF_BAR_X0 + index * (ICON_W + ICON_GAP)
    local bd = ____UI_5DE5_5177:createFrame({
        type = ____UI_5DE5_5177.FrameType.BACKDROP,
        name = "BuffUIBarIcon" .. tostring(index),
        parent = parent,
        template = "template",
        visible = false
    }) or 0
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        10,
        (("[BuffUI] slot" .. tostring(index)) .. " bd=") .. tostring(bd)
    )
    if not bd or bd == 0 then
        return nil
    end
    ____UI_5DE5_5177:setFramePosition(bd, {point = ____UI_5DE5_5177.FramePoint.TOPLEFT, x = x, y = BUFF_BAR_Y})
    ____UI_5DE5_5177:setFrameSize(bd, {width = ICON_W, height = ICON_H})
    ____UI_5DE5_5177:setFrameTexture(bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp")
    setFrameLevelSafe(bd, 180)
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
        japi.DzFrameSetTextAlignment(remainText, ____UI_5DE5_5177.FramePoint.CENTER)
        setFrameLevelSafe(remainText, 182)
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
    if hit and hit ~= 0 then
        hoverSlotIndexByFrameId[hit] = index
        japi.DzFrameSetAllPoints(hit, bd)
        setFrameLevelSafe(hit, 181)
        ____UI_5DE5_5177:setFrameHoverEvents(hit, onSlotHoverEnter, onSlotHoverLeave, false)
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
        ____UI_5DE5_5177:setFramePointRelative(
            tipBox,
            ____UI_5DE5_5177.FramePoint.TOPLEFT,
            bd,
            ____UI_5DE5_5177.FramePoint.TOPRIGHT,
            0.002,
            TIP_OFFSET_Y_FROM_ICON_TOP
        )
        ____UI_5DE5_5177:setFrameSize(tipBox, {width = boxW, height = boxH})
        ____UI_5DE5_5177:setFrameTexture(tipBox, TIP_BOX_TEX)
        setFrameLevelSafe(tipBox, 0)
        ____UI_5DE5_5177:hideFrame(tipBox)
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
        japi.DzFrameSetTextAlignment(tipText, 0)
        setFrameLevelSafe(tipText, 0)
        ____UI_5DE5_5177:hideFrame(tipText)
    end
    if hit ~= 0 and tipBox ~= 0 then
        japi.DzFrameSetTooltip(hit, tipBox)
    end
    ____UI_5DE5_5177:hideFrame(bd)
    return {
        root = bd,
        remainText = remainText or 0,
        hit = hit or 0,
        tipBox = tipBox or 0,
        tipText = tipText or 0
    }
end
local function createUi()
    local parent = getGameUI()
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        10,
        "[BuffUI] createUi parent=" .. tostring(parent)
    )
    if parent == 0 or parent == nil then
        return
    end
    do
        local i = 0
        while i < MAX_SLOTS do
            local s = createOneSlot(i, parent)
            if s then
                slots[i + 1] = s
            end
            i = i + 1
        end
    end
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        10,
        "[BuffUI] slots created=" .. tostring(#slots)
    )
end
local function startRefreshTimer()
    if refreshTimer ~= nil then
        return
    end
    refreshTimer = jass.CreateTimer()
    safeTimerStart(refreshTimer, 0.1, true, onBuffUiRefreshTick)
end
local function onBuffUiInitDelayTimer()
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        10,
        "[BuffUI] initDelayTimer fired, buffUiInit=" .. tostring(buffUiInitialized)
    )
    createUi()
    startRefreshTimer()
    if pendingInitDelayTimer ~= nil then
        safeDestroyTimer(pendingInitDelayTimer)
        pendingInitDelayTimer = nil
    end
end
function ____exports.init()
end
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    jass.DisplayTimedTextToPlayer(
        jass.Player(0),
        0,
        0,
        10,
        "[BuffUI] onPlayerHeroRegistered called, init=" .. tostring(buffUiInitialized)
    )
    if buffUiInitialized then
        return
    end
    buffUiInitialized = true
    pendingInitDelayTimer = jass.CreateTimer()
    safeTimerStart(pendingInitDelayTimer, 1, false, onBuffUiInitDelayTimer)
end
function ____exports.setDebugMode(enabled)
end
return ____exports
