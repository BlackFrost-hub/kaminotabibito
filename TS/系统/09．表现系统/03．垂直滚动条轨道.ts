/**
 * 垂直滚动条轨道（BACKDROP 轨道 + 圆形 thumb + 透明 GLUETEXTBUTTON 命中）
 * - 全局左键按下/抬起 + getMouseFocus 判定本轨道（1.27e 下帧 MOUSE_DOWN 常不可靠）
 * - 多实例：模块内只注册一次全局鼠标，分发给所有 VerticalScrollbarTrack
 */

/* eslint-disable @typescript-eslint/no-explicit-any */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { getMouseFocus, getMouseY, getWindowHeight, frameSetScriptByCode } from "../../lib/扩展函数/封装函数/04．硬件输入/index";
import { createFrame, setFramePointRelative, FrameType, FramePoint, EventType } from "./01．UI工具/index";

/** thumb 竖直可移动行程（归一化 UI 高度），与 syncThumb 使用同一公式 */
export function getScrollbarThumbTravelNorm(
  trackHeightNorm: number,
  thumbSizeNorm: number,
  topCompensation: number,
  bottomCompensation: number
): number {
  const yRange = trackHeightNorm - thumbSizeNorm + topCompensation + bottomCompensation;
  return Math.max(0, yRange);
}

/** 与 syncThumb 一致的轨道像素高度（Dz 竖向 0..0.6 对应 client 高度） */
export function getScrollbarTrackThumbTravelPx(travelNorm: number): number {
  const ch = (japi as any).DzGetClientHeight();
  return Math.max(1, (ch * travelNorm) / 0.6);
}

/** 与 war3map.j DzTriggerRegisterMouseEventTrg 一致：左键按下 (1,1)、释放 (1,0) */
const MOUSE_BTN_LEFT = 1;
const MOUSE_STATUS_PRESS = 1;
const MOUSE_STATUS_RELEASE = 0;

export interface VerticalScrollbarTrackOptions {
  /** 轨道 BACKDROP */
  trackFrame: number;
  /** thumb BACKDROP（子帧叠透明按钮） */
  thumbFrame: number;
  /** 透明命中按钮名称（多轨道时请保证全局唯一） */
  hitButtonName: string;
  /** 列表可视区高度（归一化），用于 maxScroll = contentH - listViewH */
  listViewHeightNorm: number;
  /** 轨道 BACKDROP 实际高度；未传时与 listViewHeightNorm 相同（锚点拉出高度必须与之一致，否则滑块到不了顶/底） */
  trackHeightNorm?: number;
  thumbSizeNorm: number;
  topCompensation: number;
  bottomCompensation: number;
  /** 轮询间隔（秒） */
  dragTick?: number;
  sensitivity?: number;
  /** 内容总高度（归一化） */
  getTotalContentHeight(): number;
  getScrollOffset(): number;
  setScrollOffset(value: number): void;
  /** 面板是否可交互（如可见） */
  isInteractionEnabled(): boolean;
  /** scrollOffset 变化后刷新（列表 + 可选 sync 原生 Slider） */
  onScrollChanged(): void;
  /** 为 true 时不改 thumb 位置（例如已用原生 SCROLLBAR 管 value） */
  skipManualThumbSync?(): boolean;
}

/** 封装：透明命中键 + 全局鼠标拖拽 + thumb 位置同步 */
export class VerticalScrollbarTrack {
  private readonly opt: VerticalScrollbarTrackOptions;
  private hitBtn: number | null = null;
  private dragging = false;
  private lastMouseY = 0;
  private dragTimer: any = null;
  private readonly dragTick: number;
  private readonly sensitivity: number;
  private mouseDownTrigger: any = null;
  private mouseUpTrigger: any = null;

  constructor(options: VerticalScrollbarTrackOptions) {
    this.opt = options;
    this.dragTick = options.dragTick ?? 0.03;
    this.sensitivity = options.sensitivity ?? 1;
  }

  /** 创建命中按钮并加入全局分发（同一地图可多实例） */
  attach(): void {
    (pcall as any)(() => {
      const lp = jass.GetLocalPlayer();
      if (lp != null) {
        if (!this.opt.thumbFrame || this.opt.thumbFrame === 0) return;
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
        (japi as any).DzFrameSetAllPoints(this.hitBtn, this.opt.thumbFrame);
        (japi as any).DzFrameSetLevel(this.hitBtn, 121);

        /** 帧上直接按下：避免仅依赖全局 MOUSE_DOWN + DzGetMouseFocus 时 focus 未落到透明 GLUETEXTBUTTON 导致无法 startDrag */
        frameSetScriptByCode(this.hitBtn, EventType.MOUSE_DOWN, () => this.forceBeginDragFromHit(), false);
        frameSetScriptByCode(this.hitBtn, EventType.MOUSE_CLICK, () => this.forceBeginDragFromHit(), false);
        frameSetScriptByCode(this.hitBtn, EventType.MOUSE_UP, () => this.endDrag(), false);

        this.mouseDownTrigger = jass.CreateTrigger();
        (japi as any).DzTriggerRegisterMouseEventByCode(this.mouseDownTrigger, MOUSE_BTN_LEFT, MOUSE_STATUS_PRESS, false, () => {
          (pcall as any)(() => {
            const lp2 = jass.GetLocalPlayer();
            if (lp2 == null) return;
            if (!this.opt.isInteractionEnabled() || !this.hitBtn) return;
            const maxScroll = this.getMaxScroll();
            if (maxScroll <= 0) return;
            if (this.dragging) return;
            const focus = getMouseFocus();
            if (this.isFocusOnThisTrack(focus)) this.startDrag();
          });
        });

        this.mouseUpTrigger = jass.CreateTrigger();
        (japi as any).DzTriggerRegisterMouseEventByCode(this.mouseUpTrigger, MOUSE_BTN_LEFT, MOUSE_STATUS_RELEASE, false, () => {
          (pcall as any)(() => {
            const lp2 = jass.GetLocalPlayer();
            if (lp2 == null) return;
            this.endDrag();
          });
        });
      }
    });

    (pcall as any)(() => {
      this.stopDragTimer();
      this.dragTimer = (jass as any).CreateTimer();
      (jass as any).TimerStart(this.dragTimer, this.dragTick, true, () => this.onDragTick());
    });
  }

