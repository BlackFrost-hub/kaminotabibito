const japi = require("jass.japi");
const { debugLog } = require("lib.扩展函数.自定义扩展函数.index");
import { FrameType } from "./00．类型定义";
let __safeFrame = 0;
let __safeVisible = false;
let __safeAlpha = 0;
let __safeLevel = 0;
let __safeTocPath = "";
function __safeShowFramePcallBody() {
    japi.DzFrameShow(__safeFrame, __safeVisible);
}
function __safeSetEnableFalsePcallBody() {
    japi.DzFrameSetEnable(__safeFrame, false);
}
function __safeSetAlphaPcallBody() {
    japi.DzFrameSetAlpha(__safeFrame, __safeAlpha);
}
function __safeSetLevelPcallBody() {
    japi.DzFrameSetPriority(__safeFrame, __safeLevel);
}
function __safeLoadTocPcallBody() {
    japi.DzLoadToc(__safeTocPath);
}
// ========== 虚拟分区：基础创建 ==========
export function createFrame(config) {
    const { type, name, parent = 0, template = "template", id = 0 } = config;
    if (type === FrameType.SIMPLEFRAME)
        return null;
    const frame = japi.DzCreateFrameByTagName(type, name, parent, template, id);
    if (frame == null || frame === 0)
        return null;
    if (config.visible !== undefined) {
        __safeFrame = frame;
        __safeVisible = config.visible;
        pcall(__safeShowFramePcallBody);
    }
    if (config.enable === false) {
        __safeFrame = frame;
        pcall(__safeSetEnableFalsePcallBody);
    }
    if (config.alpha !== undefined) {
        __safeFrame = frame;
        __safeAlpha = config.alpha;
        pcall(__safeSetAlphaPcallBody);
    }
    if (config.level !== undefined) {
        __safeFrame = frame;
        __safeLevel = config.level;
        pcall(__safeSetLevelPcallBody);
    }
    return frame;
}
const __tocLoadedOnce = {};
// ========== 虚拟分区：初始化 ==========
export function loadTocOnce(tocLoadKey, tocPaths, debugPrefix = "UI") {
    if (__tocLoadedOnce[tocLoadKey])
        return;
    __tocLoadedOnce[tocLoadKey] = true;
    for (const p of tocPaths) {
        __safeTocPath = p;
        const ok = pcall(__safeLoadTocPcallBody);
        if (!ok) {
            debugLog(debugPrefix, "DzLoadToc fail:", p);
        }
    }
}
let __fdfSafeFrameName = "";
let __fdfSafeParent = 0;
let __fdfSafeContextId = 0;
let __fdfSafeOutFrame = 0;
function __fdfSafeCreateFramePcallBody() {
    __fdfSafeOutFrame = japi.DzCreateFrame(__fdfSafeFrameName, __fdfSafeParent, __fdfSafeContextId);
}
export function tryCreateFromFdfSafe(frameName, parent, fallback, opts) {
    loadTocOnce(opts.tocLoadKey, opts.tocPaths, opts.debugPrefix ?? "UI");
    __fdfSafeFrameName = frameName;
    __fdfSafeParent = parent;
    __fdfSafeContextId = opts.contextId ?? 0;
    const ok = pcall(__fdfSafeCreateFramePcallBody);
    const f = __fdfSafeOutFrame;
    if (ok && f != null && f !== 0)
        return f;
    return fallback();
}
