import { initMainStoryNPCsWithDelay } from "./01．主线NPC";
/**
 * 主线 NPC 创建入口
 * 对应旧 JASS InitTrig_____________NPC4_0S 的初始化行为。
 */
export function initMainStoryNpcEntry() {
    initMainStoryNPCsWithDelay(1.0);
}
// 兼容外部直接调用 init()
export function init() {
    initMainStoryNpcEntry();
}
export default initMainStoryNpcEntry;
