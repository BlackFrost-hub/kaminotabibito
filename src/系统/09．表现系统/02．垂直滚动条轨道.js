/**
 * 垂直滚动条轨道（BACKDROP 轨道 + 圆形 thumb + 透明 GLUETEXTBUTTON 命中）
 * - 全局左键按下/抬起 + getMouseFocus 判定本轨道（1.27e 下帧 MOUSE_DOWN 常不可靠）
 * - 多实例：模块内只注册一次全局鼠标，分发给所有 VerticalScrollbarTrack
 */
/* eslint-disable @typescript-eslint/no-explicit-any */
const jass = require("jass.common");
const japi = require("jass.japi");
import { getMouseFocus, getMouseY, getWindowHeight, frameSetScriptByCode } from "../00．核心系统/04．硬件函数";
import { createFrame, setFramePointRelative, FrameType, FramePoint, EventType } from "./01．UI工具/index";
/** thumb 竖直可移动行程（归一化 UI 高度），与 syncThumb 使用同一公式 */
export function getScrollbarThumbTravelNorm(trackHeightNorm, thumbSizeNorm, topCompensation, bottomCompensation) {
    const yRange = trackHeightNorm - thumbSizeNorm + topCompensation + bottomCompensation;
    return Math.max(0, yRange);
}
/** 与 syncThumb 一致的轨道像素高度（Dz 竖向 0..0.6 对应 client 高度） */
export function getScrollbarTrackThumbTravelPx(travelNorm) {
    const ch = typeof japi.DzGetClientHeight === "function"
        ? japi.DzGetClientHeight()
        : getWindowHeight() || 600;
    return Math.max(1, (ch * travelNorm) / 0.6);
}
/** 与 war3map.j DzTriggerRegisterMouseEventTrg 一致：左键按下 (1,1)、释放 (1,0) */
const MOUSE_BTN_LEFT = 1;
const MOUSE_STATUS_PRESS = 1;
const MOUSE_STATUS_RELEASE = 0;
/** 封装：透明命中键 + 全局鼠标拖拽 + thumb 位置同步 */
export class VerticalScrollbarTrack {
    opt;
    hitBtn = null;
    dragging = false;
    lastMouseY = 0;
    dragTimer = null;
    dragTick;
    sensitivity;
    mouseDownTrigger = null;
    mouseUpTrigger = null;
    constructor(options) {
        this.opt = options;
        this.dragTick = options.dragTick ?? 0.03;
        this.sensitivity = options.sensitivity ?? 1;
    }
    /** 创建命中按钮并加入全局分发（同一地图可多实例） */
    attach() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp != null) {
                if (!this.opt.thumbFrame || this.opt.thumbFrame === 0)
                    return;
                this.hitBtn = createFrame({
                    type: FrameType.GLUETEXTBUTTON,
                    name: this.opt.hitButtonName,
                    parent: this.opt.thumbFrame,
                    template: "template",
                    visible: true,
                    enable: true,
                    alpha: 0,
                });
                if (!this.hitBtn || this.hitBtn === 0) {
                    this.hitBtn = null;
                    return;
                }
                if (typeof japi.DzFrameSetAllPoints === "function") {
                    japi.DzFrameSetAllPoints(this.hitBtn, this.opt.thumbFrame);
                }
                if (typeof japi.DzFrameSetLevel === "function") {
                    japi.DzFrameSetLevel(this.hitBtn, 121);
                }
                /** 帧上直接按下：避免仅依赖全局 MOUSE_DOWN + DzGetMouseFocus 时 focus 未落到透明 GLUETEXTBUTTON 导致无法 startDrag */
                frameSetScriptByCode(this.hitBtn, EventType.MOUSE_DOWN, () => this.forceBeginDragFromHit(), false);
                frameSetScriptByCode(this.hitBtn, EventType.MOUSE_CLICK, () => this.forceBeginDragFromHit(), false);
                frameSetScriptByCode(this.hitBtn, EventType.MOUSE_UP, () => this.endDrag(), false);
                if (typeof jass.CreateTrigger === "function" && typeof japi.DzTriggerRegisterMouseEventByCode === "function") {
                    this.mouseDownTrigger = jass.CreateTrigger();
                    japi.DzTriggerRegisterMouseEventByCode(this.mouseDownTrigger, MOUSE_BTN_LEFT, MOUSE_STATUS_PRESS, false, () => {
                        pcall(() => {
                            const lp2 = jass.GetLocalPlayer();
                            if (lp2 == null)
                                return;
                            if (!this.opt.isInteractionEnabled() || !this.hitBtn)
                                return;
                            const maxScroll = this.getMaxScroll();
                            if (maxScroll <= 0)
                                return;
                            if (this.dragging)
                                return;
                            const focus = getMouseFocus();
                            if (this.isFocusOnThisTrack(focus))
                                this.startDrag();
                        });
                    });
                    this.mouseUpTrigger = jass.CreateTrigger();
                    japi.DzTriggerRegisterMouseEventByCode(this.mouseUpTrigger, MOUSE_BTN_LEFT, MOUSE_STATUS_RELEASE, false, () => {
                        pcall(() => {
                            const lp2 = jass.GetLocalPlayer();
                            if (lp2 == null)
                                return;
                            this.endDrag();
                        });
                    });
                }
            }
        });
        pcall(() => {
            this.stopDragTimer();
            if (typeof jass.CreateTimer !== "function" || typeof jass.TimerStart !== "function")
                return;
            this.dragTimer = jass.CreateTimer();
            jass.TimerStart(this.dragTimer, this.dragTick, true, () => this.onDragTick());
        });
    }
    destroy() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp != null) {
                if (this.mouseDownTrigger && typeof jass.DestroyTrigger === "function") {
                    jass.DestroyTrigger(this.mouseDownTrigger);
                }
                if (this.mouseUpTrigger && typeof jass.DestroyTrigger === "function") {
                    jass.DestroyTrigger(this.mouseUpTrigger);
                }
            }
        });
        this.endDrag();
        pcall(() => {
            this.stopDragTimer();
        });
        this.hitBtn = null;
        this.mouseDownTrigger = null;
        this.mouseUpTrigger = null;
    }
    /** 面板隐藏时调用，避免隐藏后仍保持拖拽状态 */
    cancelDrag() {
        this.endDrag();
    }
    getHitButtonFrame() {
        return this.hitBtn;
    }
    isDragging() {
        return this.dragging;
    }
    isFocusOnThisTrack(focus) {
        if (!focus || focus === 0)
            return false;
        if (this.hitBtn && focus === this.hitBtn)
            return true;
        if (focus === this.opt.thumbFrame)
            return true;
        if (focus === this.opt.trackFrame)
            return true;
        return false;
    }
    trackH() {
        const t = this.opt.trackHeightNorm;
        if (t !== undefined && t > 0)
            return t;
        return this.opt.listViewHeightNorm;
    }
    getMaxScroll() {
        const h = this.opt.getTotalContentHeight();
        const lv = this.opt.listViewHeightNorm;
        return Math.max(0, h - lv);
    }
    /** 透明命中键回调：不依赖 getMouseFocus，与 tryBeginDrag 条件一致 */
    forceBeginDragFromHit() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (!this.opt.isInteractionEnabled() || !this.hitBtn)
                return;
            const maxScroll = this.getMaxScroll();
            if (maxScroll <= 0)
                return;
            if (this.dragging)
                return;
            this.startDrag();
        });
    }
    startDrag() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (this.dragging)
                return;
            const maxScroll = this.getMaxScroll();
            if (maxScroll <= 0)
                return;
            this.dragging = true;
            this.lastMouseY = getMouseY();
        });
    }
    stopDragTimer() {
        if (this.dragTimer === null)
            return;
        if (typeof jass.PauseTimer === "function")
            jass.PauseTimer(this.dragTimer);
        if (typeof jass.DestroyTimer === "function")
            jass.DestroyTimer(this.dragTimer);
        this.dragTimer = null;
    }
    onDragTick() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (!this.dragging)
                return;
            const maxScroll = this.getMaxScroll();
            if (maxScroll <= 0) {
                this.endDrag();
                return;
            }
            const mouseY = getMouseY();
            const dy = mouseY - this.lastMouseY;
            this.lastMouseY = mouseY;
            const travelNorm = getScrollbarThumbTravelNorm(this.trackH(), this.opt.thumbSizeNorm, this.opt.topCompensation, this.opt.bottomCompensation);
            const trackPx = getScrollbarTrackThumbTravelPx(travelNorm);
            let next = this.opt.getScrollOffset() + (dy / trackPx) * maxScroll * this.sensitivity;
            if (next < 0)
                next = 0;
            if (next > maxScroll)
                next = maxScroll;
            this.opt.setScrollOffset(next);
            this.opt.onScrollChanged();
        });
    }
    endDrag() {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (!this.dragging)
                return;
            this.dragging = false;
        });
    }
    /** 根据 scrollOffset / maxScroll 设置 thumb 相对轨道位置 */
    syncThumbVisual(maxScroll) {
        pcall(() => {
            if (typeof jass.GetLocalPlayer !== "function")
                return;
            const lp = jass.GetLocalPlayer();
            if (lp == null)
                return;
            if (this.opt.skipManualThumbSync && this.opt.skipManualThumbSync())
                return;
            if (!this.opt.thumbFrame || this.opt.thumbFrame === 0)
                return;
            if (!this.opt.trackFrame || this.opt.trackFrame === 0)
                return;
            const tf = this.opt.thumbFrame;
            if (typeof japi.DzFrameShow === "function")
                japi.DzFrameShow(tf, true);
            if (typeof japi.DzFrameSetLevel === "function")
                japi.DzFrameSetLevel(tf, 120);
            if (typeof japi.DzFrameSetSize === "function") {
                japi.DzFrameSetSize(tf, this.opt.thumbSizeNorm, this.opt.thumbSizeNorm);
            }
            const safeRange = getScrollbarThumbTravelNorm(this.trackH(), this.opt.thumbSizeNorm, this.opt.topCompensation, this.opt.bottomCompensation);
            const progress = maxScroll <= 0 ? 0 : this.opt.getScrollOffset() / maxScroll;
            const yOffset = (0.5 - progress) * safeRange +
                (this.opt.topCompensation - this.opt.bottomCompensation) * 0.5;
            if (typeof japi.DzFrameClearAllPoints === "function") {
                japi.DzFrameClearAllPoints(tf);
            }
            setFramePointRelative(tf, FramePoint.CENTER, this.opt.trackFrame, FramePoint.CENTER, 0, yOffset);
        });
    }
}
