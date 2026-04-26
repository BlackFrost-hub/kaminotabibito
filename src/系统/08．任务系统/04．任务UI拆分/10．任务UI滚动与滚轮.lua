--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local thumbTravelNorm, setTaskScrollThumbByRatio, updateTaskUIScrollThumbPosition, ratioFromThumbDragMouseY, onThumbDragMove, dragCtx, thumbDragActive, thumbDragStartMouseYPx, thumbDragStartPage
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local ENABLE_MOUSE_WHEEL_SCROLL = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_MOUSE_WHEEL_SCROLL
local ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8 = require("系统.08．任务系统.04．任务UI拆分.03．任务UI列表与滚动")
local isWheelTargetForTaskListByJapi = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isWheelTargetForTaskList
local isTaskScrollThumbDragHit = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isTaskScrollThumbDragHit
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local createTriggerOrNull = ____index.createTriggerOrNull
local getMouseY = ____index.getMouseY
local getScrollbarTrackThumbTravelPx = ____index.getScrollbarTrackThumbTravelPx
local registerMouseButtonEventByCode = ____index.registerMouseButtonEventByCode
local registerMouseMoveEventByCode = ____index.registerMouseMoveEventByCode
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local SCROLLBAR_W = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLLBAR_W
local SCROLL_THUMB_SIZE = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_SIZE
local SCROLL_THUMB_TOP_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_TOP_COMPENSATION
local SCROLL_THUMB_BOTTOM_COMPENSATION = ____01_FF0E_4EFB_52A1UI_5E38_91CF.SCROLL_THUMB_BOTTOM_COMPENSATION
local ____02_FF0E_4EFB_52A1UI_8F85_52A9 = require("系统.08．任务系统.04．任务UI拆分.02．任务UI辅助")
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
    local r = math.max(
        0,
        math.min(1, ratio)
    )
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
    local currentPage = math.max(
        0,
        math.min(
            pageCount - 1,
            ctx:getCurrentPage()
        )
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
        nextPage = math.max(0, currentPage - 1)
    end
    if delta < 0 then
        nextPage = math.min(pageCount - 1, currentPage + 1)
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
    return math.max(
        0,
        math.min(1, startRatio + (mouseYPx - thumbDragStartMouseYPx) / travelPx)
    )
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
    local targetPage = math.max(
        0,
        math.min(
            pageCount - 1,
            math.floor(ratio * (pageCount - 1) + 0.5)
        )
    )
    local cur = dragCtx:getCurrentPage()
    if targetPage ~= cur then
        dragCtx:setCurrentPage(targetPage)
        dragCtx:onPageChanged(cur, targetPage)
    end
end
local japi = require("jass.japi")
local wheelCtx = nil
--- 帧上 MOUSE_DOWN 在部分环境不触发；用全局鼠标（`registerMouseButtonEventByCode`，见 ui-frame-types.mdc）
local taskThumbGlobalMouseTrig = nil
local function taskUIWheelEventPcallBody(self)
    local ctx = wheelCtx
    if not ctx:isVisible() then
        return
    end
    if not isWheelTargetForTaskListByJapi(
        nil,
        japi,
        ctx.getMouseFocus,
        ctx.listContainer,
        ctx.scrollBarFrame,
        ctx.scrollThumbFrame,
        ctx.scrollThumbHitBtn
    ) then
        return
    end
    ____exports.handleTaskUIListWheel(nil, ctx)
end
local function onMouseWheelEvent(self)
    if not wheelCtx then
        return
    end
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
        ctx.scrollBarFrame,
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
    local targetPage = math.max(
        0,
        math.min(
            pageCount - 1,
            math.floor(ratio * (pageCount - 1) + 0.5)
        )
    )
    local cur = dragCtx:getCurrentPage()
    if targetPage ~= cur then
        dragCtx:setCurrentPage(targetPage)
        dragCtx:onPageChanged(cur, targetPage)
    end
    updateTaskUIScrollThumbPosition(nil, dragCtx, pageCount)
end
--- 本图约定：左键按下 (btn=1,status=1)、释放 (1,0)，见 .cursor/rules/dzapi/ui-frame-types.mdc
local function taskUIThumbPressPcallBody(self)
    local ctx = wheelCtx
    if not ctx or not ctx:isVisible() then
        return
    end
    if not isTaskScrollThumbDragHit(
        nil,
        japi,
        ctx.getMouseFocus,
        ctx.scrollThumbFrame,
        ctx.scrollThumbHitBtn
    ) then
        return
    end
    dragCtx = ctx
    onThumbDragStart(nil)
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
    if taskThumbGlobalMouseTrig ~= nil then
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
    taskThumbGlobalMouseTrig = trig
end
function ____exports.registerTaskUIListWheel(self, ctx)
    wheelCtx = ctx
    dragCtx = ctx
    ensureTaskThumbGlobalMouseRegistered(nil)
    if not ENABLE_MOUSE_WHEEL_SCROLL then
        return ctx.taskListWheelTrig
    end
    if ctx.taskListWheelTrig then
        return ctx.taskListWheelTrig
    end
    ctx.taskListWheelTrig = ctx.registerMouseWheel(false, onMouseWheelEvent)
    return ctx.taskListWheelTrig
end
function ____exports.updateTaskUIScrollBarVisibility(self, ctx, pageCount, hasQuestRows)
    local visible = hasQuestRows
    for ____, frame in ipairs({ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn}) do
        if frame and frame ~= 0 then
            pcallDzFrameShow(nil, japi, frame, visible)
        end
    end
    if visible then
        updateTaskUIScrollThumbPosition(nil, ctx, pageCount)
    end
end
return ____exports