  destroy(): void {
    (pcall as any)(() => {
      const lp = jass.GetLocalPlayer();
      if (lp != null) {
        if (this.mouseDownTrigger) {
          jass.DestroyTrigger(this.mouseDownTrigger);
        }
        if (this.mouseUpTrigger) {
          jass.DestroyTrigger(this.mouseUpTrigger);
        }
      }
    });
    this.endDrag();
    (pcall as any)(() => {
      this.stopDragTimer();
    });
    this.hitBtn = null;
    this.mouseDownTrigger = null;
    this.mouseUpTrigger = null;
  }

  /** 面板隐藏时调用，避免隐藏后仍保持拖拽状态 */
  cancelDrag(): void {
    this.endDrag();
  }

  getHitButtonFrame(): number | null {
    return this.hitBtn;
  }

  isDragging(): boolean {
    return this.dragging;
  }

  private isFocusOnThisTrack(focus: number): boolean {
    if (!focus || focus === 0) return false;
    if (this.hitBtn && focus === this.hitBtn) return true;
    if (focus === this.opt.thumbFrame) return true;
    if (focus === this.opt.trackFrame) return true;
    return false;
  }

  private trackH(): number {
    const t = this.opt.trackHeightNorm;
    if (t !== undefined && t > 0) return t;
    return this.opt.listViewHeightNorm;
  }

  private getMaxScroll(): number {
    const h = this.opt.getTotalContentHeight();
    const lv = this.opt.listViewHeightNorm;
    return Math.max(0, h - lv);
  }

  /** 透明命中键回调：不依赖 getMouseFocus，与 tryBeginDrag 条件一致 */
  private forceBeginDragFromHit(): void {
    (pcall as any)(() => {
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.opt.isInteractionEnabled() || !this.hitBtn) return;
      const maxScroll = this.getMaxScroll();
      if (maxScroll <= 0) return;
      if (this.dragging) return;
      this.startDrag();
    });
  }

  private startDrag(): void {
    (pcall as any)(() => {
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (this.dragging) return;
      const maxScroll = this.getMaxScroll();
      if (maxScroll <= 0) return;
      this.dragging = true;
      this.lastMouseY = getMouseY();
    });
  }

  private stopDragTimer(): void {
    if (this.dragTimer === null) return;
    (jass as any).PauseTimer(this.dragTimer);
    (jass as any).DestroyTimer(this.dragTimer);
    this.dragTimer = null;
  }

  private onDragTick(): void {
    (pcall as any)(() => {
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.dragging) return;
      const maxScroll = this.getMaxScroll();
      if (maxScroll <= 0) {
        this.endDrag();
        return;
      }
      const mouseY = getMouseY();
      const dy = mouseY - this.lastMouseY;
      this.lastMouseY = mouseY;
      const travelNorm = getScrollbarThumbTravelNorm(
        this.trackH(),
        this.opt.thumbSizeNorm,
        this.opt.topCompensation,
        this.opt.bottomCompensation
      );
      const trackPx = getScrollbarTrackThumbTravelPx(travelNorm);
      let next = this.opt.getScrollOffset() + (dy / trackPx) * maxScroll * this.sensitivity;
      if (next < 0) next = 0;
      if (next > maxScroll) next = maxScroll;
      this.opt.setScrollOffset(next);
      this.opt.onScrollChanged();
    });
  }

  private endDrag(): void {
    (pcall as any)(() => {
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (!this.dragging) return;
      this.dragging = false;
    });
  }

  /** 根据 scrollOffset / maxScroll 设置 thumb 相对轨道位置 */
  syncThumbVisual(maxScroll: number): void {
    (pcall as any)(() => {
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

      if (this.opt.skipManualThumbSync && this.opt.skipManualThumbSync()) return;
      if (!this.opt.thumbFrame || this.opt.thumbFrame === 0) return;
      if (!this.opt.trackFrame || this.opt.trackFrame === 0) return;

      const tf = this.opt.thumbFrame;
      (japi as any).DzFrameShow(tf, true);
      (japi as any).DzFrameSetLevel(tf, 120);
      (japi as any).DzFrameSetSize(tf, this.opt.thumbSizeNorm, this.opt.thumbSizeNorm);

      const safeRange = getScrollbarThumbTravelNorm(
        this.trackH(),
        this.opt.thumbSizeNorm,
        this.opt.topCompensation,
        this.opt.bottomCompensation
      );
      const progress = maxScroll <= 0 ? 0 : this.opt.getScrollOffset() / maxScroll;
      const yOffset =
        (0.5 - progress) * safeRange +
        (this.opt.topCompensation - this.opt.bottomCompensation) * 0.5;

      (japi as any).DzFrameClearAllPoints(tf);
      setFramePointRelative(tf, FramePoint.CENTER, this.opt.trackFrame, FramePoint.CENTER, 0, yOffset);
    });
  }
}
