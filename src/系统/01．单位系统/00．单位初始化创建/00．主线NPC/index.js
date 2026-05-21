/**
 * 主线NPC - 统一导出和初始化入口
 */
// ========== 子模块导出 ==========
export * from "./01．主线NPC";
/** 主线NPC总开关：默认关闭，便于临时禁用整套创建流程 */
export const ENABLE_MAIN_STORY_NPC = false;
// ========== 初始化 ==========
const { initMainStoryNPCsWithDelay } = require("系统.01．单位系统.00．单位初始化创建.00．主线NPC.01．主线NPC");
/**
 * 初始化主线NPC
 */
export function init() {
    if (!ENABLE_MAIN_STORY_NPC)
        return;
    if (typeof initMainStoryNPCsWithDelay === "function") {
        initMainStoryNPCsWithDelay(1.0);
    }
}
// 兼容旧入口
export function initMainStoryNpcEntry() {
    if (!ENABLE_MAIN_STORY_NPC)
        return;
    init();
}
