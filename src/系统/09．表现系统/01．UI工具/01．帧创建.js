const japi = require("jass.japi");
import { FrameType } from "./00．类型定义";
// ========== 虚拟分区：基础创建 ==========
export function createFrame(config) {
    const { type, name, parent = 0, template = "template", id = 0 } = config;
    if (typeof japi.DzCreateFrameByTagName !== "function")
        return null;
    if (type === FrameType.SIMPLEFRAME)
        return null;
    const frame = japi.DzCreateFrameByTagName(type, name, parent, template, id);
    if (frame == null || frame === 0)
        return null;
    if (config.visible !== undefined && typeof japi.DzFrameShow === "function") {
        pcall(() => japi.DzFrameShow(frame, config.visible));
    }
    if (config.enable === false && typeof japi.DzFrameSetEnable === "function") {
        pcall(() => japi.DzFrameSetEnable(frame, false));
    }
    if (config.alpha !== undefined && typeof japi.DzFrameSetAlpha === "function") {
        pcall(() => japi.DzFrameSetAlpha(frame, config.alpha));
    }
    if (config.level !== undefined && typeof japi.DzFrameSetLevel === "function") {
        pcall(() => japi.DzFrameSetLevel(frame, config.level));
    }
    return frame;
}
const __tocLoadedOnce = {};
// ========== 虚拟分区：初始化 ==========
export function loadTocOnce(tocLoadKey, tocPaths, debugPrefix = "UI") {
    if (__tocLoadedOnce[tocLoadKey])
        return;
    __tocLoadedOnce[tocLoadKey] = true;
    if (typeof japi.DzLoadToc !== "function")
        return;
    for (const p of tocPaths) {
        const ok = pcall(() => japi.DzLoadToc(p));
        if (!ok) {
            const pr = globalThis.print;
            if (typeof pr === "function")
                pr("[" + debugPrefix + "] DzLoadToc fail: " + p);
        }
    }
}
export function tryCreateFromFdfSafe(frameName, parent, fallback, opts) {
    loadTocOnce(opts.tocLoadKey, opts.tocPaths, opts.debugPrefix ?? "UI");
    if (typeof japi.DzCreateFrame !== "function")
        return fallback();
    let f = 0;
    const ok = pcall(() => {
        f = japi.DzCreateFrame(frameName, parent, 0);
    });
    if (ok && f != null && f !== 0)
        return f;
    return fallback();
}
