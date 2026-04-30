--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local thumbTravelNorm, setTaskScrollThumbByRatio, updateTaskUIScrollThumbPosition, ratioFromThumbDragMouseY, onThumbDragMove, round, clampMin, clampRange, dragCtx, thumbDragActive, thumbDragStartMouseYPx, thumbDragStartPage
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.02．任务UI拆分.01．任务UI常量")
local ENABLE_MOUSE_WHEEL_SCROLL = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_MOUSE_WHEEL_SCROLL
local ENTRY_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENTRY_Y
local PANEL_REL_TO_ENTRY_Y = ____01_FF0E_4EFB_52A1UI_5E38_91CF.PANEL_REL_TO_ENTRY_Y
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local SCROLLBAR_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_W
local SCROLLBAR_TOP_INSET = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_TOP_INSET
local SCROLL_THUMB_SIZE = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_SIZE
local SCROLL_THUMB_TOP_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_TOP_COMPENSATION
local SCROLL_THUMB_BOTTOM_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_BOTTOM_COMPENSATION
local ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8 = require("系统.08．任务系统.02．任务UI拆分.03．任务UI列表与滚动")
local isWheelTargetForTaskListByJapi = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isWheelTargetForTaskList
local isTaskScrollThumbDragHit = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isTaskScrollThumbDragHit
local isTaskScrollBarTrackHit = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isTaskScrollBarTrackHit
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local createTriggerOrNull = ____index.createTriggerOrNull
local getClientHeight = ____index.getClientHeight
local getMouseY = ____index.getMouseY
local getMouseYRelative = ____index.getMouseYRelative
local getWindowHeight = ____index.getWindowHeight
local getScrollbarTrackThumbTravelPx = ____index.getScrollbarTrackThumbTravelPx
local registerMouseButtonEventByCode = ____index.registerMouseButtonEventByCode
local registerMouseMoveEventByCode = ____index.registerMouseMoveEventByCode
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
    local r = clampRange(nil, ratio, 0, 1)
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
        nil,
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
        nextPage = clampMin(nil, currentPage - 1, 0)
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
function ratioFromThumbDragMouseY(self, pageCount, mouseYPx)
    local travelNorm = thumbTravelNorm(nil)
    if travelNorm <= 0 or pageCount <= 1 then
        return 0
    end
    local travelPx = getScrollbarTrackThumbTravelPx(nil, travelNorm)
    local startRatio = pageCount > 1 and thumbDragStartPage / (pageCount - 1) or 0
    return clampRange(nil, startRatio + (mouseYPx - thumbDragStartMouseYPx) / travelPx, 0, 1)
end
function onThumbDragMove(self)
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
        nil,
        round(nil, ratio * (pageCount - 1)),
        0,
        pageCount - 1
    )
    local cur = dragCtx:getCurrentPage()
    if targetPage ~= cur then
        dragCtx:setCurrentPage(targetPage)
        dragCtx:onPageChanged(cur, targetPage)
    end
end
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
round = ____require_result_0.round
clampMin = ____require_result_0.clampMin
clampRange = ____require_result_0.clampRange
--- N 槽：所有已注册的滚动上下文，滚轮/拖拽事件路由到可见的那个
local allWheelCtxs = {}
--- 帧上 MOUSE_DOWN 在部分环境不触发；用全局鼠标（`registerMouseButtonEventByCode`，见 ui-frame-types.mdc）
local taskThumbGlobalMouseRegistered = false
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
local function taskUIWheelEventPcallBody(self)
    local ctx = findVisibleWheelCtx(nil)
    if not ctx or not ctx:isVisible() then
        return
    end
    if not isWheelTargetForTaskListByJapi(
        nil,
        japi,
        ctx.getMouseFocus,
        ctx.listContainer,
        ctx.scrollBarHitBtn or ctx.scrollBarFrame,
        ctx.scrollThumbFrame,
        ctx.scrollThumbHitBtn
    ) then
        return
    end
    ____exports.handleTaskUIListWheel(nil, ctx)
end
local function onMouseWheelEvent(self)
    taskUIWheelEventPcallBody(nil)
