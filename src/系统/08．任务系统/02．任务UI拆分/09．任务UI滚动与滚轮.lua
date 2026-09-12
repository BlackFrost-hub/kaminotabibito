--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local thumbTravelNorm, setTaskScrollThumbByRatio, updateTaskUIScrollThumbPosition, clampMin, clampRange
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.02．任务UI拆分.01．任务UI常量")
local ENABLE_MOUSE_WHEEL_SCROLL = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_MOUSE_WHEEL_SCROLL
local ENABLE_TASK_UI_TRACK_CLICK = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_TASK_UI_TRACK_CLICK
local ENTRY_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_Y
local PANEL_REL_TO_ENTRY_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.PANEL_REL_TO_ENTRY_Y
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local SCROLLBAR_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_W
local SCROLLBAR_TOP_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_TOP_INSET
local SCROLL_THUMB_SIZE = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_SIZE
local SCROLL_THUMB_TOP_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_TOP_COMPENSATION
local SCROLL_THUMB_BOTTOM_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_BOTTOM_COMPENSATION
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local getClientHeight = ____index.getClientHeight
local getMouseYRelative = ____index.getMouseYRelative
local getWindowHeight = ____index.getWindowHeight
local getScrollbarTrackThumbTravelPx = ____index.getScrollbarTrackThumbTravelPx
local frameSetScriptByCode = ____index.frameSetScriptByCode
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.02．任务UI拆分.02．任务UI辅助")
local pcallDzFrameShow = ____02_FF0E_4EFB_52A1UI_8F85_52A9.pcallDzFrameShow
function thumbTravelNorm(self)
    return LIST_VIEW_H - SCROLL_THUMB_SIZE - SCROLL_THUMB_TOP_COMPENSATION - SCROLL_THUMB_BOTTOM_COMPENSATION
end
function setTaskScrollThumbByRatio(self, ctx, ratio)
    if not ctx.scrollBarFrame or not ctx.scrollThumbFrame then
        return
    end
    local centeredX = (SCROLLBAR_W - SCROLL_THUMB_SIZE) * 0.5
    local travelRange = thumbTravelNorm(nil)
    if travelRange < 0 then
        travelRange = 0
    end
    local r = clampRange(ratio, 0, 1)
    local topOffset = SCROLL_THUMB_TOP_COMPENSATION + travelRange * r
    ctx:setFramePointRelative(
        ctx.scrollThumbFrame,
        ctx.FramePoint.TOPLEFT,
        ctx.scrollBarFrame,
        ctx.FramePoint.TOPLEFT,
        centeredX,
        -topOffset
    )
end
function updateTaskUIScrollThumbPosition(self, ctx, pageCount)
    if pageCount <= 1 then
        setTaskScrollThumbByRatio(nil, ctx, 0)
        return
    end
    local currentPage = clampRange(
        ctx:getCurrentPage(),
        0,
        pageCount - 1
    )
    local ratio = currentPage / (pageCount - 1)
    setTaskScrollThumbByRatio(nil, ctx, ratio)
end
function ____exports.handleTaskUIListWheel(self, ctx)
    local pageCount = ctx:getCurrentPageCount()
    if pageCount <= 1 then
        return
    end
    local delta = type(ctx.getWheelDelta) == "function" and ctx:getWheelDelta() or 0
    if delta == 0 then
        return
    end
    local currentPage = ctx:getCurrentPage()
    local nextPage = currentPage
    if delta > 0 then
        nextPage = clampMin(currentPage - 1, 0)
    end
    if delta < 0 then
        nextPage = currentPage + 1 < pageCount and currentPage + 1 or pageCount - 1
    end
    if nextPage == currentPage then
        return
    end
    ctx:setCurrentPage(nextPage)
    ctx:onPageChanged(currentPage, nextPage)
    updateTaskUIScrollThumbPosition(nil, ctx, pageCount)
