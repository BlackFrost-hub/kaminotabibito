local ____lualib = require("lualib_bundle")
local __TS__ArrayFilter = ____lualib.__TS__ArrayFilter
local ____exports = {}
local uiSetFrameTexture, uiHideFrame, uiShowFrame, hideSlot, hideAllSlots, renderBuffBarLocal, rebuildAllBuffBarViewModels, syncBuffBar, onBuffUiRefreshTick, jass, japi, debugLog, MAX_SLOTS, slots, buffBarViewModelByPlayerId, MAX_PLAYER_ID
local ____05_FF0E_73A9_5BB6_9009_4E2D_5355_4F4D_4E8B_4EF6_4E2D_5FC3 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local getSoleSelectedUnitForPlayerImported = ____05_FF0E_73A9_5BB6_9009_4E2D_5355_4F4D_4E8B_4EF6_4E2D_5FC3.getSoleSelectedUnitForPlayer
local ____04_FF0EBuffUIViewModel = require("系统.05．Buff系统.04．BuffUIViewModel")
local buildBuffBarViewModelImported = ____04_FF0EBuffUIViewModel.buildBuffBarViewModel
local getMaxSlotsImported = ____04_FF0EBuffUIViewModel.getMaxSlots
local ____01_FF0E_5E27_521B_5EFA = require("系统.09．表现系统.01．UI工具.01．帧创建")
local createFrameImported = ____01_FF0E_5E27_521B_5EFA.createFrame
local ____02_FF0E_4F4D_7F6E_5C3A_5BF8 = require("系统.09．表现系统.01．UI工具.02．位置尺寸")
local setFramePointRelativeImported = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePointRelative
local setFramePositionImported = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFramePosition
local setFrameSizeImported = ____02_FF0E_4F4D_7F6E_5C3A_5BF8.setFrameSize
local ____03_FF0E_5185_5BB9_8BBE_7F6E = require("系统.09．表现系统.01．UI工具.03．内容设置")
local setFrameHoverEventsImported = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameHoverEvents
local setFrameTextureImported = ____03_FF0E_5185_5BB9_8BBE_7F6E.setFrameTexture
local ____04_FF0E_590D_5408_7EC4_4EF6 = require("系统.09．表现系统.01．UI工具.04．复合组件")
local createTextLabelImported = ____04_FF0E_590D_5408_7EC4_4EF6.createTextLabel
local ____05_FF0E_5E27_63A7_5236 = require("系统.09．表现系统.01．UI工具.05．帧控制")
local hideFrameImported = ____05_FF0E_5E27_63A7_5236.hideFrame
local showFrameImported = ____05_FF0E_5E27_63A7_5236.showFrame
function uiSetFrameTexture(frame, texture)
    return setFrameTextureImported(nil, frame, texture)
end
function uiHideFrame(frame)
    return hideFrameImported(nil, frame)
end
function uiShowFrame(frame)
    return showFrameImported(nil, frame)
end
function hideSlot(i)
    local s = slots[i + 1]
    if not s then
        return
    end
    if s.tipText ~= 0 then
        uiHideFrame(s.tipText)
    end
    if s.tipBox ~= 0 then
        uiHideFrame(s.tipBox)
    end
    if s.hit ~= 0 then
        uiHideFrame(s.hit)
    end
    if s.root ~= 0 then
        uiHideFrame(s.root)
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
                    goto __continue43
                end
                if slotVM.visible then
                    if slot.root ~= 0 then
                        uiSetFrameTexture(slot.root, slotVM.iconPath)
                        uiShowFrame(slot.root)
                    end
                    if slot.remainText ~= 0 then
                        japi.DzFrameSetText(slot.remainText, slotVM.remainText)
                    end
                    if slot.tipText ~= 0 then
                        japi.DzFrameSetText(slot.tipText, slotVM.tooltipText)
                    end
                    if slot.hit ~= 0 then
                        uiShowFrame(slot.hit)
                    end
                else
                    hideSlot(i)
                end
            end
            ::__continue43::
            i = i + 1
        end
    end
