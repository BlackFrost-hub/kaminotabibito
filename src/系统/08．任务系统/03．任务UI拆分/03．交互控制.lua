local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__Iterator = ____lualib.__TS__Iterator
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local ____00_FF0E_914D_7F6E_5E38_91CF = require("系统.08．任务系统.03．任务UI拆分.00．配置常量")
local LIST_ITEM_H = ____00_FF0E_914D_7F6E_5E38_91CF.LIST_ITEM_H
local jass = require("jass.common")
function ____exports.registerTaskUIHotkeys(self, opts)
    local ____opts_0 = opts
    local registerKeyDown = ____opts_0.registerKeyDown
    local KEY = ____opts_0.KEY
    local KEY_NUM = ____opts_0.KEY_NUM
    local onClickSound = ____opts_0.onClickSound
    local onTogglePanel = ____opts_0.onTogglePanel
    local onSwitchCategory = ____opts_0.onSwitchCategory
    local isVisible = ____opts_0.isVisible
    local setCurrentPlayerId = ____opts_0.setCurrentPlayerId
    if type(registerKeyDown) ~= "function" then
        return
    end
    registerKeyDown(
        nil,
        KEY.J,
        function(____, player)
            pcall(function ()
                    if type(jass.GetLocalPlayer) ~= "function" then
                        return
                    end
                    local lp = jass.GetLocalPlayer()
                    if lp == nil then
                        return
                    end
                    local ____temp_1
                    if type(jass.GetPlayerId) == "function" then
                        ____temp_1 = jass.GetPlayerId
                    else
                        ____temp_1 = nil
                    end
                    local getPid = ____temp_1
                    if getPid and player then
                        setCurrentPlayerId(
                            nil,
                            getPid(player)
                        )
                    end
                    onClickSound(nil)
                    onTogglePanel(nil)
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K1,
        function()
            pcall(function ()
                    if type(jass.GetLocalPlayer) ~= "function" then
                        return
                    end
                    if jass.GetLocalPlayer() == nil then
                        return
                    end
                    if not isVisible(nil) then
                        return
                    end
                    onClickSound(nil)
                    onSwitchCategory(nil, QuestType.MAIN)
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K2,
        function()
            pcall(function ()
                    if type(jass.GetLocalPlayer) ~= "function" then
                        return
                    end
                    if jass.GetLocalPlayer() == nil then
                        return
                    end
                    if not isVisible(nil) then
                        return
                    end
                    onClickSound(nil)
                    onSwitchCategory(nil, QuestType.SIDE)
                end
            )
        end
    )
    registerKeyDown(
        nil,
        KEY_NUM.K3,
        function()
            pcall(function ()
                    if type(jass.GetLocalPlayer) ~= "function" then
                        return
                    end
                    if jass.GetLocalPlayer() == nil then
                        return
                    end
                    if not isVisible(nil) then
                        return
                    end
                    onClickSound(nil)
                    onSwitchCategory(nil, QuestType.DAILY)
                end
            )
        end
    )
end
local function isDescendantOfFrame(self, japi, frame, ancestor)
    if not frame or frame == 0 or not ancestor or ancestor == 0 then
        return false
    end
    local cur = frame
    do
        local i = 0
        while i < 64 do
            if cur == ancestor then
                return true
            end
            local ____temp_2
            if type(japi.DzFrameGetParent) == "function" then
                ____temp_2 = japi.DzFrameGetParent(cur)
            else
                ____temp_2 = 0
            end
            local p = ____temp_2
            if not p or p == 0 then
                return false
            end
            cur = p
            i = i + 1
        end
    end
    return false
end
local function isWheelTargetForTaskList(self, japi, getMouseFocus, listContainer, scrollBarFrame, scrollThumbFrame, scrollThumbHitBtn)
    local f = type(getMouseFocus) == "function" and getMouseFocus(nil) or 0
    if not f or f == 0 then
        return false
    end
    if listContainer and (f == listContainer or isDescendantOfFrame(nil, japi, f, listContainer)) then
        return true
    end
    if scrollBarFrame and (f == scrollBarFrame or isDescendantOfFrame(nil, japi, f, scrollBarFrame)) then
        return true
    end
    if scrollThumbFrame and (f == scrollThumbFrame or isDescendantOfFrame(nil, japi, f, scrollThumbFrame)) then
        return true
    end
    if scrollThumbHitBtn and f == scrollThumbHitBtn then
        return true
    end
    return false
end
____exports.isDescendantOf = isDescendantOfFrame
____exports.isWheelTargetForTaskList = isWheelTargetForTaskList
function ____exports.registerTaskListWheelBridge(self, opts)
    local ____opts_3 = opts
    local japi = ____opts_3.japi
    local registerMouseWheel = ____opts_3.registerMouseWheel
    local getMouseFocus = ____opts_3.getMouseFocus
    local isVisible = ____opts_3.isVisible
    local isMainPanelReady = ____opts_3.isMainPanelReady
    local listContainer = ____opts_3.listContainer
    local scrollBarFrame = ____opts_3.scrollBarFrame
    local scrollThumbFrame = ____opts_3.scrollThumbFrame
    local scrollThumbHitBtn = ____opts_3.scrollThumbHitBtn
    local onWheelAccepted = ____opts_3.onWheelAccepted
    if type(registerMouseWheel) ~= "function" then
        return nil
    end
    return registerMouseWheel(
        nil,
        false,
        function()
            pcall(function ()
                    if not isMainPanelReady(nil) then
                        return
                    end
                    if not isVisible(nil) then
                        return
                    end
                    local ok = isWheelTargetForTaskList(
                        nil,
                        japi,
                        getMouseFocus,
                        listContainer(nil),
                        scrollBarFrame(nil),
                        scrollThumbFrame(nil),
                        scrollThumbHitBtn(nil)
                    )
                    if not ok then
                        return
                    end
                    onWheelAccepted(nil)
                end
            )
        end
    )
end
function ____exports.applyWheelScrollOffset(self, opts)
    local ____opts_4 = opts
    local getWheelDelta = ____opts_4.getWheelDelta
    local listItemHeight = ____opts_4.listItemHeight
    local listGap = ____opts_4.listGap
    local totalContentHeight = ____opts_4.totalContentHeight
    local listViewHeight = ____opts_4.listViewHeight
    local scrollOffset = ____opts_4.scrollOffset
    local setScrollOffset = ____opts_4.setScrollOffset
    local delta = type(getWheelDelta) == "function" and getWheelDelta(nil) or 0
    if delta == 0 then
        return false
    end
    local step = listItemHeight + listGap
    local maxScroll = math.max(0, totalContentHeight - listViewHeight)
    local next = scrollOffset
    if delta > 0 then
        next = math.max(0, scrollOffset - step)
    elseif delta < 0 then
        next = math.min(maxScroll, scrollOffset + step)
    end
    if next == scrollOffset then
        return false
    end
    setScrollOffset(nil, next)
    return true
end
function ____exports.computeNextScrollOffsetByWheel(self, getWheelDelta, currentOffset, totalContentHeight, listViewHeight)
    local delta = type(getWheelDelta) == "function" and getWheelDelta(nil) or 0
    if delta == 0 then
        return currentOffset
    end
    local step = LIST_ITEM_H + 0.01
    local maxScroll = math.max(0, totalContentHeight - listViewHeight)
    if delta > 0 then
        return math.max(0, currentOffset - step)
    end
    if delta < 0 then
        return math.min(maxScroll, currentOffset + step)
    end
    return currentOffset
end
function ____exports.syncTaskUIScrollThumb(self, vScrollTrack, maxScroll)
    if not vScrollTrack then
        return
    end
    vScrollTrack:syncThumbVisual(maxScroll)
end
function ____exports.updateTaskUIScrollBarVisibility(self, japi, maxScroll, frames)
    local vis = maxScroll > 0
    local show = japi.DzFrameShow
    if type(show) ~= "function" then
        return
    end
    for ____, f in ipairs(frames) do
        if f and f ~= 0 then
            pcall(function () return show(nil, f, vis) end
            )
        end
    end
end
____exports.updateScrollBarVisibility = ____exports.updateTaskUIScrollBarVisibility
function ____exports.clearTaskUIReusableFrames(self, opts)
    local ____opts_5 = opts
    local japi = ____opts_5.japi
    local listItemFrames = ____opts_5.listItemFrames
    local rowBackdropByQuestId = ____opts_5.rowBackdropByQuestId
    local titleByQuestId = ____opts_5.titleByQuestId
    local clickBtnByQuestId = ____opts_5.clickBtnByQuestId
    local objFrameByKey = ____opts_5.objFrameByKey
    local failFrameByQuestId = ____opts_5.failFrameByQuestId
    local rowIconByQuestId = ____opts_5.rowIconByQuestId
    local setListItemFrames = ____opts_5.setListItemFrames
    local show = japi.DzFrameShow
    if type(show) ~= "function" then
        setListItemFrames(nil, {})
        return
    end
    for ____, f in ipairs(listItemFrames) do
        show(nil, f, false)
    end
    for ____, f in __TS__Iterator(rowBackdropByQuestId:values()) do
        if f ~= 0 then
            show(nil, f, false)
        end
    end
    for ____, f in __TS__Iterator(titleByQuestId:values()) do
        if f ~= 0 then
            show(nil, f, false)
        end
    end
    for ____, f in __TS__Iterator(clickBtnByQuestId:values()) do
        if f ~= 0 then
            show(nil, f, false)
        end
    end
    for ____, f in __TS__Iterator(objFrameByKey:values()) do
        if f ~= 0 then
            show(nil, f, false)
        end
    end
    for ____, f in __TS__Iterator(failFrameByQuestId:values()) do
        if f ~= 0 then
            show(nil, f, false)
        end
    end
    for ____, f in __TS__Iterator(rowIconByQuestId:values()) do
        if f ~= 0 then
            show(nil, f, false)
        end
    end
    setListItemFrames(nil, {})
end
function ____exports.toggleTaskUIPanel(self, opts)
    local ____opts_6 = opts
    local isVisible = ____opts_6.isVisible
    local setVisible = ____opts_6.setVisible
    local show = ____opts_6.show
    local hide = ____opts_6.hide
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            if jass.GetLocalPlayer() == nil then
                return
            end
            local next = not isVisible(nil)
            setVisible(nil, next)
            if next then
                show(nil)
            else
                hide(nil)
            end
        end
    )
end
function ____exports.showTaskUIPanel(self, opts)
    local ____opts_7 = opts
    local mainPanel = ____opts_7.mainPanel
    local playerId = ____opts_7.playerId
    local setCurrentPlayerId = ____opts_7.setCurrentPlayerId
    local setVisible = ____opts_7.setVisible
    local showFrame = ____opts_7.showFrame
    local refreshList = ____opts_7.refreshList
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            if jass.GetLocalPlayer() == nil then
                return
            end
            if not mainPanel then
                return
            end
            setCurrentPlayerId(nil, playerId)
            setVisible(nil, true)
            showFrame(nil, mainPanel)
            refreshList(nil)
        end
    )
end
function ____exports.hideTaskUIPanel(self, opts)
    local ____opts_8 = opts
    local mainPanel = ____opts_8.mainPanel
    local vScrollTrack = ____opts_8.vScrollTrack
    local setVisible = ____opts_8.setVisible
    local hideFrame = ____opts_8.hideFrame
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            if jass.GetLocalPlayer() == nil then
                return
            end
            if not mainPanel then
                return
            end
            if vScrollTrack and type(vScrollTrack.cancelDrag) == "function" then
                vScrollTrack:cancelDrag()
            end
            setVisible(nil, false)
            hideFrame(nil, mainPanel)
        end
    )
end
____exports.LIST_WHEEL_STEP_BASE = LIST_ITEM_H
return ____exports