end
function ____exports.isTaskUIWheelTarget(self, ctx)
    if not ctx.mainPanel then
        return false
    end
    return isWheelTargetForTaskListByJapi(
        nil,
        japi,
        ctx.getMouseFocus,
        ctx.listContainer,
        ctx.scrollBarHitBtn or ctx.scrollBarFrame,
        ctx.scrollThumbFrame,
        ctx.scrollThumbHitBtn
    )
end
dragCtx = nil
thumbDragActive = false
thumbDragStartMouseYPx = 0
thumbDragStartPage = 0
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
    onThumbDragMove(nil)
end
local function onThumbDragEnd(self)
    if not thumbDragActive then
        return
    end
    thumbDragActive = false
    if not dragCtx then
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
    local targetPage = clampRange(
        nil,
        round(nil, ratio * (pageCount - 1)),
        0,
        pageCount - 1
    )
    local cur = dragCtx:getCurrentPage()
    if targetPage ~= cur then
        dragCtx:setCurrentPage(targetPage)
        dragCtx:onPageChanged(cur, targetPage)
    end
    updateTaskUIScrollThumbPosition(nil, dragCtx, pageCount)
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
    local ratio = clampRange(nil, (topY - mouseY) / (topY - bottomY), 0, 1)
    return ratio
end
local function onScrollBarTrackClick(self, ctx)
    local pageCount = ctx:getCurrentPageCount()
    if pageCount <= 1 then
        return
    end
    local ratio = getTaskScrollTrackClickRatio(nil)
    local targetPage = clampRange(
        nil,
        round(nil, ratio * (pageCount - 1)),
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
--- 本图约定：左键按下 (btn=1,status=1)、释放 (1,0)，见 .cursor/rules/dzapi/ui-frame-types.mdc
local function taskUIThumbPressPcallBody(self)
    local ctx = findVisibleWheelCtx(nil)
    if not ctx or not ctx:isVisible() then
        return
    end
    local thumbHit = isTaskScrollThumbDragHit(
        nil,
        japi,
        ctx.getMouseFocus,
        ctx.scrollThumbFrame,
        ctx.scrollThumbHitBtn
    )
    if thumbHit then
        dragCtx = ctx
        onThumbDragStart(nil)
        return
    end
    local trackHit = isTaskScrollBarTrackHit(
        nil,
        japi,
        ctx.getMouseFocus,
        ctx.scrollBarHitBtn or ctx.scrollBarFrame,
        ctx.scrollThumbFrame,
        ctx.scrollThumbHitBtn
    )
    if not trackHit then
        return
    end
    onScrollBarTrackClick(nil, ctx)
end
local function onGlobalThumbLeftPress(self)
    taskUIThumbPressPcallBody(nil)
end
local function taskUIThumbReleasePcallBody(self)
    onThumbDragEnd(nil)
end
local function onGlobalThumbLeftRelease(self)
    taskUIThumbReleasePcallBody(nil)
end
local function taskUIThumbMovePcallBody(self)
    onThumbDragMove(nil)
end
local function onGlobalThumbDragMove(self)
    taskUIThumbMovePcallBody(nil)
end
local function ensureTaskThumbGlobalMouseRegistered(self)
    if taskThumbGlobalMouseRegistered then
        return
    end
    local trig = createTriggerOrNull(nil)
    if not trig then
        return
    end
    registerMouseButtonEventByCode(
        nil,
        trig,
        1,
        1,
        false,
        onGlobalThumbLeftPress
    )
    registerMouseButtonEventByCode(
        nil,
        trig,
        1,
        0,
        false,
        onGlobalThumbLeftRelease
    )
    registerMouseMoveEventByCode(nil, trig, false, onGlobalThumbDragMove)
    taskThumbGlobalMouseRegistered = true
end
function ____exports.registerTaskUIListWheel(self, ctx)
    dragCtx = ctx
    allWheelCtxs[#allWheelCtxs + 1] = ctx
    ensureTaskThumbGlobalMouseRegistered(nil)
    if not ENABLE_MOUSE_WHEEL_SCROLL then
        return nil
    end
    if ctx.taskListWheelRegistered then
        return nil
    end
    ctx.registerMouseWheel(false, onMouseWheelEvent)
    ctx.taskListWheelRegistered = true
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
