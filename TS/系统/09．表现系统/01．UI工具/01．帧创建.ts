const japi = require("jass.japi") as any;

import { FrameConfig, FrameType, TryCreateFromFdfOptions } from "./00．类型定义";

// ========== 虚拟分区：基础创建 ==========
export function createFrame(config: FrameConfig): number | null {
  const { type, name, parent = 0, template = "template", id = 0 } = config;

  if (type === FrameType.SIMPLEFRAME) return null;

  const frame = japi.DzCreateFrameByTagName(type, name, parent, template, id);
  if (frame == null || frame === 0) return null;

  if (config.visible !== undefined) {
    (pcall as any)(() => japi.DzFrameShow(frame, config.visible));
  }
  if (config.enable === false) {
    (pcall as any)(() => japi.DzFrameSetEnable(frame, false));
  }
  if (config.alpha !== undefined) {
    (pcall as any)(() => japi.DzFrameSetAlpha(frame, config.alpha));
  }
  if (config.level !== undefined) {
    (pcall as any)(() => japi.DzFrameSetLevel(frame, config.level));
  }

  return frame;
}

const __tocLoadedOnce: Record<string, boolean> = {};

// ========== 虚拟分区：初始化 ==========
export function loadTocOnce(
  tocLoadKey: string,
  tocPaths: string[],
  debugPrefix: string = "UI"
): void {
  if (__tocLoadedOnce[tocLoadKey]) return;
  __tocLoadedOnce[tocLoadKey] = true;

  for (const p of tocPaths) {
    const ok = (pcall as any)(() => japi.DzLoadToc(p));
    if (!ok) {
      const pr = (globalThis as any).print;
      pr("[" + debugPrefix + "] DzLoadToc fail: " + p);
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

  let f: number = 0;
  const ok = (pcall as any)(() => {
    f = japi.DzCreateFrame(frameName, parent, 0);
  });
  if (ok && f != null && f !== 0) return f;
  return fallback();
}

