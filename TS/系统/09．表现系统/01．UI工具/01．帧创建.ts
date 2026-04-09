const japi = require("jass.japi") as any;

import { FrameConfig, FrameType, TryCreateFromFdfOptions } from "./00．类型定义";

// ========== 虚拟分区：基础创建 ==========
export function createFrame(config: FrameConfig): number | null {
  const { type, name, parent = 0, template = "template", id = 0 } = config;

  if (typeof japi.DzCreateFrameByTagName !== "function") return null;
  if (type === FrameType.SIMPLEFRAME) return null;

  const frame = japi.DzCreateFrameByTagName(type, name, parent, template, id);
  if (frame == null || frame === 0) return null;

  if (config.visible !== undefined && typeof japi.DzFrameShow === "function") {
    (pcall as any)(() => japi.DzFrameShow(frame, config.visible));
  }
  if (config.enable === false && typeof japi.DzFrameSetEnable === "function") {
    (pcall as any)(() => japi.DzFrameSetEnable(frame, false));
  }
  if (config.alpha !== undefined && typeof japi.DzFrameSetAlpha === "function") {
    (pcall as any)(() => japi.DzFrameSetAlpha(frame, config.alpha));
  }
  if (config.level !== undefined && typeof japi.DzFrameSetLevel === "function") {
    (pcall as any)(() => japi.DzFrameSetLevel(frame, config.level));
  }

  return frame;
}

const __tocLoadedOnce: Record<string, boolean> = {};

// ========== 虚拟分区：TOC加载 ==========
export function loadTocOnce(
  tocLoadKey: string,
  tocPaths: string[],
  debugPrefix: string = "UI"
): void {
  if (__tocLoadedOnce[tocLoadKey]) return;
  __tocLoadedOnce[tocLoadKey] = true;
  if (typeof japi.DzLoadToc !== "function") return;

  for (const p of tocPaths) {
    const ok = (pcall as any)(() => japi.DzLoadToc(p));
    if (!ok) {
      const pr = (globalThis as any).print;
      if (typeof pr === "function") pr("[" + debugPrefix + "] DzLoadToc fail: " + p);
    }
  }
}

export function tryCreateFromFdfSafe(
  frameName: string,
  parent: number,
  fallback: () => number | null,
  opts: TryCreateFromFdfOptions
): number | null {
  loadTocOnce(opts.tocLoadKey, opts.tocPaths, opts.debugPrefix ?? "UI");
  if (typeof japi.DzCreateFrame !== "function") return fallback();

  let f: number = 0;
  const ok = (pcall as any)(() => {
    f = japi.DzCreateFrame(frameName, parent, 0);
  });
  if (ok && f != null && f !== 0) return f;
  return fallback();
}

