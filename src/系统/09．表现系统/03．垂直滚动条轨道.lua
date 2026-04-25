local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local ____exports = {}
local ____index = require("lib.扩展函数.封装函数.04．硬件输入.index")
local getWindowHeight = ____index.getWindowHeight
local ____index = require("系统.09．表现系统.01．UI工具.index")
local setFramePointRelative = ____index.setFramePointRelative
local FramePoint = ____index.FramePoint
--- 垂直滚动条轨道（BACKDROP 轨道 + 圆形 thumb）
-- - 仅保留滚轮滑动功能，删除鼠标拖拽
local jass = require("jass.common")
local japi = require("jass.japi")
--- thumb 垂直可移动行程（归一化 UI 高度），与 syncThumb 使用同一公式
function ____exports.getScrollbarThumbTravelNorm(self, trackHeightNorm, thumbSizeNorm, topCompensation, bottomCompensation)
    local yRange = trackHeightNorm - thumbSizeNorm + topCompensation + bottomCompensation
    return math.max(0, yRange)
end
--- 与 syncThumb 一致的轨道像素高度（Dz 纵向 0..0.6 对应 client 高度）
function ____exports.getScrollbarTrackThumbTravelPx(self, travelNorm)
    local ch = japi.DzGetClientHeight()
    local clientH = type(ch) == "number" and ch > 0 and ch or (getWindowHeight(nil) or 600)
    return math.max(1, clientH * travelNorm / 0.6)
end
--- 封装：仅保留 thumb 位置同步，删除鼠标拖拽
____exports.VerticalScrollbarTrack = __TS__Class()
local VerticalScrollbarTrack = ____exports.VerticalScrollbarTrack
VerticalScrollbarTrack.name = "VerticalScrollbarTrack"
function VerticalScrollbarTrack.prototype.____constructor(self, options)
    self.opt = options
end
function VerticalScrollbarTrack.prototype.attach(self)
end
function VerticalScrollbarTrack.prototype.destroy(self)
end
function VerticalScrollbarTrack.prototype.cancelDrag(self)
end
function VerticalScrollbarTrack.prototype.getHitButtonFrame(self)
    return nil
end
function VerticalScrollbarTrack.prototype.isDragging(self)
    return false
end
function VerticalScrollbarTrack.prototype.trackH(self)
    local t = self.opt.trackHeightNorm
    if t ~= nil and t > 0 then
        return t
    end
    return self.opt.listViewHeightNorm
end
function VerticalScrollbarTrack.prototype.syncThumbVisual(self, maxScroll)
    pcall(function ()
            if type(jass.GetLocalPlayer) ~= "function" then
                return
            end
            local lp = jass.GetLocalPlayer()
            if lp == nil then
                return
            end
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
    )
end
return ____exports
