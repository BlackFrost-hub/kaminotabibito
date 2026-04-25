/**
 * 垂直滚动条轨道（BACKDROP 轨道 + 圆形 thumb）
 * - 仅保留滚轮滑动功能，删除鼠标拖拽
 */

/* eslint-disable @typescript-eslint/no-explicit-any */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { getWindowHeight } from "../../lib/扩展函数/封装函数/04．硬件输入/index";
import { setFramePointRelative, FramePoint } from "./01．UI工具/index";

/** thumb 垂直可移动行程（归一化 UI 高度），与 syncThumb 使用同一公式 */
export function getScrollbarThumbTravelNorm(
  trackHeightNorm: number,
  thumbSizeNorm: number,
  topCompensation: number,
  bottomCompensation: number
): number {
  const yRange = trackHeightNorm - thumbSizeNorm + topCompensation + bottomCompensation;
  return Math.max(0, yRange);
}

/** 与 syncThumb 一致的轨道像素高度（Dz 纵向 0..0.6 对应 client 高度） */
export function getScrollbarTrackThumbTravelPx(travelNorm: number): number {
  const ch = (japi as any).DzGetClientHeight();
  const clientH = typeof ch === "number" && ch > 0 ? ch : getWindowHeight() || 600;
  return Math.max(1, (clientH * travelNorm) / 0.6);
}

export interface VerticalScrollbarTrackOptions {
  /** 轨道 BACKDROP */
  trackFrame: number;
  /** thumb BACKDROP */
  thumbFrame: number;
  /** 列表可视区高度（归一化） */
  listViewHeightNorm: number;
  /** 轨道 BACKDROP 实际高度 */
  trackHeightNorm?: number;
  thumbSizeNorm: number;
  topCompensation: number;
  bottomCompensation: number;
  /** 内容总高度（归一化） */
  getTotalContentHeight(): number;
  getScrollOffset(): number;
  setScrollOffset(value: number): void;
  /** 面板是否可交互 */
  isInteractionEnabled(): boolean;
  /** scrollOffset 变化后刷新 */
  onScrollChanged(): void;
  /** 为 true 时不改 thumb 位置 */
  skipManualThumbSync?(): boolean;
}

/** 封装：仅保留 thumb 位置同步，删除鼠标拖拽 */
export class VerticalScrollbarTrack {
  private readonly opt: VerticalScrollbarTrackOptions;

  constructor(options: VerticalScrollbarTrackOptions) {
    this.opt = options;
  }

  /** 初始化（无命中按钮，无拖拽） */
  attach(): void {
    // 仅初始化，不注册鼠标事件
  }

  destroy(): void {
    // 无需清理
  }

  /** 面板隐藏时调用 */
  cancelDrag(): void {
    // 无拖拽状态需要清理
  }

  getHitButtonFrame(): number | null {
    return null;
  }

  isDragging(): boolean {
    return false;
  }

  private trackH(): number {
    const t = this.opt.trackHeightNorm;
    if (t !== undefined && t > 0) return t;
    return this.opt.listViewHeightNorm;
  }

  /** 根据 scrollOffset / maxScroll 设置 thumb 相对轨道位置 */
  syncThumbVisual(maxScroll: number): void {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null) return;

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
    });
  }
}
