--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1UI_5E38_91CF = require("系统.08．任务系统.04．任务UI拆分.01．任务UI常量")
local LIST_VIEW_H = ____01_FF0E_4EFB_52A1UI_5E38_91CF.LIST_VIEW_H
local ENABLE_MOUSE_WHEEL_SCROLL = ____01_FF0E_4EFB_52A1UI_5E38_91CF.ENABLE_MOUSE_WHEEL_SCROLL
local ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8 = require("系统.08．任务系统.04．任务UI拆分.03．任务UI列表与滚动")
local isWheelTargetForTaskListByJapi = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.isWheelTargetForTaskList
local computeNextScrollOffsetByWheel = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.computeNextScrollOffsetByWheel
local updateScrollBarVisibilityByJapi = ____03_FF0E_4EFB_52A1UI_5217_8868_4E0E_6EDA_52A8.updateScrollBarVisibility
local jass = require("jass.common")
local japi = require("jass.japi")
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
--- 根据滚轮增量计算下一帧 scrollOffset，并在值变化时触发列表重绘。
function ____exports.handleTaskUIListWheel(self, ctx, refreshList)
    local next = computeNextScrollOffsetByWheel(
        nil,
        ctx.getWheelDelta,
        ctx:getScrollOffset(),
        ctx:getTotalContentHeight(),
        LIST_VIEW_H
    )
    if next == ctx:getScrollOffset() then
        return
    end
    ctx:setScrollOffset(next)
    refreshList(nil)
end
--- 注册一次全局滚轮，再通过焦点父链判断把事件限制在任务列表子树内。
function ____exports.registerTaskUIListWheel(self, ctx, refreshList)
    if not ENABLE_MOUSE_WHEEL_SCROLL then
        return ctx.taskListWheelTrig
    end
    if ctx.taskListWheelTrig then
        return ctx.taskListWheelTrig
    end
    ctx.taskListWheelTrig = ctx:registerMouseWheel(
        false,
        function()
            pcall(function ()
                    local lp = jass.GetLocalPlayer()
                    if lp == nil then
                        return
                    end
                    if not ctx:isVisible() then
                        return
                    end
                    if not ____exports.isTaskUIWheelTarget(nil, ctx) then
                        return
                    end
                    ____exports.handleTaskUIListWheel(nil, ctx, refreshList)
                end
            )
        end
    )
    return ctx.taskListWheelTrig
end
--- 只同步视觉 thumb，不参与值计算。
function ____exports.syncTaskUIScrollThumb(self, ctx, maxScroll)
    if not ctx.vScrollTrack then
        return
    end
    ctx.vScrollTrack:syncThumbVisual(maxScroll)
end
--- 轨道/滑块显隐规则统一委托给列表滚动辅助模块，避免门面层重复判断。
function ____exports.updateTaskUIScrollBarVisibility(self, ctx, maxScroll, hasQuestRows)
    updateScrollBarVisibilityByJapi(
        nil,
        japi,
        maxScroll,
        {ctx.scrollBarFrame, ctx.scrollThumbFrame, ctx.scrollThumbHitBtn},
        hasQuestRows
    )
end
return ____exports