end
function rebuildAllBuffBarViewModels()
    do
        local playerId = 0
        while playerId < MAX_PLAYER_ID do
            local targetUnit = getSoleSelectedUnitForPlayerImported(playerId)
            buffBarViewModelByPlayerId[playerId] = buildBuffBarViewModelImported(targetUnit)
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
    debugLog(
        nil,
        "BuffUI",
        (((((("pid=" .. tostring(localPlayerId)) .. " vm=") .. (viewModel and "yes" or "nil")) .. " vis=") .. tostring(visCount)) .. " slotsLen=") .. tostring(#slots)
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
local ____UI_5DE5_5177 = require("系统.09．表现系统.01．UI工具.index")
local ____hwMod = require("lib.扩展函数.封装函数.04．硬件输入.index")
local getGameUI = ____hwMod.getGameUI
local ____safeUtils = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____safeUtils.safeTimerStart
local safeDestroyTimer = ____safeUtils.safeDestroyTimer
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
debugLog = ____require_result_0.debugLog
local setDebug = ____require_result_0.setDebug
setDebug(nil, "BuffUI", false)
MAX_SLOTS = getMaxSlotsImported()
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
local function uiCreateFrame(options)
    return createFrameImported(nil, options)
end
local function uiSetFramePosition(frame, options)
    return setFramePositionImported(nil, frame, options)
end
local function uiSetFrameSize(frame, options)
    return setFrameSizeImported(nil, frame, options)
end
local function uiSetFrameHoverEvents(frame, onEnter, onLeave, sync)
    return setFrameHoverEventsImported(
        nil,
        frame,
        onEnter,
        onLeave,
        sync
    )
end
local function uiSetFramePointRelative(frame, point, relativeTo, relativePoint, x, y)
    return setFramePointRelativeImported(
        nil,
        frame,
        point,
        relativeTo,
        relativePoint,
        x,
        y
    )
end
local function uiCreateTextLabel(name, parent, text, position, size)
    return createTextLabelImported(
        nil,
        name,
        parent,
        text,
        position,
        size
    )
end
local function getTriggerUiEventFrame()
    return japi.DzGetTriggerUIEventFrame()
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
        uiShowFrame(s.tipBox)
    end
    if s and s.tipText ~= 0 then
        uiShowFrame(s.tipText)
    end
end
local function hideSlotTooltipByIndex(index)
    local s = slots[index + 1]
    if s and s.tipText ~= 0 then
        uiHideFrame(s.tipText)
    end
    if s and s.tipBox ~= 0 then
        uiHideFrame(s.tipBox)
    end
end
local function onSlotHoverEnter(self)
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
local function onSlotHoverLeave(self)
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
    local bd = uiCreateFrame({
        type = ____UI_5DE5_5177.FrameType.BACKDROP,
        name = "BuffUIBarIcon" .. tostring(index),
        parent = parent,
        template = "template",
        visible = false
    }) or 0
    debugLog(
        nil,
        "BuffUI",
        (("slot" .. tostring(index)) .. " bd=") .. tostring(bd)
    )
    if not bd or bd == 0 then
        return nil
    end
    uiSetFramePosition(bd, {point = ____UI_5DE5_5177.FramePoint.TOPLEFT, x = x, y = BUFF_BAR_Y})
    uiSetFrameSize(bd, {width = ICON_W, height = ICON_H})
    uiSetFrameTexture(bd, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp")
    setFrameLevelSafe(bd, 180)
    local remainText = uiCreateTextLabel(
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
    local hit = uiCreateFrame({
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
        uiSetFrameHoverEvents(hit, onSlotHoverEnter, onSlotHoverLeave, false)
    end
    local boxW = TIP_W + TIP_PAD * 2
    local boxH = TIP_H + TIP_PAD * 2
    local tipBox = uiCreateFrame({
        type = ____UI_5DE5_5177.FrameType.BACKDROP,
        name = "BuffUIBarTip" .. tostring(index),
        parent = parent,
        template = "template",
        visible = false
    }) or 0
    if tipBox and tipBox ~= 0 then
        uiSetFramePointRelative(
            tipBox,
            ____UI_5DE5_5177.FramePoint.TOPLEFT,
            bd,
            ____UI_5DE5_5177.FramePoint.TOPRIGHT,
            0.002,
            TIP_OFFSET_Y_FROM_ICON_TOP
        )
        uiSetFrameSize(tipBox, {width = boxW, height = boxH})
        uiSetFrameTexture(tipBox, TIP_BOX_TEX)
        setFrameLevelSafe(tipBox, 200)
        uiHideFrame(tipBox)
    end
    local tipText = uiCreateTextLabel(
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
        setFrameLevelSafe(tipText, 201)
        uiHideFrame(tipText)
    end
    uiHideFrame(bd)
    return {
        root = bd,
        remainText = remainText or 0,
        hit = hit or 0,
        tipBox = tipBox or 0,
        tipText = tipText or 0
    }
end
MAX_PLAYER_ID = 6
local function createUi()
    local parent = getGameUI(nil)
    debugLog(
        nil,
        "BuffUI",
        "createUi parent=" .. tostring(parent)
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
end
local function startRefreshTimer()
    if refreshTimer ~= nil then
        return
    end
    refreshTimer = jass.CreateTimer()
    jass.TimerStart(refreshTimer, 0.1, true, onBuffUiRefreshTick)
end
local function onBuffUiInitDelayTimer()
    createUi()
    startRefreshTimer()
    if pendingInitDelayTimer ~= nil then
        jass.DestroyTimer(pendingInitDelayTimer)
        pendingInitDelayTimer = nil
    end
end
function ____exports.init()
end
function ____exports.onPlayerHeroRegistered(whichPlayer, whichHero)
    debugLog(
        nil,
        "BuffUI",
        "onPlayerHeroRegistered called, init=" .. tostring(buffUiInitialized)
    )
    if buffUiInitialized then
        return
    end
    buffUiInitialized = true
    pendingInitDelayTimer = jass.CreateTimer()
    jass.TimerStart(pendingInitDelayTimer, 1, false, onBuffUiInitDelayTimer)
end
return ____exports
