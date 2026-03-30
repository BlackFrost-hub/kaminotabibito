local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____786C_4EF6_51FD_6570 = require("系统.00．核心系统.硬件函数")
local getMouseFocus = _____786C_4EF6_51FD_6570.getMouseFocus
local getMouseY = _____786C_4EF6_51FD_6570.getMouseY
local getWindowHeight = _____786C_4EF6_51FD_6570.getWindowHeight
local frameSetScriptByCode = _____786C_4EF6_51FD_6570.frameSetScriptByCode
local ____UI_5DE5_5177 = require("系统.09．表现系统.UI工具")
local createFrame = ____UI_5DE5_5177.createFrame
local setFramePointRelative = ____UI_5DE5_5177.setFramePointRelative
local FrameType = ____UI_5DE5_5177.FrameType
local FramePoint = ____UI_5DE5_5177.FramePoint
local EventType = ____UI_5DE5_5177.EventType
--- 垂直滚动条轨道（BACKDROP 轨道 + 圆形 thumb + 透明 GLUETEXTBUTTON 命中）
-- - 全局左键按下/抬起 + getMouseFocus 判定本轨道（1.27e 下帧 MOUSE_DOWN 常不可靠）
-- - 多实例：模块内只注册一次全局鼠标，分发给所有 VerticalScrollbarTrack
local jass = require("jass.common")
local japi = require("jass.japi")
--- thumb 竖直可移动行程（归一化 UI 高度），与 syncThumb 使用同一公式
function ____exports.getScrollbarThumbTravelNorm(self, trackHeightNorm, thumbSizeNorm, topCompensation, bottomCompensation)
    local yRange = trackHeightNorm - thumbSizeNorm + topCompensation + bottomCompensation
    return math.max(0, yRange)
end
--- 与 syncThumb 一致的轨道像素高度（Dz 竖向 0..0.6 对应 client 高度）
function ____exports.getScrollbarTrackThumbTravelPx(self, travelNorm)
    local ____temp_0
    if type(japi.DzGetClientHeight) == "function" then
        ____temp_0 = japi.DzGetClientHeight()
    else
        ____temp_0 = getWindowHeight(nil) or 600
    end
    local ch = ____temp_0
    return math.max(1, ch * travelNorm / 0.6)
end
--- 与 war3map.j DzTriggerRegisterMouseEventTrg 一致：左键按下 (1,1)、释放 (1,0)
local MOUSE_BTN_LEFT = 1
local MOUSE_STATUS_PRESS = 1
local MOUSE_STATUS_RELEASE = 0
--- 封装：透明命中键 + 全局鼠标拖拽 + thumb 位置同步
____exports.VerticalScrollbarTrack = __TS__Class()
local VerticalScrollbarTrack = ____exports.VerticalScrollbarTrack
VerticalScrollbarTrack.name = "VerticalScrollbarTrack"
function VerticalScrollbarTrack.prototype.____constructor(self, options)
    self.hitBtn = nil
    self.dragging = false
    self.lastMouseY = 0
    self.dragTimer = nil
    self.opt = options
    self.dragTick = options.dragTick or 0.03
    self.sensitivity = options.sensitivity or 1