end
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local round = ____require_result_0.round
clampMin = ____require_result_0.clampMin
clampRange = ____require_result_0.clampRange
local japi = require("jass.japi")
local ____require_result_1 = require("lib.扩展函数.封装函数.04．硬件输入.index")
local createTriggerOrNull = ____require_result_1.createTriggerOrNull
local getMouseY = ____require_result_1.getMouseY
local registerMouseButtonEventByCode = ____require_result_1.registerMouseButtonEventByCode
local registerMouseMoveEventByCode = ____require_result_1.registerMouseMoveEventByCode
--- 帧事件 ID（见 `.cursor/rules/engine/dzapi/ui-frame-types.mdc`）
local FRAME_EVENT_CLICK = 1
--- N 槽：所有已注册的滚动上下文，滚轮/轨道点击帧事件路由到可见的那个
local allWheelCtxs = {}
local taskThumbGlobalMouseRegistered = false
local taskGlobalWheelRegistered = false
local dragCtx = nil
local thumbDragActive = false
local thumbDragStartMouseYPx = 0
local thumbDragStartPage = 0
local function findVisibleWheelCtx(self)
    do
        local i = 0
        while i < #allWheelCtxs do
            local ctx = allWheelCtxs[i + 1]
            if ctx:isOwnedByLocalPlayer() and ctx:isVisible() then
                return ctx
            end
            i = i + 1
        end
    end
    return nil
end
--- 本地全局滚轮回调，只路由到本地玩家当前可见的槽位。
-- 回调为全局具名函数，符合 Dz 回调约束。
local function onMouseWheelEvent(self)
    local ctx = findVisibleWheelCtx(nil)
    if not ctx or not ctx:isVisible() then
        return
    end
    ____exports.handleTaskUIListWheel(nil, ctx)
end
local function getTaskScrollTrackTopYNorm(self)
    return ENTRY_Y + PANEL_REL_TO_ENTRY_Y - SCROLLBAR_TOP_INSET
end
local function getTaskScrollTrackBottomYNorm(self)
    return getTaskScrollTrackTopYNorm(nil) - LIST_VIEW_H
end
local function getTaskScrollThumbCenterTopYNorm(self)
    return getTaskScrollTrackTopYNorm(nil) - SCROLL_THUMB_TOP_COMPENSATION - SCROLL_THUMB_SIZE * 0.5
end
local function getTaskScrollThumbCenterBottomYNorm(self)
    return getTaskScrollThumbCenterTopYNorm(nil) - thumbTravelNorm(nil)
end
local function getTaskScrollTrackClickRatio(self)
    local topY = getTaskScrollThumbCenterTopYNorm(nil)
    local bottomY = getTaskScrollThumbCenterBottomYNorm(nil)
    local mouseYPx = getMouseYRelative(nil)
    local clientH = getClientHeight(nil)
    local baseH = clientH > 0 and clientH or (getWindowHeight(nil) or 600)
    local mouseY = (baseH - mouseYPx) * 0.6 / baseH
    if topY <= bottomY then
        return 0
    end
    local ratio = clampRange((topY - mouseY) / (topY - bottomY), 0, 1)
    return ratio
end
local function onScrollBarTrackClick(self, ctx)
    local pageCount = ctx:getCurrentPageCount()
    if pageCount <= 1 then
        return
    end
    local ratio = getTaskScrollTrackClickRatio(nil)
    local targetPage = clampRange(
        round(ratio * (pageCount - 1)),
        0,
        pageCount - 1
    )
    local currentPage = ctx:getCurrentPage()
    if targetPage == currentPage then
        updateTaskUIScrollThumbPosition(nil, ctx, pageCount)
        return
    end
    ctx:setCurrentPage(targetPage)
    ctx:onPageChanged(currentPage, targetPage)
    updateTaskUIScrollThumbPosition(nil, ctx, pageCount)
end
--- 轨道点击回调：帧事件已带命中信息，直接用本地鼠标纵坐标换算目标页。
-- 纯本机 UI 交互，`sync=false`（见 n-slot-ui-symmetric-execution §4.4）。
local function onTaskUITrackClickEvent(self)
    local ctx = findVisibleWheelCtx(nil)
    if not ctx or not ctx:isVisible() then
        return
    end
    onScrollBarTrackClick(nil, ctx)
end
local function ratioFromThumbDragMouseY(self, pageCount, mouseYPx)
    local travelPx = getScrollbarTrackThumbTravelPx(
        nil,
        thumbTravelNorm(nil)
    )
    if travelPx <= 0 or pageCount <= 1 then
        return 0
    end
    local startRatio = thumbDragStartPage / (pageCount - 1)
    return clampRange(startRatio + (mouseYPx - thumbDragStartMouseYPx) / travelPx, 0, 1)
