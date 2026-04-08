/**
 * UI工具 - 帧创建
 * Frame创建、TOC加载
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import {
  FrameConfig,
  FrameType,
  TryCreateFromFdfOptions,
} from "./00．类型定义";

/**
 * 创建Frame
 */
export function createFrame(config: FrameConfig): number | null {
  const { type, name, parent = 0, template = "template", id = 0 } = config;

  if (typeof japi.DzCreateFrameByTagName !== "function") {
    return null;
  }

  // 1.27e 下部分类型（尤其 SIMPLEFRAME）用 DzCreateFrameByTagName 易触发引擎级崩溃
  // 这些类型应优先走 DzCreateFrame(FDF) 路径；此处兜底直接返回 null，交给上层 fallback 策略。
  if (type === FrameType.SIMPLEFRAME) {
    return null;
  }

  const frame = japi.DzCreateFrameByTagName(type, name, parent, template, id);
  // 注意：Lua 里 0 也是 truthy，不能用 `if (!frame)` 这种方式防守
  if (frame == null || frame === 0) return null;

  if (config.visible !== undefined && typeof japi.DzFrameShow === "function") {
    (pcall as any)(() => {
      japi.DzFrameShow(frame, config.visible);
    });
  }

  // 1.27e 下 DzFrameSetEnable 对部分帧类型会直接引擎级 crash。
  // 按需策略：只在明确需要"禁用"时调用；enable=true 依赖默认启用状态。
  if (config.enable === false && typeof japi.DzFrameSetEnable === "function") {
    (pcall as any)(() => {
      japi.DzFrameSetEnable(frame, false);
    });
  }

  if (config.alpha !== undefined && typeof japi.DzFrameSetAlpha === "function") {
    (pcall as any)(() => {
      japi.DzFrameSetAlpha(frame, config.alpha);
    });
  }

  if (config.level !== undefined && typeof japi.DzFrameSetLevel === "function") {
    (pcall as any)(() => {
      japi.DzFrameSetLevel(frame, config.level);
    });
  }

  return frame;
}

// ─────────────────────────────────────────────────────────────────────────────
// TOC 加载
// ─────────────────────────────────────────────────────────────────────────────

/**
 * 安全加载 TOC（只加载一次）：
 * - 允许同时传多个可能路径（你这套项目里常见：`UI\\xxx.toc` 与 `war3mapImported\\UI\\xxx.toc`）
 * - 用 `pcall` 包住 Lua 层异常，避免初始化流程被 Lua 报错打断
 *
 * 注意：如果客户端在绘制/交互阶段对某些 FDF 帧直接"引擎级崩溃"，`pcall` 也拦不住；
 * 所以仍建议"分阶段/白名单"逐步替换控件类型。
 */
const __tocLoadedOnce: Record<string, boolean> = {};

export function loadTocOnce(
  tocLoadKey: string,
  tocPaths: string[],
  debugPrefix: string = "UI"
): void {
  if (__tocLoadedOnce[tocLoadKey]) return;
  __tocLoadedOnce[tocLoadKey] = true;

  if (typeof japi.DzLoadToc !== "function") return;

  for (const p of tocPaths) {
    const ok = (pcall as any)(() => {
      japi.DzLoadToc(p);
    });
    if (!ok) {
      const pr = (globalThis as any).print;
      if (typeof pr === "function") pr("[" + debugPrefix + "] DzLoadToc fail: " + p);
    }
  }
}

/**
 * `DzLoadToc` + `DzCreateFrame` try/fallback 的通用封装。
 *
 * 用法示例（放在某个 UI 模块里）：
 * ```ts
 * const f = tryCreateFromFdfSafe("TaskEntryIcon", parent, () =>
 *   createFrame({ type: FrameType.BACKDROP, name: "TaskEntryIcon", parent, template: "template", visible: true })
 * , {
 *   tocLoadKey: "TaskUI",
 *   tocPaths: ["UI\\TaskUI.toc", "war3mapImported\\UI\\TaskUI.toc"],
 *   debugPrefix: "TaskUI"
 * });
 * ```
 *
 * @returns 失败时返回 fallback 的结果（允许 fallback 返回 null）
 */
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