end
function VerticalScrollbarTrack.prototype.attach(self)
    if not self.opt.thumbFrame or self.opt.thumbFrame == 0 then
        return
    end
    self.hitBtn = createFrame(nil, {
        type = FrameType.GLUETEXTBUTTON,
        name = self.opt.hitButtonName,
        parent = self.opt.thumbFrame,
        template = "template",
        visible = true,
        enable = true,
        alpha = 0
    })
    if not self.hitBtn or self.hitBtn == 0 then
        self.hitBtn = nil
        return
    end
    if type(japi.DzFrameSetAllPoints) == "function" then
        japi.DzFrameSetAllPoints(self.hitBtn, self.opt.thumbFrame)
    end
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(self.hitBtn, 121)
    end
    frameSetScriptByCode(
        nil,
        self.hitBtn,
        EventType.MOUSE_DOWN,
        function() return self:forceBeginDragFromHit() end,
        false
    )
    local ____exports_VerticalScrollbarTrack_instances_1 = ____exports.VerticalScrollbarTrack.instances
    ____exports_VerticalScrollbarTrack_instances_1[#____exports_VerticalScrollbarTrack_instances_1 + 1] = self
    ____exports.VerticalScrollbarTrack:ensureGlobalMouseHooks()
end
function VerticalScrollbarTrack.prototype.destroy(self)
    local idx = __TS__ArrayIndexOf(____exports.VerticalScrollbarTrack.instances, self)
    if idx >= 0 then
        __TS__ArraySplice(____exports.VerticalScrollbarTrack.instances, idx, 1)
    end
    self:endDrag()
    self.hitBtn = nil
end
function VerticalScrollbarTrack.prototype.cancelDrag(self)
    self:endDrag()
end
function VerticalScrollbarTrack.prototype.getHitButtonFrame(self)
    return self.hitBtn
end
function VerticalScrollbarTrack.prototype.isDragging(self)
    return self.dragging
end
function VerticalScrollbarTrack.prototype.isFocusOnThisTrack(self, focus)
    if not focus or focus == 0 then
        return false
    end
    if self.hitBtn and focus == self.hitBtn then
        return true
    end
    if focus == self.opt.thumbFrame then
        return true
    end
    if focus == self.opt.trackFrame then
        return true
    end
    return false
end
function VerticalScrollbarTrack.prototype.trackH(self)
    local t = self.opt.trackHeightNorm
    if t ~= nil and t > 0 then
        return t
    end
    return self.opt.listViewHeightNorm
end
function VerticalScrollbarTrack.prototype.getMaxScroll(self)
    local h = self.opt:getTotalContentHeight()
    local lv = self.opt.listViewHeightNorm
    return math.max(0, h - lv)
end
function VerticalScrollbarTrack.prototype.forceBeginDragFromHit(self)
    if not self.opt:isInteractionEnabled() or not self.hitBtn then
        return
    end
    local maxScroll = self:getMaxScroll()
    if maxScroll <= 0 then
        return
    end
    if self.dragging then
        return
    end
    self:startDrag()
end
function VerticalScrollbarTrack.prototype.tryBeginDrag(self)
    if not self.opt:isInteractionEnabled() or not self.hitBtn then
        return
    end
    local maxScroll = self:getMaxScroll()
    if maxScroll <= 0 then
        return
    end
    if self.dragging then
        return
    end
    local function go()
        local focus = getMouseFocus(nil)
        if self:isFocusOnThisTrack(focus) then
            self:startDrag()
        end
    end
    go(nil)
    local ____temp_2
    if type(jass.CreateTimer) == "function" then
        ____temp_2 = jass.CreateTimer()
    else
        ____temp_2 = nil
    end
    local t = ____temp_2
    if not t or type(jass.TimerStart) ~= "function" then
        return
    end
    jass.TimerStart(
        t,
        0.03,
        false,
        function()
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(t)
            end
            if not self.dragging then
                go(nil)
            end
        end
    )
end
function VerticalScrollbarTrack.prototype.startDrag(self)
    if self.dragging then
        return
    end
    local maxScroll = self:getMaxScroll()
    if maxScroll <= 0 then
        return
    end
    self.dragging = true
    self.lastMouseY = getMouseY(nil)
    self:stopDragTimer()
    if type(jass.CreateTimer) ~= "function" or type(jass.TimerStart) ~= "function" then
        return
    end
    self.dragTimer = jass.CreateTimer()
    jass.TimerStart(
        self.dragTimer,
        self.dragTick,
        true,
        function() return self:onDragTick() end
    )
end
function VerticalScrollbarTrack.prototype.stopDragTimer(self)
    if self.dragTimer == nil then
        return
    end
    if type(jass.PauseTimer) == "function" then
        jass.PauseTimer(self.dragTimer)
    end
    if type(jass.DestroyTimer) == "function" then
        jass.DestroyTimer(self.dragTimer)
    end
    self.dragTimer = nil
end
function VerticalScrollbarTrack.prototype.onDragTick(self)
    if not self.dragging then
        return
    end
    local maxScroll = self:getMaxScroll()
    if maxScroll <= 0 then
        self:endDrag()
        return
    end
    local mouseY = getMouseY(nil)
    local dy = mouseY - self.lastMouseY
    self.lastMouseY = mouseY
    local travelNorm = ____exports.getScrollbarThumbTravelNorm(
        nil,
        self:trackH(),
        self.opt.thumbSizeNorm,
        self.opt.topCompensation,
        self.opt.bottomCompensation
    )
    local trackPx = ____exports.getScrollbarTrackThumbTravelPx(nil, travelNorm)
    local next = self.opt:getScrollOffset() + dy / trackPx * maxScroll * self.sensitivity
    if next < 0 then
        next = 0
    end
    if next > maxScroll then
        next = maxScroll
    end
    self.opt:setScrollOffset(next)
    self.opt:onScrollChanged()
end
function VerticalScrollbarTrack.prototype.endDrag(self)
    if not self.dragging then
        return
    end
    self.dragging = false
    self:stopDragTimer()
end
function VerticalScrollbarTrack.prototype.onGlobalMouseUp(self)
    self:endDrag()
end
function VerticalScrollbarTrack.prototype.syncThumbVisual(self, maxScroll)
    if self.opt.skipManualThumbSync and self.opt:skipManualThumbSync() then
        return
    end
    if not self.opt.thumbFrame or self.opt.thumbFrame == 0 then
        return
    end
    if not self.opt.trackFrame or self.opt.trackFrame == 0 then
        return
    end
    local tf = self.opt.thumbFrame
    if type(japi.DzFrameShow) == "function" then
        japi.DzFrameShow(tf, true)
    end
    if type(japi.DzFrameSetLevel) == "function" then
        japi.DzFrameSetLevel(tf, 120)
    end
    if type(japi.DzFrameSetSize) == "function" then
        japi.DzFrameSetSize(tf, self.opt.thumbSizeNorm, self.opt.thumbSizeNorm)
    end
    local safeRange = ____exports.getScrollbarThumbTravelNorm(
        nil,
        self:trackH(),
        self.opt.thumbSizeNorm,
        self.opt.topCompensation,
        self.opt.bottomCompensation
    )
    local progress = maxScroll <= 0 and 0 or self.opt:getScrollOffset() / maxScroll
    local yOffset = (0.5 - progress) * safeRange + (self.opt.topCompensation - self.opt.bottomCompensation) * 0.5
    if type(japi.DzFrameClearAllPoints) == "function" then
        japi.DzFrameClearAllPoints(tf)
    end
    setFramePointRelative(
        nil,
        tf,
        FramePoint.CENTER,
        self.opt.trackFrame,
        FramePoint.CENTER,
        0,
        yOffset
    )
end
function VerticalScrollbarTrack.ensureGlobalMouseHooks(self)
    if not ____exports.VerticalScrollbarTrack.globalDownOk then
        local ____temp_3
        if type(jass.CreateTrigger) == "function" then
            ____temp_3 = jass.CreateTrigger()
        else
            ____temp_3 = nil
        end
        local trig = ____temp_3
        if trig and type(japi.DzTriggerRegisterMouseEventByCode) == "function" then
            japi.DzTriggerRegisterMouseEventByCode(
                trig,
                MOUSE_BTN_LEFT,
                MOUSE_STATUS_PRESS,
                false,
                function()
                    for ____, inst in ipairs(____exports.VerticalScrollbarTrack.instances) do
                        inst:tryBeginDrag()
                    end
                end
            )
            ____exports.VerticalScrollbarTrack.globalDownOk = true
        end
    end
    if not ____exports.VerticalScrollbarTrack.globalUpOk then
        local ____temp_4
        if type(jass.CreateTrigger) == "function" then
            ____temp_4 = jass.CreateTrigger()
        else
            ____temp_4 = nil
        end
        local trig2 = ____temp_4
        if trig2 and type(japi.DzTriggerRegisterMouseEventByCode) == "function" then
            japi.DzTriggerRegisterMouseEventByCode(
                trig2,
                MOUSE_BTN_LEFT,
                MOUSE_STATUS_RELEASE,
                false,
                function()
                    for ____, inst in ipairs(____exports.VerticalScrollbarTrack.instances) do
                        inst:onGlobalMouseUp()
                    end
                end
            )
            ____exports.VerticalScrollbarTrack.globalUpOk = true
        end
    end
end
VerticalScrollbarTrack.instances = {}
VerticalScrollbarTrack.globalDownOk = false
VerticalScrollbarTrack.globalUpOk = false
return ____exports