end
local function onThumbDragStart(self)
    if not dragCtx then
        return
    end
    if dragCtx:getCurrentPageCount() <= 1 then
        return
    end
    thumbDragStartMouseYPx = getMouseY(nil)
    thumbDragStartPage = dragCtx:getCurrentPage()
    thumbDragActive = true
end
local function onThumbDragMove(self)
    if not thumbDragActive or not dragCtx then
        return
    end
    local pageCount = dragCtx:getCurrentPageCount()
    if pageCount <= 1 then
        return
    end
    local ratio = ratioFromThumbDragMouseY(
        nil,
        pageCount,
        getMouseY(nil)
    )
    setTaskScrollThumbByRatio(nil, dragCtx, ratio)
    local targetPage = clampRange(
        round(ratio * (pageCount - 1)),
        0,
        pageCount - 1
    )
    local currentPage = dragCtx:getCurrentPage()
    if targetPage ~= currentPage then
        dragCtx:setCurrentPage(targetPage)
        dragCtx:onPageChanged(currentPage, targetPage)
    end
end
local function onThumbDragEnd(self)
    if not thumbDragActive then
        return
    end
    thumbDragActive = false
    if dragCtx then
        updateTaskUIScrollThumbPosition(
            nil,
            dragCtx,
            dragCtx:getCurrentPageCount()
        )
    end
end
local function onGlobalThumbLeftPress(self)
    local ctx = findVisibleWheelCtx(nil)
    if not ctx then
        return
    end
    local focus = japi.DzGetMouseFocus()
    if focus ~= ctx.scrollThumbFrame and focus ~= ctx.scrollThumbHitBtn then
        return
    end
    dragCtx = ctx
    onThumbDragStart(nil)
end
local function onGlobalThumbLeftRelease(self)
    onThumbDragEnd(nil)
end
local function onGlobalThumbDragMove(self)
    onThumbDragMove(nil)
end
local function ensureTaskThumbGlobalMouseRegistered(self)
    if taskThumbGlobalMouseRegistered then
        return
    end
    local trigger = createTriggerOrNull(nil)
    if not trigger then
        return
    end
    registerMouseButtonEventByCode(
        nil,
        trigger,
        1,
        1,
        false,
        onGlobalThumbLeftPress
    )
    registerMouseButtonEventByCode(
        nil,
        trigger,
        1,
        0,
        false,
        onGlobalThumbLeftRelease
    )
    registerMouseMoveEventByCode(nil, trigger, false, onGlobalThumbDragMove)
    taskThumbGlobalMouseRegistered = true
end
local function registerSlotFrameEvents(self, ctx)
    if ctx.taskListWheelRegistered then
        return
    end
    if ENABLE_TASK_UI_TRACK_CLICK then
        local trackFrame = ctx.scrollBarHitBtn or ctx.scrollBarFrame
        if trackFrame then
            frameSetScriptByCode(trackFrame, FRAME_EVENT_CLICK, onTaskUITrackClickEvent, false)
        end
    end
    ctx.taskListWheelRegistered = true
end
function ____exports.registerTaskUIListWheel(self, ctx)
    allWheelCtxs[#allWheelCtxs + 1] = ctx
    dragCtx = ctx
    ensureTaskThumbGlobalMouseRegistered(nil)
    if ENABLE_MOUSE_WHEEL_SCROLL and not taskGlobalWheelRegistered and ctx.registerMouseWheel then
        ctx.registerMouseWheel(false, onMouseWheelEvent)
        taskGlobalWheelRegistered = true
    end
    registerSlotFrameEvents(nil, ctx)
    return nil
end
function ____exports.updateTaskUIScrollBarVisibility(self, ctx, pageCount, hasQuestRows)
    local visible = hasQuestRows
    for ____, frame in ipairs({ctx.scrollBarFrame, ctx.scrollBarHitBtn, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn}) do
        if frame and frame ~= 0 then
            pcallDzFrameShow(nil, frame, visible)
        end
    end
    if visible then
        updateTaskUIScrollThumbPosition(nil, ctx, pageCount)
    end
end
return ____exports
