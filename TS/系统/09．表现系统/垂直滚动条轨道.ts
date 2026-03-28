/**
 * 垂直滚动条轨道（BACKDROP 轨道 + 圆形 thumb + 透明 GLUETEXTBUTTON 命中）
 * - 全局左键按下/抬起 + getMouseFocus 判定本轨道（1.27e 下帧 MOUSE_DOWN 常不可靠）
 * - 多实例：模块内只注册一次全局鼠标，分发给所有 VerticalScrollbarTrack
 */

/* eslint-disable @typescript-eslint/no-explicit-any */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { getMouseFocus, getMouseY, getWindowHeight } from "../00．核心系统/硬件函数";
import { createFrame, setFramePointRelative, FrameType, FramePoint } from "./UI工具";

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
  const ch =
    typeof (japi as any).DzGetClientHeight === "function"
      ? (japi as any).DzGetClientHeight()
      : getWindowHeight() || 600;
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

/**
 * 封装：透明命中键 + 全局鼠标拖拽 + thumb 位置同步
 */
export class VerticalScrollbarTrack {
  private readonly opt: VerticalScrollbarTrackOptions;
  private hitBtn: number | null = null;
  private dragging = false;
  private lastMouseY = 0;
  private dragTimer: any = null;
  private readonly dragTick: number;
  private readonly sensitivity: number;

  private static instances: VerticalScrollbarTrack[] = [];
  private static globalDownOk = false;
  private static globalUpOk = false;

  constructor(options: VerticalScrollbarTrackOptions) {
    this.opt = options;
    this.dragTick = options.dragTick ?? 0.03;
    this.sensitivity = options.sensitivity ?? 1;
  }

  /** 创建命中按钮并加入全局分发（同一地图可多实例） */
  attach(): void {
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
    if (typeof (japi as any).DzFrameSetAllPoints === "function") {
      (japi as any).DzFrameSetAllPoints(this.hitBtn, this.opt.thumbFrame);
    }
    if (typeof (japi as any).DzFrameSetLevel === "function") {
      (japi as any).DzFrameSetLevel(this.hitBtn, 121);
    }

    VerticalScrollbarTrack.instances.push(this);
    VerticalScrollbarTrack.ensureGlobalMouseHooks();
  }

  destroy(): void {
    const idx = VerticalScrollbarTrack.instances.indexOf(this);
    if (idx >= 0) VerticalScrollbarTrack.instances.splice(idx, 1);
    this.endDrag();
    this.hitBtn = null;
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

  private tryBeginDrag(): void {
    if (!this.opt.isInteractionEnabled() || !this.hitBtn) return;
    const maxScroll = this.getMaxScroll();
    if (maxScroll <= 0) return;
    if (this.dragging) return;
    const go = () => {
      const focus = getMouseFocus();
      if (this.isFocusOnThisTrack(focus)) this.startDrag();
    };
    go();
    const t = typeof (jass as any).CreateTimer === "function" ? (jass as any).CreateTimer() : null;
    if (!t || typeof (jass as any).TimerStart !== "function") return;
    (jass as any).TimerStart(t, 0.03, false, () => {
      if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(t);
      if (!this.dragging) go();
    });
  }

  private startDrag(): void {
    const maxScroll = this.getMaxScroll();
    if (maxScroll <= 0) return;
    this.dragging = true;
    this.lastMouseY = getMouseY();
    this.stopDragTimer();
    if (typeof (jass as any).CreateTimer !== "function" || typeof (jass as any).TimerStart !== "function") return;
    this.dragTimer = (jass as any).CreateTimer();
    (jass as any).TimerStart(this.dragTimer, this.dragTick, true, () => this.onDragTick());
  }

  private stopDragTimer(): void {
    if (this.dragTimer === null) return;
    if (typeof (jass as any).PauseTimer === "function") (jass as any).PauseTimer(this.dragTimer);
    if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(this.dragTimer);
    this.dragTimer = null;
  }

  private onDragTick(): void {
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
  }

  private endDrag(): void {
    if (!this.dragging) return;
    this.dragging = false;
    this.stopDragTimer();
  }

  /** 供全局抬起调用：仅本实例在拖时收尾 */
  private onGlobalMouseUp(): void {
    this.endDrag();
  }

  /** 根据 scrollOffset / maxScroll 设置 thumb 相对轨道位置 */
  syncThumbVisual(maxScroll: number): void {
    if (this.opt.skipManualThumbSync && this.opt.skipManualThumbSync()) return;
    if (!this.opt.thumbFrame || this.opt.thumbFrame === 0) return;
    if (!this.opt.trackFrame || this.opt.trackFrame === 0) return;

    const tf = this.opt.thumbFrame;
    if (typeof (japi as any).DzFrameShow === "function") (japi as any).DzFrameShow(tf, true);
    if (typeof (japi as any).DzFrameSetLevel === "function") (japi as any).DzFrameSetLevel(tf, 120);
    if (typeof (japi as any).DzFrameSetSize === "function") {
      (japi as any).DzFrameSetSize(tf, this.opt.thumbSizeNorm, this.opt.thumbSizeNorm);
    }

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

    if (typeof (japi as any).DzFrameClearAllPoints === "function") {
      (japi as any).DzFrameClearAllPoints(tf);
    }
    setFramePointRelative(tf, FramePoint.CENTER, this.opt.trackFrame, FramePoint.CENTER, 0, yOffset);
  }

  private static ensureGlobalMouseHooks(): void {
    if (!VerticalScrollbarTrack.globalDownOk) {
      const trig =
        typeof (jass as any).CreateTrigger === "function" ? (jass as any).CreateTrigger() : null;
      if (trig && typeof (japi as any).DzTriggerRegisterMouseEventByCode === "function") {
        (japi as any).DzTriggerRegisterMouseEventByCode(
          trig,
          MOUSE_BTN_LEFT,
          MOUSE_STATUS_PRESS,
          false,
          () => {
            for (const inst of VerticalScrollbarTrack.instances) {
              inst.tryBeginDrag();
            }
          }
        );
        VerticalScrollbarTrack.globalDownOk = true;
      }
    }
    if (!VerticalScrollbarTrack.globalUpOk) {
      const trig2 =
        typeof (jass as any).CreateTrigger === "function" ? (jass as any).CreateTrigger() : null;
      if (trig2 && typeof (japi as any).DzTriggerRegisterMouseEventByCode === "function") {
        (japi as any).DzTriggerRegisterMouseEventByCode(
          trig2,
          MOUSE_BTN_LEFT,
          MOUSE_STATUS_RELEASE,
          false,
          () => {
            for (const inst of VerticalScrollbarTrack.instances) {
              inst.onGlobalMouseUp();
            }
          }
        );
        VerticalScrollbarTrack.globalUpOk = true;
      }
    }
  }
}
